APCLCH2 ; IHS/CMI/LAB - DX BY COMMUNITY LOCAL,SECONDARY,TERTIARY ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ; 
 S APCLJOB=$J,APCLBTH=$H
 K ^XTMP("APCLCH2",APCLJOB,APCLBTH)
 D XTMP^APCLOSUT("APCLCH2","PCC - DX TALLY")
 D INFORM
SU S B=$P(^AUTTLOC(DUZ(2),0),U,5) I B S S=$P(^AUTTSU(B,0),U),DIC("A")="Please Identify your Service Unit: "_S_"//"
 S DIC="^AUTTSU(",DIC(0)="AEMQZ" W ! D ^DIC K DIC
 I X="^" G XIT
 I X="" S (APCLSU,APCLSUF)=B G GETDATES
 G:Y=-1 GETDATES
 S (APCLSU,APCLSUF)=+Y
GETDATES ;
BD ;
 W !!,"Enter the time frame of interest.",! S DIR(0)="D^::EP",DIR("A")="Enter Beginning Visit Date",DIR("?")="Enter the beginning visit date for the search." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S APCLBD=Y
ED ;
 S DIR(0)="DA^::EP",DIR("A")="Enter Ending Visit Date:  " D ^DIR K DIR,DA S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 I Y<APCLBD W !,"Ending date must be greater than or equal to beginning date!" G ED
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
COMM ;
 S APCLCOMT="" K APCLQUIT,^XTMP("APCLCH2",APCLJOB,APCLBTH,"COMMUNITIES")
 K DIR S DIR(0)="S^O:ONE Particular Community;S:All Communities within the "_$P(^AUTTSU(APCLSU,0),U)_" SERVICE UNIT;T:A TAXONOMY or selected set of Communities"
 S DIR("A")="Enter a code indicating what COMMUNITIES of RESIDENCE are of interest",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) GETDATES
 S APCLCOMT=Y
 D @APCLCOMT
 G:$D(APCLQUIT) COMM
CHECK ;check each community entry for existence of facility identification
 K APCLQUIT
 W !!,"Checking community table for required items..."
 S (APCLX,C)=0 F  S APCLX=$O(^XTMP("APCLCH2",APCLJOB,APCLBTH,"COMMUNITIES",APCLX)) Q:APCLX'=+APCLX!($D(APCLQUIT))  D
 .S (L,S,T)=0 S:'$P(^AUTTCOM(APCLX,0),U,15) L=1
 .I '$P(^AUTTCOM(APCLX,0),U,16) S S=1
 .I '$P(^AUTTCOM(APCLX,0),U,17) S T=1
 .I 'L,'S,'T Q
 .S C=C+1
 .I $Y>(IOSL-2) D PAUSE Q:$D(APCLQUIT)
 .W !,$P(^AUTTCOM(APCLX,0),U)," is missing "
 .W "facility identification in the community table."
 I 'C  W !,"ALL are okay.",!!,"Be sure to utilize a printer with 132 margin print capability.",! G ZIS
CHECK1 ;
 W !!,"Since some of the community entries are missing data, I cannot continue.",!,"See your site manager about fixing the community entries.",!,"You may now select other communities or exit the report.",! G COMM
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G COMM
 W !! S XBRP="^APCLCH2P",XBRC="^APCLCH21",XBNS="APCL",XBRX="XIT^APCLCH2"
 D ^XBDBQUE
 D XIT
 Q
 ;
PAUSE ; 
 S DIR(0)="E",DIR("A")="Press return to continue or '^' to quit" D ^DIR K DIR,DA
 S:$D(DIRUT) APCLQUIT=1
 W:$D(IOF) @IOF
 Q
XIT ;
 K APCLQUIT,APCLCOMT,APCLBD,APCLED,APCLDFN,APCLSD,APCLX,APCLY,APCLER,APCL1,APCL2,APCL3,APCLBDO,APCLBT,APCLBTH,APCLC,APCLCOM,APCLCOMI,APCLLOC,APCLTYPE
 K APCLDX,APCLEDO,APCLET,APCLF,APCLI,APCLJOB,APCLLFAC,APCLP,APCLPG,APCLSFAC,APCLSU,APCLSUF,APCLTFAC,APCLV,APCLVCNT,APCLVLOC
 K L,M,S,T,X,X1,X2,Y,Z,B
 D KILL^AUPNPAT
 D ^XBFMK
 Q
O ;one community
 S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Which COMMUNITY: " D ^DIC K DIC
 I Y=-1 S APCLQUIT="" Q
 S ^XTMP("APCLCH2",APCLJOB,APCLBTH,"COMMUNITIES",+Y)=""
 Q
S ;all communities within APCLSU su
 S X=0 F  S X=$O(^AUTTCOM(X)) Q:X'=+X  I $P(^AUTTCOM(X,0),U,5)=APCLSU S ^XTMP("APCLCH2",APCLJOB,APCLBTH,"COMMUNITIES",X)=""
 Q
 ;
T ;taxonomy - call qman interface
 K ^XTMP("APCLCH2",APCLJOB,APCLBTH,"COMMUNITIES")
ASK ; Get community name or cohort
 K APCLCOMM
 R:'$D(^XTMP("APCLCH2",APCLJOB,APCLBTH,"COMMUNITIES")) !,"Enter community or [search template name: ",X:DTIME
 R:$D(^XTMP("APCLCH2",APCLJOB,APCLBTH,"COMMUNITIES")) !,"Enter ANOTHER community or [search template name: ",X:DTIME
 I X=""&('$D(^XTMP("APCLCH2",APCLJOB,APCLBTH,"COMMUNITIES"))) S APCLQUIT=1 W !!,$C(7),$C(7),"No communities selected!!",! Q
 Q:X=""
 I "^"[X K ^XTMP("APCLCH2",APCLJOB,APCLBTH,"COMMUNITIES") S APCLQUIT=1 W !!,"Okay - exiting....try again later" Q
 I $E(X)'="[" S APCLCOMM=""
 E  S X=$E(X,2,99)
 I '$D(APCLCOMM) S DIC("S")="I $P(^(0),U,15)=9999999.05"
 S DIC=$S($D(APCLCOMM):"^AUTTCOM(",1:"^ATXAX("),DIC(0)="EQM" D ^DIC K DIC
 I Y=-1 G ASK
 I $D(APCLCOMM) S ^XTMP("APCLCH2",APCLJOB,APCLBTH,"COMMUNITIES",+Y)=""
 E  S X=0 F  S X=$O(^ATXAX(+Y,21,X)) Q:'X  S Z=$P(^ATXAX(+Y,21,X,0),U) I Z]"" S ^XTMP("APCLCH2",APCLJOB,APCLBTH,"COMMUNITIES",$O(^AUTTCOM("B",Z,0)))=""
 K APCLCOMM
 G ASK
 Q
INFORM ;tell user what is going on
 ;
 W:$D(IOF) @IOF
 W !!?5,"DIAGNOSES BY A COMMUNITY'S LOCAL, SECONDARY AND TERTIARY FACILITIES"
 W !!,"This report will present a tally of all diagnoses for patients in a community",!,"or communities you select.  The report will tally the diagnoses for"
 W !,"the community's local, secondary and tertiary facilities.  Each community's",!,"report will be 2 pages long, 1 page for outpatient diagnoses and 1 for ",!,"inpatient diagnoses.",!!
 Q
SET ;EP - ENTRY POINT
 S APCLC="" F  S APCLC=$O(^XTMP("APCLCH2",APCLJOB,APCLBTH,"DATA",APCLC)) Q:APCLC=""   D
 .S APCLF=0 F  S APCLF=$O(^XTMP("APCLCH2",APCLJOB,APCLBTH,"DATA",APCLC,APCLF)) Q:APCLF'=+APCLF  D
 ..S APCL1="OUTDXC",APCL3="OUTDX" D SET1
 ..S APCL1="INDXC",APCL3="INDX" D SET1
 ..S APCL1="OUTCATC",APCL3="OUTCAT" D SET1
 ..S APCL1="INCATC",APCL3="INCAT" D SET1
 Q
SET1 ;
 S APCL2="^XTMP(""APCLCH2"",APCLJOB,APCLBTH,""DATA"",APCLC,APCLF,"""_APCL3_""",X)"
 S X="" F  S X=$O(@APCL2) Q:X=""  S %=^(X) S ^XTMP("APCLCH2",APCLJOB,APCLBTH,"DATA",APCLC,APCLF,APCL1,9999999-%,X)=%
 Q
