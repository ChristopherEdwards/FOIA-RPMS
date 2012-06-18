ABMUROPN ; IHS/SD/SDR - 3PB/UFMS Re-open Session Option   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; New routine - v2.5 p12 SDD item 4.9.2.3
 ; Re-open Cashiering Session
 ;
 W !!,"The following sessions are available for re-opening =>",!
 S ABMFLG="CLOSED"
 K ABMO
 D FINDACLS^ABMUCUTL
 D HEADER
 ;remove any POS entries; they are not re-openable
 S ABMS=0
 F  S ABMS=$O(ABMO(ABMS)) Q:+ABMS=0  D
 .S ABMSDUZ=""
 .F  S ABMSDUZ=$O(ABMO(ABMS,ABMSDUZ)) Q:ABMSDUZ=""  D
 ..I ABMSDUZ="POS" K ABMO(ABMS)
 I '$D(ABMO) D  Q
 .W !?5,"There are no CLOSED sessions."
 .K DIR
 .W !!!
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 D VIEWLIST  ;list of closed sessions
 D SELSESS  ;which session to open
 Q:+$G(ABMANS)=0
 D FINDOPEN^ABMUCUTL($P($G(ABMOS(ABMANS)),U,2))  ;check if user already has open session; prevent two open sessions
 I +$G(ABMFD)'=0 D
 .W !!,"This user has an existing open session so the selected session will not be",!,"  re-opened.",!
 .K ABMANS
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 I +$G(ABMANS)'=0 D REOPEN
 Q
HEADER ;EP
 W !!,"The following SESSIONS are currently "_ABMFLG_" =>",!!
 W ?4,"SESSION ID",?19,"CASHIER",?40,"DATE OPENED",?57,"DATE CLOSED"
 W ?74,"STATUS"
 W !
 S $P(ABMLINE,"-",80)=""
 W ABMLINE,!
 Q
VIEWLIST ;EP
 S ABMS=0,ABMSCNT=0
 F  S ABMS=$O(ABMO(ABMS)) Q:+ABMS=0  D
 .S ABMSDUZ=0
 .F  S ABMSDUZ=$O(ABMO(ABMS,ABMSDUZ)) Q:+ABMSDUZ=0  D
 ..S ABMSDT=0
 ..F  S ABMSDT=$O(ABMO(ABMS,ABMSDUZ,ABMSDT)) Q:+ABMSDT=0  D
 ...S ABMST=$P($G(ABMO(ABMS,ABMSDUZ,ABMSDT)),U)
 ...Q:ABMST'="C"  ;only closed sessions
 ...S ABMSCNT=ABMSCNT+1
 ...W ABMSCNT_". "
 ...W ABMSDT
 ...W ?19,$E($P($G(^VA(200,ABMSDUZ,0)),U),1,19)
 ...W ?40,$P($$CDT^ABMDUTL(ABMSDT)," ")
 ...W ?57,$P($$CDT^ABMDUTL($P($G(^ABMUCASH(ABMLOC,10,ABMSDUZ,20,ABMSDT,0)),U,3))," ")
 ...I $G(ABMO(ABMS,ABMSDUZ,ABMSDT))'="" D
 ....W ?74,"CLOSED",!
 ...S ABMOS(ABMSCNT)=ABMS_"^"_ABMSDUZ_"^"_ABMSDT_"^"_$G(ABMO(ABMS,ABMSDUZ,ABMSDT))
 Q
SELSESS ;EP
 K DIC,DIE,DIR,X,Y,DA
 S DIR(0)="NO^1:"_ABMSCNT
 S DIR("A")="Select Session Number to Re-open"
 D ^DIR K DIR
 S ABMANS=+Y
 I $D(DIROUT)!$D(DUOUT)!$D(DTOUT)!$D(DIRUT) K ABMANS Q
 K DIC,DIE,DIR,X,Y,DA
 W !
 S DIR(0)="Y"
 S DIR("A")="Are you sure you want to re-open session "_$P($G(ABMOS(ABMANS)),U,3)
 S DIR("B")="N"
 D ^DIR K DIR
 I +Y'=1 K ABMANS
 Q
REOPEN ;EP
 K DIC,DIE,X,Y,DA
 S DA(2)=ABMLOC
 S DA(1)=$P($G(ABMOS(ABMANS)),U,2)
 S DA=$P($G(ABMOS(ABMANS)),U,3)
 S DIE="^ABMUCASH("_DA(2)_",10,"_DA(1)_",20,"
 S DR=".09///NOW;.03////@;.04////O"
 D ^DIE
 W !!,"Ok, session "_$P($G(ABMOS(ABMANS)),U,3)_" has been re-opened and will begin tracking bills again."
 Q
