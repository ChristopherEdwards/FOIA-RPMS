APCDEM ; IHS/CMI/LAB - MODIFY MODE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ; APCDFLG=0 ... RUN
 ; APCDFLG=1 ... ERROR
 ;
 ; APCDMODE=A ... ADD
 ; APCDMODE=M ... MOD
 ;
HDR ; Write Header
 W:$D(IOF) @IOF
 F APCDJ=1:1:5 S APCDX=$T(TEXT+APCDJ),APCDX=$P(APCDX,";;",2) W !?80-$L(APCDX)\2,APCDX K APCDX
 K APCDX,APCDJ
 W !!
 D ^APCDEIN S APCDMODE="M"
 Q:APCDFLG
 F APCDL=0:0 D GETPAT Q:APCDPAT=""  F APCDL=0:0 S APCDVSIT="" D GETVISIT Q:'APCDVSIT  D PROCESS Q
 D EOJ
 Q
 ;
GETPAT ; GET PATIENT
 W !
 S APCDPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 S APCDPAT=+Y
 I DUZ("AG")="I" D ^APCDEMDI
 Q
 ;
GETVISIT ;
 S APCDLOOK="",APCDVSIT="",APCDEMF=0
 K APCDVLK
 S DIR(0)="Y",DIR("A")="VISIT related",DIR("B")="YES" D ^DIR K DIR Q:$D(DIRUT)  S APCDX=Y
 I APCDX=1 D ^APCDVLK
 I APCDLOOK S AUPNVSIT=APCDLOOK D MOD^AUPNVSIT
 I APCDLOOK="",APCDX=1 W !!,"No Visit Selected!!",$C(7),$C(7),! G GETVISIT
 I APCDLOOK="" S APCDLOOK=-1,APCDEMF=1 W !!,"Select non VISIT related mnemonics only!"
 S (APCDVSIT,APCDVLK)=APCDLOOK
 I AUPNDOB]"",$D(APCDDATE) S X2=AUPNDOB,X1=APCDDATE D ^%DTC S AUPNDAYS=X ; re-set days of age to visit date-dob
 K APCDLOOK
 Q
 ;
PROCESS ;EP PROCESS MNEMONIC
 D GETMNE
 S DIE="^AUPNPAT(",DR=".16///TODAY",DA=APCDPAT D ^DIE
 Q
 ;
GETMNE ; GET MNEMONIC
 W !
 S DIC="^APCDTKW(",DIC(0)="AEMQ",DIC("A")="MNEMONIC: ",DIC("S")="I $L($P(^(0),U))<5" D ^DIC K DIC
 G:Y<0 GETMNEK
 S APCDMNE=+Y,APCDMNE("NAME")=$P(Y,U,2)
 D ^APCDEA3
 G GETMNE
 ;
GETMNEK ; KILL GETMNE SPECIFIC VARIABLES
 D:APCDVSIT>0 CHECK
 I $G(APCDVSIT) D EP^APCDKDE
 K APCDVSIT,APCDX
 Q
 ;
CHECK ; SEE IF PV AND PRO ENTERED CORRECTLY
 D ^APCDVCHK
 S APCDMNE=0
 Q
 ;
EOJ ; END OF JOB
 D ^APCDEKL
 Q
TEXT ;
 ;;PCC Data Entry Module
 ;;
 ;;***************
 ;;* MODIFY Mode *
 ;;***************