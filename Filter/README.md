# Filter
A filter is a piece of code that iterates over a source of incoming data and outputs it to a buffer with an iterator. Often several filters are run end to end.

## Filter Methods
* init() -- initializes the internal filter queue
* Process(iter) -- processes the iter to all the filter_process stages in the queue or raises 'FILT' exception if there are no filter_process stages added to the queue.
* enqueue(filter_process) -- adds the specified filter_process to the end of the queue
* get_output() -- gets the buffer of the last filter_process. It Raises a 'FILT' exception if the filter has no filter_processes added to it.

# Filter Process
Each filter is broken down into multiple filter_process stages.

## Filter Process Methods
* add(parent, output) -- constructor that adds the process to the parent filter using the output buffer class as storage.
* process(iterator) -- processes all of the items from the previous output buffer's iterator
* clear_output() -- called by the process method at the beginning to remove any remaining contents
* get_output() -- accesses the handle that outputs to the buffer

# Splitter
The splitter filter process divides byte buffers and strings into multiple estrings and outputs them into a string queue buffer.

Useful applications include line counting for "more"-style pagers, splitting from spaces between words in a primitive parser.

## Methods
* create(parent, output, string_size, delimiter) -- constructor: parent is the filter, output is required to be a string_queue (or a child class thereof) because the number of substrings is unknown, string_size is the work buffer size and delimiter is the character that will be omitted from the output stream but trigger a split.

# Word Wrap
The word wrap filter process accepts an iterator of paragraph-size strings. Although no line breaks are allowed in the inputs, the output strings will have line breaks added to them in appropriate places.

## Note
Word wrap doesn't require a linefeed splitter afterward because it generates one line per append method call to the buffer.

## Methods
* create(parent,output,line_length) -- constructor: parent is the filter, output is the buffer, line_length is the length of the line in characters.

# Passthrough
Moves from input to output unmodified. It is useful for converting to different buffer types.

# Text List Base
Creates a syntactically correct, punctuated list of items in English from an iterator of strings.

## Methods
* create(parent,output,work_size) -- constructor: parent is the filter, output is the buffer, work_size is the size of the string buffer to be placed in the self.work estring.
* generate() -- abstract method to output each string. The string is contained in self.work and the enumerated status of the class is in self.status. See in-code comments for more specific information.

# Subfilter
Makes a filter of multiple filter_processes and yields the cumulative process as if it were all one stage in the current filter

## Methods
* build(parent) -- constructor: parent is the filter this subfilter is called from.
