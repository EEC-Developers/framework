OPT MDOULE
-> hash of elist
EXPORT PROC elist_hash(key:PTR TO LONG)
  DEF hashvalue:REG,current:REG

  hashvalue:=0
  current:=key[]++
  WHILE current<>NIL
    hashvalue:=Eor(hashvalue,current)
    current:=key[]++
  ENDWHILE
ENDPROC Eor(hashvalue AND $FFFF,Shr(hashvalue,16))
