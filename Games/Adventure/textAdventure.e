OPT MODULE

MODULE 'Filter/filterBase','Filter/textList','Filter/wordWrap',
  'Buffer/stringQueue','Hash/hashBase',
  'Hash/unorderedHash','Set/setBase','Set/bitVector',
  'Iterator/iterator','Iterator/elist'

EXPORT OBJECT object OF hash_link
  name:PTR TO CHAR
  set_handle
ENDOBJECT

PROC get_name() OF object IS self.name

PROC get_set_handle() OF object IS self.set_handle

PROC set_set_handle(v) OF object IS self.set_handle:=v

PROC get_set_handler(parent:PTR TO bit_vector,o:PTR TO object)
ENDPROC o.get_set_handle()

PROC set_set_handler(parent:PTR TO bit_vector,o:PTR TO object,v)
  o.set_set_handle(v)

PROC object_name(o:PTR TO object) IS o.get_name()

PROC name_compare(o:PTR TO object,s:PTR TO CHAR)
ENDPROC StrCmp(o.name,s)=0

-> constructor
PROC generate(name:PTR TO CHAR) OF object
  SUPER self.init(name)
ENDPROC

EXPORT OBJECT inventory OF subset
ENDOBJECT

-> constructor
PROC create(parent,mask=0) OF inventory IS SUPER self.create(parent,mask)

-> constructor
PROC init(parent:PTR TO bit_vector,list:PTR TO LONG) OF inventory
  SUPER self.init(parent,list)
ENDPROC

PROC give(item:PTR TO object, destination:PTR TO inventory) OF inventory
  DEF ret:REG,item_set:PTR TO inventory

  NEW item_set.create(self.get_parent(),item.get_mask())
  ret:=FALSE
  IF self.has_one(item_set)
    self.remove(item_set)
    destination.insert(item_set)
    ret:=TRUE
  ENDIF
  END item_set
ENDPROC ret

PROC take(myitem:PTR TO object, source:PTR TO inventory) OF inventory
ENDPROC source.give(myitem, self)

EXPORT OBJECT master_list OF unordered_hash PRIVATE
  all:PTR TO inventory
ENDOBJECT

PROC get_all() OF master_list IS self.all

-> constructor
PROC init_master_list(object_list) OF master_list
  DEF x:PTR TO bit_vector,y:PTR TO object,z:PTR TO inventory,
    obj:PTR TO elist_iterator

  SUPER self.init(HASH_SMALL,{get_name},{name_compare},{string_hash})
  NEW x.init(object_list,{get_set_handler},{set_set_handler})
  NEW z.create(x,x.all_mask())
  self.all:=z
  NEW obj.init(object_list)
  WHILE obj.next()
    self.add(obj.get_current_item())
  ENDWHILE
  END obj
ENDPROC

EXPORT OBJECT exit_list OF unordered_hash
ENDOBJECT

EXPORT OBJECT room
  exits:PTR TO exit_list
  items:PTR TO inventory
  description -> elist of estrings
ENDOBJECT

EXPORT OBJECT exit OF hash_link PRIVATE
  dir:PTR TO CHAR
ENDOBJECT

PROC get_direction() OF exit IS self.dir

PROC exit_compare(e:PTR TO exit,d) IS StrCmp(e.get_direction(),d)=0

PROC exit_get_direction(e:PTR TO exit) IS e.get_direction()

-> constructor
-> note that destination is not allowed to be NIL
PROC create_exit(el:PTR TO exit_list,
    direction:PTR TO CHAR,
    destinaton:PTR TO room) OF exit
  SUPER self.init_link(direction,el,destination)
  el.add(self)
ENDPROC

-> go_to method
-> returns a room or NIL if invalid exit
PROC go_to(direction:PTR TO CHAR) OF room 
  DEF el:PTR TO exit_list,e:PTR TO exit

  el:=self.exits
  e:=el.find(direction)
  IF e THEN RETURN e.get_value()
ENDPROC NIL

-> constructor
->    For rooms with more than 3 or 4 exits, increase the hash_size to HASH_TINY
->    dexcribe is an elist of estrings, one estring per paragraph
PROC init(describe,stuff:PTR TO inventory,
    hash_size=HASH_MICRO) OF room
  DEF x:PTR TO exit_list

  NEW x.init(hash_size,{exit_get_direction},{exit_compare},{string_hash})
  self.description:=describe
  self.exits:=x
  self.items:=stuff
ENDPROC

PROC get_room_inventory() OF room IS self.items

PROC get_room_exits() OF room IS self.exits

OBJECT inventory_iter OF set_iterator
ENDOBJECT

PROC get_current_item() OF inventory_iter
  DEF item:PTR TO object

  item:=SUPER self.get_current_item()
ENDPROC item.get_name()

OBJECT exit_iter OF unordered_hash_iterator
ENDOBJECT

PROC get_current_item() OF exit_iter
  DEF e:PTR TO exit

  e:=SUPER self.get_current_item()
ENDPROC e.get_direction()

OBJECT inventory_lister OF text_list_base
ENDOBJECT

PROC generate() OF inventory_lister
  DEF work2[80]:STRING,
    out:PTR TO buffer
  out:=self.get_output()
  SELECT self.status
    CASE TEXT_EMPTY
      out.append('no objects.')
    CASE TEXT_SINGULAR
      out.append(work)
    CASE TEXT_PLURAL
      out.append(work)
    CASE TEXT_PLURAL_FINAL
	  StringF(work2,'\s.',work)
      out.append(work2)
    DEFAULT
      Raise("INIT")
  ENDSELECT
ENDPROC

OBJECT exit_lister OF text_list_base
ENDOBJECT

PROC generate() OF exit_lister
  DEF work2[80]:STRING,
    out:PTR TO buffer
  out:=self.get_output()
  SELECT self.status
    CASE TEXT_EMPTY
      out.append('none.')
    CASE TEXT_SINGULAR
      out.append(work)
    CASE TEXT_PLURAL
      out.append(work)
    CASE TEXT_PLURAL_FINAL
	  StringF(work2,'\s.',work)
      out.append(work2)
    DEFAULT
      Raise("INIT")
  ENDSELECT
ENDPROC

-> look method prints description, lists items and lists exits
PROC look() OF room
  DEF i:PTR TO inventory,
    exits:PTR TO exit_iter,
    inv:PTR TO inventory_iter,
    p:PTR TO bit_vector,
    f:PTR TO filter,
    q:PTR TO string_queue,
    q1:PTR TO string_queue,
    s_buf:PTR TO string_buffer,
    wrap:PTR TO word_wrap,
    paragraphs:PTR TO elist_buffer,
    room_inv:PTR TO elist_buffer,
    d:PTR TO elist_iterator,
	f2:PTR TO filter,
	list:PTR TO inventory_lister,
    f3:PTR TO filter,
    exit_list:PTR TO exit_lister,
    e:PTR TO exit,
	o:PTR TO iterator

  i:=self.items
  p:=i.get_parent()
  NEW inv.init(i)
  NEW stuff_iter.init(i)
  NEW paragraphs.init(12)
  NEW f.init()
  NEW f2.init()
  NEW f3.init()
  NEW q.init()
  NEW q1.init()
  NEW s_buf.init(2048)
  NEW s_buf2.init(2048)
  NEW inv_buffer.init(p.get_last_item())
  NEW list.create(f2,s_buf,'You see ')
  f2.enqueue(list)
  NEW exit_list(f3,s_buf2,'The exits here are ')
  f3.enqueue(exit_list)
  NEW d.init(self.description)
  -> add description to paragraphs buffer
  WHILE d.next()
    paragraphs.append(d.get_current_item())
  ENDWHILE
  END d
  -> buffer inventory items
  WHILE inv.next()
    inv_buffer.append(inv.get_current_item())
  ENDWHILE
  END inv
  -> buffer exit list
  NEW exits.init(self.get_room_exits())
  WHILE exits.next()
    e:=exits.get_current_item()
    q1.append(e.get_direction())
  ENDWHILE
  END exits
  -> list inventory filter
  NEW d.init(inv_buffer)
  f2.process(d)
  END d
  paragraphs.append(s_buf)
  -> list exit filter
  f3.process(q1)
  paragraphs.append(s_buf2)
  -> word wrap all of them
  NEW wrap.create(f,q,80) -> TODO: change 80 to whatever line length
  f.enqueue(wrap)
  f.process(paragraphs)
  o:=f.get_output()
  WHILE o.next()
    WriteF('\s',o.get_current_item())
  ENDWHILE
  END o
  END f
  END f2
  END f3
  END paragraphs
ENDPROC

PROC end() OF room
  self.exits.end_links(SIZEOF exit)
ENDPROC
