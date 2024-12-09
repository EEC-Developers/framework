-> hashing module

OPT MODULE

MODULE 'Iterator/iterator','List/singleList','List/listBase',
  'Hash/hashBase'

-> Sentinal value for dynamic_hash
EXPORT CONST GARBAGE_COLLECT=0

EXPORT OBJECT unordered_hash OF hash_base
ENDOBJECT

PROC remove_from_slot(slot:PTR TO single_list_header) OF unordered_hash
  DEF ret
  ret:=slot.remove_first()
  self.decrement_num_entries()
ENDPROC ret

-> base constructor
->   See hashBase.e for more inromation about function pointers
PROC init_base(tablesize,get_key,comparison,hash_func) OF unordered_hash
  DEF table:PTR TO LONG,count,q:PTR TO single_list_header
  NEW table[tablesize]
  FOR count:=0 TO tablesize-1
    NEW q.init()
    table[count]:=q
  ENDFOR
  SUPER self.initializer(table,tablesize,get_key,comparison,hash_func)
ENDPROC

-> add a new hash_link
PROC add(link:PTR TO hash_link) OF unordered_hash
  DEF hashvalue,scratch:PTR TO single_list_header
  hashvalue:=self.hash_slot(link.get_hash_value())
  scratch:=self.get_slot(hashvalue)
  scratch.insert(link)
  self.increment_num_entries()
ENDPROC

-> iterator base class
EXPORT OBJECT unordered_hash_iterator OF iterator
PRIVATE
  col
  n
  table:PTR TO LONG
  i:PTR TO list_iterator
ENDOBJECT

-> iterator constructor
PROC init(t:PTR TO hash_base) OF unordered_hash_iterator
  self.n:=t.get_size()
  self.table:=t.get_entries()
  self.col:=0
  NEW self.i.init(self.table[0])
ENDPROC

PROC get_current_item() OF unordered_hash_iterator
ENDPROC self.i.get_current_item()

-> advance iterator to the next item
PROC next() OF unordered_hash_iterator
  -> row advance
  WHILE self.i.next()=FALSE
    -> column advance
    END self.i
    self.col+=1
    -> abort if last column reached
    IF self.col = self.n THEN RETURN FALSE
    NEW self.i.init(self.table[self.col])
  ENDWHILE
ENDPROC TRUE

-> Constructor
PROC rehash(size,old:PTR TO unordered_hash) OF unordered_hash
  DEF count:REG,slot:REG PTR TO single_list_header,table:REG PTR TO LONG,
    item:REG PTR TO hash_link
  nullable:=FALSE
  IF size=old.get_size()
    SUPER self.initializer(old.get_entries(),old.get_size(),
      old.get_comparison(),old.get_hash_function(),
      old.get_num_entries())
    Dispose(old)
    RETURN
  ENDIF
  IF size=GARBAGE_COLLECT -> dynamic_hash sentinel
    size:=old.get_size()
  ENDIF
  FOR count:=0 TO size-1
    NEW slot.init()
    table[count]:=slot
  ENDFOR
  SUPER self.initializer(table,size,old.get_key_get(),
    old.get_comparison(),old.get_hash_function())
  FOR count:=0 TO old.get_size()-1
    slot:=old.get_slot(count)
    WHILE slot.get_first()<>NIL
      item:=old.remove_from_slot(slot)
      self.add(item)
    ENDWHILE
  ENDFOR
  END old
ENDPROC
