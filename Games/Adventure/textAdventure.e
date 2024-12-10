OPT MODULE

MODULE 'Filter/filterBase','Filter/textList','Filter/wordWrap',
  'Filter/stringify','Buffer/stringQueue','Hash/hashBase',
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

OBJECT inventory_lister OF text_list_base
ENDOBJECT

EXPORT OBJECT inventory OF subset PRIVATE
ENDOBJECT

-> iterates the names of the items in an inventory
->   instead of the objects themselves
OBJECT inventory_iter OF set_iterator
ENDOBJECT

PROC get_current_item() OF inventory_iter
  DEF item:PTR TO object

  item:=SUPER self.get_current_item()
ENDPROC item.get_name()

-> constructor of dummy mask
PROC create(parent,mask=0) OF inventory
  SUPER self.create(parent,mask)
  self.lister:=NIL
ENDPROC

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

PROC list() OF inventory
  DEF lister:PTR TO inventory_lister,
    iter:REG PTR TO inventory_iterator,
    q:PTR TO string_queue,
    strbuf:PTR TO string_buffer,
    pass:PTR TO stringify,
    filt:PTR TO filter,
    str_q:PTR TO string_queue

  NEW filt.init()
  NEW str_q.init()
  NEW lister.create(filt,'You see ')
  lister.set_output(str_q)
  NEW pass.stage(filt,lister)
  NEW iter.init(self)
  WHILE iter.next()
    q.append(iter.get_current_item())
  ENDWHILE
  self.filt.process(q)
ENDPROC filt.get_output()

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

OBJECT exit_lister OF text_list_base
ENDOBJECT

EXPORT OBJECT exit_list OF unordered_hash PRIVATE
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
PROC create_exit(el:PTR TO exit_list,
    direction:PTR TO CHAR,
    destinaton:PTR TO room) OF exit
  IF destination=NIL THEN Raise("INIT")
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

OBJECT exit_iter OF unordered_hash_iterator
ENDOBJECT

PROC get_current_item() OF exit_iter
  DEF e:PTR TO exit

  e:=SUPER self.get_current_item()
ENDPROC e.get_direction()

PROC list() OF exit_list
  DEF lister:PTR TO exit_lister,
    iter:REG PTR TO exit_iterator,
    q:PTR TO string_queue,
    strbuf:PTR TO string_buffer,
    pass:PTR TO stringify,
    filt:PTR TO filter,
    str_q:PTR TO string_queue

  NEW filt.init()
  NEW str_q.init()
  NEW lister.create(filt,'The exits here are ')
  lister.set_output(str_q)
  NEW pass.stage(filt,lister)
  NEW iter.init(self)
  WHILE iter.next()
    q.append(iter.get_current_item())
  ENDWHILE
  filt.process(q)
ENDPROC filt.get_output()

PROC generate() OF inventory_lister
  DEF work2[80]:STRING,
    out:PTR TO buffer
  out:=self.get_output()
  SELECT self.status
    CASE TEXT_EMPTY
      out.append('no objects.')
    CASE TEXT_SINGULAR
	  StringF(work2,'\s.',work)
      out.append(work2)
    CASE TEXT_PLURAL
      out.append(work)
    CASE TEXT_PLURAL_FINAL
	  StringF(work2,'\s.',work)
      out.append(work2)
    DEFAULT
      Raise("INIT")
  ENDSELECT
ENDPROC

PROC generate() OF exit_lister
  DEF work2[80]:STRING,
    out:PTR TO buffer
  out:=self.get_output()
  SELECT self.status
    CASE TEXT_EMPTY
      out.append('none.')
    CASE TEXT_SINGULAR
	  StringF(work2,'\s.',work)
      out.append(work2)
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
  DEF exits:PTR TO exit_list,
    f:PTR TO filter,
    q:PTR TO string_queue,
    wrap:PTR TO word_wrap,
    paragraphs:PTR TO elist_buffer,
    d:PTR TO elist_iterator,
	o:PTR TO iterator

  NEW paragraphs.init(12)
  NEW f.init()
  NEW d.init(self.description)
  -> add description to paragraphs buffer
  WHILE d.next()
    paragraphs.append(d.get_current_item())
  ENDWHILE
  END d
  -> buffer inventory items
  o:=self.items.list()
  WHILE o.next()
    paragraphs.append(o.get_current_item())
  ENDWHILE
  END o
  -> buffer exit list
  exits:=self.get_room_exits()
  NEW o(exits.list())
  WHILE o.next()
    paragraphs.append(o.get_current_item())
  ENDWHILE
  END o
  -> word wrap all of them
  NEW wrap.create(f,80) -> TODO: change 80 to whatever line length
  f.process(paragraphs)
  o:=f.get_output()
  WHILE o.next()
    WriteF('\s',o.get_current_item())
  ENDWHILE
  END o
  END f
  END paragraphs
  END q
ENDPROC

PROC end() OF room
  self.exits.end_links(SIZEOF exit)
ENDPROC
