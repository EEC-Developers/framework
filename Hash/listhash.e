-> hashing module

OPT MODULE

MODULE 'hash/hashbase'

EXPORT OBJECT list_hash_link OF hash_link
PRIVATE
  key:PTR TO LONG
ENDOBJECT

PROC get_key() OF list_hash_link IS self.key

PROC init(key) OF list_hash_link -> constructor
  DEF hashvalue:REG, x:REG, y:REG PTR TO LONG, count:REG
  hashvalue:=0
  y:=key
  self.key:=y
  count:=ListLen(y)
  -> calculate hash function
  REPEAT
    ->ROL.W #4,hashvalue
    hashvalue:=Shr(hashvalue,12) OR Shl(hashvalue,4) AND $FFFF
    x:=y[]++
    x:=Eor(x,Shr(x,16)) AND $FFFF
    hashvalue:=Eor(x,hashvalue)
    count--
  UNTIL count=0
  self.hash_value:=hashvalue AND $FFFF
ENDPROC

PROC key_equality(m:PTR TO list_hash_link) OF list_hash_link
  DEF scratch
  scratch:=ListCmp(m.key,self.key)
ENDPROC scratch

EXPORT OBJECT list_hash OF hash_base
ENDOBJECT

-> constructor
PROC init(tablesize) OF list_hash IS SUPER self.init(tablesize)

PROC add(link) OF list_hash
  SUPER self.add(link)
ENDPROC
