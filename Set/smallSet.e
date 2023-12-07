OPT MODULE

MODULE 'Iterator/iterator','Set/setBase'

EXPORT OBJECT smallSet OF set PRIVATE
  items:PTR TO LONG -> E-List of host items
  offset:INT -> offset in host object to Int enumerator
  lastitem:INT
ENDOBJECT

PROC mask(host:PTR TO LONG) OF smallSet
  DEF ret:REG,x:REG
  x:=self.get_item_num(host)
  IF x>self.lastitem THEN Raise("ARGS")
  ret:=Shl(1,x)
ENDPROC ret

PROC set_item_num(ob,value) OF smallSet IS PutInt(ob+self.offset,value)

PROC get_item_num(ob) OF smallSet IS Int(ob+self.offset)

PROC get_items() OF smallSet IS self.items

PROC get_last_item() OF smallSet IS self.lastitem

PROC init(itemlist:PTR TO LONG,i_host) OF smallSet
  DEF y:REG,iter:PTR TO LONG
  y:=ListLen(itemlist)-1
  IF y>31 OR y<=0 THEN Raise("bset")
  self.items:=itemlist
  self.lastitem:=y
  self.offset:=i_host
  REPEAT -> Enumerate the items
    iter:=ListItem(itemlist,y)
    self.set_item_num(iter,y)
    y--
  UNTIL y<0
ENDPROC

PROC all_mask() OF smallSet
  DEF ret:REG,y:REG
  y:=self.lastitem+1
  ret:=Shl(1,y)-1
ENDPROC ret

EXPORT OBJECT subSmallSet OF subset
PRIVATE
  mask:LONG
ENDOBJECT

PROC get_mask() OF subSmallSet IS self.mask

PROC is_empty() OF subSmallSet IS self.mask=0

-> create subSmallSet from list of items
PROC init(parentSet:PTR TO smallSet,members) OF subSmallSet -> constructor
  DEF x:PTR TO LONG,iter:REG,y:REG
  SUPER self.baseInit(parentSet)
  self.mask:=0
  iter:=ListLen(members)
  IF iter=0 THEN Raise('ARGS') 
  REPEAT
    iter--
    x:=ListItem(members,iter)
    y:=parentSet.get_item_num(x)
    self.mask:=self.mask OR parentSet.mask(y)
  UNTIL iter=0
ENDPROC

-> create a subSmallSet with a fixed mask
PROC create(parent:PTR TO LONG,mask=0) OF subSmallSet -> constructor
  SUPER self.baseInit(parent)
  self.mask:=mask
ENDPROC

PROC remove(items:PTR TO subSmallSet) OF subSmallSet
  self.mask:=self.mask AND Not(items.mask)
ENDPROC

PROC insert(items:PTR TO subSmallSet) OF subSmallSet
  self.mask:=self.mask OR items.mask
ENDPROC
  
PROC has_one(item:PTR TO subSmallSet) OF subSmallSet
  DEF ret:REG
  ret:= (self.mask AND item.mask)<>0
ENDPROC ret

PROC has_all(items:PTR TO subSmallSet) OF subSmallSet
  DEF ret:REG
  ret:=(self.mask AND items.mask)=items.mask
ENDPROC ret

EXPORT OBJECT smallSet_iterator OF set_iterator
PRIVATE
  item:PTR TO LONG
  mask:LONG
  source:PTR TO subSmallSet
  count:INT
ENDOBJECT

PROC get_current_item() OF smallSet_iterator IS self.item

-> constructor
PROC init(src:PTR TO subSmallSet) OF smallSet_iterator
  self.mask:=1
  self.source:=src
  self.item:=NIL
  self.count:=0
ENDPROC

PROC next() OF smallSet_iterator
  DEF count:REG,
    last:REG,
    mask:REG,
    src:REG PTR TO subSmallSet,
    bs:PTR TO smallSet,
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
