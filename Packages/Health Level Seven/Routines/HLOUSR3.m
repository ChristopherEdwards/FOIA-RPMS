HLOUSR3 ;ALB/CJM -ListManager Screen for viewing messages(continued);12 JUN 1997 10:00 am
 ;;1.6;HEALTH LEVEL SEVEN;**126**;Oct 13, 1995
 ;
 ;
EN ;
 N HLPARMS
 D FULL^VALM1
 I '$$ASK(.HLPARMS) S VALMBCK="R" Q
 D WAIT^DICD
 D EN^VALM("HLO MESSAGE SEARCH")
 Q
SEARCH ;
 N I,APP,START,END,DIR,MSG,EVENT,TIME
 D EXIT
 S I=""
 F  S I=$O(HLPARMS(I)) Q:I=""  S @I=HLPARMS(I)
 K HLPARMS
 S (VALMCNT,I)=0
 S TIME=START
 F  S TIME=$O(^HLB("SEARCH",DIR,TIME)) Q:'TIME  Q:TIME>END  Q:VALMCNT>600  D
 .N SAPP S SAPP=""
 .S:APP'="" SAPP=$O(^HLB("SEARCH",DIR,TIME,APP),-1)
 .F  S SAPP=$O(^HLB("SEARCH",DIR,TIME,SAPP)) Q:SAPP=""  Q:$E(SAPP,1,$L(APP))]APP  Q:VALMCNT>600  D:$E(SAPP,1,$L(APP))=APP
 ..N SMSG S SMSG=""
 ..S:MSG'="" SMSG=$O(^HLB("SEARCH",DIR,TIME,SAPP,MSG),-1)
 ..F  S SMSG=$O(^HLB("SEARCH",DIR,TIME,SAPP,SMSG)) Q:SMSG=""  Q:$E(SMSG,1,$L(MSG))]MSG  Q:VALMCNT>600  D:$E(SMSG,1,$L(MSG))=MSG
 ...N SEVENT S SEVENT=""
 ...S:EVENT'="" SEVENT=$O(^HLB("SEARCH",DIR,TIME,SAPP,SMSG,EVENT),-1)
 ...F  S SEVENT=$O(^HLB("SEARCH",DIR,TIME,SAPP,SMSG,SEVENT)) Q:SEVENT=""  Q:$E(SEVENT,1,$L(EVENT))]EVENT  Q:VALMCNT>600  D:$E(SEVENT,1,$L(EVENT))=EVENT
 ....N IEN
 ....S IEN=""
 ....F  S IEN=$O(^HLB("SEARCH",DIR,TIME,SAPP,SMSG,SEVENT,IEN)) Q:IEN=""  Q:VALMCNT>600  D ADDTO(DIR,TIME,SAPP,SMSG,SEVENT,IEN)
 ;
 ;
END S VALMBCK="R"
 ;
 Q
ADDTO(DIR,TIME,APP,MSG,EVENT,IEN) ;
 N HDR,FS,LOC,MSGID
 S MSGID=$S($P(IEN,"^",2):$P($G(^HLB(+IEN,3,$P(IEN,"^",2),0)),"^",2),1:$P($G(^HLB(IEN,0)),"^",1))
 S HDR=$G(^HLB(+IEN,1))
 S FS=$E(HDR,4)
 I FS'="" D
 .I DIR="IN" S LOC=$P(HDR,FS,4)
 .I DIR'="IN" S LOC=$P(HDR,FS,6)
 E  S LOC=""
 S @VALMAR@($$I,0)=$$LJ(MSGID,25)_$$LJ(APP,30)_" "_MSG_"~"_EVENT
 D CNTRL^VALM10(VALMCNT,1,25,IOINHI,IOINORM)
 S @VALMAR@($$I,0)="     "_$$LJ($$FMTE^XLFDT(TIME,2),20)_$$LJ(LOC,60)
 S @VALMAR@($$I,0)=""
 Q
LJ(STRING,LEN) ;
 Q $$LJ^XLFSTR(STRING,LEN)
 ;
I() ;
 S VALMCNT=VALMCNT+1
 Q VALMCNT
 ;
ASK(PARMS) ;
 N SUB
 F SUB="START","END","EVENT","APP","MSG","DIR" S PARMS(SUB)=""
 S PARMS("START")=$$ASKBEGIN^HLOUSR2()
 Q:'PARMS("START") 0
 S PARMS("END")=$$ASKEND^HLOUSR2(PARMS("START"))
 Q:'PARMS("END") 0
 S PARMS("APP")=$$ASKAPP()
 Q:PARMS("APP")=-1 0
 S PARMS("MSG")=$$ASKMSG()
 Q:PARMS("MSG")=-1 0
 S PARMS("EVENT")=$$ASKEVENT()
 Q:PARMS("EVENT")=-1 0
 S PARMS("DIR")=$$ASKDIR()
 Q:PARMS("DIR")=-1 0
 S PARMS("DIR")=$S(PARMS("DIR")="I":"IN",1:"OUT")
 Q 1
 ;
ASKAPP() ;
 N DIR
 S DIR(0)="FO^0:60"
 S DIR("A")="Application"
 S DIR("?",1)="Enter the name of the application, or '^' to exit."
 S DIR("?")="You can enter just the first part of the name."
 D ^DIR
 Q:$D(DTOUT)!$D(DUOUT) -1
 Q X
ASKMSG() ;
 N DIR
 S DIR(0)="FO^0:3"
 S DIR("A")="HL7 Message Type"
 S DIR("?",1)="Enter the 3 character message type (e.g. MFN, ADT), or '^' to exit."
 S DIR("?")="You can enter just the first character or two."
 D ^DIR
 Q:$D(DTOUT)!$D(DUOUT) -1
 Q X
ASKEVENT() ;
 N DIR
 S DIR(0)="FO^0:3"
 S DIR("A")="HL7 Event"
 S DIR("?",1)="Enter the 3 character event type, or '^' to exit."
 S DIR("?")="You can enter just the first character or two."
 D ^DIR
 Q:$D(DTOUT)!$D(DUOUT) -1
 Q X
ASKDIR() ;
 N DIR
 S DIR(0)="S^I:INCOMING;O:OUTGOING"
 S DIR("A")="Incoming or Outgoing"
 S DIR("?",1)="Are you searching for an incoming message or an outgoing message?"
 S DIR("?")="You can enter '^' to exit"
 D ^DIR
 Q:$D(DTOUT)!$D(DUOUT) -1
 Q X
HDR ;
 S VALMHDR(1)="MsgID                    Application                    MsgType"
 Q
HLP ;
 Q
EXIT ;
 D CLEAN^VALM10
 D CLEAR^VALM1
 S VALMBCK="R"
 Q
