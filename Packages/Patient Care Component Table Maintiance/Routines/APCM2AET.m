APCM2AET ;IHS/CMI/LAB - IHS MU PATIENT LIST;
 ;;1.0;MU PERFORMANCE REPORTS;**7**;MAR 26, 2012;Build 15
 ;
 ;
 ;
 W:$D(IOF) @IOF
EP D XIT
INTRO ;
 S APCMRPTT=1  ;CONTROL VARIABLE FOR EP REPORT
 S APCMRPTC=$O(^APCMMUCN("B","MODIFIED STAGE 2 2015",0))
 W !!!
 ;S X=0 F  S X=$O(^APCMMUCN(APCMRPTC,11,X)) Q:X'=+X  W ^APCMMUCN(APCMRPTC,11,X,0),!
 W $$CTR("***IHS Modified Stage 2 MU Performance Reports for EPS***",80),!
 W $$CTR("Alternate Stage 1 Exclusions",80),!
 W !,"This report displays the performance measure results for Modified",!
 W "Stage 2 Meaningful Use with alternate Stage 1 exclusions/thresholds.",!
 W !,"In order to achieve Meaningful Use, an EP must attest to meeting",!
 W "all 10 objectives and their associated performance measures.",!
 W !,"The report can be run for 90 days, 1 year or a user defined time period.",!
 W !,"This report allows a user to review the patients that populate the",!
 W "numerator and denominator of each Performance Measure."
 W !!
 S DIR(0)="Y",DIR("A")="Do you wish to continue to report",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 ;gather up measures for this report
 S DIR(0)="S^S:One or More Performance Measures;A:All MU Performance Measures",DIR("A")="Run the report on",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S APCMINDZ=Y
 I APCMINDZ="S" D EN^APCM2ASI S Q=0 D  I Q G INTRO
 .I '$D(APCMIND) W !!,"No measures selected" H 2 S Q=1 Q
 .S X=0 F  S X=$O(APCMIND(X)) Q:X'=+X  D
 ..;GET ALL WITH SAME SUMMARY ORDER # AND ADD IN
 ..S O=0 F  S O=$O(^APCM25OB(X,29,O)) Q:O'=+O  S Y=$P(^APCM25OB(X,29,O,0),U,1),Y=$O(^APCM25OB("B",Y,0)) I Y S APCMIND(Y)=""
 I APCMINDZ="A" S X=0 F  S X=$O(^APCM25OB(X)) Q:X'=+X  I $P(^APCM25OB(X,0),U,2)="E" S APCMIND(X)=""
SI S APCMQ=0 D LISTS
 I APCMQ G INTRO
SI1 ;NOW SELECT ONE OR MORE W/IN THE TOPIC
 K APCMX,APCMY,APCMINDL S APCMQ=0
 D TERM^VALM0
 ;REORDER IN AOI FORMAT
 K APCMINDO
 S APCMIND=0 F  S APCMIND=$O(APCMLIST(APCMIND)) Q:APCMIND'=+APCMIND  S APCMINDO($P(^APCM25OB(APCMIND,0),U,4),APCMIND)=""
 S APCMORD=0 F  S APCMORD=$O(APCMINDO(APCMORD)) Q:APCMORD'=+APCMORD!(APCMQ)!($D(DIRUT))  D
 .S APCMIND=$O(APCMINDO(APCMORD,0))
 .S APCMCR="AEP"
 .K APCMX S APCMO=0,X=0,APCMC=0 F  S APCMO=$O(^APCMM25L(APCMCR,APCMIND,APCMO)) Q:APCMO'=+APCMO!($D(DIRUT))  D
 ..S X=$O(^APCMM25L(APCMCR,APCMIND,APCMO,0))
 ..S APCMX(APCMO,X)="",APCMC=APCMC+1
 .;display the choices
 .W !!!,"Please select one or more of these report choices within the",!,IORVON,$P(^APCM25OB(APCMIND,0),U,5),IORVOFF," objective.",!
 .K APCMY S X=0,APCMC=0,APCMO=0 F  S APCMO=$O(APCMX(APCMO)) Q:APCMO'=+APCMO!($D(DIRUT))  S X=0 F  S X=$O(APCMX(APCMO,X)) Q:X'=+X!($D(DIRUT))  S APCMC=APCMC+1 W !?5,APCMC,")",?9,$P(^APCMM25L(X,0),U,3) S APCMY(APCMC)=X
 .S DIR(0)="L^1:"_APCMC,DIR("A")="Which item(s)"
 .D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 .I Y="" W !,"No REPORTS selected for this objective." Q
 .I $D(DIRUT) W !,"No REPORTs selected for this objective." Q
 .S APCMANS=Y,APCMC="" F APCMI=1:1 S APCMC=$P(APCMANS,",",APCMI) Q:APCMC=""  S APCMINDL(APCMIND,APCMY(APCMC))=""
 ;get report type
 I $D(DIRUT) G SI
 K APCMQUIT ;D RT^APCM2ASL I '$D(APCMLIST)!($D(APCMQUIT)) G SI
RT ;
 S APCMSUM="S"
TP ;
 S APCMRPTP=""
 ;
 W !
MUYEAR ;
 K DIR S DIR(0)="D^::EP"
 W !,"Enter the Calendar Year for which the EP is demonstrating Meaningful"
 S DIR("A")="Use.  Use a 4 digit year, e.g. 2015"
 S DIR("?")="Enter a valid year."
 D ^DIR KILL DIR
 I $D(DIRUT) G EP
 I $D(DUOUT) G EP
 S APCMVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G MUYEAR
 I $E(Y,1,3)'=315,$E(Y,1,3)'=316 W !!,"Calendar year must equal 2015 or 2016.",! G MUYEAR
 S APCMPER=APCMVDT
 S APCMLD=$E(APCMPER,1,3)_"0101",APCMHD=$E(APCMPER,1,3)_"1231"   ;LOW AND HIGH DATES ALLOWED BELOW
 ;
YEAR ;
 S (APCMVDT,APCMBD,APCMED)=""
 S APCMQ=0
 D  G:APCMQ INTRO
 .W !!,"Select one of the following:",!
 .W !?10,"1  User Defined 90-Day Report"
 .W !?10,"2  Calendar Year"
 .W !?10,"3  User Defined Date Range"
 .W ! S DIR(0)="N^1:3:",DIR("A")="Select Report Period" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMRPTP=Y
 .I APCMRPTP=1 D 5^APCM2AE Q
 .I APCMRPTP=2 S APCMBD=APCMLD,APCMED=APCMHD  W !!,"Date range is: ",$$FMTE^XLFDT(APCMBD)," - ",$$FMTE^XLFDT(APCMED),"." Q
 .I APCMRPTP=3 D 6^APCM2AE Q
 I APCMBD="" G TP
 I APCMED="" G TP
PRV ;
 S APCMPLTY=""
 S DIR(0)="S^IP:Individual Provider;SEL:Selected Providers (User Defined);TAX:Provider Taxonomy List",DIR("A")="Enter Selection" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G TP
 S APCMPLTY=Y
 S APCMQUIT=""
 I APCMPLTY="IP" D  I $G(APCMQUIT) G PRV
 .K APCMPRV
 .W !!,"Enter the name of the provider for whom the Meaningful Use Patient List will be run.",!
 .S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER NAME: " D MIX^DIC1 K DIC,D
 .I Y<0 S APCMQUIT=1 Q
 .S APCMPRV(+Y)=""
 I APCMPLTY="SEL" D  I $G(APCMQUIT) G PRV
 .K APCMPRV
 .W !!,"Enter the name of the provider for whom the Meaningful Use Patient List will be run.",!
SEL1 .S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER NAME: " D MIX^DIC1 K DIC,D
 .I Y<0,'$D(APCMPRV) S APCMQUIT=1 Q
 .I Y<0 Q
 .S APCMPRV(+Y)=""
 .G SEL1
 I APCMPLTY="TAX" D  I $G(APCMQUIT) G PRV
 .W !!,"Enter the name of the provider taxonomy"
 .S DIC="^ATXAX(",DIC("S")="I $P(^(0),U,15)=200",DIC(0)="AEMQ",DIC("A")="Enter PROVIDER TAXONOMY NAME: " D ^DIC K DIC
 .I Y<0 S APCMQUIT=1 Q
 .S APCMPRTX=+Y
 .W !,"The following providers are members of this taxonomy: "
 .S X=0 F  S X=$O(^ATXAX(+Y,21,"B",X)) Q:X'=+X  S APCMPRV(X)="" W !?5,"- ",$P(^VA(200,X,0),U,1)
DEMO ;
 D DEMOCHK^APCLUTL(.APCMDEMO)
 I APCMDEMO=-1 G PRV
ASKADD ;
 K APCMADDQ
 ;S A=$O(^APCM25OB("B","S2.008.EP",0))
 S B=$O(^APCM25OB("B","S2.003.EP",0))
 I '$D(APCMIND(B)) G ATTEST
 W !! ;,"Please answer the following exclusion questions for each provider."
 ;D EPRES^APCM2AE ;ASK ADDITIONAL QUESTIONS FOR E-PRESCRIBING
 ;I APCMQ G DEMO
ATTEST ;get answers to attestation questions for each provider.
 D ATTESTQ^APCM2AE
 I APCMQ G DEMO
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF IHS MODIFIED STAGE 2 MEANINGFUL USE REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(APCMBD)," to ",?31,$$FMTE^XLFDT(APCMED)
 W !!,"Providers: "
 S X=0 F  S X=$O(APCMPRV(X)) Q:X'=+X  W !?5,$P(^VA(200,X,0),U,1)
 D PT^APCM2ASL
 I APCMROT="" G DEMO
ZIS ;call to XBDBQUE
 D REPORT^APCM2ASL
 I $G(APCMQUIT) D XIT Q
 I APCMRPT="" D XIT Q
 K IOP,%ZIS I APCMROT="D",APCMDELT="F" D NODEV,XIT Q
 K IOP,%ZIS W !! S %ZIS=$S(APCMDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP W !,"Report Aborted" S DA=APCMRPT,DIK="^APCMM25C(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=APCMRPT,DIK="^APCMM14P(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D PROC^APCM2AE1
 U IO
 D ^APCM2AEP
 D ^%ZISC
 D XIT
 Q
 ;
NODEV ;
 S XBRP="",XBRC="NODEV1^APCM2AET",XBRX="XIT^APCM2AET",XBNS="APCM"
 D ^XBDBQUE
 Q
 ;
NODEV1 ;
 D PROC^APCM2AE1
 D ^APCM2AEP
 D ^%ZISC
 D XIT
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("APCM*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCM2AE",ZTDTH="",ZTDESC="2014 MU STAGE 2 REPORT" D ^%ZTLOAD D XIT Q
 Q
 ;
XIT ;
 L -^APCMM25C
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
 ;
LISTS ;any lists with measures?
 K APCMLIST,APCMQUIT
 W !!,"PATIENT LISTS"
 I '$D(^XUSEC("APCMZ PATIENT LISTS",DUZ)) W !!,"You do not have the security access to print patient lists.",!,"Please see your supervisor or program manager if you feel you should have",!,"the APCMZ PATIENT LISTS security key.",! D  Q
 .K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 S DIR(0)="Y",DIR("A")="Do you want patient lists for any of the measures",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") S APCMQ=1 Q
 I Y=0 Q
 K APCMLIST
 D EN^APCM2ASL
 I '$D(APCMLIST) W !!,"No lists selected.",!
 I $D(APCMLIST) S APCMLIST="A" ;I '$D(APCMLIST)!($D(APCMQUIT)) G LISTS ;get report type for each list
 Q
