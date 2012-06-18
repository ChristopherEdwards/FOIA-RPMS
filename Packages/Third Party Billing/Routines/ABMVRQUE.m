ABMVRQUE ;IHS/SD/SDR - Routine to regenerate claims for Riverside ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ;Routine will loop through claims generated under Riverside
 ;putting the visits back into the ABILL cross reference and
 ;removing the .04 field (THIRD PARTY BILLED) from the visit
 ;file so they will regenerate.
 ;
 ;ASK for locations to get claims from; this will be used
 ;for the DUZ(2) of the 3P Claim global root
SITE K ABML
 K ^TMP($J)
 K DIC,DIE,DA,DR,X,Y
 F  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)!($D(ABML)&(Y<0))
 .S DIC="^AUTTLOC("
 .S DIC(0)="AEMQZ"
 .I $D(ABML) S DIC("A")="Select another site: "
 .E  S DIC("A")="Select site to requeue visits from: "
 .D ^DIC
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .Q:Y<0
 .I +Y>0 S ABML(+Y)=""
 W !
 ;
 ;ASK for date range; just as a safety precaution; it could
 ;be that the site had claims generating at the satellite at
 ;one point but doesn't anymore
FROMDT   ;
 K DIR,DIC,DIE,DA,X,Y
 S DIR("A")="Enter Encounter FROM date"
 S DIR(0)="D"
 D ^DIR
 Q:'Y
 Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABMFROM=+Y
TODT     ;
 K DIR,DIC,DIE,DA,X,Y
 S DIR("A")="Enter Encounter TO date"
 S DIR(0)="D"
 D ^DIR
 Q:'Y
 G:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT) FROMDT
 S ABMTO=+Y
 I ABMTO<ABMFROM W !!,"TO DATE CAN'T BE AFTER FROM DATE",! G FROMDT
 W !
 ;
DISP ; display selection made
 W !,"Ok, I will requeue visits for: "
 S ABMI=0
 F  S ABMI=$O(ABML(ABMI)) Q:+ABMI=0  D
 .W !,?5,$P($G(^AUTTLOC(ABMI,0)),U,2)
 W !,"for date range ",$$SDT^ABMDUTL(ABMFROM)," thru ",$$SDT^ABMDUTL(ABMTO)
 ;
PAUSE ;
 W !!,"I am now going to loop through and requeue the requested visits"
 W !,"and dump the visit info to the screen."
 W !!,"PLEASE turn on screen capture to record the visit info."
 K DIR,DIC,DIE,X,Y,DA
 W ! S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;
LOOP ;loop thru claims and requeue
 W !,"VISIT IEN",?13,"HRN",?20,"S.CAT",?28,"ADMIT DT/TM",?45,"CLN",?65,"LOC",?74,"REVW'D"
 S ABMI=0
 K ABMALST
 F  S ABMI=$O(ABML(ABMI)) Q:+ABMI=0  D
 .S ABMFDT=ABMFROM-.5
 .F  S ABMFDT=$O(^ABMDCLM(ABMI,"AD",ABMFDT)) Q:+ABMFDT=0!(ABMFDT>ABMTO)  D
 ..S ABMP("CDFN")=0
 ..F  S ABMP("CDFN")=$O(^ABMDCLM(ABMI,"AD",ABMFDT,ABMP("CDFN"))) Q:+ABMP("CDFN")=0  D
 ...S ABMP("VDFN")=0
 ...F  S ABMP("VDFN")=$O(^ABMDCLM(ABMI,ABMP("CDFN"),11,ABMP("VDFN"))) Q:+ABMP("VDFN")=0  D
 ....Q:$D(^TMP($J,ABMP("VDFN")))  ;visit already requeued
 ....;
 ....I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),65)) D
 .....S D1=0
 .....F  S D1=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),65,D1)) Q:'D1  D
 ......I +^ABMDCLM(DUZ(2),ABMP("CDFN"),65,D1,0) S ABMALST(ABMP("CDFN"))=""
 .....K D1
 ....Q:$D(ABMALST(ABMP("CDFN")))  ;an active bill was found; don't cancel
 ....I '$D(ABMALST(ABMP("CDFN"))) D ENT
 ....;
 ....;remove THIRD PARTY BILLED from Visit
 ....K DIC,DIE,DA,DR,X,Y
 ....S DIE="^AUPNVSIT("
 ....S DA=ABMP("VDFN")
 ....S DR=".04////@"
 ....D ^DIE
 ....S ABMDTC=$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U,2)
 ....S ^AUPNVSIT("ABILL",ABMDTC,ABMP("VDFN"))=""     ;Set ABILL X-ref
 ....S ABMP("PDFN")=$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U,5)
 ....S ABMSCAT=$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U,7)
 ....S ABMADTTM=$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U)
 ....S ABMPCLN=$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U,8)
 ....S ABMCSTAT=$P($G(^AUPNVSIT(ABMP("VDFN"),11)),U,11)
 ....S ABMP("LDFN")=$P($G(^AUPNVSIT(ABMP("VDFN"),0)),U,6)
 ....W !,ABMP("VDFN"),?13,$$HRN^ABMUTL8(ABMP("PDFN")),?22,ABMSCAT
 ....W ?26,$$CDT^ABMDUTL(ABMADTTM)
 ....W:+ABMPCLN'=0 ?43,$E($P($G(^DIC(40.7,ABMPCLN,0)),U),1,17)
 ....W ?62,$E($P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2),1,11)
 ....W ?77,ABMCSTAT
 ....S ^TMP($J,ABMP("VDFN"))=""
 Q:'$D(ABMALST)  ;no active bills were found
 W !!,"ACTIVE BILLS WERE FOUND FOR THE FOLLOWING CLAIMS SO THEY WERE NOT REQUEUED"
 S ABMI=0
 F  S ABMI=$O(ABMALST(ABMI)) Q:+ABMI=0  D
 .W !,ABMI
XIT ;
 Q
 ;
ENT ;EP - to Cancel a Claim
 W !
 S DIE="^ABMCCLMS(DUZ(2),"
 S DA=ABMP("CDFN")
 S DIE("NO^")="OUTOK"
 S DR=".04////X;.114////"_DUZ_";.115///NOW;.118////11"  ;put OTHER for cancel reason
 D ^DIE
 I $P($G(^ABMCCLMS(DUZ(2),ABMP("CDFN"),1)),U,8)="" D  Q  ;cancellation reason
 .S DIK="^ABMCCLMS(DUZ(2),"
 .S DA=ABMP("CDFN")
 .D ^DIK
 M ^ABMCCLMS(DUZ(2),ABMP("CDFN"),0)=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 M ^ABMCCLMS(DUZ(2),ABMP("CDFN"),11)=^ABMDCLM(DUZ(2),ABMP("CDFN"),11)  ;PCC Visits
 M ^ABMCCLMS(DUZ(2),ABMP("CDFN"),41)=^ABMDCLM(DUZ(2),ABMP("CDFN"),41)  ;Providers
 S DIK="^ABMCCLMS(DUZ(2),"
 S DA=ABMP("CDFN")
 D IX^DIK  ;merged entries don't x-ref
 S DR=".04///1" D KCLM
 S ^ABMDTMP("KCLM",DT,ABMP("CDFN"))=DUZ
 K ^TMP($J)
 Q
 ;
KCLM ;EP for Deleting Claim
 S DIK="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 D ^ABMDEDIK
 Q
