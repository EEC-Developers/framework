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

PROC get_current_item() OF list_iterator IS iter

PROC init(head:PTR TO list_header) OF list_iterator
  self.is_new:=TRUE
  self.head:=head
  self.iter:=NIL
ENDPROC

-> helper method
PROC advance(self:PTR TO list_iterator)
  IF isNew
    isNew:=FALSE
	iter:=head.get_first()
  ELSE
    iter:=iter.get_next()
  ENDIF
  IF iter THEN RETURN TRUE
ENDPROC FALSE

PROC next() OF list_iterator IS advance(self)
