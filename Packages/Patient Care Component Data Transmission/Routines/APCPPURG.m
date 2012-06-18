APCPPURG ; IHS/TUCSON/LAB - OHPRD-TUCSON/EDE PURGE VISIT POINTERS AUGUST 14, 1992 ; [ 04/03/98  08:39 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;;APR 03, 1998
 ;
 D INIT
 I APCP("QFLG") D EOJ W !!,"Bye",!! Q
 D PROCESS
 D EOJ
 W !!,"DONE",!!
 Q
 ;
PROCESS ;
 S APCP("LOG")=APCP("OLDEST LOG")-1 F  S APCP("LOG")=$O(^APCPLOG(APCP("LOG"))) Q:APCP("LOG")'=+APCP("LOG")  D DELCHK Q:APCP("QFLG")
 Q
DELCHK ;
 S X=^APCPLOG(APCP("LOG"),0),APCP("BEGIN DATE")=$P(X,U),APCP("END DATE")=$P(X,U,2),APCP("COUNT")=$P(X,U,6)
 S Y=APCP("BEGIN DATE") X ^DD("DD") S APCP("BEGIN DATE")=Y
 S Y=APCP("END DATE") X ^DD("DD") S APCP("END DATE")=Y
 S APCP("VISITS")=$P(^APCPLOG(APCP("LOG"),21,0),U,4)
 W !!,"Log entry ",APCP("LOG")," was for date range ",APCP("BEGIN DATE")," through ",APCP("END DATE"),!,"and generated ",APCP("COUNT")," transactions from ",APCP("VISITS")," visits."
RDD ;
 S DIR(0)="Y",DIR("A")="Do you want to delete the VISIT pointers for this log entry",DIR("B")="N" K DA D ^DIR K DIR
 I Y K ^APCPLOG(APCP("LOG"),21),^APCPLOG(APCP("LOG"),51) W "  Done" Q
 S APCP("QFLG")=1
 Q
 ;
INIT ; 
 K APCP
 I '$D(DUZ(2))#2 W !!,$C(7),$C(7),"SITE NOT SET!!!" S APCP("QFLG")=1 Q
 S APCP("COUNT")=0,APCP("QFLG")=0
 D CHKSITE^APCPDRI
 Q:APCP("QFLG")
 S (APCP("X"),APCP("LAST LOG"))=$P(^APCPLOG(0),U,3) F  S APCP("X")=$O(^APCPLOG(APCP("X"))) Q:APCP("X")'=+APCP("X")  S APCP("LAST LOG")=APCP("X")
 S APCP("OLDEST LOG")=APCP("LAST LOG") F APCP("X")=APCP("LAST LOG"):-1:1 I $D(^APCPLOG(APCP("X"))) Q:'$D(^APCPLOG(APCP("X"),21))  S APCP("OLDEST LOG")=APCP("X"),APCP("COUNT")=APCP("COUNT")+1
 I APCP("COUNT")=0 W !!,"No log entries with VISIT data." S APCP("QFLG")=1 Q
 W !!,"There ",$S(APCP("COUNT")>1:"are",1:"is")," ",APCP("COUNT")," generation",$S(APCP("COUNT")>1:"s ",1:" "),"with VISIT data."
RD ;
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT)!('Y) S APCP("QFLG")=1
 Q
 ;
CHKENTRY ; CHECK LOG ENTRY
 Q:'$D(^APCPLOG(APCP("X"),21))
 S:APCP("OLDEST LOG")="" APCP("OLDEST LOG")=APCP("X")
 S APCP("COUNT")=APCP("COUNT")+1
 Q
 ;
EOJ ; EOJ CLEAN UP
 K APCP
 Q
