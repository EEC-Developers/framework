-> Test Text List

MODULE 'Filter/textListBase','Filter/wordWrap','Filter/filterBase',
  'Buffer/stringQueue','Buffer/estring','Buffer/bufferBase',
  'Iterator/iterator'

ENUM TEST_OK,TEST_UNDEFINED

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

PROC main() HANDLE
  DEF lister:PTR TO textListBase,wrap:PTR TO word_wrap,
    filt:PTR TO filter,output:PTR TO estring_buffer,
    q:PTR TO string_queue,i:REG,count:REG,
    q2:PTR TO string_queue,content

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
  NEW q2.init()
  FOR count:=0 TO ListLen(content)
    IF count>0
      WriteF('Christmas day number \d.\n',count)
      FOR i:=0 TO count-1
        q2.append(ListItem(content,i))
      ENDFOR
    ELSE
      WriteF('On Christmas Eve\n')
    ENDIF
    filt.process(q2)
    WriteF('\s',output)
  ENDFOR
EXCEPT
  SELECT exception
    CASE TEST_UNDEFINED
      WriteF('Encountered undefined behavior.\n')
    CASE TEST_OK
      WriteF('Ended successfully.\n')
    CASE "MEM"
      WriteF('Out of memory.\n')
    CASE "FILT"
      WriteF('Filter exception occurred.\n')
    DEFAULT
      WriteF('Encountered an unprocessed exception.\n')
  ENDSELECT
ENDPROC
