INHMS1 ;DJL; 18 Jun 99 13:51;Interface - Message Search
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
EXPAND ;Expand-action logic on List Processor field
 ; MODULE NAME: EXPAND (Expand-action logic for ^DWL )
 ; DESCRIPTION: Expand using INH MESSAGE DISPLAY print
 ;              template.
 ; RETURN = none
 ; PARAMETERS = none
 ; CODE BEGINS
 N I,X,DIC,DR,DHD,DW,DWCP,INIO,DIE,DA
 Q:'$D(@DWLRF@($P(@DWLRF,U,4),0))
 D CLEAR^DW
 S %ZIS="N" D ^%ZIS Q:POP  S INIO=IO,IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 S DA(@DWLRF@($P(@DWLRF,U,4),0))=""
 S DR="INH MESSAGE DISPLAY",DIC=4001,DHD="@" D PRTLIST^DWPR
 S:INIO=IO X=$$CR^UTSRD
 Q
 ;
INMSPAT(INIEN,INPAT,INPATNAM) ; Test msg. for a patient match
 ; MODULE NAME: INMSPAT (Interface Message PATIENT Search)
 ; DESCRIPTION: Search ^INTHU( INIEN ) message PID segment for matching
 ;               values to the string: INPAT. Using CHCS patient IEN for
 ;               outbound messages and FMP/SSN for inbound messages
 ; RETURN= PASS/FAIL (1/0) and patient found set in INPATNAM 
 ; PARAMETERS:
 ;   INIEN= The IEN of the message in the ^INTHU message file
 ;   INPAT= The patients internal IEN from the ^DPT file
 ;   INPATNAM= The patient name found in the message ("" if none)
 ; CODE BEGINS
 S INPATNAM=$G(INPATNAM),INPAT=+$G(INPAT)
 Q:'INIEN 0
 N INPATFND,INDPTNAM,INDPTSSN,INPIDFND,INBLDCT,INBLDTXT,INDEL,INSUBDEL,INQUIT
 I $$MSGSTD^INHUTC51(INIEN)="NCPDP" Q $$INNCPAT^INHUTC51(INIEN,$G(INSRCH("INPAT")))
 ;
 S (INPATFND,INPIDFND,INBLDCT)=0,INBLDTXT="" D GETLINE^INHOU(INIEN,.INBLDCT,.INBLDTXT)
 Q:'$D(INBLDTXT) 0
 ; if 'MSH' begins the string then get delimiters for the msg.
 ;    and loop thru msg. until 'PID' segment is found
 I $E(INBLDTXT,1,3)="MSH" S INDEL=$E(INBLDTXT,4),INSUBDEL=$E(INBLDTXT,5),INQUIT=0 F  Q:INQUIT  D
 .  D GETLINE^INHOU(INIEN,.INBLDCT,.INBLDTXT)
 .  I '$D(INBLDTXT) S INQUIT=1 Q
 .  S:$E(INBLDTXT,1,3)="PID" (INQUIT,INPIDFND)=1
 ; if the 'PID' segment is found look into the segment to match
 ;  the patients IEN if 'Outbound' msg. or name & FMPSSN if
 ;  'Inbound' msg.
 D:INPIDFND
 .; set the patient name variable
 .  S INPATNAM=$P(INBLDTXT,INDEL,6)
 .; check the OUTBOUND msg with the patient IEN for uniqueness
 .  I $P(^INTHU(INIEN,0),U,10)="O" S:+$P(INBLDTXT,INDEL,4)=INPAT INPATFND=1
 .  I $P(^INTHU(INIEN,0),U,10)="I" D
 ..; for INBOUND msg check the patients name AND FMP/SSN matches
 ..;     for uniqueness
 ..    S INDPTNAM=$P($G(^DPT(INPAT,0)),U,1),INDPTSSN=$P($G(^DPT(INPAT,0)),U,15)
 ..    I (INPATNAM=$$PN^INHUT(INDPTNAM)),($TR($P(INBLDTXT,INDEL,5),"-","")=INDPTSSN) S INPATFND=1
 .  S INPATNAM=$$HLPN^INHUT1(INPATNAM,INSUBDEL)
 Q INPATFND
 ;
INMSRCH(INMSTEXT,INMIEN,INMLOGIC) ; Test msg. for text-string match(multi)
 ; MODULE NAME: INMSRCH (Interface Message MESSAGE Search)
 ; DESCRIPTION: Search ^INTHU( INMIEN ) message for matching values to
 ;              the search string array: INMSTEXT.
 ; RETURN= PASS/FAIL (1/0)
 ; PARAMETERS:
 ;   INMSTEXT= search string array with base node("INTEXT") set to
 ;             subscript count value and subscript nodes containing
 ;             the strings
 ;   INMIEN= The IEN of the message in the ^INTHU message file
 ;   INMLOGIC= The matching logic switch set to 1 or 0
 ;             1= ANDing functionality RE:all strings must be found
 ;                in the message
 ;             0= ORing functionality RE:only one string need match
 ; CODE BEGINS
 N X,INMFOUND,INMQUIT,INMCT,INMLINE,INMNODE
 S (INMFOUND,INMQUIT,INMCT)=0,INMLINE="",INMNODE=1
 F  Q:INMQUIT!INMFOUND  D
 .  D GETLINE^INHOU(INMIEN,.INMCT,.INMLINE)
 .  I '$D(INMLINE) S INMQUIT=1 Q
 .; loop through the strings for the current message
 .  S INMFOUND=$$INLSRCH(.INMSTEXT,.INMLINE,.INMFOUND,INMLOGIC)
 .; no items were found or AND functionality is used.
 .; test if any of INMFOUND(n) are not TRUE quit with 0 returned
 .  I INMLOGIC S INMFOUND=1,X="" F  S X=$O(INMSTEXT("INTEXT",X)) Q:'X  I '$D(INMFOUND(X)) S INMFOUND=0 Q
 Q INMFOUND
 ;
INLSRCH(SRCHTEXT,MSGTEXT,INFOUND,INLOGIC) ; Test msg. for text-string
 ;                                          match(one line)
 ; MODULE NAME: INLSRCH (Interface Message LINE Search)
 ; DESCRIPTION: To find a search string in a message which may be a
 ;              continuation line or not. The search line MAY be
 ;              split across multiple lines.
 ; RETURN= PASS/FAIL (1/0)
 ; PARAMETERS:
 ;   SRCHTEXT= The array of search string containing less than a 70 char.
 ;             count value and subscript nodes containing the strings
 ;   MSGTEXT= NON-HL7 message text/array typical of those returned by
 ;            GETLINE^INHOU.
 ;   INFOUND= The array used to indicate strings matches found.
 ;   INLOGIC= The flag indicating the type(OR/AND) of logic used with
 ;            matching message data and the search strings.
 ; CODE BEGINS
 N BUF,INQUIT,INNODE
 ; pack the message into 250 char./node message
 D MSGPACK(.MSGTEXT)
 S BUF=MSGTEXT,(INFOUND,INQUIT)=0
 F  Q:INFOUND!INQUIT  D
 .; loop thru the strings(SRCHTEXT("INTEXT")) to match
 .; setting a corresponding node(INFOUND(n))=TRUE if a match is
 .; found. quit on a single 'find' for OR functionality
 .  S INNODE="" F  S INNODE=$O(SRCHTEXT("INTEXT",INNODE)) Q:'INNODE  I BUF[SRCHTEXT("INTEXT",INNODE) S INFOUND(INNODE)=1 I 'INLOGIC S INFOUND=1 Q
 .; if OR functionity and a message was found then quit looping thru
 .; this message
 .  I 'INLOGIC,INFOUND Q
 .;  quit if there are no more lines to test
 .  I '$O(MSGTEXT("")) S INQUIT=1 Q
 .;  move the last 69 char to the front of buffer and repack the array
 .  S MSGTEXT=$E(BUF,181,999) D MSGPACK(.MSGTEXT) S BUF=MSGTEXT
 .  Q
 Q INFOUND
 ;
MSGPACK(INMSGTXT) ; pack a subscripted array into 250 char./node
 ; MODULE NAME: MSGPACK (Interface Message Segment Packer)
 ; DESCRIPTION: Interface message segments can extend beyond
 ;              250 char. by spanning multiple nodes. These nodes
 ;              are not required to be 250 char. long but string
 ;              searchs are more efficient if larger strings are
 ;              tested. This routine packs an extended message
 ;              segment to the smallest num. of 250 char./node
 ;              possible. Deleting empty nodes in the process.
 ; RETURN= none
 ; PARAMETERS:
 ;   INMSGTXT= The array containing the message.
 ; CODE BEGINS
 N INLINE,INBUFLEN,INNEXT,INFOUND,INQUIT
 ; test for non-subscripted first node if found pack first node here
 I '$O(INMSGTXT(0)) Q
 S INBUFLEN=$L(INMSGTXT),INLINE=$O(INMSGTXT(""))
 S INMSGTXT=INMSGTXT_$E(INMSGTXT(INLINE),1,250-INBUFLEN)
 S INMSGTXT(INLINE)=$E(INMSGTXT(INLINE),251-INBUFLEN,999)
 I '$L(INMSGTXT(INLINE)) K INMSGTXT(INLINE) S INLINE=$O(INMSGTXT(INLINE))
 ;  pack the SUBSCRIPTED message if it is a continued message and any
 ;  of the lines are not full 250 char. lines 
 I INLINE,$O(INMSGTXT(INLINE)) S INQUIT=0 F  D  Q:INQUIT!'$O(INMSGTXT(INLINE))
 .  S INBUFLEN=$L(INMSGTXT(INLINE)),INNEXT=$O(INMSGTXT(INLINE))
 .; append the next line to the current line (up to 250 char. len.)
 .  S INMSGTXT(INLINE)=INMSGTXT(INLINE)_$E(INMSGTXT(INNEXT),1,250-INBUFLEN)
 .; remove the chars. from the next line that were appended to the
 .; current line
 .  S INMSGTXT(INNEXT)=$E(INMSGTXT(INNEXT),251-INBUFLEN,999)
 .; if the current line is still not full delete the now empty next
 .;  node and don't update the current line index
 .  K:'$L(INMSGTXT(INNEXT)) INMSGTXT(INNEXT)
 .  I $L(INMSGTXT(INLINE))=250 S INLINE=$O(INMSGTXT(INLINE))
 .  Q
 Q
 ;
