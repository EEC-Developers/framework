-> hashing module

OPT MODULE

MODULE 'Hash/hashBase'

EXPORT OBJECT string_hash OF hash_base
ENDOBJECT

EXPORT OBJECT string_hash_link OF hash_link
PRIVATE
  key:PTR TO CHAR
ENDOBJECT

PROC get_key() OF string_hash_link IS self.key

->constructor
PROC init(key,parent:PTR TO string_hash) OF string_hash_link
  SUPER self.init(key,parent)
ENDPROC

PROC hash_function(key:PTR TO CHAR) OF string_hash
  DEF hashvalue:REG, x:REG, y:REG PTR TO CHAR, count:REG
  hashvalue:=0
  y:=key
  count:=StrLen(y)
  -> calculate hash function
  REPEAT
    ->ROL.W #4,hashvalue
    hashvalue:=Shr(hashvalue,12) OR Shl(hashvalue,4) AND $FFFF
    x:=y[]++
    hashvalue:=Eor(x,hashvalue)
    count--
  UNTIL count=0
ENDPROC hashvalue AND $FFFF

PROC key_equality(m:PTR TO string_hash_link,k)
  DEF scratch
  scratch:=StrCmp(m.key,k)
ENDPROC scratch=0

PROC add(link:PTR TO string_hash_link) OF string_hash
  SUPER self.add(link)
ENDPROC

->constructor
PROC init(size) OF string_hash
  SUPER self.init_base(size,{key_equality})
ENDPROC
