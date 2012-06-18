BARBLOS ; IHS/SD/LSL - REPORT ALL OUTSTANDING BILLS AS OF DATE REQUESTED - JAN 14,1996 ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ;;
 ; IHS/SD/LSL - 12/12/02 - V1.6 Patch 4 - NHA-0601-180049
 ;       Tribal sites still use this report.  Removed 3pb search as
 ;       it's not needed and the code does it wrong.
 ;
 ; IHS/SD/LSL - 09/04/03 - V1.7 Patch 4 - IM11410
 ;       Resolved <UNDEF>TRANCAL+5^BARBLOS
 ; MODIFIED TO CHANGE XTMP($J,"BARBLOS" TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; *********************************************************************
 ;
 D ASK^BARBLOS0
 S BARDATE=$$DIR^XBDIR("D","Enter the ending date","SEP 30, 1997",,"Enter the ending date of the fiscal year to be reported","^D HELP^XBHELP(""HELP"",""BARBLOS"")")
 Q:'Y
 W "  ("_$$MDT2^BARDUTL(BARDATE)_")"
 ;
HELP ;
 ;;In Jan, 1997, auditors from the Inspector General (OIG) requested
 ;;a one-time report from all RPMS A/R implementations.
 ;;Specifically, the information needed by the IG is the amount of
 ;;monies that were outstanding of the end of a fiscal year (ie.
 ;;September 30, 1996).
 ;;
 ;;The results should be faxed to: 
 ;;Carl Fitzpatrick OAM,HQW at 301-443-9157
 ;; 
 ;;Also fax a copy to your Area Office
 ;;###
 ;
 S XBRC="EN^BARBLOS"
 S XBRP="PRINT^BARBLOS"
 S XBNS="BAR"
 S XBRX="EXIT^BARBLOS"
 W *7,!!,">> This report takes a while and will be automatically queued! <<",!
 D ^XBDBQUE
 Q
 ; *********************************************************************
 ;
EN ;EP 
 K ^XTMP("BARBLOS",$J)
 D INIT^BARUTL
 S BARX="39^40^43^49^108"
 S (BARBLDA,BARBLDT,BARDACT,BAR3PNF)=0
 F  S BARBLDT=$O(^BARBL(DUZ(2),"AG",BARBLDT)) Q:BARBLDT'>0  Q:$E(BARBLDT,1,7)>BARDATE  D
 . S BARBLDA=0
 . F  S BARBLDA=$O(^BARBL(DUZ(2),"AG",BARBLDT,BARBLDA)) Q:BARBLDA'>0  D
 .. S BARDACT=BARDACT+1 I $E(IOST)="C",IOT["TRM" W "."
 .. D SRCHTPB
 . Q
 S (%DT,X1)=DT
 S X="N"
 S X2=7
 D ^%DT
 S Y=X
 S:$D(^XTMP("BARBLOS",$J)) ^XTMP("BARBLOS",$J,0)=Y_"^"_DT_"^"_"IG REPORTING DATA"
 K X,Y
 D HOME^%ZIS
 ;
ENEXIT ;
 Q
 ; *********************************************************************
 ;
SRCHTPB ;
 D SRCHTRNS
 ;
SRCHTPBE ;
 Q
 ; *********************************************************************
 ;
SRCHTRNS ;
 ; Search the ^BARTR global for type of transaction records for this A/R bill
 S (BARDTTM,BARCR,BARDB,BARQUIT,BARACCT,BARCNT,BARXOVR)=0
 F  S BARDTTM=$O(^BARTR(DUZ(2),"AC",BARBLDA,BARDTTM)) Q:BARDTTM'>0  Q:BARQUIT  D
 . Q:$P($G(^BARTR(DUZ(2),BARDTTM,0)),U)=""
 . S BARCNT=BARCNT+1
 . I '$D(^BARTR(DUZ(2),BARDTTM,1)) Q
 . D TRANCAL
 I BARCNT=0 Q
 I '$D(BAR(49,0,0,"DB")) D
 . S BAR(49,0,0,"DB")=$$GET1^DIQ(90050.01,BARBLDA,13,"I")
 . S:BARACCT=0 BARACCT=$$GET1^DIQ(90050.01,BARBLDA,3,"I")
 . S ^XTMP("BARBLOS",$J,"NO49REC",BARBLDA)=""
 D CALIT
 I BARDB-BARCR<.01 S BARQUIT=1
 I '$D(^XTMP("BARBLOS",$J,BARACCT,"COLLECTED")) S ^XTMP("BARBLOS",$J,BARACCT,"COLLECTED")=0
 S ^XTMP("BARBLOS",$J,BARACCT,"COLLECTED")=^XTMP("BARBLOS",$J,BARACCT,"COLLECTED")+BARCR
 I BARGRP>0 D
 . I '$D(^XTMP("BARBLOS",$J,BARACCT,"GROUPER")) S ^XTMP("BARBLOS",$J,BARACCT,"GROUPER")=0
 . S ^XTMP("BARBLOS",$J,BARACCT,"GROUPER")=^XTMP("BARBLOS",$J,BARACCT,"GROUPER")+BARGRP
 Q
 ; *********************************************************************
 ;
PRINT ;
 ; roll through the ^XTMP("BARBLOS",$J) and report on these records
 S BARDATE=BARDATE
 D PRINT^BARBLOS1
 D TRAN^BARBLOS0
 K ^XTMP("BARBLOS",$J)
 Q
 ; *********************************************************************
 ;
TRANCAL ;
 ; Determine what type of transaction it is
 K BARTEMP
 I BARX'[$P(^BARTR(DUZ(2),BARDTTM,1),"^") Q
 I BARACCT>0 D
 . I BARACCT'=$P(^BARTR(DUZ(2),BARDTTM,0),"^",6) D
 .. S BARTEMP=$P(^BARTR(DUZ(2),BARDTTM,0),"^",6)
 .. S:'$D(^XTMP("BARBLOS",$J,BARACCT,BARTEMP)) ^XTMP("BARBLOS",$J,BARACCT,BARTEMP)=0
 .. S ^XTMP("BARBLOS",$J,BARACCT,BARTEMP)=^XTMP("BARBLOS",$J,BARACCT,BARTEMP)+1
 .. S BARXOVR=BARXOVR+1
 .. D XOVER
 I $P(^BARTR(DUZ(2),BARDTTM,1),"^")=49 D
 . S BARACCT=$P(^BARTR(DUZ(2),BARDTTM,0),"^",6)
 . I '$D(^XTMP("BARBLOS",$J,BARACCT,"BILLED")) S ^XTMP("BARBLOS",$J,BARACCT,"BILLED")=0
 . S ^XTMP("BARBLOS",$J,BARACCT,"BILLED")=^XTMP("BARBLOS",$J,BARACCT,"BILLED")+$P(^BARTR(DUZ(2),BARDTTM,0),"^",3)
 S BARTTYP=$P(^BARTR(DUZ(2),BARDTTM,1),"^")
 S BARTCAT=$P(^BARTR(DUZ(2),BARDTTM,1),"^",2)
 S BARTREA=$P(^BARTR(DUZ(2),BARDTTM,1),"^",3)
 S:BARTCAT="" BARTCAT=0
 S:BARTREA="" BARTREA=0
 I $P(^BARTR(DUZ(2),BARDTTM,0),"^",3)'="" D
 . S:'$D(BAR(BARTTYP,BARTCAT,BARTREA,"DB")) BAR(BARTTYP,BARTCAT,BARTREA,"DB")=0
 . S BAR(BARTTYP,BARTCAT,BARTREA,"DB")=BAR(BARTTYP,BARTCAT,BARTREA,"DB")+$P(^BARTR(DUZ(2),BARDTTM,0),"^",3)
 I $P(^BARTR(DUZ(2),BARDTTM,0),"^",2)'="" D
 . S:'$D(BAR(BARTTYP,BARTCAT,BARTREA,"CR")) BAR(BARTTYP,BARTCAT,BARTREA,"CR")=0
 . S BAR(BARTTYP,BARTCAT,BARTREA,"CR")=BAR(BARTTYP,BARTCAT,BARTREA,"CR")+$P(^BARTR(DUZ(2),BARDTTM,0),"^",2)
 Q
 ; *********************************************************************
 ;
CALIT ;Calculate the Debits and Credits
 S (BARDB,BARCR,BARGRP)=0
 S BARTTYP=38
 F  S BARTTYP=$O(BAR(BARTTYP)) Q:BARTTYP=""  D
 . S BARTCAT=""
 . F  S BARTCAT=$O(BAR(BARTTYP,BARTCAT)) Q:BARTCAT=""  D
 .. S BARTREA=""
 .. F  S BARTREA=$O(BAR(BARTTYP,BARTCAT,BARTREA)) Q:BARTREA=""  D
 ... I BARTTYP=49 D
 .... S:$D(BAR(BARTTYP,BARTCAT,BARTREA,"DB")) BARDB=BARDB+BAR(BARTTYP,BARTCAT,BARTREA,"DB")
 .... S:$D(BAR(BARTTYP,BARTCAT,BARTREA,"CR")) BARDB=BARDB-BAR(BARTTYP,BARTCAT,BARTREA,"CR")
 ... I BARTTYP'=49 D
 .... S:$D(BAR(BARTTYP,BARTCAT,BARTREA,"DB")) BARCR=BARCR-BAR(BARTTYP,BARTCAT,BARTREA,"DB")
 .... S:$D(BAR(BARTTYP,BARTCAT,BARTREA,"CR")) BARCR=BARCR+BAR(BARTTYP,BARTCAT,BARTREA,"CR")
 ... I BARTCAT=16 D
 .... S:$D(BAR(BARTTYP,BARTCAT,BARTREA,"DB")) BARGRP=BARGRP+BAR(BARTTYP,BARTCAT,BARTREA,"DB")
 .... S:$D(BAR(BARTTYP,BARTCAT,BARTREA,"CR")) BARGRP=BARGRP-BAR(BARTTYP,BARTCAT,BARTREA,"CR")
 ... K BAR(BARTTYP,BARTCAT,BARTREA)
 Q
 ; *********************************************************************
 ;
XOVER ;
 ; Accumulate cross over dollars, ie-dollars billed to one insurer and paid by another insurer
 I BARXOVR=1 D
 . S:'$D(^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"BILL")) ^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"BILL")=0
 . S ^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"BILL")=^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"BILL")+BAR(49,0,0,"DB")
 I $P(^BARTR(DUZ(2),BARDTTM,0),"^",3)'="" D
 . S:'$D(^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"DB")) ^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"DB")=0
 . S ^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"DB")=^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"DB")+$P(^BARTR(DUZ(2),BARDTTM,0),"^",3)
 I $P(^BARTR(DUZ(2),BARDTTM,0),"^",2)'="" D
 . S:'$D(^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"CR")) ^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"CR")=0
 . S ^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"CR")=^XTMP("BARBLOS",$J,BARACCT,BARTEMP,"CR")+$P(^BARTR(DUZ(2),BARDTTM,0),"^",2)
 Q
 ; *********************************************************************
 ;
EXIT ; Exit routine
 Q
