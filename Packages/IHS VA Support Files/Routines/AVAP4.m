AVAP4 ;IHS/ORDC/LJF - CLEANUP PROVIDER CLASS ENTRIES; [ 05/11/94  2:57 PM ]
 ;;93.2;VA SUPPORT FILES;**4,5,6**;JUL 01, 1993
 ;cleanup rtn for patches #4, 5, & 6
 ;
 Q  ;can only execute from line label
 ;
CLASS ;EP >> kill off file 6 entries if no zero node
 ;      then if provider class set in file 200, fire xrefs for
 ;      provider class, affiliation, and code
 ;
 S U="^"
 W !!!,"This program will cleanup bad entries in your PROVIDER file"
 W !,"and recreate them if a PROVIDER CLASS has been entered for the"
 W !,"provider in the NEW PERSON file."
 W !! K DIR S DIR(0)="YO",DIR("B")="NO"
 S DIR("A")="OKAY to run CLEANUP" D ^DIR Q:Y'=1
 ;
 S AVA6=0
 F  S AVA6=$O(^DIC(6,AVA6)) Q:AVA6'=+AVA6  D
 .Q:$D(^DIC(6,AVA6,0))  ;skip good entries
 .Q:'$D(^DIC(6,AVA6,9999999))  I $P(^(9999999),U,9)]""  D  ;PATCH 6
 ..K ^DIC(6,"GIHS",$P(^DIC(6,AVA6,9999999),U,9),AVA6) ;kill xref PATCH 6
 .K ^DIC(6,AVA6) ;kill bad entry in file 6
 .S AVA200=$P($G(^DIC(16,AVA6,"A3")),U) ;ifn in file 200
 .Q:AVA200=""  Q:'$D(^VA(200,AVA200,0))  ;no entry in file 200
 .Q:$P($G(^DIC(3,AVA200,0)),U,16)'=AVA6  ;bad pointers
 .S AVACLS=$P($G(^VA(200,AVA200,"PS")),U,5) ;IHS/ORDC/LJF PATCH 5
 .Q:AVACLS=""  ;no provider class entered
 .;
 .S DIE="^VA(200,",DA=AVA200,DR="53.5///@" D ^DIE
 .S DR="53.5////"_AVACLS D ^DIE
 .;
 .W !,"NEW PERSON entry #",AVA200," creating entry in file 6"
 ;
 W !!,"CLEANUP COMPLETE",!
 ;
EOJ ;     
 K AVA6,AVA200,DIR,DIE,DA,DR,X,Y
 Q
