return require("telescope").register_extension({
	exports = {
		pydoc = require("pydoc-nvim.telescope").pydoc,
		grep = require("pydoc-nvim.telescope").pydoc_grep,
	},
})
