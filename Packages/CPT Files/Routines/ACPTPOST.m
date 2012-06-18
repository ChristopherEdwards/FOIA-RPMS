ACPTPOST ; IHS/ASDST/DMJ,SDR - CPT POST INIT ;      [ 02/03/2004  11:05 AM ]
 ;;2.08;CPT FILES;;DEC 17, 2007
 ;
 ;
START ;START HERE
 I '$G(DT) D NOW^%DTC S DT=X
 S ACPTYR=3080000
 W $$EN^ACPTVDF("IOF")
 W !!,"CPT Version 2.08 Install",!
 D MSG
 K DIR S DIR(0)="E" D ^DIR K DIR Q:Y'=1
 D DIR
 S I=99,ACPTTO=99999 D INA
 S I=4848484969,ACPTTO=5248494971 D INA
 ;S I=9990002,ACPTTO=9990003 D INA  ;inactivate erroneous code 0003T
 ;S I=9990007,ACPTTO=9990008 D INA  ;inactivate erroneous code 0008T
 ;S I=9990017,ACPTTO=9990018 D INA  ;inactivate erroneous code 0018T
 ;S I=9990020,ACPTTO=9990021 D INA  ;inactivate erroneous code 0021T
 ;S I=9990043,ACPTTO=9990044 D INA  ;inactivate erroneous code 0044T
 D SREAD  ;short desc.
 D LREAD  ;long desc.
 ;S I=99999,ACPTTO=999999 D INA  ;HCPCS inactivation
 ;D HREAD  ;hcpcs
 D MREAD  ;mod
 D MOD^ACPTPST2  ;hcpc mod
 ;D GROUPS  ;loads current group/ASC codes
 D XREF
 D XREFM
 ;D FIXCPT^ACPTPST2  ;acpt*2.06*1
 ;
 D:'$D(^XT(8984.4,81,0)) ADD81
 I ACPTYR>DT D QUE
 I ACPTYR<DT D
 .W !!,"Will now activate new codes, de-activate deleted codes.",!
 .D ^ACPTSINF
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
SREAD ;READ AND UPDATE SHORT DESC.
 S ACPTFL="acpt2008.s"
 W !!,"Reading SHORT description file, file name ",ACPTFL,!
 D OPEN^%ZISH("CPTSFILE",ACPTPTH,ACPTFL,"R")
 I POP U IO(0) W !,"Could not open short description file." Q
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH
 .U IO R X Q:$$STATUS^%ZISH
 .S ACPTCD=$P(X," ",1)
 .I ACPTCD?4N1"T"!(ACPTCD?4N1"F") D CAT2S Q
 .Q:ACPTCD'?5N
 .S A=$P(X," ",2,999) D DESC
 .I '$D(^ICPT(+ACPTCD)) D
 ..S ^ICPT(+ACPTCD,0)=ACPTCD
 ..S $P(^ICPT(+ACPTCD,0),"^",6)=ACPTYR
 ..S:ACPTYR>DT $P(^ICPT(+ACPTCD,0),"^",4)=1
 ..K DIC
 ..S DA(1)=ACPTCD
 ..S DIC="^ICPT("_DA(1)_",60,"
 ..S DIC(0)="L"
 ..S DIC("P")=$P(^DD(81,60,0),"^",2)
 ..S X="01/01/2008"
 ..S DIC("DR")=".02////1"
 ..D ^DIC
 .S $P(^ICPT(+ACPTCD,0),"^",2)=ACPTDESC
 .S:$P(^ICPT(+ACPTCD,0),"^",6)<DT $P(^ICPT(+ACPTCD,0),"^",4)=""
 .S $P(^ICPT(+ACPTCD,0),"^",7)=""
 .D CAT(ACPTCD)
 .D DOTS(ACPTCNT)
 D ^%ZISC
 Q
 ;
LREAD ;READ AND UPDATE LONG DESC.
 S ACPTFL="acpt2008.l"
 W !!,"Reading LONG description file, file name ",ACPTFL,!
 D OPEN^%ZISH("CPTLFILE",ACPTPTH,ACPTFL,"R")
 I POP U IO(0) W !,"Could not open long description file." Q
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH
 .U IO R X Q:$$STATUS^%ZISH
 .S ACPTCD=$E(X,1,5)
 .I ACPTCD?4N1"T"!(ACPTCD?4N1"F") D CAT2L Q
 .Q:ACPTCD'?5N
 .S ACPTLN=$E(X,6,7)
 .S A=$P(X," ",2,999) D DESC
 .I '$D(^ICPT(+ACPTCD)) D
 ..S ^ICPT(+ACPTCD,0)=ACPTCD
 ..S $P(^ICPT(+ACPTCD,0),"^",6)=ACPTYR
 ..S:ACPTYR>DT $P(^ICPT(+ACPTCD,0),"^",4)=1
 ..K DIC
 ..S DA(1)=ACPTCD
 ..S DIC="^ICPT("_DA(1)_",60,"
 ..S DIC(0)="L"
 ..S DIC("P")=$P(^DD(81,60,0),"^",2)
 ..S X="01/01/2008"
 ..S DIC("DR")=".02////1"
 ..D ^DIC
 .I +ACPTLN=1 D
 ..K ^ICPT(+ACPTCD,"D")
 ..S ^ICPT(+ACPTCD,"D",0)="^81.01A^^"
 .S ^ICPT(+ACPTCD,"D",+ACPTLN,0)=ACPTDESC
 .S $P(^ICPT(+ACPTCD,"D",0),"^",3,4)=+ACPTLN_"^"_+ACPTLN
 .D DOTS(ACPTCNT)
 D ^%ZISC
 Q
 ;
HREAD ;READ HCPCS FILE
 K ACPTCD,ACPTFLAG,ACPTIEN,ACPTDESC
 S ACPTCSV=""
 W !,"Installing ",$E(ACPTYR,1,3)+1700," HCPCS codes.",!
 ;S ACPTFL="acpt2006.h"  ;acpt*2.07*1
 S ACPTFL="acpt2007.01h"  ;acpt*2.07*1
 D OPEN^%ZISH("CPTHFILE",ACPTPTH,ACPTFL,"R")
 I POP U IO(0) W !,"Could not open HCPCS file." Q
 U IO(0) W !,"Reading HCPCS Codes File.",!
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH
 .U IO R X Q:$$STATUS^%ZISH
 .S ACPTCD=$E(X,1,5)
 .I ACPTCD=ACPTCSV S ACPTFLAG=1
 .Q:ACPTCD'?1U4N
 .;S ACPTLNE=$E(X,6,10)  ;acpt*2.07*1
 .;S ACPTACDE=$E(X,293)  ;action code  ;acpt*2.07*1
 .S ACPTACDE=$E(X,6)  ;action code  ;acpt*2.07*1
 .Q:ACPTACDE=""  ;no action code
 .;Q:ACPTACDE="N"  ;no change to code  ;acpt*2.07*1
 .;Q:ACPTACDE="P"  ;payment change-not stored  ;acpt*2.07*1
 .;I ACPTACDE="D" D  Q  ;delete code and quit  ;acpt*2.07*1
 .;.S ACPTIEN=$A($E(ACPTCD))_$E(ACPTCD,2,5)  ;acpt*2.07*1
 .;.I $G(^ICPT(ACPTIEN,0))="" S ACPTIEN=$O(^ICPT("B",ACPTCD,0))  ;acpt*2.07*1
 .;.Q:+ACPTIEN=0  ;acpt*2.07*1
 .;.Q:$P($G(^ICPT(ACPTIEN,0)),"^",7)  ;acpt*2.07*1
 .;.S $P(^ICPT(ACPTIEN,0),"^",7)=ACPTYR  ;acpt*2.07*1
 .;S A=$E(X,7,40) D DESC S ACPTSD=ACPTDESC  ;acpt*2.06*1
 .;S A=$E(X,42,299) D DESC S ACPTLD=ACPTDESC  ;acpt*2.06*1
 .;S A=$E(X,92,119) D DESC S ACPTSD=ACPTDESC  ;acpt*2.06*1  ;acpt*2.07*1
 .S A=$E(X,7,41) D DESC S ACPTSD=ACPTDESC  ;acpt*2.07*1
 .;S A=$E(X,12,91) D DESC S ACPTLD=ACPTDESC  ;acpt*2.06*1  ;acpt*2.07*1
 .S A=$E(X,42,975) D DESC S ACPTLD=ACPTDESC  ;acpt*2.07*1
 .;if no entry in CPT file
 .I '$D(^ICPT("B",ACPTCD)) D
 ..S ACPTIEN=$A($E(ACPTCD))_$E(ACPTCD,2,5)
 ..S ^ICPT(ACPTIEN,0)=ACPTCD
 ..S ^ICPT("B",ACPTCD,ACPTIEN)=""
 ..S $P(^ICPT(ACPTIEN,0),"^",6)=ACPTYR
 ..S:ACPTYR>DT $P(^ICPT(ACPTIEN,0),"^",4)=1
 ..K DIC
 ..S DA(1)=ACPTIEN
 ..S DIC="^ICPT("_DA(1)_",60,"
 ..S DIC(0)="L"
 ..S DIC("P")=$P(^DD(81,60,0),"^",2)
 ..S X="01/01/2007"
 ..S DIC("DR")=".02////1"
 ..D ^DIC
 .;get IEN and edit existing entry
 .S ACPTIEN=$O(^ICPT("B",ACPTCD,0))
 .Q:ACPTIEN'>0
 .;start old code acpt*2.07*1
 .;I +ACPTLNE=100 D
 .;.K ^ICPT(ACPTIEN,"D")
 .;.S ^ICPT(ACPTIEN,"D",0)="^81.01A^^"
 .;S ACPTLN=$E(ACPTLNE,3)
 .;S ^ICPT(ACPTIEN,"D",+ACPTLN,0)=ACPTLD
 .;S $P(^ICPT(ACPTIEN,"D",0),"^",3,4)=+ACPTLN_"^"_+ACPTLN
 .;end old code acpt*2.07*1
 .;start new code acpt*2.07*1
 .S ^ICPT(ACPTIEN,"D",1,0)=ACPTLD
 .S $P(^ICPT(ACPTIEN,"D",0),"^",3,4)=1_"^"_1
 .;end new code acpt*2.07*1
 .S:ACPTSD'="" $P(^ICPT(ACPTIEN,0),"^",2)=ACPTSD
 .S $P(^ICPT(ACPTIEN,0),"^",7)=""
 .;start new code acpt*2.07*1
 .S ACPTEDT=$O(^ICPT(ACPTIEN,60,"B",9999999),-1)
 .I ACPTEDT'="" D
 ..S ACPTEIEN=$O(^ICPT(ACPTIEN,60,"B",ACPTEDT,0))
 ..I $P($G(^ICPT(ACPTIEN,60,ACPTEIEN,0)),U,2)'=1 D  ;1=ACTIVE
 ...K DIC
 ...S DA(1)=ACPTIEN
 ...S DIC="^ICPT("_DA(1)_",60,"
 ...S DIC(0)="L"
 ...S DIC("P")=$P(^DD(81,60,0),"^",2)
 ...S X="01/01/2007"
 ...S DIC("DR")=".02////1"
 ...D ^DIC
 .;end new code acpt*2.07*1
 .D DOTS(ACPTCNT)
 .S ACPTCSV=ACPTCD,ACPTFLAG=""
 D ^%ZISC
 K ACPTSD,ACPTLD
 K ACPTCSV,ACPTFLAG
 K ACPTLNE
 Q
 ;
MREAD ;READ AND UPDATE MODIFIERS AND P-CODES
 S ACPTFL="acpt2008.m"
 W !!,"Reading MODIFIER file, file name ",ACPTFL,!
 D OPEN^%ZISH("CPTSFILE",ACPTPTH,ACPTFL,"R")
 I POP U IO(0) W !,"Could not open modifier and p-code file." Q
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH
 .U IO R X Q:$$STATUS^%ZISH
 .S ACPTCD=$E(X,1,2)
 .S DESC=$E($P(X,": ",1),4,$L(X))
 .S ACPTCDN=$S(ACPTCD=+ACPTCD:ACPTCD,1:$A($E(ACPTCD,1))_$A($E(ACPTCD,2)))
 .I '$D(^AUTTCMOD(ACPTCDN)) D
 ..S ^AUTTCMOD(ACPTCDN,0)=ACPTCD
 .S $P(^AUTTCMOD(ACPTCDN,0),"^",2)=DESC
 .D DOTS(ACPTCNT)
 D ^%ZISC
 Q
 ;
GROUPS ;
 S ACPTFL="acpt2006.d"
 W !!,"Reading Group file, file name ",ACPTFL,!
 D OPEN^%ZISH("CPTSFILE",ACPTPTH,ACPTFL,"R")
 I POP U IO(0) W !,"Could not open group file." Q
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH
 .U IO R X Q:$$STATUS^%ZISH
 .S ACPTCD=$P(X,",")
 .Q:ACPTCD=""
 .S ACPTDA=$O(^ICPT("B",ACPTCD,""))
 .Q:ACPTDA=""
 .S ACPTGRP=$P(X,",",2)
 .S DR="6///"_ACPTGRP
 .S DIE="^ICPT("
 .S DA=ACPTDA
 .D ^DIE
 .D DOTS(ACPTCNT)
 D ^%ZISC
 Q
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
 S ACPTDESC=$$UPC^ACPTPST2(ACPTDESC)
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
XREF ;RE-CROSS REFERENCE FILE
 W !,"WILL NOW RE-INDEX CPT FILE (this will take awhile).",!
 S DIK="^ICPT(" D IXALL^DIK
 D ^ACPTCXR
 Q
XREFM ;RE-CROSS REFERENCE FILE
 W !,"WILL NOW RE-INDEX MODIFIER FILE.",!
 S DIK="^AUTTCMOD(" D IXALL^DIK
 Q
QUE ;QUE JOB TO ACTIVATE/INACTIVATE CODES
 S ZTRTN="^ACPTSINF"
 S ZTIO=""
 S ZTDESC="Activate/inactivate CPT codes."
 S ZTDTH="60996,21600"
 S ACPTRDT=$$HTFM^XLFDT(ZTDTH)
 S ACPTRDT=$$FMTE^XLFDT(ACPTRDT,1)
 D ^%ZTLOAD
 I $G(ZTSK) D
 .W !,"I've taken the liberty to queue task # ",ZTSK," to run on ",ACPTRDT
 .W !,"This routine will inactivate deleted codes and activate new codes."
 .W !,"If this date and time is inconvenient, you may use the Taskman re-schedule"
 .W !,"option to run at a more suitable time."
 I '$G(ZTSK) D
 .W !,"Attempt to queue routine ACPTSINF was unsuccessful. This routine will"
 .W !,"need to be run to activate new codes and de-activate old codes."
 .W !,"and should be run January or February ",ACPTCV,"."
 K ACPTRDT,ACPTCV
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
 ;;CPT version 2.08 contains CPT codes and Modifiers for 2008.
 ;;The install will attempt to read the short description file
 ;;(acpt2008.s), the long description file (acpt2008.l), the
 ;;HCPCS Modifiers file (acpt2008.c), and the Modifiers file
 ;;(acpt2008.m) from the directory you specify.
 ;;
 ;;***end***
 Q
CAT2S ;
 S A=$P(X," ",2,999) D DESC
 S ACPTCDN=""
 F ACPTCDC=1:1:5 S ACPTCDN=ACPTCDN_$A($E(ACPTCD,ACPTCDC))
 I '$D(^ICPT(+ACPTCDN)) D
 .S ^ICPT(+ACPTCDN,0)=ACPTCD
 .S $P(^ICPT(+ACPTCDN,0),"^",6)=ACPTYR
 .S:ACPTYR>DT $P(^ICPT(+ACPTCDN,0),"^",4)=1
 .K DIC
 .S DA(1)=+ACPTCDN
 .S DIC="^ICPT("_DA(1)_",60,"
 .S DIC(0)="L"
 .S DIC("P")=$P(^DD(81,60,0),"^",2)
 .S X="01/01/2008"
 .S DIC("DR")=".02////1"
 .D ^DIC
 S $P(^ICPT(+ACPTCDN,0),"^",2)=ACPTDESC
 S:$P(^ICPT(+ACPTCDN,0),"^",6)<DT $P(^ICPT(+ACPTCDN,0),"^",4)=""
 S $P(^ICPT(+ACPTCDN,0),"^",7)=""
 D CAT(ACPTCDN)
 Q
CAT2L ; 
 S ACPTLN=$E(X,6,7)
 S ACPTCDN=""
 F ACPTCDC=1:1:5 S ACPTCDN=ACPTCDN_$A($E(ACPTCD,ACPTCDC))
 S A=$P(X," ",2,999) D DESC
 I '$D(^ICPT(+ACPTCDN)) D
 .S ^ICPT(+ACPTCDN,0)=ACPTCD
 .S $P(^ICPT(+ACPTCDN,0),"^",6)=ACPTYR
 .S:ACPTYR>DT $P(^ICPT(+ACPTCDN,0),"^",4)=1
 .K DIC
 .S DA(1)=+ACPTCDN
 .S DIC="^ICPT("_DA(1)_",60,"
 .S DIC(0)="L"
 .S DIC("P")=$P(^DD(81,60,0),"^",2)
 .S X="01/01/2008"
 .S DIC("DR")=".02////1"
 .D ^DIC
 I +ACPTLN=1 D
 .K ^ICPT(+ACPTCDN,"D")
 .S ^ICPT(+ACPTCDN,"D",0)="^81.01A^^"
 S ^ICPT(+ACPTCDN,"D",+ACPTLN,0)=ACPTDESC
 S $P(^ICPT(+ACPTCDN,"D",0),"^",3,4)=+ACPTLN_"^"_+ACPTLN
 D DOTS(ACPTCNT)
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
 S DR="13///2.08"  ;current version
 D ^DIE
 S DA(1)=DA
 S X=2.04
 S DIC="^DIC(9.4,DA(1),22,"
 S DIC(0)="LX"
 D ^DIC
 Q:+Y<0
 S DA=+Y
 S DIE=DIC
 S DR="1///3071231;2///"_DT_";3///`"_DUZ
 D ^DIE
 Q
