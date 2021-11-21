# EEC Framework

## Description

This is designed to be a minimal framework of abstract data types for Amiga-like operating systems running EEC or other AmigaE derived languages.

## Format and Naming Conventions

Drawers are to be uppper-camel-case naming, files and modules themselves are to be lower-camel-case and the methods within them should be lower-snake-case.

There should be unit tests for each data type in its respective drawer, recognizable by the word "Test" in the end of their lower-camel-case filenames.  Base classes should have "Base" at the end of their filename.

Since Amiga filesystems are case-insensitive, it may make no difference to your code but please try to be consistent with the filename case conventions because cross compilers may someday be possible.
