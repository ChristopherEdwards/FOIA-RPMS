ACPT24P2 ; IHS/ASDST/DMJ,SDR - CPT POST INIT ;      [ 02/03/2004  11:07 AM ]
 ;;2004;CPT FILES;**2**;DEC 31, 2003
 ;
 ; Fixes problem with modifiers not having complete description
 ;
 ;
START ;START HERE
 I '$G(DT) D NOW^%DTC S DT=X
 S ACPTYR=3040000
 W $$EN^ACPTVDF("IOF")
 W !!,"CPT Version 2.04 Install",!
 D MSG
 K DIR S DIR(0)="E" D ^DIR K DIR Q:Y'=1
 D DIR
 D MREAD  ;mod
 D XREFM
 ;
 D:'$D(^XT(8984.4,81,0)) ADD81
 D UPKG
 W !!,"INSTALL COMPLETE",!!
 S DIR(0)="E" D ^DIR
 K DIR,ACPT,ACPTYR
 Q
INA ;set date deleted for all codes
 W !!,"Updating Year Deleted Field.",!
 F  S I=$O(^ICPT(I)) Q:I>ACPTTO!('I)  D
 .Q:$P($G(^ICPT(I,0)),"^",7)
 .S $P(^ICPT(I,0),"^",7)=ACPTYR
 .D DOTS(I)
 K ACPTTO
 Q
DOTS(X) ;EP - WRITE OUT A DOT EVERY HUNDRED
 U IO(0)
 W:'(X#100) "."
 Q
MREAD ;READ AND UPDATE MODIFIERS AND P-CODES
 ;S ACPTFL="acpt2004.m"  ;IHS/SD/SDR 2/3/2004
 S ACPTFL="acpt2004.02m"  ;IHS/SD/SDR 2/3/2004
 W !!,"Reading MODIFIER file, file name ",ACPTFL,!
 D OPEN^%ZISH("CPTSFILE",ACPTPTH,ACPTFL,"R")
 I POP U IO(0) W !,"Could not open modifier and p-code file." Q
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH
 .U IO R X Q:$$STATUS^%ZISH
 .I $E(X,1)'="-" Q
 .S ACPTCD=$E(X,2,3)
 .S DESC=$E($P(X,": ",1),4,$L(X))
 .;S DESC=$E(DESC,5,$L(DESC))  ;IHS/SD/SDR 2/3/2004
 .S DESC=$E(DESC,2,$L(DESC))  ;IHS/SD/SDR 2/3/2004
 .S ACPTCDN=$S(ACPTCD=+ACPTCD:ACPTCD,1:$A($E(ACPTCD,1))_$A($E(ACPTCD,2)))
 .I '$D(^AUTTCMOD(ACPTCDN)) D
 ..S ^AUTTCMOD(ACPTCDN,0)=ACPTCD
 .S $P(^AUTTCMOD(ACPTCDN,0),"^",2)=DESC
 .D DOTS(ACPTCNT)
 D ^%ZISC
 Q
 ;
DIR ;ASK DIRECTORY WHERE FILES WERE LOADED
 W !
 S DIR(0)="F",DIR("A")="Enter directory where CPT files are located."
 S DIR("B")="/usr/spool/uucppublic/"
 D ^DIR K DIR
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIRUT)
 I ^%ZOSF("OS")["UNIX" D
 .S Y=$TR(Y,"\","/")
 .S:$E(Y)'="/" Y="/"_Y
 .S:$E(Y,$L(Y))'="/" Y=Y_"/"
 I ^%ZOSF("OS")'["UNIX" D
 .S Y=$TR(Y,"/","\")
 .I $E(Y)'="\",Y'[":" S Y="\"_Y
 .S:$E(Y,$L(Y))'="\" Y=Y_"\"
 S ACPTPTH=Y
 Q
FILE ;ASK FOR FILE NAME
 W !
 S DIR(0)="F"
 D ^DIR K DIR
 S Y=$TR(Y,"/\")
 S ACPTFL=Y
 Q
DESC ;STRIP TRAILING BLANKS FROM DESCRIPTION FIELD
 S ACPTDESC=""
 N I F I=0:1:31 S A=$TR(A,$C(I))
 N I F I=1:1:$L(A," ") D
 .S ACPTWORD=$P(A," ",I)
 .Q:ACPTWORD=""
 .S:I>1 ACPTDESC=ACPTDESC_" "
 .S ACPTDESC=ACPTDESC_ACPTWORD
 K ACPTWORD
 Q
CAT(Z) ;SET CPT CATEGORY
 S ACPTCAT=Z
 I '$D(^DIC(81.1,"ACPT",Z)) D
 .S ACPTCAT=$O(^DIC(81.1,"ACPT",ACPTCAT),-1)
 S ACPTCAT=$O(^DIC(81.1,"ACPT",ACPTCAT,0))
 S $P(^ICPT(Z,0),"^",3)=ACPTCAT
 K ACPTCAT
 Q
ADD81 ;ADD FILE 81 TO LOCAL LOOKUP FILE
 S DLAYGO=8984.4
 W !!,"ADDING CPT FILE TO LOCAL LOOKUP FILE" D
 .I '$D(^DIC(8984.4)) W !,"LOCAL LOOKUP FILE (FILE 8984.4) MISSING.",! Q
 .S DIC="^XT(8984.4,",DIC(0)="LX",X=81 D ^DIC
 .Q:Y<0  S DA=+Y,DIE=DIC,DR=".03////C" D ^DIE
 .W !,"FILE 81 ADDED.",!
 K DLAYGO
 Q
XREFM ;RE-CROSS REFERENCE FILE
 W !,"WILL NOW RE-INDEX MODIFIER FILE.",!
 S DIK="^AUTTCMOD(" D IXALL^DIK
 Q
MSG ;display message
 F I=1:1 D  Q:ACPTTXT["***end***"
 .S ACPTTXT=$P($T(TXT+I),";;",2)
 .Q:ACPTTXT["end"
 .I ACPTTXT="NOTE:" W $$EN^ACPTVDF("RVN")
 .W !,ACPTTXT
 .I ACPTTXT="NOTE:" W $$EN^ACPTVDF("RVF")
 K ACPTTXT
 Q
TXT ;text lines
 ;;CPT version 2.04 patch 2 contains corrections for 2004 CPT
 ;;modifiers.  The install will attempt to read the Modifiers
 ;;file (acpt2004.m) and update the description to be correct. 
 ;;
 ;;***end***
 Q
UPKG ;update package file
 I '$G(DUZ) D
 .S DUZ=1
 .S DUZ(0)="@"
 I '$G(DT) D
 .D NOW^%DTC
 .S DT=$P(%,".",1)
 S DA=$O(^DIC(9.4,"C","ACPT",0))
 Q:'DA
 S DIE="^DIC(9.4,"
 S DR="13///2.04"
 D ^DIE
 S DA(1)=DA
 S X=2.04
 S DIC="^DIC(9.4,DA(1),22,"
 S DIC(0)="LX"
 D ^DIC
 Q:+Y<0
 S DA=+Y
 S DIE=DIC
 S DR="1///3031231;2///"_DT_";3///`"_DUZ
 D ^DIE
 Q
