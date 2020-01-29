

MODULE 'Hash/hashbase', 'Hash/listhash'

OBJECT lister OF list_hash_link
	cargo:LONG
ENDOBJECT

DEF tester:PTR TO list_hash,
	iter:PTR TO hash_iterator,
	link:PTR TO lister,
	link2:PTR TO lister

PROC main() HANDLE
	NEW tester.init(HASH_TINY)
	NEW link.init([$12345678,$BCDEF0,$0F0F0F0F,$F0F0F0F0])
	WriteF('initialized\n')
	link.cargo:=1
	tester.add(link)
	out(link)
	NEW link2.init([$76543210,$FEDCBA98,$0000FFFF,$FFFF0000])
	link2.cargo:=2
	tester.add(link2)
	out(link2)
EXCEPT
	SELECT exception
		CASE "MEM"
			WriteF('Out of memory.')
		DEFAULT
			WriteF('An unknown error occurred.')
	ENDSELECT
ENDPROC

PROC out(link:PTR TO lister)
	WriteF('Added \d to bucket \d with hash \h listlen \d\n',
		link.cargo, tester.hash_slot(link), link.hash_value, link.get_key() )
ENDPROC