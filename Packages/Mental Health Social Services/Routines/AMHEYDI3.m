AMHEYDI3 ; IHS/CMI/LAB - initialization part III AUGUST 14, 1992 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
INFORM ;EP - INFORM OPERATOR WHAT IS GOING TO HAPPEN
 Q:$D(ZTQUEUED)
 W !!,"This routine will generate BH transactions to be sent to HQ.",!,"The transactions are for records posted since the last time you did an",!,"export up until yesterday.",!,"Both BH visit records and Suicide forms will be exported.",!
 W !,"You may ""^"" out at any prompt and will be",!,"ask to confirm your entries prior to generating transactions."
 Q
 ;
CURRUN ;EP - COMPUTE DATES FOR CURRENT RUN
 S AMH("RUN BEGIN")=""
 I AMH("LAST LOG") S X1=$P(^AMHXLOG(AMH("LAST LOG"),0),U,2),X2=1 D C^%DTC S AMH("RUN BEGIN")=X,Y=X D DD^%DT
 I AMH("RUN BEGIN")="" D FIRSTRUN
 Q:AMH("QFLG")
 S X1=DT,X2=-2 D C^%DTC S Y=X
 I Y<AMH("RUN BEGIN") W:'$D(ZTQUEUED) !!,"  Ending date cannot be before beginning date!",$C(7) S AMH("QFLG")=18 Q
 S AMH("RUN END")=Y
 S Y=AMH("RUN BEGIN") X ^DD("DD") S AMH("X")=Y
 S Y=AMH("RUN END") X ^DD("DD") S AMH("Y")=Y
 W:'$D(ZTQUEUED) !!,"The inclusive dates for this run are ",AMH("X")," through ",AMH("Y"),"."
 K %,%H,%I,AMH("RDFN"),AMH("X"),AMH("Y"),AMH("LAST LOG"),AMH("LAST BEGIN"),AMH("Z"),AMH("DATE")
 Q
 ;
FIRSTRUN ; FIRST RUN EVER (NO LOG ENTRY)
 I $D(ZTQUEUED),$D(AMHO("SCHEDULED")) S AMH("QFLG")=12 Q
 W !!,"No log entry.  First run ever assumed.",!
FRLP ;
 S DIR(0)="D^::EP",DIR("A")="Enter beginning date for this run" K DA D ^DIR K DIR
 I Y=""!($D(DIRUT)) S AMH("QFLG")=99 Q
 S AMH("X")=Y
 D DATECHK Q:AMH("QFLG")  G:Y="" FRLP
 S AMH("RUN BEGIN")=Y
 S AMH("FIRST RUN")=1
 Q
 ;
DATECHK ;
 I AMH("X")="^" S AMH("QFLG")=99 Q
 S %DT="PX",X=AMH("X") D ^%DT I X="?" S Y="" Q
 I Y<0!(Y>DT)!(Y=DT) W !!,$S(Y>DT!(Y=DT):"  Current or future date not allowed!",1:"  Invalid date!"),$C(7) S Y=""
 Q
 ;
ERRBULL ;ENTRY POINT - ERROR BULLETIN
 S AMH("QFLG1")=$O(^AMHDTER("B",AMH("QFLG"),"")),AMH("QFLG DES")=$P(^AMHDTER(AMH("QFLG1"),0),U,2)
 S XMB(2)=AMH("QFLG"),XMB(3)=AMH("QFLG DES")
 S XMB(4)=$S($D(AMH("RUN LOG")):AMH("RUN LOG"),1:"< NONE >")
 I '$D(AMH("RUN BEGIN")) S XMB(5)="<UNKNOWN>" G ERRBULL1
 S Y=AMH("RUN BEGIN") D DD^%DT S XMB(5)=Y
ERRBULL1 S Y=DT D DD^%DT S XMB(1)=Y,XMB="AMH BH TRANSMISSION ERROR"
 S XMDUZ=.5 D ^XMB
 K XMB,XM1,XMA,XMDT,XMM,AMH("QFLG1"),AMH("QFLG DES"),XMDUZ
 Q
