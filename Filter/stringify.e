OPT MODULE

-> stringify filter process

-> used to export to string_buffer of exact capacity

MODULE 'Filter/filterBase','Iterator/iterator','Buffer/bufferBase'

OBJECT stringify OF filter_process PRIVATE
  previous:PTR TO buffer
ENDOBJECT

-> constructor
PROC stage(parent,prev) OF stringify
  SUPER self.add(parent)
  IF prev=NIL THEN Raise("INIT")
  self.previous:=prev
ENDPROC

PROC process(iter:PTR TO iterator) OF stringify
  DEF o:REG PTR TO estring_buffer

  NEW o.init(self.previous.get_capacity())
  WHILE iter.next()
    o.append(iter.get_current_item())
  ENDWHILE
  self.set_output(o)
ENDPROC
