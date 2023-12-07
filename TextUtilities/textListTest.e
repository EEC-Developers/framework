-> Test Text List

MODULE 'TextUtilities/textList','Iterator/iterator',
  'List/listBase','List/singleList'

ENUM TEST_OK,TEST_UNDEFINED

OBJECT name OF single_list_node
  item:PTR TO CHAR
ENDOBJECT

PROC out(format,n:PTR TO name) IS WriteF(format,n.item)

PROC main() HANDLE
  DEF iter:PTR TO list_iterator,count:REG,node:PTR TO name,
    list:PTR TO single_list_header,content

  content:=['a partridge','turtle-doves','french hens',
    'calling birds','gold rings'
  ]
  NEW list.init()
  FOR count:=0 TO ListLen(content)
    IF count>0
      WriteF('Christmas day number \d.\n',count)
      NEW node.init()
      node.item:=ListItem(content,count-1)
      list.insert(node)
    ELSE
      WriteF('On Christmas Eve\n')
    ENDIF
    NEW iter.init(list)
    WriteF('You received ')
    SELECT text_list(iter,{out})
      CASE TEXT_PLURAL; WriteF(' as gifts.')
      CASE TEXT_SINGULAR; WriteF(' as a gift.')
      CASE TEXT_EMPTY; WriteF('nothing.')
      DEFAULT; Raise(TEST_UNDEFINED)
    ENDSELECT
    WriteF('\n')
    END iter
  ENDFOR
EXCEPT
  SELECT exception
    CASE TEST_UNDEFINED
      WriteF('Encountered undefined behavior.\n')
    CASE TEST_OK
      WriteF('Ended successfully.\n')
  ENDSELECT
  IF iter THEN END iter
  IF list THEN END list
ENDPROC
