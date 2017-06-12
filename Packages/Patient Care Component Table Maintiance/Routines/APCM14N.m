APCM14N ;IHS/CMI/LAB - MU PATIENT LIST;
 ;;1.0;IHS MU PERFORMANCE REPORTS;**5,6**;MAR 26, 2012;Build 65
 ;
 ;
 ;
 W:$D(IOF) @IOF
 D XIT
INTRO ;
 S APCMRPTT=2  ;CONTROL VARIABLE FOR CAH REPORT
 S APCMRPTC=$O(^APCMMUCN("B","INTERIM STAGE 1 2014",0))
 W !!!
 S X=0 F  S X=$O(^APCMMUCN(APCMRPTC,15,X)) Q:X'=+X  W ^APCMMUCN(APCMRPTC,15,X,0),!
 W !,"This report will enable a Hospital/CAH to review Meaningful Use "
 W !,"performance by presenting patient-specific data lists. You will be"
 W !,"asked to select one or more Performance Measures on which to report.",!
 S DIR(0)="Y",DIR("A")="Do you wish to continue to report",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 ;gather up measures for this report
 S DIR(0)="S^S:Selected set of MU Performance Measures;A:All MU Performance Measures",DIR("A")="Run the report on",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S APCMINDZ=Y
 I APCMINDZ="A" S X=0 F  S X=$O(^APCM14OB(X)) Q:X'=+X  I $P(^APCM14OB(X,0),U,2)="H" S APCMIND(X)=""
 I APCMINDZ="A" G SI
 I APCMINDZ="S" D EN^APCM14SI I '$D(APCMIND) W !!,"No measures selected" H 2 G INTRO
 S X=0 F  S X=$O(APCMIND(X)) Q:X'=+X  D
 .;GET ALL WITH SAME SUMMARY ORDER # AND ADD IN
 .S O=0 F  S O=$O(^APCM14OB(X,29,O)) Q:O'=+O  S Y=$P(^APCM14OB(X,29,O,0),U,1),Y=$O(^APCM14OB("B",Y,0)) I Y S APCMIND(Y)=""
SI D LISTS
SI1 ;NOW SELECT ONE OR MORE W/IN THE TOPIC
 K APCMX,APCMY,APCMINDL S APCMQ=0
 D TERM^VALM0
 ;REORDER IN AOI FORMAT
 K APCMINDO
 S APCMIND=0 F  S APCMIND=$O(APCMLIST(APCMIND)) Q:APCMIND'=+APCMIND  S APCMINDO($P(^APCM14OB(APCMIND,0),U,4),APCMIND)=""
 S APCMORD=0 F  S APCMORD=$O(APCMINDO(APCMORD)) Q:APCMORD'=+APCMORD!(APCMQ)!($D(DIRUT))  D
 .S APCMIND=$O(APCMINDO(APCMORD,0))
 .S APCMCR="AH"
 .K APCMX S APCMO=0,X=0,APCMC=0 F  S APCMO=$O(^APCMM14L(APCMCR,APCMIND,APCMO)) Q:APCMO'=+APCMO!($D(DIRUT))  D
 ..S X=$O(^APCMM14L(APCMCR,APCMIND,APCMO,0))
 ..S APCMX(APCMO,X)="",APCMC=APCMC+1
 .;display the choices
 .W !!!,"Please select one or more of these report choices within the",!,IORVON,$P(^APCM14OB(APCMIND,0),U,5),IORVOFF," objective.",!
 .K APCMY S X=0,APCMC=0,APCMO=0 F  S APCMO=$O(APCMX(APCMO)) Q:APCMO'=+APCMO!($D(DIRUT))  S X=0 F  S X=$O(APCMX(APCMO,X)) Q:X'=+X!($D(DIRUT))  S APCMC=APCMC+1 W !?5,APCMC,")",?9,$P(^APCMM14L(X,0),U,3) S APCMY(APCMC)=X
 .S DIR(0)="L^1:"_APCMC,DIR("A")="Which item(s)"
 .D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 .I Y="" W !,"No REPORTS selected for this objective." Q
 .I $D(DIRUT) W !,"No REPORTs selected for this objective." Q
 .S APCMANS=Y,APCMC="" F APCMI=1:1 S APCMC=$P(APCMANS,",",APCMI) Q:APCMC=""  S APCMINDL(APCMIND,APCMY(APCMC))=""
 ;get report type
 I $D(DIRUT) G SI
 K APCMQUIT
RT ;
 S APCMSUM="S"
TP ;
 S APCMRPTP=""
 W !! S X=0 F  S X=$O(^APCMMUCN(APCMRPTC,18,X)) Q:X'=+X  W ^APCMMUCN(APCMRPTC,18,X,0),!
YEAR ;
 S (APCMPER,APCMVDT,APCMBD,APCMED)=""
 W !!,"Enter the Fiscal Year for which report is to be run.  Use a 4 digit",!,"year, e.g. 2014."
 S DIR(0)="D^::EP"
 S DIR("A")="Enter the Fiscal Year"
 S DIR("?")="This report is compiled for a period.  Enter a valid year."
 D ^DIR KILL DIR
 I $D(DIRUT) G INTRO
 I $D(DUOUT) S DIRUT=1 G INTRO
 S APCMVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G YEAR
 S APCMPER=APCMVDT
 S APCMQ=0
 I APCMPER'="3150000"  D  G:APCMQ YEAR
 .W !!,"Select one of the following:",!
 .W !?10,"1  Quarter: October 1 - December 31"
 .W !?10,"2  Quarter: January 1 - March 31"
 .W !?10,"3  Quarter: April 1 - June 30"
 .W !?10,"4  Quarter: July 1 - September 30"
 .W !?10,"5  User Defined 90-Day Report"
 .W !?10,"6  User Defined Date Range"
 .S DIR(0)="N^1:6:",DIR("A")="Select Report Period" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1
 .S APCMRPTP=Y
 .I APCMRPTP=1 S APCMBD=($E(APCMPER,1,3)-1)_"1001",APCMED=($E(APCMPER,1,3)-1)_"1231"
 .I APCMRPTP=2 S APCMBD=$E(APCMPER,1,3)_"0101",APCMED=$E(APCMPER,1,3)_"0331"
 .I APCMRPTP=3 S APCMBD=$E(APCMPER,1,3)_"0401",APCMED=$E(APCMPER,1,3)_"0630"
 .I APCMRPTP=4 S APCMBD=$E(APCMPER,1,3)_"0701",APCMED=$E(APCMPER,1,3)_"0930"
 .I APCMRPTP=5 D 5^APCM14H Q
 .I APCMRPTP=6 D 6^APCM14H Q
 I APCMPER="3150000"  D  G:APCMQ YEAR
 .W !!,"Select one of the following:",!
 .W !?10,"1  Year: October 1 - September 30"
 .W !?10,"2  User Defined 90-Day Report"
 .W !?10,"3  User Defined Date Range"
 .S DIR(0)="N^1:3:",DIR("A")="Select Report Period" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1
 .S APCMRPTP=Y
 .I APCMRPTP=1 S APCMBD=($E(APCMPER,1,3)-1)_"1001",APCMED=($E(APCMPER,1,3)-1)_"1231" Q
 .I APCMRPTP=2 D 5^APCM14H Q
 .I APCMRPTP=3 D 6^APCM14H Q
 I APCMBD="" G TP
 I APCMED="" G TP
 ;S X=$O(^APCM14OB("B","S1.002.H",0))
 ;S APCMQ=""
 ;I $D(APCMIND(X)),($P($G(^APCCCTRL(DUZ(2),"MU")),U,1)=""!($P($G(^APCCCTRL(DUZ(2),"MU")),U,1)'<APCMBD)) D  G:APCMQ XIT
 ;.S APCMQ=""
 ;.W !!,"You have chosen to run the Drug Interaction Checks Measure."
 ;.W !,"Warning: Your MU Clean Date for this measure is either blank"
 ;.W !,"or set to a date that is after the beginning date of the report"
 ;.W !,"period.  Therefore, you will not meet this measure."
 ;.S DIR(0)="Y",DIR("A")="Do you wish to continue to run this report",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ;.I $D(DIRUT) S APCMQ=1 Q
 ;.I 'Y S APCMQ=1 Q
 ;
METHOD ;
 S APCMMETH=""
 S DIR(0)="S^E:All Emergency Department;O:Observation Method",DIR("A")="Run the report using which method",DIR("B")="E" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G TP
 S APCMMETH=Y
FAC ;
 S APCMFAC=""
 S DIC("A")="Select Hospital or CAH: ",DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("B")=$P(^DIC(4,DUZ(2),0),U) D ^DIC K DIC,DA
 G:Y<0 TP
 S APCMFAC=+Y
PRV ;
 S APCMQUIT=""
DEMO ;
 D DEMOCHK^APCLUTL(.APCMDEMO)
 I APCMDEMO=-1 G FAC
ATTEST ;get answers to attestation questions for each provider.
 K APCMATTE
 F X="S1.002.H","S1.009.H","S1.025.H.1","S1.013.H","S1.018.H","S1.022.H","S1.023.H","S1.024.H" D
 .S Z=$O(^APCM14OB("B",X,0))
 .I 'Z Q
 .I '$D(APCMIND(Z)) Q
 .S Y=APCMFAC S APCMATTE(X,Y)=""
 I '$D(APCMATTE) G SUM
 W !!,"Several Stage 1 Meaningful Use Performance Measures require an attestation of "
 W !,"Yes or No for the hospital/CAH for which the report is being run.",!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G FAC
 I 'Y G FAC
 S APCMQ=0
 S APCMX="" F  S APCMX=$O(APCMATTE(APCMX)) Q:APCMX=""!(APCMQ)  D
 .;WRITE QUESTION
 .W !
 .S APCMY=$O(^APCM14OB("B",APCMX,0))
 .S X=0 F  S X=$O(^APCM14OB(APCMY,19,X)) Q:X'=+X  W !,^APCM14OB(APCMY,19,X,0)
 .D
 ..I '$P(^APCM14OB(APCMY,0),U,13),APCMX'="S1.025.H.1" S DIR(0)="Y",DIR("A")="Does "_$E($P(^DIC(4,APCMFAC,0),U,1),1,25)_" attest to this",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ..I '$P(^APCM14OB(APCMY,0),U,13),APCMX="S1.025.H.1" S DIR(0)="Y",DIR("A")="Does "_$E($P(^DIC(4,APCMFAC,0),U,1),1,25)_" meet this broadband exclusion",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ..I $P(^APCM14OB(APCMY,0),U,13) S DIR(0)="S^Y:YES;N:NO;X:No Registry Available",DIR("A")="Does "_$E($P(^DIC(4,APCMFAC,0),U,1),1,25)_" attest to this",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ..I $D(DIRUT) S APCMQ=1 Q
 ..S APCMATTE(APCMX,APCMFAC)=$S(Y="X":"N/A",Y="Y":"Yes",Y="N":"No",Y:"Yes",1:"No")
 I APCMQ G DEMO
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF STAGE 1 2014 and/or 2015 MEANINGFUL USE REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(APCMBD)," to ",?31,$$FMTE^XLFDT(APCMED)
 W !!,"Hospital: ",$P(^DIC(4,APCMFAC,0),U,1)
 D PT^APCM14SL
 I APCMROT="" G DEMO
ZIS ;call to XBDBQUE
 D REPORT^APCM14SL
 I $G(APCMQUIT) D XIT Q
 I APCMRPT="" D XIT Q
 K IOP,%ZIS I APCMROT="D",APCMDELT="F" D NODEV,XIT Q
 K IOP,%ZIS W !! S %ZIS=$S(APCMDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP W !,"Report Aborted" S DA=APCMRPT,DIK="^APCMM14C(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D PROC^APCM14E1
 U IO
 D ^APCM14EP
 D ^%ZISC
 D XIT
 Q
 ;
NODEV ;
 S XBRP="",XBRC="NODEV1^APCM14N",XBRX="XIT^APCM14N",XBNS="APCM"
 D ^XBDBQUE
 Q
 ;
NODEV1 ;
 D PROC^APCM14E1
 D ^APCM14EP
 D ^%ZISC
 D XIT
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("APCM*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCM14N",ZTDTH="",ZTDESC="2014 MU STAGE 1 REPORT" D ^%ZTLOAD D XIT Q
 Q
 ;
XIT ;
 L -^APCMM14C
 D ^%ZISC
 D EN^XBVK("APCM")
 I $D(ZTQUEUED) S ZTREQ="@"
 K DIRUT,DUOUT,DIR,DOD
 K DIADD,DLAYGO
 D KILL^AUPNPAT
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K BD,ED
 D KILL^AUPNPAT
 D ^XBFMK
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!$D(IO("S"))
 NEW DIR
 K DIR,DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR KILL DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
LISTS ;any lists with measures?
 K APCMLIST,APCMQUIT
 W !!,"PATIENT LISTS"
 I '$D(^XUSEC("APCMZ PATIENT LISTS",DUZ)) W !!,"You do not have the security access to print patient lists.",!,"Please see your supervisor or program manager if you feel you should have",!,"the APCMZ PATIENT LISTS security key.",! D  Q
 .K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 S DIR(0)="Y",DIR("A")="Do you want patient lists for any of the measures",DIR("B")="NO" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") Q
 I Y=0 Q
 K APCMLIST
 D EN^APCM14SL
 I '$D(APCMLIST) W !!,"No lists selected.",!
 I $D(APCMLIST) S APCMLIST="A" ;I '$D(APCMLIST)!($D(APCMQUIT)) G LISTS ;get report type for each list
 Q
