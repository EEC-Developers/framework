OPT PREPROCESS

MODULE 'Hash/hashBase','Hash/stringHash','Set/setBase','Set/smallSet',
  'TextUtilities/monospacedWrap','TextUtilites/wordWrap',
  'Games/Adventure/textAdventure'

ENUM ERR_NONE,ERR_FILE

#define DEBUG

DEF torch:PTR TO object,
  lamp:PTR TO object,
  bag:PTR TO object,
  light:PTR TO inventory,
  allitems:PTR TO inventory,
  everything:PTR TO master_list,
  this_room:PTR TO room,
  mystuff:PTR TO inventory
  
STATIC torch_name='torch',
  lamp_name='lamp',
  bag_name='bag'

PROC grab(myitem:PTR TO object)
  DEF x:PTR TO inventory
  x:=this_room.get_room_inventory()
  IF x.give(myitem,mystuff)
  #ifdef DEBUG
    WriteF('\h ', myitem.get_key())
  #endif
    WriteF('\s taken.\n', myitem.get_key())
  ELSE
    WriteF('Not taken.\n')
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
  DEF get[2]:STRING,in,running,stuff:PTR TO inventory

  NEW torch.generate(torch_name)
  #ifdef debug
    WriteF('torchname=\s\n\h\n',torch.get_key(),torch.get_key())
  #endif
  NEW bag.generate(bag_name)
  NEW lamp.generate(lamp_name)
  -> master list holds and enumerates all items
  NEW everything.init_master_list([lamp,torch,bag])
  allitems:=everything.get_all()
  -> sublist of items that create light
->  NEW light.init(everything,[torch,lamp])
  NEW light.create(everything,torch.get_mask() OR lamp.get_mask() )
  -> initialize inventory
  NEW stuff.create(everything,allitems.get_mask())
  NEW mystuff.create(everything)
  -> initialize room
  NEW this_room.init('You are in a plain-looking room.',stuff)
  running:=TRUE

  REPEAT
    #ifdef debug
      WriteF('mystuff mask=\d\n',mystuff.get_mask())
    #endif
    IF mystuff.has_one(light)
      this_room.look()
    ELSE
      WriteF('You are in a room with no exits.\nIt is dark.\n')
    ENDIF
    WriteF('Enter first letter of item to pick up/drop\nor Q to quit\n')
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
    IF mystuff.has_all(everything.get_all())
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
      WriteF('Illegal bitset size.\n')
    DEFAULT
      WriteF('An error occurred.\n')
  ENDSELECT
  everything.end_links(SIZEOF object)
  END everything
  END light
  END mystuff
  END this_room
ENDPROC
