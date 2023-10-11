-> Rope data structure

OPT MODULE

MODULE 'List/listBase','List/singleList','Queue/queue'

EXPORT OBJECT rope_node OF queue_node PRIVATE
  substring:PTR TO CHAR
  length
ENDOBJECT

EXPORT OBJECT rope OF queue PRIVATE
  total_length
ENDOBJECT

-> Constructor
PROC init() OF rope
  SUPER self.init()
  self.total_length:=0
ENDPROC

-> Constructor
PROC wrap(ss:PTR TO CHAR, len) OF rope_node
  SUPER self.init()
  self.substring:=ss
  self.length:=len
ENDPROC

-> getters and setters
PROC get_length() OF rope_node IS self.length

PROC get_substring() OF rope_node IS self.substring

-> Enqueues a substring wrapper
PROC add(node:PTR TO rope_node) OF rope
  self.enqueue(node)
  self.total_length:=self.total_length+node.get_length()
ENDPROC

-> Appendss all substrings, clears rope and returns EString result
PROC output() OF rope
  DEF buf,node:PTR TO rope_node
  IF self.total_length>0
    buf:=String(self.total_length)
    self.total_length:=0
    LOOP
      node:=self.dequeue()
      IF node=NIL THEN RETURN buf
      StrAdd(buf,node.get_substring())
    ENDLOOP
  ENDIF
ENDPROC String(0)
