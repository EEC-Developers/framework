-> Split Buffer

OPT MODULE

MODULE 'Filter/filterBase','Buffer/bufferBase','Buffer/stringQueue',
  'Buffer/estring','Iterator/iterator','Queue/queue','List/singleList'

EXPORT OBJECT splitter OF filter_process PRIVATE
  delimiter
  work:PTR TO estring_buffer
ENDOBJECT

-> Constructor
-> delimiter defults to linefeed
PROC create(parent,string_size,delimiter=$0a) OF splitter
  DEF output:PTR TO string_queue

  SUPER self.add(parent)
  self.delimiter:=delimiter
  NEW self.work.init(string_size)
  NEW output.init()
  self.set_output(output)
ENDPROC

PROC process(iter:PTR TO iterator) OF splitter
  DEF cursor:REG,trailbyte:REG,q:PTR TO string_queue

  self.clear_output()
  q:=self.get_output()
  trailbyte:=self.delimiter AND $ff
  WHILE iter.next()
    cursor:=iter.get_current_item()
    IF cursor = trailbyte
      q.enqueue(self.work.buf)
      self.work.clear()
    ELSE
      StrAddChar(self.work.buf,cursor)
    ENDIF
  ENDWHILE
ENDPROC
