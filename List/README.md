# Linked Lists

## Base Class
Abstracts a singly-linked list and its iterator.

### Methods
* get_first() -- a getter method that returns a pointer to the head item in the list
* insert(node) -- inserts the node on the head of the list
* remove_first() -- removes and returns a pointer to the head node

The list node class implements a single getter:
* get_next() -- returns a pointer to the next node in the list or NIL

Note: The get_next() method should be used mostly internally because it is an implementation detail that is unique to the linked list. Use iterators if possible.

### Iterator
A unidirectional iterator starts at the head and moves down the list.

NOTE: The iterator isn't valid until the next() method has been called at least once becuase the list could be empty.

## Single List
Implements the base class and iterator methods only.

Note: Unlike some frameworks, the queue and the linked-indexing of the hashBase class use only singly-linked lists.

## List
A doubly-linked list that implements NIL-termination within the header in the same way as AmigaOS did in its system lists. The header is called `min_list_header`.

### Iterator Notes
* Two bidirectional iterators are supplied.
* The standard one is `min_list_iterator`.
* The reverse iterator, called `min_list_reverse`, sets the role of `next()` to go backwards through the list and `prev()` to go frontwards.
* Bidirectional iterators inherit from the standard iterator as well for unidirectional interchangability.

### Additional Methods Beyond the Base Class
* append(min_list_header) -- adds an entire doubly-linked list to the end of the current list, consuming the header and deallocating it in the process
* prepend(min_list_header) -- similar to `append()` except it adds to the beginning
* add(min_list_header) -- adds node to tail of list
* add_node(min_list_node) -- adds after the node
* insert(min_list_node) -- inserts before the node
* insert_node(min_list_header) -- adds to head of list

### Node method:
* get_prev() -- backward link from the list node class
