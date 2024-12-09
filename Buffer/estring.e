OPT MODULE

MODULE 'Iterator/iterator','Iterator/estring','Buffer/bufferBase'

EXPORT OBJECT estring_buffer OF buffer
ENDOBJECT

-> Constructor
PROC init(size) OF estring_buffer
  DEF ret

  self.buf:=String(size)
  IF ret=NIL THEN Raise('MEM')
ENDPROC

PROC clear() OF estring_buffer IS SetStr(self.buf,0)

PROC get_iterator() OF estring_buffer
  DEF iter:PTR TO estring_iterator

  NEW iter.init(self.buf)
ENDPROC iter

PROC get_size() OF estring_buffer IS EstrLen(self.buf)

PROC append(str) OF estring_buffer IS StrAdd(self.buf,str)

PROC get_capacity OF estring_buffer IS StrMax(self.buf)
