ABMPOST ;IHS/ASDS/LSL - 3PB Pharmacy POS - Patch 6 POST INIT  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 05/21/2001 - V2.4 Patch 6 - Post Init
 ;     Populate 3P Visit Type file with 901 Pharmacy POS
 ;
 Q
 ;
EN ;      
 K DA,DR,DIC,DLAYGO,X,DINUM
 S DIC="^ABMDVTYP("
 S DIC(0)="LX"
 S DLAYGO=9002274
 S DIC("DR")=".02////131"
 S DINUM=901
 S X="Pharmacy POS"
 D ^DIC
 K DA,DR,DIC,DLAYGO,X,DINUM,Y
 Q
