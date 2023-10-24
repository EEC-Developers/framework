-> hashing module

OPT MODULE

MODULE 'hash/hashBase','Hash/unorderedHashBase'

EXPORT OBJECT elist_hash_link OF unordered_hash_link
PRIVATE
  key:PTR TO LONG
ENDOBJECT

PROC get_key() OF elist_hash_link IS self.key

PROC key_equality(m:PTR TO elist_hash_link,k:PTR TO LONG)
  DEF scratch
  scratch:=ListCmp(m.key,k)
ENDPROC scratch=0

EXPORT OBJECT elist_hash OF unordered_hash_base
ENDOBJECT

-> constructor
PROC init(tablesize) OF elist_hash
  SUPER self.init_base(tablesize,{key_equality})
ENDPROC

PROC add(link) OF elist_hash
  SUPER self.add(link)
ENDPROC

-> link constructor
PROC init(key:PTR TO LONG,parent:PTR TO elist_hash) OF elist_hash_link -> constructor
  SUPER self.init(key,parent)
ENDPROC

PROC hash_function(key) OF elist_hash
  DEF hashvalue:REG, x:REG, y:REG PTR TO LONG, count:REG
  hashvalue:=0
  y:=key
  count:=ListLen(y)
  IF count=0 THEN Raise("ARGS")
  -> calculate hash function
  REPEAT
    ->ROL.W #4,hashvalue
    hashvalue:=Shr(hashvalue,12) OR Shl(hashvalue,4) AND $FFFF
    x:=y[]++
    x:=Eor(x,Shr(x,16)) AND $FFFF
    hashvalue:=Eor(x,hashvalue)
    count--
  UNTIL count=0
ENDPROC hashvalue AND $FFFF
