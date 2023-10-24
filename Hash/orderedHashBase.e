-> hashing module

OPT MODULE

MODULE 'Iterator/iterator','List/singleList','Queue/queue'

OBJECT order_queue OF queue PRIVATE
ENDOBJECT

EXPORT OBJECT ordered_hash_base OF hash_base
PRIVATE
  q:PTR TO order_queue
ENDOBJECT

EXPORT OBJECT ordered_hash_link OF hash_link PRIVATE
ENDOBJECT

OBJECT order_node OF queue_node PRIVATE
  item:PTR TO ordered_hash_link
ENDOBJECT

-> getters
PROC get_queue() OF ordered_hash_base IS self.q

PROC get_node() OF order_node IS self.item

-> constructor
PROC init(key,parent:PTR TO hash_base) OF ordered_hash_link
  SUPER self.init()
ENDPROC

PROC remove_from_slot(slot:PTR TO queue) OF ordered_hash_base
  DEF ret
  ret:=slot.dequeue()
  self.num_items--
ENDPROC ret

-> base constructor
-> comparison is a function pointer of the format:
-> comparison(x:PTR TO hash_link,key):BOOL
PROC init_base(tablesize,comparison) OF hash_base
  DEF table:PTR TO LONG,count,q2:PTR TO queue
  NEW table[tablesize]
  self.entries:=table
  FOR count:=0 TO tablesize-1
    NEW q2.init()
    table[count]:=q2
  ENDFOR
  self.size:=tablesize
  NEW self.q.init()
  self.num_entries:=0
  self.compare_key:=comparison
ENDPROC

-> add a new hash_link
PROC add(link:PTR TO ordered_hash_link) OF ordered_hash_base
  DEF hashvalue
  hashvalue:=self.hash_slot(link.get_hash_value())
  self.entries[hashvalue].enqueue(link)
  self.num_entries++
  self.q.enqueue(self)
ENDPROC

-> Iterator
EXPORT OBJECT ordered_hash_iterator OF iterator
  iter:PTR TO single_list_iterator
ENDOBJECT

PROC init(me:PTR TO ordered_hash_base) OF ordered_hash_iterator
  NEW self.iter(me.get_queue())
ENDPROC

PROC next() OF ordered_hash_itorator IS self.iter.next()

PROC get_current_item() OF ordred_hash_iterator
  DEF x:PTR TO order_node
  x:=self.i.get_current_item()
ENDPROC x.get_node()

-> Constructor
PROC rehash(size,old:PTR TO ordered_hash_base) OF ordered_hash_base
  DEF old_iter:PTR TO ordered_hash_iterator,
    q3:PTR TO queue,me:PTR TO ordered_hash_link
  CopyMem(old,self,sizeof ordered_hash_base)
  IF size=old.get_size()
    Dispose(old)
    RETURN
  ENDIF
  NEW self.table[size]
  self.size:=size
  NEW old_iter.init(self)
  -> buckets are also ordered, otherwise this wouldn't work
  WHILE old_iter.next()
    me:=old_iter.get_current_item()
    q3:=hash_slot(me.get_hash_value())
    self.add(q3.remove_from_slot())
  ENDWHILE
  END old
ENDPROC
