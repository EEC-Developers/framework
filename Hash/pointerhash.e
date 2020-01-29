-> hashing module

OPT MODULE

MODULE 'hash/hashbase'

EXPORT OBJECT pointer_hash OF hash_base
ENDOBJECT

EXPORT OBJECT pointer_hash_link OF hash_link
PRIVATE
  key:PTR TO LONG
ENDOBJECT

PROC get_key() OF pointer_hash_link IS self.key

PROC init(key) OF pointer_hash_link
  DEF temp:REG
  temp:=key
  self.key:=temp
  /*MOVEQ.L #0,r1
  MOVE.W r0,r1
  SWAP r0
  EOR.W r0,r1
  r2:=r1
  */
  self.hash_value:=Eor((temp AND $FFFF),Shr(temp,16))
ENDPROC

PROC key_equality(m:PTR TO hash_link) OF pointer_hash_link
  IF self.key<>m.get_key() THEN RETURN FALSE
ENDPROC TRUE

PROC add(link) OF pointer_hash
  SUPER self.add(link)
ENDPROC
