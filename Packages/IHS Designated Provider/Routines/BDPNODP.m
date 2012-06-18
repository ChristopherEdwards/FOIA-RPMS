BDPNODP ;IHS/CMI/LAB - listing of patients with no desg prov
 ;;2.0;IHS PCC SUITE;**7**;MAY 14, 2009
 ;
 ;
INFORM ;
 W !!,"This report will generate a list of patients who do not have a designated"
 W !,"provider assigned.  The user will be able to run this report on a selected"
 W !,"set of patients or on a search template of patients.  The user will also"
 W !,"be able to select which designated provider category to report on.  For"
 W !,"example you can run this report for all females over 18 with no designated"
 W !,"Women's Health Case Manager or run the report for all patients living in"
 W !,"a particular community with no designated primary care provider."
 W !!
ST ;
 W !,"Please note that you will get a chance later to further refine the set"
 W !,"of patients to include in this report.",!
 S BDPSEAT=""
 S DIR(0)="S^A:All Patients;S:Search template (cohort) of Patients",DIR("A")="Run the report for",DIR("B")="A"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I Y="A" G PGEN
ST1 ;
 S BDPSEAT=""
 W ! S DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ"
 D ^DIC K DIC,DA,DR,DICR
 I Y=-1 G ST
 S BDPSEAT=+Y
PGEN ;
 S BDPSC=""
 W !!,"You will now be able to select criteria for which patients to "
 W !,"include in the report.  If you are running this report on a search"
 W !,"template of patients and do not want additional criteria applied"
 W !,"you can bypass the criteria selection."
 S DIR(0)="Y",DIR("A")="Do you want to apply search criteria for which subset of patients to include",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G ST
 S BDPSC=Y
 I BDPSC=0 G CAT
CONT ;
 S BDPNCAN=1 D ADD^APCLVL01 I $D(BDPQUIT) D DEL^APCLVL K BDPQUIT G ST
 S APCLTCW=0,APCLPTVS="P",APCLTYPE="P",APCLCTYP="T"
 K ^APCLVRPT(APCLRPT,11) S APCLCNTL="S" D ^APCLVL4 K APCLCNTL I $D(APCLQUIT) D DEL^APCLVL G ST
CAT ;which category
 W !!,"Enter the designated provider category for which you would like a list"
 W !,"of patients who do not have a provider assigned.",!
 S DIR(0)="90360.1,.01",DIR("A")="Enter the Designated Provider Category"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G ST
 S BDPCAT=+Y
 S BDPCATN=$P(Y,U,2)
SORT ;
 S BDPSORT=""
 S DIR(0)="S^N:Patient Name;H:HRN;C:Current Community;A:Age of the Patient"
 S DIR("A")="How do you want the list of patients sorted",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G CAT
 S BDPSORT=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.BDPDEMO)
 I BDPDEMO=-1 G SORT
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 S BDPBROW=Y
 I $G(Y)="B" D BROWSE,XIT Q
 W !! S XBRP="PRINT^BDPNODP",XBRC="PROC^BDPNODP",XBNS="BDP",XBRX="XIT^BDPNODP"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BDPNODP"")"
 S XBNS="BDP",XBRC="PROC^BDPNODP",XBRX="XIT^BDPNODP",XBIOP=0 D ^XBDBQUE
 Q
 ;
PAUSE ; 
 S DIR(0)="E",DIR("A")="Press return to continue or '^' to quit" D ^DIR K DIR,DA
 S:$D(DIRUT) BDPQUIT=1
 W:$D(IOF) @IOF
 Q
XIT ;
 D EN^XBVK("BDP")
 K L,M,S,T,X,X1,X2,Y,Z,B
 D KILL^AUPNPAT
 D ^XBFMK
 Q
PROC ;
 S BDPJOB=$J,BDPBTH=$H,BDPTOT=0,DFN=0,BDPBT=$H
 D XTMP^APCLOSUT("BDPNODP","BDP - NO DESIGNATED PROV REPORT")
 ;loop through either the template or the patient file and apply screens
 I $G(BDPSEAT) D STP Q
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:$$DEMO^APCLUTL(DFN,$G(BDPDEMO))
 .I BDPSC D SCREENS
 .Q:$D(BDPSKIP)
 .;check to see if they have a desginated provider in the category selected.
 .K R
 .D ALLDP^BDPAPI(DFN,BDPCATN,.R)
 .I $D(R) Q  ;has the provider
 .S BDPSRTV=""
 .D @BDPSORT
 .S ^XTMP("BDPNODP",BDPJOB,BDPBTH,BDPSRTV,DFN)=""
 .Q
 Q
STP ;
 S DFN=0 F  S DFN=$O(^DIBT(BDPSEAT,1,DFN)) Q:DFN'=+DFN  D
 .Q:$$DEMO^APCLUTL(DFN,$G(BDPDEMO))
 .I BDPSC D SCREENS
 .;check to see if they have a desginated provider in the category selected.
 .K R
 .D ALLDP^BDPAPI(DFN,$P(^BDPTCAT(BDPCAT,0),U,1),.R)
 .I $D(R) Q  ;has the provider
 .S BDPSRTV=""
 .D @BDPSORT
 .S ^XTMP("BDPNODP",BDPJOB,BDPBTH,BDPSRTV,DFN)=""
 .Q
 Q
SCREENS ;
 K BDPSKIP
 S APCLI=0 F  S APCLI=$O(^APCLVRPT(APCLRPT,11,APCLI)) Q:APCLI'=+APCLI!($D(BDPSKIP))  D
 .I '$P(^APCLVSTS(APCLI,0),U,8) D SINGLE Q
 .D MULT
 .Q
 Q
SINGLE ;
 K X,APCLSPEC S X="",APCLX=0
 X:$D(^APCLVSTS(APCLI,1)) ^(1)
 I X="" S BDPSKIP="" Q
 I '$D(APCLSPEC),'$D(^APCLVRPT(APCLRPT,11,APCLI,11,"B",X)) S BDPSKIP="" Q
 I $D(APCLSPEC),X="" S BDPSKIP=1 Q
 Q
MULT ;
 K APCLFOUN,BDPSKIP,APCLSPEC,X S APCLX=0,X=""
 X:$D(^APCLVSTS(APCLI,1)) ^(1)
 I $O(X(""))="" S BDPSKIP="" Q
 I '$D(APCLSPEC) S Y="" F  S Y=$O(X(Y)) Q:Y=""  I $D(^APCLVRPT(APCLRPT,11,APCLI,11,"B",Y)) S APCLFOUN="" Q
 I $D(APCLSPEC),$D(X) S APCLFOUN=1 Q
 S:'$D(APCLFOUN) BDPSKIP=""
 Q
N ;
 S BDPSRTV=$P(^DPT(DFN,0),U,1)
 Q
H ;
 S BDPSRTV=$$HRN^AUPNPAT(DFN,DUZ(2))
 Q
C S BDPSRTV=$$COMMRES^AUPNPAT(DFN,"E") Q
A S BDPSRTV=$$AGE^AUPNPAT(DFN,DT) Q
 ;
PRINT ;
 S BDP80D="-------------------------------------------------------------------------------"
 S BDPPG=0
 I '$D(^XTMP("BDPNODP",BDPJOB,BDPBTH)) D HEAD W !!,"NO PATIENTS TO REPORT" G DONE
 D HEAD
 S BDPPROV=0 F  S BDPPROV=$O(^XTMP("BDPNODP",BDPJOB,BDPBTH,BDPPROV)) Q:BDPPROV=""!($D(BDPQ))  D
 .F  S DFN=$O(^XTMP("BDPNODP",BDPJOB,BDPBTH,BDPPROV,DFN)) Q:DFN=""!($D(BDPQ))  D DFN
DONE D DONE^APCLOSUT
 K ^XTMP("BDPNODP",BDPJOB,BDPBTH),BDPJOB,BDPBTH
 Q
DFN ;
 I $Y>(IOSL-3) D HEAD Q:$D(BDPQ)
 D LVST
 W $E($P(^DPT(DFN,0),U),1,20),?24,$$UP^XLFSTR($$DOB^AUPNPAT(DFN,"E")),?40,$$HRN^AUPNPAT(DFN,DUZ(2)),?50,$E($$COMMRES^AUPNPAT(DFN,"E"),1,15),?66,BDPDT,!
 Q
HEAD I 'BDPPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDPQ="" Q
HEAD1 ;
 I BDPPG W:$D(IOF) @IOF
 S BDPPG=BDPPG+1
 W $P(^VA(200,DUZ,0),U,2),?30,$$FMTE^XLFDT($$NOW^XLFDT),?70,"PAGE  "_BDPPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W $$CTR("PATIENTS WITH NO "_BDPCATN_" DESIGNATED PROVIDER",80),!
 I BDPSEAT W !,$$CTR("SEARCH TEMPLATE USED: "_$P(^DIBT(BDPSEAT,0),U,1),80),!
 W !?50,"CURRENT",!
 W "NAME",?24,"DOB",?40,"HRN",?50,"COMMUNITY",?66,"LAST VISIT",!,BDP80D,!
 Q
LVST ;ENTRY POINT from [BDP PRIM PROV LISTING print template
 S BDPAST=""
 S BDPVDFN=""
 S BDPAST=$O(^AUPNVSIT("AA",DFN,""))
 I BDPAST="" S BDPAST="NONE FOUND" Q
 S BDPVDFN=$O(^AUPNVSIT("AA",DFN,BDPAST,""))
 S Y=$P(^AUPNVSIT(BDPVDFN,0),U)
 D DD^%DT S BDPDT=$E(Y,1,12)
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
