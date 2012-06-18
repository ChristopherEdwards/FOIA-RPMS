BCHEXDI3 ; IHS/TUCSON/LAB - initialization part III ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;CHR export initialization for new export.
 ;
INFORM ;EP - INFORM OPERATOR WHAT IS GOING TO HAPPEN
 Q:$D(ZTQUEUED)
 W !!,"This routine will generate CHRIS II records to be sent to HQ.",!,"The data transmitted will include everything entered since the last time",!,"data was exported up until yesterday."
 W !,"You may ""^"" out at any prompt and will be",!,"ask to confirm your entries prior to generating transactions."
 Q
 ;
CURRUN ;EP - COMPUTE DATES FOR CURRENT RUN
 S BCH("RUN BEGIN")=""
 I BCH("LAST LOG") S X1=$P(^BCHXLOG(BCH("LAST LOG"),0),U,2),X2=1 D C^%DTC S BCH("RUN BEGIN")=X,Y=X D DD^%DT
 I BCH("RUN BEGIN")="" D FIRSTRUN
 Q:BCH("QFLG")
 S X1=DT,X2=-1 D C^%DTC S Y=X
 I Y<BCH("RUN BEGIN") W:'$D(ZTQUEUED) !!,"  Ending date cannot be before beginning date!",$C(7) S BCH("QFLG")=18 Q
 S BCH("RUN END")=Y
 S Y=BCH("RUN BEGIN") X ^DD("DD") S BCH("X")=Y
 S Y=BCH("RUN END") X ^DD("DD") S BCH("Y")=Y
 W:'$D(ZTQUEUED) !!,"The inclusive dates for this run are ",BCH("X")," through ",BCH("Y"),"."
 K %,%H,%I,BCH("RDFN"),BCH("X"),BCH("Y"),BCH("LAST LOG"),BCH("LAST BEGIN"),BCH("Z"),BCH("DATE")
 Q
 ;
FIRSTRUN ; FIRST RUN EVER (NO LOG ENTRY)
 I $D(ZTQUEUED),$D(BCHO("SCHEDULED")) S BCH("RUN BEGIN")=2950101,BCH("FIRST RUN")=1 Q
 W !!,"No log entry.  First run ever assumed.",!
FRLP ;
 K DIR W ! S DIR(0)="D^::EP",DIR("A")="Enter Beginning Date for this Run" K DA D ^DIR K DIR
 I $D(DIRUT) S BCH("QFLG")=99 Q
 I Y="" S BCH("QFLG")=99 Q
 S BCH("X")=Y
 D DATECHK Q:BCH("QFLG")  G:Y="" FRLP
 S BCH("RUN BEGIN")=Y
 S BCH("FIRST RUN")=1
 Q
 ;
DATECHK ;
 I BCH("X")="^" S BCH("QFLG")=99 Q
 S %DT="PX",X=BCH("X") D ^%DT I X="?" S Y="" Q
 I Y<0!(Y>DT)!(Y=DT) W !!,$S(Y>DT!(Y=DT):"  Current or future date not allowed!",1:"  Invalid date!"),$C(7) S Y=""
 Q
 ;
ERRBULL ;ENTRY POINT - ERROR BULLETIN
 Q:BCH("QFLG")=22  ;if error is 22, no visits don't send bulletin
 S BCH("QFLG1")=$O(^BCHDTER("B",BCH("QFLG"),"")),BCH("QFLG DES")=$P(^BCHDTER(BCH("QFLG1"),0),U,2)
 S XMB(2)=BCH("QFLG"),XMB(3)=BCH("QFLG DES")
 S XMB(4)=$S($D(BCH("RUN LOG")):BCH("RUN LOG"),1:"< NONE >")
 I '$D(BCH("RUN BEGIN")) S XMB(5)="<UNKNOWN>" G ERRBULL1
 S Y=BCH("RUN BEGIN") D DD^%DT S XMB(5)=Y
ERRBULL1 S Y=DT D DD^%DT S XMB(1)=Y,XMB="BCH CHR TRANSMISSION ERROR"
 S XMDUZ=.5 D ^XMB
 K XMB,XM1,XMA,XMDT,XMM,BCH("QFLG1"),BCH("QFLG DES"),XMDUZ
 Q
