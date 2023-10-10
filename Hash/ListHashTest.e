

MODULE 'Hash/hashbase', 'Hash/listhash'

OBJECT test OF list_hash
ENDOBJECT

OBJECT lister OF list_hash_link
	cargo:LONG
ENDOBJECT

PROC build(x:PTR TO LONG,y) OF lister
	SUPER self.init(x)
	self.cargo:=y
ENDPROC

DEF tester:PTR TO test,
	iter:PTR TO hash_iterator,
	link:PTR TO lister,
	link2:PTR TO lister,
	link3:PTR TO lister

PROC main() HANDLE
	NEW tester.init(HASH_TINY)
	NEW link.build([$12345678,$BCDEF0,$0F0F0F0F,$F0F0F0F0],1)
	WriteF('initialized\n')
	add(link)
	NEW link2.build([$76543210,$FEDCBA98,$0000FFFF,$FFFF0000],2)
	add(link2)
	NEW link3.build([1],3)
	add(link3)
EXCEPT
	SELECT exception
		CASE "MEM"
			WriteF('Out of memory.')
		DEFAULT
			WriteF('An unknown error occurred.')
	ENDSELECT
ENDPROC

-> This local function adds and displays information about the node just added
PROC add(link:PTR TO lister)
	DEF junk
	tester.add(link)
	junk:=link.get_key()
	WriteF('Added \d ',link.cargo)
	WriteF('to bucket \d ',tester.hash_slot(link))
	WriteF('with hash \h ',link.hash_value)
	WriteF('key address \h ',junk)
	WriteF('listlen \d\n',ListLen(junk))
ENDPROC
