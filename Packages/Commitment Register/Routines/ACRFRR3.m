ACRFRR3 ;IHS/OIRM/DSD/THL,AEF - RECEIVING REPORT/INVOICE AUDIT CONT'D;  [ 09/23/2005   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**19**;NOV 05, 2001
 ;;CONTINUATION OF ACRFRR
EORA ;EP;EDIT OR ADD RECEIVING REPORT
 I $D(ACRRR)#2,'$D(^ACRAPL("AC",DUZ,7)) D  Q
 .W !!,"You do not have authority to sign as a Receiving Agent."
 .W !,"Contact your ARMS Systems Manager if you should have this authority."
 .D PAUSE^ACRFWARN
 .S ACRQUIT=""
 .K ACRFINAL
 I $D(ACRIV)#2,'$D(^ACRAPL("AC",DUZ,42)) D  Q
 .W !!,"You do not have authority to sign as an Invoice Auditor."
 .W !,"Contact your ARMS Systems Manager if you should have this authority."
 .D PAUSE^ACRFWARN
 .S ACRQUIT=""
 .K ACRFINAL
 S ACRDUZ=$S($D(ACRRR)#2:$P(^ACRDOC(ACRDOCDA,"REQ1"),U,6),1:$P(^ACRDOC(ACRDOCDA,"POIO"),U,8))
 I 'ACRDUZ D  Q
 .W !!,"No ",$S($D(ACRRR)#2:"Receiving Agent",1:"Invoice Auditor")
 .W " is specified for this Purchase Order."
 .W !,"Please contact your ARMS Systems Manager for assistance."
 .D PAUSE^ACRFWARN
 .S ACRQUIT=""
 .K ACRFINAL
 I DUZ'=ACRDUZ,'$D(^ACRAPL("ALT",ACRDUZ,$S($D(ACRRR)#2:7,1:42),DUZ)) D  Q:$D(ACRQUIT)
 .N X,Y
 .S Y=0
 .F  S Y=$O(^ACRSS("J",ACRDOCDA,Y)) Q:'Y!$D(ACRQUIT)  D
 ..S X=$P(^ACRSS(Y,0),U,3)
 ..S X=$P($G(^ACRDOC(X,"REQ1")),U,6)
 ..I X=DUZ!$D(^ACRAPL("ALT",X,$S($D(ACRRR)#2:7,1:42),DUZ)) S ACRQUIT=""
 .I $D(ACRQUIT) K ACRQUIT Q
 .;S ACRDUZ=$P(^VA(200,ACRDUZ,0),U)  ;ACR*2.1*19.02 IM16848
 .S ACRDUZ=$$NAME2^ACRFUTL1(ACRDUZ)  ;ACR*2.1*19.02 IM16848
 .S ACRDUZ=$P($P(ACRDUZ,",",2)," ")_" "_$P(ACRDUZ,",")
 .W !!,"You are not the designated "
 .W $S($D(ACRRR)#2:"Receiving Agent",1:"Invoice Auditor")
 .W " for this Purchase Order,"
 .W !,"nor are you an alternate to the designated "
 .W $S($D(ACRRR)#2:"Receiving Agent",1:"Invoice Auditor")
 .W !!,"Contact ",ACRDUZ," or his/her authorized alternate to complete"
 .W !,"this "
 .W $S($D(ACRRR)#2:"receiving action.",1:"invoice audit.")
 .D PAUSE^ACRFWARN
 .S ACRQUIT=""
 .K ACRFINAL
 K ACRRRADD
 I $D(ACRIV)#2,$P(^ACRDOC(ACRDOCDA,"PO"),U,16)]"" S ACRIVNO=$P(^("PO"),U,16)
 E  I $D(ACRIV)#2,$P(^ACRDOC(ACRDOCDA,"PO"),U,16)="" D
 .S DA=ACRDOCDA
 .S DIE="^ACRDOC("
 .S DR="103200T;103200.1T"
 .W !
 .D DIE^ACRFDIC
 .S ACRIVNO=$P(^ACRDOC(ACRDOCDA,"PO"),U,16)
 I $D(ACRRR)#2 D
 .S DIR(0)="SO^1:Add Receiving Report;2:Cancel an Item"
 .I $D(^ACRRR("C",ACRDOCDA)) D
 ..S DIR(0)=DIR(0)_";3:Edit Receiving Report by Item;4:Edit Receiving Report by Report"
 I $D(ACRIV)#2 D ^ACRFIV Q
 S DIR(0)=DIR(0)_";P:Print Receiving Report"
 S DIR("A")="Which one"
 D DIR^ACRFDIC
 S ACRFINAL=0
 Q:(1234'[Y&(Y'="P"))!$D(ACRQUIT)!$D(ACROUT)
 I Y,$D(ACRIV)#2 S Y=Y+2
 I Y=1 S ACRRRADD="" D ADD^ACRFRR33 S Y=1
 I Y=2 D CANCEL^ACRFRR2 S Y=1
 I Y=3 D ITEM K ACRQUIT S Y=1
 I Y=4 D SELECT S Y=1
 I Y="P" D P11^ACRFPO1 K ACRQUIT
 S ACRFINAL=0
 Q
SELECT ;EP;SELECT RECEIVING REPORT TO EDIT
 F  D S1 Q:$D(ACRQUIT)!$D(ACROUT)
 K ACRQUIT
 Q
S1 ;EP;
 S (X,Z)=0
 F  S X=$O(^ACRRR("AC",ACRDOCDA,X)) Q:'X  S Z=Z+1
 I Z=0 D  Q
 .W !!,"No Receiving Reports on file for this document."
 .D PAUSE^ACRFWARN
 I Z=1 D  Q
 .S (ACRRRNO,Y)=1
 .D S2
 .S ACRQUIT=""
 S DIR(0)="NO^1:"_Z
 S DIR("A")="Which Receiving Report"
 W !
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)!'Y
 S ACRRRNO=Y
S2 D BYRR^ACRFRR32
 Q
ITEM ;EP;TO AUDIT BY ITEM
 F  D I1 Q:$D(ACRQUIT)!$D(ACROUT)
 Q
I1 I ACRSSMAX=1 S ACRXX=+ACRSS0 G ITEM1
 S DIR(0)="LO^1:"_ACRSSMAX
 S DIR("A")="Which item(s)"
 W !
 D DIR^ACRFDIC
 Q:'+Y!$D(ACRQUIT)!$D(ACROUT)
 S ACRXX=Y
 I $G(Y(1))]"" S %X="Y(",%Y="ACRXX(" D %XY^%RCR
 D ITEM1
 N ACRJJ
 S ACRJJ=0
 F  S ACRJJ=$O(ACRXX(ACRJJ)) Q:'ACRJJ  S ACRXX=ACRXX(ACRJJ) D ITEM1
 Q
ITEM1 F ACRK=1:1 S ACRSSNO=$P(ACRXX,",",ACRK) Q:'ACRSSNO  S ACRSSDA=+$G(ACRSS(ACRSSNO)) D:ACRSSDA DISPLAY^ACRFRR32
 S ACRQUIT=""
 Q
IADD ;EP;
 Q:'$G(ACRRRNO)
 I '$D(^ACRDOC(ACRDOCDA,20,"B",ACRRRNO)) D
 .S:'$D(^ACRDOC(ACRDOCDA,20,0)) ^(0)="^9002196.2001"
 .S DA(1)=ACRDOCDA
 .S DINUM=ACRRRNO
 .S X=$S($D(ACRIVNO):ACRIVNO,1:$P(^ACRDOC(ACRDOCDA,"PO"),U,16))
 .Q:X=""
 .S DIC="^ACRDOC("_DA(1)_",20,"
 .S DIC(0)="L"
 .S DIC("DR")=".02////"_$P($G(^ACRDOC(ACRDOCDA,"PO")),U,21)_";.03////"_$P($G(^ACRDOC(ACRDOCDA,5)),U,6)
 .D FILE^ACRFDIC
 Q
