ACDWASF ;IHS/ADC/EDE/KML - VALIDATE RECORD MEETS USER REQUESTED CRITERIA; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;************************************************************
 ;//^ACDWVIS
 ;Routine needs the 6 digIt ASUFAC. It must be in variable ACDAUF
 ;ACDONE =area
 ;ACDTWO =service unit
 ;ACDTHREE =facility
 ;ACDONE,ACDTWO,ACDTHREE will ALL be defined leaving this routine
 ;if we have a valid CDMIS record matching user criteria
 ;************************************************************
EN ;
CHK ;
 ;See if printing reports by the Area or Facility or Service Unit
 ;1 of 3 arrays ACDAREA or ACDSU or ACDFAC will be defined here
 K ACDONE,ACDTWO,ACDTHREE,ACDFOUR
 I $D(ACDAREA) D AREA,K Q
 I $D(ACDSU) D SU,K Q
 I $D(ACDFAC) D FAC,K Q
 W !,"ERROR ************************************" Q
 ;
AREA ;User is printing by areas
 ;ACDAREA(*ALL*) means user selected all areas
 ;ACDAREA(2 DIGITS) means match on these areas only
 I $D(ACDAREA("*ALL*")) D MATCH
 I $D(ACDAREA($E(ACDAUF,1,2))) D MATCH
 Q
SU ;User is printing by service unit
 ;ACDSU(*ALL*) means user selected all service units
 ;ACDSU(4 DIGIT) means match on these service units only
 I $D(ACDSU("*ALL*")) D MATCH
 I $D(ACDSU($E(ACDAUF,1,4))) D MATCH
 Q
FAC ;User is printing by facility
 ;ACDFAC(*ALL*) means user selected all facilities
 ;ACDFAC(6 DIGIT) means run for selected facilities
 I $D(ACDFAC("*ALL*")) D MATCH
 I $D(ACDFAC(ACDAUF)) D MATCH
 Q
MATCH ;
 S ACDONE=$E(ACDAUF,1,2),ACDDA=$O(^AUTTAREA("C",ACDONE,0)) Q:'ACDDA  S ACDONE=$S($D(^AUTTAREA(ACDDA,0)):$P(^(0),U),1:"NF"),ACDONE=$E(ACDONE,1,12)_"*"_ACDDA
 S ACDTWO=$E(ACDAUF,1,4),ACDDA=$O(^AUTTSU("C",ACDTWO,0)) Q:'ACDDA  S ACDTWO=$S($D(^AUTTSU(ACDDA,0)):$P(^(0),U),1:"NF"),ACDTWO=$E(ACDTWO,1,12)_"*"_ACDDA
 S ACDTHREE=ACDAUF,ACDDA=$O(^AUTTLOC("C",ACDTHREE,0)) Q:'ACDDA  S ACDTHREE=$S($D(^AUTTLOC(ACDDA,0)):$P(^(0),U,2),1:"NF"),ACDTHREE=$E(ACDTHREE,1,12)_"*"_ACDDA
K Q
