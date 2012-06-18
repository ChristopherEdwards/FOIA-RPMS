ACRFPO2 ;IHS/OIRM/DSD/THL,AEF - PURCHASE ORDER PROCESSING;  [ 09/23/2005   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**19**;NOV 05, 2001
 ;;CONTINUATION OF ACRFPO
EXIT ;EP;
 K ACRDATA,ACRDAT2,ACRDATX,ACRRDATE,ACRPRIOR,ACRDATA1,ACRX,ACRDOC,ACRREF,ACRTXTYP,ACRDOC1,ACRMAX,ACRAPVT,ACRQUIT,ACRDA,ACRDOCDA,ACRGREF,ACRDOCDA,ACRREF1,ACRY,ACRAPDA,ACRLBDA,ACRNOW,ACRNUM,ACRORD,ACRREFDA,ACRSIG,ACRSIGG,ACRPRT
 K ACRSIGP,ACRSIGZ,ACRSIGZZ,ACRFDNO(1),ACRPOA,ACRPO,ACRPPO,ACRPA,ACRXMY,ACRSCRL
 Q
OBJ ;EP;DETERMINE OBJECT CLASS CODE
 K ACROBJ
 N X,Y,Z
 S X=0
 F  S X=$O(^ACRSS("J",ACRDOCDA,X)) Q:'X  D
 .S Y=$P($G(^ACRSS(X,0)),U,4)
 .S ACRW=$P($G(^ACRSS(X,"DT")),U,4)
 .I +Y D
 ..S Z=$G(^AUTTOBJC(+Y,0))
 ..S Z=$E($P(Z,U),1,2)
 ..I $L(Z) D
 ...S:'$D(ACR("OBJ",Z)) ACR("OBJ",Z)=""
 ...S ACR("OBJ",Z)=ACR("OBJ",Z)+ACRW
 K ACRW
 S (X,Y)=0
 F  S X=$O(ACR("OBJ",X)) Q:'X  I ACR("OBJ",X)>Y D
 .S Z=X
 .S Y=ACR("OBJ",X)
 Q:$G(Z)=""
 S ACROBJ=Z_"00"
 K ACR("OBJ")
 Q
VENDOR ;EP;INCLUDE VENDOR NAME ON DISPLAY
 S DIR(0)="YO"
 S DIR("A")="Display VENDOR's name"
 S DIR("B")="NO"
 S DIR("?")="Enter 'Y' if you want the VENDOR's name displayed."
 W !
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)
 I Y=1 S ACRSCRL=6
 E  S ACRSCRL=10
 Q
SELECT ;EP;TO SELECT PURCHASE ORDER
 I 'ACRMAX D  Q
 .W !?10,"NO PURCHASE ORDERS PENDING"
 .D PAUSE^ACRFWARN
 .S ACRQUIT=""
 K ACRQUIT
 S DIR(0)="LO^1:"_ACRMAX
 S DIR("A")=$S($D(ACRPO):"Which one",1:"Assign NO(S)")
 W !
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)!(+Y<1)
 N ACRY,ACRI,ACRZI
 S ACRY=Y
 F ACRZI=1:1 S ACRX=$P(ACRY,",",ACRZI) Q:ACRX=""!$D(ACROUT)  D  Q:$D(ACROUT)
 .S ACRX=+ACRX
 .S ACRXPO=ACRX
 .N ACRENTRY
 .S ACRENTRY="PO"
 .S (DA,ACRDOCDA,ACRZDA,ACRDOCDA)=$P(^TMP("ACRDATA",$J,ACRX),U)
 .S ACRDOC=$P(^TMP("ACRDATA",$J,ACRX),U,4)
 .S ACRTXTYP=$P(^TMP("ACRDATA",$J,ACRX),U,3)
 .D SETDOC^ACRFEA1
 .I $P(ACRDOC0,U,4)=35 S ACRREFX=116
 .E  S ACRREFX=$P(ACRDOC0,U,13),ACRREFX=$P(^AUTTDOCR(ACRREFX,0),U)
 .Q:$D(ACRTRANS)
 .I $D(ACRPOA) D
 ..D ASSIGN^ACRFPO1
 ..S ACRPOA=""
 ..K ACRPO
 .I $D(ACRPO)&'$D(ACRPPO) D
 ..D EDIT
 ..K ACRPOA
 ..S ACRPO=""
 .S ACRX=ACRXPO
 .K ACRXPO,ACRIPO
 Q
AGENT ;EP;TO SELECT PURCHASING AGENT FOR PO REVIEW
 S DIR(0)="YO"
 S DIR("A")="Display documents assigned to one PURCHASING AGENT only"
 S DIR("B")="NO"
 S DIR("?")="Enter 'Y' to display only documents assigned to a specified purchasing agent."
 W !
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)
 I +Y'=1 K ACRDUZ,ACRREV Q
 S DIC="^ACRPA("
 S DIC("A")="Which PURCHASING AGENT: "
 S DIC(0)="AEMQZ"
 W !
 D DIC^ACRFDIC
 I $E(X)=U!$D(DTOUT)!$D(DUOUT) S ACRQUIT="" Q
 S ACRDUZ=+Y
 S ACRPO=""
 Q
TEMP ;EP;TEMP MESSAGE
 W @IOF,*7,*7,*7
 W !?10,"***   PURCHASING SUPERVISOR PLEASE NOTE THE FOLLOWING   ***"
 W !?5,"A slight modification has been made to allow ARMS to work better with"
 W !?5,"requisitions created to produce CONTRACTs rather than PURCHASE ORDERs."
 W !!?5,"The CONTRACT module of ARMS is still not yet completed. However,"
 W !?5,"if you select '2' below for requisitions which are intended to initiate a"
 W !?5,"CONTRACT action, ARMS will allow you to proceed with assigning the document"
 W !?5,"to a contract or purchasing agent.  The BASIC data can be completed and"
 W !?5,"the document sent for approval and 'signed.'  This will allow the initiator"
 W !?5,"to use ARMS to initiate and track the document throughout the process"
 W !?5,"and get the dollars recorded against their DEPARTMENT ACCOUNT."
 W !?5,"However, NO CIS (Contract Information System) entry will be created."
 W !?5,"The document will be 'set aside' by ARMS and can be processed manually"
 W !?5,"as a new CONTRACT or CONTRACT action."
 W !!?5,"Therefore, ALL ARMS requisitions which are intended to initiate a"
 W !?5,"CONTRACT action should be coded as a '2' for 'Contract'd."
 Q
HEAD ;EP;
 W:$D(IOF)&'$D(ACRTRANS)&'$D(ACRREV) @IOF
 W $S($D(ACRPO)!$D(ACRPPO):"Select PURCHASE ORDER:",1:"Select REQUEST to ASSIGN TO PURCHASING AGENT")
 W !!?2,"NO."
 W ?9,"REQUEST NO."
 W ?24,"RQD BY/OBJ CD/$$"
 W ?40,"|  NO."
 W ?50,"REQUEST NO."
 W ?65,"RQD BY/OBJ CD/$"
 W !,"------"
 W ?7,"----------------"
 W ?24,"----------------"
 W ?40,"|------"
 W ?48,"----------------"
 W ?65,"---------------"
 Q
ASSONE ;EP;TO ASSIGN ONE DOCUMENT ONLY
 K ACRPO
 S ACRPOA=""
 S DIR(0)="SO^1:Assign ONE Document Only;2:List ALL Pending PO's;3:Transfer Unsigned PO's to new Agent"
 W !
 D DIR^ACRFDIC
 I $D(ACRQUIT)!$D(ACROUT)!(123'[+Y) S ACRQUIT="" Q
 Q:Y=2
 I Y=3 D TRANS Q
ONE ;EP;
 D LOOKUP^ACRFPO3
 K ACRREFZ,ACRAPV
 I $D(ACRQUIT)!$D(ACROUT) K ACRQUIT
 N ACRENTRY
 S ACRENTRY="PO",ACRONE=""
 D ASSIGN^ACRFPO1
 Q
EDIT ;EP;
 S ACRENTRY=$T(@ACRENTRY^ACRFCTL1)
 S ACRPO=""
 K ACRPOA
 D SET^ACRFEA
 D ^ACRFEA4
 K ACRPRCS
 Q
TRANS ;EP;TO TRANSFER ALL ACTIVE/UNSIGNED PO'S TO NEW PA
 N ACRPA1,ACRPA2
 S DIC="^ACRPA("
 S DIC(0)="AEMQZ"
 S DIC("A")="Purchasing Agent: "
 W !!,"Transfer PO's FROM"
 D DIC^ACRFDIC
 I Y<1 W !,"No Purchasing Agent selected." H 2 Q
 S ACRPA1=+Y
 S DIC="^ACRPA("
 S DIC(0)="AEMQZ"
 S DIC("A")="Purchasing Agent: "
 W !!,"Transfer PO's TO"
 D DIC^ACRFDIC
 I Y<1 W !,"No Purchasing Agent selected." H 2 Q
 S ACRPA2=+Y
 D T1
 S ACRQUIT=""
 Q
T1 S (ACRDOCDA,ACRJ)=0
 F  S ACRDOCDA=$O(^ACRDOC("PA",ACRPA1,ACRDOCDA)) Q:'ACRDOCDA  I $E($G(^ACROBL(ACRDOCDA,"APV")))="A",$P(^("APV"),U,8)="" S ACRJ=ACRJ+1
 W !!?10,"All ",@ACRON,ACRJ,@ACROF," unsigned PO's"
 ;W !?10,"currently  assigned to: ",$P($G(^VA(200,ACRPA1,0)),U)  ;ACR*2.1*19.02 IM16848
 ;W !?10,"will be re-assigned to: ",$P($G(^VA(200,ACRPA2,0)),U)  ;ACR*2.1*19.02 IM16848
 W !?10,"currently  assigned to: ",$$NAME2^ACRFUTL1(ACRPA1)  ;ACR*2.1*19.02 IM16848
 W !?10,"will be re-assigned to: ",$$NAME2^ACRFUTL1(ACRPA2)  ;ACR*2.1*19.02 IM16848
 S DIR(0)="YO"
 S DIR("A",1)="Are you certain you want"
 S DIR("A")="to make this transfer"
 S DIR("B")="NO"
 W !
 D DIR^ACRFDIC
 I Y'=1 S ACRQUIT="" Q
 D T2
 Q
T2 S ACRDOCDA=0
 F  S ACRDOCDA=$O(^ACRDOC("PA",ACRPA1,ACRDOCDA)) Q:'ACRDOCDA  I $E($G(^ACROBL(ACRDOCDA,"APV")))="A",$P(^("APV"),U,8)="" D
 .S DA=ACRDOCDA
 .S DIE="^ACRDOC("
 .S DR=".2////"_ACRPA2
 .D DIE^ACRFDIC
 .;W !,$P(^ACRDOC(ACRDOCDA,0),U),?15," now assigned to: ",$P($G(^VA(200,ACRPA2,0)),U)  ;ACR*2.1*19.02 IM16848
 .W !,$P(^ACRDOC(ACRDOCDA,0),U),?15," now assigned to: ",$$NAME2^ACRFUTL1(ACRPA2)  ;ACR*2.1*19.02 IM16848
 Q
