-> Doubly Linked List
-> Backwardly compatible to Amiga system lists

OPT MODULE

MODULE 'List/listBase','List/singleList','exec/lists',
    'Iterator/iterator','Iterator/bidiriectional',
	'Iterator/reverse'

-> Equivalent to Amiga mln structure plug VPointer
EXPORT OBJECT min_list_node OF single_list_node
  prev:PTR TO min_list_node
ENDOBJECT

-> getters and setters
PROC get_prev() OF min_list_node IS self.prev

PROC set_prev(node:PTR TO min_list_node) OF min_list_node
  self.prev:=node
ENDPROC

-> conversion method
PROC to_mln() OF min_list_node IS {self.next}::PTR TO mln

-> Equivalent to Amiga mlh structure plus VPointer
EXPORT OBJECT min_list_header OF single_list_header
  tail:PTR TO min_list_node
  tailpred:PTR TO min_list_node
ENDOBJECT

-> Constructor
PROC min_list() OF min_list_header
  self.head:={self.tail}
  self.tail:=NIL
  self.tailpred:={self.head}
ENDPROC

-> Getters and Setters
PROC get_last() OF min_list_header IS self.tailpred

PROC set_last(node:PTR TO min_list_node) OF min_list_header
  self.tailpred:=node
ENDPROC

-> Conversion method
PROC to_mlh() OF min_list_header IS {self.head}::PTR TO mlh

PROC insert_node(node:PTR TO min_list_node) OF min_list_node
  self.prev:=node.get_prev()
  self.next:=node
  node.set_prev(self)
ENDPROC

PROC insert(node:PTR TO min_list_node) OF min_list_header
  self.head::PTR TO min_list_node.insert_node(node)
ENDPROC

PROC add(node:PTR TO min_list_node) OF min_list_header
  self.tail.insert_node(node)
ENDPROC

PROC add_node(node:PTR TO min_list_node) OF min_list_node
  self.next.insert_node(node)
ENDPROC

-> Private helper function
PROC merge(first:PTR TO min_list_header,
    second:PTR TO min_list_header)
  DEF middle:REG PTR TO min_list_node,
    middleBack:REG PTR TO min_list_node
  middle:=second.get_first()
  middleBack:=first.get_last()
  middle.set_prev(middleBack)
  middleBack.set_next(middle)
ENDPROC

-> Adds a list to the end of the current one
-> second list's header is consumed and deallocated
PROC append(list:PTR TO min_list_header) OF min_list_header
  merge(self,list)
  self.set_last(list.get_last())
  Dispose(list)
ENDPROC

-> Adds a list to the beginning of the current one
-> first list's header is consumed and deallocated
PROC prepend(list:PTR TO min_list_header) OF min_list_header
  merge(list,self)
  self.set_first(list.get_first())
  Dispose(list)
ENDPROC

-> Iterator
OBJECT min_list_iterator OF bidirectional
ENDOBJECT

PROC init(head:PTR TO min_list_header) OF min_list_iterator
  SUPER self.init(head)
ENDPROC

PROC init_last(head:PTR TO min_list_header) OF min_list_iterator
  self.is_new:=TRUE
  self.iter:=head.get_last()
ENDPROC

PROC prev() OF min_list_iterator
  IF self.is_new
    self.is_new:=FALSE
    self.iter:=self.head.get_last()
  ELSE
    self.iter:=self.iter.get_prev()
  ENDIF
  IF iter THEN RETURN TRUE
ENDPROC FALSE

-> Reverse iterator traverses backwards

OBJECT min_list_reverse OF min_list_iterator
ENDOBJECT

PROC init(head:PTR TO mln_list_header) OF mln_list_reverse
  SUPER self.init(head)
ENDPROC

PROC next() OF mln_list_reverse IS SUPER.prev()

PROC prev() OF mln_list_reverse is SUPER.next()
