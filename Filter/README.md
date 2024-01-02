# Filter
A filter is a piece of code that iterates over a source of incoming data and outputs it to a buffer with an iterator. Often several filters are run end to end.

## Filter Methods
* init() -- initializes the internal filter queue
* Process() -- propogates data from the source buffer to all the filter processes in the queue.
* enqueue(filter_process) -- adds the specified filter_process to the end of the queue

# Filter Process
Each stage of a filter is broken down into multiple filter processes.

## Filter Process Methods
* add(parent, output) -- constructor that adds the process to the parent filter using the output buffer class as storage.
* process(iterator) -- processes all of the items from the previous output buffer's iterator
* clear_output() -- called by the process method at the beginning to remove any remaining contents

## Filter Process Getters
* get_parent() -- accesses the filter that this process belongs to
* get_output() -- accesses the handle that outputs to the buffer

# Splitter
The splitter filter process divides byte buffers and strings into multiple estrings and outputs them into a string queue buffer.

Useful applications include line counting for "more"-style pagers, splitting from spaces between words in a primitive parser.

## Methods
* create(parent, output, string_size, delimiter) -- constructor: parent is the filter, output is required to be a string_queue (or a child class thereof) because the number of substrings is unknown, string_size is the work buffer size and delimiter is the character that will be omitted from the output stream but trigger a split.

# Word Wrap
The word wrap filter process accepts an iterator of paragraph-size strings. Although no line breaks are allowed in the inputs, the output strings will have line breaks added to them in appropriate places.

## Methods
* create(parent,output,line_length) -- constructor: parent is the filter, output is the buffer, line_length is the length of the line in characters.

# Passthrough
Moves from input to output unmodified. It is useful for converting to different buffer types.

# Text List
Creates a syntactically correct, punctuated list of items in English from an iterator of strings.

## Methods
* create(parent,output,work_size) -- constructor: parent is the filter, output is the buffer, work_size is the size of the string buffer to be placed in the self.work estring.
* generate() -- method that must be supplied by a child class to output each string. The string is contained in self.work and the enumerated status of the class is in self.is_singular. See in-code comments for more specific information.
