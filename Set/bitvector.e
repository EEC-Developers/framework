OPT MODULE

MODULE 'Iterator/iterator','Set/setBase'

EXPORT OBJECT bitVector OF set PRIVATE
  items:PTR TO LONG -> E-List of host items
  offset:INT -> offset in host object to Int enumerator
  lastitem:INT
  numBuckets:INT
ENDOBJECT

PROC mask(host:PTR TO LONG) OF bitVector
  DEF ret,x:REG
  ret:=List(self.numBuckets)
  x:=self.get_item_num(host)
  IF x>self.lastitem OR x<=0 THEN Raise("ARGS")
  ret[Shr(x,5)]:=Shl(1,x AND 31)
ENDPROC ret

PROC set_item_num(ob,value) OF bitVector IS PutInt(ob+(self.offset),value)

PROC get_item_num(ob) OF bitVector IS Int(ob+(self.offset))

PROC get_items() OF bitVector IS self.items

PROC get_last_item() OF bitVector IS self.lastitem

PROC get_num_buckets() OF bitVector IS self.numBuckets

PROC init(itemlist:PTR TO LONG,i_host) OF bitVector
  DEF y:REG,iter:PTR TO LONG
  y:=ListLen(itemlist)-1
  IF y<0 THEN Raise("ARGS")
  IF y=0 THEN Raise("bset")
  self.items:=itemlist
  self.lastitem:=y
  self.offset:=i_host
  REPEAT -> Enumerate the items
    iter:=ListItem(itemlist,y)
    self.set_item_num(iter,y)
    y--
  UNTIL y<0
ENDPROC

PROC all_mask() OF bitVector
  DEF ret,y:REG,iter:REG
  iter:=0
  ret:=List(self.numBuckets)
  y:=self.lastitem+1
  WHILE y>31
    ret[iter]:=-1
    iter++
    y:=y-32
  ENDWHILE
  ret:=Shl(1,y)-1
ENDPROC ret

EXPORT OBJECT maskList OF subset
PRIVATE
  mask:PTR TO LONG -> E-List of masks
ENDOBJECT

PROC get_mask() OF maskList IS self.mask

PROC is_empty() OF maskList
  DEF x,ret
  ret:=Exists({x},self.mask,`x<>0)
ENDPROC Not(ret)

-> create maskList from list of items
PROC init(parentSet:PTR TO bitVector,members) OF maskList -> constructor
  DEF x:PTR TO LONG,iter:REG,bucket:REG,y:REG,bucketNum:REG
  SUPER self.baseInit(parentSet)
  self.mask:=List(parentSet.get_num_buckets())
  iter:=ListLen(members)
  IF iter=0 THEN Raise('ARGS')
  REPEAT
    iter--
    x:=ListItem(members,iter)
    y:=parentSet.get_item_num(x)
    bucketNum:=Shr(y,5)
    bucket:=self.mask[bucketNum]
    self.mask[bucketNum]:=bucket OR Shl(1,y AND 31)
  UNTIL iter=0
ENDPROC

-> create a maskList with a fixed mask
PROC create(parent:PTR TO bitVector,mask:PTR TO LONG) OF maskList -> constructor
  SUPER self.baseInit(parent)
  self.mask:=mask
ENDPROC

PROC remove(items:PTR TO maskList) OF maskList
  DEF bucket:REG,iter:REG,myParent:PTR TO bitVector
  myParent:=self.get_parent()
  iter:=myParent.numBuckets
  REPEAT
    bucket:=self.mask[iter] AND Not(items.mask[iter])
    self.mask[iter]:=bucket
    iter--
  UNTIL iter<0
ENDPROC

PROC insert(items:PTR TO maskList) OF maskList
  DEF bucket:REG,iter:REG,myParent:PTR TO bitVector
  myParent:=self.get_parent()
  iter:=myParent.numBuckets
  REPEAT
    bucket:=self.mask[iter] OR items.mask[iter]
    self.mask[iter]:=bucket
    iter--
  UNTIL iter<0
ENDPROC
  
PROC has_one(item:PTR TO maskList) OF maskList
  DEF iter:REG,myParent:PTR TO bitVector
  myParent:=self.get_parent()
  iter:=myParent.numBuckets
  REPEAT
    IF self.mask[iter] AND item.mask[iter]<>0 THEN RETURN TRUE
    iter--
  UNTIL iter<0
ENDPROC FALSE

PROC has_all(items:PTR TO maskList) OF maskList
  DEF bucket:REG,iter:REG,myParent:PTR TO bitVector
  myParent:=self.get_parent()
  iter:=myParent.numBuckets
  REPEAT
    bucket:=self.mask[iter] AND items.mask[iter]
    IF bucket<>self.mask[iter] THEN RETURN FALSE
    iter--
  UNTIL iter<0
ENDPROC TRUE

EXPORT OBJECT bitVector_iterator OF set_iterator
PRIVATE
  item:PTR TO LONG
  mask:LONG
  source:PTR TO maskList
  buckets:PTR TO LONG
  bucketNum:LONG
  count:INT
ENDOBJECT

PROC get_current_item() OF bitVector_iterator IS self.item

-> constructor
PROC init(src:PTR TO maskList) OF bitVector_iterator
  self.mask:=1
  self.source:=src
  self.item:=NIL
  self.count:=0
  self.bucketNum:=0
  self.buckets:=src.get_mask()
ENDPROC

PROC next() OF bitVector_iterator
  DEF count:REG,
    last:REG,
    mask:REG,
	bn:REG,
    src:REG PTR TO maskList,
    bv:PTR TO bitVector,
    i:PTR TO LONG
  src:=self.source
  bv:=src.get_parent()
  count:=self.count
  bn:=self.bucketNum
  last:=bv.get_last_item()
  WHILE count <= last -> find next item
    IF self.mask[bn] AND self.buckets[bn] -> found
      i:=bv.get_items()
      self.item:=i[count]
      self.count:=count
	  self.bucketNum:=bn
      RETURN TRUE
    ENDIF
    count++
    mask:=Shl(1,count AND 31)
	IF mask=0
      bn:=Shr(count,5)
	ENDIF
  ENDWHILE
  self.mask:=mask
  self.count:=count
ENDPROC FALSE
