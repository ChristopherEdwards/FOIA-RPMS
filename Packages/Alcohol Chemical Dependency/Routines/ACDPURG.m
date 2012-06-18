ACDPURG ;IHS/ADC/EDE/KML - PURGE DAT OVER 3 YEARS OLD;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
EN ;EP
 ;//[ACD SUPER5]
 W @IOF,"Signon Program is            : ",$P(^DIC(4,DUZ(2),0),U)
 ;
 ;
 ;Stop user if HQ
 I $E(ACD6DIG)=9 W !!,*7,"Headquarters may not purge data." D K Q
 I $E(ACD6DIG,3,4)="00" W !!,*7,"Area's may not purge data." D K Q
 ;
 K ACDPGM
 F ACDDA=0:0 S ACDDA=$O(^ACDVIS("C",ACDDA)) Q:'ACDDA  S ACDPGM(ACDDA)=""
 F ACDDA=0:0 S ACDDA=$O(^ACDPD("C",ACDDA)) Q:'ACDDA  S ACDPGM(ACDDA)=""
 F ACDDA=0:0 S ACDDA=$O(^ACDINTV("C",ACDDA)) Q:'ACDDA  S ACDPGM(ACDDA)=""
 I '$O(ACDPGM(0)) G K
 ;
 ;Force dates back 3 years
 D NOW^%DTC S DT=X,X1=DT,X2=-1095 D C^%DTC S ACDTO=X W !!,"I will purge data older than ",$$DD^ACDFUNC(ACDTO)
 ;
 ;verify user wants to continue
 W !!!,"Purging for all CDMIS visit/prevention/intervention data",!!,"Older than: ",!,$$DD^ACDFUNC(ACDTO),!!,"for Program(s): " F DA=0:0 S DA=$O(ACDPGM(DA)) Q:'DA  W !,$P(^DIC(4,DA,0),U)
 ;
 F  W !!,"OK to continue" S %=2 D YN^DICN W:%=0 "  Answer Yes or No" G:%'=1&(%'=0) K Q:%=1
 W !!,"First let me break the Visit Links....."
 F ACDAT=0:0 S ACDAT=$O(^ACDVIS("B",ACDAT)) Q:'ACDAT!(ACDAT>ACDTO)  F DA=0:0 S DA=$O(^ACDVIS("B",ACDAT,DA)) Q:'DA  I $D(^ACDVIS(DA,0)),$D(^ACDVIS(DA,"BWP")),$D(ACDPGM(^("BWP"))) S DIK="^ACDVIS(" D ^DIK
 D EN1^ACDCLN
 W !!,"Now purging old prevention data"
 F ACDAT=0:0 S ACDAT=$O(^ACDPD("B",ACDAT)) Q:'ACDAT!(ACDAT>ACDTO)  F DA=0:0 S DA=$O(^ACDPD("B",ACDAT,DA)) Q:'DA  I $D(^ACDPD(DA,0)),$D(ACDPGM($P(^(0),U,4))) S DIK="^ACDPD(" D ^DIK W "."
 W !!,"Now purging old intervention data"
 F ACDAT=0:0 S ACDAT=$O(^ACDINTV("B",ACDAT)) Q:'ACDAT!(ACDAT>ACDTO)  F DA=0:0 S DA=$O(^ACDINTV("B",ACDAT,DA)) Q:'DA  I $D(^ACDINTV(DA,0)),$D(ACDPGM($P(^(0),U,17))) S DIK="^ACDINTV(" D ^DIK W "."
K ;
 K DIC,DIK,DA,ACDPGM,Y,ACDTO,ACDFR
 K ACDAT
 Q
