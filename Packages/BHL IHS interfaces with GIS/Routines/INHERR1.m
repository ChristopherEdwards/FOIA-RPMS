INHERR1 ;DJL; 28 Feb 95 10:40;Interface - Error Search
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
EXPAND(INTEMPLT,INFILE) ;Expand-action logic on List Processor field
 ; MODULE NAME: EXPAND (Expand-action logic for ^DWL )
 ; DESCRIPTION: Expand using print template name passed and
 ;              on the file passed.
 ; RETURN = none
 ; PARAMETERS
 ;    INTEMPLT = The print template to use
 ;    INFILE   = The file to use
 ; CODE BEGINS
 N I,X,DIC,DR,DHD,DW,DWCP,INIO,DIE,DA
 Q:'$D(@DWLRF@($P(@DWLRF,U,4),0))
 D CLEAR^DW
 S %ZIS="N" D ^%ZIS Q:POP  S INIO=IO,IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 S DA(@DWLRF@($P(@DWLRF,U,4),0))=""
 S DR=INTEMPLT,DIC=INFILE,DHD="@" D PRTLIST^DWPR
 S:INIO=IO X=$$CR^UTSRD
 Q
 ;
INERSRCH(INETEXT,INEIEN,INELOGIC) ; Test error for text-string match(multi)
 ; MODULE NAME: INERSRCH (Interface Error MESSAGE Search)
 ; DESCRIPTION: Search ^INTHER( INEIEN ) error for matching values to
 ;              the search string array: INETEXT.
 ; RETURN= PASS/FAIL (1/0)
 ; PARAMETERS:
 ;   INETEXT= search string array with base node("INTEXT") set to
 ;             subscript count value and subscript nodes containing
 ;             the strings
 ;   INEIEN= The IEN of the error in the ^INTHER error file
 ;   INELOGIC= The matching logic switch set to 1 or 0
 ;             1= ANDing functionality RE:all strings must be found
 ;                in the error
 ;             0= ORing functionality RE:only one string need match
 ; CODE BEGINS
 N X,INEFOUND,INELINE,INENODE
 S (INEFOUND,INENODE)=0 F  S INENODE=$O(^INTHER(INEIEN,2,INENODE)) Q:'INENODE!INEFOUND  D
 .  S INELINE=^INTHER(INEIEN,2,INENODE,0)
 .  I '$D(INELINE) Q
 .; loop through the strings for the current error
 .; For enhances text searching use MSGPACK^INHMS1
 .  S INEFOUND=$$INLSRCH(.INETEXT,.INELINE,.INEFOUND,INELOGIC)
 .; no items were found or AND functionality is used.
 .; test if any of INEFOUND(n) are not TRUE quit with 0 returned
 .  I INELOGIC S INEFOUND=1,X="" F  S X=$O(INETEXT("INTEXT",X)) Q:'X  I '$D(INEFOUND(X)) S INEFOUND=0 Q
 Q INEFOUND
 ;
INLSRCH(SRCHTEXT,MSGTEXT,INFOUND,INLOGIC) ; Test error for text-string
 ;                                          match(one line)
 ; MODULE NAME: INLSRCH (Interface Error LINE Search)
 ; DESCRIPTION: To find a search string in a error which may be a
 ;              continuation line or not. The search line MAY be
 ;              split across multiple lines.
 ; RETURN= PASS/FAIL (1/0)
 ; PARAMETERS:
 ;   SRCHTEXT(PBR)= The array of search string containing less than a 70 char.
 ;             count value and subscript nodes containing the strings
 ;   MSGTEXT(PBR)= error text/array
 ;   INFOUND(PBR)= The array used to indicate strings matches found.
 ;   INLOGIC(PBV)= The flag indicating the type(OR/AND) of logic used with
 ;            matching error data and the search strings.
 ; CODE BEGINS
 N BUF,INQUIT,INNODE
 ; pack the error into 250 char./node error
 ; *** COMMENTED-OUT(following line) FOR ERROR SEARCH ONLY ***
 ;D MSGPACK(.MSGTEXT)
 S BUF=MSGTEXT,(INFOUND,INQUIT)=0
 F  Q:INFOUND!INQUIT  D
 .; loop thru the strings(SRCHTEXT("INTEXT")) to match
 .; setting a corresponding node(INFOUND(n))=TRUE if a match is
 .; found. quit on a single 'find' for OR functionality
 .  S INNODE="" F  S INNODE=$O(SRCHTEXT("INTEXT",INNODE)) Q:'INNODE  I BUF[SRCHTEXT("INTEXT",INNODE) S INFOUND(INNODE)=1 I 'INLOGIC S INFOUND=1 Q
 .; if OR functionity and a error was found then quit looping thru
 .; this error
 .  I 'INLOGIC,INFOUND Q
 .;  quit if there are no more lines to test
 .  I '$O(MSGTEXT("")) S INQUIT=1 Q
 .;  move the last 69 char to the front of buffer and repack the array
 .; *** COMMENTED-OUT(following line) FOR ERROR SEARCH ONLY ***
 .;  S MSGTEXT=$E(BUF,181,999) D MSGPACK(.MSGTEXT) S BUF=MSGTEXT
 .  Q
 Q INFOUND
 ;
