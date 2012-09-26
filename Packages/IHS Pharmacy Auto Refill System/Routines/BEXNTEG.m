BEXNTEG ;ISC/XTSUMBLD KERNEL - Package checksum checker ;3120312.212552
 ;;0.0;;;;Build 1
 ;;7.3;3120312.212552
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
BEX5ENV ;;926384
BEXRDAT ;;9935979
BEXRDOW ;;5342068
BEXREXC ;;7390695
BEXRHOR ;;10376642
BEXRQUE ;;8085563
BEXRREJ ;;9246325
BEXRRPH ;;5745821
BEXRSRT ;;9988845
BEXRUTL ;;1237155
BEXRX7 ;;26358948
