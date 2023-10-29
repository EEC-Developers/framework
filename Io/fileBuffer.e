-> File Buffer class
-> padded with longword of delimieters before and after in constructor

OPT MODULE

EXPORT OBJECT file_buffer PRIVATE
  membuf:PTR TO CHAR
  length
ENDOBJECT

-> Getters and Setters
PROC get_buffer() OF file_buffer IS self.membuf+4

PROC get_length() OF file_buffer IS self.length

-> Constructor
PROC read_file(filename:PTR TO CHAR,
  trailbyte=$0a,memflags=0) OF file_buffer
  DEF scratch:REG,footer:PTR TO CHAR,handle
  
  self.length:=FileLength(filename)
  IF self.length<=0 THEN Throw("OPEN",filename)
  self.membuf:=NewM(self.length+8,memflags)
  scratch:=Mul(trailbyte,$01010101)
  -> since membuf is longword aligned anyway...
  PutLong(self.membuf,scratch)
  footer:=self.membuf+length+4
  IF footer AND 1 -> is not word aligned
    footer[0]:=trailbyte
    PutInt(footer+1,scratch)
	footer[3]:=trailbyte
  ELSE
    PutLong(footer,scratch)
  ENDIF
  handle:=Open(filename,OLDFILE)
  IF handle=NIL THEN Raise("OPEN")
  scratch:=Read(handle,self.membuf+4,length)
  Close(handle)
  IF scratch<>length THEN Raise("IN")
ENDPROC

-> Destructor
PROC end() OF file_buffer IS Dispose(membuf)

PROC write_file(filename:PTR TO CHAR) OF file_buffer
  DEF scratch:REG,handle

  handle:=Open(filename,NEWFILE)
  IF handle=NIL THEN Throw("OPEN",filename)
  scratch:=Write(self.get_buffer(),self.get_length())
  Close(handle)
  IF scratch<>length THEN Raise("OUT")
ENDPROC
