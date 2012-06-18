HLOUSR2 ;ALB/CJM -ListManager Screen for viewing messages(continued);12 JUN 1997 10:00 am
 ;;1.6;HEALTH LEVEL SEVEN;**126**;Oct 13, 1995
 ;
EN ;
 D WAIT^DICD
 D EN^VALM("HLO MESSAGE VIEWER")
 Q
 ;
SHOWLIST(TYPE) ;
 ;TYPE= "SE", "AE", "TF"
 N PARMS,I
 S (VALMBG,VALMCNT,I)=0
 D CLEAN^VALM10
 S VALMBG=1
 I '$$ASKPARMS(.PARMS) S VALMBCK="" Q
 I PARMS("ALL") D
 .N APP
 .S APP=""
 .F  S APP=$O(^HLB("ERRORS",TYPE,APP)) Q:APP=""  Q:I>500  D
 ..N TIME,IEN
 ..S TIME=PARMS("START")
 ..Q:($O(^HLB("ERRORS",TYPE,APP,TIME))="")
 ..S @VALMAR@($$I,0)="Application: "_APP
 ..D CNTRL^VALM10(VALMCNT,14,$L(APP),IOINHI,IOINORM)
 ..F  S TIME=$O(^HLB("ERRORS",TYPE,APP,TIME)) Q:'TIME  Q:VALMCNT>500  S IEN="" F  S IEN=$O(^HLB("ERRORS",TYPE,APP,TIME,IEN)) Q:IEN=""  Q:VALMCNT>500  D ADDTO(TYPE,IEN,TIME)
 E  D
 .N APP
 .S APP=PARMS("APP")
 .N TIME,IEN
 .S TIME=PARMS("START")
 .Q:$O(^HLB("ERRORS",TYPE,APP,TIME))=""
 .S @VALMAR@($$I,0)="Application: "_APP
 .D CNTRL^VALM10(VALMCNT,14,$L(APP),IOINHI,IOINORM)
 .F  S TIME=$O(^HLB("ERRORS",TYPE,APP,TIME)) Q:'TIME  Q:VALMCNT>500  S IEN="" F  S IEN=$O(^HLB("ERRORS",TYPE,APP,TIME,IEN)) Q:IEN=""  Q:VALMCNT>500  D ADDTO(TYPE,IEN,TIME)
 ;
SHOW S VALMBCK="R"
 ;
 Q
ADDTO(LTYPE,IEN,TIME) ;
 N NODE,MSG
 Q:'$$GETMSG^HLOMSG(+IEN,.MSG)
 I LTYPE'="AE" D
 .N TYPE
 .S TYPE=$S(MSG("BATCH"):"BATCH",1:MSG("MESSAGE TYPE")_"~"_MSG("EVENT"))
 .S @VALMAR@($$I,0)="  "_$$LJ(MSG("ID"),15)_$$LJ(TYPE,8)_$$LJ($$FMTE^XLFDT(TIME,2),20)_MSG("STATUS","ERROR TEXT")
 .D CNTRL^VALM10(VALMCNT,3,15,IOINHI,IOINORM)
 .S:MSG("ID")]"" @VALMAR@("INDEX",MSG("ID"))=IEN
 E  D
 .;application errors - could be an error to a msg within a batch
 .;also, need to go to the ack msg to get the error text from the MSA segment
 .;
 .N SUBIEN,MSA,ERRTEXT
 .S (ERRTEXT,MSA)=""
 .S SUBIEN=$P(IEN,"^",2)
 .;within batch?
 .D:SUBIEN GETMSGB^HLOMSG1(.MSG,SUBIEN,.MSG)
 .I MSG("ACK BY")]"",($$FINDMSG^HLOMSG1(MSG("ACK BY"),.LIST)=1) D
 ..N MSG,SEG,FS
 ..S IEN=+LIST(1),SUBIEN=$P(LIST(1),"^",2)
 ..Q:'$$GETMSG^HLOMSG(IEN,.MSG)
 ..I SUBIEN S MSG("BATCH","CURRENT MESSAGE")=SUBIEN,MSG("LINE COUNT")=0
 ..F  Q:'$$HLNEXT^HLOMSG(.MSG,.SEG)  I $E(SEG(1),1,3)="MSA" S MSA=SEG(1),FS=$E(MSA,4),ERRTEXT=$P(MSA,FS,4) Q
 .S:ERRTEXT="" ERRTEXT=MSG("STATUS","ERROR TEXT")
 .S @VALMAR@($$I,0)="  "_$$LJ(MSG("ID"),15)_$$LJ(MSG("MESSAGE TYPE")_"~"_MSG("EVENT"),8)_$$LJ($$FMTE^XLFDT(MSG("DT/TM CREATED"),2),20)_$E(ERRTEXT,1,37)
 .D CNTRL^VALM10(VALMCNT,3,15,IOINHI,IOINORM)
 .I $L(ERRTEXT)>37 D
 ..S @VALMAR@($$I,0)="~"_$E(ERRTEXT,38,112)
 ..D CNTRL^VALM10(VALMCNT,1,1,IORVON,IORVOFF)
 .S:MSG("ID")]"" @VALMAR@("INDEX",MSG("ID"))=IEN
 Q
 ;
ASKPARMS(PARMS) ;
 K PARMS
 S PARMS("START")=$$ASKBEGIN("T-1")
 I 'PARMS("START") Q 0
 S PARMS("ALL")=$$ASKYESNO("Include ALL applications","YES")
 I PARMS("ALL") Q 1
 I PARMS("ALL")="" Q 0
 S PARMS("APP")=$$ASKAPP
 I PARMS("APP")="" Q 0
 Q 1
 ;
ASKAPP() ;
 D FULL^VALM1
 S VALMBCK="R"
 N DIR
 S DIR(0)="F^3:60"
 S DIR("A")="Application"
 S DIR("?")="Enter the full name of the application, or '^' to exit."
 S DIR("?",1)="For transmission failures, enter the sending application. "
 S DIR("?",2)="For other errors, enter the name of the receiving application. "
 D ^DIR
 I $D(DIRUT)!(Y="") Q ""
 Q Y
 ;
ASKYESNO(PROMPT,DEFAULT) ;
 ;Description: Displays PROMPT, appending '?'.  Expects a YES NO response
 ;Input:
 ;   PROMPT - text to display as prompt.  Appends '?'
 ;   DEFAULT - (optional) YES or NO.  If not passed, defaults to YES
 ;Output:
 ;  Function value: 1 if yes, 0 if no, "" if '^' entered or timeout
 ;
 N DIR,Y
 S DIR(0)="Y"
 S DIR("A")=PROMPT
 S DIR("B")=$S($G(DEFAULT)="NO":"NO",1:"YES")
 D ^DIR
 Q:$D(DIRUT) ""
 Q Y
 ;
STRTSTPQ ;
 ;action to start or stop a queue, either incoming or outgoing
 ;
 N STOP,INOROUT,QUE
 S VALMBCK="R"
 D FULL^VALM1
 ;ask if stop or start
 D  Q:STOP=""
 .N DIR
 .S DIR(0)="S^1:START;2:STOP"
 .S DIR("A")="Do you want to START or STOP a queue"
 .S DIR("B")="1"
 .D ^DIR
 .S STOP=$S(Y=1:0,Y=2:1,1:"")
 ;ask if in or out
 D  Q:INOROUT=""
 .N DIR
 .S DIR(0)="S^I:INCOMING;O:OUTGOING"
 .S DIR("A")="Do you want to "_$S(STOP:"stop",1:"start")_" an incoming queue or an outgoing queue"
 .S DIR("B")="I"
 .D ^DIR
 .S INOROUT=$S(Y="I":"IN",Y="O":"OUT",1:"")
 S QUE=$$ASKQUE(INOROUT)
 Q:QUE=""
 I STOP=$$STOPPED^HLOQUE(INOROUT,QUE) D
 .N C
 .I STOP D
 ..W !,"That queue is already stopped!"
 .E  W !,"That queue is not stopped!"
 .W !,IOINHI,"Hit any key to continue...",IOINORM
 .R *C:DTIME
 E  D
 .N C
 .D:STOP STOPQUE^HLOQUE(INOROUT,QUE)
 .D:'STOP STARTQUE^HLOQUE(INOROUT,QUE)
 .W !,"DONE!"
 .W !,IOINHI,"Hit any key to continue...",IOINORM
 .R *C:DTIME
 .D @HLRFRSH
 Q
 ;
ASKQUE(DIR) ;
 N QUEUE
AGAIN W !,"Enter the full, exact name of queue:"
 S QUEUE=""
 R QUEUE:60 I '$T Q ""
 I $E(QUEUE)="?" W !,"Each message is placed on a queue that has an arbitrary name up to 20",!,"characters long." I $$ASKYESNO("Would you like to see a list of the queues that currently exist","NO") D  G AGAIN
 .N SUB,QUE,QUIT,COUNT
 .K ^TMP($J,"HLO QUEUES")
 .S SUB=""
 .F  S SUB=$O(^HLB("QUEUE",DIR,SUB)) Q:SUB=""  D
 ..S QUE=""
 ..F  S QUE=$O(^HLB("QUEUE",DIR,SUB,QUE)) Q:QUE=""  S ^TMP($J,"HLO QUEUES",QUE)=""
 .S QUE=""
 .S IOSL=$G(IOSL,20)
 .S (COUNT,QUIT)=0
 .W !
 .F  S QUE=$O(^TMP($J,"HLO QUEUES",QUE)) Q:QUE=""  Q:QUIT  D
 ..W !,QUE
 ..S COUNT=COUNT+1
 ..I COUNT>(IOSL-3) D
 ...N Y
 ...D PAUSE^VALM1
 ...I 'Y S QUIT=1
 ...S COUNT=0
 .W !
 .K ^TMP($J,"HLO QUEUES")
 Q:$E(QUEUE)="?" ""
 Q:$E(QUEUE)="^" ""
 Q QUEUE
 ;
ASKBEGIN(DEFAULT) ;
 ;Description: Asks the user to enter a beginning date.
 ;Input: DEFAULT - the suggested default dt/time (optional)
 ;Output: Returns the date as the function value, or 0 if the user does not select a date
 ;
 ;
 N %DT
 S %DT="AEST"
 S %DT("A")="Enter the beginning date/time: "
 S %DT("B")=$$FMTE^XLFDT($S($L($G(DEFAULT)):DEFAULT,1:$$FMADD^XLFDT(DT,-1)))
 S %DT(0)="-NOW"
 Q:$D(DTOUT) 0
 D ^%DT
 I Y=-1 Q 0
 Q Y
 ;
ASKEND(BEGIN) ;
 ;Description: Asks the user to enter an ending date/time
 ;Input: BEGIN - the earliest date/time allowed
 ;Output: Returns the date as the function value, or 0 if the user does not select a date/time
 ;
 N %DT
 S %DT="AEST"
 S %DT("A")="Enter the ending date/time: "
 S %DT("B")="NOW"
 S %DT(0)=BEGIN
 Q:$D(DTOUT) 0
 D ^%DT
 I Y=-1 Q 0
 Q Y
 ;
LJ(STRING,LEN) ;
 Q $$LJ^XLFSTR(STRING,LEN)
 ;
I() ;
 S VALMCNT=VALMCNT+1
 Q VALMCNT
 ;
HEADER ;
 Q
