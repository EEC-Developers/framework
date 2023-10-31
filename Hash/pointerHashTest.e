-> Pointer Hash Test

MODULE 'Hash/hashBase','Hash/unorderedHashBase','Hash/pointerHash'

OBJECT test OF pointer_hash
ENDOBJECT

OBJECT lister OF pointer_hash_link
  cargo:LONG
ENDOBJECT

PROC get_cargo() OF lister IS self.cargo

-> constructor
PROC build(x:PTR TO LONG,parent:PTR TO pointer_hash,y) OF lister
  SUPER self.init_link(x,parent)
  self.cargo:=y
ENDPROC

PROC main() HANDLE
DEF tester:PTR TO test,
    iter:PTR TO unordered_hash_iterator,
    link:PTR TO lister,
    link2:PTR TO lister,
    link3:PTR TO lister,
	scratch:PTR TO lister
  NEW tester.init(HASH_TINY)
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
      scratch.get_key(),scratch.get_cargo())
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
PROC add(tester:PTR TO test,link:PTR TO lister)
  DEF thing
  tester.add(link)
  thing:=link.get_hash_value()
  WriteF('Added \d ',link.cargo)
  WriteF('to bucket \d ',tester.hash_slot(thing))
  WriteF('with hash \h ',thing)
  WriteF('and key is \h.\n',link.get_key())
ENDPROC
