BWGRVL ; IHS/CMI/LAB - WH VISIT GENERAL RETRIEVAL DRIVER ROUTINE ;15-Feb-2003 21:51;PLS
 ;;2.0;WOMEN'S HEALTH;**6,8**;MAY 16, 1996
 ;visit general retrieval
START ;
 K BWGRQUIT,BWGRDTR
 D XIT
 D INFORM
RTYPE ;get report type  - patient list or procedure list
 S BWGRPTVS=""
 S DIR(0)="S^P:Patients (List or Count WH Patients);R:Procedures (List or Count WH Procedures)",DIR("A")="Which type of Retrieval should be done",DIR("B")="P" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) XIT
 S BWGRPTVS=Y
TYPE ;--- get type of report (patient, date range or search template)
 S (BWGRPCNT,BWGRPTCT)=0 ;BWGRPTCT -- pt total for # of "V"isits
 K BWGRTYPE ;--- just in case variable left around
 K DIR,X,Y
 I BWGRPTVS="P" S DIR(0)="S^S:Search Template of Patients;P:Search All WH Patients",DIR("B")="P"
 I BWGRPTVS="R" S DIR(0)="S^P:Search Template of Patients;S:Search All WH Procedures",DIR("B")="S"
 S DIR("A")="     Select "_$S(BWGRPTVS="P":"Patient ",1:"Procedure ")_"List from" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S BWGRTYPE=BWGRPTVS_Y
 D @BWGRTYPE,XIT
 Q
PP ;patient lister
 D ADD I $D(BWGRQUIT) D DEL K BWGRQUIT G TYPE
 I '$D(BWGRCAND) D PP1 Q
 I $D(BWGRCAND),$P(^BWGRTRPT(BWGRRPT,0),U,11) D  I $D(DIRUT)!'($D(BWGRBDD))!('$D(BWGREDD)) Q
 .S BWGRDTR=""
 .W !!,"You have selected at least one item that requires a date range selection."
 .D GETDATE1
 D TITLE I $D(BWGRQUIT) K BWGRQUIT G TYPE
 D ZIS
 Q
PP1 ;if patient, no prev defined report used
PP11 K ^BWGRTRPT(BWGRRPT,11) D SCREEN I $D(BWGRQUIT) K BWGRQUIT D DEL G TYPE
 I $D(BWGRDTR) D
 .W !!,"You have selected at least one item that requires a date range selection."
 .D GETDATE1
 .I '$D(BWGRBDD)!('$D(BWGREDD))!($D(DIRUT)) G PP11
PP12 K ^BWGRTRPT(BWGRRPT,12) S BWGRTCW=0 D COUNT I $D(BWGRQUIT) K BWGRQUIT G PP11
PP13 D TITLE I $D(BWGRQUIT) K BWGRQUIT G PP12
 D SAVE,ZIS
 Q
PS ;--- process report when search template used
 Q:$D(BWGRQMAN)
 D PS0
 Q:$D(BWGRQUIT)
PS1 ;EP
 D ADD I $D(BWGRQUIT) G PS
PS12 K ^BWGRTRPT(BWGRRPT,12) S BWGRTCW=0 D COUNT I $D(BWGRQUIT) K BWGRQUIT G PS
PS13 D TITLE I $D(BWGRQUIT) K BWGRQUIT G PS12
 D ZIS
 Q
PS0 ;
 S DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 S BWGRQUIT="" Q
 S BWGRSEAT=+Y
 Q
RP ;visit/pt search template
 W ! S DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 S BWGRQUIT="" Q
 S BWGRSEAT=+Y
 G RS
 Q
RS ;
GETDATES ;
 S BWGRLHDR="DATE RANGE SELECTION" W !!?((80-$L(BWGRLHDR))/2),BWGRLHDR
 W !!,"This is a required response.  Remember, if you are using a Search Template of",!,"WH Procedures, the Date Range entered here must correspond to the date range"
 W !,"used to generate the template or be a subset of that date range.",!
GETDATE1 ;
BD ;get beginning date
 W ! K DIR,X,Y S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Visit Date for search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) D DEL Q
 S BWGRBD=Y
ED ;get ending date
 W ! K DIR,X,Y S DIR(0)="DA^"_BWGRBD_":DT:EP",DIR("A")="Enter Ending Visit Date for search: " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 G:Y="" BD
 S BWGRED=Y
 S X1=BWGRBD,X2=-1 D C^%DTC S BWGRD=X S Y=BWGRBD D DD^%DT S BWGRBDD=Y S Y=BWGRED D DD^%DT S BWGREDD=Y
 Q:$D(BWGRDTR)
 D ADD I $D(BWGRQUIT) D DEL K BWGRQUIT G RS
 I '$D(BWGRCAND) D D1 Q
 D TITLE I $D(BWGRQUIT) K BWGRQUIT G TYPE
 D ZIS
 Q
D1 ;if visit, no prev defined report used
D11 K ^BWGRTRPT(BWGRRPT,11) D SCREEN I $D(BWGRQUIT) K BWGRQUIT D DEL G RS
D12 K ^BWGRTRPT(BWGRRPT,12) S BWGRTCW=0 D COUNT I $D(BWGRQUIT) K BWGRQUIT G D11
D13 D TITLE I $D(BWGRQUIT) K BWGRQUIT G D12
 D SAVE,ZIS
 Q
SCREEN ;
 S BWGRCNTL="S"
 D ^BWGRVL4
 Q
COUNT ;count only or detailed report
 D COUNT^BWGRVL3
 Q
TITLE ;
 D TITLE^BWGRVL3
 Q
SAVE ;
 D SAVE^BWGRVL3
 Q
ZIS ;call to XBDBQUE
 K BWGROPT
 I 'BWGRTCW S BWGRTCW=IOM
 S BWGRDONE=""
 D SHOW^BWGRVLS,SHOWP^BWGRVLS,SHOWR^BWGRVLS
 D XIT1
 I BWGRCTYP="D"!(BWGRCTYP="S") D
 .S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 .I $D(DIRUT) S BWGRQUIT="" Q
 .S BWGROPT=Y
 G:$G(BWGRQUIT) SAVE
 I $G(BWGROPT)="B" D BROWSE,XIT Q
 S XBRP="^BWGRVLP",XBRC="^BWGRVL1",XBRX="XIT^BWGRVL",XBNS="BWGR"
 D ^XBDBQUE
 D XIT
 Q
DEL ;EP DELETE LOG ENTRY IF ONE EXISTS AND USER "^" OUT
 I $G(BWGRRPT),$D(^BWGRTRPT(BWGRRPT,0)),'$P(^BWGRTRPT(BWGRRPT,0),U,2) S DIK="^BWGRTRPT(",DA=BWGRRPT D ^DIK K DIK,DA,DIC
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BWGRVLP"")"
 S XBRC="^BWGRVL1",XBRX="XIT^BWGRVL",XBIOP=0 D ^XBDBQUE
 Q
XIT ;
 D XIT^BWGRVL1
XIT1 ;
 D XIT1^BWGRVL1
 Q
ADD ;EP
 K BWGRCAND
 W !!
 I $D(BWGRNCAN) G ADD1
 I $D(BWGRSEAT),'$D(BWGREP1) G ADD1
 S DIR(0)="Y",DIR("A")="Do you want to use a PREVIOUSLY DEFINED REPORT",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BWGRQUIT=1 Q
 I 'Y G ADD1
 S DIC="^BWGRTRPT(",DIC("S")="I $P(^(0),U,2)&($P(^(0),U,6)=BWGRPTVS)" S:$D(BWGREP1) DIC("S")=DIC("S")_"&($P(^(0),U,9)=BWGRPACK)" S DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 I Y=-1 S BWGRQUIT=1 Q
 S BWGRRPT=+Y,BWGRCAND=1
 ;--- set up sorting and report control variables
 S BWGRSORT=$P(^BWGRTRPT(BWGRRPT,0),U,7),BWGRSORV=$P(^(0),U,8),BWGRSPAG=$P(^(0),U,4),BWGRCTYP=$P(^(0),U,5)
 S X=0 F  S X=$O(^BWGRTRPT(BWGRRPT,12,X)) Q:X'=+X  S BWGRTCW=BWGRTCW+$P(^BWGRTRPT(BWGRRPT,12,X,0),U,2)+2
 Q
ADD1 ;
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 S %H=$H D YX^%DTC S X=$P(^VA(200,DUZ,0),U)_"-"_Y,DIC(0)="L",DIC="^BWGRTRPT(",DLAYGO=9002086.88,DIADD=1,DIC("DR")=".13////"_DUZ D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT ENTRY - NOTIFY SITE MANAGER!" S BWGRQUIT=1 Q
 S BWGRRPT=+Y
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 ;DELETE ALL 11 MULTIPLE HERE
 K ^BWGRTRPT(BWGRRPT,11)
 Q
INFORM ;EP
 S BWGRTCW=0
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC(),80),!
 W $$CTR($$USR(),80)
 W !!,$$CTR("WOMEN'S HEALTH GENERAL RETRIEVAL PROGRAM",80),!
 ;W !,"This report will list or count "_$S(BWGRPTVS="P":"Patients",1:"Procedures")," in the Women's Health Register based"
 S T="INTRO" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  W !,X
 K J,X,T
 Q
 ;
INTRO ;
 ;;This report will list or count patients or procedures in the Women's Health
 ;;Register based on selection criteria entered by the user.  You will be asked
 ;;in three separate steps to identify your selection criteria, what you want
 ;;displayed for each patient and the sorting order for your list.
 ;;You may save the logic used to produce the report for future use.
 ;;If you design a report that is 80 characters or less in width it can be
 ;;displayed on your screen or printed.  If your report is 81-132 characters
 ;;wide, it must be printed - and only on a printer capable of producing
 ;;132 character lines.
 ;;
 ;;END
 Q
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Hit return to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
