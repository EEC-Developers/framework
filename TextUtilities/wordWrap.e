OPT MODULE

EXPORT OBJECT wordWrap PRIVATE
  buffer_size:INT
  buf_length:INT
  max_length:INT
  cursor:INT
  buffer:PTR TO CHAR
  buffer2:PTR TO CHAR
ENDOBJECT

->constructor
EXPORT PROC init(buffer_length) OF wordWrap
  self.buffer_size:=buffer_length
  self.buffer:=String(buffer_length)
  IF self.buffer=NIL THEN Raise("MEM")
  self.buffer2:=String(buffer_length)
  IF self.buffer=NIL THEN Raise("MEM")
ENDPROC

->wrapper method so that length field can be overridden as pixel width for
->  proportional fonts or StrLen for C strings if needed
EXPORT PROC length(text) OF wordWrap IS EstrLen(text)

->second wrapper for buffered io support in AmigaOS 2+ using PutStr
EXPORT PROC output(text) OF wordWrap IS WriteF('\s',text)

->private helper method
PROC out_or_in(self:PTR TO wordWrap,my_length)
  IF my_length=0 THEN RETURN
  IF self.buf_length+my_length<self.max_length
	self.buf_length:=self.buf_length+my_length
	MidStr(self.buffer,self.buffer2,self.cursor,my_length)
	self.cursor:=self.cursor+my_length
  ELSE
    self.output(self.buffer)
	MidStr(self.buffer,self.buffer2,self.cursor,ALL)
	SetStr(self.buffer2,0)
	self.cursor:=0
  ENDIF
ENDPROC

EXPORT PROC wrap(format,var) OF wordWrap
  DEF next_word:REG,to_go:REG
  StringF(self.buffer2,format,var)
  self.cursor:=0
  self.buf_length:=self.length(self.buffer)
  to_go:=self.length(self.buffer2)
  WHILE self.buf_length+to_go<self.max_length
    IF to_go=0 THEN RETURN
	next_word:=InStr(self.buffer2,' ')
	IF next_word=-1
	  next_word:=InStr(self.buffer2,'-')
	  IF next_word=-1
		next_word:=StrLen(self.buffer2)
		out_or_in(self,next_word)
        RETURN
	  ENDIF
    ENDIF
    out_or_in(self,next_word)
	to_go:=StrLen(self.buffer2)-self.cursor
  ENDWHILE
ENDPROC

->End of paragraph
EXPORT PROC flush_wrap() OF wordWrap
  self.output(self.buffer)
  self.output('\n\n')
  SetStr(self.buffer,0)
ENDPROC
