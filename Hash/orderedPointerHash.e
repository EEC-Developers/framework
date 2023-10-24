-> hashing module

OPT MODULE

MODULE 'Hash/hashBase','Hash/orderedHashBase'

EXPORT OBJECT ordered_pointer_hash OF ordered_hash_base
ENDOBJECT

EXPORT OBJECT ordered_pointer_hash_link OF ordered_hash_link
PRIVATE
  key:PTR TO LONG
ENDOBJECT

PROC get_key() OF ordered_pointer_hash_link IS self.key

->constructor
PROC init(key,parent:PTR TO ordered_pointer_hash) OF ordered_pointer_hash_link
  SUPER self.init(key,parent)
ENDPROC

PROC hash_function(key) OF ordered_pointer_hash
  DEF temp:REG
  temp:=key
ENDPROC Eor((temp AND $FFFF),Shr(temp,16))

PROC key_equality(m:PTR TO hash_link,k)
  IF k<>m.get_key() THEN RETURN FALSE
ENDPROC TRUE

PROC add(link:PTR TO ordered_pointer_hash_link) OF ordered_pointer_hash
  SUPER self.add(link)
ENDPROC

-> Constructor
PROC init(table_size) OF ordered_pointer_hash
  SUPER self.init_base(table_size,{key_equality})
ENDPROC
