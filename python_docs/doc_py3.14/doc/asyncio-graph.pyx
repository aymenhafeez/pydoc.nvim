Python 3.14.2
*asyncio-graph.pyx*                           Last change: 2025 Dec 20

Call Graph Introspection
************************

**Source code:** Lib/asyncio/graph.py

======================================================================

asyncio has powerful runtime call graph introspection utilities to
trace the entire call graph of a running _coroutine_ or _task_, or a
suspended _future_.  These utilities and the underlying machinery can
be used from within a Python program or by external profilers and
debuggers.

Added in version 3.14.

asyncio.print_call_graph(future=None, /, *, file=None, depth=1, limit=None)

   Print the async call graph for the current task or the provided
   "Task" or "Future".

   This function prints entries starting from the top frame and going
   down towards the invocation point.

   The function receives an optional _future_ argument. If not passed,
   the current running task will be used.

   If the function is called on _the current task_, the optional
   keyword-only _depth_ argument can be used to skip the specified
   number of frames from top of the stack.

   If the optional keyword-only _limit_ argument is provided, each
   call stack in the resulting graph is truncated to include at most
   "abs(limit)" entries. If _limit_ is positive, the entries left are
   the closest to the invocation point. If _limit_ is negative, the
   topmost entries are left. If _limit_ is omitted or "None", all
   entries are present. If _limit_ is "0", the call stack is not
   printed at all, only “awaited by” information is printed.

   If _file_ is omitted or "None", the function will print to
   "sys.stdout".

   **Example:**

   The following Python code:
>
      import asyncio

      async def test():
          asyncio.print_call_graph()

      async def main():
          async with asyncio.TaskGroup() as g:
              g.create_task(test(), name='test')

      asyncio.run(main())
<
   will print:
>
      * Task(name='test', id=0x1039f0fe0)
      + Call stack:
      |   File 't2.py', line 4, in async test()
      + Awaited by:
         * Task(name='Task-1', id=0x103a5e060)
            + Call stack:
            |   File 'taskgroups.py', line 107, in async TaskGroup.__aexit__()
            |   File 't2.py', line 7, in async main()
<
asyncio.format_call_graph(future=None, /, *, depth=1, limit=None)

   Like "print_call_graph()", but returns a string. If _future_ is
   "None" and there’s no current task, the function returns an empty
   string.

asyncio.capture_call_graph(future=None, /, *, depth=1, limit=None)

   Capture the async call graph for the current task or the provided
   "Task" or "Future".

   The function receives an optional _future_ argument. If not passed,
   the current running task will be used. If there’s no current task,
   the function returns "None".

   If the function is called on _the current task_, the optional
   keyword-only _depth_ argument can be used to skip the specified
   number of frames from top of the stack.

   Returns a "FutureCallGraph" data class object:

   * "FutureCallGraph(future, call_stack, awaited_by)"

        Where _future_ is a reference to a "Future" or a "Task" (or
        their subclasses.)

        "call_stack" is a tuple of "FrameCallGraphEntry" objects.

        "awaited_by" is a tuple of "FutureCallGraph" objects.

   * "FrameCallGraphEntry(frame)"

        Where _frame_ is a frame object of a regular Python function
        in the call stack.


Low level utility functions
===========================

To introspect an async call graph asyncio requires cooperation from
control flow structures, such as "shield()" or "TaskGroup". Any time
an intermediate "Future" object with low-level APIs like
"Future.add_done_callback()" is involved, the following two functions
should be used to inform asyncio about how exactly such intermediate
future objects are connected with the tasks they wrap or control.

asyncio.future_add_to_awaited_by(future, waiter, /)

   Record that _future_ is awaited on by _waiter_.

   Both _future_ and _waiter_ must be instances of "Future" or "Task"
   or their subclasses, otherwise the call would have no effect.

   A call to "future_add_to_awaited_by()" must be followed by an
   eventual call to the "future_discard_from_awaited_by()" function
   with the same arguments.

asyncio.future_discard_from_awaited_by(future, waiter, /)

   Record that _future_ is no longer awaited on by _waiter_.

   Both _future_ and _waiter_ must be instances of "Future" or "Task"
   or their subclasses, otherwise the call would have no effect.

vim:tw=78:ts=8:ft=help:norl: