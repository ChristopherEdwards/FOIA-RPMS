LR6NTEG4 ; IHS/DIR/FJE - KERNEL - Package checksum checker APR 24, 1996@10:36:08 ;
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;0.0;
 ;;1.0;APR 24, 1996@10:36:08
 S Z=^%ZOSF("RSUM"),SGT=0
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 Z W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
LRXOS1 ;;3868247
LRXREF ;;9255866
LRXREF1 ;;7533129
