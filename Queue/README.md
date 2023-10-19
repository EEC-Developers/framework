# Queue
A single-direction queue that is a child class of the List/singleList class

## Constructors
All constructors for both the queue and queue_node structures are non-descript init() functions with no parameters.

## Methods
* enqueue(node) adds a queue_node to the back of the queue
* dequeue() retrieves a queue_node from the front of the queue

## Notes
* To peek what's next on the front of the queue without removing it, the `get_first()` method is inherited from the singleList class so the pointer returned only needs to be downcasted.
* Likewise the single_list_iterator class is inherited and searches in order from the first to the last in the queue.
