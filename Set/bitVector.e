OPT MODULE

MODULE 'Iterator/iterator','Set/setBase'

/* The form of the item_num_getter function is:
PROC getter(me:PTR TO bit_vector,object)
  and the item_num_setter function is:
PROC setter(me:PTR TO bit_vector,object,number)
Both functions should refer to the same field in 
  the destination object.
Note that since the setter is used only in the constructor,
  it is not stored in the bit_vector.
*/
EXPORT OBJECT bit_vector PRIVATE
  items:PTR TO LONG -> array of host items
  last_item
  num_buckets
  item_num_getter -> function pointer
ENDOBJECT

PROC mask(host:PTR TO LONG) OF bit_vector
  DEF ret,x:REG

  ret:=NewR(Mul(SIZEOF LONG,self.num_buckets))
  x:=self.get_item_num(host)
  IF x>self.last_item OR x<=0 THEN Raise("RNG")
  ret[Shr(x,5)]:=Shl(1,x AND 31)
ENDPROC ret

PROC get_item_num(ob) OF bit_vector
  DEF getter

  getter:=self.item_num_getter
ENDPROC getter(self,ob)

PROC get_items() OF bit_vector IS self.items

PROC get_last_item() OF bit_vector IS self.last_item

PROC get_num_buckets() OF bit_vector IS self.num_buckets

PROC init(item_list:PTR TO LONG,getter,setter) OF bit_vector
  DEF y:REG,iter:PTR TO LONG

  y:=ListLen(item_list)-1
  IF y<=0 THEN Raise("RNG")
  self.items:=item_list
  self.last_item:=y
  self.item_num_getter:=getter
  -> Enumerate the items
  REPEAT
    iter:=ListItem(item_list,y)
    setter(self,iter,y)
    y-=1
  UNTIL y<0
ENDPROC

PROC all_mask() OF bit_vector
  DEF ret,y:REG,iter:REG

  iter:=0
  ret:=NewR(Mul(SIZEOF LONG,self.num_buckets))
  y:=self.last_item+1
  WHILE y>31
    ret[iter]:=-1
    iter+=1
    y:=y-32
  ENDWHILE
  ret:=Shl(1,y)-1
ENDPROC ret

EXPORT OBJECT mask_list OF subset
PRIVATE
  mask:PTR TO LONG -> array of mask buckets
ENDOBJECT

PROC get_mask() OF mask_list IS self.mask

PROC is_empty() OF mask_list
  DEF x,ret:REG

  ret:=Exists({x},self.mask,`x<>0)
ENDPROC Not(ret)

-> constructor
-> create mask_list from list of items
PROC init(parent_set:PTR TO bit_vector,members) OF mask_list
  DEF x:PTR TO LONG,iter:REG,bucket:REG,y:REG,bucket_num:REG
  SUPER self.base_init(parent_set)
  self.mask:=List(parent_set.get_num_buckets())
  iter:=ListLen(members)
  IF iter=0 THEN Raise('RNG')
  REPEAT
    iter--
    x:=ListItem(members,iter)
    y:=parent_set.get_item_num(x)
    bucket_num:=Shr(y,5)
    bucket:=self.mask[bucket_num]
    self.mask[bucket_num]:=bucket OR Shl(1,y AND 31)
  UNTIL iter=0
ENDPROC

-> create a mask_list with a fixed mask
PROC create(parent:PTR TO bit_vector,mask:PTR TO LONG) OF mask_list -> constructor
  SUPER self.base_init(parent)
  self.mask:=mask
ENDPROC

PROC remove(items:PTR TO mask_list) OF mask_list
  DEF bucket:REG,iter:REG,myParent:PTR TO bit_vector
  myParent:=self.get_parent()
  iter:=myParent.num_buckets
  REPEAT
    bucket:=self.mask[iter] AND Not(items.mask[iter])
    self.mask[iter]:=bucket
    iter-=1
  UNTIL iter<0
ENDPROC

PROC insert(items:PTR TO mask_list) OF mask_list
  DEF bucket:REG,iter:REG,myParent:PTR TO bit_vector
  myParent:=self.get_parent()
  iter:=myParent.num_buckets
  REPEAT
    bucket:=self.mask[iter] OR items.mask[iter]
    self.mask[iter]:=bucket
    iter-=1
  UNTIL iter<0
ENDPROC
  
PROC has_one(item:PTR TO mask_list) OF mask_list
  DEF iter:REG,myParent:PTR TO bit_vector
  myParent:=self.get_parent()
  iter:=myParent.num_buckets
  REPEAT
    IF self.mask[iter] AND item.mask[iter]<>0 THEN RETURN TRUE
    iter-=1
  UNTIL iter<0
ENDPROC FALSE

PROC has_all(items:PTR TO mask_list) OF mask_list
  DEF bucket:REG,iter:REG,myParent:PTR TO bit_vector
  myParent:=self.get_parent()
  iter:=myParent.num_buckets
  REPEAT
    bucket:=self.mask[iter] AND items.mask[iter]
    IF bucket<>self.mask[iter] THEN RETURN FALSE
    iter-=1
  UNTIL iter<0
ENDPROC TRUE

EXPORT OBJECT bit_vector_iterator OF set_iterator
PRIVATE
  item:PTR TO LONG
  mask:LONG
  source:PTR TO mask_list
  buckets:PTR TO LONG
  bucket_num:LONG
  count:INT
ENDOBJECT

PROC get_current_item() OF bit_vector_iterator IS self.item

-> constructor
PROC init(src:PTR TO mask_list) OF bit_vector_iterator
  self.mask:=1
  self.source:=src
  self.item:=NIL
  self.count:=0
  self.bucket_num:=0
  self.buckets:=src.get_mask()
ENDPROC

PROC next() OF bit_vector_iterator
  DEF count:REG,
    last:REG,
    mask:REG,
	bn:REG,
    src:REG PTR TO mask_list,
    bv:PTR TO bit_vector,
    i:PTR TO LONG
  src:=self.source
  bv:=src.get_parent()
  count:=self.count
  bn:=self.bucket_num
  last:=bv.get_last_item()
  WHILE count <= last -> find next item
    IF self.mask[bn] AND self.buckets[bn] -> found
      i:=bv.get_items()
      self.item:=i[count]
      self.count:=count
	  self.bucket_num:=bn
      RETURN TRUE
    ENDIF
    count+=1
    mask:=Shl(1,count AND 31)
    IF mask=1
      bn:=Shr(count,5)
    ENDIF
  ENDWHILE
  self.mask:=mask
  self.count:=count
ENDPROC FALSE
