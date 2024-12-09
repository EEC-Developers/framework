-> Test Text List

MODULE 'Filter/textListBase','Filter/wordWrap','Filter/filterBase',
  'Buffer/stringQueue','Buffer/estring','Buffer/bufferBase',
  'Iterator/iterator','List/listBase','List/singleList'

ENUM TEST_OK,TEST_UNDEFINED

OBJECT name OF single_list_node
  item:PTR TO CHAR
ENDOBJECT

OBJECT text_list OF text_list_base
ENDOBJECT

PROC generate() OF text_list
  DEF buf:PTR TO buffer,work2[128]:STRING
  buf:=self.get_output()
  SELECT self.status
    CASE TEXT_SINGULAR
      StringF(work2,'\s as a gift.',self.work)
      buf.append(work2)
    CASE TEXT_PLURAL
      buf.append(work)
    CASE TEXT_PLURAL_FINAL
      StringF(work2,'\s as gifts.',self.work)
	  buf.append(work2)
    CASE TEXT_EMPTY
	  StringF(work2, 'nothing.')
	  buf.append(work2)
    DEFAULT
      Raise(TEST_UNDEFINED)
  ENDSELECT
ENDPROC

PROC out(n:PTR TO name) IS WriteF('\s',n.item)

PROC main() HANDLE
  DEF lister:PTR TO textListBase,wrap:PTR TO word_wrap,
    filt:PTR TO filter,output:PTR TO estring_buffer,
    q:PTR TO string_queue,iter:PTR TO list_iterator,
    count:REG,node:PTR TO name,
    list:PTR TO single_list_header,content

  NEW output.init(1024)
  NEW filt.init()
  NEW q.init()
  NEW lister.create(filt,q,256,'You received ')
  filt.enqueue(lister)
  NEW wrap.create(filt,output,80)
  filt.enqueue(wrap)

  content:=['a partridge','turtle-doves','french hens',
    'calling birds','gold rings','laying geese',
	'swimming swans','milk maids','pipers','drummers',
	'dancing ladies','leaping lords'
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
    filt.process(iter)
	WriteF('\s',output)
    END iter
  ENDFOR
EXCEPT
  SELECT exception
    CASE TEST_UNDEFINED
      WriteF('Encountered undefined behavior.\n')
    CASE TEST_OK
      WriteF('Ended successfully.\n')
	DEFAULT
	  WriteF('Encountered \s exception.\n',exception)
  ENDSELECT
ENDPROC
