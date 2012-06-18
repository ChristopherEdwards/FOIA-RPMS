XUINTSK4 ;SEA/RDS-TaskMan: Conversion, ^%ZIS, Part 3 ;6/24/91  10:23 ;
 ;;7.0;Kernel;;Jul 17, 1992
 ;
EVERY ;Code executed every time conversion is done
 W !,"Now I will update 14.5, 14.6, and 14.7 based on this volume set and cpu.",!?5
E D VOLUME,UCI,LINK,CVPAIR
 S ZT1=0 F ZT=0:0 S ZT1=$O(^%ZIS(14.5,ZT1)) Q:'ZT1  S ZTS=^(ZT1,0),ZTM=$P(ZTS,U,6) D MGR I ZTM="" K DD,DO S DIE="^%ZIS(14.5,",DA=ZT1,DR=".01:7" D ^DIE W !?5,"." S ZT1=0
 W !?5,"All done."
 K %,%Y,C,D,D0,DA,DD,DI,DIC,DICR,DIE,DIG,DIH,DISYS,DIU,DIV,DIW,DQ,DR,DTOUT,DUOUT,X,Y,ZT,ZT1,ZT2,ZT3,ZT4,ZT7,ZTDEF,ZTDINUM,ZTENV,ZTF01,ZTF1,ZTF2,ZTF3,ZTF4,ZTF5,ZTF6,ZTF7,ZTI,ZTM,ZTM1,ZTM2,ZTMAST,ZTN,ZTPAIR,ZTS,ZTU,ZTUCI,ZTV,ZTVI,ZTVOL,ZTXMB
 Q
 ;
VOLUME ;EVERY--make sure the current volume set has been filed
 S ZTV=$P(ZTENV,U,2)
 S ZTVI=$O(^%ZIS(14.5,"B",ZTV,""))
 I ZTVI]"" Q
 K DD,DO S DIC="^%ZIS(14.5,",DIC(0)="L",X=ZTV D FILE^DICN
 K DD S DIE=DIC,DA=$P(Y,U),ZTVI=DA,DR=".01:7" D ^DIE
 W "."
 Q
 ;
UCI ;EVERY--make sure all ucis on this volume set are filed
 I ^%ZOSF("OS")'["DSM" Q
 S X="NOUCI^XUINTSK4",@^%ZOSF("TRAP")
 F ZT1=1:1 S ZTU=$P($ZU(ZT1),",") Q:ZTU=""  I $O(^%ZIS(14.6,"AV",ZTV,ZTU,""))="" D ADDUCI
NOUCI Q
 ;
ADDUCI ;UCI--add a uci on this volume set to file 14.6
 K DO S DIC="^%ZIS(14.6,",DIC(0)="L",X=ZTU
 S DINUM=$P(^%ZIS(14.6,0),U,3)+1
 F ZT=0:0 Q:'$D(^%ZIS(14.6,DINUM))  S DINUM=DINUM+1
 S $P(^%ZIS(14.6,0),U,3)=DINUM,ZTDINUM=DINUM
 K DD D FILE^DICN
 K DD S DIE=DIC,DA=ZTDINUM,DR="1////"_ZTVI D ^DIE
 K DINUM W "."
 Q
 ;
LINK ;EVERY--make sure LINK node entries are filed and cleaned out
 S ZT1="" F ZT=0:0 S ZT1=$O(^%ZTSCH("LINK",ZT1)) Q:ZT1=""  D CHECK I $O(^%ZTSCH("LINK",ZT1,""))="" K ^%ZTSCH("LINK",ZT1)
 Q
 ;
CHECK ;LINK--ensure a link entry is filed
 S ZTI=$O(^%ZIS(14.5,"B",ZT1,""))
 I ZTI]"" Q
 K DD,DO S DIC="^%ZIS(14.5,",DIC(0)="L",X=ZT1 D FILE^DICN
 K DD S DIE=DIC,DA=$P(Y,U),DR=".01:7" D ^DIE
 W "."
 Q
 ;
CVPAIR ;EVERY--file record for current cpu-volume pair
 S ZTPAIR=$P(ZTENV,U,4)
 S ZTI=$O(^%ZIS(14.7,"B",ZTPAIR,""))
 I ZTI]"" Q
 S ZTDEF=$S($D(@(ZTXMB_"(1,1,3)"))#2:^(3),1:"")
 S ZTS=$S($D(@(ZTXMB_"(1,1,4,ZTVI,0)"))#2:^(0),1:"")
 S ZTF01=ZTPAIR
 S ZTF1=$P(ZTS,U,6),ZTF1=$S(ZTF1="":"N",ZTF1="n":"N",ZTF1="y":"Y",1:"N")
 S ZTF2="N"
 S ZTF3=$P(ZTDEF,U,3),ZTF3=$S(ZTF3="":"",ZTF3<1:"",ZTF3>10:"",1:ZTF3\1)
 S ZTF4=$P(ZTDEF,U,4),ZTF4=$S(^%ZOSF("OS")["VAX DSM":"",^%ZOSF("OS")'["DSM":"",ZTF4="":"",ZTF4<1:"",ZTF4>3:"",1:ZTF4\1+1*8)
 S ZTF5=$P(ZTDEF,U,5),ZTF5=ZTF5\1
 S ZTF6=$P(ZTS,U,7),ZTF6=$S(ZTF6:"////"_ZTF6,1:"")
 S ZTF7=$P(ZTDEF,U,6),ZTF7=+ZTF7
 K DD,DO S DIC="^%ZIS(14.7,",DIC(0)="L",X=ZTPAIR D FILE^DICN
 S DIE=DIC,DA=$P(Y,U)
 S DR="1////"_ZTF1_";2////"_ZTF2_";3////"_ZTF3_";4////"_ZTF4_";5////"_ZTF5_";6"_ZTF6_";7////"_ZTF7
 I ZTF6="" W !!,"For cpu-volume pair ",ZTPAIR,!,"-------------------------------"
 K DD D ^DIE I ZTF6="" W !
 W "."
 Q
 ;
MGR ;EVERY--ensure MGR ucis are filed
 I ZTM="" Q
 S ZTN=$P(ZTS,U)
 S ZTI=$O(^%ZIS(14.6,"AV",ZTN,ZTM,""))
 I ZTI]"" Q
 S DINUM=$P(^%ZIS(14.6,0),U,3)+1
 F ZT=0:0 Q:'$D(^%ZIS(14.6,DINUM))  S DINUM=DINUM+1
 S $P(^%ZIS(14.6,0),U,3)=DINUM
 K DD,DO S DIC="^%ZIS(14.6,",DIC(0)="L",X=ZTM D FILE^DICN
 K DD S DIE=DIC,DA=$P(Y,U),DR="1////"_ZT1 D ^DIE W "."
 K DINUM Q
 ;
