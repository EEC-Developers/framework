OPT MODULE

MODULE 'TextUtilities/wordWrap'

OBJECT wrapMonospaced OF wrapBase
ENDOBJECT

EXPORT PROC init(columns) OF wrapMonospaced
  SUPER self.init(columns)
ENDPROC

EXPORT PROC length(text) OF wrapMonospaced IS StrLen(text)

EXPORT PROC output(text) OF wrapMonospaced IS WriteF('\s', text)
