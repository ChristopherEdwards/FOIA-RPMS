BEXNTEG ;CMI/BJI/DAY - Package checksum checker ;3100615.214728 [ 06/15/2010  10:07 PM ]
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**1,2,3,4**;DEC 01, 2009
 ;;7.3;3100615.214728
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
BEX2ENV ;;927014
BEX80 ;;570752
BEXPST ;;1780918
BEXRDAT ;;9944553
BEXRDOW ;;5350642
BEXRHOR ;;10385216
BEXRREJ ;;9254899
BEXRRPH ;;5753463
BEXRSRT ;;9708951
BEXRUTL ;;1006070
BEXRX ;;19364782
BEXRX7 ;;31153487
