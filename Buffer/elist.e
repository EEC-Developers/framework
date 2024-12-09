OPT MODULE

MODULE 'Iterator/iterator','Iterator/elist','Buffer/bufferBase'

EXPORT OBJECT elist_buffer OF buffer
ENDOBJECT

-> Constructor
PROC init(size) OF elist_buffer
  DEF ret

  self.buf:=String(size)
  IF ret=NIL THEN Raise('MEM')
ENDPROC

PROC clear() OF elist_buffer IS SetList(self.buf,0)

PROC get_iterator() OF elist_buffer
  DEF iter:PTR TO elist_iterator

  NEW iter.init(self.buf)
ENDPROC iter

PROC get_size() OF elist_buffer IS ListLen(self.buf)

PROC append(item) OF elist_buffer IS ListAdd(self.buf,item)

PROC get_capacity() OF elist_buffer IS BUF_EMPTY
