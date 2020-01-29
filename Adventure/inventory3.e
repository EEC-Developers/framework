
MODULE 'Hash/hashbase',
  'Hash/stringhash',
  'Adventure/textadventure'

ENUM ERR_NONE,ERR_FILE

DEF torch:PTR TO object,
  lamp:PTR TO object,
  bag:PTR TO object,
  light:PTR TO inventory,
  everything:PTR TO master_list,
  roomstuff:PTR TO inventory,
  mystuff:PTR TO inventory,
  torch_name:PTR TO CHAR,
  lamp_name:PTR TO CHAR,
  bag_name:PTR TO CHAR

PROC grab(myitem:PTR TO object)
  IF mystuff.take(myitem,roomstuff)
    WriteF('\s taken.\n', myitem.get_key())
  ENDIF
ENDPROC

PROC surequit(running)
  DEF input[2]:STRING, in:LONG, ret
  ret:=FALSE
  IF Not(running)
    WriteF('Do you want to quit?\n')
    in:=ReadStr(stdin, input)
    IF in=-1 THEN Raise(ERR_FILE)
    IF input[0]="y" THEN ret:=TRUE
  ENDIF
ENDPROC ret

PROC main() HANDLE
  DEF get[2]:STRING,in,running

  torch_name:='torch'
  bag_name:='bag'
  lamp_name:='lamp'
  NEW torch.init(torch_name)
  NEW bag.init(bag_name)
  NEW lamp.init(lamp_name)
  NEW everything.init_master_list([lamp,torch,bag])
  -> create sublist of items
  NEW light.init(everything,[torch,lamp])
  -> create empty inventories
  NEW roomstuff.create(everything)
  NEW mystuff.create(everything)
  roomstuff.add_item(torch)
  roomstuff.add_item(lamp)
  roomstuff.add_item(bag)
  running:=TRUE

  WriteF('You are in a room with no exits.\n')
  REPEAT
    IF mystuff.has_a(light)
      WriteF('You see:\n')
      IF roomstuff.has_a(torch) THEN WriteF(' a torch\n')
      IF roomstuff.has_a(lamp) THEN WriteF(' a lamp\n')
      IF roomstuff.has_a(bag) THEN WriteF(' a bag\n')
    ELSE
      WriteF('It is dark.  You are likely to be eaten by a grue.\n')
    ENDIF
    WriteF('Enter first letter of item to pick up/drop\n')
    WriteF('or Q to quit\n')
    in:=ReadStr(stdin,get)
    IF in=-1 THEN Raise(ERR_FILE)
    in:=get[0]
    SELECT in
      CASE "b"
        grab(bag)
      CASE "t"
        grab(torch)
      CASE "l"
        grab(lamp)
      CASE "q"
        running:=FALSE
      DEFAULT
        WriteF('No such item.\n')
    ENDSELECT
    IF roomstuff.is_empty()
      running:=FALSE
      WriteF('You have everything.\n')
    ENDIF
  UNTIL surequit(running)
EXCEPT
  SELECT exception
    CASE ERR_FILE
      WriteF('End of File encountered.\n')
    CASE 'ARGS'
      WriteF('Illegal arguments.\n')
    CASE 'bset'
      WriteF('Oversized bitset.\n')
    DEFAULT
      WriteF('An error occurred.\n')
  ENDSELECT
  everything.end_links(SIZEOF object)
  END everything
  END light
  END mystuff
  END roomstuff
ENDPROC
