ABMUVCSH ; IHS/SD/SDR - 3PB/UFMS View Cashiering Session Option   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ; New routine - v2.5 p12 SDD item 4.9.2.2
 ;
 ; IHS/SD/SDR - v2.5 p13 - NO IM
 ;
 ; View Cashiering Session
EP ;EP
 D HEADER("OPEN")
 D FINDAOPN^ABMUCUTL
 S ABMTRIBL=$P($G(^ABMDPARM(DUZ(2),1,4)),U,14)
 I '$D(ABMO) W !?5,"There are NO open sessions at this time"
 D VIEWLIST
 K DIR,X,Y
 W !!
 I $D(ABMO) D
 .S DIR(0)="NO^1:"_ABMSCNT
 .S DIR("A")="Select Session Number to View: "
 .D ^DIR K DIR
 S ABMSESSL=+$G(Y)
 I ABMSESSL'=0 D DISPLAY("opened")  ;open session selected for view
 I +$G(ABMSESSL)=0  D  ;no open session selected; what about closed?
 .W !!
 .W !?1,"Other session statuses available for viewing"
 .W !?1,"Enter list of session statuses to view or ""^"" to quit."
 .W !!?4,"C - CLOSED"
 .I $P($G(^ABMDPARM(DUZ(2),1,4)),U,14)=0 W !?4,"R - RECONCILED"
 .I $P($G(^ABMDPARM(DUZ(2),1,4)),U,14)=1 W !?4,"T - TRANSMITTED"
 .W !?4,"B - BOTH",!
 .S DIR(0)="FO^0:3"
 .S DIR("A")="Session statuses to view"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABMBAD=0
 .I Y="B"!(Y="b") S Y=$S($P($G(^ABMDPARM(DUZ(2),1,4)),U,14)=0:"CR",1:"CT")
 .S ABMSESSL=Y
 .F I=1:1:$L(Y) I ABMSESSL'[$E(Y,I) D  Q
 ..W !!,"<<BAD ENTRY>> ",Y
 ..S ABMBAD=1
 .Q:+ABMBAD
 .;
 .W !!
 .D HEADER("CLOSED")
 .D FINDACLS^ABMUCUTL
 .I '$D(ABMO) W !?5,"There are NO sessions with a status of "_$S(ABMSESSL["RT":"RECONCILED and TRANSMITTED",ABMSESSL="R":"RECONCILED",1:"TRANSMITTED")_"at this time" S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR Q
 .D VIEWLIST
 .W !!
 .K DIR
 .S DIR(0)="NO^1:"_ABMSCNT
 .S DIR("A")="Select Session Number to View: "
 .D ^DIR K DIR
 .S ABMSESSL=+Y
 .I ABMSESSL'=0 D DISPLAY("closed")  ;closed session selected for view
 Q
HEADER(ABMFLG) ;EP
 W !!,"The following SESSIONS are currently "_ABMFLG_" =>"
 W !!?3,"(*)  Indicates no activity in session."
 W !!?6,"SESSION ID",?19,"CASHIER",?47,"DATE "_$S(ABMFLG="OPEN":"OPENED",1:ABMFLG)
 I ABMFLG["CLOSE" W ?68,"STATUS"
 W !
 S $P(ABMLINE,"-",80)=""
 W ABMLINE
 Q
VIEWLIST ;EP
 S X1=DT
 S X2="-"_$P($G(^ABMDPARM(DUZ(2),1,4)),U,16)  ;display number of days limit
 D C^%DTC
 S ABMDLIMT=X
 S ABMS=0,ABMSCNT=0
 F  S ABMS=$O(ABMO(ABMS)) Q:+ABMS=0  D
 .S ABMSDUZ=""
 .F  S ABMSDUZ=$O(ABMO(ABMS,ABMSDUZ)) Q:ABMSDUZ=""  D
 ..;not supervisor; they can only view their own sessions
 ..I '$D(^XUSEC("ABMDZ UFMS SUPERVISOR",DUZ)),(ABMSDUZ'=DUZ) K ABMO(ABMS,ABMSDUZ) Q
 ..S ABMSDT=0
 ..F  S ABMSDT=$O(ABMO(ABMS,ABMSDUZ,ABMSDT)) Q:+ABMSDT=0  D
 ...Q:ABMSDT<ABMDLIMT
 ...I $G(ABMSESSL)'="",(ABMSESSL'[$P($G(ABMO(ABMS,ABMSDUZ,ABMSDT)),U)) Q  ;status selected and not part of selection
 ...S ABMSCNT=ABMSCNT+1
 ...W !,ABMSCNT_"."
 ...W ?4,ABMSDT
 ...W ?19,$S(+ABMSDUZ'=0:$E($P($G(^VA(200,ABMSDUZ,0)),U),1,26),1:"POS CLAIMS")
 ...W ?47,$$CDT^ABMDUTL($S($P($G(ABMO(ABMS,ABMSDUZ,ABMSDT)),U,2)'="":$P($G(ABMO(ABMS,ABMSDUZ,ABMSDT)),U,2),1:ABMSDT))
 ...I $P(ABMO(ABMS,ABMSDUZ,ABMSDT),U)'="" D
 ....S ABMST=$P($G(ABMO(ABMS,ABMSDUZ,ABMSDT)),U)
 ....W ?68,$S(ABMST="O":"OPEN",ABMST="C":"CLOSED",ABMST="R":"RECONCILED",1:"TRANSMITTED")
 ...S ABMOS(ABMSCNT)=ABMS_"^"_ABMSDUZ_"^"_ABMSDT_"^"_$G(ABMO(ABMS,ABMSDUZ,ABMSDT))
 ...I +ABMSDUZ'=0,(+$P($G(ABMO(ABMS,ABMSDUZ,ABMSDT)),U,3)=0) W ?79,"*"  ;session doesn't have activity
 Q
DISPLAY(ABMFLG) ;EP
 W $$EN^ABMVDF("IOF")
 S ABMLREC=$G(ABMOS(ABMSESSL))
 S ABMS=$P(ABMLREC,U)
 S ABMSDUZ=$P(ABMLREC,U,2)
 S ABMSDT=$P(ABMLREC,U,3)
 W !,"Session detail for Session ID: "_ABMSDT
 W ?48,"Date ",ABMFLG,": ",$$CDT^ABMDUTL(ABMSDT)
 W !,"Cashier: ",$S(+ABMSDUZ'=0:$P($G(^VA(200,ABMSDUZ,0)),U),1:"POS CLAIMS")
 W !,ABMLINE
 S ABMFD=ABMSDT
 D:+ABMSDUZ CASHTOT^ABMUCASH(ABMSDUZ)
 D:'ABMSDUZ CASHTOTP^ABMUCASH
 S ABMBA=""
 I '$D(ABMBAL)&(+ABMSDUZ) D  Q
 .W !?5,"AT THIS TIME THERE IS NO BILLING ACTIVITY FOR THIS SESSION.",!
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 F  S ABMBA=$O(ABMBAL(ABMBA)) Q:ABMBA=""  D
 .W !?5,$P($T(@ABMBA^ABMUCASH),";;",2)
 .W !?15,"- Cancelled Claims",?40,+$G(ABMBAL(ABMBA,"CCLMS"))
 .W !?15,"- Approved Bills",?40,+$G(ABMBAL(ABMBA,"ABILLS")),?50,"$",$J($FN(+$G(ABMBAL(ABMBA,"ABAMT")),",",2),10)
 .I +$G(ABMBAL(ABMBA,"EBILLS"))>0 D
 ..W " "
 ..W $$EN^ABMVDF("RVN")_"(EXCL. ",ABMBAL(ABMBA,"EBILLS")
 ..W $$EN^ABMVDF("RVN")_" @ "_$FN(+$G(ABMBAL(ABMBA,"EBAMT")),",",2)_")"
 ..W $$EN^ABMVDF("RVF")
 .W !?15,"- Cancelled Bills",?40,+$G(ABMBAL(ABMBA,"CBILLS")),?50,"$",$J($FN(+$G(ABMBAL(ABMBA,"CBAMT")),",",2),10)
 W !
 ;requeued bills/batches
 I +$G(ABMBLCNT)'=0 W !?3,ABMBLCNT_" "_$S(ABMBLCNT=1:"BILL has",1:"BILLS have")_" been requeued"
 I +$G(ABMBTCNT)'=0 W !?3,ABMBTCNT_" "_$S(ABMBTCNT=1:"EXPORT has",1:"EXPORTS have")_" been requeued"
 ;ben pts
 I +$P($G(^ABMUCASH(ABMLOC,10,ABMSDUZ,20,ABMFD,0)),U,11)'=0 D
 .S ABMBCNT=$P($G(^ABMUCASH(ABMLOC,10,ABMSDUZ,20,ABMFD,0)),U,11)
 .W !?3,"There is ",ABMBCNT," claims/bills for beneficiary patients in this session that will ",!?3,"not be included in the export.",!
 ;
 K DIR
 ;view detail of session?
 W !
 K DIR,X,Y
 S DIR("A")="View detail"
 S DIR(0)="Y"
 D ^DIR K DIR
 S ABMDUZ=ABMSDUZ
 I Y=1 D SEL^ABMUCASH
 S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q
