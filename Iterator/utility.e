-> Utility subroutines for iterators

OPT MODULE

MODULE 'Iterator/iterator'

-> count items in an iterator
-> note: Iterator is consumed by this function so reuse requires
->    reallocation of the iterator.
EXPORT PROC content_count(iter:PTR TO iterator)
  DEF ret:REG

  ret:=0
  WHILE iter.next()
    ret+=1
  ENDWHILE
  END iter
ENDPROC ret

-> Convert an iterator of LONG values or Pointers into an elist
-> note: Iterator is also consumed by this function
EXPORT PROC to_elist(iter:PTR TO iterator,size)
  DEF out

  out:=List(size)
  WHILE iter.next()
    ListAddItem(out,iter.get_current_item())
  ENDWHILE
  END iter
ENDPROC out
