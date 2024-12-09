OPT MDOULE
-> hash of elist named composite because it is an elist of
->   other hash functions

OBJECT composite_hash_key
  functions:LIST
  object
ENDOBJECT

-> Constructor
EXPORT PROC init(fn,obj) OF composite_hash_key PRIVATE
  self.functions:=fn
  object:=obj
ENDPROC

PROC get_functions() OF composite_hash_key IS self.functions

PROC get_object() OF composite_hash_key IS self.object

EXPORT PROC composite_hash(key:PTR TO composite_hash_key)
  DEF hashvalue:REG,current,fnlist,o:REG

  fnlist:=key.get_functions()
  o:=key.get_object()
  hashvalue:=0
  current:=fnlist[]++
  WHILE current<>NIL
    hashvalue:=Eor(hashvalue,current(o))
    current:=key[]++
  ENDWHILE
ENDPROC Eor(hashvalue AND $FFFF,Shr(hashvalue,16))
