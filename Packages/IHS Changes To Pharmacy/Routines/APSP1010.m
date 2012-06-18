APSP1010 ;ISC/XTSUMBLD KERNEL - Package checksum checker ;14-Feb-2011 08:28;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;;DEC 11, 2003
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
APSPMULT ;;12029547
APSQSIGN ;;9020511
APSPLBL1 ;;8288959
APSPFUNC ;;9417381
PSORENW ;;20907153
PSORFL ;;7005044
PSOLLLI ;;28061933
PSORXL1 ;;24100351
APSPPCC1 ;;6773772
APSPPCC ;;12809879
