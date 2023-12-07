-> hashing module

OPT MODULE

MODULE 'Iterator/iterator','List/singleList','List/listBase'

EXPORT CONST HASH_MICRO    = 5,
             HASH_TINY     = 13,
             HASH_SMALL    = 61,
             HASH_NORMAL   = 211,
             HASH_MEDIUM   = 941,
             HASH_BIG      = 3911,
             HASH_HUGE     = 16267

-> signature of hash_func is 
->   hash_func(get_key(link:PTR TO hash_link))
->   which returns an INT as a hash_result
-> signature of compare_key is 
->   compare_key(get_key(link:PTR TO hash_link),get_key(link2:PTR TO hash_link))
->   which returns BOOLEAN where TRUE is equal and FALSE is not
EXPORT OBJECT hash_base
PRIVATE
  future1:INT
  size:INT
  num_entries:LONG
  compare_key -> function pointer
  hash_func -> function pointer
  get_key -> function pointer
  entries:PTR TO LONG
ENDOBJECT

-> getters and setters
PROC get_size() OF hash_base IS self.size

PROC get_entries() OF hash_base IS self.entries

PROC get_slot(i) OF hash_base IS self.entries[i]

PROC get_num_entries() OF hash_base IS self.num_entries

PROC get_comparison() OF hash_base IS self.compare_key

PROC get_hash_function() OF hash_base IS self.hash_func

PROC get_key_get() OF hash_base IS self.get_key

PROC increment_num_entries() OF hash_base
  self.num_entries+=1
ENDPROC

PROC decrement_num_entries() OF hash_base
  self.num_entries-=1
ENDPROC

-> signature for key_getter is key_getter(link:PTR TO hash_link)
->   and returns the key (usually a pointer to an OBJECT)
EXPORT OBJECT hash_link OF single_list_node PRIVATE
  future1:INT
  hash_value:INT
  value
ENDOBJECT

-> getters
PROC get_hash_value() OF hash_link IS self.hash_value

PROC get_value() OF hash_link IS self.value

-> other hash_base method wrappers
PROC compare(link,key) OF hash_base
ENDPROC self.compare_key(self.get_key(link),key)

-> constructor
PROC init_link(key,parent:PTR TO hash_base,value) OF hash_link
  DEF hash_function

  SUPER self.init()
  hash_function:=parent.get_hash_function()
  self.hash_value:=hash_function(key)
  self.value:=value
ENDPROC

PROC remove_from_slot(slot) OF hash_base IS EMPTY

-> modulo distribution method for slot selection
PROC hash_slot(hash_val) OF hash_base
  DEF ret

  ret:=hash_val AND $7FFF -> REMOVE negative sign bit
  ret:=Mod(ret,self.size)
ENDPROC ret

-> base constructor
-> is implemented in intermediate base class due to 
-> ordered/unordered implementation as is constructor
-> PROC rehash(size,self) OF hash_base
PROC initializer(table:PTR TO LONG,tablesize,
    get_key,comparison,hash_func,num=0) OF hash_base
  self.size:=tablesize
  self.entries:=table
  self.num_entries:=num
  self.get_key:=get_key
  self.compare_key:=comparison
  self.hash_func:=hash_func
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
  DEF a:REG,o:REG PTR TO single_list_header,s:REG PTR TO hash_link
  
  FOR a:=0 TO self.size-1
    o:=self.entries[a]
    WHILE o.get_first()<>NIL
      s:=self.remove_from_slot(o)
      END s
    ENDWHILE
  ENDFOR
ENDPROC

-> hashes key, then tries to find entry.
-> returns hash_link
PROC find(key) OF hash_base
  DEF iter:REG PTR TO list_iterator,index,h:REG,cmp,
    link:PTR TO hash_link
  
  h:=self.hash_func(key)
  cmp:=self.compare_key
  index:=self.hash_slot(h)
  -> hashvalue found, now do a search
  NEW iter.init(self.entries[index])
  WHILE iter.next()
    link:=iter.get_current_item()
    IF link.get_hash_value()=h
      IF cmp(self.get_key(link),key)
        END iter
        RETURN link
      ENDIF
    ENDIF
  ENDWHILE
ENDPROC NIL

-> virtual method to add a new hash_link
PROC add(link) OF hash_base IS EMPTY

-> standard hash functions
EXPORT PROC long_hash(key) IS Eor(key AND $FFFF,Shr(key,16))

EXPORT PROC string_hash(key)
  DEF hashvalue:REG, x:REG, y:REG PTR TO CHAR, count:REG
  
  hashvalue:=0
  y:=key
  count:=StrLen(y)
  -> calculate hash function
  WHILE count>0
    ->ROL.W #4,hashvalue
    hashvalue:=Shr(hashvalue,12) OR Shl(hashvalue,4) AND $FFFF
    x:=y[]++
    hashvalue:=Eor(x,hashvalue)
    count--
  ENDWHILE
ENDPROC hashvalue

-> hash of elist of either INT or LONG named composite
->   because it can be an elist of other hash function results
EXPORT PROC composite_hash(key)
  DEF count:REG,hashvalue:REG
  
  hashvalue:=0
  count:=ListLen(key)
  WHILE count>0
    count-=1
    hashvalue:=Eor(hashvalue,ListItem(key,count))
  ENDWHILE
ENDPROC Eor(hashvalue AND $FFFF,Shr(hashvalue,16))
