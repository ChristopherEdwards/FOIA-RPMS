INTSTR ;DGH; 29 Apr 97 16:39;Required field/segment validation 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q  ;no top entry
 ;
EN(INEXPND,INREQLST) ;Entry point with user interaction to select a message
 ;INPUT:
 ;  INEXPND = 1 for expanded display, 0 for not
 ;  INREQLST = (OPT) array of UIF entries
 ;If array of messages to validate is not supplied, prompt.
 ;;Enhancement needed for this tag
 ;;1) %ZIS call
 N DIC,INLST,INUIF,SELCT,INMSG
 I '$D(INREQLST) D
 .W "Select uif entry"
 .S DIC="^INTHU(",DIC(0)="AEQM" D ^DIC W !
 .Q:Y<1
 .S SELCT=1,INREQLST(1)=+Y
 ;If there is still nothing in array, quit
 I '$D(INREQLST) S INMSG="Nothing selected" D IO(INMSG) Q
 ;Otherwise, loop through array
 S INLST="" F  S INLST=$O(INREQLST(INLST)) Q:'INLST  D
 .S INUIF=INREQLST(INLST)
 .;kill activity log multiple
 .K ^INTHU(INUIF,1)
 .S INMSG="UIF Transaction "_$P(^INTHU(INUIF,0),U,5) D IO(INMSG)
 .D MAIN(INUIF,INEXPND)
 ;If selections were made inside this routine, kill them
 I $G(SELCT) K INREQLST
 Q
 ;
MAIN(INUIF,INEXPND) ;Main program loop
 ;INPUT
 ;  INUIF = Entry in UIF to validate
 ;  INEXPND     = 1 for expanded and for not (reverse of INEXPAND
 ;                used in calling routine)
 ;KEY VARIABLES
 ; UIFMES(UCNT) = message array from the UIF file (may be sparse array)
 ; DEFMES       = message array as the message is defined
 ; USID         = segment id for UIF segment
 ; MSID         = segment id for defined message segment
 N LVL,UIFMES,INOUT,OTT,TT1,DMESS,INMSG,DEFMES,INCDEC,INTT,LINE,MSH,MATCH,ORD,OUT,SEGID,VALSTR,VAR,INERR,DEST,TYPE,LVL,UCNT,INDELIM,LCT,EXPAND,IEN,I,J,X,Y,DEBUG,INSUBDEL
 ;If needed, DEBUG will have to be set using a break point
 I $G(DEBUG) D
 .S INMSG="" F I=1:1:79 S INMSG=INMSG_"+"
 .D IO(INMSG)
 S INERR=0 K LVL,UIFMES,DEFMES,LCT
 S INERR=$$UIF^INTSTR1(INUIF,.UIFMES,.INDELIM,.INSUBDEL)
 I INERR S INMSG="Unable to validate required fields" D IO(INMSG) Q
 I '$D(^INTHU(INUIF,3)) S INMSG="Message contains no segments",INERR=1 D IO(INMSG) Q
 I $G(DEBUG) S INMSG="Validating message "_$P(^INTHU(INUIF,0),U,5) D IO(INMSG)
 I $G(DEBUG)>1 D
 .D IO("UIFMES array:")
 .S QX=$Q(UIFMES) Q:'$L(QX)  S INMSG=QX_"="_$G(@(QX)) D IO(INMSG)
 .F  S QX=$Q(@(QX)) Q:'$L(QX)  S INMSG=QX_"="_$G(@(QX)) D IO(INMSG)
 ;Find the message type for this message
 S INOUT=$P(^INTHU(INUIF,0),U,10)
 I INOUT="I" D  Q:INERR
 .;If incoming, get Transaction Type from Destination data
 .S TYPE=$$TYPE^INHOTM(INUIF)
 .I 'DEST S INMSG="Can not validate. Transaction has no destination",INERR=1 D IO(INMSG) Q
 .I 'TYPE S INMSG="Can not validate. Destination has no method of processing",INERR=1 D IO(INMSG) Q
 .I TYPE'=1 S INMSG="Can not validate. This destination is not currently supported",INERR=1 D IO(INMSG) Q
 .S OTT=+$P(^INRHD(DEST,0),U,2) I 'OTT S INMSG="Can not validate. Missing transaction type or entry for destination "_$P(^INRHD(DEST,0),U),INERR=1 D IO(INMSG) Q
 ;If outbound, get originating TT from 11th piece
 I INOUT="O" D  Q:INERR
 .S OTT=$P(^INTHU(INUIF,0),U,11)
 .Q:OTT
 .S INMSG="Can not validate. Originating Transaction Type not found",INERR=1 D IO(INMSG)
 I '$D(^INRHT(OTT)) S INMSG="Can not validate. No entry in Transaction Type File for this transaction type",INERR=1 D IO(INMSG) Q
 S INMSG="Validating Transaction Type: "_$P(^INRHT(OTT,0),U) D IO(INMSG)
 ;Determine if a message uses this originating transaction type.
 D FNDMSG(OTT,.DMESS)
 ;If DMESS is found, compare actual message with this. If it is not
 ;found, it may be a replicated transacton--so check replication file.
 ;If found there, re-define OTT to be the "base" transaction type.
 I 'DMESS,$D(^INRHR("B",OTT)) D
 .S IEN=$O(^INRHR("B",OTT,"")),OTT=$P(^INRHR(IEN,0),U,2)
 .S INMSG="Validating Base Transaction Type: "_$P(^INRHT(OTT,0),U) D IO(INMSG)
 .;Now determine if a message uses the "base" transaction type.
 .D FNDMSG(OTT,.DMESS)
 I 'DMESS S INMSG="Can not validate. No message defined for transaction type" D IO(INMSG) Q
 ;Run the verification
 S INMSG="Validating message: "_$P(^INTHL7M(DMESS,0),U) D IO(INMSG)
 ;;Enhancement: Allow user to select message type instead of doing lookup
 ;W "Select message type"
 ;S DIC="^INTHL7M(",DIC(0)="AEQ" D ^DIC Q:Y<1
 ;also set DIC to default to the type found above.
 D MSG^INTSTR1(DMESS,.DEFMES)
 I '$D(DEFMES) S INMSG="Can not validate. No structure is defined for this message" D IO(INMSG) Q
 I $G(DEBUG)>1 D
 .D IO("DEFMES array:")
 .S QX="DEFMES"
 .F  S QX=$Q(@(QX)) Q:'$L(QX)  S INMSG=QX_"="_$G(@(QX)) D IO(INMSG)
 S LVL(1)=$O(DEFMES("")),UCNT=$O(UIFMES("")),INERR=0
 ;S INCDEC=1 D LOOP^INTSTR2(INUIF,.LVL,.UCNT,.INCDEC,.INERR)
 S INCDEC=1 D LOOP^INTSTR2(INUIF,.LVL,.UIFMES,.UCNT,.INCDEC,.DEFMES,.INERR)
 ;
 ;As final check, loop through UIFMES array to see if all
 ;segments have been validated.
 I INEXPND D IO("---- Required Field summary -------------------------")
 S UCNT="" F  S UCNT=$O(UIFMES(UCNT)) Q:'UCNT  D
 .S STATUS=$P(UIFMES(UCNT),U,2)
 .;In expanded mode, display validation status of all segments.
 .I INEXPND,STATUS D
 ..S INMSG="Segment "_$P(UIFMES(UCNT),U)_": Required fields "_$S(STATUS=1:"present",1:"missing")
 ..D IO(INMSG)
 .Q:$P(UIFMES(UCNT),U,2)
 .;Whether expanded or not, display status of segments not validated.
 .S INERR=2,INMSG="Warning. Segment "_$P(UIFMES(UCNT),U)_" could not be validated" D IO(INMSG)
 ;Display final message
 S INMSG=$S('INERR:"All required fields are present",INERR=2:"Message structure is incorrect",1:"Message contains errors") D IO(INMSG)
 Q
 ;
FNDMSG(OTT,DMESS) ;find message that contains the ttype
 ;INPUT:
 ; OTT = Originating Transaction Type
 ;OUTPUT:
 ; DMESS = (PBR) the ien of the message (Script Generator
 ;         Message File entry) containing OTT.
 ;         DMESS=0 if no message contains OTT.
 N IEN,TT1,INTT
 S (IEN,DMESS)=0 F  S IEN=$O(^INTHL7M(IEN)) Q:'IEN!DMESS  D
 .Q:'$D(^INTHL7M(IEN,2))
 .S TT1=0 F  S TT1=$O(^INTHL7M(IEN,2,TT1)) Q:'TT1!DMESS  D
 ..S INTT=$G(^INTHL7M(IEN,2,TT1,0))
 ..I INTT=OTT S DMESS=IEN Q
 Q
 ;
IO(INMSG,INDRCT) ;print messages
 ;If called as part of Unit Test Utility, DISPLAY^INTSUT1 is used.
 ;;Future development: i
 ;INPUT:
 ;  INMSG=message to print
 ;  INDRCT (OPT) = 1 if called as a stand alone function
 I '$G(INDRCT) D DISPLAY^INTSUT1(INMSG,0) Q
 ;;Future development: Build in writes to IO. A call to %ZIS needed
 ;;at top.
 I $G(INDRCT) W INMSG,! Q
 Q
 ;
TEST(INEXPND,INSTEP) ;Run a test of nn messages in INTHU
 ;INPUT:
 ;  INEXPND=1 for expanded mode, 0 for not
 ;  INSTEP = 1 to pause (step) between messages
 N N,INREQLST,UIF
 W !,"Enter number of messages from INTHU to validate " R N:3600
 Q:'+N
 W !,"This runs a test validation on the last "_N_" messages in INTHU",!
 W "Press any key to start",! R *x:3600
 S U="^"
 K INREQLST
 S UIF="A" F I=1:1:N S UIF=$O(^INTHU(UIF),-1) Q:'UIF  D
 .;S INREQLST(I)=UIF
 .S INMSG="UIF Transaction "_$P(^INTHU(UIF,0),U,5) D IO(INMSG)
 .D MAIN(UIF,INEXPND)
 .I $G(INSTEP) D IO("Press any key to continue") R *X:3600
 Q
 ;
