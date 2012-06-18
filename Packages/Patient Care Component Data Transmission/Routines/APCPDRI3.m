APCPDRI3 ; IHS/TUCSON/LAB - initialization part III AUGUST 14, 1992 ; [ 04/07/99 7:47 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**1**;APR 03, 1998
INFORM ;EP - INFORM OPERATOR WHAT IS GOING TO HAPPEN
 Q:$D(ZTQUEUED)
 W !!,"This routine will generate the following transaction types:"
 ;W:$D(APCPS("APC")) !?15,"APC - AMBULATORY SYSTEM " ;IHS/CMI/LAB - per hdqrts west NO  APC records
 ;W:$D(APCPS("INPT")) !?15,"INPATIENT - DIRECT INPATIENT" ;IHS/CMI/LAB - per hdqtrs west NO inpatient txs
 ;W:$D(APCPS("CHA")) !?15,"CHA - COMMUNITY HEALTH ACTIVITY" ;per hdqtrs west, NO CHA transactions
 W !?15,"STATISTICAL DATABASE RECORDS" ;IHS/CMI/LAB - stat recs only per hdqtrs west
 W !,"for visits posted between a specified range of dates.  You may ""^"" out at any",!,"prompt and will be ask to confirm your entries prior to generating transactions."
 Q
 ;
CURRUN ;EP - COMPUTE DATES FOR CURRENT RUN
 S APCP("RUN BEGIN")=""
 I APCP("LAST LOG") S X1=$P(^APCPLOG(APCP("LAST LOG"),0),U,2),X2=1 D C^%DTC S APCP("RUN BEGIN")=X,Y=X D DD^%DT
 I APCP("RUN BEGIN")="" D FIRSTRUN
 Q:APCP("QFLG")
 S X1=DT,X2=$P(^APCPSITE(1,0),U,3)*-1 D C^%DTC S Y=X
 I Y<APCP("RUN BEGIN") W:'$D(ZTQUEUED) !!,"  Ending date cannot be before beginning date!",$C(7) S APCP("QFLG")=18 Q
 S APCP("RUN END")=Y
 S Y=APCP("RUN BEGIN") X ^DD("DD") S APCP("X")=Y
 S Y=APCP("RUN END") X ^DD("DD") S APCP("Y")=Y
 W:'$D(ZTQUEUED) !!,"The inclusive dates for this run are ",APCP("X")," through ",APCP("Y"),"."
 K %,%H,%I,APCP("RDFN"),APCP("X"),APCP("Y"),APCP("LAST LOG"),APCP("LAST BEGIN"),APCP("Z"),APCP("DATE")
 Q
 ;
FIRSTRUN ; FIRST RUN EVER (NO LOG ENTRY)
 I $D(ZTQUEUED),$D(APCPO("SCHEDULED")) S APCP("QFLG")=12 Q
 W !!,"No log entry.  First run ever assumed.",!
FRLP  ;
 S DIR(0)="D^:"_DT_":EP",DIR("A")="Enter Beginning Date for this run" K DA D ^DIR K DIR
 I $D(DIRUT)!(Y="") S APCP("QFLG")=99 Q
 S APCP("RUN BEGIN")=Y
 S APCP("FIRST RUN")=1
 Q
 ;
 ;
ERRBULL ;ENTRY POINT - ERROR BULLETIN
 S APCP("QFLG1")=$O(^APCPERRC("B",APCP("QFLG"),"")),APCP("QFLG DES")=$P(^APCPERRC(APCP("QFLG1"),0),U,2)
 S XMB(2)=APCP("QFLG"),XMB(3)=APCP("QFLG DES")
 S XMB(4)=$S($D(APCP("RUN LOG")):APCP("RUN LOG"),1:"< NONE >")
 I '$D(APCP("RUN BEGIN")) S XMB(5)="<UNKNOWN>" G ERRBULL1
 S Y=APCP("RUN BEGIN") D DD^%DT S XMB(5)=Y
ERRBULL1 S Y=DT D DD^%DT S XMB(1)=Y,XMB="APCP PCC TRANSMISSION ERROR"
 S XMDUZ=.5 D ^XMB
 K XMB,XM1,XMA,XMDT,XMM,APCP("QFLG1"),APCP("QFLG DES"),XMDUZ
 Q
