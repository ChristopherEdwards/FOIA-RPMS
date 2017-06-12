APCM2AE ; IHS/CMI/LAB - IHS MU ; 07 Oct 2015  1:21 PM
 ;;1.0;MU PERFORMANCE REPORTS;**7**;MAR 26, 2012;Build 15
 ;
 ;
 W:$D(IOF) @IOF
EP D XIT
INTRO ;
 S APCMRPTT=1
 W !!!
 W $$CTR("***IHS Modified Stage 2 MU Performance Reports for EPS***",80),!
 W $$CTR("Alternate Stage 1 Exclusions",80),!
 W !,"This report displays the performance measure results for Modified",!
 W "Stage 2 Meaningful Use with alternate Stage 1 exclusions/thresholds.",!
 W !,"In order to achieve Meaningful Use, an EP must attest to meeting",!
 W "all 10 objectives and their associated performance measures.",!
 W !,"The report can be run for 90 days, 1 year or a user defined time period.",!
 S DIR(0)="Y",DIR("A")="Do you wish to continue to report",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 ;
 W !! S X=0 F  S X=$O(^APCM25OB(X)) Q:X'=+X  I $P(^APCM25OB(X,0),U,2)="E" S APCMIND(X)=""
RT ;
 S APCMSUM="S"
TP ;
 S APCMRPTP=""
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
 S APCMLD=$E(APCMPER,1,3)_"0101",APCMHD=$E(APCMPER,1,3)_"1231"
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
 .I APCMRPTP=1 D 5 Q
 .I APCMRPTP=2 S APCMBD=APCMLD,APCMED=APCMHD  W !!,"Date range is: ",$$FMTE^XLFDT(APCMBD)," - ",$$FMTE^XLFDT(APCMED),"." Q
 .I APCMRPTP=3 D 6 Q
 I APCMBD="" G TP
 I APCMED="" G TP
 ;
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
 K APCMADDQ
 ;
ATTEST ;get answers to attestation
 D ATTESTQ
 I APCMQ G PRV
SUM ;display summary
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF MODIFIED STAGE 2 REPORT TO BE GENERATED")
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
 S XBRP="",XBRC="NODEV1^APCM2AE",XBRX="XIT^APCM2AE",XBNS="APCM"
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
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCM2AE",ZTDTH="",ZTDESC="MODIFIED STAGE 2 REPORT" D ^%ZTLOAD D XIT Q
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
CTR(X,Y) ;EP - Center X
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
USR() ;EP - Return USER
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
6 ;EP
C ;EP
 S (APCMVDT,APCMBD,APCMED)=""
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date"
 D ^DIR I $D(DIRUT) S APCMQ=1 Q
 I Y<0 S APCMQ=1 Q
 I Y>DT W !!,"Future dates not allowed." G C
 I Y<APCMLD W !!,"The beginning date must be within calendar year entered." G C
 I Y>APCMHD W !!,"The beginning date must be within calendar year entered." G C
 S APCMBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date"
 D ^DIR G:Y<1 C
 I Y>APCMHD W !!,"The ending date must be within calendar year entered." G C
 S APCMED=Y
 ;
 I APCMED<APCMBD D  G C
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 Q
5 ;EP - TEXT
 ;W !!,"Enter the start date of the 90-day report period.",!
 S (APCMVDT,APCMBD,APCMED)=""
 W ! K DIR,X,Y
 S DIR(0)="D^::E"
 S DIR("A")="Enter Start Date for the 90-Day Report (e.g. 01/01/2015)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S APCMQ=1 Q
 I Y<APCMLD W !!,"The 90 day start and end dates must be within the calendar year entered." G 5
 I $$FMADD^XLFDT(Y,89)>APCMHD W !!,"The end date would be ",$$FMTE^XLFDT($$FMADD^XLFDT(Y,89)),".",!,"The 90 day start and end dates must be within the calendar year entered." G 5
 S APCMBD=Y,APCMED=$$FMADD^XLFDT(APCMBD,89)
 Q
 ;
CXIT ;
 K DIR
 Q
EPRES ;EP - ask additional exclusion questions for e-prescribing
 S APCMQ=0
 S APCMY=$O(^APCM25OB("B","S2.003.EP",0))
 ;Q:'$D(APCMIND(APCMY))  ;measure not being run
 K APCMADDQ("ANS",APCMY)
 ;display exclusion text/narrative
 I $O(^APCM25OB(APCMY,26,0)) D ET
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
 .S APCMZ=0 F  S APCMZ=$O(^APCM25OB(APCMY,24,APCMZ)) Q:APCMZ'=+APCMZ  W !,^APCM25OB(APCMY,24,APCMZ,0)
 .W ! S DIR(0)="Y",DIR("A")=$E($P(^VA(200,APCMP,0),U,1),1,25)_"'s answer",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMADDQ("ANS",APCMY,24,APCMP)=$S(Y:"Yes",1:"No")
 .Q:Y
 .W ! S X=0 F  S X=$O(^APCM25OB(APCMY,25,X)) Q:X'=+X  W !,^APCM25OB(APCMY,25,X,0)
 .;
 .W ! S DIR(0)="Y",DIR("A")=$E($P(^VA(200,APCMP,0),U,1),1,25)_"'s answer",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQ=1 Q
 .S APCMADDQ("ANS",APCMY,25,APCMP)=$S(Y:"Yes",1:"No")
 Q
ET ;
 W ! S APCMZ=0 F  S APCMZ=$O(^APCM25OB(APCMY,26,APCMZ)) Q:APCMZ'=+APCMZ  W !,^APCM25OB(APCMY,26,APCMZ,0)
 W !
 Q
ATTESTQ ;EP
 K APCMATTE
 S APCMQ=0
 S Z=0 F  S Z=$O(^APCM25OB("ALTA",Z)) Q:Z'=+Z  S A=0 F  S A=$O(^APCM25OB("ALTA",Z,A)) Q:A'=+A  I $D(APCMIND(A)) S X=$P(^APCM25OB(A,0),U,1) D
 .S Y=0 F  S Y=$O(APCMPRV(Y)) Q:Y'=+Y  S APCMATTE(X,Y)="",APCMORA(Z,X)=""
 I '$D(APCMATTE) Q  ;no measures with attestation being run
 S APCMQ=0
 I APCMPLTY="SEL"!(APCMPLTY="TAX") D
 .W !!,"Each of the questions below may be addressed as a group or individual",!,"attestation.",!
 ;PROTECT
 I $D(APCMATTE("S2.014.EP")) D
 .S APCMQU=19,APCMAP=1,APCMX="S2.014.EP" D ASK
 Q:APCMQ
 I $D(APCMATTE("S2.010.EP.1")) D
 .S APCMQU=$S($E(APCMPER,1,3)=315:32,$E(APCMPER,1,3)=316:33,1:19),APCMAP=1,APCMX="S2.010.EP.1" D ASK
 Q:APCMQ
 I $D(APCMATTE("S2.010.EP.2")) D
 .S APCMQU=19,APCMAP=1,APCMX="S2.010.EP.2" D ASK
 Q:APCMQ
 I $D(APCMATTE("S2.001.1EP")) D
 .W !!,"CPOE Exclusions:"
 .W !,"If the provider is scheduled to demonstrate Stage 1 for an EHR"
 .W !,"reporting period in 2015 or 2016, the provider may claim the "
 .W !,"exclusions below."
 .S APCMQU=32,APCMAP=1,APCMX="S2.001.1EP" D ASK
 Q:APCMQ
 I $D(APCMATTE("S2.001.2EP")) D
 .I '$D(APCMATTE("S2.001.1EP")) D
 ..W !,"CPOE Exclusions:"
 ..W !!,"If the provider is scheduled to demonstrate Stage 1 for an EHR"
 ..W !,"reporting period in 2015 or 2016, the provider may claim the "
 ..W !,"exclusions below."
 .S APCMQU=32,APCMAP=1,APCMX="S2.001.2EP" D ASK
 Q:APCMQ
 I $D(APCMATTE("S2.003.EP")) D
 .S APCMQU=32,APCMAP=1,APCMX="S2.003.EP" D EPRES
 Q:APCMQ
 I $D(APCMATTE("S2.023.EP"))  D
 .I $E(APCMPER,1,3)=315 D
 ..W !!,"If the provider is scheduled to demonstrate Stage 1 for an EHR"
 ..W !,"reporting period in 2015, the provider may claim one or more of the"
 ..W !,"alternate exclusions below."
 ..S APCMQU=32,APCMAP=2,APCMX="S2.023.EP" D ASK
 .;S APCMQU=19,APCMAP=1,APCMX="S2.023.EP" D ASK
 Q:APCMQ
 I $D(APCMATTE("S2.021.EP")),$E(APCMPER,1,3)=315 D
 .I '$D(APCMATTE("S2.023.EP")) D
 ..W !!,"If the provider is scheduled to demonstrate Stage 1 for an EHR"
 ..W !,"reporting period in 2015, the provider may claim one or more of the"
 ..W !,"alternate exclusions below."
 .S APCMQU=32,APCMAP=1,APCMX="S2.021.EP" D ASK
 Q:APCMQ
 I $D(APCMATTE("S2.022.EP")),$E(APCMPER,1,3)=315 D
 .I '$D(APCMATTE("S2.021.EP")) D
 ..W !!,"If the provider is scheduled to demonstrate Stage 1 for an EHR"
 ..W !,"reporting period in 2015, the provider may claim one or more of the"
 ..W !,"alternate exclusions below."
 .S APCMQU=32,APCMAP=1,APCMX="S2.022.EP" D ASK
 Q:APCMQ
 I $D(APCMATTE("S2.020.EP")) D
 .I $E(APCMPER,1,3)=315 D
 ..I '$D(APCMATTE("S2.022.EP")) D
 ...W !!,"If the provider is scheduled to demonstrate Stage 1 for an EHR"
 ...W !,"reporting period in 2015, the provider may claim one or more of the"
 ...W !,"alternate exclusions below."
 ..S APCMQU=32,APCMAP=2,APCMX="S2.020.EP.1" D ASK
 .Q:APCMQ
 .;S APCMQU=19,APCMAP=1,APCMX="S2.020.EP.1" D ASK
 Q:APCMQ
 I $D(APCMATTE("S2.026.EP")),$E(APCMPER,1,3)=315 D
 .I '$D(APCMATTE("S2.020.EP")) D
 ..W !!,"If the provider is scheduled to demonstrate Stage 1 for an EHR"
 ..W !,"reporting period in 2015, the provider may claim one or more of the"
 ..W !,"alternate exclusions below."
 .S APCMQU=32,APCMAP=3,APCMX="S2.026.EP" D ASK
 .;Q:$D(APCMATTE("S2.020.EP.1")) ;ALREADY ASKED
 Q:APCMQ
 I $D(APCMATTE("S2.026.EP"))!($D(APCMATTE("S2.020.EP.1"))) D
 .S APCMQU=19,APCMAP=1,APCMX="S2.026.EP" D ASK
 .I $E(APCMPER,1,3)=315 S APCMQU=31,APCMAP=2,APCMX="S2.026.EP" D ASK
 S APCMQU=19
 I $D(APCMATTE("S2.024.EP")) S APCMX="S2.024.EP",APCMQU=32 D IMMREG
 Q:APCMQ
 S APCMQU=19
 I $D(APCMATTE("S2.025.EP")) S APCMX="S2.025.EP" D IMMREG
 Q:APCMQ
 S APCMQU=19
 I $D(APCMATTE("S2.030.EP")) S APCMX="S2.030.EP" D IMMREG
 Q
ASK ;
 D
 .S APCMY=$O(^APCM25OB("B",APCMX,0))
 .Q:'$O(^APCM25OB(APCMY,APCMQU,0))
 .W !
 .I APCMX="S2.020.EP.1",APCMAP=1 S Y=$O(^APCM25OB("B","S2.026.EP",0)) Q:$D(APCMIND(Y))
 .S X=0 F  S X=$O(^APCM25OB(APCMY,APCMQU,X)) Q:X'=+X  W !,^APCM25OB(APCMY,APCMQU,X,0)
 .I APCMPLTY="SEL"!(APCMPLTY="TAX") D  G:APCMIND ATTIND Q
 ..S APCMIND=0
 ..I '$P(^APCM25OB(APCMY,0),U,13) D
 ...W ! S DIR(0)="Y",DIR("A")="Do all selected providers included in this report"_$$T(APCMY,APCMQU)
 ...S DIR("B")="YES" I $P(^APCM25OB(APCMY,0),U,1)="S2.020.EP.1",APCMQU'=32 S DIR("B")="NO"
 ...I APCMQU=19,$P(^APCM25OB(APCMY,0),U,1)="S2.026.EP" S DIR("B")="NO"
 ...KILL DA D ^DIR KILL DIR
 ...I $D(DIRUT) S APCMQ=1 Q
 ...I 'Y S APCMIND=1 Q
 ...S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  I $P(APCMATTE(APCMX,APCMP),U,APCMAP)'="N/A" S $P(APCMATTE(APCMX,APCMP),U,APCMAP)="Yes"
 ..I $P(^APCM25OB(APCMY,0),U,13) D
 ...W ! S DIR(0)="Y",DIR("A")="Will the following response apply to all EPs included in this report",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ...I $D(DIRUT) S APCMQ=1 Q
 ...I 'Y S APCMIND=1 Q
 ...S DIR(0)="S^Y:YES;N:NO;X:No Registry Available",DIR("A")="All selected providers included in this report attest to (Enter Y, N or X)",DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ...I $D(DIRUT) S APCMQ=1 Q
 ...S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP  S $P(APCMATTE(APCMX,APCMP),U,APCMAP)=$S(Y="X":"N/A",Y="Y":"Yes",Y="N":"No",Y:"Yes",1:"No")
ATTIND .;
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP!(APCMQ)  D
 ..W !
 ..I '$P(^APCM25OB(APCMY,0),U,13) S DIR(0)="Y",DIR("A")="Does "_$E($P(^VA(200,APCMP,0),U,1),1,25)_$$T(APCMY,APCMQU)
 ..S DIR("B")="YES" I $P(^APCM25OB(APCMY,0),U,1)="S2.020.EP.1",APCMQU'=32 S DIR("B")="NO"
 ..I APCMQU=19,$P(^APCM25OB(APCMY,0),U,1)="S2.026.EP" S DIR("B")="NO"
 ..KILL DA D ^DIR KILL DIR
 ..I $P(^APCM25OB(APCMY,0),U,13) S DIR(0)="S^Y:YES;N:NO;X:No Registry Available" D
 ...S DIR("A")="Does "_$E($P(^VA(200,APCMP,0),U,1),1,25)_$$T(APCMY,APCMQU),DIR("B")="YES" KILL DA D ^DIR KILL DIR
 ..I $D(DIRUT) S APCMQ=1 Q
 ..S $P(APCMATTE(APCMX,APCMP),U,APCMAP)=$S(Y="X":"N/A",Y="Y":"Yes",Y="N":"No",Y:"Yes",1:"No")
 Q
IMMREG ;EP - ask 
 D IMMREG^APCM2AEA
 Q
SPECREG ;
 D SPECREG^APCM2AEA
 Q
SS D SS^APCM2AEA
 Q
T(APCMY,APCMQU) ;
 I APCMQU=32,$P(^APCM25OB(APCMY,0),U,1)="S2.020.EP.1" Q " claim this exclusion"
 I APCMQU=32,$P(^APCM25OB(APCMY,0),U,1)="S2.026.EP" Q " claim this exclusion"
 I APCMQU=31 Q " attest to this"
 NEW %
 S %=$S($P($G(^APCM25OB(APCMY,11)),U,1)]"":$P(^APCM25OB(APCMY,11),U,1),1:" attest to this")
 Q %
