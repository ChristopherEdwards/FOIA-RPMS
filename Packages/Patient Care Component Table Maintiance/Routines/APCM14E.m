APCM14E ; IHS/CMI/LAB - IHS MU ;
 ;;1.0;IHS MU PERFORMANCE REPORTS;**5,6**;MAR 26, 2012;Build 65
 ;
 ;
 W:$D(IOF) @IOF
 D XIT
INTRO ;
 S APCMRPTT=1  ;CONTROL VARIABLE FOR EP REPORT
 S APCMRPTC=$O(^APCMMUCN("B","INTERIM STAGE 1 2014",0))
 W !!!
 S X=0 F  S X=$O(^APCMMUCN(APCMRPTC,11,X)) Q:X'=+X  W ^APCMMUCN(APCMRPTC,11,X,0),!
 S DIR(0)="Y",DIR("A")="Do you wish to continue to report",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 ;gather up measures for this report
 S X=0 F  S X=$O(^APCM14OB(X)) Q:X'=+X  I $P(^APCM14OB(X,0),U,2)="E" S APCMIND(X)=""
RT ;
 S APCMSUM="S"
TP ;
 S APCMRPTP=""
 ;W !!,"Report may be run for a quarter, 90-days, a one year or a user defined period."
 ;display note
 W !!
 S X=0 F  S X=$O(^APCMMUCN(APCMRPTC,17,X)) Q:X'=+X  W ^APCMMUCN(APCMRPTC,17,X,0),!
YEAR ;
 S (APCMPER,APCMVDT,APCMBD,APCMED)=""
 W !!,"Enter the Calendar Year for which report is to be run.  Use a 4 digit",!,"year, e.g. 2014."
 S DIR(0)="D^::EP"
 S DIR("A")="Enter the Calendar Year"
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
 .W !?10,"1  Quarter: January 1 - March 31"
 .W !?10,"2  Quarter: April 1 - June 30"
 .W !?10,"3  Quarter: July 1 - September 30"
 .W !?10,"4  Quarter: October 1 - December 31"
 .W !?10,"5  User Defined 90-Day Report"
 .W !?10,"6  User Defined Date Range"
 .S DIR(0)="N^1:6:",DIR("A")="Select Report Period" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1
 .S APCMRPTP=Y
 .I APCMRPTP=1 S APCMBD=$E(APCMPER,1,3)_"0101",APCMED=$E(APCMPER,1,3)_"0331" Q
 .I APCMRPTP=2 S APCMBD=$E(APCMPER,1,3)_"0401",APCMED=$E(APCMPER,1,3)_"0630" Q
 .I APCMRPTP=3 S APCMBD=$E(APCMPER,1,3)_"0701",APCMED=$E(APCMPER,1,3)_"0930" Q
 .I APCMRPTP=4 S APCMBD=$E(APCMPER,1,3)_"1001",APCMED=$E(APCMPER,1,3)_"1231" Q
 .I APCMRPTP=5 D 5 Q
 .I APCMRPTP=6 D 6 Q
 I APCMPER="3150000"  D  G:APCMQ YEAR
 .W !!,"Select one of the following:",!
 .W !?10,"1  Year: January 1 - December 31"
 .W !?10,"2  User Defined 90-Day Report"
 .W !?10,"3  User Defined Date Range"
 .S DIR(0)="N^1:3:",DIR("A")="Select Report Period" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1
 .S APCMRPTP=Y
 .I APCMRPTP=1 S APCMBD=$E(APCMPER,1,3)_"0101",APCMED=$E(APCMPER,1,3)_"1231" Q
 .I APCMRPTP=2 D 5 Q
 .I APCMRPTP=3 D 6 Q
 I APCMBD="" G TP
 I APCMED="" G TP
 ;S X=$O(^APCM14OB("B","S1.002.EP",0))
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
PRV ;
 S APCMPLTY=""
 S DIR(0)="S^IP:Individual Provider;SEL:Selected Providers (User Defined);TAX:Provider Taxonomy List",DIR("A")="Enter Selection" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G TP
 S APCMPLTY=Y
 S APCMQUIT=""
 I APCMPLTY="IP" D  I $G(APCMQUIT) G PRV
 .K APCMPRV
 .W !!,"Enter the name of the provider for whom the Meaningful Use Report will be run.",!
 .S DIC="^VA(200,",DIC(0)="AEMQ",D="AK.PROVIDER",DIC("A")="Enter PROVIDER NAME: " D MIX^DIC1 K DIC,D
 .I Y<0 S APCMQUIT=1 Q
 .S APCMPRV(+Y)=""
 I APCMPLTY="SEL" D  I $G(APCMQUIT) G PRV
 .K APCMPRV
 .W !!,"Enter the name of the provider for whom the Meaningful Use Report will be run.",!
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
 K APCMADDQ,APCMATTE
 S A=$O(^APCM14OB("B","S1.008.EP",0))
 S B=$O(^APCM14OB("B","S1.003.EP",0))
 S C=$O(^APCM14OB("B","S1.020.EP",0))
 I '$D(APCMIND(A)),'$D(APCMIND(B)),'$D(APCMIND(C)) G ATTEST
 W !!,"Please answer the following exclusion questions for each provider."
 D EPRES ;ASK ADDITIONAL QUESTIONS FOR E-PRESCRIBING
 I APCMQ G DEMO
 D VITALS ;ASK ADDITIONAL QUESTIONS FOR VITALS
 I APCMQ G ASKADD
 D VDT^APCM14E1
 I APCMQ G ASKADD
ATTEST ;get answers to attestation questions for each provider.
 D ATTESTQ
 I APCMQ G ASKADD
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF STAGE 1 2014/2015 MEANINGFUL USE REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(APCMBD)," to ",?31,$$FMTE^XLFDT(APCMED)
 W !!,"Providers: "
 S X=0 F  S X=$O(APCMPRV(X)) Q:X'=+X  W !?5,$P(^VA(200,X,0),U,1)
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
 S XBRP="",XBRC="NODEV1^APCM14E",XBRX="XIT^APCM14E",XBNS="APCM"
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
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCM14E",ZTDTH="",ZTDESC="2014 MU STAGE 1 REPORT" D ^%ZTLOAD D XIT Q
 Q
 ;
XIT ;
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
 ;----------
 ;
5 ;
B ;
 W !
 S (APCMPER,APCMVDT,APCMBD,APCMED)=""
 W ! K DIR,X,Y S DIR(0)="D^::EP",DIR("A")="Enter Start Date for the 90-Day Report (e.g. 01/01/2014)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 S (APCMPER,APCMVDT)=Y
 S APCMBD=Y,APCMED=$$FMADD^XLFDT(APCMBD,89)
 Q
6 ;EP
C ;EP
 S (APCMPER,APCMVDT,APCMBD,APCMED)=""
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date"
 D ^DIR G:Y<1 CXIT
 I Y>DT W !!,"Future dates not allowed." G C
 S APCMBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date"
 D ^DIR G:Y<1 C  S APCMED=Y
 ;
 I APCMED<APCMBD D  G C
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 Q
CXIT ;
 K DIR
 Q
EPRES ;EP - ask additional exclusion questions for e-prescribing
 S APCMQ=0
 S APCMY=$O(^APCM14OB("B","S1.003.EP",0))
 Q:'$D(APCMIND(APCMY))  ;measure not being run
 K APCMADDQ("ANS",APCMY)
 ;display exclusion text/narrative
 I $O(^APCM14OB(APCMY,26,0)) D ET
 I APCMPLTY="SEL"!(APCMPLTY="TAX") D  G:APCMIND=1 EIND Q
 .S APCMQ=0,APCMIND=0
 .W !,"The e-Prescribing onsite pharmacy question below may be addressed as a group or"
 .W !,"by individual provider. Do you want to answer for all selected providers as a"
 .S DIR(0)="Y",DIR("A")="group Y/N",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .I 'Y S APCMIND=1 Q
 .W !!,"Do all selected providers included in this report have an onsite"
 .S DIR(0)="Y",DIR("A")="pharmacy Y/N",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .I 'Y S APCMIND=1 Q
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  S APCMADDQ("ANS",APCMY,24,APCMP)="Yes"
EIND ;ask individually
 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP!(APCMQ)  D
 .S APCMZ=0 F  S APCMZ=$O(^APCM14OB(APCMY,24,APCMZ)) Q:APCMZ'=+APCMZ  W !,^APCM14OB(APCMY,24,APCMZ,0)
 .S DIR(0)="Y",DIR("A")=$E($P(^VA(200,APCMP,0),U,1),1,25)_"'s answer",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMADDQ("ANS",APCMY,24,APCMP)=$S(Y:"Yes",1:"No")
 .Q:Y
 .W ! S X=0 F  S X=$O(^APCM14OB(APCMY,25,X)) Q:X'=+X  W !,^APCM14OB(APCMY,25,X,0)
 .;S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP!(APCMQ)  D
 .S DIR(0)="Y",DIR("A")=$E($P(^VA(200,APCMP,0),U,1),1,25)_"'s answer",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMADDQ("ANS",APCMY,25,APCMP)=$S(Y:"Yes",1:"No")
 Q
ET ;
 W ! S APCMZ=0 F  S APCMZ=$O(^APCM14OB(APCMY,26,APCMZ)) Q:APCMZ'=+APCMZ  W !,^APCM14OB(APCMY,26,APCMZ,0)
 W !
 Q
VITALS ;EP - VITALS QUESTIONS
 S APCMQ=0
 S APCMY=$O(^APCM14OB("B","S1.008.EP",0))
 Q:'$D(APCMIND(APCMY))  ;measure not being run
 K APCMADDQ("ANS",APCMY)
 ;display exclusion text/narrative
 I $O(^APCM14OB(APCMY,26,0)) D ET
VIND ;ask individually
 S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP!(APCMQ)  D
 .W ! S APCMZ=0 F  S APCMZ=$O(^APCM14OB(APCMY,24,APCMZ)) Q:APCMZ'=+APCMZ  W !,^APCM14OB(APCMY,24,APCMZ,0)
 .S DIR(0)="Y",DIR("A")=$E($P(^VA(200,APCMP,0),U,1),1,25)_"'s answer",DIR("B")="NO" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMADDQ("ANS",APCMY,24,APCMP)=$S(Y:"Yes",1:"No")
 .Q:Y
 .W ! S X=0 F  S X=$O(^APCM14OB(APCMY,25,X)) Q:X'=+X  W !,^APCM14OB(APCMY,25,X,0)
 .S DIR(0)="Y",DIR("A")=$E($P(^VA(200,APCMP,0),U,1),1,25)_"'s answer",DIR("B")="NO" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMADDQ("ANS",APCMY,25,APCMP)=$S(Y:"Yes",1:"No")
 .Q:Y
 .W ! S X=0 F  S X=$O(^APCM14OB(APCMY,27,X)) Q:X'=+X  W !,^APCM14OB(APCMY,27,X,0)
 .S DIR(0)="Y",DIR("A")=$E($P(^VA(200,APCMP,0),U,1),1,25)_"'s answer",DIR("B")="NO" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMADDQ("ANS",APCMY,27,APCMP)=$S(Y:"Yes",1:"No")
 .Q:Y
 .W ! S X=0 F  S X=$O(^APCM14OB(APCMY,28,X)) Q:X'=+X  W !,^APCM14OB(APCMY,28,X,0)
 .S DIR(0)="Y",DIR("A")=$E($P(^VA(200,APCMP,0),U,1),1,25)_"'s answer",DIR("B")="NO" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMADDQ("ANS",APCMY,28,APCMP)=$S(Y:"Yes",1:"No")
 Q
ATTESTQ ;EP
 S APCMQ=0
 S Z=0 F  S Z=$O(^APCM14OB("EOORDER",Z)) Q:Z'=+Z  S X=$O(^APCM14OB("EOORDER",Z,0)) I $D(APCMIND(X)),$P(^APCM14OB(X,0),U,17) S X=$P(^APCM14OB(X,0),U,1) D
 .S Y=0 F  S Y=$O(APCMPRV(Y)) Q:Y'=+Y  S APCMATTE(X,Y)=""
 I '$D(APCMATTE) Q  ;no measures with attestation being run
 W !!,"Several Stage 1 Meaningful Use Performance Measures require an attestation of "
 W !,"Yes or No for each provider for which the report is being run.",!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCMQ=1 Q
 I 'Y S APCMQ=1 Q
 S APCMQ=0
 I APCMPLTY="SEL"!(APCMPLTY="TAX") D
 .W !!,"Each of the questions below may be addressed as a group or individual",!,"attestation.",!
 S APCMX="" F  S APCMX=$O(APCMATTE(APCMX)) Q:APCMX=""!(APCMQ)  D
 .;WRITE QUESTION
 .Q:APCMX="S1.020.EP.1"
 .W !
 .S APCMY=$O(^APCM14OB("B",APCMX,0))
 .S X=0 F  S X=$O(^APCM14OB(APCMY,19,X)) Q:X'=+X  W !,^APCM14OB(APCMY,19,X,0)
 .I APCMPLTY="SEL"!(APCMPLTY="TAX") D  G:APCMIND ATTIND Q
 ..S APCMIND=0
 ..I '$P(^APCM14OB(APCMY,0),U,13) D
 ...W ! S DIR(0)="Y",DIR("A")="Do all selected providers included in this report attest to this",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ...I $D(DIRUT) S APCMQ=1 Q
 ...I 'Y S APCMIND=1 Q
 ...S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  S APCMATTE(APCMX,APCMP)="Yes"
 ..I $P(^APCM14OB(APCMY,0),U,13) D
 ...W ! S DIR(0)="Y",DIR("A")="Will the following response apply to all EPs included in this report",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ...I $D(DIRUT) S APCMQ=1 Q
 ...I 'Y S APCMIND=1 Q
 ...S DIR(0)="S^Y:YES;N:NO;X:No Registry Available",DIR("A")="All selected providers included in this report attest to (Enter Y, N or X)",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ...I $D(DIRUT) S APCMQ=1 Q
 ...S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  S APCMATTE(APCMX,APCMP)=$S(Y="X":"N/A",Y="Y":"Yes",Y="N":"No",Y:"Yes",1:"No")
ATTIND .;
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP!(APCMQ)  D
 ..I '$P(^APCM14OB(APCMY,0),U,13) S DIR(0)="Y",DIR("A")="Does "_$E($P(^VA(200,APCMP,0),U,1),1,25)_" attest to this",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ..I $P(^APCM14OB(APCMY,0),U,13) S DIR(0)="S^Y:YES;N:NO;X:No Registry Available",DIR("A")="Does "_$E($P(^VA(200,APCMP,0),U,1),1,25)_" attest to this",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ..I $D(DIRUT) S APCMQ=1 Q
 ..S APCMATTE(APCMX,APCMP)=$S(Y="X":"N/A",Y="Y":"Yes",Y="N":"No",Y:"Yes",1:"No")
 Q
