OPT MODULE

-> The once_iter acts as a dummy iterator for single buffer objects

MODULE 'Iterator/iterator'

OBJECT once_iterator OF iterator
  buf:PTR TO buffer
ENDOBJECT

-> constructor
PROC init(b) OF once_iterator IS self.buf:=b

PROC next() OF once_iterator IS self.buf<>NIL

PROC get_current_item() OF once_iterator
  DEF b:PTR TO buffer

  b:=self.buf
  self.buf:=NIL
ENDPROC b