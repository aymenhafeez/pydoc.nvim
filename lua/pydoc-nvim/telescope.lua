local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_set = require("telescope.actions.set")
local make_entry = require("telescope.make_entry")

local M = {}

-- get current Python version from pydoc.nvim
local function get_pydoc()
	local present, pydoc = pcall(require, "pydoc-nvim")
	if not present then
		vim.notify("pydoc.nvim not found. Please install RazorBest/pydoc.nvim", vim.log.levels.ERROR)
		return nil
	end

	if not pydoc.current_version then
		vim.notify("pydoc.nvim not initialised. Please call require('pydoc-nvim').setup()", vim.log.levels.ERROR)
		return nil
	end

	return pydoc
end

-- find tags file for specific version
local function find_tags_file(doc_path)
	local tags_file = doc_path .. "/tags-py"
	if vim.fn.filereadable(tags_file) == 1 then
		return tags_file
	end
	return nil
end

-- ensure tags file exists, generate if needed
local function ensure_tags_exist(doc_path)
	local tags_file = find_tags_file(doc_path)
	if not tags_file then
		-- local versioned_doc_path = doc_path .. "/doc_py" .. version
		vim.notify("Generating tags for Python Documentation...", vim.log.levels.INFO)
		vim.cmd("helptags " .. vim.fn.fnameescape(doc_path))
	end
end

-- read and parse Python help tags
local function get_python_help_tags(doc_path)
	local tags_file = find_tags_file(doc_path)
	if not tags_file then
		return nil, "Failed to find or generate tags file for Python"
	end

	local tags = {}
	local file = io.open(tags_file, "r")
	if not file then
		return nil, "Could not open tags file: " .. tags_file
	end

	-- tab character
	local delimiter = string.char(9)
	for line in file:lines() do
		-- skip comment lines (tags file metadata)
		if not line:match("^!_TAG_") then
			-- parse: tag_name<TAB>filename<TAB>search_pattern
			local fields = vim.split(line, delimiter, { trimempty = true })
			if #fields >= 3 then
				local tag_name = fields[1]
				local filename = fields[2]
				local cmd = fields[3]

				-- filter for .pyx files
				if filename:match("%.pyx$") then
					local full_filename = doc_path .. "/" .. filename
					table.insert(tags, {
						name = tag_name,
						filename = full_filename,
						cmd = cmd,
					})
				end
			end
		end
	end
	file:close()
	return tags, nil
end

local function setup_pydoc()
	local pydoc = get_pydoc()
	if not pydoc then
		return nil
	end

	local version = pydoc.current_version
	local doc_path = pydoc.python_docs[version]

	if not doc_path then
		vim.notify("Documentation path not found for Python version " .. version, vim.log.levels.ERROR)
		return nil
	end

	ensure_tags_exist(doc_path)

	local tags, err = get_python_help_tags(doc_path)
	if not tags then
		vim.notify(err or "Failed to load Python help tags", vim.log.levels.ERROR)
		return nil
	end

	if #tags == 0 then
		vim.notify("No Python help tags found for Python version " .. version, vim.log.levels.WARN)
		return nil
	end

	return {
		version = version,
		tags = tags,
		doc_path = doc_path,
	}
end

M.pydoc = function(opts)
	opts = opts or {}

	local setup = setup_pydoc()
	if not setup then
		return
	end

	pickers
		.new(opts, {
			prompt_title = "Python Documentation (v" .. setup.version .. ")",
			finder = finders.new_table({
				results = setup.tags,
				entry_maker = function(entry)
					return make_entry.set_default_entry_mt({
						value = entry.name,
						display = entry.name,
						ordinal = entry.name,
						filename = entry.filename,
						cmd = entry.cmd,
					}, opts)
				end,
			}),

			sorter = conf.generic_sorter(opts),
			previewer = conf.file_previewer(opts),

			attach_mappings = function(prompt_bufnr)
				---@diagnostic disable-next-line: undefined-field
				action_set.select:replace(function(_)
					local selection = action_state.get_selected_entry()
					if not selection then
						vim.notify("No selection", vim.log.levels.WARN)
						return
					end
					actions.close(prompt_bufnr)
					vim.cmd("help " .. selection.value)
				end)
				return true
			end,
		})
		:find()
end

M.pydoc_grep = function(opts)
	opts = opts or {}

	local setup = setup_pydoc()
	if not setup then
		return
	end

	local file_paths = {}
	local seen = {}
	for _, tag in ipairs(setup.tags) do
		if not seen[tag.filename] then
			table.insert(file_paths, tag.filename)
			seen[tag.filename] = true
		end
	end

	pickers
		.new(opts, {
			prompt_title = "Grep Python Documentation (v" .. setup.version .. ")",
			finder = finders.new_async_job({
				command_generator = function(prompt)
					if not prompt or prompt == "" then
						return nil
					end

					local args = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"-e",
						prompt,
					}

					-- add .pyx file paths
					for _, path in ipairs(file_paths) do
						table.insert(args, path)
					end

					return args
				end,

				entry_maker = function(entry)
					local default_entry = make_entry.gen_from_vimgrep(opts)(entry)
					if default_entry then
						local filename = default_entry.filename:match("([^/]+)$")
						default_entry.display = function(e)
							return string.format("%s:%s:%s: %s", filename, e.lnum, e.col, e.text)
						end
					end
					return default_entry
				end,
			}),

			sorter = conf.generic_sorter(opts),
			previewer = conf.grep_previewer(opts),

			attach_mappings = function(prompt_bufnr)
				---@diagnostic disable-next-line: undefined-field
				action_set.select:replace(function(_)
					local selection = action_state.get_selected_entry()
					if not selection then
						vim.notify("No selection", vim.log.levels.WARN)
						return
					end
					actions.close(prompt_bufnr)

					-- get filename from full path
					local filename = selection.filename
					local lnum = selection.lnum or 1

					-- get just the .pyx filename
					local help_file = filename:match("([^/]+)$")

					vim.cmd("help " .. help_file)
					vim.api.nvim_win_set_cursor(0, { lnum, 0 })
				end)
				return true
			end,
		})
		:find()
end

return M
