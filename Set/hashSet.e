OPT MODULE

-> Hash Set: a wrapper of dynamicHash where hash_link's value is
->   always the key

MODULE 'Hash/hashBase','Hash/unorderedHash','Hash/dynamicHash',
  'Iterator/iterator','Set/setBase'

EXPORT OBJECT hash_set OF set PRIVATE
  cargo:PTR TO dynamic_hash
ENDOBJECT

PROC key_getter(link:PTR TO hash_link) IS link.get_value()

-> Constructor
PROC init(table_size,comparison,hash_func) OF hash_set
  NEW self.cargo.init_base(table_size,{key_getter},comparison,hash_func)
ENDPROC

EXPORT OBJECT hash_subset OF subset PRIVATE
  cargo:PTR TO dynamic_hash
ENDOBJECT

-> Constructor
PROC init(parent_set:PTR TO hash_set,members:PTR TO iterator) OF hash_subset
  DEF item:PTR TO hash_link,current:PTR TO hash_link

  SUPER self.baseInit(parent_set)  
  NEW self.cargo.init_base(parent_set.get_size(),{key_getter},
    parent_set.get_comparison(),parent_set.get_hash_func())
  WHILE members.next()
    current:=members.get_current_item()
    NEW item.init_link(current,parent_set,parent_set,current)
    self.add(item)
  ENDWHILE
ENDPROC
