# Text Utilities

## Text List
This module contains a single function that creates a syntactically correct, punctuated list of items from an iterator.

* text_list(iterator,generator) -- accepts an iterator and a function pointer to generate the text. It returns an enumeration that indicates whether the resultant list was none, singular or plural.

Generally the generator will be a wrapper for StringF and accepts the parameter passed by the get_current_item() getter from the iterator.  This is to abstract the iterator type from the implementation of the string generation so that numbers can be converted to strings if necessary.  It will be called repeatedly if there are multiple items in the structure being iterated.

## Word Wrap
This module wraps text according to the length of the words.

### Constructor
* init(buffer_length) -- the maximum length of a string input is the parameter of this constructor

### Methods
* length(text) -- Defines the length of the text, regardless of whether it is in pixels or characters
* output(text) -- wrapper method for WriteF() that can be overridden for newer Kickstart routines or numeric datatypes
* wrap(format, var) -- outputs formatted text like StringF but with wordwrap and only accepting one string as input.
* flushWrap() -- marks end of paragraph

### Notes
The `length()` method is a wrapper method for `EstrLen()` that can be overridden for proportional font usage as pixels instead of character length.

A carriage return input is not properly processed as a `flushWrap()` call at this time.

## Known Bugs
* Sometimes the hyphen is not used correctly as a wrap character.

## Omitted Features
* Proportional fonts could be supported by creating another child class of wordWrap.
