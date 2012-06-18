DGCRBR ; IHS/ADC/PDW/ENM - ADD/EDIT BILLING RATES FILE ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;;MAS VERSION 5.0;
 ;
 ;ask date, bed section, revenue code, amount, the file.
 ;     reask revenue code until null
 ;     reask bed section untill null - then revenue code
 ;     reask date until null .....
ADD W ! S %DT="AEX",%DT("A")="Select BILLING RATE EFFECTIVE DATE: " D ^%DT G:Y<1 END S DGEFDT=+Y
 F I=0:0 D BS G:DGBS<1 ADD
 Q
BS W ! S DIC("S")="I $P(^(0),U,5)",DIC="^DGCR(399.1,",DIC(0)="AEQM",DIC("A")="   Select BILLING BEDSECTION: " D ^DIC K DIC S DGBS=+Y Q:DGBS<1
 F J=0:0 D REV Q:DGREV<1
 Q
REV W ! S DIC("S")="I $P(^(0),U,3)",DIC="^DGCR(399.2,",DIC(0)="AEQM",DIC("A")="      Select REVENUE CODE: " D ^DIC K DIC S DGREV=+Y Q:DGREV<1
 I $D(^DGCR(399.5,"AIVDT",DGBS,-DGEFDT,DGREV)) S DIC(0)="EMQF",X=DGEFDT,DIC="^DGCR(399.5,",DIC("S")="I $P(^(0),U,2)=DGBS,$P(^(0),U,3)=DGREV" D ^DIC K DIC D NEW:+Y<1 Q:Y<1  S DA=+Y D EDIT Q
 W !,"Filing New Entry!" D FILE,EDIT
 Q
FILE S:'$D(DIC(0)) DIC(0)="L" S DIC="^DGCR(399.5,",X=DGEFDT,DIC("DR")=".02////"_DGBS_";.03////"_DGREV D FILE^DICN S DA=+Y
 Q
 ;
NEW ;ask to add new entry from fast
 S Y=DGEFDT X ^DD("DD") W !?3,"ARE YOU ADDING '",Y,"' AS A NEW BILLING RATES" D YN^DICN Q:%=-1!(%=2)
 I '% W !!?3,"Enter 'YES' to add this as a new BILLING RATES",!?3,"or Enter 'NO' to not add a new entry",! G NEW
 S DIC(0)="EQL" D FILE Q
 Q
 ;
EN1 ;edit file entry, do lookup, then edit.
 W ! S DIC("A")="Select BEDSECTION: ",DIC="^DGCR(399.1,",DIC(0)="AEQMN",DIC("S")="I $P(^(0),U,5)" D ^DIC K DIC G:Y<1 END S DGBS=+Y D BR G EN1
 Q
BR W ! S DIC("DR")=".02///"_DGBS,DIC("S")="I $P(^(0),U,2)=DGBS",DIC="^DGCR(399.5,",DIC(0)="AEQL" D ^DIC K DIC Q:Y<1  S DA=+Y D EDIT G BR
 ;
EDIT S (DIC,DIE)="^DGCR(399.5,",DR=".01:99" D ^DIE
 Q
 ;
END K I,J,X,Y,%DT,DA,DIC,DIE,DR,DGBS,DGREV,DGEFDT
 Q
 ;
REDO ;re-index the aivdt x-ref in billing rates file.
 K ^DGCR(399.5,"AIVDT")
 S DGCRJ=0 F DGCRI=0:0 S DGCRJ=$O(^DGCR(399.5,DGCRJ)) Q:'DGCRJ  I $D(^DGCR(399.5,DGCRJ,0)) S X=^(0) I $P(X,"^",2)]"",$P(X,"^",3)]"" S ^DGCR(399.5,"AIVDT",$P(X,"^",2),-($P(X,"^")),$P(X,"^",3),DGCRJ)=""
