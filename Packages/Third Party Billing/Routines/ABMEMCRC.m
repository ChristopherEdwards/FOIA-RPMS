ABMEMCRC ; IHS/SD/SDR - 3PB recreate batch of ICD9 bills   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p12 - New routine
 ;   Recreate batches for specified insurer that meet selection criteria
 ;
EP ;
 W !!,"This option will create a batch of claims that meet the following criteria:"
 W !?5,"* Bill type is 11* where * is any number"
 W !?5,"* The bill contains ICD Procedure codes"
 W !?5,"* Bill status is NOT cancelled"
 W !?5,"* 837I export mode only"
 W !
 W !,"You will be asked the following to complete the selection criteria:"
 W !?5,"* Insurer (multiple entries not allowed)"
 W !?5,"* Date range (either by approval, batch, or visit date)"
 W !?5,"* Resubmission note that will be put on ALL claims"
 W !
 S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;
INSURER D EN^ABMVDF("IOF")
 S DIC="^AUTNINS("
 S DIC(0)="AEMQ"
 D ^DIC
 Q:+Y<0
 I +Y>0 S ABMINS=+Y
 ;
WHATDT ;
 K DIR
 S DIR("A")="Apply range to"
 S DIR(0)="SO^A:APPROVAL DATE;B:BATCH DATE;V:VISIT DATE"
 D ^DIR
 G:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT) INSURER
 S ABMFILE=Y
 ;
FROMDT ;
 K DIR
 S DIR("A")="Enter FROM date"
 S DIR(0)="D"
 D ^DIR
 Q:'Y
 Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABMFROM=+Y
TODT ;
 K DIR
 S DIR("A")="Enter TO date"
 S DIR(0)="D"
 D ^DIR
 Q:'Y
 G:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT) FROMDT
 S ABMTO=+Y
 I ABMTO<ABMFROM W !!,"TO DATE CAN'T BE AFTER FROM DATE",! G FROMDT
 ;
RESUBN ;
 K DIR
 S DIR("A")="Resubmission note"
 S DIR(0)="F^3:80"
 D ^DIR
 G:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT) FROMDT
 S ABMRESUB=Y
 ;
MSG ;
 W !!,"Bills meeting the following criteria will be recreated in a new batch:"
 W !?5,"* Bill type is 11* where * is any number"
 W !?5,"* The bill contains ICD Procedure codes"
 W !?5,"* Bill status is NOT cancelled"
 W !?5,"* 837I export mode only"
 W !
 W !?5,"* Active insurer is ",$P($G(^AUTNINS(ABMINS,0)),U)
 W !?5,"* ",$S(ABMFILE="B":"Batches created",ABMFILE="V":"Visit dates",1:"Bills approved")
 W " between "_$$SDT^ABMDUTL(ABMFROM)_" and "_$$SDT^ABMDUTL(ABMTO)
 W !?5,"* With the resubmission note: ",ABMRESUB
 W !
 S DIR(0)="Y",DIR("A")="Do you wish to continue" D ^DIR K DIR
 Q:Y'=1
 I ABMFILE="A" D ALOOP
 I ABMFILE="B" D BLOOP
 I ABMFILE="V" D VLOOP
 D OUTPUT
 S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 D XIT
 Q
 ;
ALOOP ;
 K ABMB
 S ABMDT=ABMFROM-.5
 S ABMTO=ABMTO+1
 F  S ABMDT=$O(^ABMDBILL(DUZ(2),"AP",ABMDT)) Q:+ABMDT=0!(ABMDT>ABMTO)  D
 .S ABMBDFN=0
 .F  S ABMBDFN=$O(^ABMDBILL(DUZ(2),"AP",ABMDT,ABMBDFN)) Q:+ABMBDFN=0  D
 ..D BILLCK
 Q
BLOOP ;
 K ABMB
 S ABMDT=ABMFROM-.5
 S ABMTO=ABMTO+1
 F  S ABMDT=$O(^ABMDTXST(DUZ(2),"B",ABMDT)) Q:+ABMDT=0!(ABMDT>ABMTO)  D
 .S ABMTIEN=0
 .F  S ABMTIEN=$O(^ABMDTXST(DUZ(2),"B",ABMDT,ABMTIEN)) Q:+ABMTIEN=0  D
 ..Q:$P($G(^ABMDTXST(DUZ(2),ABMTIEN,1)),U,4)=""  ;EMC FILENAME
 ..S ABMBDFN=0
 ..F  S ABMBDFN=$O(^ABMDTXST(DUZ(2),ABMTIEN,2,ABMBDFN)) Q:+ABMBDFN=0  D
 ...D BILLCK
 Q
VLOOP ;
 K ABMB
 S ABMDT=ABMFROM-.5
 S ABMTO=ABMTO+1
 F  S ABMDT=$O(^ABMDBILL(DUZ(2),"AD",ABMDT)) Q:+ABMDT=0!(ABMDT>ABMTO)  D
 .S ABMBDFN=0
 .F  S ABMBDFN=$O(^ABMDBILL(DUZ(2),"AD",ABMDT,ABMBDFN)) Q:+ABMBDFN=0  D
 ..D BILLCK
 Q
BILLCK ;
 Q:($E($P($G(^ABMDBILL(DUZ(2),ABMBDFN,0)),U,2),1,2)'=11)  ;bill type
 Q:$P($G(^ABMDBILL(DUZ(2),ABMBDFN,0)),U,4)="X"  ;bill status-cancelled
 Q:$P($G(^ABMDBILL(DUZ(2),ABMBDFN,0)),U,8)'=ABMINS  ;insurer selected
 Q:'$D(^ABMDBILL(DUZ(2),ABMBDFN,19,0))  ;ICD procedures
 S ABMEXPM=$P($G(^ABMDBILL(DUZ(2),ABMBDFN,0)),U,6)  ;export mode
 Q:$G(ABMEXPM)'=21  ;837I only
 S ABMB(ABMEXPM,ABMBDFN)=""
 Q
OUTPUT ;
 S ABMINS("IEN")=ABMINS  ;Active Insurer IEN
 S ABMITYP=$P(^AUTNINS(ABMINS("IEN"),2),U)  ;Insurer type
 S ABMEXP=21  ;export type
 D NEWB    ; Create a new batch in 3P TX STATUS
 I $G(Y)<0 D MSG^ABMERUTL("Could not enter batch in 3P TX STATUS file.") Q
 ; Add bill to detail in 3P TX STATUS for this batch
 S ^ABMDTXST(DUZ(2),DA(1),2,0)="^9002274.61P^^"
 S ABMAPOK=1
 S ABMDA=0
 F  S ABMDA=$O(ABMB(21,ABMDA)) Q:+ABMDA=0  D
 .S X=ABMDA
 .S DIC="^ABMDTXST(DUZ(2),DA(1),2,"
 .S DIC(0)="LXNE"
 .S DINUM=X
 .K DD,DO D FILE^DICN
 .Q:+Y<0
 .S DA=+Y
 .S DIE="^ABMDTXST(DUZ(2),DA(1),2,"
 .S ABMAPRV=$O(^ABMDBILL(DUZ(2),ABMDA,41,"C","A",0))
 .S:ABMAPRV ABMAPRV=$P(^ABMDBILL(DUZ(2),ABMDA,41,ABMAPRV,0),U)
 .I ABMAPRV D
 ..S DR=".02///`"_ABMAPRV
 ..D ^DIE
 ..K ABMAPRV
 .S ABMSBR=$$SBR^ABMUTLP(ABMDA)
 .S DR=".03///"_ABMSBR
 .D ^DIE
 .K ABMSBR
 K ABMAPOK
 ; Write record  (Create EMC unix file)
 D ^ABMEF21
 I $G(POP) D
 .S DIE="^ABMDTXST(DUZ(2),"
 .S DA=ABMP("XMIT")
 .S DR=".14///NOPEN"
 .D ^DIE
 Q
NEWB ;
 ; Create a new batch  (Make entry in 3P TX STATUS)
 D NOW^%DTC
 S X=%
 S DIC="^ABMDTXST(DUZ(2),"
 S DIC(0)="LX"
 S DLAYGO=9002274.6
 K DD,DO D FILE^DICN
 K DLAYGO
 Q:Y<0
 S ABMP("XMIT")=+Y
 S DIE=DIC
 S DA=+Y
 S DR=".02///21;.04///`"_ABMINS("IEN")_";.03///"_ABMITYP_";.05////"_DUZ
 D ^DIE
 S DR=".16///"_$$NSN^ABMERUTL D ^DIE
 S DA(1)=DA
 W !,"ENTRY CREATED IN 3P TX STATUS FILE."
 Q
CLAIM ;one claim
 K ABMP
 S ABMP("INS")=ABMINS
 S ABMP("ITYPE")=$P($G(^AUTNINS(ABMINS,2)),U)
 S ABMP("BDFN")=ABMBDFN
 Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0))
 D SET^ABMUTLP(ABMP("BDFN"))
 I '$G(ABMOSBR) D
 .U 0 W !,"Submission # ",ABMSUBN
 .U 0 W !,"Writing bills to file.",!
 .D ^ABME8L1
 .D ^ABME8L2
 S ABMNPDFN=$P(ABMB0,U,5)
 I ABMOSBR'=ABMASBR D
 .D SBR
 I ABMNPDFN'=ABMOPDFN D
 .D PTCHG^ABME8L3
 S ABMP("PNUM")=$$PNUM^ABMUTLP(ABMBILL)
 D ^ABME8L5
 D ^ABME8L6
 D ^ABME8L7
 D ^ABME8L8
 D ^ABME8L10
 W "."
 Q
SBR ;new subscriber
 S ABMSFILE=$P(ABMASBR,"-",1)
 S ABMSIEN=$P(ABMASBR,"-",2)
 S ABMCHILD=0
 N I
 S I=0
 F  S I=$O(^ABMDTXST(DUZ(2),ABMPXMIT,2,"ASBR",ABMASBR,I)) Q:'I  D
 .Q:+^ABMDTXST(DUZ(2),ABMPXMIT,2,"ASBR",ABMASBR,I)=18
 .S ABMCHILD=1
 S ABMP("PNUM")=$$PNUM^ABMUTLP(ABMBILL)
 D ^ABME8L3
 S ABMOSBR=ABMASBR
 S ABMOPDFN=ABMP("PDFN")
 Q
XIT ;
 D ^%ZISC
 W !!,"Finished.",!!
 K ABMEXPM,ABMBDFN,ABMB,ABMTIEN,ABMFROM,ABMTO,ABMDT
 K ABMFILE,ABMRESUB,ABMINS
 Q
