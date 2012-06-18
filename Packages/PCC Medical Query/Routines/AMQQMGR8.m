AMQQMGR8 ; IHS/CMI/THL - MORE OVERFLOW FROM AMQQMGR6 ;
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;-----
SYN ;EP;
 W !,"Print the UPDATED list of QMAN lab test names and synonyms now."
 W !,"(If synonyms exist, they will be indented below the primary lab test name.)"
 S DIR(0)="YO"
 S DIR("A")="Print QMAN lab tests now"
 S DIR("B")="NO"
 W !
 D ^DIR
 K DIR
 Q:Y'=1
SYN1 ;EP;
 K ^TMP("AMQQ LAB TEST",$J)
 D ^%ZIS
 I POP S AMQQSTOP=1 Q
 U IO D PRINT
 D ^%ZISC
 K ^TMP("AMQQ LAB TEST",$J),AMQQSTOP
 Q
 ; 
PRINT ;
 N AMQQLIEN,AMQQDA,X,Y,Z,%,AMQQTOT,AMQQSTOP
 S AMQQTOT=0
 S AMQQDA=999
 F  S AMQQDA=$O(^AMQQ(5,AMQQDA)) Q:'AMQQDA  D
 .I $P($G(^AMQQ(5,AMQQDA,4)),U,8) Q
 .S AMQQLIEN=(AMQQDA\1)-1000
 .S X=$P($G(^LAB(60,AMQQLIEN,0)),U)
 .Q:X=""
 .S ^TMP("AMQQ LAB TEST",$J,X)=""
 .S Z=""
 .F  S Z=$O(^AMQQ(5,AMQQDA,1,"B",Z)) Q:Z=""  D
 ..S ^TMP("AMQQ LAB TEST",$J,X,Z)=""
 Q:'$D(^TMP("AMQQ LAB TEST",$J))
 N XX
 S XX=""
 F  S XX=$O(^TMP("AMQQ LAB TEST",$J,XX)) Q:XX=""!$G(AMQQSTOP)  D
 .S Z="     "_XX
 .D INC(Z)
 .S Z=""
 .F  S Z=$O(^TMP("AMQQ LAB TEST",$J,XX,Z)) Q:Z=""  D:Z'=XX
 ..D INC("         "_Z)
 Q
 ;
INC(XX) ;
 N %
 S AMQQTOT=AMQQTOT+1
 W !
 I $E($G(IOST),1,2)="C-",'(AMQQTOT#20) W "<>" R %:$G(DTIME,300) W $C(13),?79,$C(13) I %=U S AMQQSTOP=1 Q
 W XX
 Q
 ; 
PCO ; PRINT COMPANION TESTS
 W !!,"Print the current list of companion lab tests now...."
 W !,"Companion tests are indented below the primary test"
 D ^%ZIS
 I POP S AMQQSTOP=1 Q
 U IO
 D CPRINT
 W !!!
 D ^%ZISC
 Q
 ; 
CPRINT ;
 N AMQQLAB,AMQQCO,X,AMQQTOT
 S AMQQTOT=0
 S AMQQLAB=0
 F  S AMQQLAB=$O(^AMQQ(5,"LC",AMQQLAB)) Q:'AMQQLAB  D
 .S XX=""
 .D INC(X)
 .S XX=$P($G(^AMQQ(5,AMQQLAB,0)),U)
 .D INC(XX)
 .S AMQQCO=0
 .F  S AMQQCO=$O(^AMQQ(5,"LC",AMQQLAB,AMQQCO)) Q:'AMQQCO  D
 ..S XX="   "_$P($G(^LAB(60,AMQQCO,0)),U)
 ..D INC(XX)
 Q
 ;
GETAKA ;EP;
 N X,Y,DIC,DA,%,AMQQSTG,AMQQLINE,AMQQLAB,AMQQI,AMQQDA
 W !,"Updating lab test synonym list..."
 S DIC("P")=$P(^DD(60,2,0),U,2)
 F AMQQLINE=1:1 S AMQQSTG=$$GET^AMQQMGRX(AMQQLINE) Q:AMQQSTG["***"  Q:AMQQSTG=""  D
 .K AMQQLAB,AMQQSYN
 .S AMQQSTG=$P(AMQQSTG,"; ",2)
 .S AMQQLAB=$P(AMQQSTG,U)
 .S X=AMQQLAB
 .S DIC="^LAB(60,"
 .S DIC(0)=""
 .D ^DIC
 .Q:Y=-1
 .S AMQQDA=+Y
 .F AMQQI=2:1:$L(AMQQSTG,U) S X=$P(AMQQSTG,U,AMQQI) D
 ..S DA(1)=AMQQDA,DIC="^LAB(60,"_DA(1)_",5,",DIC(0)="L"
 ..Q:$D(^LAB(60,DA(1),5,"B",X))
 ..D ^DIC
 ..I $P(Y,U,3) W "."
 Q
