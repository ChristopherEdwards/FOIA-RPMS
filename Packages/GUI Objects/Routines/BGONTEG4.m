BGONTEG4 ;ISC/XTSUMBLD KERNEL - Package checksum checker ;3080210.083849
 ;;1.1;BGO COMPONENTS;;Sep 18,2007
 ;;7.3;3080210.083849
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
BGOCC ;;2950778
BGOEDTP2 ;;1141002
BGOUTL ;;8539088
BGOVHF ;;4044651
BGOVCPT ;;10583076
BGOVIMM2 ;;4442934
BGOVIMM ;;11176856
BGOVPOV ;;10189404
BGOVSK ;;4663356
BGOTRG ;;5087649
BGOCPTP2 ;;8056034
BGOEDTPR ;;2325600
BGOVPED ;;10811168
