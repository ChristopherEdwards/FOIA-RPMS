BGONTEG6 ;ISC/XTSUMBLD KERNEL - Package checksum checker ;3100707.144728
 ;;1.1;BGO COMPONENTS;;Jul 07,2010
 ;;7.3;3100707.144728
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
BGOFHLK ;;1347458
BGOFHX ;;3976033
BGOICDLK ;;1965893
BGOPROB ;;8538553
BGOREL ;;3788115
BGOREP ;;6755159
BGOUTL ;;9297118
BGOUTL2 ;;6891986
BGOVCPT ;;11938990
BGOVCPT2 ;;3545529
BGOVHF ;;4118557
BGOVIMM ;;18439719
BGOVPED ;;11902277
BGOVPOV ;;12250490
BGOVSK ;;8666124
BGOTRG ;;6661674
BGOASLK ;;2227692
BGOVAST ;;2209918
BGOVIMM2 ;;4698042
BGOREPCV ;;1461472
BGOVIF ;;817412