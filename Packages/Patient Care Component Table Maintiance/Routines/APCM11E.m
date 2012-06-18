APCM11E ;IHS/CMI/LAB - IHS MU;
 ;;2.0;IHS PCC SUITE;**6**;MAY 14, 2009;Build 11
 ;
 ;
 W:$D(IOF) @IOF
 ;W !!,$$CTR("IHS 2011 Stage 1 Meaningful Use Performance Report for EPs",80),!
 D XIT
INTRO ;
 S APCMRPTT=1  ;CONTROL VARIABLE FOR EP REPORT
 S APCMRPTC=$O(^APCMMUCN("B","INTERIM STAGE 1 2011",0))
 W !
 S X=0 F  S X=$O(^APCMMUCN(APCMRPTC,11,X)) Q:X'=+X  W ^APCMMUCN(APCMRPTC,11,X,0),!
 K DIR S DIR(0)="E",DIR("A")="Press Enter to Continue" D ^DIR K DIR,DUOUT,DIRUT
 ;NOTICE
 W !!!
 S X=0 F  S X=$O(^APCMMUCN(APCMRPTC,12,X)) Q:X'=+X  W ^APCMMUCN(APCMRPTC,12,X,0),!
 S DIR(0)="Y",DIR("A")="Do you wish to continue to report",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 ;gather up measures for this report
 S X=0 F  S X=$O(^APCMMUM(X)) Q:X'=+X  I $P(^APCMMUM(X,0),U,2)="E" S APCMIND(X)=""
RT ;
 S APCMSUM=""
 W !!,"A full report will include an itemized listing of all performance measures"
 W !,"and will include a summary report.  The summary report excludes itemized"
 W !,"data.  The full report will produce approximately 40 pages of data for"
 W !,"each provider. Please take this into consideration when running print jobs,"
 W !,"ensuring dedicated time on your printer and sufficient paper supplies"
 W !,"to complete your job. "
 S DIR(0)="S^F:Full Report;S:Summary Report",DIR("A")="Enter Selection",DIR("B")="F" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S APCMSUM=Y
TP ;
 S APCMRPTP=""
 W !!,"Report may be run for a 90-day or a one year period.  " ;The 90-day period"
 ;W !,"may be automatically defined or user may select a specific start date."
 ;W !!,"The automated reprt will return the first 90-day peiod in the calendar"
 ;W !,"year in which all meaningful use objectives have been met.  If all"
 ;W !,"objectives have not been met, the report will return results on the highest"
 ;W !,"average 90-day performance period within the calendar year.",!
 S DIR(0)="S^A:January 1 - December 31;B:User Defined 90-Day Report",DIR("A")="Select Report Period" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G RT
 S APCMRPTP=Y
 D @APCMRPTP
 I APCMBD="" G TP
 I APCMRPTP="C" D  I $G(APCMQUIT) G TP
 .S APCMQUIT=""
 .W !!,$$CTR("*** IMPORTANT NOTICE ***")
 .W !,"This report may take several hours to run and could potentially slow"
 .W !,"your system performance.  Please queue this report to run after normal"
 .W !,"working hours.",!
 .S DIR(0)="Y",DIR("A")="Do you wish to continue to report",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCMQUIT=1 Q
 .I 'Y S APCMQUIT=1 Q
PP ;
 S APCMWPP=""
 I APCMRPTP="A" W !!,"Historical data from the previous calendar year can be included in this report."
 I APCMRPTP="B" W !!,"Historical data from the 90-days immediately preceding the currently",!,"selected report period can be included."
 W !,"IMPORTANT NOTICE: Including previous period data may significantly increase ",!,"run time.",!
 S DIR(0)="Y",DIR("A")="Do you wish to include the previous period",DIR("B")="Y"	KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G TP
 S APCMWPP=Y
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
PL ;do you want any patient lists
 I $G(APCMIWPL) D LISTS
DEMO ;
 D DEMOCHK^APCLUTL(.APCMDEMO)
 I APCMDEMO=-1 G PRV
ATTEST ;get answers to attestation questions for each provider.
 K APCMATTE
 F X="S1.010.EP","S1.013.EP","S1.014.EP","S1.015.EP","S1.018.EP","S1.020.EP","S1.024.EP","S1.025.EP" S Y=0 F  S Y=$O(APCMPRV(Y)) Q:Y'=+Y  S APCMATTE(X,Y)=""
 W !!,"Several Stage 1 Meaningful Use Performance Measures require an attestation of "
 W !,"Yes or No for each provider for which the report is being run.",!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PRV
 I 'Y G PRV
 S APCMQ=0
 S APCMX="" F  S APCMX=$O(APCMATTE(APCMX)) Q:APCMX=""!(APCMQ)  D
 .;WRITE QUESTION
 .W !
 .S APCMY=$O(^APCMMUM("B",APCMX,0))
 .S X=0 F  S X=$O(^APCMMUM(APCMY,19,X)) Q:X'=+X  W !,^APCMMUM(APCMY,19,X,0)
 .S APCMP=0 F  S APCMP=$O(APCMPRV(APCMP)) Q:APCMP'=+APCMP!(APCMQ)  D
 ..I '$P(^APCMMUM(APCMY,0),U,13) S DIR(0)="Y",DIR("A")="Does "_$E($P(^VA(200,APCMP,0),U,1),1,25)_" attest to this",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 ..I $P(^APCMMUM(APCMY,0),U,13) S DIR(0)="S^Y:YES;N:NO;X:No Registry Available",DIR("A")="Does "_$E($P(^VA(200,APCMP,0),U,1),1,25)_" attest to this",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 ..I $D(DIRUT) S APCMQ=1 Q
 ..S APCMATTE(APCMX,APCMP)=$S(Y="X":"N/A",Y="Y":"Yes",Y="N":"No",Y:"Yes",1:"No")
 I APCMQ G DEMO
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF 2011 MEANINGFUL USE REPORT TO BE GENERATED")
 W !!,"The date ranges for this report are:"
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(APCMBD)," to ",?31,$$FMTE^XLFDT(APCMED)
 I $G(APCMWPP) W !?5,"Previous Period: ",?31,$$FMTE^XLFDT(APCMPBD)," to ",?31,$$FMTE^XLFDT(APCMPED)
 W !!,"Providers: "
 S X=0 F  S X=$O(APCMPRV(X)) Q:X'=+X  W !?5,$P(^VA(200,X,0),U,1)
 D PT^APCM11SL
 I APCMROT="" G DEMO
ZIS ;call to XBDBQUE
 D REPORT^APCM11SL
 I $G(APCMQUIT) D XIT Q
 I APCMRPT="" D XIT Q
 K IOP,%ZIS I APCMROT="D",APCMDELT="F" D NODEV,XIT Q
 K IOP,%ZIS W !! S %ZIS=$S(APCMDELT'="S":"PQM",1:"PM") D ^%ZIS
 I POP W !,"Report Aborted" S DA=APCMRPT,DIK="^APCMMUDC(" D ^DIK K DIK D XIT Q
 I POP W !,"Report Aborted" S DA=APCMRPT,DIK="^APCMMUDP(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D PROC^APCM11E1
 U IO
 D ^APCM11EP
 D ^%ZISC
 D XIT
 Q
 ;
NODEV ;
 S XBRP="",XBRC="NODEV1^APCM11E",XBRX="XIT^APCM11E",XBNS="APCM"
 D ^XBDBQUE
 Q
 ;
NODEV1 ;
 D PROC^APCM11E1
 D ^APCM11EP
 D ^%ZISC
 D XIT
 Q
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("APCM*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCM11E",ZTDTH="",ZTDESC="2011 MU STAGE 1 REPORT" D ^%ZTLOAD D XIT Q
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
LISTS ;any lists with measures?
 K APCMLIST,APCMQUIT
 W !!,"PATIENT LISTS"
 I '$D(^XUSEC("APCMZ PATIENT LISTS",DUZ)) W !!,"You do not have the security access to print patient lists.",!,"Please see your supervisor or program manager if you feel you should have",!,"the APCMZ PATIENT LISTS security key.",! D  Q
 .K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 S DIR(0)="Y",DIR("A")="Do you want patient lists for any of the measures",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") Q
 I Y=0 Q
 K APCMLIST
 D EN^APCM11SL
 I '$D(APCMLIST) W !!,"No lists selected.",!
 I $D(APCMLIST) D RT^APCM11SL I '$D(APCMLIST)!($D(APCMQUIT)) G LISTS ;get report type for each list
 Q
A ;fiscal year
 S (APCMPER,APCMVDT,APCMBD,APCMED)=""
 W !!,"Enter the Calendar Year for which report is to be run.  Use a 4 digit",!,"year, e.g. 2011."
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year"
 S DIR("?")="This report is compiled for a period.  Enter a valid year."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S APCMVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G A
 S APCMPER=APCMVDT
 S APCMBD=$E(APCMPER,1,3)_"0101",APCMED=$E(APCMPER,1,3)_"1231"
 S APCMPBD=($E(APCMPER,1,3)-1)_"0101",APCMPED=($E(APCMPER,1,3)-1)_"1231"
 Q
B ;
 W !!,"Enter the start date of the 90-day report period.",!
 S (APCMPER,APCMVDT,APCMBD,APCMED)=""
 W ! K DIR,X,Y S DIR(0)="D^::EP",DIR("A")="Enter Start Date for the 90-Day Report (e.g. 01/01/2011)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 S (APCMPER,APCMVDT)=Y
 S APCMBD=Y,APCMED=$$FMADD^XLFDT(APCMBD,89)
 S APCMPED=$$FMADD^XLFDT(APCMBD,-1),APCMPBD=$$FMADD^XLFDT(APCMPED,-89)
 Q
C ;
 S (APCMPER,APCMVDT,APCMBD,APCMED)=""
 W !!,"Enter the Calendar Year for which report is to be run.  Use a 4 digit",!,"year, e.g. 2011.  This is the year that will be used to find an ",!,"automated 90-Day time period.",!!
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year"
 S DIR("?")="This report is compiled for a period.  Enter a valid year."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S APCMVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G C
 S APCMPER=APCMVDT
 S APCMBD=$E(APCMPER,1,3)_"0101",APCMED=$$FMADD^XLFDT(APCMBD,89)
 S APCMPBD=($E(APCMPER,1,3)-1)_"0101",APCMPED=$$FMADD^XLFDT(APCMPBD,89)
 Q
