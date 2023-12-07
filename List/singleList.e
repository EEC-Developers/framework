-> Singly Linked List

OPT MODULE

MODULE 'List/listBase'

EXPORT OBJECT single_list_node OF list_node PRIVATE
  next:PTR TO single_list_node
ENDOBJECT

-> Constructor
PROC init() OF single_list_node IS self.next:=NIL

-> getters and setters
PROC get_next() OF single_list_node IS self.next

PROC set_next(node) OF single_list_node IS self.next:=node

EXPORT OBJECT single_list_header OF list_header PRIVATE
  head:PTR TO single_list_node
ENDOBJECT

-> Constructor
PROC init() OF single_list_header IS self.head:=NIL

-> getters and setters
PROC get_first() OF single_list_header IS self.head

PROC set_first(node:PTR TO single_list_node) OF single_list_header
  self.head:=node
ENDPROC

PROC insert(node:PTR TO single_list_node) OF single_list_header
  node.set_next(self.head)
  self.head:=node
ENDPROC

PROC remove_first() OF single_list_header
  DEF iter:PTR TO single_list_node
  iter:=self.get_first()
  self.head:=iter.get_next()
  iter.set_next(NIL)
ENDPROC iter

PROC end() OF single_list_header
  DEF iter:PTR TO single_list_node
  LOOP
    iter:=self.get_first()
    IF iter=NIL THEN RETURN
    iter:=self.remove_first()
    END iter
  ENDLOOP
ENDPROC
