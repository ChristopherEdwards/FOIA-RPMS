BLR1009P ;POST LR PATCH 9 TO FIX .90 MODIFIER IN LAB CPT FILE[ 10/05/1999  9:28 AM ]
 ;;5.2;BLR;**1009**;SEP 1, 1999
 ;
ASK ;ASK USER TO CONVERT
 W !,"Do you want to convert the IHS LAB CPT FILE MODIFIERS from .90 to 90?" S %=1 D YN^DICN G:%<0 EOJ W:%=0 !,"Answer NO if you are unsure, or '^' to quit.",! G:%=0 ASK
 I %=1 G OK
 W !,"You can run this fix at a later date (D ^BLR1009P )",!! Q
 ;
 ;
OK W !,"Is everything OK" S %=2 D YN^DICN G:%<0 EOJ W:%=0 !,"Answer NO if you are unsure, or '^' to quit.",! G:%=0 ASK
 I %=2 G ASK
 W !!,"This will take about one minute..."
BEGIN ;
 S LRENT=0 D A1
 W !!,"The entries have been changed...",!!
 D EOJ
 Q
A1 ;get entry
 F  S LRENT=$O(^BLRCPT(LRENT)) Q:+LRENT<1  S LRCPT=0 D A2
 Q
 ;
A2 ;get CPT
 F  S LRCPT=$O(^BLRCPT(LRENT,11,LRCPT)) Q:(+LRCPT<1)  S LRMOD=0 D A3
 Q
 ;
A3 ;get MODIFIER
 F  S LRMOD=$O(^BLRCPT(LRENT,11,LRCPT,1,LRMOD)) Q:(+LRMOD<1)  D A4
 Q
 ;
A4 ;deletes .90 entry and adds 90 entry
DELETE ;delete old entry
 Q:$P(^BLRCPT(LRENT,11,LRCPT,1,LRMOD,0),U,1)'=".90"
 S DA(2)=LRENT,DA(1)=LRCPT,DA=LRMOD,DIK="^BLRCPT("_DA(2)_",11,"_DA(1)_",1," D ^DIK
 W "."
ENTER ;enter new entry 
 K DD,DO S DA(2)=LRENT,DA(1)=LRCPT,DA=LRMOD
 S DIC="^BLRCPT(DA(2),11,DA(1),1,",DIC(0)="LN",X=90
 S DIC("DR")="101///^S X=90" D FILE^DICN
 Q
EOJ ;kill
 K LRENT,LRCPT,LRMOD
 Q
