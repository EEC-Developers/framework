# Queue
A single-direction queue that is a child class of the List/singleList class

## Constructors
All constructors for both the queue and queue_node structures are non-descript init() functions with no parameters.

## Methods
* enqueue(node) adds a queue_node to the back of the queue. O(1) time complexity
* dequeue() retrieves a queue_node from the front of the queue. O(1) time complexity.
* merge(other) appends the contents of a second queue to the current one, consuming the other's header in the process. O(1) time complexity.

## Getter
* get_back() reveals the most recently added element in the current queue
* get_first() peeks the item first in line without removing it. It is inherited from single_list.

## Notes
* The list_iterator class is inherited and searches in order from the first to the last in the queue.
