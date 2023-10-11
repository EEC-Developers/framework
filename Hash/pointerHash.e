-> hashing module

OPT MODULE

MODULE 'Hash/hashBase'

EXPORT OBJECT pointer_hash OF hash_base
ENDOBJECT

EXPORT OBJECT pointer_hash_link OF hash_link
PRIVATE
  key:PTR TO LONG
ENDOBJECT

PROC get_key() OF pointer_hash_link IS self.key

->constructor
PROC init(key,parent:PTR TO pointer_hash) OF pointer_hash_link
  SUPER self.init(key,parent)
ENDPROC

PROC hash_function(key) OF pointer_hash
  DEF temp:REG
  temp:=key
ENDPROC Eor((temp AND $FFFF),Shr(temp,16))

PROC key_equality(m:PTR TO hash_link,k)
  IF k<>m.get_key() THEN RETURN FALSE
ENDPROC TRUE

PROC add(link:PTR TO pointer_hash_link) OF pointer_hash
  SUPER self.add(link)
ENDPROC

-> Constructor
PROC init(table_size) OF pointer_hash
  SUPER self.init_base(table_size,{key_equality})
ENDPROC
