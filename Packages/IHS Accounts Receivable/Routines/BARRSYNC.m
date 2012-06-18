BARRSYNC ; IHS/SD/LSL - AUTO SYNC MANAGEMENT REPORT ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,3**;MAR 27,2007
 ;
 ; IHS/SD/LSL - 05/29/02 - V1.6 Patch 2
 ;     Routine created
 ;
 ; IHS/SD/LSL - 01/13/03 - V1.7
 ;     Modified to accomodate new global structure for multiple runs
 ;     of the Auto Sync (BARSYNC).
 ;
 ; *********************************************************************
 ;
 ;     This routine will traverse the ^BARSYNC global created in BARSYNC
 ;     that was run when A/R V1.6 Patch 2 was installed.  A report will
 ;     be generated that displays those bills that had an AUTO IN SYNC
 ;     transaction created.  The BARSYNC global looks like:
 ;
 ;     ^BARSYNC(BARSTART,DUZ(2),BARVISOU,BARAC,BARDOS,BARBILL)=BARBAMT^BARTAMT
 ;     
 ;     Where:   BARSTART = Date AUTO SYNC was run
 ;              DUZ(2)   = Billing location
 ;              BARVIS   = Visit type on A/R Bill
 ;              BARAC    = A/R Account on A/R Bill
 ;              BARDOS   = DOS Begin on A/R Bill
 ;              BARBILL  = A/R Bill
 ;              BARBAMT  = Current Bill Amount from A/R Bill File
 ;              BARTAMT  = Transaction History Balance
 ;
 ; *********************************************************************
 Q
 ; *********************************************************************
 ;
EN ; EP
 K BARY,BAR
 I '$D(^BARSYNC) D NODATA Q          ; Auto Sync did not run
 D:'$D(BARUSR) INIT^BARUTL           ; Set up basic A/R variables
 S BARP("RTN")="BARRSYNC"            ; Routine used to gather data
 S BAR("PRIVACY")=1                  ; Privacy act applies (used BARRHD)
 S BAR("LOC")=$$GET1^DIQ(90052.06,DUZ(2),16)   ; BILLING or VISIT
 I BAR("LOC")="" S BAR("LOC")="VISIT"
 D MSG^BARRSEL                       ; Message about BILLING/VISIT loc
 D LOC^BARRSL1                       ; Ask location - BARY("LOC")
 Q:$D(DTOUT)!($D(DUOUT))
 W:'$D(BARY("LOC")) "ALL"
 D SETHDR                            ; Build header array 
 S BARQ("RC")="COMPUTE^BARRSYNC"     ; Gather data
 S BARQ("RP")="PRINT^BARRSYNC"       ; Print report
 S BARQ("NS")="BAR"                  ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"         ; Clean-up routine
 D ^BARDBQUE                         ; Double queuing
 D PAZ^BARRUTL                       ; Press return to continue
 Q
 ; *********************************************************************
 ;
NODATA ;   
 ; Write message because Auto Sync did not run
 W !!?5,$$EN^BARVDF("RVN"),"WARNING:",$$EN^BARVDF("RVF")
 W ?18,"Auto Sync has not been executed.  This report contains no data."
 W !?18,"Contact your site manager for further assistance."
 D PAZ^BARRUTL
 Q
 ; *********************************************************************
 ;
SETHDR ;
 ; Build header array
 S BAR("LVL")=0
 S BAR("HD",0)="Auto Sync Management Report"
 S BAR("TXT")="ALL"
 I $D(BARY("LOC")) S BAR("TXT")=$P(^DIC(4,BARY("LOC"),0),U)
 I BAR("LOC")="BILLING" D
 . S BAR("TXT")=BAR("TXT")_" Visit location(s) under "
 . S BAR("TXT")=BAR("TXT")_$P(^DIC(4,DUZ(2),0),U)
 . S BAR("TXT")=BAR("TXT")_" Billing Location"
 E  S BAR("TXT")=BAR("TXT")_" Visit location(s) regardless of Billing Location"
 S BAR("CONJ")="at "
 D CHK^BARRHD
 Q
 ; *********************************************************************
 ;
COMPUTE ;
 N BARSTART
 Q:BAR("LOC")="BILLING"
 S BARSTART=0
 F  S BARSTART=$O(^BARSYNC(BARSTART)) Q:'+BARSTART  D
 . S BARBLOC=0
 . F  S BARBLOC=$O(^BARSYNC(BARSTART,BARBLOC)) Q:'+BARBLOC  D
 . . S BARVLOC=""
 . . F  S BARVLOC=$O(^BARSYNC(BARSTART,BARBLOC,BARVLOC)) Q:BARVLOC=""  D
 . . . I $D(BARY("LOC")),BARY("LOC","NM")'=BARVLOC Q
 . . . S BAR("VISIT",BARVLOC)=""
 Q
 ; *********************************************************************
 ;
PRINT ;   
 ; Print report
 K BARRCNT,BARR1,BARR2,BARR3
 S BAR("PG")=0
 S BARDASH="W !?43,""----------   ----------   ----------"""
 S BAREQUAL="W !?43,""==========   ==========   =========="""
 D HDB                             ; Print page and column headers
 I '+$O(^BARSYNC(0)) D  Q
 . W !!!,"*** NO DATA TO PRINT ***"
 . D EOP^BARUTL(0)
 I BAR("LOC")="BILLING" D BILL
 E  D VISIT
 Q:$G(BAR("F1"))
 I '$D(BARRCNT) D  Q
 . W !!!,"*** NO DATA TO PRINT ***"
 E  D
 . X BAREQUAL
 . W !,"*** REPORT TOTAL          (Bill cnt:"
 . W ?37,$J(BARRCNT,4),")"
 . W ?43,$J($FN(BARR1,",",2),10)
 . W ?56,$J($FN(BARR2,",",2),10)
 . W ?69,$J($FN(BARR3,",",2),10)
 Q
 ; *********************************************************************
 ;
HD ; EP
 D PAZ^BARRUTL
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BAR("F1")=1 Q
 ;
HDB ; EP
 ; Page and column header
 S BAR("PG")=BAR("PG")+1
 S BAR("I")=""
 D WHD^BARRHD                       ; Page header
 W !?48,"BILL",?56,"TRANSACTION"
 W !,"A/R BILL",?15,"DOS",?27,"A/R ACCOUNT",?46,"BALANCE",?56,"HISTORY BAL",?69,"DIFFERENCE"
 S $P(BAR("DASH"),"=",$S($D(BAR(132)):132,1:80))=""
 W !,BAR("DASH"),!
 Q
 ; *********************************************************************
 ;
BILL ;
 ; Report of selected visit types for DUZ(2) logged into.
 I $D(BARY("LOC")) D  Q
 . ;BEGIN NEW CODE IM23858
 . S BARSTART=0
 . F  S BARSTART=$O(^BARSYNC(BARSTART)) Q:'+BARSTART!($G(BAR("F1")))  D
 . .S Y=BARSTART
 . .D DD^%DT
 . .W !!,$$CJ^XLFSTR("(As of Auto Sync run on "_Y_")",IOM)
 . .S BARVIS=BARY("LOC","NM")
 . .S (BARV1,BARV2,BARV3,BARVCNT)=0
 . .D BILL2
 . .;END NEW CODE
 . ;S BARVIS=BARY("LOC","NM")
 . ;K BARV1,BARV2,BARV3,BARVCNT
 . ;D BILL2
 E  D
 . S BARSTART=0
 . F  S BARSTART=$O(^BARSYNC(BARSTART)) Q:'+BARSTART!($G(BAR("F1")))  D
 . . S Y=BARSTART
 . . D DD^%DT
 . . W !!,$$CJ^XLFSTR("(As of Auto Sync run on "_Y_")",IOM)
 . . S BARVIS=""
 . . F  S BARVIS=$O(^BARSYNC(BARSTART,DUZ(2),BARVIS)) Q:BARVIS=""!($G(BAR("F1")))  D
 . . . K BARV1,BARV2,BARV3,BARVCNT
 . . . D BILL2
 Q
 ; *********************************************************************
 ;
BILL2 ;
 W !!?5,"Visit Location: ",BARVIS,!
 S BARAC=""
 F  S BARAC=$O(^BARSYNC(BARSTART,DUZ(2),BARVIS,BARAC)) Q:BARAC=""!$G(BAR("F1"))  D
 . S BARDOS=0
 . F  S BARDOS=$O(^BARSYNC(BARSTART,DUZ(2),BARVIS,BARAC,BARDOS)) Q:'+BARDOS!$G(BAR("F1"))  D
 . . S BARBILL=0
 . . F  S BARBILL=$O(^BARSYNC(BARSTART,DUZ(2),BARVIS,BARAC,BARDOS,BARBILL)) Q:'+BARBILL!$G(BAR("F1"))  D
 . . . S BARBAMT=$P(^BARSYNC(BARSTART,DUZ(2),BARVIS,BARAC,BARDOS,BARBILL),U)
 . . . S BARTAMT=$P(^BARSYNC(BARSTART,DUZ(2),BARVIS,BARAC,BARDOS,BARBILL),U,2)
 . . . S BARDIFF=BARBAMT-BARTAMT
 . . . I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 . . . W !,$E($$GET1^DIQ(90050.01,BARBILL,.01),1,12)
 . . . I BARDOS=99 W ?14,"NO DOS"
 . . . E  W ?14,$$SDT^BARDUTL(BARDOS)
 . . . W ?26,$E(BARAC,1,15)
 . . . W ?43,$J($FN(BARBAMT,",",2),10)
 . . . W ?56,$J($FN(BARTAMT,",",2),10)
 . . . W ?69,$J($FN(BARDIFF,",",2),10)
 . . . ;
 . . . S BARVCNT=$G(BARVCNT)+1
 . . . S BARRCNT=$G(BARRCNT)+1
 . . . S BARV1=$G(BARV1)+BARBAMT
 . . . S BARV2=$G(BARV2)+BARTAMT
 . . . S BARV3=$G(BARV3)+BARDIFF
 . . . S BARR1=$G(BARR1)+BARBAMT
 . . . S BARR2=$G(BARR2)+BARTAMT
 . . . S BARR3=$G(BARR3)+BARDIFF
 Q:$G(BAR("F1"))
 X BARDASH
 W !," ** Visit Location Total  (Bill cnt:"
 ;W ?37,$J(BARVCNT,4),")"
 ;W ?43,$J($FN(BARV1,",",2),10)
 ;W ?56,$J($FN(BARV2,",",2),10)
 ;W ?69,$J($FN(BARV3,",",2),10)
 ;IHS/SD/TPF BAR*1.8*3 IM25783
 W ?37,$J($G(BARVCNT),4),")"
 W ?43,$J($FN($G(BARV1),",",2),10)
 W ?56,$J($FN($G(BARV2),",",2),10)
 W ?69,$J($FN($G(BARV3),",",2),10)
 ;END BAR*1.8*3 IM25783
 Q
 ; *********************************************************************
 ;
VISIT ;
 Q:'$D(BAR("VISIT"))
 S BARSTART=0
 F  S BARSTART=$O(^BARSYNC(BARSTART)) Q:'+BARSTART!($G(BAR("F1")))  D
 . S Y=BARSTART
 . D DD^%DT
 . W !!,$$CJ^XLFSTR("(As of Auto Sync run on "_Y_")",IOM)
 . S BARVIS=""
 . F  S BARVIS=$O(BAR("VISIT",BARVIS)) Q:BARVIS=""!($G(BAR("F1")))  D VISIT2
 Q
 ; *********************************************************************
 ;
VISIT2 ;
 K BARVCNT,BARV1,BARV2,BARV3
 S BARHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARSYNC(BARSTART,DUZ(2))) Q:'+DUZ(2)!($G(BAR("F1")))  D
 . Q:'$D(^BARSYNC(BARSTART,DUZ(2),BARVIS))
 . D BILL2
 S DUZ(2)=BARHOLD
 Q
