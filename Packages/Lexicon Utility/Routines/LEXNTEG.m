LEXNTEG ;ISC/XTSUMBLD KERNEL - Package checksum checker ;3120222.110716
 ;;0.0;;;;Build 10
 ;;7.3;3120222.110716
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
LEXILG ;;1908644
LEXILGD ;;4604087
LEXILGO ;;4598594
LEXILGP ;;4268180
LEXILGU ;;4228795
LEXILGX ;;4894297
LEXLGM ;;9295475
LEXLGM2 ;;5606949
LEXLGM3 ;;3980869
LEXPL ;;8475760
LEXPLEM ;;10204594
LEXPLIA ;;3621484
LEXPLUP ;;3461727
LEXXST ;;20978655
LEXXST2 ;;10265987
LEXXST3 ;;8370313
LEXXST4 ;;9728890