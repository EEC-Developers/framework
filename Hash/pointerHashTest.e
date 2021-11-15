

MODULE 'Hash/hashBase', 'Hash/pointerHash'

OBJECT test OF pointer_hash
ENDOBJECT

OBJECT lister OF pointer_hash_link
	cargo:LONG
ENDOBJECT

PROC build(x:PTR TO LONG,parent:PTR TO pointer_hash,y) OF lister
	SUPER self.init(x,parent)
	self.cargo:=y
ENDPROC

DEF tester:PTR TO test,
	iter:PTR TO hash_iterator,
	link:PTR TO lister,
	link2:PTR TO lister,
	link3:PTR TO lister

PROC main() HANDLE
	NEW tester.init(HASH_TINY)
	NEW link.build($12345678,tester,1)
	WriteF('initialized\n')
	add(link)
	NEW link2.build($FEDCBA98,tester,2)
	add(link2)
	NEW link3.build(1,tester,3)
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
	DEF junk,thing
	tester.add(link)
	junk:=link.get_key()
	thing:=link.get_hash_value()
	WriteF('Added \d ',link.cargo)
	WriteF('to bucket \d ',tester.hash_slot(thing))
	WriteF('with hash \h ',thing)
	WriteF('key value \h\n',junk)
ENDPROC
