OPT MODULE

MODULE 'Filter/filterBase', 'Iterator/iterator'

EXPORT OBJECT subfilter OF filter_process
  filt:PTR TO filter
ENDOBJECT

-> Constructor
PROC build(parent) OF subfilter IS SUPER self.add(parent,NIL)

PROC get_filter() OF subfilter IS self.filt

PROC process(iter:PTR TO iterator) OF subfilter
  self.filt.process(iter)
ENDPROC 

PROC enqueue(filt_process:PTR TO filter_process) OF subfilter
  self.filt.enqueue(filt_process)
ENDPROC

PROC get_output() OF subfilter IS self.filt.get_output()
