DGPTF5 ;ALB/MTC - PTF ENTRY/EDIT-4 ; 07 JUN 91 
 ;;5.3;Registration;;Aug 13, 1993
 ;
Z I 'DGN S Z=$S(IOST="C-QUME"&($L(DGVI)'=2):Z,1:"["_Z_"]") W @DGVI,Z,@DGVO
 E  W "   "
 Q
 ;
Z1 F I=1:1:(Z1-$L(Z)) S Z=Z_" "
 W Z
 Q
 ;
CEN ;
 W !!,*7,"Record #",PTF," MUST be closed for CENSUS first.",!
ASK W !,"Would you like to close this record for CENSUS" S %=2 D YN^DICN
 I '% W !?5,"Answer 'YES' to close record for CENSUS also",!?5,"  or   'NO'  to not close this record at all." G ASK
 I %=1 S Y=2 D RTY^DGPTUTL D CLS^DGPTC1
 K DGRTY,DGRTY0 Q
