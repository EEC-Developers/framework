# Buffer
The buffer classes are used in tandem with the filter classes. They wrap different kinds of iterable buffers.

## Buffer Getters
* get_size() -- returns the number of items in the current buffer or BUF_EMPTY if size is not supplied or not allocated.
* get_iterator() -- returns a handle to an already-initialized iterator appropriate for the data type.
* get_capacity() -- returns the maximum capacity of the current data structure

## Buffer methods
* append(item) -- adds item to the end of the buffer if possible or raises "SIZE" exception if not possible.
* clear() -- removes the contents of the buffer and starts fresh.

# Buffer Classes

## EString Buffer
This holds a monolithic estring. Only the standard methods are supplied.

## EList Buffer
This is useful for making a buffer listing other buffers. The get_capacity method isn't supplied.

## String Queue
This dynamically allocates nodes of containing string contents. The get_capacity() method is a precise tally of total string length if the append method is the only method used to add to it.

### Methods
* merge(other) -- appends other string_queue structure to the end of this one. Capacities are added also. The other's header is consumed by the merge operation. Time complexity is O(1).

## File Buffer
It can load and save its contents to disk storage. It cannot grow the buffer it wraps.

### Methods
* init() -- Constructor that sets size to BUF_EMPTY until the load_buffer or append method is called.
* load_buffer(filename, trail, memflags) -- loads file specified in filename into a newly allocated memory buffer. If not found, "OPEN" exception is thrown passing the filename as a secondary parameter. If opened but not successfully read, the "IN" exception is raised. The optional "trail" parameter adds a linefeed and null character past the buffer's end if TRUE. The "memflags" sets the allocation flags to something other than the default MEMF_ANY.
* save_buffer(filename) -- saves the buffer to disk. If file could not be created the "OPEN" exception is thrown. If the write was unsuccessful the "OUT" exception is raised.
* append(item) -- converts an estring_buffer into a file_buffer if file_buffer is BUF_EMPTY.
