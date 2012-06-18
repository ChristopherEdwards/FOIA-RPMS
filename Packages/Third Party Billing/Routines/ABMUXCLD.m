ABMUXCLD ; IHS/SD/SDR - 3PB/UFMS populate Exclusion Table   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; new routine - v2.5 p12 SDD item 4.4
 ;
EP ; EP
 W !!?3,"WARNING: Entries into the following file will prohibit data from being"
 W !?12,"sent to UFMS."
 W !?12,"Use EXTREME caution when creating entries."
 W !!,"The default to your current location."
 K DIR
 W !!
 S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;location
 I +$P($G(^ABMUXCLD(0)),U,3)=0 W !!,"There is currently no data in file.",!,"""^"" to exit without entry.",!
 K DIC,DIE,DA,X,Y
 S DIC="^ABMUXCLD("
 S DIC(0)="AEMQL"
 S DIC("A")="Select Location: "
 S DIC("B")=DUZ(2)
 D ^DIC
 Q:+Y<0
 Q:$D(DTOUT)!$D(DUOUT)
 S ABMLOC=+Y
 ;
DISP ;display of existing entries in file
 W !!,"Existing entries for "_$P($G(^DIC(4,ABMLOC,0)),U)_":"
 W !?3,"Eff. Date"
 W ?15,"End Date"
 W ?28,"Clinic"
 W ?55,"Insurer Type",!
 F ABMI=1:1:80 W "-"
 S ABMEDT=0
 I +$O(^ABMUXCLD(ABMLOC,1,ABMEDT))=0 W !?5,"NO ENTRIES EXIST"
 F  S ABMEDT=$O(^ABMUXCLD(ABMLOC,1,ABMEDT)) Q:+ABMEDT=0  D
 .S ABMREC=$G(^ABMUXCLD(ABMLOC,1,ABMEDT,0))
 .W !?3,$$SDT^ABMDUTL($P(ABMREC,U))
 .W ?15,$$SDT^ABMDUTL($P(ABMREC,U,2))
 .W:$P(ABMREC,U,3)'="" ?28,$P($G(^DIC(40.7,$P(ABMREC,U,3),0)),U,2),?31,$E($P($G(^DIC(40.7,$P(ABMREC,U,3),0)),U),1,20)
 .I $P(ABMREC,U,4)'="" D
 ..S ABMTYP=$P(ABMREC,U,4)
 ..W ?55,$P($T(@ABMTYP^ABMUCASH),";;",2)
 W !
 ;effective date
 K DIC,DIE,DA,X,Y
 S DA(1)=ABMLOC
 S DIC="^ABMUXCLD(DA(1),1,"
 S DIC(0)="AEQLV"
 D ^DIC
 Q:+Y<0
 Q:$D(DTOUT)!$D(DUOUT)
 S ABMEFFDT=+Y
 ;everything else
 K DIC,DIE,DA,X,Y
 S DA(1)=ABMLOC
 S DIE="^ABMUXCLD(DA(1),1,"
 S DA=ABMEFFDT
 S DR=".03;.04;.02"
 D ^DIE
 G DISP
 Q
