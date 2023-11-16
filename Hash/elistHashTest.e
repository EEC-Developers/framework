

MODULE 'Hash/hashbase', 'Hash/unorderedHash','Iterator/iterator'

OBJECT tester OF hash_link
  my_key:PTR TO LONG
ENDOBJECT

DEF lister:PTR TO unordered_hash,
	iter:PTR TO unordered_hash_iterator,
	link:PTR TO tester,
	link2:PTR TO tester,
	link3:PTR TO tester

-> key getter function
PROC key_get(x:PTR TO tester) IS x.my_key

-> Local constructor
PROC build(list,value) OF tester
  self.my_key:=list
  SUPER self.init_link(list,lister,value)
ENDPROC

-> key comparison function
PROC cmp(l,k) IS ListCmp(key_get(l),k)

PROC main() HANDLE
  DEF list_val,test:PTR TO unordered_hash,scratch:PTR TO tester
  NEW test.init_base(HASH_TINY,{key_get},{cmp},{composite_hash})
  NEW link.build([$12345678,$BCDEF0,$0F0F0F0F,$F0F0F0F0],1)
  WriteF('initialized\n')
  add(link)
  NEW link2.build([$76543210,$FEDCBA98,$0000FFFF,$FFFF0000],2)
  add(link2)
  NEW link3.build([1],3)
  add(link3)
  NEW iter.init(test)
  WHILE iter.next()
    scratch:=iter.get_current_item()
    list_val:=key_get(scratch)
    WriteF('key value pair of \s \d\n',
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
PROC add(link:PTR TO tester)
	DEF junk
	lister.add(link)
	junk:=key_get(link)
	WriteF('Added \d ',link.get_value())
	WriteF('to bucket \d ',lister.hash_slot(link))
	WriteF('with hash \h ',link.get_hash_value())
	WriteF('key address \h ',junk)
	WriteF('listlen \d\n',ListLen(junk))
ENDPROC
