-> Split Buffer

OPT MODULE

-> counts the delimiters in a buffer
PROC count_strings(buffer,bufferLength,delimiter=$0a)
  DEF iter:REG PTR TO CHAR,scratch:REG,count:REG,trailbyte:REG

  iter:=buffer
  count:=0
  scratch:=bufferLength
  trailbyte:=delimiter AND $ff
  while scratch>0
    scratch--
    IF iter[]++ = trailbyte THEN count++
  ENDWHILE
ENDPROC count

-> split a buffer into null-terminated substrings
-> Notes:
-> * in-place operation, buffer will still be deallocated as one deallocation
-> * last member of elist is buffer end address for convenience
PROC create_string_list(buffer,bufferLength,delimiter=$0a,
    maxumum=self.count_strings())
  DEF iter:REG PTR TO CHAR,scratch:REG,trailbyte:REG,ret

  ret:=List(maximum+1)
  IF ret=NIL THEN Raise("MEM")
  iter:=buffer
  scratch:=bufferLength
  count:=1
  ListAddItem(ret,iter)
  trailbyte:=delimiter AND $ff
  while scratch>0
    scratch--
    IF iter[] = trailbyte
      iter[]++ := 0
      ListAddItem(ret,iter)
    ELSE
      iter[]++
    ENDIF
  ENDWHILE
ENDPROC ret
