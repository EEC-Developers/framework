OPT MODULE

-> Dynamic hash table (allows removing items)

MODULE 'Hash/hashBase','Hash/unorderedHash'

EXPORT OBJECT dynamic_hash OF unordered_hash
ENDOBJECT

-> NOTE: Any rehash will garbage collect but this one keeps the same size
PROC garbage_collect() OF dynamic_hash
  DEF var:PTR TO dynamic_hash
  NEW var.rehash(GARBAGE_COLECT,self)
ENDPROC var  

-> not only prevents NIL adds but used by garbage collection pass 
->   in rehash constructor
PROC add(item:PTR TO hash_link) OF nullable_hash
  IF item.get_value()=NIL
    END item
    RETURN
  ENDIF
  SUPER self.add(item)
ENDPROC

PROC remove(item:PTR TO hash_link) OF dynamic_hash
  DEF cargo

  cargo:=item.get_value()
  IF cargo<>NIL
    item.set_value(NIL)
    self.decrement_num_entries()
  ENDIF
ENDPROC cargo
