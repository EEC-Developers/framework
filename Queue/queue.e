OPT MODULE

-> Queue class

MODULE 'List/listBase','List/singleList'

EXPORT OBJECT queue_node OF single_list_node PRIVATE
ENDOBJECT

EXPORT OBJECT queue OF single_list_header PRIVATE
  back:PTR TO queue_node
ENDOBJECT

-> Constructor
PROC init() OF queue
  SUPER self.init()
  self.back:=NIL
ENDPROC

-> Constructor
PROC init() OF queue_node IS SUPER self.init()

PROC enqueue(node:PTR TO queue_node) OF queue
  IF self.back THEN self.back.set_next(node)
  node.set_next(NIL)
  self.back:=node
ENDPROC

PROC merge(other:PTR TO queue)
  DEF node:PTR TO queue_node

  node:=other.get_first()
  self.back.set_next(node)
  self.back:=other.get_back()
  Dispose(other)
ENDPROC

PROC dequeue() OF queue IS self.remove_first()

PROC get_back() OF queue IS self.back
