ACDRESET ;IHS/ADC/EDE/KML - EXTRACT RESET BY DATE RANGE;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;***********************************************************
 ;//[ACD SUPER1]
 ;***********************************************************
EN ;EP
 W !!,@IOF,"I will reset all CDMIS extract flags between the to: and from:",!,"dates you give me. Once the extract flags are reset for the records, the",!,"records may be re-extracted for transmission to the AREA or HQ."
 W !!,*7,*7,"WARNING.....",!,"THIS MAY CAUSE DUPLICATED ENTRIES IN THE AREA/HQ MACHINE..",!,"COORDINATE THE EXTRACT RESET WITH THE AREA/HEADQUARTERS.."
EN1 ;
 K ACDPGM
 W !!,"Reset extract flags for all programs" S %=2 D YN^DICN I %=1 F ACDDA=0:0 S ACDDA=$O(^ACDVIS("C",ACDDA)) Q:'ACDDA  S ACDPGM(ACDDA)=""
 I %=0 W !!,"Answer yes to reset extract flags for 'ALL' programs."
 I %=0 W !,"If you answer yes, I will show you a list of programs found."
 I %=0 W !,"Answer no, and you may then select individual programs." G EN1
 I %=2 F  S DIC(0)="AEQ",DIC=4,DIC("A")="SELECT PROGRAM: " D ^DIC Q:Y<0  S ACDPGM(+Y)=""
 I '$O(ACDPGM(0)) G K
 ;
 K ACDQUIT D D^ACDWRQ I $D(ACDQUIT) G K
 W !!!,"Resetting Extract flags for all CDMIS visit/prevention data"
 W !!,"from: ",$$DD^ACDFUNC(ACDFR)," through: "
 W $$DD^ACDFUNC(ACDTO),!!,"for Program(s): "
 F DA=0:0 S DA=$O(ACDPGM(DA)) Q:'DA  W !,$P(^DIC(4,DA,0),U)
 F  W !!,"OK to continue" S %=2 D YN^DICN W:%=0 "  Answer Yes or No" G:%'=1&(%'=0) K Q:%=1
 W !!,"Extract flags being re-initialized for VISIT DATA"
 F ACD=ACDFR-.01:0 S ACD=$O(^ACDVIS("B",ACD)) Q:'ACD!(ACD>ACDTO)  F ACDV=0:0 S ACDV=$O(^ACDVIS("B",ACD,ACDV)) Q:'ACDV  W "." D
 .I '$D(^ACDVIS(ACDV,0)) Q
 .I '$D(^ACDVIS(ACDV,"BWP")) Q
 .I '$D(ACDPGM(^ACDVIS(ACDV,"BWP"))) Q
 .S DA=ACDV,DIE="^ACDVIS(",DR="25///@" D DIE^ACDFMC
 .F ACDDA=0:0 S ACDDA=$O(^ACDIIF("C",ACDV,ACDDA)) Q:'ACDDA  S DA=ACDDA,DIE="^ACDIIF(",DR="25///@" D DIE^ACDFMC
 .F ACDDA=0:0 S ACDDA=$O(^ACDTDC("C",ACDV,ACDDA)) Q:'ACDDA  S DA=ACDDA,DIE="^ACDTDC(",DR="25///@" D DIE^ACDFMC
 .F ACDDA=0:0 S ACDDA=$O(^ACDCS("C",ACDV,ACDDA)) Q:'ACDDA  S DA=ACDDA,DIE="^ACDCS(",DR="5///@" D DIE^ACDFMC
PRV ;
 W !!,"Extract flags being re-initialized for PREVENTION DATA"
 F ACD=ACDFR-.001:0 S ACD=$O(^ACDPD("B",ACD)) Q:'ACD!(ACD>ACDTO)  F ACDV=0:0 S ACDV=$O(^ACDPD("B",ACD,ACDV)) Q:'ACDV  D
 .I '$D(^ACDPD(ACDV,0)) Q
 .S ACDBWP=$P(^ACDPD(ACDV,0),U,4) Q:'ACDBWP  I '$D(ACDPGM(ACDBWP)) Q
 .S DA=ACDV,DIE="^ACDPD(",DR="25///@" D DIE^ACDFMC W "."
K ;
 K X,Y,ACDFR,ACDTO,DA,DR,DIE,ACDDA,ACD,ACDV,%,ACDPGM
