OPT MODULE

-> Base class for buffers

EXPORT CONST BUF_EMPTY=-1

EXPORT OBJECT buffer
  buf
ENDOBJECT

PROC get_iterator() OF buffer IS EMPTY

-> may return BUF_EMPTY if size unavailable
PROC get_size() OF buffer IS EMPTY

-> also may return BUF_EMPTY if unavailable
PROC get_capacity() OF buffer IS EMPTY

PROC clear() OF buffer IS EMPTY

PROC append(item) OF buffer IS EMPTY