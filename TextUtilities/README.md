# Text Utilities

## Text List

This module creates a syntactically correct, punctuated list of items from an iterator.

### text_list -- accepts an iterator and a function pointer to generate the text.  Generally it will be a wrapper for StringF.

## Word Wrap

This module wraps text according to the length of the words.

### wrapBase -- An abstract class that can wrap text according to word length

#### init(buffer_length) -- the maximum length of a string input is the parameter of this constructor

#### end() -- destructor

#### length(text) -- abstract method

Define the length of the text, regardless of whether it is in pixels or characters

#### output(text) -- abstract output method

#### wrap(format, var) -- outputs formatted text

Like StringF but with wordwrap and only accepting one string as input.

#### flushWrap() -- marks end of paragraph

*NOTE:* The carriage return is not properly processed as a flushWrap() call at this time.

### wrapMonospaced -- The concrete definition of a text wrapper for monospaced text on a console

Uses character lengths as length so regular WriteF calls are used to output to a console.

## Known Bugs

- Sometimes the hyphen is not used correctly as a wrap character.

## Omitted Features

- Proportional fonts could be supported by creating another child class of wrapBase.
