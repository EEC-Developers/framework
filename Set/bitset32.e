OPT MODULE

MODULE 'Iterator/iterator'

EXPORT OBJECT bitset PRIVATE
  items:PTR TO LONG -> E-List of host items
  offset:INT -> offset in host object to Int enumerator
  lastitem:INT
ENDOBJECT

PROC mask(host:PTR TO LONG) OF bitset
  DEF ret:REG,x:REG
  x:=self.get_item_num(host)
  IF x>self.lastitem THEN Raise("ARGS")
  ret:=Shl(1,x)
ENDPROC ret

PROC set_item_num(ob,value) OF bitset IS PutInt(ob+self.offset,value)

PROC get_item_num(ob) OF bitset IS Int(ob+self.offset)

PROC get_items() OF bitset IS self.items

PROC get_last_item() OF bitset IS self.lastitem

PROC init(itemlist:PTR TO LONG,i_host) OF bitset
  DEF y:REG,iter:PTR TO LONG
  y:=ListLen(itemlist)-1
  IF y<0 THEN Raise("ARGS")
  IF y>31 OR y=0 THEN Raise("bset")
  self.items:=itemlist
  self.lastitem:=y
  self.offset:=i_host
  REPEAT -> Enumerate the items
    iter:=ListItem(itemlist,y)
    self.set_item_num(iter,y)
    y--
  UNTIL y<0
ENDPROC

PROC all_mask() OF bitset
  DEF ret:REG,y:REG
  y:=self.lastitem+1
  ret:=Shl(1,y)-1
ENDPROC ret

EXPORT OBJECT subset
PRIVATE
  parent:PTR TO bitset
  mask:LONG
ENDOBJECT

PROC get_parent() OF subset IS self.parent

PROC get_mask() OF subset IS self.mask

PROC is_empty() OF subset IS self.mask=0

-> create subset from list of items
PROC init(parent:PTR TO bitset,members) OF subset -> constructor
  DEF x:PTR TO LONG,iter:REG
  self.parent:=parent
  self.mask:=0
  iter:=ListLen(members)
  IF iter=0 THEN Raise('ARGS') 
  REPEAT
    iter--
    x:=ListItem(members,iter)
    self.mask:=self.mask OR parent.mask(x)
  UNTIL iter=0
ENDPROC

-> create a subset with a fixed mask
PROC create(parent:PTR TO LONG,mask=0) OF subset -> constructor
  self.parent:=parent
  self.mask:=mask
ENDPROC

PROC remove(things:PTR TO subset) OF subset
  self.mask:=self.mask AND Not(things.mask)
ENDPROC

PROC insert(things:PTR TO subset) OF subset
  self.mask:=self.mask OR things.mask
ENDPROC
  
PROC has_one(things:PTR TO subset) OF subset
  DEF ret:REG
  ret:= (self.mask AND things.mask)<>0
ENDPROC ret

PROC has_all(stuff:PTR TO subset) OF subset
  DEF ret:REG
  ret:=(self.mask AND stuff.mask)=stuff.mask
ENDPROC ret

EXPORT OBJECT bitset_iterator OF iterator
PRIVATE
  item:PTR TO LONG
  mask:LONG
  source:PTR TO subset
  count:INT
ENDOBJECT

PROC get_current_item() OF bitset_iterator IS self.item

-> constructor
PROC init(src:PTR TO subset) OF bitset_iterator
  self.mask:=1
  self.source:=src
  self.item:=NIL
  self.count:=0
ENDPROC

PROC next() OF bitset_iterator
  DEF count:REG,
    last:REG,
    mask:REG,
    src:REG PTR TO subset,
    bs:PTR TO bitset,
    i:PTR TO LONG
  src:=self.source
  bs:=src.get_parent()
  count:=self.count
  last:=bs.get_last_item()
  mask:=self.mask
  WHILE count <= last -> find next item
    IF src.get_mask() AND mask -> found
      i:=bs.get_items()
      self.mask:=mask
      self.item:=i[count]
      self.count:=count
      RETURN TRUE
    ENDIF
    count++
    mask:=Shl(1,count)
  ENDWHILE
  self.mask:=mask
  self.count:=count
ENDPROC FALSE
