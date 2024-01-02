OPT MODULE

-> a bidirectional iterator for E-Strings

MODULE 'Iterator/bidirectional','Iterator/iterator'

CONST STR_UNINITIALIZED=-1

EXPORT OBJECT estring_iterator OF bidirectional
  cursor:LONG
  me:PTR TO CHAR
  len:LONG
ENDOBJECT

-> Constructor
PROC init(the_string) OF estring_iterator
  self.me:=the_string
  self.len:=EstrLen(the_string)
  self.cursor:=STR_UNINITIALIZED
ENDPROC

PROC next() OF estring_iterator
  IF self.cursor:=STR_UNINITIALIZED
    self.cursor:=0
    RETURN TRUE
  ENDIF
  self.cursor+=1
  IF self.cursor<self.len THEN RETURN TRUE
ENDPROC FALSE

PROC prev() OF estring_iterator
  IF self.cursor:=STR_UNINITIALIZED
    self.cursor:=self.len
    RETURN TRUE
  ENDIF
  self.cursor-=1
  IF self.cursor>=0 THEN RETURN TRUE
ENDPROC FALSE

PROC get_current_item() OF estring_iterator
ENDPROC self.me[self.cursor]
