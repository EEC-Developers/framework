-> File Buffer class

OPT MODULE

MODULE 'dos/dos','Buffer/bufferBase','Iterator/iterator',
  'Iterator/estring'

EXPORT OBJECT file_buffer OF buffer PRIVATE
  size -> content may not be an estring so keep track of this
ENDOBJECT

PROC get_size() OF file_buffer IS self.size

PROC clear() OF file_buffer
  IF self.size>=0 THEN Dispose(self.buf)
  self.size:=BUF_EMPTY
ENDPROC

-> Constructor
PROC init() OF file_buffer
  self.size:=BUF_EMPTY
ENDPROC

-> fixed size buffer cannot append beyond initialization
PROC append(item:PTR TO estring_buffer) OF file_buffer
  IF self.size<>BUF_EMPTY THEN Raise("SIZE")
  self.size:=item.get_capacity()
  self.buf:=item.buf
ENDPROC

PROC load_buffer(filename:PTR TO CHAR,trail=FALSE,
    memflags=0) OF file_buffer
  DEF scratch:REG,footer:PTR TO CHAR,handle

  IF self.size>=0 THEN self.clear()
  self.size:=FileLength(filename)
  IF self.size<=0 THEN Throw("OPEN",filename)
  IF trail -> if TRUE adds linefeed and null past the buffer's end
    self.buf:=NewM(self.size+2,memflags)
    footer:=self.buf+self.size
    footer[0]:=$0a
    footer[1]:=$00
  ELSE
    self.buf:=NewM(self.size,memflags)
  ENDIF
  handle:=Open(filename,OLDFILE)
  IF handle=NIL THEN Raise("OPEN")
  scratch:=Read(handle,self.buf,self.size)
  Close(handle)
  IF scratch<>self.size THEN Raise("IN")
ENDPROC

-> Destructor
PROC end() OF file_buffer IS Dispose(self.buf)

PROC save_buffer(filename:PTR TO CHAR) OF file_buffer
  DEF scratch:REG,handle

  handle:=Open(filename,NEWFILE)
  IF handle=NIL THEN Throw("OPEN",filename)
  scratch:=Write(handle,self.buf,self.get_size())
  Close(handle)
  IF scratch<>self.get_size() THEN Raise("OUT")
ENDPROC
