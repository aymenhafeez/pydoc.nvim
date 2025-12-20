Python 3.8.20
*dummy_threading.pyx*                         Last change: 2025 Dec 20

"dummy_threading" — Drop-in replacement for the "threading" module
******************************************************************

**Source code:** Lib/dummy_threading.py

Deprecated since version 3.7: Python now always has threading enabled.
Please use "threading" instead.

======================================================================

This module provides a duplicate interface to the "threading" module.
It was meant to be imported when the "_thread" module was not provided
on a platform.

Be careful to not use this module where deadlock might occur from a
thread being created that blocks waiting for another thread to be
created.  This often occurs with blocking I/O.

vim:tw=78:ts=8:ft=help:norl: