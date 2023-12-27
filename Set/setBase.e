-> abstract base class of dataset data structure
OPT MODULE

MODULE 'Iterator/iterator'

EXPORT OBJECT subset PRIVATE
  parent:PTR TO LONG
ENDOBJECT

-> Constructor
PROC base_init(parent_set) OF subset
  self.parent:=parent_set
ENDPROC

PROC get_parent() OF subset IS self.parent

PROC insert(items:PTR TO subset) OF subset IS EMPTY

PROC remove(items:PTR TO subset) OF subset IS EMPTY

PROC has_one(item) OF subset IS EMPTY

PROC has_all(items:PTR TO subset) OF subset IS EMPTY

PROC is_empty() OF subset IS EMPTY

EXPORT OBJECT set_iterator OF iterator
ENDOBJECT

PROC get_current_item() OF set_iterator IS EMPTY

PROC init(s:PTR TO subset) OF set_iterator IS EMPTY

PROC next() OF set_iterator IS EMPTY
