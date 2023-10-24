-> hashing module

OPT MODULE

MODULE 'Iterator/iterator','List/singleList'

EXPORT OBJECT unordered_hash_base OF hash_base
ENDOBJECT

EXPORT OBJECT unordered_hash_link OF hash_link
ENDOBJECT

PROC remove_from_slot(slot:PTR TO queue) OF unordered_hash_base
  DEF ret
  ret:=slot.removee_first()
  self.num_items--
ENDPROC ret


-> base constructor
-> comparison is a function pointer of the format:
-> comparison(x:PTR TO hash_link,key):BOOL
PROC init_base(tablesize,comparison) OF hash_base
  DEF table:PTR TO LONG,count,q:PTR TO single_list_header
  NEW table[tablesize]
  self.entries:=table
  FOR count:=0 TO tablesize-1
    NEW q.init()
    table[count]:=q
  ENDFOR
  self.size:=tablesize
  self.num_entries:=0
  self.compare_key:=comparison
ENDPROC

-> add a new hash_link
PROC add(link:PTR TO hash_link) OF unordered_hash_base
  DEF hashvalue
  hashvalue:=self.hash_slot(link.get_hash_value())
  self.entries[hashvalue].insert_first(link)
  self.num_entries++
ENDPROC

-> iterator base class
EXPORT OBJECT unordered_hash_iterator OF iterator
PRIVATE
  col
  n
  table:PTR TO LONG
  i:PTR TO single_list_iterator
ENDOBJECT

-> iterator constructor
PROC init(t:PTR TO hash_base) OF hash_iterator
  self.n:=t.get_size()
  self.table:=t.get_entries()
  self.col:=0
  NEW self.i.init(self.table[0])
  self.item:=NIL
ENDPROC

PROC get_current_item() OF hash_iterator
ENDPROC self.i.get_current_item()

-> advance iterator to the next item
PROC next() OF hash_iterator
  -> row advance
  WHILE self.i.next()=FALSE
    -> column advance
    END self.i
    self.col++
    -> abort if last column reached
    IF self.col>=self.n THEN RETURN FALSE
    NEW self.i.init(self.table[self.col])
  ENDWHILE
ENDPROC TRUE

-> Constructor
PROC rehash(size,old:PTR TO unordered_hash_base) OF unordered_hash_base
  DEF old_entries:PTR TO LONG,count,slot:PTR TO single_list_header
  CopyMem(old,self,sizeof hash_base)
  IF size=old.get_size()
    Dispose(old)
    RETURN
  ENDIF
  NEW self.table[size]
  self.size:=size
  old_entries:=old.get_entries()
  FOR count:=0 TO old.get_size()-1
    slot:=old_entries[count]
    WHILE old.get_first()<>NIL
      item:=old.remove_from_slot(slot)
      self.add(item)
    ENDWHILE
  ENDFOR
  END old
ENDPROC
