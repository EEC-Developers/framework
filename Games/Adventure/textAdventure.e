OPT MODULE

MODULE 'Set/setBase','TextUtilites/textList','TextUtilities/wordWrap',
  'Hash/stringHash','Hash/hashBase','iterator/Iterator'

EXPORT OBJECT object OF string_hash_link
  sethandle:INT
ENDOBJECT

PROC get_mask() OF object IS Shl(1,self.sethandle)

-> constructor
PROC generate(name:PTR TO CHAR) OF object
  SUPER self.init(name)
  self.sethandle:=0
ENDPROC

EXPORT OBJECT inventory OF subset
ENDOBJECT

-> constructor
PROC create(parent,mask=0) OF inventory IS SUPER self.create(parent,mask)

-> constructor
PROC init(parent:PTR TO setBase,list:PTR TO LONG) OF inventory IS SUPER self.init(parent,list)

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

EXPORT OBJECT master_list OF string_hash PRIVATE
  all:PTR TO inventory
ENDOBJECT

PROC get_all() OF master_list IS self.all

-> constructor
PROC init_master_list(object_list) OF master_list
  DEF x:PTR TO setBase,y:PTR TO object,z:PTR TO inventory
  SUPER self.init(HASH_SMALL)
  NEW x.init(object_list,OFFSETOF object.sethandle)
  NEW z.create(x,x.all_mask())
  self.all:=z
  ForAll({y},object_list,`self.add(y)) -> hash index objects
ENDPROC

EXPORT OBJECT exit_list OF string_hash
ENDOBJECT

EXPORT OBJECT room
  exits:PTR TO exit_list
  items:PTR TO inventory
  description:PTR TO CHAR
ENDOBJECT

EXPORT OBJECT exit OF string_hash_link PRIVATE
  portal:PTR TO room
ENDOBJECT

-> constructor
-> note that it is not called init
PROC create_exit(el:PTR TO exit_list,
    direction:PTR TO CHAR,
    destinaton:PTR TO room) OF exit
  SUPER self.init(direction)
  self.portal:=destinaton
  el.add(self)
ENDPROC

-> getter to move to exit
PROC get_portal() OF exit IS self.portal

-> go_to method
-> returns an exit or NIL if invalid exit
PROC go_to(direction:PTR TO CHAR) OF room 
  DEF el:PTR TO exit_list
  el:=self.exits
ENDPROC el.find(direction)

-> constructor
-> set hash_size to HASH_SMALL if there's more than 8 exits or so
PROC init(describe:PTR TO CHAR,stuff:PTR TO inventory,hash_size=HASH_TINY) OF room
  DEF x:PTR TO exit_list
  NEW x.init(hash_size)
  self.description:=describe
  self.exits:=x
  self.items:=stuff
ENDPROC

PROC get_room_inventory() OF room IS self.items

PROC get_room_exits() OF room IS self.exits

EXPORT PROC wrap(format,var)
  StringF(outbuffer2,format,var)
  IF EstrLen(outbuffer)+EstrLen(outbuffer2)>MAXWIDTH
    WriteF('\s',outbuffer)
    StrCopy(outbuffer,outbuffer2)
  ELSE
    StrAdd(outbuffer,outbuffer2)
  ENDIF
ENDPROC

EXPORT PROC flush_wrap()
  WriteF('\s\n\n',outbuffer)
  StrCopy(outbuffer,NIL,0)
ENDPROC

PROC list(iter:PTR TO iterator,
  singular:PTR TO CHAR,
  plural:PTR TO CHAR,
  generate,
  structure)
  DEF item1:REG,item2:REG
  IF iter.next()
    item1:=iter.get_current_item()
    IF iter.next()
      item2:=iter.get_current_item()
      wrap('\s:\n',plural)
      flush_wrap()
      WHILE iter.next()
        generate(structure,'\s, ',item1)
        item1:=item2
        item2:=iter.get_current_item()
      ENDWHILE
      generate(structure,'\s and ',item1)
      generate(structure,'\s.\n',item2)
    ELSE
      wrap('\s:\n',singular)
      flush_wrap()
      generate(structure,'\s.\n',item1)
    ENDIF
  ELSE
    wrap('\s:\nNONE.\n',plural)
  ENDIF
  flush_wrap()
ENDPROC

PROC inventory_wrap(structure:PTR TO setBase,format,var)
  wrap(format,ListItem(structure.get_items(),var))
ENDPROC

PROC exit_wrap(structure,format,var:PTR TO exit) IS wrap(format,var.get_key())

-> look method prints description, lists items and lists exits
PROC look() OF room
  DEF stuff:PTR TO bitset_iterator,
    exits:PTR TO hash_iterator,
    i:PTR TO inventory,
    p:PTR TO setBase
  i:=self.items
  p:=i.get_parent()
  NEW stuff.init(i)
  wrap('%s', self.description)
  flush_wrap()
  list(stuff,'Item','Items',{inventory_wrap},p)
  END stuff -> close iterator
  NEW exits.init(self.exits)
  list(exits,'Exit','Exits',{exit_wrap},NIL)
  END exits -> close iterator
ENDPROC

PROC end() OF room
  self.exits.end_links(SIZEOF exit)
ENDPROC
