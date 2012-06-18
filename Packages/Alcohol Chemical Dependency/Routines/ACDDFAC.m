ACDDFAC ;IHS/ADC/EDE/KML - CLEAN OUT AREA/HQ DB OF FACILITY ENTRIES; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;************************************************************
 ;This CDMIS utility runs at the Area or HQ to clean out the
 ;Area or HQ database of facility data by date range. The user
 ;specifies which date range to delete data for, and which facility
 ;to delete. This routine will prep an Area/HQ machine for an upcomming
 ;import from a facility. There will be a need to clean out the 
 ;Area/HQ machine prior to importing. This will be the case if a
 ;facility needs to resend data up to the Area. The Area database
 ;must first be cleaned out so not to have duplicate entries.
 ;
 ;Note this utility DOES NOT delete intervention data.
 ;//[ACD SUPER2]
 ;************************************************************
EN ;EP
 W @IOF,!,*7,*7,*7,"WARNING..This utility will 'PERMANENTLY DELETE' CDMIS DATA."
 W !,"This is not a data archive (the data cannot be retrieved)",!
 W !,"This utility should only be run on machines receiving data imports."
 W !,"This utility should 'NEVER' run at the facility or on an",!,"Area machine where facilities are dialing into the Area to access CDMIS."
 ;
 D EN4^ACDV4MES
 ;
 ;
 ;
 ;
EN1 ;
 ;Stop user if facility
 I $E(ACD6DIG)'=9,$E(ACD6DIG,3,4)'="00" W !!,*7,*7,"Facilities may not delete data using this option." D K Q
 ;
 K ACDPGM
 ;
 ;Load program names from the CDMIS VISIT file
 ;Load program names from the CDMIS PREVENTION file
 W !!,"Delete data for all programs" S %=2 D YN^DICN I %=1 F ACDDA=0:0 S ACDDA=$O(^ACDVIS("C",ACDDA)) Q:'ACDDA  S ACDPGM(ACDDA)=""
 I %=1 F ACDDA=0:0 S ACDDA=$O(^ACDPD("C",ACDDA)) Q:'ACDDA  S ACDPGM(ACDDA)=""
 I %=0 W !!,"Answer yes to 'PERMANENTLY DELETE DATA' for 'ALL' programs."
 I %=0 W !,"If you answer yes, I will show you a list of programs found."
 I %=0 W !,"Answer no, and you may then select individual programs." G EN1
 I %=2 F  S DIC(0)="AEQ",DIC=4,DIC("A")="SELECT PROGRAM: " D ^DIC Q:Y<0  S ACDPGM(+Y)=""
 I '$O(ACDPGM(0)) G K
 ;Ask user for dates
 K ACDQUIT D D^ACDWRQ I $D(ACDQUIT) G K
 ;verify user wants to continue
 W !!!,"Deleting CDMIS VISIT ENTRIES for all CDMIS visit/prevention data",!!,"from: ",$$DD^ACDFUNC(ACDFR)," through: ",$$DD^ACDFUNC(ACDTO),!!,"for Program(s): " F DA=0:0 S DA=$O(ACDPGM(DA)) Q:'DA  W !,$P(^DIC(4,DA,0),U)
 ;
 W !!!,*7,*7,"Your last chance to quit without deleting data is NOW !!??"
 W !!
 F  W !!,"OK to continue" S %=2 D YN^DICN W:%=0 "  Answer Yes or No" G:%'=1&(%'=0) K Q:%=1
 W !!,"First let me break the Visit Links....."
 F ACDAT=ACDFR-.01:0 S ACDAT=$O(^ACDVIS("B",ACDAT)) Q:'ACDAT!(ACDAT>ACDTO)  F DA=0:0 S DA=$O(^ACDVIS("B",ACDAT,DA)) Q:'DA  I $D(^ACDVIS(DA,0)),$D(^ACDVIS(DA,"BWP")),$D(ACDPGM(^("BWP"))) S DIK="^ACDVIS(" D ^DIK
 D EN1^ACDCLN
 F ACDAT=ACDFR-.01:0 S ACDAT=$O(^ACDPD("B",ACDAT)) Q:'ACDAT!(ACDAT>ACDTO)  F DA=0:0 S DA=$O(^ACDPD("B",ACDAT,DA)) Q:'DA  I $D(^ACDPD(DA,0)),$D(ACDPGM($P(^(0),U,4))) S DIK="^ACDPD(" D ^DIK
K ;
 K DIC,DIK,DA,ACDPGM,Y,ACDTO,ACDFR
 K ACDAT
 Q
