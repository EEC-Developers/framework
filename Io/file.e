OPT MODULE

-> Based on Tools/File.e from E 3.3a demo version
-> This version is object-oriented and uses no inline assembly

EXPORT OBJECT file_buffer PRIVATE
  membuf:PTR TO CHAR
  length
  line_list -> e-list of strings
  delimiter
ENDOBJECT

-> Getters and Setters
PROC get_buffer() OF file_buffer IS self.membuf+4

PROC get_length() OF file_buffer IS self.length

PROC get_delimiter() OF file_buffer IS self.delimiter

PROC set_delimieter(value) OF file_buffer
  self.delimiter:=value
ENDPROC

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
  self.delimiter:=trailbyte
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

PROC count_strings() OF file_buffer
  DEF iter:REG PTR TO CHAR,scratch:REG,count:REG,trailbyte:REG

  iter:=self.get_buffer()
  count:=0
  scratch:=self.get_length()
  trailbyte:=self.get_delimiter() AND $ff
  while scratch>0
    scratch--
    IF iter[]++ = trailbyte THEN count++
  ENDWHILE
ENDPROC count

PROC create_string_list(maxumum=self.count_strings()) OF file_buffer
  DEF iter:REG PTR TO CHAR,scratch:REG,trailbyte:REG

  self.line_list:=List(maximum)
  IF self.line_list=NIL THEN Raise("MEM")
  iter:=self.get_buffer()
  scratch:=self.get_length()
  count:=1
  ListAddItem(self.line_list,iter)
  trailbyte:=self.get_delimiter() AND $ff
  while scratch>0
    scratch--
    IF iter[] = trailbyte
      iter[]++ := 0
      ListAddItem(self.line_list,iter)
    ELSE
      iter[]++
    ENDIF
  ENDWHILE
ENDPROC
