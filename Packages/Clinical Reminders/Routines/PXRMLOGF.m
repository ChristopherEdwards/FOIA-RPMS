PXRMLOGF ;SLC/PKR - Clinical Reminders logic routines. ;01/25/2002
 ;;1.5;CLINICAL REMINDERS;**8**;Jun 19, 2000
 ;
 ;=======================================================================
BFUNLIST(LIST) ;Build the list of logic functions. The list has the form
 ;LIST("function name")=variable name_;_function. Where variable name
 ;is the name of the FIEVAL variable, for example FIEVAL(1,"DATE")
 ;and function is the actual function used to process the FIEVAL
 ;data.
 S LIST("MRD")="DATE;$$MAX^PXRMLOGF"
 Q
 ;
 ;=======================================================================
MAX(LIST) ;Return the max from a comma separated list.
 N IND,MAX,NUM
 S NUM=$L(LIST,",")
 S MAX=+$P(LIST,",",1)
 I NUM>1 D
 . F IND=2:1:NUM D
 .. S TEMP=+$P(LIST,",",IND)
 .. I TEMP>MAX S MAX=TEMP
 Q MAX
 ;
 ;=======================================================================
MP(STRING,LP,RP) ;Given a string starting with LP find its match RP and
 ;return the position number. This is used to find things like matching
 ;parentheses.
 N CHAR,DONE,LEN,PN,SP,STACK,TEMP
 S (DONE,SP)=0
 S LEN=$L(STRING)
 F PN=1:1:LEN Q:DONE  D
 . S CHAR=$E(STRING,PN)
 . I CHAR=LP D PUSH^PXRMLOG(.STACK,.SP,CHAR)
 . I CHAR=RP S TEMP=$$POP^PXRMLOG(.STACK,.SP)
 . I SP=0 S LEN=PN,DONE=1 Q
 Q LEN
 ;
 ;=======================================================================
REPFUN(LOGSTR) ;Replace any special reminders functions in a logic string
 ;with the code required to actually do the evaluation. Called as
 ;part of the set logic when custom logic is stored.
 N FILIST,FINDING,FNC,FUNCTION,FUNLIST,FUNNAME,FUNSTR,IND
 N LPP,NAK,NUM,RPP,TEMP,TFUNSTR,TLOGSTR,VAR
 S NAK=$C(21)
 S TLOGSTR=LOGSTR
 ;Initialize the function list
 D BFUNLIST(.FUNLIST)
 ;Process the functions in the string.
 S FUNNAME=""
 F  S FUNNAME=$O(FUNLIST(FUNNAME)) Q:FUNNAME=""  D
 . S FNC=0
 . S VAR=$P(FUNLIST(FUNNAME),";",1)
 . S FUNCTION=$P(FUNLIST(FUNNAME),";",2)
 . F  S FNC=$F(TLOGSTR,FUNNAME,FNC) Q:FNC=0  D
 .. S TEMP=$E(TLOGSTR,FNC,245)
 .. S LPP=FNC
 .. S RPP=$$MP(TEMP,"(",")")+LPP-1
 .. S (FUNSTR,TFUNSTR)=$E(TLOGSTR,(LPP-3),RPP)
 .. S FILIST=$E(TLOGSTR,(LPP+1),(RPP-1))
 .. S NUM=$L(FILIST,",")
 .. F IND=1:1:NUM D
 ... S FINDING=$P(FILIST,",",IND)
 ... S TEMP=$$STRREP^PXRMUTIL(FINDING,")",","""_VAR_""")")
 ...;Turn the list into a string.
 ... I IND=1 S TEMP=""""_TEMP
 ... I IND=NUM S TEMP=TEMP_""""
 ... S TFUNSTR=$$STRREP^PXRMUTIL(TFUNSTR,FINDING,TEMP)
 .. S TLOGSTR=$$STRREP^PXRMUTIL(TLOGSTR,FUNSTR,TFUNSTR)
 . S TLOGSTR=$$STRREP^PXRMUTIL(TLOGSTR,FUNNAME,FUNCTION)
 S TLOGSTR=$TR(TLOGSTR,"^",NAK)
 Q TLOGSTR
 ;
