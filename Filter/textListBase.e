OPT MODULE

-> text_list_base creates a punctuated list of items in English

MODULE 'Iterator/iterator','Filter/filterBase','Buffer/bufferBase'

EXPORT ENUM TEXT_EMPTY,TEXT_SINGULAR,TEXT_PLURAL,TEXT_PLURAL_FINAL,
  TEXT_INITIALIZED

EXPORT OBJECT text_list_base OF filter_process
  status
  work
  preamble
ENDOBJECT

-> self.is_singlular is guaranteed to be set to the proper value by
->   the time this method gets called

-> generate() will also be called at least once.
-> if TEXT_PLURAL is set, expect to be called again
-> if TEXT_PLURAL_FINAL is set, it's the last call
PROC generate() OF text_list_base IS EMPTY

PROC create(parent:PTR TO filter,output:PTR TO buffer,
    work_size,preamble) OF text_list_base
  self.work:=String(work_size)
  self.status:=TEXT_INITIALIZED
  SUPER self.add(parent,output)
ENDPROC

EXPORT PROC process(iter:PTR TO iterator) OF text_list_base
  DEF item1:REG,item2:REG,out:PTR TO buffer

  self.clear_output()
  out:=self.get_output()
  out.append(preamble)
  self.status:=TEXT_EMPTY
  IF iter.next()
    self.status:=TEXT_SINGULAR
    item1:=iter.get_current_item()
    IF iter.next()
      self.status:=TEXT_PLURAL
      item2:=iter.get_current_item()
      WHILE iter.next()
        StringF(self.work,'\s, ',item1)
        self.generate()
        item1:=item2
        item2:=iter.get_current_item()
      ENDWHILE
      self.status:=TEXT_PLURAL_FINAL
      StringF(self.work,'\s and \s',item1,item2)
    ELSE
      StrCopy(self.work,item1)
    ENDIF
  ENDIF
  self.generate()
ENDPROC
