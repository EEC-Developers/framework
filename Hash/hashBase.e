-> hashing module

OPT MODULE

MODULE 'Iterator/iterator','List/singleList'

EXPORT CONST HASH_MICRO    = 5,
             HASH_TINY     = 13,
             HASH_SMALL    = 61,
             HASH_NORMAL   = 211,
             HASH_MEDIUM   = 941,
             HASH_BIG      = 3911,
             HASH_HUGE     = 16267

EXPORT OBJECT hash_base
PRIVATE
  future1:INT
  size:INT
  num_entries:LONG
  compare_key -> function pointer
  entries:PTR TO LONG
ENDOBJECT

PROC get_size() OF hash_base IS self.size

PROC get_entries() OF hash_base IS self.entries

PROC get_num_entries() OF hash_base IS self.num_entries

-> virtual hash function
PROC hash_function(key) OF hash_base IS EMPTY

EXPORT OBJECT hash_link OF single_list_node PRIVATE
  future1:INT
  hash_value:INT
ENDOBJECT

-> getters
PROC get_hash_value() OF hash_link IS self.hash_value

-> constructor
PROC init(key,parent:PTR TO hash_base) OF hash_link
  SUPER self.init()
  self.hash_value:=parent.hash_function(key)
ENDPROC

-> virtual getter
PROC get_key() OF hash_link IS EMPTY

-> use this remove method instead of on the link itself
PROC remove(link:PTR TO hash_link) OF hash_base
  DEF ret
  ret:=link.remove()
  self.num_items--
ENDPROC ret

-> modulo distribution method for slot selection
PROC hash_slot(hash_val) OF hash_base
  DEF ret
  ret:=hash_val AND $7FFF -> REMOVE negative sign bit
  ret:=Mod(ret,self.size)
ENDPROC ret

-> base constructor
-> comparison is a function pointer of the format:
-> comparison(x:PTR TO hash_link,key):BOOL
PROC init_base(tablesize,comparison) OF hash_base
  DEF table:PTR TO LONG,count,h:PTR TO single_list_header
  NEW table[tablesize]
  self.entries:=table
  FOR count:=0 TO tablesize-1
    NEW h.init()
    table[count]:=h
  ENDFOR
  self.size:=tablesize
  
  self.num_entries:=0
  self.compare_key:=comparison
ENDPROC

-> destructor
PROC end() OF hash_base
  DEF p:PTR TO LONG,count
  p:=self.entries
  FOR count:=0 TO self.size-1
    END p[count]
  ENDFOR
  END p[self.size]
ENDPROC

-> destruct all links if desired
PROC end_links() OF hash_base
  DEF a,o:PTR TO single_list_header,
    i:PTR TO single_list_iterator
  FOR a:=0 TO self.size-1
    o:=self.entries[a]
    NEW i.init(o)
    WHILE i.next()
      END self.remove(i.get_current_item())
    ENDWHILE
	END i
  ENDFOR
ENDPROC

-> hashes key, then tries to find entry.
-> returns hash_link
PROC find(key) OF hash_base
  DEF hiter:PTR TO single_list_iter,index,h:REG,cmp,
    hlink:=PTR TO hash_link
  h:=self.hash_function(key)
  cmp:=self.compare_key
  index:=self.hash_slot(h)
  -> hashvalue found, now do a search
  NEW hiter.init(self.entries[index])
  WHILE hiter.next()
    hlink:=hiter.get_current_item()
    IF hlink.get_hash_value()=h
	    IF cmp(hlink,key) THEN RETURN hlink
	ENDIF
  ENDWHILE
ENDPROC NIL

-> add a new hash_link
PROC add(link:PTR TO hash_link) OF hash_base
  DEF hashvalue
  hashvalue:=self.hash_slot(link.get_hash_value())
  self.entries[hashvalue].insert(link)
  self.num_entries++
ENDPROC

-> iterator base class
EXPORT OBJECT hash_iterator OF iterator
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
PROC rehash(size,old:PTR TO hash_base) OF hash_base
  DEF iter:PTR TO hash_node,old_entries:PTR TO LONG,
    count,slot:PTR TO single_list_header
  CopyMem(old,self,sizeof hash_base)
  IF size=old.get_size() THEN RETURN
  NEW self.table[size]
  self.size:=size
  old_entries:=old.get_entries()
  FOR count:=0 TO old.get_size()-1
    slot:=old_entries[count]
    NEW iter.init(slot)
    WHILE iter.next()
      item:=old.remove(iter.get_current_item())
      self.add(item)
    ENDWHILE
	END iter
  ENDFOR
  END old
ENDPROC
