INHOU5 ;DP; 7 May 96 11:41;Interface Message Requeue Utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
GOHOT1(INSELECT,INLSTNAM) ; Hot Key #1 execution code
 ; MODULE NAME: GOHOT1 ( HotKey #1 execution code )
 ; DESCRIPTION: Requeue using existing priorities and time to process
 ;              for each message
 ; RETURN = none
 ; PARAMETERS:
 ;          INSELECT = Array of selected items from List Processor
 ;                     (DWLMK or DWLMK1)
 ;          INLSTNAM = Array of IEN's into ^INTHU to be Queued for
 ;                     processing
 N INNODE,INREQIEN,INPRIO,INTTPROC
 S INNODE="",INABORT=0
 F  S INNODE=$O(INSELECT(INNODE)) Q:'INNODE!(INABORT>1)  D
 .S INREQIEN=$G(@INLSTNAM@(INNODE,0)) Q:'INREQIEN
 .S INABORT=$$FINDQUE^INHOU1(INREQIEN,.INMSG) Q:INABORT>1
 .S $P(INSELECT(INNODE),U,2)=INMSG Q:INABORT
 .S INABORT=$$GETPT^INHOU5(1,INREQIEN,.INPRIO,.INTTPROC) Q:INABORT
 .D DOREQ^INHOU1(INREQIEN,INPRIO,INTTPROC)
 Q
 ;
GOHOT2(INSELECT,INLSTNAM) ; Hot Key #2 execution code
 ; MODULE NAME: GOHOT2 ( HotKey #2 execution code )
 ; DESCRIPTION: Requeue using one priority and time to process for all
 ;              messages
 ; See GOHOT1^INHOU5 for Parameter information
 N INNODE,INREQIEN,INPRIO,INTTPROC
 ;Prompt for priority and time to process first, then loop through
 ;all selected transactions
 Q:$$GETPT(2,"",.INPRIO,.INTTPROC)  S INNODE="",INABORT=0
 F  S INNODE=$O(INSELECT(INNODE)) Q:'INNODE!(INABORT>1)  D
 .S INREQIEN=$G(@INLSTNAM@(INNODE,0)) Q:'INREQIEN
 .S INABORT=$$FINDQUE^INHOU1(INREQIEN,.INMSG) Q:INABORT>1
 .S $P(INSELECT(INNODE),U,2)=INMSG Q:INABORT
 .D DOREQ^INHOU1(INREQIEN,INPRIO,INTTPROC)
 Q
 ;
GOHOT3(INSELECT,INLSTNAM) ; Hot Key #3 execution code
 ; MODULE NAME: GOHOT3 ( HotKey #3 execution code )
 ; DESCRIPTION: Requeue using unique priorities and time to process for each message
 ; See GOHOT1^INHOU5 for Parameter information
 ; CODE BEGINS
 N INNODE,INREQIEN,INPRIO,INTTPROC
 S INNODE="",INABORT=0
 F  S INNODE=$O(INSELECT(INNODE)) Q:'INNODE!(INABORT>1)  D
 .S INREQIEN=$G(@INLSTNAM@(INNODE,0)) Q:'INREQIEN
 .S INABORT=$$FINDQUE^INHOU1(INREQIEN,.INMSG) I INABORT D  Q
 ..;following sets second piece if msg is to not requeue,
 ..;but leaves it blank if user had entered "^" 
 ..S:INABORT=1 $P(INSELECT(INNODE),U,2)=INMSG
 .S INABORT=$$GETPT^INHOU5(1,INREQIEN,.INPRIO,.INTTPROC) Q:INABORT
 .S $P(INSELECT(INNODE),U,2)=INMSG
 .D DOREQ^INHOU1(INREQIEN,INPRIO,INTTPROC)
 Q
GETPT(INHOTOPT,INREQIEN,INPRIO,INTTPROC) ; Prompt for new prior. and time-to-proc.
 ; MODULE NAME: GETPT ( acquire the priority and time-to-process msg)
 ; DESCRIPTION: Depending on the INHOTOPT parameter, the message prio-
 ;              ity and time-to-process is returned for the message
 ;              in ^INTHU(INREQIEN.
 ; RETURN = PASS/FAIL (0/2)
 ; PARAMETERS:
 ;          INHOTOPTP = Option selector.
 ;          INREQIEN = The IEN of the message of interest.
 ;          INPRIO = (Ref.) The priority is returned here.
 ;          INTTPROC = (Ref.) The Time-to-Process is returned here.
 N INQUIT,INABORT
 S INABORT=0
 I INHOTOPT=1 D  Q 0
 . ; get the priority and time to process from the original message
 .S INPRIO=+$P(^INTHU(INREQIEN,0),U,16)
 .S INTTPROC=$P(^INTHU(INREQIEN,0),U,19)
 . S:'$L(INTTPROC) INTTPROC=$H
 ; for option 3 kill the prio and ttproc and use option 2 to get
 I INHOTOPT=3 K INPRIO,INTTPROC S (INPRIO,INTTPROC)=""
 ; for option 2 prompt for input only if prio and ttproc are not defined
 I INHOTOPT=2!(INHOTOPT=3) D
 . D CLEAR^DW
 . ; get the priority and time to process from the user on the first
 . ; pass and then use the passed value from then on.
 . I '$G(INPRIO)!('$G(INTTPROC)) D
 ..  S INQUIT=0 F  D  Q:INQUIT  K X,Y
 ...   W:$G(INREQIEN) "Message:",!,$$INMSGSTR^INHMS2(INREQIEN)
 ...   ; handle initial user input for time-to-process
 ...   K X W ! D ^UTSRD("Time to process: ;;;;NOW;","Enter the Time-to-process the message.")
 ...   I X["^"!(X="") S (INQUIT,INABORT)=2 Q
 ...   S X=$$CASECONV^UTIL(X,"U")
 ...   ; handle the different error/exit conditions
 ...   I X="STAT" S INTTPROC="00000,00000",INQUIT=1 Q
 ...   ; let DT handle all other input checks for time to process
 ...   S %DT="ET" D ^%DT S INTTPROC=$$CDATF2H^UTDT(Y) I Y>-1 S INQUIT=1
 ..  Q:INABORT
 ..  S INPRIO=0 W ! D ^UTSRD("PRIORITY: ;;;;0;0,10","Enter the New Priority.") S INPRIO=+X
 ..  I X["^"!(X="") S (INQUIT,INABORT)=2
 . Q:INABORT
 . ; default the Priority and Time to Process if STILL not defined
 . S:'INPRIO INPRIO=0 S:'$L(INTTPROC) INTTPROC=$H
 Q INABORT
