APSPOST9 ; IHS/DSD/ENM - ADD APSP OPTIONS TO PSO MENU'S ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
EP ;
 W !!,"Now, I'm going to add your 'APSP' menu options to the 'PSO'",!,"menu options........One moment please!",!! H 3
 S M1="PSO MANAGER"
 ;APSP CHRONIC MED PROFILE
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP CHRONIC MED PROFILE",0)) ;item rec nbr
 S DIC("DR")="2///CMP" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO MANAGER",0)) ;main option nbr
 D PT1
 ;APSP PREPACK MAIN MENU
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP PREPACK MAIN MENU",0)) ;item rec nbr
 S DIC("DR")="2///PREP" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO MANAGER",0)) ;main option nbr
 D PT1
 ;APSP B LABEL/PRO MONITOR REPRINT (SLAVE PRINTERS)
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP B",0)) ;item rec nbr
 S DIC("DR")="2///LMRS" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO MANAGER",0)) ;main option nbr
 D PT1
 ;APSP PHAMACY QA MAIN MENU
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP QA MAIN MENU",0)) ;item rec nbr
 S DIC("DR")="2///QAMM" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO MANAGER",0)) ;main option nbr
 D PT1
 S M1="PSO OUTPUTS"
 ;APSP CONTROLLED DRUG USE
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP CONTROLLED DRUG USE",0)) ;item rec nbr
 S DIC("DR")="2///CDUR" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO OUTPUTS",0)) ;main option nbr
 D PT1
 ;APSP DAILY PRESCRIPTION LOG
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP DAILY PRESCRIPTION LOG",0)) ;item rec nbr
 S DIC("DR")="2///DPL" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO OUTPUTS",0)) ;main option nbr
 D PT1
 ;APSP DRUG RECALL
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP DRUG RECALL",0)) ;item rec nbr
 S DIC("DR")="2///DRRR" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO OUTPUTS",0)) ;main option nbr
 D PT1
 ;APSP DUE
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP DUE",0)) ;item rec nbr
 S DIC("DR")="2///DUER" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO OUTPUTS",0)) ;main option nbr
 D PT1
 ;APSP TOTAL DRUGS DISPENSED
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP TOTAL DRUGS DISPENSED",0)) ;item rec nbr
 S DIC("DR")="2///TDDR" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO OUTPUTS",0)) ;main option nbr
 D PT1
 S M1="PSO RX"
 ;APSP PATIENT INSTRUCTIONS
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP PATIENT INSTRUCTIONS",0)) ;item rec nbr
 S DIC("DR")="2///MEDI" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO RX",0)) ;main option nbr
 D PT1
 ;APSP INFORMATION MENU
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP INFORMATION MENU",0)) ;item rec nbr
 S DIC("DR")="2///MIME" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO RX",0)) ;main option nbr
 D PT1
 ;APSP OUTSIDE RX MENU
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP OUTSIDE RX MENU",0)) ;item rec nbr
 S DIC("DR")="2///ORX" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO RX",0)) ;main option nbr
 D PT1
 ;APSP SUMMARY LABEL
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP SUMMARY LABEL",0)) ;item rec nbr
 S DIC("DR")="2///SUM" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO RX",0)) ;main option nbr
 D PT1
 S M1="PSO SUPERVISOR"
 ;APSP INVENTORY BY LOCATION
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP INVENTORY BY LOCATION",0)) ;item rec nbr
 S DIC("DR")="2///DSLL" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO SUPERVISOR",0)) ;main option nbr
 D PT1
 ;APSP INVENTORY LIST
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP INVENTORY LIST",0)) ;item rec nbr
 S DIC("DR")="2///INLI" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSO SUPERVISOR",0)) ;main option nbr
 D PT1
 S M1="PSOZ SITE PARAMETER"
 ;APSP IHS CONTROL
 S DIC("P")=$P(^DD(19,10,0),"^",2)
 S DA=$O(^DIC(19,"B","APSP IHS CONTROL",0)) ;item rec nbr
 S DIC("DR")="2///IHSP" ;synonym
 S DA(1)=$O(^DIC(19,"B","PSOZ SITE PARAMETER",0)) ;main option nbr
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
