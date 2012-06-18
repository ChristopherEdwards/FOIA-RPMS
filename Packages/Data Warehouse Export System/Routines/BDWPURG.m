BDWPURG ; IHS/CMI/LAB - PURGE DW LOG ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;
 D INIT
 I BDW("QFLG") D EOJ W !!,"Bye",!! K DIR S DIR(0)="E",DIR("A")="Press ENTER to continue" D ^DIR K DIR Q
 D PROCESS
 D EOJ
 W !!,"DONE",!!
 Q
 ;
PROCESS ;
 S BDW("LOG")=BDW("OLDEST LOG")-1 F  S BDW("LOG")=$O(^BDWXLOG(BDW("LOG"))) Q:BDW("LOG")'=+BDW("LOG")  D DELCHK Q:BDW("QFLG")
 Q
DELCHK ;
 S X=^BDWXLOG(BDW("LOG"),0),BDW("BEGIN DATE")=$P(X,U),BDW("END DATE")=$P(X,U,2),BDW("COUNT")=$P(X,U,6)
 S Y=BDW("BEGIN DATE") X ^DD("DD") S BDW("BEGIN DATE")=Y
 S Y=BDW("END DATE") X ^DD("DD") S BDW("END DATE")=Y
 S BDW("VISITS")=$P(^BDWXLOG(BDW("LOG"),21,0),U,4)
 W !!,"Log entry ",BDW("LOG")," was for date range ",BDW("BEGIN DATE")," through ",BDW("END DATE"),!,"and generated ",BDW("COUNT")," transactions from ",BDW("VISITS")," encounters."
RDD ;
 S DIR(0)="Y",DIR("A")="Do you want to delete the VISIT pointers for this log entry",DIR("B")="N" K DA D ^DIR K DIR
 I Y K ^BDWXLOG(BDW("LOG"),21),^BDWXLOG(BDW("LOG"),51),^BDWXLOG(BDW("LOG"),41) W "  Done" Q
 S BDW("QFLG")=1
 Q
 ;
INIT ; 
 K BDW
 I '$D(DUZ(2))#2 W !!,$C(7),$C(7),"SITE NOT SET!!!" S BDW("QFLG")=1 Q
 S BDW("COUNT")=0,BDW("QFLG")=0
 D CHKSITE^BDWRDRI
 Q:BDW("QFLG")
 S (BDW("X"),BDW("LAST LOG"))=$P(^BDWXLOG(0),U,3) F  S BDW("X")=$O(^BDWXLOG(BDW("X"))) Q:BDW("X")'=+BDW("X")  S BDW("LAST LOG")=BDW("X")
 S BDW("OLDEST LOG")=BDW("LAST LOG") F BDW("X")=BDW("LAST LOG"):-1:1 I $D(^BDWXLOG(BDW("X"))) Q:'$D(^BDWXLOG(BDW("X"),21))  S BDW("OLDEST LOG")=BDW("X"),BDW("COUNT")=BDW("COUNT")+1
 I BDW("COUNT")=0 W !!,"No log entries with VISIT data." S BDW("QFLG")=1 Q
 W !!,"There ",$S(BDW("COUNT")>1:"are",1:"is")," ",BDW("COUNT")," generation",$S(BDW("COUNT")>1:"s ",1:" "),"with ENCOUNTER/VISIT data."
RD ;
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT)!('Y) S BDW("QFLG")=1
 Q
 ;
CHKENTRY ; CHECK LOG ENTRY
 Q:'$D(^BDWXLOG(BDW("X"),21))
 S:BDW("OLDEST LOG")="" BDW("OLDEST LOG")=BDW("X")
 S BDW("COUNT")=BDW("COUNT")+1
 Q
 ;
EOJ ; EOJ CLEAN UP
 K BDW
 Q
