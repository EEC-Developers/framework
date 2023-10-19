# I/O
Simple file and other input and output operations

## File Buffer
Reads, writes, splits and counts delimiters in file buffers

* read_file(filename,delimiter,memflags) -- constructor that reads a file into a buffer
  * raises OPEN exception if file cannot open
  * raises IN exception if input is incomplete
* get_buffer() -- getter for the file buffer address (skipping 4-byte header)
* get_length() -- getter for the total length of the file
* get_delimiter() -- getter returns the delimiter as a long
* set_delimiter(value) -- sets the deilimiter value
* write_file(filename) -- writes file to new address
  * raises OPEN exception if file exists or cannot open
  * raises OUT exception if write is incomplete
* count_strings() -- counts occurrences of the least significant byte of delimiter in buffers
* create_string_list(maximum) -- divides buffer and returns E-List of null terminated strings where deleimiter byte is overwritten by null character
  * if optional "maximum" parameter is not specified, it calls count_strings() to find the exact count
  * raises MEM if E-List of "maximum" cannot be allocated regardless of whether it is the exact count
