ABMCHRPT ; IHS/SD/SDR - Clearing House report ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
START ;start
 W !!,"This report will print all Clearinghouse entries and their associated insurers,"
 W !,"as well as any fields that have been populated for that Clearinghouse."
 ;
SEL ;
 S ABM("HD",0)="CLEARINGHOUSE LISTING"
 S ABM("PG")=0
 D ^ABMDRHD
 S ABMQ("RC")="COMPUTE^ABMCHRPT",ABMQ("RX")="POUT^ABMDRUTL",ABMQ("NS")="ABM"
 S ABMQ("RP")="PRINT^ABMCHRPT"
 D ^ABMDRDBQ
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 Q
PRINT ;EP for printing data
 S ABMCHIEN=0
 D HDB
 F  S ABMCHIEN=$O(^ABMRECVR(ABMCHIEN)) Q:'ABMCHIEN  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W " (cont)"
 .S ABMCH=$P($G(^ABMRECVR(ABMCHIEN,0)),U)
 .S ABMPAYID=$P($G(^ABMRECVR(ABMCHIEN,0)),U,2)
 .W !,ABMCH_"   PAYER ID: ",ABMPAYID
 .S ABMINS=0
 .F  S ABMINS=$O(^ABMRECVR(ABMCHIEN,1,ABMINS)) Q:'ABMINS  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ..I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W " (cont)"
 ..S ABMINSN=$P($G(^AUTNINS(ABMINS,0)),U)
 ..S ABMIPYID=$P($G(^ABMRECVR(ABMCHIEN,1,ABMINS,0)),U,2)
 ..S ABMCONTN=$P($G(^AUTNINS(ABMINS,0)),U,8)
 ..S ABMEMCID=$P($G(^ABMNINS(DUZ(2),ABMINS,0)),U,2)
 ..W !,?3,ABMINSN
 ..W ?32,ABMIPYID
 ..W ?42
 ..W ?50,ABMCONTN
 ..W ?69,ABMEMCID
 .W !
 Q:$D(DIROUT)!($D(DUOUT))!($D(DTOUT))
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1 D WHD^ABMDRHD
 W !,"Clearinghouse"
 W !?3,"Insurer",?32,"Payer ID",?42,"EXP",?50,"AO CONTROL#",?69,"EMC SUB ID"
 S $P(ABM("LINE"),"-",80)="" W !,ABM("LINE") K ABM("LINE")
 Q
