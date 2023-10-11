OPT MODULE

-> Queue class

MODULE 'List/listBase','List/singleList'

EXPORT OBJECT queue_node OF single_list_node PRIVATE
ENDOBJECT

EXPORT OBJECT queue OF single_list_header PRIVATE
  front:PTR TO queue_node
ENDOBJECT

-> Constructor
PROC init() OF queue
  SUPER self.init()
  front:=NIL
ENDPROC

-> Constructor
PROC init() OF queue_node IS SUPER self.init()

PROC enqueue(node:PTR TO queue_node) OF queue
  IF self.front THEN self.front.set_next(node)
  self.front:=node
ENDPROC

PROC dequeue() OF queue IS self.remove_first()::queue_node
