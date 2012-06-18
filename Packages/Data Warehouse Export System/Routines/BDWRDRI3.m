BDWRDRI3 ; IHS/CMI/LAB - INIT CONT DW ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
INFORM ;EP - INFORM OPERATOR WHAT IS GOING TO HAPPEN
 Q:$D(ZTQUEUED)
 W !!,"This routine will generate IHS Data Warehouse records"
 W !,"for visits posted between a specified range of dates.  You may ""^"" out at any",!,"prompt and will be ask to confirm your entries prior to generating transactions."
 Q
 ;
CURRUN ;EP - COMPUTE DATES FOR CURRENT RUN
 S BDW("RUN BEGIN")=""
 I BDW("LAST LOG") S X1=$P(^BDWXLOG(BDW("LAST LOG"),0),U,2),X2=1 D C^%DTC S BDW("RUN BEGIN")=X,Y=X D DD^%DT
 I BDW("RUN BEGIN")="" D FIRSTRUN
 Q:BDW("QFLG")
 S X1=DT,X2=$P(^BDWSITE(1,0),U,3)*-1 D C^%DTC S Y=X
 I Y<BDW("RUN BEGIN") W:'$D(ZTQUEUED) !!,"  Ending date cannot be before beginning date!",$C(7) S BDW("QFLG")=18 Q
 S BDW("RUN END")=Y
 S Y=BDW("RUN BEGIN") X ^DD("DD") S BDW("X")=Y
 S Y=BDW("RUN END") X ^DD("DD") S BDW("Y")=Y
 W:'$D(ZTQUEUED) !!,"The inclusive dates for this run are ",BDW("X")," through ",BDW("Y"),"."
 K %,%H,%I,BDW("RDFN"),BDW("X"),BDW("Y"),BDW("LAST LOG"),BDW("LAST BEGIN"),BDW("Z"),BDW("DATE")
 Q
 ;
FIRSTRUN ; FIRST RUN EVER (NO LOG ENTRY)
 I $D(ZTQUEUED),$D(BDWO("SCHEDULED")) S BDW("QFLG")=12 Q
 W !!,"No log entry.  First run ever assumed (excluding date range re-exports).",!
 S BDW("RUN BEGIN")=$O(^AUPNVSIT("ADWO",0))
 S BDW("FIRST RUN")=1
 Q
 ;
 ;
ERRBULL ;ENTRY POINT - ERROR BULLETIN
 S BDW("QFLG1")=$O(^BDWERRC("B",BDW("QFLG"),"")),BDW("QFLG DES")=$P(^BDWERRC(BDW("QFLG1"),0),U,2)
 S XMB(2)=BDW("QFLG"),XMB(3)=BDW("QFLG DES")
 S XMB(4)=$S($D(BDW("RUN LOG")):BDW("RUN LOG"),1:"< NONE >")
 I '$D(BDW("RUN BEGIN")) S XMB(5)="<UNKNOWN>" G ERRBULL1
 S Y=BDW("RUN BEGIN") D DD^%DT S XMB(5)=Y
ERRBULL1 S Y=DT D DD^%DT S XMB(1)=Y,XMB="BDW DATA WAREHOUSE TRANSMISSION ERROR"
 S XMDUZ=.5 D ^XMB
 K XMB,XM1,XMA,XMDT,XMM,BDW("QFLG1"),BDW("QFLG DES"),XMDUZ
 Q
