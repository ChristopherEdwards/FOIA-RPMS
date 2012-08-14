ACRFPRC2 ;IHS/OIRM/DSD/THL,AEF - PROCESS PENDING DOCUMENTS;  [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;CONTINUATION OF ACRFPRCS
CSI ;EP;DISPLAY APPROVAL STATUS
 D DISPLAY^ACRFTXTP
 D SELECT^ACRFTXTP Q:$D(ACRQUIT)!$D(ACROUT)
 S ACRX=0,ACRFDNO(1)=","
 F  S ACRX=$O(^ACRLOCB("SEC",DUZ,ACRX)) Q:'ACRX  S ACRFDNO(1)=ACRFDNO(1)_ACRX_","
 I ACRFDNO(1)="," D
 .W !!,"YOU DO NOT HAVE ACCESS TO ANY ACCOUNTS."
 .H 2
 .S ACRQUIT=""
 W !!
 S ACRAPVT=0
 F  S ACRAPVT=$O(^ACRAPVS("ANXT",ACRAPVT)) Q:'ACRAPVT  D
 .S ACRINDV=0
 .F  S ACRINDV=$O(^ACRAPVS("ANXT",ACRAPVT,ACRINDV)) Q:'ACRINDV  D
 ..S D0=0
 ..F  S D0=$O(^ACRAPVS("ANXT",ACRAPVT,ACRINDV,D0)) Q:'D0!$D(ACRQUIT)!$D(ACROUT)  D CSI2
 K ACRQUIT
 D PPO
 Q
 I 'ACRJ D
 .W !!,"NO ",@ACRON,$P(^ACRTXTYP(ACRTXDA,0),U),@ACROF," PENDING."
 .H 2
 Q
CSI2 Q:'D0
 I '$D(^ACRAPVS(D0,0)),ACRINDV K ^ACRAPVS("ANXT",ACRAPVT,ACRINDV,D0) Q
 S ACRDOCDA=+^ACRAPVS(D0,0)
 I '$D(^ACRDOC(ACRDOCDA,0)) D  Q
 .S DA=D0
 .S DIK="^ACRAPVS("
 .D DIK^ACRFDIC
 .K ^ACRAPVS("ANXT",ACRAPVT,ACRINDV,D0)
 S ACRLBDA=","_$P(^ACRAPVS(D0,0),U,5)_","
 Q:$P(^ACRDOC(ACRDOCDA,0),U,4)'=ACRTXDA!(ACRFDNO(1)'[ACRLBDA)
 W !
 I '$D(^ACRAPVS("AB",ACRDOCDA)) W !,"DOCUMENT HAS NOT BEEN SUBMITTED FOR APPROVAL."
 E  D
 .S ACRD0=0
 .F  S ACRD0=$O(^ACRAPVS("AB",ACRDOCDA,ACRD0)) Q:'ACRD0  D
 ..S ACRAPVT=$P(^ACRAPVS(ACRD0,0),U,3)
 ..S ACRINDV=$P(^ACRAPVS(ACRD0,"DT"),U,2)
 ..I $D(^ACRAPVS("ANXT",ACRAPVT,ACRINDV,ACRD0)) D
 ...S D0=ACRD0
 ...N DXS,DIP,DC,DN
 ...D ^ACRPTTS
 I $D(ACRD0),'ACRD0 D
 .W !,"DOCUMENT PENDING IN PROCUREMENT."
 .K ACRD0
 K ACRAPVT,ACRINDV
 D PAUSE^ACRFWARN
 Q
LIST S ACRDOCDA=+^ACRAPVS(D0,0)
LIST1 S ACRJ=ACRJ+1
 S ACRDATA=^ACRDOC(ACRDOCDA,0)
 S ACRDOC=$P(ACRDATA,U)
 S ACRTXTYP=$P(ACRDATA,U,4)
 S:$D(ACRPPO1) ACRTXTYP=1
 K ACRPPO1
 S ACRREF=$P(^ACRTXTYP(ACRTXTYP,0),U,2)
 S ACRREF1=$P(^AUTTDOCR(ACRREF,0),U)
 S ACRID=$E($P(ACRDATA,U,14),1,15)
 S ^TMP("ACRDATA",$J,ACRJ)=ACRDOCDA_U_ACRREF1_U_ACRTXTYP_U_D0_U_ACRDOC_U_ACRID
 S ACRDATA1(ACRDOCDA)=""
 I $Y#IOSL>19,$E(IOST,1,2)="C-" D PAUSE^ACRFWARN W @IOF
 Q
PPO I $D(^TMP("ACRDATA",$J))#2 D
 .S ACRX=0
 .F  S ACRX=$O(^TMP("ACRDATA",$J,ACRX)) Q:'ACRX  I '$D(ACRDATA1($P(^TMP("ACRDATA",$J,ACRX),U))) D PPH Q
 S ACRX=0
 F  S ACRX=$O(^ACRDOC("PA",ACRX)) Q:'ACRX  D
 .S D0=0
 .F  S D0=$O(^ACRDOC("PA",ACRX,D0)) Q:'D0!$D(ACRQUIT)!$D(ACROUT)  D
 .I '$D(ACRDATA1(D0)) D
 ..S ACRDOCDA=D0
 ..D:$P(^ACROBL(D0,"APV"),U,8)="" PPO1
 K ACRQUIT
 Q
PPO1 S ACRLBDA=","_$P(^ACRDOC(D0,0),U,6)_","
 Q:$P(^ACRDOC(D0,0),U,4)'=11!(ACRFDNO(1)'[ACRLBDA)
 S ACRPPO1=""
 N DXS,DIP,DC,DN
 D ^ACRPTT2,LIST1
 I $Y#IOSL>19,$E(IOST,1,2)="C-" D PAUSE^ACRFWARN,PPH
 Q
PPH W @IOF
 W !,"APPROVED REQUESTS AWAITING FURTHER PROCESSING."
 W !!
 Q
EXIT ;EP;
 K ACRTXDA,ACRESIG,ACRCSI,ACRDAT,ACRX,ACRTXTYP,ACRJJ,ACRAPVT,ACRQUIT,ACRDA,ACR,ACRREF1,ACRMAX,ACRPA,ACRY,ACRAPDA,ACRLBDA,ACRNOW,ACRNUM,ACRORD,ACRSIG,ACRSIGG,ACRSIGP,ACRSIGZ,ACRSIGZZ,ACRFDNO(1),ACRXMY,ACRINDV,ACRAP,ACRATTCH
 K ^TMP("ACRDATE",$J),^TMP("ACRALT",$J),^TMP("ACRALTDT",$J),^TMP("ACRDATA",$J)
 Q
RESP ;EP;NOTIFITY INITIATOR THAT RESPONSE REQUIRED
 K ACRREQX
 N X,Y,Z,ACRREQ,J
 S X=0
 F  S X=$O(^ACRAPVS("ANXT",X)) Q:'X  D
 .W:$E($G(IOST),1,2)="C-" "."
 .S Y=0
 .F  S Y=$O(^ACRAPVS("ANXT",X,Y)) Q:'Y  D
 ..S Z=0
 ..F  S Z=$O(^ACRAPVS("ANXT",X,Y,Z)) Q:'Z  D
 ...S ACRDOCDA=+^ACRAPVS("ANXT",X,Y,Z)
 ...I $E($G(^ACRDOC(ACRDOCDA,"DT")),1,3)="1^0","^33^35^"[(U_$P($G(^(0)),U,13)_U) D
 ....S ACRREQ=U_$P($G(^ACRDOC(ACRDOCDA,"REQ")),U,12)_U_$P($G(^ACRDOC(ACRDOCDA,"REQ2")),U,8)_U_$P($G(^ACROBL(ACRDOCDA,0)),U,5)_U
 ....Q:ACRREQ'[(U_DUZ_U)
 ....S ACRREQX($P(^ACRDOC(ACRDOCDA,0),U,6),ACRDOCDA)=""
 Q:'$D(ACRREQX)
 W *7,*7
 W !!?5,"The following document(s) were returned for change or clarification."
 W !?5,"You must respond before they can be signed and processed further."
 W !?5,"Under 'USER MENU' use 'ER' (Edit Pending Request).  Select the"
 W !?5,"Department Account, make the requested changes AND send the"
 W !?5,"REQUIRED response."
 W !!?5,"ID NO."
 W ?13,"Department Account"
 W !?5,"------"
 W ?13,"--------------------"
 S X=0
 F  S X=$O(ACRREQX(X)) Q:'X  I $D(^ACRLOCB(X,0)) S Z=^(0) D
 .W !?5,X
 .W ?13,$P($G(^AUTTPRG(+$P(Z,U,5),0)),U)
 .W !!?13,"ID NO."
 .W ?21,"DOCUMENT"
 .W ?58,"IDENTIFIER"
 .W !?13,"------"
 .W ?21,"------------------------------"
 .W ?58,"---------------"
 .S Y=0
 .F  S Y=$O(ACRREQX(X,Y)) Q:'Y  I $D(^ACRDOC(Y,0)) S J=^(0) D
 ..W !?13,Y
 ..W ?21,$P(J,U)
 ..W ?$X+2,"(",$P(J,U,2),")"
 ..W ?58,$P(J,U,14)
 D PAUSE^ACRFWARN
 Q
ATTACH ;EP;DISPLAY ATTACHMENT MESSAGE
EDIT K ACRRR
 S ACRATTCH=$G(^ACRDOC(ACRDOCDA,3))
 S ACRATTCH=$P(ACRATTCH,U,9)
 I 'ACRATTCH D  Q
 .W !!,"There are NO attachments for this document"
 .D PAUSE^ACRFWARN
 .K ACRATTCH
 N X
 S X=ACRATTCH
 W !!,*7,*7,"There ",$S(X>1:"are ",1:"is "),ACRATTCH," physical attachment",$S(X>1:"s",1:"")," which pertain",$S(X>1:"",1:"s")
 W " to this request."
 W !,"Please find and review ",$S(X>1:"them",1:"it")," if ",$S(X>1:"they",1:"it")," affect",$S(X>1:"",1:"s")," your approval of this request."
 I $D(^ACRDOC(ACRDOCDA,10,0)),$P(^(0),U,3)>0 D
 .W !!,"Th",$S(X>1:"ese",1:"is")," attachment",$S(X>1:"s",1:""),$S(X>1:" are",1:" is")," described as follows:"
 .W !,"--------------------------------------------------------------------------------"
 .N X,J
 .S X=0
 .F J=1:1 S X=$O(^ACRDOC(ACRDOCDA,10,X)) Q:'X  I $D(^ACRDOC(ACRDOCDA,10,X,0)) D
 ..W !,^ACRDOC(ACRDOCDA,10,X,0)
 ..I J#15=0 D
 ...S ACRX=X
 ...D PAUSE^ACRFWARN
 ...S X=ACRX
 Q