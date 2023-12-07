-> Pointer Hash Test

MODULE 'Hash/hashBase','Hash/unorderedHash','Iterator/iterator'

OBJECT lister OF hash_link
PUBLIC
  my_key:LONG
ENDOBJECT

-> key getter
PROC key_get(x:PTR TO lister) IS x.my_key

-> comparison
PROC cmp(l,k) IS key_get(l)=k

-> constructor
PROC build(x,parent:PTR TO unordered_hash,y) OF lister
  self.my_key:=x
  SUPER self.init_link(x,parent,y)
ENDPROC

PROC main() HANDLE
DEF tester:PTR TO unordered_hash,
    iter:PTR TO unordered_hash_iterator,
    link:PTR TO lister,
    link2:PTR TO lister,
    link3:PTR TO lister,
    scratch:PTR TO lister
  NEW tester.init_base(HASH_TINY,{key_get},{cmp},{long_hash})
  NEW link.build($01234567,tester,1)
  WriteF('initialized\n')
  add(tester,link)
  NEW link2.build($FEDCBA98,tester,2)
  add(tester,link2)
  NEW link3.build(1,tester,3)
  add(tester,link3)
  NEW iter.init(tester)
  WHILE iter.next()
    scratch:=iter.get_current_item()
    WriteF('key value pair of \h \d\n',
      key_get(scratch),scratch.get_value())
  ENDWHILE
EXCEPT
  SELECT exception
    CASE "MEM"
      WriteF('Out of memory.')
    DEFAULT
      WriteF('An unknown error occurred.')
  ENDSELECT
ENDPROC

-> This local function adds and displays information about the node just added
PROC add(tester:PTR TO unordered_hash,link:PTR TO lister)
  DEF thing

  tester.add(link)
  thing:=link.get_hash_value() AND $FFFF
  WriteF('Added \d ',link.get_value())
  WriteF('to bucket \d ',tester.hash_slot(thing))
  WriteF('with hash \h ',thing)
  WriteF('and key is \h.\n',key_get(link))
ENDPROC
