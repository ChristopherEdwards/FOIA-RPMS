APCLBRH ; IHS/CMI/LAB - list holders of medicare a, b, medicaid or priv ins ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
START ;
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! Q
 W:$D(IOF) @IOF
 I '$D(APCLRPT) W !,$C(7),$C(7),"REPORT TYPE MISSING!!  NOTIFY PROGRAMMER",! Q
 D GETINFO G:$D(APCLQ) QUIT
 W !!,"This option will print a list of Patients who are registered at",!,"the facility that you select who are currently enrolled in ",APCLINF,".",!
 W !,"You will be asked to enter an 'As of' date to be used in determining",!,"those patients who are 'actively' enrolled.",!
 W !,"The report will be sorted alphabetically by Patient Name.",!
F ;
 S DIC("A")="Which Facility: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 QUIT
 S APCLSU=+Y
AOD ;
 S %DT("A")="Patients are to be considered ACTIVE as of what date: ",%DT="AEPX" W ! D ^%DT
 I Y=-1 G F
 S APCLACE=Y X ^DD("DD") S APCLACEY=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G AOD
 S XBRP="^APCLBRH1",XBRC="^APCLBRH2",XBRX="QUIT^APCLBRH",XBNS="APCL"
 D ^XBDBQUE
 D QUIT
 Q
QUIT ;
 K POP,ZTSK,ZTQUEUED,DFN,%DT,%,X,Y,DIRUT,J,K,%XX,%YY,DDBN,DDBT,DDBX,HS,IX,C,H,M,S,TS
 K APCLACE,APCLSU,APCLINFO,APCL80D,APCLACEY,DOB,APCLGOT,APCLINF,APCLLENG,APCLMDFN,APCLMDOB,APCLMEDN,APCLMN,APCLPG,APCLPN,APCLPROC,APCLR,APCLRPT,APCLTITL,APCLTOT,APCLVAL,APCLHRN,APCLQ,APCLDDFN,APCLBT,APCLNAME,APCLNDFN,APCLNREC,APCLJOB
 Q
 ;
GETINFO ;
 I $T(@(APCLRPT))="" W !!,$C(7),$C(7),"REPORT INFORMATION MISSING!! NOTIFY PROGRAMMER!",!! S APCLQ="" Q
 S APCLINFO=$T(@(APCLRPT)),APCLVAL=$P(APCLINFO,";;",2),APCLPROC=$P(APCLINFO,";;",4),APCLINF=$P(APCLINFO,";;",3),APCLTITL=$P(APCLINFO,";;",5)
 Q
 ;
MCD ;;X;;Medicaid;;MCD;;ACTIVE MEDICAID ENROLLEES
MCRA ;;A;;Medicare Part A;;MCRA;;ACTIVE MEDICARE PART A ENROLLEES
MCRB ;;B;;Medicare Part B;;MCRA;;ACTIVE MEDICARE PART B ENROLLEES
PI ;;X;;Private Insurance;;PI;;ACTIVE PRIVATE INSURANCE ENROLLEES
