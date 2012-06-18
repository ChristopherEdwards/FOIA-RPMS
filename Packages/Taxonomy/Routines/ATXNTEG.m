ATXNTEG ;ISC/XTSUMBLD KERNEL - Package checksum checker ;3070828.111557 [ 08/28/2007  11:16 AM ]
 ;;5.1;TAXONOMY;**10**;EB 04, 1997
 ;;0.0;
 ;;7.3;3070828.111557
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
ATX50P6 ;;13551083
ATX50P61 ;;4717572
ATX50P7 ;;13664540
ATX50P71 ;;4941754
ATX51P2 ;;83420
ATXBULL ;;11740571
ATXCHK ;;1369726
ATXCODE ;;11904667
ATXCODE0 ;;7576951
ATXDEL ;;4249337
ATXDELA ;;3400216
ATXGE ;;6159314
ATXGU ;;14814686
ATXGUA ;;10659319
ATXPOV ;;6052354
