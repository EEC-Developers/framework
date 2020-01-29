
MODULE '*adventurebase','*textadventure'

ENUM ERR_NONE,ERR_FILE

DEF torch:PTR TO item,
  lamp:PTR TO item,
  bag:PTR TO item,
  light:PTR TO inventory,
  roomstuff:PTR TO inventory,
  mystuff:PTR TO inventory

PROC grab(myitem:PTR TO item)
  IF mystuff.take(myitem,roomstuff)
    WriteF('\s taken.\n', myitem.itemname)
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

  NEW torch.item('torch')
  NEW bag.item('bag')
  NEW lamp.item('lamp')
  NEW light.itemclass([torch,lamp])
  NEW roomstuff.inventory()
  NEW mystuff.inventory()
  roomstuff.additem(lamp)
  roomstuff.additem(torch)
  roomstuff.additem(bag)
  running:=TRUE

  WriteF('You are in a room with no exits.\n')
  REPEAT
    IF mystuff.has(light)
      WriteF('You see:\n')
      roomstuff.list()
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
    IF roomstuff.isempty()
      running:=FALSE
      WriteF('You have everything.\n')
    ENDIF
  UNTIL surequit(running)
EXCEPT
  SELECT exception
    CASE ERR_FILE
      WriteF('End of File encountered.\n')
    DEFAULT
      WriteF('An error occurred.\n')
  ENDSELECT
  END lamp
  END torch
  END bag
  END light
  END mystuff
  END roomstuff
ENDPROC
