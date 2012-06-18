ABMRLABS ; IHS/SD/SDR - Add/Edit Reference Lab Locations - 3/15/2005 2:11:05 PM
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ; New routine - 3/15/05
 ;
EP ;
 K DIC
 S DIC="^ABMRLABS("
 S DIC(0)="QAELM"
 D ^DIC
 Q:(+Y<0)
 I $P(Y,"^",3)'=1 D  ;not new entry; prompt for .02
 .S DIE=DIC
 .S DA=+Y
 .S DR=".01//;.02//"
 .D ^DIE
 Q
