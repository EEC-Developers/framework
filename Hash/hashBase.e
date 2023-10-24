-> hashing module

OPT MODULE

MODULE 'Iterator/iterator','List/singleList','Queue/queue'

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

EXPORT OBJECT hash_link OF queue_node PRIVATE
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

PROC remove_from_slot(slot:PTR TO queue) OF hash_base IS EMPTY

-> modulo distribution method for slot selection
PROC hash_slot(hash_val) OF hash_base
  DEF ret
  ret:=hash_val AND $7FFF -> REMOVE negative sign bit
  ret:=Mod(ret,self.size)
ENDPROC ret

-> base constructor
-> comparison is a function pointer of the format:
-> comparison(x:PTR TO hash_link,key):BOOL
-> PROC init_base(tablesize,comparison) OF hash_base
-> is implemented in intermediate base class due to 
-> ordered/unordered implementation as is constructor
-> PROC rehash(size,self) OF hash_base

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
  DEF a:REG,o:REG PTR TO queue
  FOR a:=0 TO self.size-1
    o:=self.entries[a]
    WHILE o.get_first()<>NIL
      END self.remove_from_slot(o)
    ENDWHILE
  ENDFOR
ENDPROC

-> hashes key, then tries to find entry.
-> returns hash_link
PROC find(key) OF hash_base
  DEF hiter:REG PTR TO single_list_iter,index,h:REG,cmp,
    hlink:=PTR TO hash_link
  h:=self.hash_function(key)
  cmp:=self.compare_key
  index:=self.hash_slot(h)
  -> hashvalue found, now do a search
  NEW hiter.init(self.entries[index])
  WHILE hiter.next()
    hlink:=hiter.get_current_item()
    IF hlink.get_hash_value()=h
      IF cmp(hlink,key)
        END hiter
        RETURN hlink
      ENDIF
    ENDIF
  ENDWHILE
ENDPROC NIL

-> add a new hash_link
PROC add(link:PTR TO hash_link) OF hash_base IS EMPTY
