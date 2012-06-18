ACPT24P1 ; IHS/ASDST/DMJ,SDR - CPT POST INIT ;      [ 02/03/2004  12:28 PM ]
 ;;2004;CPT FILES;**1,2**;JAN 14, 2004
 ;
 ;
START S ACPTYR=3040000
 D MSG
 D DIR
 S I=99999,ACPTTO=999999 D INA
 D HREAD  ;hcpcs
 D FINISH
 D XREFM
 W !!,"INSTALL COMPLETE",!!
 S DIR(0)="E" D ^DIR
 K DIR,ACPT,ACPTYR
 Q
INA ;set date deleted for all codes
 W !!,"Updating Year Deleted Field.",!
 F  S I=$O(^ICPT(I)) Q:I>ACPTTO!('I)  D
 .Q:$P($G(^ICPT(I,0)),"^",7)'=3040000
 .S $P(^ICPT(I,0),"^",7)=ACPTYR  ;put date deleted
 .S $P(^ICPT(I,0),"^",4)=""  ;remove inactive flag
 .S ACPTEFDT=$O(^ICPT(I,60,"B",3040101,0))  ;get effective date entry
 .Q:ACPTEFDT=""
 .S DA(1)=I
 .S DIK="^ICPT("_DA(1)_",60,"
 .S DA=ACPTEFDT
 .D ^DIK
 .D DOTS(I)
 K ACPTTO
 Q
DOTS(X) ;EP - WRITE OUT A DOT EVERY HUNDRED
 U IO(0)
 W:'(X#100) "."
 Q
 ;
HREAD ;READ HCPCS FILE
 K ACPTCD,ACPTFLAG,ACPTIEN,ACPTDESC
 S ACPTCSV=""
 W !,"Installing ",$E(ACPTYR,1,3)+1700," HCPCS codes.",!
 S ACPTFL="acpt2004.01h"
 D OPEN^%ZISH("CPTHFILE",ACPTPTH,ACPTFL,"R")
 I POP U IO(0) W !,"Could not open HCPCS file." Q
 U IO(0) W !,"Reading HCPCS Codes File.",!
 F ACPTCNT=1:1 D  Q:$$STATUS^%ZISH
 .U IO R X Q:$$STATUS^%ZISH
 .S ACPTCD=$E(X,1,5)
 .I ACPTCD=ACPTCSV S ACPTFLAG=1
 .Q:ACPTCD'?1U4N
 .S A=$E(X,7,40) D DESC S ACPTSD=ACPTDESC
 .S A=$E(X,42,299) D DESC S ACPTLD=ACPTDESC
 .I '$D(^ICPT("B",ACPTCD)) D
 ..S ACPTIEN=$A($E(ACPTCD))_$E(ACPTCD,2,5)
 ..S ^ICPT(ACPTIEN,0)=ACPTCD
 ..S ^ICPT("B",ACPTCD,ACPTIEN)=""
 ..S $P(^ICPT(ACPTIEN,0),"^",6)=ACPTYR
 ..S $P(^ICPT(ACPTIEN,0),"^",7)=""
 ..K DIC
 ..S DA(1)=ACPTIEN
 ..S DIC="^ICPT("_DA(1)_",60,"
 ..S DIC(0)="L"
 ..S DIC("P")=$P(^DD(81,60,0),"^",2)
 ..S X="01/01/2004"
 ..S DIC("DR")=".02////1"
 ..D ^DIC
 .S ACPTIEN=$O(^ICPT("B",ACPTCD,0))
 .Q:ACPTIEN'>0
 .K ^ICPT(ACPTIEN,"D")
 .S ^ICPT(ACPTIEN,"D",0)="^81.01A^^"
 .S ^ICPT(ACPTIEN,"D",1,0)=ACPTLD
 .S:ACPTSD'="" $P(^ICPT(ACPTIEN,0),"^",2)=ACPTSD
 .S $P(^ICPT(ACPTIEN,0),"^",7)=""
 .D DOTS(ACPTCNT)
 .S ACPTCSV=ACPTCD,ACPTFLAG=""
 D ^%ZISC
 K ACPTSD,ACPTLD
 K ACPTCSV,ACPTFLAG
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
FINISH ;
 S I=99999,ACPTTO=999999
 W !!,"Updating Effective Date Field.",!
 F  S I=$O(^ICPT(I)) Q:I>ACPTTO!('I)  D
 .Q:$P($G(^ICPT(I,0)),"^",7)'=3040000
 .S DA(1)=I
 .S DIC="^ICPT("_DA(1)_",60,"
 .S DIC(0)="L"
 .S DIC("P")=$P(^DD(81,60,0),"^",2)
 .S X="01/01/2004"
 .S DIC("DR")=".02////0"
 .D ^DIC
 .D DOTS(I)
 K ACPTTO
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
 ;;CPT Version 2.04 Patch 1 contains HCPCs update for 2004.
 ;;The install will attempt to read the HCPCS codes file (acpt2004.h),
 ;;and update the codes accordingly.
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
 .S X="01/01/2004"
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
 .S X="01/01/2004"
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
