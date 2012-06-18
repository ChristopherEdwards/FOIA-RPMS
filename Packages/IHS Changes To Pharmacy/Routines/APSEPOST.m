APSEPOST ; IHS/DSD/ENM - ADD PMI OPTIONS TO PSO MENU'S ;  [ 06/11/2001  1:29 PM ]
 ;;6.1;IHS PHARMACY MODIFICATIONS;**1**;04/11/01
EP ;
 W !!,"Now, I'm going to add the following menu options to the 'PSO RX'",!,"Menu Option",!,?10,"PRINT DRUG MEDICATION SHEET (APSE PMI DRUG)"
 W !,?10,"PRINT PATIENT MEDICATION SHEET (APSP PMI PATIENT)",!,"........One moment please!",!! H 3
 S M1="PSO RX"
 ;APSP PATIENT INSTRUCTIONS
 S DIC("P")=$P(^DD(19,10,0),"^",2) ;GET MENU SUB FILE NBR
 S DA=$O(^DIC(19,"B","APSE PMI DRUG",0)) ;item rec nbr
 S DIC("DR")="2///DPMI" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO RX",0)) ;main option nbr
 D PT1
 ;APSP INFORMATION MENU
 S DIC("P")=$P(^DD(19,10,0),"^",2) ;GET MENU SUB FILE NBR
 S DA=$O(^DIC(19,"B","APSP PMI PATIENT",0)) ;item rec nbr
 S DIC("DR")="2///PMI" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO RX",0)) ;main option nbr
 D PT1
 W !!,"OK, I'm done!",!!
 Q
PT1 S APSPN=$P(^DIC(19,DA,0),"^",1) ;name of item option
 I 'DA(1) W !!,*7,*7,"*** The "_APSPN_" option has not been added to vthe"_M1_" menu",!,"    because the "_M1_" menu does not exist on your system. Install"
 I  W !,"    the "_M1_" menu then rerun this routine again." G EX
 S THERE=$O(^DIC(19,DA(1),10,"B",DA,0))
 I THERE W !,*7,*7,"The "_APSPN_" option has already been added to the "_M1_" menu.",!! G EX
 S X=DA,DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LMZ" K DD,DO D FILE^DICN K DIC
 W !,APSPN_" Option added to "_M1_" menu!"
EX K DA,THERE,X,Y,APSPN Q
 Q
