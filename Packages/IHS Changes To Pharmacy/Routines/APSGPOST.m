APSGPOST ; IHS/DSD/ENM - ADD P28 OPTIONS TO IV MENU'S ;  [ 01/14/2002  3:19 PM ]
 ;;3.2;INPATIENT MEDICATIONS;**3**;12/28/01
EP ;
 W !!,"Now, I'm going to add the following menu options to the 'PSJI MGR'",!,"Menu Option",!,?10,"PSJ4 MGR - Inpatient Meds V4 Pre-Release Menu"
 W !!,?10,"and PSJU MARK UD ITEMS Option added to PSJ4 MGR Menu",!
 W !,?10,"........One moment please!",!! H 3
 S M1="PSJI MGR"
 ;GET FILE 19 DETAILS FOR OPTIONS
 S DIC("P")=$P(^DD(19,10,0),"^",2) ;GET MENU SUB FILE NBR
 S DA=$O(^DIC(19,"B","PSJ4 MGR",0)) ;item rec nbr
 S DIC("DR")="2///PRE4" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSJI MGR",0)) ;main option nbr
 D PT1
 ;
 S M1="PSJ4 MGR"
 S DIC("P")=$P(^DD(19,10,0),"^",2) ;GET MENU SUB FILE NBR
 S DA=$O(^DIC(19,"B","PSJU MARK UD ITEMS",0)) ;item rec nbr
 S DIC("DR")="2///MUD" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSJ4 MGR",0)) ;main option nbr
 D PT1
 W !!,"OK, I'm done!",!!
 Q
PT1 Q:DA=""
 S APSPN=$P(^DIC(19,DA,0),"^",1) ;name of item option
 I 'DA(1) W !!,*7,*7,"*** The "_APSPN_" option has not been added to the"_M1_" menu",!,"    because the "_M1_" menu does not exist on your system. Install"
 I  W !,"    the "_M1_" menu then rerun this routine again." G EX
 S THERE=$O(^DIC(19,DA(1),10,"B",DA,0))
 I THERE W !,*7,*7,"The "_APSPN_" option has already been added to the "_M1_" menu.",!! G EX
 S X=DA,DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LMZ" K DD,DO D FILE^DICN K DIC
 W !,APSPN_" Option added to "_M1_" menu!"
EX K DA,THERE,X,Y,APSPN Q
 Q
