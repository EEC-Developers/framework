-> hashing module

OPT MODULE

MODULE 'hash/hashbase'

EXPORT OBJECT string_hash_link OF hash_link
PRIVATE
  key:PTR TO CHAR
ENDOBJECT

PROC get_key() OF string_hash_link IS self.key

PROC init(key) OF string_hash_link -> constructor
  DEF hashvalue:REG, x:REG, y:REG PTR TO CHAR, count:REG
  hashvalue:=0
  y:=key
  self.key:=y
  count:=StrLen(y)
  -> calculate hash function
  REPEAT
    ->ROL.W #4,hashvalue
    hashvalue:=Shr(hashvalue,12) OR Shl(hashvalue,4) AND $FFFF
    x:=y[]++
    hashvalue:=Eor(x,hashvalue)
    count--
  UNTIL count=0
  self.hash_value:=hashvalue AND $FFFF
ENDPROC

PROC key_equality(m:PTR TO string_hash_link) OF string_hash_link
  DEF scratch
  scratch:=StrCmp(m.key,self.key)
ENDPROC scratch

EXPORT OBJECT string_hash OF hash_base
ENDOBJECT

PROC add(link:PTR TO string_hash_link) OF string_hash
  SUPER self.add(link)
ENDPROC
