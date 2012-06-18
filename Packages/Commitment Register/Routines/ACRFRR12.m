ACRFRR12 ;IHS/OIRM/DSD/THL,AEF - DISPALY AND EDIT RECEIVING REPORT/INVOICE AUDIT - CON'T;  [ 07/20/2006   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**20**;NOV 05, 2001
 ;;CONTINUATION OF ACRFRR11
PVN ;EP;
 K ACRQUIT
 N X,Y,Z
 S X=0
 F  S X=$O(^ACRRR("AC",ACRDOCDA,ACRRRNO,X)) Q:'X!$D(ACRQUIT)!$D(ACROUT)  D
 .S Z=$O(^ACRRR("AC",ACRDOCDA,ACRRRNO,X,0))
 .Q:'Z
 .Q:'$D(^ACRRR(Z,0))  Q:$P(^(0),U,13)]""  S Y=+^(0)
 .S Y=$P($G(^ACRSS(Y,0)),U,4)
 .I $D(^AUTTOBJC(+Y,0)),$E($P(^(0),U),1,2)="26" S ACRQUIT=""
 Q:'$D(ACRQUIT)
 K ACRQUIT
 S ACRFY=$S($E(DT,4,5)<10:$E(DT,1,3)+1700,1:($E(DT,1,3)+1)+1700)
PVNMON S DIR(0)="N^1:12"
 S DIR("A")="Enter Property Voucher Number MONTH"
 S DIR("B")=+$E(DT,4,5)
 W !
 D DIR^ACRFDIC
 I '+Y D  G PVNMON
 .W !!,"You are required to enter the MONTH for this Property Voucher Number."
 .W !,"You cannot exit without entering the MONTH which will be used for this"
 .W !,"Property Voucher Number."
 S ACRMONTH=+Y
 S ACRLCDA=$P(^ACRLOCB(ACRLBDA,"DT"),U,11)
 ;Begin old code                       ;ACR*2.1*20.05  IM17144
 ;D PVNCHK^ACRFPVN                     ;ACR*2.1*20.05  IM17144
 ;Begin new code                       ;ACR*2.1*20.05  IM17144
 S ACRPVN=$$PVNCHK^ACRFPVN(ACRLCDA,ACRFY,ACRMONTH,.ACRPVN)  ;ACR*2.1*20.05  IM17144
 ;End new code                         ;ACR*2.1*20.05  IM17144
 W !!,"Property Voucher Number ",ACRPVN," (with correct sequence) will be assigned."
 K ACRPVN
 S DIR(0)="YO"
 S DIR("A")="Is this correct"
 S DIR("B")="YES"
 W !
 D DIR^ACRFDIC
 I +Y'=1 G PVNMON
 D SET^ACRFPVN
 S X=ACRPVN
 S DA(1)=ACRDOCDA
 S DIC="^ACRDOC("_DA(1)_",8,"
 S DIC(0)="L"
 S:'$D(^ACRDOC(ACRDOCDA,8,0))#2 ^ACRDOC(ACRDOCDA,8,0)="^9002196.801"
 D FILE^ACRFDIC
 Q
PVNPRINT ;EP;TO PRINT THE PROPERTY VOUCHER REPORT
 F  D PVNP Q:$D(ACRQUIT)!$D(ACROUT)
 K ACRQUIT,ACROUT
 Q
PVNP N ACRDC,ACRBEGIN,ACREND,ACRB,ACRE,ACRX,ACRLOC,ACRDOC0,ACRDOCDA,ACRLOCX,ACRXX,ACRRTN,ACRJ,ACRTOT
 W @IOF
 W !?10,"Enter the beginning and ending dates for this"
 W !?10,"Property Voucher Register Report",!!
 D DATES^ACRFDATE
 I '$G(ACRBEGIN) S ACRQUIT="" Q
 S ACRBEGIN=($E(ACRBEGIN,1,3)+1700)_"-"_$E(ACRBEGIN,4,5)
 S ACRB=$TR(ACRBEGIN,"-","")
 S ACREND=($E(ACREND,1,3)+1700)_"-"_$E(ACREND,4,5)
 S ACRE=$TR(ACREND,"-","")
 S DIR(0)="YO"
 S DIR("A")="Print the Report for ALL Locations"
 S DIR("B")="YES"
 W !
 D DIR^ACRFDIC
 Q:$D(ACRQUIT)!$D(ACROUT)
 I +Y=1 S ACRLOC="000"
 I '$D(ACRLOC) D
 .S DIC="^AUTTLCOD("
 .S DIC(0)="AEMZQ"
 .S DIC("A")="Which LOCATION CODE: "
 .D DIC^ACRFDIC
 .Q:$D(ACRQUIT)!$D(ACROUT)!($G(Y)<1)
 .S ACRLOC=$P(^AUTTLCOD(+Y,0),U)
 Q:'$D(ACRLOC)
 D ZIS
 Q
ZIS ;SELECT DEVICE
 S (ZTRTN,ACRRTN)="P^ACRFRR12"
 S ZTDESC="Property Voucher Report"
 D ^ACRFZIS
 Q
P ;EP -- PRINT PROPERTY VOUCHER REPORT
 ;
 N ACRB,ACRDC,ACRDOC0,ACRDOCDA,ACRE,ACRFINAL,ACRJ,ACRLOCX,ACRRRDA,ACRRRDT,ACRTOT,ACRTYPE,ACRX,ACRZ,J,X,Y,Z
 K ^TMP("ACRPV",$J)
 S ACRLOCX=$S(ACRLOC="000":"ALL",1:ACRLOC)
 S ACRX=ACRLOC_"-0000-00-0000"
 D LOOP
 Q:'$D(^TMP("ACRPV",$J))
 D PRINT
 K ^TMP("ACRPV",$J)
 Q
LOOP ;----- LOOP THROUGH RECEIVING REPORTS AND GATHER DATA
 ;
 F  S ACRX=$O(^ACRRR("PVN",ACRX)) Q:ACRX=""!($G(ACRLOCX)'="ALL"&($E(ACRX,1,3)'=ACRLOC))  D
 . S ACRZ=$P(ACRX,"-",2)
 . I $L(ACRZ)=4 S ACRZ=$E(ACRZ,3,4)
 . S X=$P(ACRX,"-",3)_"01"_ACRZ
 . D ^%DT
 . S X=Y
 . S X=$E(Y,1,3)+1700_$E(Y,4,5)
 . S ACRB=$TR(ACRBEGIN,"-","")
 . S ACRE=$TR(ACREND,"-","")
 . Q:(X<ACRB)!(X>ACRE)
 . S (J,Y,Z)=0
 . S ACRRRDA=0
 . F  S ACRRRDA=$O(^ACRRR("PVN",ACRX,ACRRRDA)) Q:'ACRRRDA  D
 . . S X=$G(^ACRRR(ACRRRDA,0))
 . . S ACRDOCDA=$P(X,U,2)
 . . S ACRRRDT=$G(^ACRRR(ACRRRDA,"DT"))
 . . S ACRDOC0=^ACRDOC(ACRDOCDA,0)
 . . S J=J+1,ACRJ=$G(ACRJ)+1
 . . S Y=Y+($P($G(^ACRSS(+X,"DT")),U,3)*$P(ACRRRDT,U,3))
 . . S ACRFINAL=$P(X,U,8)
 . . S X=+X
 . . S Z=$P($G(^ACRSS(+X,0)),U,4)
 . . I $D(^AUTTOBJC(+Z,0)),$E($P(^(0),U),1,2)="26" S ACRTYPE=$P(^(0),U,8)
 . . S ACRTYPE=$S($G(ACRTYPE)="S":"SS",1:"DI")
 . . S ACRTOT=$G(ACRTOT)+$P($G(^ACRSS(X,"DT")),U,4)
 . S ^TMP("ACRPV",$J,"D",ACRX)=$S($P(ACRDOC0,U,2)="":$P(ACRDOC0,U),1:$P(ACRDOC0,U,2))_U_ACRTYPE_U_J_U_Y
 . S $P(^TMP("ACRPV",$J,"TOTAL",$E(ACRX,1,3)),U)=$P($G(^TMP("ACRPV",$J,"TOTAL",$E(ACRX,1,3))),U)+J
 . S $P(^TMP("ACRPV",$J,"TOTAL",$E(ACRX,1,3)),U,2)=$P($G(^TMP("ACRPV",$J,"TOTAL",$E(ACRX,1,3))),U,2)+Y
 . S $P(^TMP("ACRPV",$J,"ZGRANDTOTAL"),U)=$P($G(^TMP("ACRPV",$J,"ZGRANDTOTAL")),U)+J
 . S $P(^TMP("ACRPV",$J,"ZGRANDTOTAL"),U,2)=$P($G(^TMP("ACRPV",$J,"ZGRANDTOTAL")),U,2)+Y
 Q
PRINT ;----- PRINT THE REPORT
 ;
 N ACRDC,ACRPVN,ACRQUIT,ACRX,DATA
 S ACRPVN="" F  S ACRPVN=$O(^TMP("ACRPV",$J,"D",ACRPVN)) Q:ACRPVN']""  D  Q:$D(ACRQUIT)
 . I $G(ACRX)'=$E(ACRPVN,1,3) D  Q:$D(ACRQUIT)
 . . D PVNTOT
 . . Q:$D(ACRQUIT)
 . . D PHEAD
 . . S ACRX=$E(ACRPVN,1,3)
 . S DATA=^TMP("ACRPV",$J,"D",ACRPVN)
 . W !,ACRPVN
 . W ?16,"|",$P(DATA,U)
 . W ?31,"|",$J($P(DATA,U,2),3)
 . W ?37,"|",$J($P(DATA,U,3),6)
 . W ?45,"|",$J($FN($P(DATA,U,4),"P",2),13)
 . I $Y>($G(IOSL)-4) D PAUSE^ACRFWARN Q:$D(ACRQUIT)  D PHEAD
 Q:$D(ACRQUIT)
 D PVNTOT
 Q
PHEAD ;PVN REPORT HEADER
 W @IOF
 S ACRDC=$G(ACRDC)+1
 W !,"Property Voucher Register"
 W !,"Report Date: "
 S Y=DT
 X ^DD("DD")
 W Y
 W !,"Report From: ",ACRBEGIN
 W ?43,"Accounting Point: ",$P($G(^AUTTACPT(+$P($G(^ACRPO(1,0)),U,4),0)),U)
 W !,"Report To..: ",ACREND,?55,"Page: ",$G(ACRDC)
 W $$DASH^ACRFMENU
 W !,"VOUCHER",?16,"|PURCHASE ORDER",?31,"|",?37,"|# OF",?45,"|"
 W !,"SERIAL NO.",?16,"|NUMBER",?31,"|TYPE",?37,"|ITEMS",?45,"|VALUE"
PH W !,"----------------",?16,"|--------------",?31,"|-----",?37,"|-------",?45,"|------------"
 Q
PVNTOT ;----- WRITE TOTAL
 Q:$G(ACRX)=""
 S DATA=^TMP("ACRPV",$J,"TOTAL",ACRX)
 D PH
 W !?37,"|",$J($P(DATA,U),6)
 W ?45,"|",$J($FN($P(DATA,U,2),"P",2),13)
 D PAUSE^ACRFWARN
 Q
