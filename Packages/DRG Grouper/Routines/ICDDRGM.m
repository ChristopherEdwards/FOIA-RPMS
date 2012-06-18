ICDDRGM ;NEISC/GRR/EG - GROUPER DRIVER ;14 MAR 89 [ 12/03/92  11:52 AM ]
 ;;8.0;1P GROUPER;**1**;DEC 3,1992
 ;
 ; p1 - Corrected a line of code to display HCFA Weight and LOS
 ;      by Mike Remillard 12/3/92
 ;
 S U="^",X="T",%DT="" D ^%DT S DT=Y W !!?11,"DRG Grouper    Version 8",!!
 ;
 S ICDQU=0                                        ;IHS/ANMC/MWR 12/30/91
PAT ; NEXT 5 LINES ADDED                             ;IHS/ANMC/MWR 12/30/91
 G:ICDQU EXIT
 I '$D(DUZ(2)) D  G ASK
 .W !,"DUZ(2) is undefined.  "
 .W "(Patient lookup not possible.)",!
 .S ICDQU=0,ICDPT=0 K ICDEXP,SEX,ICDDX
 ;
 ;
 ; NEXT 5 LINES ADDED                             ;IHS/ANMC/MWR 12/30/91
 S ICDQU=0 K ICDEXP,SEX,ICDDX
 S DIR(0)="YO",DIR("A")="DRGs for Registered PATIENTS (Y/N)"
 S DIR("?")="Enter Yes if the patient has been previously registered."
 D ^DIR K DIR S ICDPT=Y
 G KILL:$D(DIRUT),OUT:$D(DTOUT)
 ;
 ;
PAT0 G:ICDPT=0 ASK
VA S DIC="^DPT(",DIC(0)="AEQMZ" D ^DIC G Q:X=""!(X[U)!(Y'>0),OUT:$D(DTOUT) S DFN=+Y,AGE=$P(Y(0),U,3),SEX=$P(Y(0),U,2)
 I AGE]"" S X1=DT,X2=AGE D ^%DTC S AGE=X\365.25 W !?24,"AGE: ",AGE  ; ADDED LINEFEED AND TAB  ;IHS/ANMC/MWR 12/30/91
 ;
 ;
 ; ADDED FOLLOWING LINES TO SKIP TAC,DAM & ALIVE  ;IHS/ANMC/MWR 12/30/91
 S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Did the patient die, transfer, or sign out AMA"
 D ^DIR K DIR
 G PAT:$D(DUOUT),EXIT:$D(DTOUT)
 I 'Y S (ICDEXP,ICDTRS,ICDDMS)=0 G CD
 ;
 ;
 D TAC G:ICDQU PAT D DAM G:ICDQU PAT
EN1 D ALIVE                                          ;IHS/ANMC/MWR 01/15/92
 S ICDEXP=$S($D(ICDEXP):ICDEXP,1:0)
CD K DIC S CC=0,DIC="^ICD9(",DIC(0)="AEQMZ",DIC("A")="Enter Primary diagnosis: ",DIC("S")="I '$P(^(0),U,4),'$P(^(0),U,9)" D ^DIC K DIC G Q:X=""!(X[U)!(Y'>0),OUT:$D(DTOUT) S ICDDX(1)=+Y
 F ICDNSD=2:1 S DIC="^ICD9(",DIC(0)="AEQMZ",DIC("A")="Enter SECONDARY diagnosis: ",DIC("S")="I '$P(^(0),U,9)" D ^DIC K DIC Q:X=""!(X[U)!(Y'>0)  G:$D(DTOUT) OUT S ICDDX(ICDNSD)=+Y
 G Q:X[U
OP S DIC("S")="I '$P(^ICD0(+Y,0),U,9)" K ICDPRC
 W ! F ICDNOR=1:1 S DIC="^ICD0(",DIC(0)="AEQMZ",DIC("A")="Enter Operation/Procedure: " D ^DIC Q:X=""!(X[U)!(Y'>0)  G:$D(DTOUT) OUT S ICDPRC(ICDNOR)=+Y
 K DIC G Q:X["^"
 D ^ICDDRG K ICDEXP,SEX,ICDDX I ICDRTC'=0 G ERROR
 D WRT G PAT0
 ;
 ;
WRT ;EP ;IHS/ANMC/MWR 03/09/92
 S ICDDRG(0)=^ICD(ICDDRG,0)
MWR ;
 ; BEGINNING OF NEW OUTPUT BY IHS/ANMC/MWR 12/30/91
 ;
 ; NEXT LINES SAVE RESULTS IN LOCAL VARIABLES (SEE ICDZENT).
 I $D(ICDZEN) D
 .S ICDZDRG=ICDDRG
 .S ICDZDRT=^ICD(ICDDRG,1,1,0)
 .S ICDZWT=$P(^ICD(ICDDRG,9999999),U)
 .S ICDZLOS=$P(^ICD(ICDDRG,9999999),U,3)
 ; NEXT LINE INHIBITS OUTPUT IF NOT DESIRED (SEE ICDZENT).
 Q:$D(ICDZNOT)
 ;
 ; BEGIN OUTPUT
 S X="",$P(X,"-",81)="" W !!,X
 W !!,"DRG: ",$J(ICDDRG,4)," -"
 S I=0 F  S I=$O(^ICD(ICDDRG,1,I)) Q:(I="")!(I'?.N)  D
 .W ?12,$P(^(I,0),U,1),!
 I $D(^ICD(ICDDRG,9999999)) D
 .W !?6,"HCFA Weight: ",$P(^ICD(ICDDRG,9999999),U)
 .W ?40,"HCFA GEOM MEAN LOS: ",$P(^ICD(ICDDRG,9999999),U,3)
 .S ICDDRGN=ICDDRG
 .D ^ICDZCOST
 S X="",$P(X,"-",81)="" W !,X
 S DIR(0)="E" D ^DIR K DIR W !
 Q
 ;
 ;
ERROR D WRT
 I ICDRTC<5 W !!,"Invalid ",$S(ICDRTC=1:"Principal Diagnosis",ICDRTC=2:"Operation/Procedure",ICDRTC=3:"Age",ICDRTC=4:"Sex",1:"") G PAT0
 I ICDRTC=5 W !!,"Grouper needs to know if patient died during this episode!" G PAT0
 I ICDRTC=6 W !!,"Grouper needs to know if patient was transferred to an acute care facility!" G PAT0
 I ICDRTC=7 W !!,"Grouper needs to know if patient was discharged against medical advice!" G PAT0
 G PAT0
EXIT ;                           ; ADDED LINE LABEL   ;IHS/ANMC/MWR 12/30/91
KILL K DIC,DFN,DUOUT,DTOUT,ICDNOR,ICDDX,ICDPRC,ICDEXP,ICDTRS,ICDDMS,ICDDRG,ICDMDC,ICDO24,ICDP24,ICDP25,ICDRTC,ICDPT,ICDQU,ICDNSD,ICDNMDC,ICDS25,ICDSEX,AGE,CC,HICDRG,ICD,ICDCC3,ICDJ,ICDJJ,ICDL39,ICDFZ Q
Q G PAT
 ;
 ;
AGE ; ADDED G QQ:Y=""  ;IHS/ANMC/MWR 12/30/91
 S DIR(0)="NOA^0:124:0",DIR("A")="Patient's age: "
 S DIR("?")="Enter how old the patient is (0-124)."
 D ^DIR K DIR
 S AGE=Y G QQ:$D(DUOUT),OUT:$D(DTOUT)
 G QQ:Y=""
 Q
 ;
ALIVE ;
 S DIR(0)="Y",DIR("A")="Did the patient die during this episode"
 D ^DIR K DIR
 S ICDEXP=Y G QQ:$D(DUOUT),OUT:$D(DTOUT)
 Q
 ;
TAC ;
 S DIR(0)="Y"
 S DIR("A")="Was the patient transferred to an acute care facility"
 D ^DIR K DIR
 S ICDTRS=Y G QQ:$D(DUOUT),OUT:$D(DTOUT)
 Q
 ;
DAM ;
 S DIR(0)="Y"
 S DIR("A")="Was the patient discharged against medical advice"
 D ^DIR K DIR
 S ICDDMS=Y G QQ:$D(DUOUT),OUT:$D(DTOUT)
 Q
 ;
SEX ;
 S DIR(0)="SB^M:MALE;F:FEMALE"
 S DIR("?")="Enter M for Male and F for Female"
 S DIR("A")="Patient's Sex"
 D ^DIR K DIR
 S SEX=Y G QQ:$D(DUOUT),OUT:$D(DTOUT)
 Q
 ;
QQ S ICDQU=1 Q
ASK ; NEW ORDER AND QUESTIONS                      ;IHS/ANMC/MWR 12/30/91
 K DTOUT,DUOUT
 D AGE G:ICDQU PAT
 D SEX G:ICDQU PAT
 S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Did the patient die, transfer, or sign out AMA"
 D ^DIR K DIR
 G QQ:$D(DUOUT),OUT:$D(DTOUT)
 I 'Y S (ICDEXP,ICDTRS,ICDDMS)=0 G CD
 D TAC G:ICDQU PAT
 D DAM G:ICDQU PAT
 D ALIVE G:ICDQU PAT
 G CD
OUT G H^XUS
