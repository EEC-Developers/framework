OPT MODULE

MODULE 'Iterator/iterator'

EXPORT ENUM TEXT_EMPTY,TEXT_SINGULAR,TEXT_PLURAL

-> text_list creates a syntactically correct list of items from an iterator
  
-> The generator function does not assume variable arguments like StringF or PrintF
->   so a wrapper function is possible in E, however it may be called multiple times.
  
-> It returns if the list was plural, singular or empty as an enumeration.
EXPORT PROC text_list(iter:PTR TO iterator,generator)
  DEF item1:REG,item2:REG,isSingular
  isSingular:=TEXT_PLURAL
  IF iter.next()
    item1:=iter.get_current_item()
    IF iter.next()
      item2:=iter.get_current_item()
      WHILE iter.next()
        generator('\s, ',item1)
        item1:=item2
        item2:=iter.get_current_item()
      ENDWHILE
      generator('\s and ',item1)
      generator('\s. ',item2)
    ELSE
	  isSingular:=TEXT_SINGULAR
      generator('\s. ',item1)
    ENDIF
  ELSE
    isSingular:=TEXT_EMPTY
  ENDIF
ENDPROC isSingular
