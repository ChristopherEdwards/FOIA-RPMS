ACHSYSR ; IHS/ITSC/PMF - display database record for given PO; [ 10/16/2001  10:13 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; Displays raw database record for a given PO
 ;
 S U="^",CM=",",QT=""""
 ;
 S STOP=0
 F  D START Q:STOP
 Q
 ;
START ;
 W !!!!!!!!!!!!!!!!!!!!!!!!!
 D YEAR I STOP Q
 D NUM I STOP Q
 D SHOW
 Q
 ;
 ;
YEAR ;
 W !!,"year:",?22
 D READ^ACHSFU
 I Y="" S STOP=1 Q
 I Y'?1N W "  one digit please" G YEAR
 S YEAR=Y
 Q
NUM ;
 W !!,"number:",?22
 D READ^ACHSFU
 I Y="" S STOP=1 Q
 I Y'?5N W "  five digits please" G NUM
 S NUM=Y
 Q
 ;
SHOW ;
 W !!!!!!!
 S SS=1_YEAR_NUM
 K LIST
 S FAC=0 F  S FAC=$O(^ACHSF(FAC)) Q:'FAC  I $D(^ACHSF(FAC,"D","B",SS)) S LIST=$G(LIST)+1,LIST(FAC,$O(^ACHSF(FAC,"D","B",SS,"")))=""
 I 'LIST W !!,"NOT FOUND" Q
 ;
 S FAC=$O(LIST("")),SS=$O(LIST(FAC,""))
 S GLOB="^ACHSF("_FAC_CM_QT_"D"_QT_CM_SS_")"
 F  S GLOB=$Q(@GLOB) Q:GLOB=""  Q:GLOB'[SS  W !!,GLOB,"=",@GLOB
 W !!!
 I $$DIR^XBDIR("E","Press RETURN...")
 Q
