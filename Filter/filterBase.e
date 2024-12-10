OPT MODULE

-> buffered filter and source class

MODULE 'Queue/queue', 'List/singleList', 'Iterator/iterator',
  'List/listBase','Buffer/bufferBase'

EXPORT OBJECT filter PRIVATE
  chain:PTR TO queue
ENDOBJECT

EXPORT OBJECT filter_process OF queue_node PRIVATE
  out:PTR TO buffer
ENDOBJECT

PROC get_output() OF filter_process
  IF self.out=NIL THEN Raise("INIT")
ENDPROC self.out

PROC set_output(o) OF filter_process
  IF o=NIL THEN Raise("FILT")
  self.out:=o
ENDPROC

PROC clear_output() OF filter_process IS self.out.clear()

-> Constructor
PROC init() OF filter
  NEW self.chain.init()
ENDPROC

PROC process(prev:PTR TO iterator) OF filter
  DEF iter:REG PTR TO list_iterator, source:PTR TO buffer,
    curr:REG PTR TO filter_process

  curr:=NIL
  NEW iter.init(self.chain)
  WHILE iter.next()
    curr:=iter.get_current_item()
    curr.process(prev)
    source:=curr.get_output()
    prev:=source.get_iterator()
  ENDWHILE
  -> exception only occurs when no filter_process has been added
  IF curr=NIL THEN Raise('FILT')
ENDPROC

PROC enqueue(filt_process:PTR TO filter_process) OF filter
  self.chain.enqueue(filt_process)
ENDPROC

PROC get_output() OF filter
  DEF fp:PTR TO filter_process

  fp:=self.chain.get_back()
  -> Raise exception if no filter_process has been added
  IF fp=NIL THEN Raise('FILT')
ENDPROC fp.get_output()

-> Constructor
PROC add(parent:PTR TO filter) OF filter_process
  parent.enqueue(self)
ENDPROC

PROC process(iter) OF filter_process IS EMPTY
