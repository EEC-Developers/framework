-> List Base Class

OPT MODULE

MODULE 'Iterator/iterator'

-> lists items must inherit from list_node
EXPORT OBJECT list_node
ENDOBJECT

-> getter
PROC get_next() OF list_node IS EMPTY

EXPORT OBJECT list_header
ENDOBJECT

-> getter
PROC get_first() OF list_header IS EMPTY

-> abstract methods
PROC insert(node:PTR TO list_node) OF list_header IS EMPTY

PROC remove_first() OF list_header IS EMPTY

-> iterator definition
EXPORT OBJECT list_iterator OF iterator
  head:PTR TO list_header
  iter:PTR TO list_node
  is_new:WORD
ENDOBJECT

-> getters and setters
PROC get_header() OF list_iterator IS self.head

PROC get_is_new() OF list_iterator IS self.is_new

PROC set_is_new(val) OF list_iterator
  self.is_new:=val
ENDPROC

PROC get_iter() OF list_iterator IS self.iter

PROC set_iter(val:PTR TO list_node) OF list_iterator
  self.iter:=val
ENDPROC

PROC get_current_item() OF list_iterator IS self.iter

PROC init(head:PTR TO list_header) OF list_iterator
  self.is_new:=TRUE
  self.head:=head
  self.iter:=NIL
ENDPROC

PROC next() OF list_iterator
  DEF scratch:PTR TO list_header,scratch2:PTR TO list_node
  IF self.get_is_new()
    self.set_is_new(FALSE)
    scratch:=self.get_header()
    self.set_iter(scratch.get_first())
  ELSE
    scratch2:=self.get_iter()
    self.set_iter(scratch2.get_next())
  ENDIF
  IF self.get_iter() THEN RETURN TRUE
ENDPROC FALSE
