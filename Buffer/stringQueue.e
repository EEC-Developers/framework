OPT MODULE

MODULE 'Buffer/bufferBase','Queue/queue','List/singleList',
  'List/listBase'

OBJECT string_node OF queue_node PUBLIC
  cargo
ENDOBJECT

EXPORT OBJECT string_queue_iterator OF list_iterator
ENDOBJECT

-> override getter so that cargo becomes transparent
PROC get_current_item() OF string_queue_iterator
  DEF node:PTR TO string_node

  node:=SUPER self.get_current_item()
ENDPROC node.cargo

-> Constructor
-> clones string so original is unmodified
PROC create(str) OF string_node
  DEF scratch:REG

  scratch:=String(EstrLen(str))
  StrCopy(scratch,str)
  self.cargo:=scratch
  SUPER self.init()
ENDPROC

EXPORT OBJECT string_queue OF buffer PRIVATE
  count
  capacity
ENDOBJECT

-> Constructor
PROC init() OF string_queue
  DEF q:PTR TO queue
  
  NEW q.init()
  SUPER self.init()
  self.count:=0
  self.buf:=q
ENDPROC

PROC append(str) OF string_queue
  DEF node:PTR TO string_node,q:PTR TO queue

  NEW node.create(str)
  q:=self.buf
  q.enqueue(node)
  self.count+=1
  self.capacity+=EstrLen(str)
ENDPROC

PROC get_size() OF string_queue IS self.count

PROC get_capacity() OF string_queue IS self.capacity

PROC get_iterator() OF string_queue
  DEF iter:PTR TO string_queue_iterator,q:PTR TO queue

  q:=self.buf
  NEW iter.init(q)
ENDPROC iter

PROC merge(other:PTR TO string_queue) OF string_queue
  self.capacity+=other.get_capacity()
  self.count+=other.get_size()
  SUPER merge(other)
ENDPROC

-> Destructor
PROC end() OF string_queue
  DEF q:PTR TO queue

  q:=self.buf
  END q
ENDPROC
