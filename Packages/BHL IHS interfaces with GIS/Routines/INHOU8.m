INHOU8 ;DJL,DP; 9 Apr 96 08:28;Interface Message Requeue Utilities 
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
 ; CODE BEGINS
 N X,Y,INQUIT,INDA,INREQLST,INPARM2,DIC
 ; construct the structure defining the requeue operations, etc
 S INPARM2("TITLE")="W ?IOM-$L(""Interface Message Requeue"")/2,""Interface Message Requeue"",!,$$INMSGSTR^INHMS2("""",1,"""")"
 ; Create the list processor help text
 S INPARM2("INHELP")="N INHELP D BLDHELP^INHOU2(.INHELP),SRCHHELP^INHMS3(.INHELP)"
 ; create the HOT KEY structure
 S INPARM2("HOT",1)="EXISTING^H1"
 S INPARM2("HOT",1,"ACTION")="D GOHOT1^INHOU1(.DWLMK,DWLRF),REMQUED^INHOU1(.DWLMK,DWLRF)"
 S INPARM2("HOT",2)="SINGLE^H2"
 S INPARM2("HOT",2,"ACTION")="D GOHOT2^INHOU1(.DWLMK,DWLRF),REMQUED^INHOU1(.DWLMK,DWLRF)"
 S INPARM2("HOT",3)="UNIQUE^H3"
 S INPARM2("HOT",3,"ACTION")="D GOHOT3^INHOU1(.DWLMK,DWLRF),REMQUED^INHOU1(.DWLMK,DWLRF)"
 S INQUIT=0 F  D  Q:INQUIT  K X,Y
 .  I '$O(^INTHU(0)) W !!,"There are no entries to requeue." S INQUIT=1 Q
 .  ; handle initial user input
 .  K X D CLEAR^DW W !! D ^UTSRD("Enter a Message to Requeue: ;;;;;","Terminate:^ or <RETURN>, Search Queue:/, or a Valid Message Component")
 .  ; handle the different error/exit conditions
 .  I X="/" S INQUIT=$$BGNSRCH^INHMS("INREQLST",1,.INDA,.INPARM2) S INQUIT=0 Q
 .  I X="^"!(X="") S INQUIT=1 Q
 .  ; let DIC handle all other input checks for single message requeue
 .  S DIC="^INTHU(",DIC(0)="NMEQ"
 .  D ^DIC Q:Y<0
 .  I +Y S INREQLST(1)=+Y,INREQLST(1,0)="" D REQONE^INHOU2(.INREQLST,.INPARM2) S INQUIT=0 Q
 D:$D(INDA) INKINDA^INHMS(INDA)
 Q
 ;
REMQUED(INLIST1,INLIST2) ; remove items in list1 from list1,list2
 N INNODE
 S INNODE="" F  S INNODE=$O(INLIST1(INNODE)) Q:'INNODE  K INLIST1(INNODE),@INLIST2@(INNODE)
 Q
 ;
GETPT(INHOTOPT,INREQIEN,INPRIO,INTTPROC) ; get prior. and time-to-proc.
 ; MODULE NAME: GETPT ( acquire the priority and time-to-process msg)
 ; DESCRIPTION: Depending on the INHOTOPT parameter, the message prio-
 ;              ity and time-to-process is returned for the message
 ;              in ^INTHU(INREQIEN.
 ; RETURN = PASS/FAIL (0/1)
 ; PARAMETERS:
 ;          INHOTOPTP = Option selector.
 ;          INREQIEN = The IEN of the message of interest.
 ;          INPRIO = (Ref.) The priority is returned here.
 ;          INTTPROC = (Ref.) The Time-to-Process is returned here.
 ; CODE BEGINS
 N X,Y,%DT,INQUIT,INABORT
 S INABORT=0
 S INHOTOPT=$G(INHOTOPT),INREQIEN=$G(INREQIEN),INPRIO=$G(INPRIO),INTTPROC=$G(INTTPROC)
 I INHOTOPT=1 D  Q INABORT
 . ; get the priority and time to process from the original message
 . S INPRIO=+$P(^INTHU(INREQIEN,0),U,16),INTTPROC=$P(^INTHU(INREQIEN,0),U,19)
 . S:'$L(INTTPROC) INTTPROC=$H
 ; for option 3 kill the prio and ttproc and use option 2 to get
 ; new input for each message
 I INHOTOPT=3 K INPRIO,INTTPROC S (INPRIO,INTTPROC)=""
 ; for option 2 prompt for input only if prio and ttproc are not defined
 I INHOTOPT=2!(INHOTOPT=3) D  Q INABORT
 . D CLEAR^DW
 . ; get the priority and time to process from the user on the first
 . ; pass and then use the passed value from then on.
 . I '$G(INPRIO)!('$G(INTTPROC)) D
 ..  S INQUIT=0 F  D  Q:INQUIT  K X,Y
 ...   W:$G(INREQIEN) "Message:",!,$$INMSGSTR^INHMS2(INREQIEN)
 ...   ; handle initial user input for time-to-process
 ...   K X W ! D ^UTSRD("Time to process: ;;;;NOW;","Enter the Time-to-process the message.")
 ...   I X["^"!(X="") S (INQUIT,INABORT)=1 Q
 ...   S X=$$CASECONV^UTIL(X,"U")
 ...   ; handle the different error/exit conditions
 ...   I X="STAT" S INTTPROC="00000,00000",INQUIT=1 Q
 ...   ; let DT handle all other input checks for time to process
 ...   S %DT="ET" D ^%DT S INTTPROC=$$CDATF2H^UTDT(Y) I Y>-1 S INQUIT=1 Q
 ..  Q:INABORT
 ..  S INPRIO=0 W ! D ^UTSRD("PRIORITY: ;;;;0;0,10","Enter the New Priority.") S INPRIO=+X
 ..  I X["^"!(X="") S (INQUIT,INABORT)=1 Q
 . Q:INABORT
 . ; default the Priority and Time to Process if STILL not defined
 . S:'INPRIO INPRIO=0 S:'$L(INTTPROC) INTTPROC=$H
 Q INABORT
 ;
GOHOT1(INSELECT,INLSTNAM) ; Hot Key #1 execution code
 ; MODULE NAME: GOHOT1 ( HotKey #1 execution code )
 ; DESCRIPTION: Requeue using existing priorities and time to process for each message 
 ; RETURN = none
 ; PARAMETERS:
 ;          INSELECT = Array of selected items from List Processor (DWLMK or DWLMK1)
 ;          INLSTNAM = Array of IEN's into ^INTHU to be Queued for processing
 ; CODE BEGINS
 N INNODE,INREQIEN,INPRIO,INTTPROC
 S INNODE="" F  S INNODE=$O(INSELECT(INNODE)) Q:'INNODE  S INREQIEN=$G(@INLSTNAM@(INNODE,0)) Q:$$GETPT^INHOU5(1,INREQIEN,.INPRIO,.INTTPROC)  D DOREQ^INHOU1(INREQIEN,INPRIO,INTTPROC)
 Q
 ;
GOHOT2(INSELECT,INLSTNAM) ; Hot Key #2 execution code
 ; MODULE NAME: GOHOT2 ( HotKey #2 execution code )
 ; DESCRIPTION: Requeue using one priority and time to process for all messages
 ; See GOHOT1^INHOU1 for Parameter information
 ; CODE BEGINS
 N INNODE,INREQIEN,INPRIO,INTTPROC
 Q:$$GETPT(2,"",.INPRIO,.INTTPROC)  S INNODE="" F  S INNODE=$O(INSELECT(INNODE)) Q:'INNODE  S INREQIEN=$G(@INLSTNAM@(INNODE,0)) D DOREQ^INHOU1(INREQIEN,INPRIO,INTTPROC)
 Q
 ;
GOHOT3(INSELECT,INLSTNAM) ; Hot Key #3 execution code
 ; MODULE NAME: GOHOT3 ( HotKey #3 execution code )
 ; DESCRIPTION: Requeue using unique priorities and time to process for each message
 ; See GOHOT1^INHOU1 for Parameter information
 ; CODE BEGINS
 N INNODE,INREQIEN,INPRIO,INTTPROC
 S INNODE="" F  S INNODE=$O(INSELECT(INNODE)) Q:'INNODE  S INREQIEN=$G(@INLSTNAM@(INNODE,0)) Q:$$GETPT^INHOU5(3,INREQIEN,.INPRIO,.INTTPROC)  D DOREQ^INHOU1(INREQIEN,INPRIO,INTTPROC)
 Q
 ;
DOREQ(INREQIEN,INPRIO,INTTPROC) ; requeue the transaction
 ; MODULE NAME: DOREQ ( Requeue the transaction )
 ; DESCRIPTION: Requeues the transaction INREQIEN with the priority and
 ;              time-to-process passed in INPRIO and INTTPROC
 ; RETURN = none
 ; PARAMETERS:
 ;          INREQIEN = The message IEN
 ;          INPRIO = The priority of the message
 ;          INTTPROC = The time to process the message
 ; CODE BEGINS
 N INIEN,INTTP,INQUEUED,INCURP,INCURT,INDEST,INDET,INQUE,INMID
 ; check to see if the message is already queued at the current
 ; priority and time-to-process
 S INDET=^INTHU(INREQIEN,0)
 S INDEST=$P(INDET,U,2),INMID=$P(INDET,U,5),INCURP=+$P(INDET,U,16)
 S INCURT=$P(INDET,U,19)
 S:'$L(INCURT) INCURT=+INCURT
 ;Get the current queue
 S INQUE=$P($G(^INRHD(INDEST,0)),U,12)
 ; check if already queued.
 D @INQUE
 I INQUEUED W !,$$INMSGSTR^INHMS2(INREQIEN)
 I INQUEUED D CLEAR^DW D
 .W !,"Message "_INMID_" is already queued on "_$S(INQUE=0:"^INLHSCH",1:"^INLHDEST")_" for "_$$CDATH2F^UTDT(INCURT)_" with a priority of "_INCURP_"."
 .F  W ! D ^UTSRD("Do you still want to queue this message? ;;;;Y;","Enter Y or N") S X=$$CASECONV^UTIL(X,"U") Q:X="Y"!(X="N")  I X="" S X="N" Q
 Q:INQUEUED&(X="N")
 ;Priority for requeue is set to 0 ?????
 S INPRIO=0
 D SET^INHD(INTTPROC,$P(^INTHU(INREQIEN,0),U,2),INREQIEN,"",INPRIO)
 Q
 ;
0 ;
 S INQUEUED=$S($D(^INLHSCH(INCURP,INCURT,INREQIEN)):1,1:0)
 Q
1 ;
 S INQUEUED=$S($D(^INLHDEST(INDEST,INCURP,INCURT,INREQIEN)):1,1:0)
 Q
