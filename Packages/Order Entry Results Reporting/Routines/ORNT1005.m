ORNT1005 ;ISC/XTSUMBLD KERNEL - Package checksum checker ;3100422.090713
 ;;1.0;ORDER ENTRY/RESULTS REPORTING;;Apr 22,2010
 ;;7.3;3100422.090713
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
ORQ21 ;;12327656
ORCACT0 ;;23142342
ORWDXC ;;6414983
ORCHECK ;;13992173
ORCSAVE2 ;;12931174
ORWRA ;;3153456
ORDV03 ;;13488364
ORDV08 ;;8565204
ORKCHK ;;9662147
ORKCHKM ;;11215365
ORWDXR ;;10903407
ORMPS1 ;;18841065
ORM ;;7562263
ORQ11 ;;21693162
ORWDXA ;;15309444
ORCMEDT0 ;;9116354
ORKCHK6 ;;11071658