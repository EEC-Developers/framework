-> hashing module

OPT MODULE

MODULE 'Iterator/iterator'

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

EXPORT OBJECT hash_link PRIVATE
  next:PTR TO hash_link
  future1:INT
  hash_value:INT
ENDOBJECT

-> getters
PROC get_next() OF hash_link IS self.next

PROC get_hash_value() OF hash_link IS self.hash_value

-> constructor
PROC init(key,parent:PTR TO hash_base) OF hash_link
  self.hash_value:=parent.hash_function(key)
ENDPROC

-> virtual getter
PROC get_key() OF hash_link IS EMPTY

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
  DEF table:PTR TO LONG
  NEW table[tablesize]
  self.entries:=table
  self.size:=tablesize
  self.num_entries:=0
  self.compare_key:=comparison
ENDPROC

-> destructor
PROC end() OF hash_base
  DEF p:PTR TO LONG
  p:=self.entries
  END p[self.size]
ENDPROC

-> destruct all links if desired
PROC end_links() OF hash_base
  DEF a,p:PTR TO hash_link,
    o:PTR TO hash_link
  FOR a:=0 TO self.size-1
    p:=self.entries[a]
    WHILE p<>NIL
      o:=p
      p:=p.next
      Dispose(o)
    ENDWHILE
  ENDFOR
  self.num_entries:=0
ENDPROC

-> hashes key, then tries to find entry.
-> returns hash_link
PROC find(key) OF hash_base
  DEF hlink:REG PTR TO hash_link,index,h:REG,cmp
  h:=self.hash_function(key)
  cmp:=self.compare_key
  index:=self.hash_slot(h)
  -> hashvalue found, now do a search
  hlink:=self.entries[index]
  WHILE hlink<>NIL
    IF hlink.get_hash_value()=h
	    IF cmp(hlink,key) THEN RETURN hlink
	ENDIF
    hlink:=hlink.next
  ENDWHILE
ENDPROC NIL

-> add a new hash_link
PROC add(link:PTR TO hash_link) OF hash_base
  DEF hashvalue
  hashvalue:=self.hash_slot(link.get_hash_value())
  link.next:=self.entries[hashvalue]
  self.entries[hashvalue]:=link
  self.num_entries++
ENDPROC

-> iterator base class
EXPORT OBJECT hash_iterator OF iterator
PRIVATE
  item:PTR TO hash_link
  col,n,depth,table:PTR TO LONG
ENDOBJECT

-> iterator constructor
PROC init(t:PTR TO hash_base) OF hash_iterator
  self.n:=t.get_size()
  self.table:=t.get_entries()
  self.col:=0
  self.item:=NIL
ENDPROC

PROC get_current_item() OF hash_iterator IS self.item

-> advance iterator to the next item
PROC next() OF hash_iterator
  IF self.item
    -> row advance
    self.item:=self.item.get_next()
  ENDIF
  -> column advance
  WHILE self.item=NIL
    IF self.col<self.n
      self.item:=self.table[self.col]
      self.col++
    ELSE
      RETURN FALSE
    ENDIF
  ENDWHILE
ENDPROC TRUE

PROC rehash(size) OF hash_base
  DEF iter:PTR TO hash_iterator,ret:PTR TO hash_base
  IF size=self.size THEN RETURN
  NEW ret.init_base(size,self.compare_key)
  NEW iter.init(self)
  WHILE iter.next()
    ret.add(iter.get_current_item())
  ENDWHILE
  Dispose(self.entries)
  self.size:=size
  self.entries:=ret.get_entries()
  Dispose(ret)
ENDPROC
