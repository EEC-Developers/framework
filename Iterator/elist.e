OPT MODULE

-> a bidirectional iterator for E-Lists

MODULE 'Iterator/bidirectional','Iterator/iterator'

CONST UNINITIALIZED=-1

EXPORT OBJECT elist_iterator OF bidirectional
  cursor:LONG
  me:PTR TO LONG
  len:LONG
ENDOBJECT

-> Constructor
PROC init(the_list) OF elist_iterator
  self.me:=the_list
  self.len:=ListLen(the_list)
  self.cursor:=UNINITIALIZED
ENDPROC

PROC next() OF elist_iterator
  IF self.cursor:=UNINITIALIZED
    self.cursor:=0
    RETURN TRUE
  ENDIF
  self.cursor++
  IF self.cursor<self.len THEN RETURN TRUE
ENDPROC FALSE

PROC prev() OF elist_iterator
  IF self.cursor:=UNINITIALIZED
    self.cursor:=self.len
    RETURN TRUE
  ENDIF
  self.cursor--
  IF self.cursor>=0 THEN RETURN TRUE
ENDPROC FALSE

PROC get_current_item() OF elist_iterator
ENDPROC ListItem(self.me,self.cursor)
