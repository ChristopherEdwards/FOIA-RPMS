APSPOSTC ; IHS/DSD/ENM - PDM POST ADD OPTION(S) TO PSS MENU'S ;  [ 02/03/2004  3:18 PM ]
 ;;1.0;IHS PHARMACY DATA MANAGEMENT;**1**;01/28/04
EP ;
 W !!,"Now, I'm going to add the following menu options to the 'PSS MGR'",!,"Menu Option"
 W !,?10,"PSS PRE-RELEASE MANUAL MATCH - Manually Match Dispensed Drugs"
 W !,?10,"PSS SYS EDIT - Pharmacy System Parameters Edit",!
 W !,?10,"PSS CREATE ORDERABLE ITEMS - Create Pharmacy Orderable Items",!!,?10,"........One moment please!",!! H 3
 S M1="PSS MGR - Pharmacy Data Management"
 ;PSS PRE-RELEASE MANUAL MATCH OPTION SETUP
 S DIC("P")=$P(^DD(19,10,0),"^",2) ;GET MENU SUB FILE NBR
 S DA=$O(^DIC(19,"B","PSS PRE-RELEASE MANUAL MATCH",0)) ;item rec nbr
 ;S DIC("DR")="2///APS" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSS MGR",0)) ;main option nbr
 D PT1
 ;PSS SYS EDIT OPTION SETUP
 S DIC("P")=$P(^DD(19,10,0),"^",2) ;GET MENU SUB FILE NBR
 S DA=$O(^DIC(19,"B","PSS SYS EDIT",0)) ;item rec nbr
 ;S DIC("DR")="2///APS" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSS MGR",0)) ;main option nbr
 D PT1
 ;PSS CREATE ORDERABLE ITEMS SETUP UP
 S DIC("P")=$P(^DD(19,10,0),"^",2) ;GET MENU SUB FILE NBR
 S DA=$O(^DIC(19,"B","PSS CREATE ORDERABLE ITEMS",0)) ;item rec nbr
 ;S DIC("DR")="2///APS" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSS MGR",0)) ;main option nbr
 D PT1
 W !!,"OK, I'm done!",!!
 Q
PT1 S APSPN=$P(^DIC(19,DA,0),"^",1) ;name of item option
 I 'DA(1) W !!,*7,*7,"*** The "_APSPN_" option has not been added to the"_M1_" menu",!,"    because the "_M1_" menu does not exist on your system. Install"
 I  W !,"    the "_M1_" menu then rerun this routine again." G EX
 S THERE=$O(^DIC(19,DA(1),10,"B",DA,0))
 I THERE W !,*7,*7,"The "_APSPN_" option has already been added to the "_M1_" menu.",!! G EX
 S X=DA,DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LMZ" K DD,DO D FILE^DICN K DIC
 W !,APSPN_" Option added to "_M1_" menu!"
EX K DA,THERE,X,Y,APSPN Q
 Q
