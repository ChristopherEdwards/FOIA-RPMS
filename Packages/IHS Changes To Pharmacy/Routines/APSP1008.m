APSP1008 ;ISC/XTSUMBLD KERNEL - Package checksum checker ;3091117.131041
 ;;7.0;IHS PHARMACY MODIFICATIONS;;Nov 17,2009
 ;;7.3;3091117.131041
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
APSPFNC2 ;;20243724
APSPES1 ;;17969086
APSPES2 ;;10398931
APSPES9 ;;10036153
PSOORFI1 ;;41217805
PSORXVW ;;34777230
APSPDIR ;;13301139
PSOORNEW ;;38192333
PSOORNE4 ;;35858615
PSONEW1 ;;12009763
PSONEW3 ;;8103788
PSOORNE2 ;;37656120
PSOORNE3 ;;49210277
PSORENW3 ;;25006422
PSORXPR ;;22181237
APSPELRX ;;8119309
APSPES3 ;;5983252
PSGMAR3 ;;10211382
PSGMMAR2 ;;15201755
PSGMMAR4 ;;5959807
PSODIR1 ;;34685018
PSON52 ;;23735798
APSPDRX ;;8539564
APSPCTR ;;11677329
APSPCTR1 ;;10888370
PSODIR2 ;;10988403
PSODIR3 ;;5348760
APSPFUNC ;;8816275
APSPDR3 ;;5046710
APSPDR4 ;;4272300
APSPDUR ;;6801513
APSPDUR1 ;;3192661
APSPTDD ;;8714875
APSPTDD1 ;;2755525
APSPCSM ;;16203066
PSOOREDT ;;27807720
APSPPCC ;;12122892
PSOSIGMX ;;10249545
PSOORRNW ;;14805564
PSOSUTL ;;30476077
PSOSULBL ;;20793756
PSOSUSRP ;;11961425
PSOLLL4 ;;4975448
APSPRRTS ;;15099559
APSPSITE ;;8203552
APSEPPIM ;;3800246
PSOORED1 ;;26802667
PSOORNW2 ;;23799613
APSPLBL ;;29985259
PSOSULOG ;;25016159
APSPNE4 ;;23732673
PSORXL ;;36171244
PSOSULB1 ;;14225719
APSPAUTO ;;19948049
PSOLLLI ;;28036416
PSOLLL1 ;;23523351
APSPESLM ;;14797834
APSPESLP ;;19888149
APSPESLR ;;7656160
PSXVND ;;18358315
PSORENW0 ;;27870508