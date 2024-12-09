OPT MODULE

-> passthrough filter process

-> used to convert to different buffers

MODULE 'Filter/filterBase','Iterator/iterator','Buffer/bufferBase'

OBJECT passthrough OF filter_process
ENDOBJECT

PROC process(iter:PTR TO iterator) OF passthrough
  DEF o:PTR TO buffer

  o:=self.get_output()
  WHILE iter.next()
    o.append(iter.get_current_item())
  ENDWHILE
ENDPROC
