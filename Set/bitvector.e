OPT MODULE

EXPORT ENUM I_GET, I_SET

EXPORT OBJECT bitset PRIVATE
  items:PTR TO LONG -> E-List of host items
  i_itemnum:LONG -> interface to host object
  lastitem:INT
ENDOBJECT

/*PROC mask(host:PTR TO LONG) OF bitset
  DEF ret:PTR TO LONG,x:REG,y,count:REG

  count:=Shr(x,5) -> high 16 bits
  x:=x AND 31 -> low 5 bits
  ret:=NewR(Shr(self.lastitem,5))
  ret[count]:=Shl(1,x)
ENDPROC
*/

PROC get_last() OF bitset IS self.lastitem

PROC get_items() OF bitset IS self.items

PROC get_item_num(item) OF bitset
  DEF x,ret:REG
  x:=ListItem(self.i_itemnum,I_GET)
  ret:=x(item)
ENDPROC ret

PROC set_item_num(item,value) OF bitset
  DEF x
  x:=ListItem(self.i_itemnum,I_SET)
  x(item,value)
ENDPROC

PROC get_num_buckets() OF bitset IS Shr(self.lastitem,5)

PROC init(itemlist:PTR TO LONG,i_host) OF bitset
  DEF y:REG,iter:PTR TO LONG
  y:=ListLen(itemlist)-1
  IF y<0 THEN Raise("ARGS")
  IF y=0 OR y>65535 THEN Raise("bset")
  self.items:=itemlist
  self.lastitem:=y
  self.i_itemnum:=i_host
  REPEAT -> Enumerate the items
    iter:=itemlist[y]
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
  mask:PTR TO LONG
ENDOBJECT

PROC get_parent() OF subset IS self.parent

PROC get_mask() OF subset IS self.mask

PROC init(parent:PTR TO bitset,members) OF subset -> constructor
  DEF x:PTR TO LONG,iter,count:REG,index:REG
  self.parent:=parent
  count:=Shr(parent.lastitem,5)
  self.mask:=NewR(count)
  iter:=ListLen(members)
  IF iter=0 THEN Raise('ARGS') 
  REPEAT
    iter--
    x:=ListItem(members,iter)
    count:=x AND 31
    index:=Shr(x,5)
    self.mask[index]:=self.mask[index] OR Shl(1,count)
  UNTIL iter=0
ENDPROC

PROC has_a(myitem:PTR TO LONG) OF subset
  DEF ret:REG,
    x:PTR TO bitset,
    count:REG,
    bucket:PTR TO LONG,
    y:REG
  x:=self.parent
  y:=x.get_item_num(myitem)
  count:=Shr(y,5)
  bucket:=self.get_mask()
  ret:=y AND 31 AND bucket[count]
ENDPROC ret

PROC is_empty() OF subset
  DEF count:REG,ret:REG,parent:PTR TO bitset,mask:PTR TO LONG
  mask:=self.mask
  parent:=self.get_parent()
  count:=parent.get_num_buckets()
  WHILE mask[]++=0 DO count--
  ret:=count>0
ENDPROC ret

PROC add_item(myitem:PTR TO LONG) OF subset
  DEF count:REG,x:PTR TO bitset,bucket:REG,y:REG
  x:=self.parent
  y:=x.get_item_num(myitem)
  count:=Shr(y,5)
  bucket:=self.mask[count] OR Shl(1,(y AND 31))
  self.mask[count]:=bucket
ENDPROC

PROC remove_item(myitem:PTR TO LONG) OF subset
  DEF count:REG,y:REG,x:PTR TO bitset,bucket:PTR TO LONG
  x:=self.parent
  y:=x.get_item_num(myitem)
  count:=Shr(y,5)
  bucket:=self.mask[count] AND Not(Shl(1,(y AND 31)))
  self.mask[count]:=bucket
ENDPROC

PROC give(myitem:PTR TO LONG, destination:PTR TO subset) OF subset
  DEF ret
  ret:=FALSE
  IF self.has_a(myitem)
    self.remove_item(myitem)
    destination.add_item(myitem)
    ret:=TRUE
  ENDIF
ENDPROC ret

PROC create(parent:PTR TO bitset,mask=0) OF subset -> constructor
  DEF size:REG
  size:=parent.get_num_buckets()*SIZEOF LONG
  self.parent:=parent
  IF mask
    CopyMem(mask,NewR(size),size)
  ELSE
    self.mask:=NewR(size)
  ENDIF
ENDPROC

PROC take(myitem:PTR TO LONG, source:PTR TO subset) OF subset
ENDPROC source.give(myitem, self)

PROC has_all(things:PTR TO subset) OF subset
  DEF ret:REG,count:REG,
    src:PTR TO LONG,src2:PTR TO LONG,
    parent:PTR TO bitset
  parent:=self.parent
  IF parent<>things.get_parent() THEN Raise("ARGS")
  count:=parent.get_num_buckets()
  src:=self.mask
  src2:=things.get_mask()
  WHILE count>0 AND src[]++=src2[]++ DO count--
  ret:=(count=0)
ENDPROC ret

PROC has_one(things:PTR TO subset) OF subset
  DEF ret:REG,count:REG,
    src:PTR TO LONG,src2:PTR TO LONG,
    parent:PTR TO bitset
  parent:=self.parent
  IF parent<>things.get_parent() THEN Raise("ARGS")
  count:=parent.get_num_buckets()
  src:=self.mask
  src2:=things.get_mask()
  WHILE count>0 AND And(src[]++,src2[]++)=0 DO count--
  ret:=(count<>0)
ENDPROC ret

EXPORT OBJECT bitset_iterator
  item:PTR TO LONG
PRIVATE
  iter:PTR TO LONG
  mask:LONG
  source:PTR TO subset
  count:INT
ENDOBJECT

PROC init(src:PTR TO subset) OF bitset_iterator -> constructor
  self.mask:=1
  self.source:=src
  self.item:=NIL
  self.count:=0
  self.iter:=src.get_mask()
ENDPROC

PROC next() OF bitset_iterator
  DEF ret:REG,bits:REG,field:REG,
    src:PTR TO subset,bs:PTR TO bitset,i:PTR TO LONG
  src:=self.source
  ret:=FALSE
  bs:=src.get_parent()
  field:=self.iter[]
  WHILE self.count<bs.get_last() AND Not(ret) -> find next item
    IF self.mask AND field -> found
      i:=bs.get_items()
      self.item:=i[self.count]
      ret:=TRUE
    ENDIF
    self.count++
    bits:=self.count AND 31
    self.mask:=Shl(1,bits)
    IF bits=0
      self.iter:=self.iter+SIZEOF LONG -> must not postincrement self
      field:=self.iter[]
    ENDIF
  ENDWHILE
ENDPROC ret
