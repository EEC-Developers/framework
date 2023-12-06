-> Split Buffer

OPT MODULE

-> counts the delimiters in a buffer
EXPORT PROC count_strings(buffer,buffer_length,delimiter=$0a)
  DEF iter:REG PTR TO CHAR,scratch:REG,count:REG,trailbyte:REG

  iter:=buffer
  count:=0
  scratch:=buffer_length
  trailbyte:=delimiter AND $ff
  WHILE scratch>0
    scratch--
    IF iter[]++ = trailbyte THEN count++
  ENDWHILE
ENDPROC count

-> split a buffer into null-terminated substrings
-> Notes:
-> * in-place operation, buffer will still be deallocated as one deallocation
-> * last member of elist is buffer end address for convenience
EXPORT PROC create_string_list(buffer,buffer_length,delimiter=$0a,
    maximum=0)
  DEF iter:REG PTR TO CHAR,scratch:REG,trailbyte:REG,ret

  IF maximum=0
    maximum:=count_strings(buffer,buffer_length,delimiter)
  ENDIF
  ret:=List(maximum+1)
  IF ret=NIL THEN Raise("MEM")
  iter:=buffer
  scratch:=buffer_length
  ListAddItem(ret,iter)
  trailbyte:=delimiter AND $ff
  WHILE scratch>0
    scratch--
    IF iter[] = trailbyte
      iter[]++ := 0
      ListAddItem(ret,iter)
    ELSE
      iter[]++
    ENDIF
  ENDWHILE
ENDPROC ret
