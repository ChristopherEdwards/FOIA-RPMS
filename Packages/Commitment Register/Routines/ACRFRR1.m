ACRFRR1 ;IHS/OIRM/DSD/THL,AEF - DISPLAY AND EDIT RECEIVING REPORT OR INVOICE AUDIT;  [ 07/20/2006  9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**20**;NOV 05, 2001
 ;;CONTINUATION OF ACRFRR
EN Q:$D(ACRQUIT)!$D(ACROUT)
 K ACRRRNO,ACRRRNOX
 S ACRDOC=$S($P(ACRDOC0,U,2)]"":$P(ACRDOC0,U,2),1:$P(ACRDOC0,U))
 S ACRLBDA=$P(ACRDOC0,U,6)
 S ACRRDATE=$P(ACRDOCPO,U,12)
 I $D(ACRIV)#2 D  Q:$D(ACRQUIT)!$D(ACROUT)
 .D RR^ACRFIV:'+$G(ACRRRNOX)
 .S ACRVDA=$P($G(^ACRDOC(ACRDOCDA,5)),U,5)
 .I 'ACRVDA S ACRQUIT="" Q
 .D EDIT^ACRFIVD
 Q:$D(ACROUT)
 F  D EN1 Q:$D(ACRQUIT)!$D(ACROUT)
 S ACRSSDA=0
 S ACRP=$S($D(ACRRR)#2:6,1:19)
 I $D(ACRFINAL) D  I 1
 .S ACRFINAL=0
 .F  S ACRSSDA=$O(^ACRSS("J",ACRDOCDA,ACRSSDA)) Q:'ACRSSDA  D
 ..S:$P(^ACRSS(ACRSSDA,"DT"),U,ACRP)]"" ACRFINAL=1
 E  S ACRFINAL=0
 K ACRP
 I '$D(ACRIV)#2,$D(^ACRSS("J",ACRDOCDA))&ACRFINAL D FP^ACRFRR11
 I '$D(ACRRR)#2,$D(^TMP("ACRSYNC",$J)) D FP^ACRFRR11
 I $D(ACRRR)#2,$D(ACRSSTOT),$P(^ACROBL(ACRDOCDA,0),U)'=ACRSSTOT D EX
EXIT K ACRX,ACRSS,ACRSSDT,ACRQUIT,ACRRDATE,ACRSSACP,ACRSSITP,ACRSSREC,ACRSSTP,ACRPVN
 Q
EN1 I $D(ACRIV)#2 D ^ACRFIV5 Q
 D DISPLAY
 D EORA^ACRFRR3:'$D(ACRQUIT)
 Q
EX S DA=ACRDOCDA
 S DIE="^ACROBL("
 S DR=".01///"_ACRSSTOT
 D DIE^ACRFDIC
 Q
TRX S DA=$O(^ACRTRX("AC",ACRDOCDA,ACRFINAL,""))
 I DA]"" D  G TRX1
 .S DA=$O(^ACRTRX("AC",ACRDOCDA,"F",""))
 .S DIE="^ACRTRX("
 .S DR="10////"_ACRSSTP
 .D DIE^ACRFDIC
 I DA="" D
 .S X=ACRFINAL
 .S DIC="^ACRTRX("
 .S DIC(0)="L"
 .S DIC("DR")=".02////"_ACRDOCDA_";.03////"_ACRDOCDA_";.04////"_ACRLBDA_";1////"_DT_";2////"_DT_";3////"_DUZ_";10////"_ACRSSTP
 .D FILE^ACRFDIC
TRX1 S DA=ACRDOCDA
 S DIE="^ACROBL("
 S DR="2////"_ACRSSTP_";909////1"
 D DIE^ACRFDIC
 Q
DISPLAY ;EP;
 K ACRSS
 D HEAD
 S (ACRSSDA,ACRSSTOT,ACRSSTP,ACRIVTP,ACRSSMAX,ACRJ)=0
 F  S ACRSSDA=$O(^ACRSS("J",ACRDOCDA,ACRSSDA)) Q:'ACRSSDA  D
 .S ACRSSMAX=ACRSSMAX+1
 .D D2
 S ACRJ=0
 F  S ACRJ=$O(ACRSS(ACRJ)) Q:'ACRJ!$D(ACRQUIT)  D DISP
 K ACRQUIT,ACROUT
 I ACRSSMAX<1 D  Q
 .W !?4,"NO ITEMS ON FILE FOR THIS PROCUREMENT"
 .S ACRQUIT=""
 .H 2
 I ACRSSMAX>0 D
 .W !?48,"-------------"
 .W:$D(ACRIV)#2 ?62,"-------------"
 .W !?38,"TOTAL"
 .W ?48,$J($FN(ACRSSTOT,"P",2),13)
 .W:$D(ACRIV)#2 ?62,$J($FN(ACRSSTP,"P",2),13)
 I $D(ACRIV)#2,ACRIVTP>0 D
 .W ?76,$J($P(ACRIVTP-ACRSSTP,"."),4)
 .W !?29,"TOTAL INVOICED:"
 .W ?62,$J($FN(ACRIVTP,"P",2),13)
 .W:ACRSSTP>0 ?76,$J($P(ACRIVTP/(ACRSSTP*100)-100,"."),4)
 Q
DISP D D1
 W !,$J(ACRJ,3)
 I $P(ACRSSNMS,U)]"" D
 .W ?4,"VON: ",$P(ACRSSNMS,U)
 .W !?3
 I $P(ACRSSNMS,U,3)]"" D
 .W ?4,"NDC: ",$P(ACRSSNMS,U,3)
 .W !?3
 I $P(ACRSSNMS,U,2)]"" D
 .W ?4,"NSN: ",$P(ACRSSNMS,U,2)
 .W !?3
 W ?4,$P(ACRSSDSC,U)
 N ACRJ,ACRI,ACRX
 F ACRJ=2:1:5 I $P(ACRSSDSC,U,ACRJ)]"" S ACRX=$P(ACRSSDSC,U,ACRJ) D
 .F ACRI=1:1 S ACRY=$P(ACRX," ",ACRI) Q:ACRY=""  D
 .W:$X+$L(ACRY)>79 !?3
 .W ?$X+1,ACRY
 W:ACRNOTES]"" !
 F ACRJ=1:1:5 I $P(ACRNOTES,U,ACRJ)]"" S ACRX=$P(ACRNOTES,U,ACRJ) D
 .F ACRI=1:1 S ACRY=$P(ACRX," ",ACRI) Q:ACRY=""  D
 .W:$X+$L(ACRY)>79 !?3
 .W ?$X+1,ACRY
 K ACRSSDSC,ACRNOTES
 W !?22,$J(ACRSSORD,6)
 W ?29,$J(ACRSSACP,6)
 W ?36,$J($FN(ACRSSUP,"P",2),12)
 W ?48,$J($FN(ACRSSIT,"P",2),13)
 W:$D(ACRIV)#2 ?62,$J($FN(ACRSSITP,"P",2),13)
 W:$D(ACRRR)#2 ?62,$J($FN(ACRSSACP*ACRSSUP,"P",2),13)
 I $D(ACRIV)#2 D
 .W:ACRIVT>0 ?76,$J($P(ACRIVT-ACRSSITP,"."),4)
 .I ACRIVACP]"" D
 ..W !?13,"INVOICED:"
 ..W ?29,$J(ACRIVACP,6)
 ..W ?36,$J($FN(ACRIVUP,"P",2),12)
 ..W ?62,$J($FN(ACRIVT,"P",2),13)
 .W:ACRSSITP>0 ?76,$J($P(ACRIVT/ACRSSITP*100-100,"."),4)
 I IOSL-4<$Y D
 .S DIR(0)="YO"
 .S DIR("A")="Display Remaining Items"
 .S DIR("B")="YES"
 .W !
 .D DIR^ACRFDIC
 .I Y'=1 S ACRQUIT="" Q
 .D HEAD
 Q
HEAD W @IOF
 W !?10,@ACRON,"SERVICES/SUPPLIES",@ACROF," RECEIVED FOR"
 W !?10,"PURCHASE ORDER NO.: ",@ACRON,$S($P(ACRDOC0,U,2)]"":$P(ACRDOC0,U,2),1:$P(ACRDOC0,U)),@ACROF
 W:$D(ACRIV)#2 !?76,"VARI"
 W !?22,"ORD-"
 W ?29,"ACC-"
 W ?48,"ORDERED"
 I $D(ACRIV)#2 D
 .W ?62,"RECOMDED"
 .W ?76,"ANCE"
 W:$D(ACRRR)#2 ?62,"ESTIMATED"
 W !,"ITM"
 W ?4,"ORDER #/DESCRIPT"
 W ?22,"ERED"
 W ?29,"EPTED"
 W ?36,"UNIT PRICE"
 W ?48,"AMOUNT"
 I $D(ACRIV)#2 D
 .W ?62,"PAYMENT"
 .W ?76,"$$/%"
 W:$D(ACRRR)#2 ?62,"COST"
 W !,"---"
 W ?4,"-----------------"
 W ?22,"------"
 W ?29,"------"
 W ?36,"-----------"
 W ?48,"-------------"
 I $D(ACRIV)#2 D
 .W ?62,"-------------"
 .W ?76,"----"
 W:$D(ACRRR)#2 ?62,"-------------"
 Q
D1 S ACRSSDA=ACRSS(ACRJ)
 S ACRSSDT=^ACRSS(ACRSSDA,"DT")
 S ACRSSNMS=$G(^ACRSS(ACRSSDA,"NMS"))
 S ACRSSDSC=$G(^ACRSS(ACRSSDA,"DESC"))
 S ACRNOTES=$G(^ACRSS(ACRSSDA,"NOTES"))
 S ACRSSORD=$P(ACRSSDT,U)
 S ACRSSREC=$P(ACRSSDT,U,5)
 S ACRSSACP=$P(ACRSSDT,U,6)
 S ACRSSIT=$P(ACRSSDT,U,4)
 S ACRSSITP=$P(ACRSSDT,U,7)
 S ACRSSUP=$P(ACRSSDT,U,3)
 S ACRIVACP=$P(ACRSSDT,U,19)
 S ACRIVUP=$P(ACRSSDT,U,20)
 Q
D2 S ACRJ=ACRJ+1
 S ACRSS0=^ACRSS(ACRSSDA,0)
 I +ACRSS0'=ACRJ D
 .S DA=ACRSSDA
 .S DIE="^ACRSS("
 .S DR=".01///^S X=ACRJ"
 .D DIE^ACRFDIC
 .S $P(ACRSS0,U)=ACRJ
 S ACRSSDT=^ACRSS(ACRSSDA,"DT")
 S ACRSS(+ACRSS0)=ACRSSDA
 S ACRSSIT=$P(ACRSSDT,U,4)
 S ACRSSITP=$P(ACRSSDT,U,7)
 S ACRSSTOT=ACRSSTOT+ACRSSIT
 S ACRSSTP=ACRSSTP+ACRSSITP
 S ACRIVT=$P(ACRSSDT,U,21)
 S ACRIVTP=ACRIVTP+ACRIVT
 Q
VHEAD ;EP;PRINT VENDOR DATA
 S D0=$S($P($G(^ACRDOC(+$G(ACRDOCDA),5)),U,5):$P(^(5),U,5),$D(^ACRDOC(+$G(ACRDOCDA),"PO")):$P(^("PO"),U,5),$G(ACRVDA):ACRVDA,1:"")
 Q:'D0
 N DXS,DIP,DC,DN
 W @IOF
 I $G(ACRDOCDA),D0'=$P($G(^ACRDOC(ACRDOCDA,"PO")),U,5) W !?9,"VENDOR: ",$P($G(^AUTTVNDR(+$P($G(^("PO")),U,5),0)),U)
 W !?9,"PAYEE.:"
 W !?9,"------------------------------"
 W !
 D ^ACRPVND
 Q
VCHANGE ;EP;SELECT PAYEE
 I $D(ACRCC) D  Q
 .W !!,"THE DEFAULT CREDIT CARD VENDOR DATA CAN ONLY BE CHANGED THROUGH "
 .W !,"THE ADD/EDIT VENDOR (EV) OPTION ON THE MAIN ARMS MENU"
 .W !!,"NOTE:  DO NOT CHANGE VENDOR ON THE REQUISITION WHEN "
 .W "MAKING A CREDIT CARD PAYMENT",!
 .D PAUSE^ACRFWARN
 .S ACRQUIT=1
 W !!,"WARNING:  If any VENDOR DATA other than the REMIT TO ADDRESS information"
 W !,"needs to be changed, consult with someone who has access to change"
 W !,"ALL VENDOR DATA before you record this payment.",!
 ;S ACRVDA=$S($P($G(^ACRDOC(ACRDOCDA,5)),U,5):$P(^(5),U,5),$D(^("PO")):$P(^("PO"),U,5),1:"")  ;ACR*2.1*20.07  IM17200
 S ACRDOCDA=+$G(ACRDOCDA)                         ;ACR*2.1*20.07  IM17200
 I '$G(ACRVDA) D                                  ;ACR*2.1*20.07  IM17200
 .S ACRVDA=$P($G(^ACRDOC(ACRDOCDA,5)),U,5)        ;ACR*2.1*20.07  IM17200
 .S:ACRVDA="" ACRVDA=$P($G(^ACRDOC(ACRDOCDA,"PO")),U,5)  ;ACR*2.1*20.07  IM17200
 S DIC="^AUTTVNDR("
 S DIC(0)="AEMQZ"
 S DIC("A")="PAYEE...............: "
 ;S DIC("B")=$P($G(^AUTTVNDR(ACRVDA,0)),U)        ;ACR*2.1*20.07  IM17200
 S:ACRVDA]"" DIC("B")=$P($G(^AUTTVNDR(ACRVDA,0)),U)  ;ACR*2.1*20.07  IM17200
 W !
 D DIC^ACRFDIC
 Q:$D(ACRQUIT)
 I +Y>0 S ACRVDA=+Y
 I +Y<1 D
 .S DIR(0)="YO"
 .S DIR("A",1)="No PAYEE was selected."
 .S DIR("A")="Leave the PAYEE the same as the current VENDOR"
 .S DIR("B")="YES"
 .W !
 .D DIR^ACRFDIC
 .Q:Y=1!$D(ACRQUIT)
 .G VCHANGE
 S DA=ACRDOCDA
 S DIE="^ACRDOC("
 S DR="103950////"_ACRVDA
 D DIE^ACRFDIC
 Q