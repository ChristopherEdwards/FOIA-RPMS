INHOU1 ;DJL,DP; 7 Oct 97 12:50;Interface Message Requeue Utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
REQ ;Requeue an Entry for processing
 ; MODULE NAME: REQ ( Requeue INH message/s )
 ; DESCRIPTION: Prompts the user for a message to requeue. The user may
 ;              enter any valid indexed message component for a single
 ;              message requeue or '/' to search and requeue multiple
 ;              messages. In either case a List will be displayed which
 ;              allows requeueing THREE different ways. 1)use existing
 ;              information, 2)use one set of info. for all message to
 ;              be requeued, or 3) use unique info. for each message.
 ; RETURN = none
 ; PARAMETERS = none
 ; 
 N X,Y,INQUIT,INDA,INREQLST,INPARM2,DIC,INMSG,DIRI,DIRCP,DLAYGO,INABORT,INCLRT,INQUED,INZ,POP,INCURT,INQUEUED,%ZIS
 ; Set up parameter for hot key and List Processor 
 D SETP2^INHOU1
 ;
EN2 ;This is the actual working loop of the routine
 S INQUIT=0 F  D  Q:INQUIT  K X,Y
 . I '$O(^INTHU(0)) W !!,"There are no entries to requeue." S INQUIT=1 Q
 . ; handle initial user input
 . K X D CLEAR^DW W !!
 . D ^UTSRD("Enter a Message to Requeue: ;;;;;","Terminate:^ or <RETURN>, Search Queue:/, or a Valid Message Component")
 .  ; handle the different error/exit conditions
 .  I X="/" S INQUIT=$$TIEN^INHUTC(.INPARM2,"INREQLST") D CLEAR^DW Q
 .  Q:'$D(X)
 .  I X="^"!(X="") S INQUIT=$S(X="":1,1:2) Q
 .  ; let DIC handle all other input checks for single message requeue
 .  S DIC="^INTHU(",DIC(0)="NMEQ"
 .  D ^DIC Q:Y<0
 .  I +Y S INREQLST(1)=+Y,INREQLST(1,0)="" D REQONE^INHOU2(.INREQLST,.INPARM2) S INQUIT=0 Q
 D:$D(INDA) INKINDA^INHMS(INDA)
 Q
 ;
REQ1 ; Requeue an entry for processing
 ; Description: REQ1 performs similar functions as REQ in which it
 ;  allows requeing message in three different ways.
 ;  However, REQ1 does not prompt user for a message to 
 ;  requeue.  Upon enter REQ1, variable Y contains IEN of
 ;  message to requeue.
 ;  
 ; RETURN = none
 ; PARAMETERS = none
 ; 
 N X,INQUIT,INDA,INREQLST,INPARM2,DIC,INMSG,DIRI,DIRCP,DLAYGO,INABORT,INCLRT,INQUED,INZ,POP,INCURT,INQUEUED,%ZIS
 ; Set up parameter for hot key and List Processor 
 D SETP2^INHOU1
 ;
EN3 ;This is the actual requeue operation 
 S INREQLST(1)=+Y,INREQLST(1,0)="" D REQONE^INHOU2(.INREQLST,.INPARM2)
 D:$D(INDA) INKINDA^INHMS(INDA)
 D CLEAR^DW
 Q
 ;
SETP2 ; Set up parameter for hot key and List Processor
 ; construct the structure defining the requeue operations, etc
 S INPARM2("LIST","TITLE")="W ?IOM-$L(""Interface Message Requeue"")/2,""Interface Message Requeue"",!,$$INMSGSTR^INHMS2("""",1,"""")"
 ; Create the list processor help text
 S INPARM2("LIST","HELP")="N INHELP D BLDHELP^INHOU2(.INHELP),SRCHHELP^INHMS3(.INHELP)"
 ; create the HOT KEY structure
 S INPARM2("LIST","HOT",1)="EXISTING^H1"
 S INPARM2("LIST","HOT",1,"ACTION")="D GOHOT1^INHOU5(.DWLMK,DWLRF),REMQUED^INHOU1(.DWLMK,DWLRF)"
 S INPARM2("LIST","HOT",2)="SINGLE^H2"
 S INPARM2("LIST","HOT",2,"ACTION")="D GOHOT2^INHOU5(.DWLMK,DWLRF),REMQUED^INHOU1(.DWLMK,DWLRF)"
 S INPARM2("LIST","HOT",3)="UNIQUE^H3"
 S INPARM2("LIST","HOT",3,"ACTION")="D GOHOT3^INHOU5(.DWLMK,DWLRF),REMQUED^INHOU1(.DWLMK,DWLRF)"
 Q
 ;
REMQUED(INLIST1,INLIST2) ; remove items in list1 from list1,list2
 N INNODE
 S %ZIS="" D CLEAR^DW,^%ZIS Q:POP  U IO I IO=$P W @IOF
 S POP=0
 S INNODE="" F  S INNODE=$O(INLIST1(INNODE)) Q:'INNODE!POP  D
 .;if second piece is null, user enter "^". Take no action
 .Q:'$L($P(INLIST1(INNODE),U,2))
 .I $Y>(IOSL-4) D CONT Q:POP
 .W !,$P(INLIST1(INNODE),U,2)
 .K INLIST1(INNODE),@INLIST2@(INNODE)
 K INLIST1
 D CONT
 D ^%ZISC S IOP="",%ZIS="" D ^%ZIS U IO K IO("Q"),IOP,POP
 Q
 ;
CONT I IO=IO(0),$E(IOST)'="P" W ! S X=$$CR^UTSRD I X S POP=1 Q
 W @IOF
 Q
 ;
FINDQUE(INREQIEN,INMSG) ;determines if entry is already on queue
 ; If entry is already on queue, prompts user if they want
 ; to requeue.
 ; INPUT:
 ; INREQIEN = IEN of entry being requeued
 ; INMSG = (PBR) message that will be displayed back to user at end
 ; RETURN = 0 if INREQUIEN is to be requeued
 ;          1 if user says "no"
 ;          2 if user enters "^"
 ;
 N INDET,INDEST,INMID,INCURP,INQUE,INQUED,OUT
 ; check to see if the message is already queued at the current
 ; priority and time-to-process
 S INDET=^INTHU(INREQIEN,0)
 S INDEST=+$P(INDET,U,2),INMID=$P(INDET,U,5),INCURP=+$P(INDET,U,16),INCURT=$P(INDET,U,19) S:'$L(INCURT) INCURT=+INCURT
 ;If requeue is suppressed, quit
 I $P(INDET,U,20) S INMSG=INMID_": Requeue of message is not allowed" Q 1
 ;Get the primary queue--0=INLHSCH, 1=INLHDEST
 S INQUE=+$P($G(^INRHD(INDEST,0)),U,12),OUT=0,INQUEUED=0
 ; check if already queued. If on INLHSCH, look there first, but
 ; it may have already processed to INLHDEST
 F INQUE=INQUE:1:1 I $L(INQUE),$L($T(@INQUE)) D @INQUE Q:INQUEUED
 I INQUEUED D CLEAR^DW W !,$$INMSGSTR^INHMS2(INREQIEN) D
 .W !!,"Message "_INMID_" is already queued on "_$S(INQUE=0:"^INLHSCH",1:"^INLHDEST")
 .W " for "_$$DATEOUT^%ZTFDT(INCURT,"F"),!,"with a priority of "_INCURP_".",!
 .S X=$$YN^UTSRD("Do you want to delete existing queue entry and requeue? ;N;")
 .S OUT=$S(X["^":2,X=0:1,1:0)
 I OUT S INMSG=INMID_": Message not requeued" Q OUT
 I INQUEUED D
 .;If requeue, kill exiting queue to prevent double entry
 .I 'INQUE K ^INLHSCH(INCURP,INCURT,INREQIEN) Q
 .K ^INLHDEST(INDEST,INCURP,INCURT,INREQIEN)
 S INMSG=INMID_": "_$S(INQUEUED:"Existing queue deleted.",1:""),INMSG=INMSG_" Message requeued"
 Q 0
 ;
DOREQ(INREQIEN,INPRIO,INTTPROC) ; requeue the transaction
 ; MODULE NAME: DOREQ ( Requeue the transaction )
 ; DESCRIPTION: Requeues the transaction INREQIEN with the priority and
 ;              time-to-process passed in INPRIO and INTTPROC
 ; RETURN None
 ; PARAMETERS:
 ;          INREQIEN = The message IEN
 ;          INPRIO = The priority of the message
 ;          INTTPROC = The time to process the message
 ; CODE BEGINS
 D SET^INHD(INTTPROC,$P(^INTHU(INREQIEN,0),U,2),INREQIEN,"",INPRIO)
 ;Change status to "pending", update activity log
 D ULOG^INHU(INREQIEN,"P","Requeued by user "_$P(^DIC(3,DUZ,0),U))
 Q
0 ;
 S INQUEUED=$S($D(^INLHSCH(INCURP,INCURT,INREQIEN)):1,1:0)
 Q
1 ;
 S INQUEUED=$S($D(^INLHDEST(INDEST,INCURP,INCURT,INREQIEN)):1,1:0)
 Q
