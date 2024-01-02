OPT MODULE

-> buffered filter and source class

MODULE 'Queue/queue', 'List/singleList', 'Iterator/iterator',
  'List/listBase','Buffer/bufferBase'

EXPORT OBJECT filter PRIVATE
  source:PTR TO iterator
  chain:PTR TO queue
ENDOBJECT

EXPORT OBJECT filter_process OF queue_node PRIVATE
  parent:PTR TO filter
  out:PTR TO buffer
ENDOBJECT

PROC get_parent() OF filter_process IS self.parent

PROC get_output() OF filter_process IS self.out

PROC clear_output() OF filter_process IS self.out.clear()

-> Constructor
PROC init() OF filter
  NEW self.chain.init()
ENDPROC

PROC process() OF filter
  DEF iter:REG PTR TO list_iterator, source:PTR TO buffer,
    curr:REG PTR TO filter_process, prev:PTR TO iterator

  prev:=self.source
  NEW iter.init(self.chain)
  WHILE iter.next()
    curr:=iter.get_current_item()
    curr.process(prev)
    source:=curr.get_output()
    prev:=source.get_iterator()
  ENDWHILE
ENDPROC curr

PROC enqueue(filt_process:PTR TO filter_process) OF filter
  self.chain.enqueue(filt_process)
ENDPROC

-> Constructor
PROC add(parent:PTR TO filter,output:PTR TO buffer) OF filter_process
  self.parent:=parent
  parent.enqueue(self)
  self.out:=output
ENDPROC

PROC process(iter) OF filter_process IS EMPTY