BCHRC5 ; IHS/TUCSON/LAB - CHRIS II Report 1 ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
START ; 
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! Q
 S BCHJOB=$J,BCHBTH=$H
 D INFORM
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter BEGINNING Date of Service for Report" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S BCHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BCHBD_":DT:EP",DIR("A")="Enter ENDING Date of Service for Report" S Y=BCHBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BCHED=Y
 S X1=BCHBD,X2=-1 D C^%DTC S BCHSD=X
 ;
PROG ;
 S BCHPRG=""
 S DIR(0)="Y",DIR("A")="Include data from ALL CHR Programs",DIR("?")="If you wish to include visits from ALL programs answer Yes.  If you wish to tabulate for only one program enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S BCHPRG="" G GETAGE
PROG1 ;enter program
 K X,DIC,DA,DD,DR,Y S DIC("A")="Which CHR Program: ",DIC="^BCHTPROG(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 PROG
 S BCHPRG=+Y
 ;G ZIS
GETAGE ;
 K BCHQUIT
 D PI
 I $D(BCHQUIT) G PROG
ZIS ;CALL TO XBDBQUE
 S XBRP="^BCHRC5P",XBRC="^BCHRC51",XBRX="XIT^BCHRC5",XBNS="BCH"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K BCHPRG,BCHTOTC,BCHQUIT,BCHJOB,BCHBTH,BCHBT,BCHET,BCHBD,BCHED,BCHBDD,BCHEDD,BCHSD,BCHODAT,BCHPROG,BCHX,BCHC,BCHPROB,BCHPROBN,BCHR,BCHR0,BCHPG,BCHDT,BCHRPT,BCHRAGE,BCHRBIN,BCHDOBS,BCHRNN,BCHRX,BCHRY,BCHRZ,BCHTF
 K BCHTM,DOB,SEX,DFN,M,F,A,I,BCHR11,BCHRA,BCHRDOBS
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !?20,"**********  CHR REPORT NO. 5  **********"
 W !!?18,"CLIENT CONTACTS BY HEALTH PROBLEM, AGE AND SEX",!!,"You must enter the time frame and the program for which the report",!,"will be run."
 W !!,"You can also define your own age groups, if you so desire.",!!
 W "THIS REPORT REQUIRES A PRINTER THAT IS CAPABLE OF PRINTING 132 COLUMN OUTPUT.",!,"SEE YOUR SITE MANAGER IF YOU NEED ASSISTANCE FINDING SUCH A PRINTER.",!!
 Q
 ;
 ;
PI ;EP ;age/sex record counts interactive print ?
 W !!
BIN D SETBIN
 W !,"The Age Groups to be used are currently defined as:",! D LIST
 S DIR(0)="Y",DIR("A")="Do you wish to modify these age groups",DIR("B")="N" D ^DIR K DIR
 I $D(DIRUT) S BCHQUIT="" Q
 I Y=0 Q
RUN ;
 K BCHQUIT S BCHRY="",BCHRA=-1 W ! F  D AGE Q:BCHRX=""  I $D(BCHQUIT) G BIN
 D CLOSE I $D(BCHQUIT) G BIN
 D LIST
 Q
 ;
AGE ;
 S BCHRX=""
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the STARTING age of the "_$S(BCHRY="":"FIRST",1:"NEXT")_" age group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S BCHQUIT="" Q
 S BCHRX=Y
 I Y="" Q
 I BCHRX?1.3N,BCHRX>BCHRA D SET Q
 W $C(7) W !,"Make sure the age is higher than the beginning age of the previous group.",! G RUN
 ;
SET S BCHRA=BCHRX
 I BCHRY="" S BCHRY=BCHRX Q
 S BCHRY=BCHRY_"-"_(BCHRX-1)_";"_BCHRX
 Q
 ;
CLOSE I BCHRY="" Q
GC ;
 S DIR(0)="NO^0:150:0",DIR("A")="Enter the highest age for the last group" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT)!($D(DTOUT)) S BCHQUIT="" Q
 S BCHRX=Y I Y="" S BCHRX=199
 I BCHRX?1.3N,BCHRX'<BCHRA S BCHRY=BCHRY_"-"_BCHRX,BCHRBIN=BCHRY Q
 W "  ??",$C(7) G CLOSE
 Q
 ;
 ;
LIST ;
 S %=BCHRBIN
 F I=1:1 S X=$P(%,";",I) Q:X=""  W !,$P(X,"-")," - ",$P(X,"-",2)
 W !
 Q
 ;
SETBIN ;
 S BCHRBIN="0-4;5-9;10-19;20-34;35-54;55-199"
 Q
