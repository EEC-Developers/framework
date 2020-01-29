/* test hashing functions

identifiers are generated in amounts of 10,100,1000, which are
then hashed with tables of size 1, 211, 941, 3911 and 16267.
Displayed are the average number of StrCmp()'s needed to find
any of these identifiers.

*/

MODULE '*hash'

RAISE "MEM" IF String()=NIL

PROC main()
  DEF heavy:PTR TO LONG,a,b,l,num:PTR TO LONG,t=NIL:PTR TO hashtable,
      c,ll,n,h,link:PTR TO hashlink,rs[10]:STRING
  heavy:=[1,HASH_NORMAL,HASH_MEDIUM,HASH_BIG,HASH_HUGE]
  num:=[10,100,1000]
  l:=genidents(1000)
  WriteF('numidents:')
  FOR b:=0 TO 2 DO WriteF('\t\d\t',num[b])
  WriteF('\ntablesize:\n')
  FOR a:=0 TO 4
    WriteF('[\d]\t\t',heavy[a])
    FOR b:=0 TO 2
      NEW t.hashtable(heavy[a])
      ll:=l
      FOR c:=1 TO num[b]
        n,h:=t.find(ll,EstrLen(ll))
        t.add(NEW link,h,ll,EstrLen(ll))
        ll:=Next(ll)
      ENDFOR
->      WriteF('\s[8]\t',RealF(rs,t.calc_hash_spread(),4))
      END t
    ENDFOR
    WriteF('\n')
  ENDFOR
ENDPROC

-> generate some random identifiers

PROC genidents(n)
  DEF l=NIL,a,s[100]:STRING,x:PTR TO LONG,len,prt,b,y
  x:=['bla','burp','e_','pom','ti','dom','aap','noot','mies']
  len:=ListLen(x)
  FOR a:=1 TO n
    StrCopy(s,'')
    StrAdd(s,(y:=Rnd(26)+"A") BUT {y}+3,1)
    StrAdd(s,(y:=Rnd(26)+"a") BUT {y}+3,1)
    StrAdd(s,(y:=Rnd(26)+"A") BUT {y}+3,1)
    prt:=Rnd(3)+1
    FOR b:=1 TO prt DO StrAdd(s,x[Rnd(len)])
    StrAdd(s,(y:=Rnd(26)+"A") BUT {y}+3,1)
    StrAdd(s,(y:=Rnd(26)+"a") BUT {y}+3,1)
    StrAdd(s,(y:=Rnd(26)+"A") BUT {y}+3,1)
    l:=Link(StrCopy(String(EstrLen(s)),s),l)
  ENDFOR
ENDPROC l
