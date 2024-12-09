OPT MODULE

-> word-wrap routine for filter streams of ASCII text

MODULE 'Buffer/bufferBase','Filter/filterBase','Iterator/iterator'

EXPORT OBJECT word_wrap OF filter_process PRIVATE
  line_buffer
  item
  line_length:INT
  cursor:INT
ENDOBJECT

->constructor
PROC create(parent:PTR TO filter,output:PTR TO buffer,
    line_length) OF word_wrap

  self.line_buffer:=String(line_length+1)
  IF self.line_buffer=NIL THEN Raise('MEM')
  self.line_length:=line_length
  SUPER self.add(parent,output)
ENDPROC

->private helper function
PROC out_or_in(self:PTR TO word_wrap,my_length)
  DEF o:PTR TO buffer

  -> check if word is too long to be wrappable
  IF my_length>self.line_length THEN Raise('LINE')
  IF EstrLen(self.line_buffer)+my_length<StrMax(self.line_buffer)
	MidStr(self.line_buffer,self.item,self.cursor,my_length)
	self.cursor:=self.cursor+my_length
    RETURN FALSE
  ENDIF
  o:=self.get_output()
  -> output a line of text
  StrAdd(self.line_buffer,'\n')
  o.append(self.line_buffer)
  -> move the remnant to the bottom address and clear line buffer
  MidStr(self.item,self.item,self.cursor,ALL)
  SetStr(self.line_buffer,0)
  self.cursor:=0
ENDPROC TRUE

PROC find_wrap_point(self:PTR TO word_wrap)
  DEF next_word:REG,next_hyphen:REG

  next_word:=InStr(self.item,' ')+1
  next_hyphen:=InStr(self.item,'-')+1
  IF next_word=0
    IF next_hyphen=0
      -> no more wrappable characters
      next_word:=EstrLen(self.line_buffer)
      RETURN out_or_in(self,next_word)
    ELSE
      -> wrap after next hyphen
      next_word:=next_hyphen
    ENDIF
  ELSE
    IF next_hyphen>0
      next_word:=Min(next_word,next_hyphen)
    ENDIF
  ENDIF
ENDPROC out_or_in(self,next_word)
  
PROC process(iter:PTR TO iterator) OF word_wrap
  DEF end_line:REG,o:PTR TO buffer

  self.clear_output()
  WHILE (iter.next())
    self.item:=iter.get_current_item()
    self.cursor:=0
    WHILE EstrLen(self.item) > self.line_length
      end_line:=find_wrap_point(self)
    ENDWHILE
    WHILE EstrLen(self.item)>0 AND Not(end_line)
      end_line:=find_wrap_point(self)
    ENDWHILE
	o:=self.get_output()
    IF Not(end_line)
      StrAdd(self.line_buffer,'\n')
      o.append(self.line_buffer)
      SetStr(self.line_buffer,0)
    ENDIF
    IF EstrLen(self.item)>self.cursor
      StrCopy(self.line_buffer,self.item)
      StrAdd(self.line_buffer,'\n')
      o.append(self.line_buffer)
    ENDIF
    o.append('\n')
  ENDWHILE
ENDPROC
