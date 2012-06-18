ABSPOSQ1 ; IHS/FCS/DRS - POS background, Part 1 ; [ 11/04/2002  2:21 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 01, 2001
 ;
 ; This is usually started by Taskman call in TASK^ABSPOSIZ
 ;
 ; For all with status 0, LOOP loops and calls CLAIMINF()
 ;     to fill in any missing information.  Pricing, for example,
 ;     may or may not have already been determined.
 ; Sets status = 10 while it's working on a request.
 ; Sets status = 30 when it's done  - and then it's ready for ABSPOSQ2
 ; If there were problems with the claim, the status will be set = 99.
 ;
 ; Also deals with status = 19 (special for Oklahoma Medicaid)
 ;
 ;    ABSPOSQ - contains many useful $$ calls
 ; Here in ABSPOSQ1:
 ;    The big outer loop through ^ABSPT("AD",0,*)
 ;    and Task manager calls to start up ^ABSPOSQ2
 ; Extensions of ABSPOSQ1:
 ;    ABSPOSQA - ONE59
 ;    ABSPOSQB - CLAIMINF
 ;    ABSPOSQC - some CLAIMINF subroutines
 ;    ABSPOSQD - data for certain a/r interfaces
 ;    ABSPOSQS - special queuing for Oklahoma Medicaid 3 highest prices
 ;
 ;--------------------------------------------------------------
 ;IHS/SD/lwj 11/04/02 on behalf of IHS/OKCAO/POC 
 ; Set ZTREQ to delete the task after it completes in task man
 ;
 ;-------------------------------------------------------------
 Q
LOOP ; line item detail: your work list is ^ABSPT("AD",0)
 N ERROR,PREVPAT,THISPAT,COUNT,PACKETER S PACKETER=0
 N IEN59,ABSBRXI,ABSBRXR,ABSBNDC,MODULO
 N ABSBPATI,ABSBPDIV,ABSBSDIV,ABSBVISI,ABSPHARM,INSURER
 N VMEDDFN,APCDVCN
 ;
 ;IHS/SD/lwj 11/04/02 on behalf of IHS/OKCAO/POC 11/04/02
 I $D(ZTQUEUED) S ZTREQ="@"  ;delete task if complete
 ;
 ;IHS/SD/lwj 11/04/02 end change
 ;
 S MODULO=4 ; interval at which we start up a packeter program
 S COUNT=0
 F  S IEN59=$$NEXT59 Q:'IEN59  D
 . D INIT^ABSPOSL(IEN59,1) ; logging (don't delete old data)
 . D ONE59^ABSPOSQA ; process this claim
 . D RELSLOT^ABSPOSL ; release logging slot
 ; Deal with the status 19s (special for Oklahoma Medicaid bundling)
 I $D(^ABSPT("AD",19)) D
 . I $$STAT19^ABSPOSQS D  ; if any 19s pushed to status 30, then
 . . S COUNT=.1 ; force packeter to start
 I COUNT#MODULO'=0 D PACKETER
 Q
NEXT59() ; Get the next entry with Status = 0
 ; If there is one, change its status to 10
 ;    (says "Gathering claim information")
 ; (Being very careful to LOCK access while you're getting the entry
 ;  and changing its status.)
 ; Timed lock and resulting complications is a hassle but not a mess.
 L +^ABSPT:300
 I '$T D  Q 0 ; lock failed?!
 . D TASK^ABSPOSIZ ; try again - requeue this job
 S IEN59=$O(^ABSPT("AD",0,0))
 I IEN59 D SETSTAT(10)
 L -^ABSPT
 Q IEN59
SETSTAT(NEWSTAT)   ;EP - from ABSPOSQA
 N ABSBRXI S ABSBRXI=IEN59 ; unfortunate variable name convention
 D SETSTAT^ABSPOSU(NEWSTAT)
 Q
PACKETER ;EP - from ABSPOSAN,ABSPOSQA 
 ; tell the packetizer it's time to get working
 ; But only if there are claims in status 30
 I $O(^ABSPT("AD",30,0)) D TASK
 Q
TASK ;EP - from ABSPOS2D,ABSPOS6D,ABSPOS6L,ABSPOSQ2,ABSPOSQ4
 N X,%DT,Y S X="N",%DT="ST" D ^%DT
 D TASKAT(Y)
 I $D(PACKETER) S PACKETER=PACKETER+1 ; note: "we started the packeter"
 Q
TASKAT(ZTDTH)      ;EP - from ABSPOSQ4 (requeue if insurer is sleeping)
 ; called here from ABSPOSQS - 
 ;N (DUZ,PACKETER,ZTDTH) N ZTRTN
 N ZTRTN,ZTIO
 S ZTRTN="PACKETS^ABSPOSQ2",ZTIO=""
 D ^%ZTLOAD
 Q
