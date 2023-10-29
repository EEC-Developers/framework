# I/O
Simple file and other input and output operations

## File Buffer
Reads, and writes file buffer I/O

* read_file(filename,delimiter,memflags) -- constructor that reads a file into a buffer
  * raises OPEN exception if file cannot open
  * raises IN exception if input is incomplete
* get_buffer() -- getter for the file buffer address (skipping 4-byte header)
* get_length() -- getter for the total length of the file
* write_file(filename) -- writes file to new address
  * raises OPEN exception if file exists or cannot open
  * raises OUT exception if write is incomplete

## Buffer Split
* count_strings(buffer,bufferLength,delimiter) -- returns count of occurrences of the least significant byte of delimiter in buffer (delimieter defaults to linefeed)
* create_string_list(buffer,bufferLength,delimiter,maximum) -- divides buffer and returns E-List of null terminated strings where deleimiter byte is overwritten by null character and last value of the E-List is end of buffer
  * if optional "maximum" parameter is not specified, it calls count_strings() to find the exact count
  * raises MEM if E-List of "maximum" cannot be allocated regardless of whether it is the exact count
