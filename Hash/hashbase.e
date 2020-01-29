-> hashing module

OPT MODULE

MODULE 'Iterator/iterator'

EXPORT CONST HASH_TINY     = 5,
             HASH_SMALL    = 31,
             HASH_NORMAL   = 211,
             HASH_MEDIUM   = 941,
             HASH_BIG      = 3911,
             HASH_HUGE     = 16267

EXPORT OBJECT hash_base
PRIVATE
  future1:INT
  size:INT
  num_entries:LONG
  entries:PTR TO LONG
ENDOBJECT

PROC get_size() OF hash_base IS self.size

PROC get_entries() OF hash_base IS self.entries

PROC get_num_entries() OF hash_base IS self.num_entries

EXPORT OBJECT hash_link PRIVATE
  next:PTR TO hash_link
  future1:INT
PUBLIC
  hash_value:INT
ENDOBJECT

-> getter
PROC get_next() OF hash_link IS self.next

-> virtual constructor
PROC init(key) OF hash_link IS EMPTY

-> virtual getter
PROC get_key() OF hash_link IS EMPTY

-> virtual method
PROC key_equality(other:PTR TO hash_link) OF hash_link IS EMPTY

-> modulo distribution method for slot selection
PROC hash_slot(link:PTR TO hash_link) OF hash_base
  DEF ret
  ret:=link.hash_value
  ret:=Mod(ret,self.size)
ENDPROC ret

-> base constructor
PROC init(tablesize) OF hash_base
  DEF table:PTR TO LONG
  self.entries:=NEW table[tablesize]
  self.size:=tablesize
  self.num_entries:=0
ENDPROC

-> destructor
PROC end() OF hash_base
  DEF p:PTR TO LONG
  p:=self.entries
  END p[self.size]
ENDPROC

-> destruct all links if desired
PROC end_links(sizeof) OF hash_base
  DEF a,p:PTR TO hash_link,o:PTR TO hash_link
  FOR a:=0 TO self.size-1
    p:=self.entries[a]
    WHILE o:=p
      p:=p.next
      FastDispose(o,sizeof)
    ENDWHILE
  ENDFOR
ENDPROC

-> hashes data, then tries to find entry.
-> returns hash_link
PROC find(key) OF hash_base
  DEF e,count:REG,hlink:PTR TO hash_link,r2,dummylink:PTR TO hash_link
  NEW dummylink.init(key)
  e:=self.entries
  r2:=self.hash_slot(dummylink)
  -> hashvalue found, now do a search
  count:=e+Shl(r2,2)
  WHILE count
    -> link is not NIL
    hlink:=count
    IF hlink.key_equality(dummylink) THEN RETURN hlink
    count:=hlink.next
  ENDWHILE
ENDPROC NIL

-> add a new hash_link
PROC add(link:PTR TO hash_link) OF hash_base
  DEF hashvalue
  hashvalue:=self.hash_slot(link)
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
