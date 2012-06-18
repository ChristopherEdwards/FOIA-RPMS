ACHSR ; IHS/ITSC/PMF - for export testing  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 Q
 ;
 ;
FOO ;
 S FAC=0 F  S FAC=$O(^ACHSF(FAC)) Q:FAC=""  D
 . S A="XPR" F  S A=$O(^ACHSF(FAC,A)) Q:A=""  Q:$E(A,1,4)'="XPRT"  W !,A  K ^(A)
 . Q
 ;
 S A="" F  S A=$O(^ACHSXPRT(A)) Q:A=""  K ^(A)
 W !,"ACHSXPRT killed"
 ;
 W !!
 K ^ACHSTXST(4)
 S PMF="" F  S PMF=$O(^ACHSTXST(PMF)) Q:PMF=""  K ^ACHSTXST(PMF,4) S PMF2="" F  S PMF2=$O(^ACHSTXST(PMF,PMF2)) Q:PMF2=""  K ^ACHSTXST(PMF,PMF2,4)
 ;
 Q
