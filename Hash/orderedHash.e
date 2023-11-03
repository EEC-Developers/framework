-> hashing module

OPT MODULE

MODULE 'Iterator/iterator','List/singleList','Queue/queue'

EXPORT OBJECT ordered_hash OF hash_base
PRIVATE
  q:PTR TO queue
ENDOBJECT

EXPORT OBJECT ordered_hash_link OF hash_link PRIVATE
ENDOBJECT

OBJECT order_node OF queue_node PRIVATE
  item:PTR TO ordered_hash_link
ENDOBJECT

-> getters
PROC get_queue() OF ordered_hash IS self.q

PROC get_node() OF order_node IS self.item

-> constructor
PROC init_link(key,parent:PTR TO hash_base,value) OF ordered_hash_link
  SUPER self.init_link(key,parent,value)
ENDPROC

PROC remove_from_slot(slot:PTR TO queue) OF ordered_hash
  DEF ret
  ret:=slot.dequeue()
  self.num_items--
ENDPROC ret

-> base constructor
-> comparison is a function pointer of the format:
-> comparison(x:PTR TO hash_link,key):BOOL
PROC init_base(tablesize,comparison,hash_function) OF hash_base
  DEF table:PTR TO LONG,count,q2:PTR TO queue
  NEW table[tablesize]
  FOR count:=0 TO tablesize-1
    NEW q2.init()
    table[count]:=q2
  ENDFOR
  NEW self.q.init()
  SUPER self.initializer(table,tablesize,comparison,hash_function)
ENDPROC

-> add a new hash_link
PROC add(link:PTR TO ordered_hash_link) OF ordered_hash
  DEF hashvalue,entries,q
  hashvalue:=self.hash_slot(link.get_hash_value())
  entries:=self.get_entries(hashvalue)
  entries.enqueue(link)
  self.increment_num_entries()
  q:=self.get_queue()
  q.enqueue(self)
ENDPROC

-> Destructors
PROC end() OF ordered_hash
  END self.get_queue()
  SUPER end()
ENDPROC
  
-> Iterator
EXPORT OBJECT ordered_hash_iterator OF iterator
  iter:PTR TO single_list_iterator
ENDOBJECT

PROC init(me:PTR TO ordered_hash) OF ordered_hash_iterator
  NEW self.iter(me.get_queue())
ENDPROC

PROC next() OF ordered_hash_itorator IS self.iter.next()

PROC get_current_item() OF ordred_hash_iterator
  DEF x:PTR TO order_node
  x:=self.iter.get_current_item()
ENDPROC x.get_node()

-> Constructor
PROC rehash(size,old:PTR TO ordered_hash) OF ordered_hash
  DEF order_q:PTR TO queue,q3:PTR TO queue,
    me:PTR TO order_node,my_node:PTR TO ordered_hash_node
  IF size=old.get_size()
    SUPER self.initializer(old.get_entries(),size,
      old.get_comparison(),old.get_hash_function(),old.get_num_entries())
    self.q:=old.get_queue()
    Dispose(old)
    RETURN
  ENDIF
  NEW self.table[size]
  SUPER self.initializer(table,size,old.get_comparison(),
    old.get_hash_function())
  -> buckets are also ordered, otherwise this wouldn't work
  order_q:=old.get_queue()
  WHILE order_q.get_first()<>NIL    
    me:=order_q.dequeue()
    my_node:=me.get_node()
    q3:=old.get_slot(old.hash_slot(my_node.get_hash_value()))
    Dispose(me)
    self.add(q3.remove_from_slot())
  ENDWHILE
  END old
ENDPROC
