BDMRML ; IHS/CMI/LAB - patients w/o dm on problem list ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**7,8**;JUN 14, 2007;Build 53
 ;
 ;
START ;
 D INFORM
GETINFO ;
 K BDMSTAT
R ;
 S BDMREG=""
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 W !,"No register selected." S BDMQUIT="" D EXIT Q
 S BDMREG=+Y
RS ;get status
 K BDMSTAT
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular status",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G R
 I Y=0 K BDMSTAT G AGE
R1 ;which status
 S DIR(0)="9002241,1O",DIR("A")="Select "_$S($D(BDMSTAT):"another ",1:"")_"status" S:'$D(BDMSTAT) DIR("B")="A" KILL DA D ^DIR KILL DIR
 I Y="",'$D(BDMSTAT) G RS
 I $D(DIRUT),'$D(BDMSTAT) G RS
 I $D(DIRUT) G AGE
 I Y="" G AGE
 S BDMSTAT(Y)=""
 G R1
AGE ;Age Screening
 K BDMAGE,BDMAGET
 W ! S DIR(0)="YO",DIR("A")="Would you like to restrict the master list by Patient age range",DIR("B")="NO"
 S DIR("?")="If you wish to include patients from ALL age ranges, anwser No.  If you wish to list only patients within a particular age range, enter Yes."
 D ^DIR K DIR
 G:$D(DIRUT) RS
 I 'Y G CMMNTS
 ;
AGER ;Age Screening
 W !
 S DIR(0)="FO^1:7",DIR("A")="Enter an Age Range (e.g. 5-12,1-1)" D ^DIR
 I Y="" W !!,"No age range entered." G AGE
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn. e.g. 0-5, 0-99, 5-20." G AGER
 S BDMAGET=Y
CMMNTS ;
 K BDMCOMM S BDMCOMT=""
 S DIR(0)="S^O:One particular Community;A:All Communities;S:Selected Set of Communities (Taxonomy)",DIR("A")="Include Patients",DIR("B")="A" K DA D ^DIR K DIR
 I $D(DIRUT) G AGE
 S BDMCOMT=Y
 I BDMCOMT="A" G SEX
 I BDMCOMT="O" D  G:'$D(BDMCOMM) CMMNTS  G SEX
 .S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Which COMMUNITY: " D ^DIC K DIC
 .Q:Y=-1
 .S BDMCOMM($P(^AUTTCOM(+Y,0),U))=""
 S X="COMMUNITY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S BDMERR=1 Q
 D PEP^AMQQGTX0(+Y,"BDMCOMM(")
 I '$D(BDMCOMM) G CMMNTS
 I $D(BDMCOMM("*")) W !,"* ISN'T ALLOWED, CHOOSE ALL" K BDMCOMM G CMMNTS
SEX ;
 S BDMSEX=""
 S DIR(0)="S^M:MALES;F:FEMALES;U:UNKNOWN;A:ALL Genders",DIR("A")="Include which Gender(s)",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G CMMNTS
 S BDMSEX=Y
CM ;
 K BDMCM
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular CASE MANAGER",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G SEX
 I Y=0 K BDMCM G WF
CM1 ;which status
 K DIC S DIC(0)="AEMQ",DIC=200,DIC("A")="Select "_$S($D(BDMCM):"another ",1:"")_"Case Manager: " D ^DIC K DIC
 I Y=-1,'$D(BDMCM) G CM
 I $D(DIRUT),'$D(BDMCM) G CM
 I $D(DIRUT) G WF
 I Y=-1 G WF
 S BDMCM(+Y)=""
 G CM1
WF ;
 K BDMWF
 S DIR(0)="Y",DIR("A")="Do you want to select patients with a particular facility WHERE FOLLOWED",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G CM
 I Y=0 K BDMWF G SORT
WF1 ;which status
 ;ihs/cmi/maw 03/12/2014 2.0 patch 8 added DIC(0) call
 K DIC S DIC=9999999.06,DIC(0)="AEMQZ",DIC("A")="Select "_$S($D(BDMWF):"another ",1:"")_"WHERE FOLLOWED facility: " D ^DIC K DIC
 I Y=-1,'$D(BDMWF) G WF
 I $D(DIRUT),'$D(BDMWF) G WF
 I $D(DIRUT) G SORT
 I Y=-1 G SORT
 S BDMWF(+Y)=""
 G WF1
SORT ;
 S BDMSORT1="",BDMSORT2=""
 W !!,"This list can be sorted by a primary and optionally a secondary sort value.",!
 S DIR(0)="S^P:Patient Name;S:Register Status;A:Age;C:Community;G:Gender;M:Case Manager;W:Where Followed",DIR("A")="Select Primary Sort Value" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G WF
 S BDMSORT1=Y,BDMSOR1T=Y(0)
SSORT ;
 W !,"You can optionally sort by a second sort value.  If you do not pick a",!,"secondary sort value it will default to patient name.",!
 S BDMSORT2=""
 K DIR
 S DIR(0)="SO^"_$S(BDMSORT1'="P":"P:Patient Name",1:"")
 S DIR(0)=DIR(0)_$S(BDMSORT1'="S":";S:Register Status",1:"")
 S DIR(0)=DIR(0)_$S(BDMSORT1'="A":";A:Age",1:"")
 S DIR(0)=DIR(0)_$S(BDMSORT1'="C":";C:Community",1:"")
 S DIR(0)=DIR(0)_$S(BDMSORT1'="G":";G:Gender",1:"")
 S DIR(0)=DIR(0)_$S(BDMSORT1'="M":";M:Case Manager",1:"")
 S DIR(0)=DIR(0)_$S(BDMSORT1'="W":";W:Where Followed",1:"")
 S DIR("A")="Select Secondary Sort Value" KILL DA D ^DIR KILL DIR
 I X="" S BDMSORT2="P",BDMSOR2T="Patient Name" G TEMP
 I $D(DIRUT) G SORT
 S BDMSORT2=Y,BDMSOR2T=Y(0)
 ;I BDMSORT2="" S BDMSORT2="P",BDMSOR2T="Patient Name"
TEMP ;
 S BDMTEMP=""
 S DIR(0)="S^P:Print the List;B:Browse the List on the Screen;S:Save as a Search Template",DIR("A")="Output Type",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G SORT
 S BDMTEMP=Y
 I BDMTEMP="P" G ZIS
 I BDMTEMP="B" G ZIS
 D EN2
 I BDMSTMP="" G TEMP
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^BDMUTL(.BDMDEMO)
 I BDMDEMO=-1 G R
 I BDMTEMP="B" D BROWSE,EXIT Q
 S XBRP="PRINT^BDMRML",XBRC="PROC^BDMRML",XBRX="EXIT^BDMRML",XBNS="BDM"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BDMRML"")"
 S XBRC="PROC^BDMRML",XBRX="EXIT^BDMRML",XBIOP=0 D ^XBDBQUE
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,$$CTR("DIABETES REGISTER MASTER LIST",80)
 W !!,"This report will list all patients on the Diabetes Register.",!
 W "You will be able to select which patients will be included on the list",!
 W "based on any of the following:",!
 W ?5,"- Register Status",!
 W ?5,"- Age",!
 W ?5,"- Community of Residence",!
 W ?5,"- Gender",!
 W ?5,"- Case Manager",!
 W ?5,"- Where Followed",!
 W !
 Q
EXIT ;clean up and exit
 I '$D(BDMGUI) D EN^XBVK("BDM")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
PROC ;EP - called from XBDBQUE
 S BDMJOB=$J,BDMBTH=$H,BDMTOT=0
 K BDMSORT
 K ^XTMP("BDMRML",BDMJOB,BDMBTH)
 D XTMP^BDMOSUT("BDMRML","DM MASTER LIST")
 S BDMX=0 F  S BDMX=$O(^ACM(41,"B",BDMREG,BDMX)) Q:BDMX'=+BDMX  D
 .S DFN=$P(^ACM(41,BDMX,0),U,2)
 .Q:$$DEMO^BDMUTL(DFN,$G(BDMDEMO))
 .Q:$$DOD^AUPNPAT(DFN)]""
 .I $D(BDMSTAT) S X=$P($G(^ACM(41,BDMX,"DT")),U,1) Q:X=""  Q:'$D(BDMSTAT(X))
 .I $D(BDMAGET) Q:$$AGE^AUPNPAT(DFN)>$P(BDMAGET,"-",2)
 .I $D(BDMAGET) Q:$$AGE^AUPNPAT(DFN)<$P(BDMAGET,"-",1)
 .I $D(BDMCOMM) S X=$P($G(^AUPNPAT(DFN,11)),U,18) Q:X=""  I X]"",'$D(BDMCOMM(X)) Q
 .I BDMSEX'="A" S X=$$GET1^DIQ(2,DFN,.02,"I") I BDMSEX'=X Q
 .I $D(BDMCM) S X=$$VALI^XBDIQ1(9002241,BDMX,6) Q:'X  I X Q:'$D(BDMCM(X))
 .I $D(BDMWF) S X=$$VALI^XBDIQ1(9002241,BDMX,10) Q:'X  I X Q:'$D(BDMWF(X))
 .D @BDMSORT1
 .S BDMS1=X
 .D @BDMSORT2
 .S BDMS2=X
 .S ^XTMP("BDMRML",BDMJOB,BDMBTH,"PATIENTS",BDMS1,BDMS2,BDMX)=DFN
 .I BDMSORT1'="P" S BDMSORT(BDMS1)=$G(BDMSORT(BDMS1))+1  ;SUBOTOTAL
 .S BDMTOT=BDMTOT+1
 Q
PRINT ;EP - called from xbdbque
 S BDMIOSL=$S($G(BDMGUI):55,1:IOSL)
 S BDM80D="-------------------------------------------------------------------------------"
 S BDMPG=0 D HEAD
 I '$D(^XTMP("BDMRML",BDMJOB,BDMBTH)) W !!,"NO PATIENTS TO REPORT" G DONE
 S BDMS1="",BDMS2="" K BDMQ
 F  S BDMS1=$O(^XTMP("BDMRML",BDMJOB,BDMBTH,"PATIENTS",BDMS1)) Q:BDMS1=""!($D(BDMQ))  D
 .I $Y>(IOSL-3) D HEAD Q:$D(BDMQ)
 .I BDMTEMP'="S",BDMSORT1'="P" W !!?5,BDMSOR1T,": ",BDMS1,"   (Subtotal: ",BDMSORT(BDMS1),")"
 .S BDMS2="" F  S BDMS2=$O(^XTMP("BDMRML",BDMJOB,BDMBTH,"PATIENTS",BDMS1,BDMS2)) Q:BDMS2=""!($D(BDMQ))  D
 ..S BDMX="" F  S BDMX=$O(^XTMP("BDMRML",BDMJOB,BDMBTH,"PATIENTS",BDMS1,BDMS2,BDMX)) Q:BDMX=""!($D(BDMQ))  D
 ...S DFN=^XTMP("BDMRML",BDMJOB,BDMBTH,"PATIENTS",BDMS1,BDMS2,BDMX)
 ...I BDMTEMP="S" S ^DIBT(BDMSTMP,1,DFN)="" Q
 ...I $Y>(BDMIOSL-4) D HEAD Q:$D(BDMQ)
 ...W !,$$HRN^AUPNPAT(DFN,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2))),?8,$E($P(^DPT(DFN,0),U,1),1,25),?35,$E($$GET1^DIQ(9002241,BDMX,6),1,22)
 ...W ?57,$$LASTVD(DFN),?67,$$DATE^BDMS9B1($$GET1^DIQ(9002241,BDMX,8,"I"))
DONE ;
 I BDMTEMP="S" D HDR
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  HIT RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K ^XTMP("BDMRML",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
LASTVD(P) ;
 NEW X,Y,Z,V,D
 S V=""
 S D=0 F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D'=+D!(V)  D
 .S X=0 F  S X=$O(^AUPNVSIT("AA",P,D,X)) Q:X'=+X!(V)  D
 ..Q:'$D(^AUPNVSIT(X,0))
 ..Q:$P(^AUPNVSIT(X,0),U,11)  ;deleted
 ..Q:'$P(^AUPNVSIT(X,0),U,9)  ;ZERO DEP
 ..Q:"CTNEDX"[$P(^AUPNVSIT(X,0),U,7)
 ..S V=X
 I V="" Q ""
 Q $$DATE^BDMS9B1($$VD^APCLV(V))
HEAD I 'BDMPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 I $G(BDMGUI),BDMPG'=1 W !,"ZZZZZZZ"
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",BDMPG,!
 W ?(80-$L($P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U))/2),$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U),!
 W $$CTR("DIABETES REGISTER MASTER LIST",80),!
 W $$CTR("Total number of patient selected for this report: "_BDMTOT),!
PIH W !,"HRN",?8,"PATIENT",?35,"CASE MANAGER",?57,"LAST VISIT",?68,"NEXT REVIEW",!,BDM80D,!
 Q
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
P ;
 S X=$P(^DPT(DFN,0),U,1)
 Q
S ;
 S X=$$GET1^DIQ(9002241,BDMX,1)
 I X="" S X="<NONE>"
 Q
A ;
 S X=$$AGE^AUPNPAT(DFN,DT)
 Q
C ;
 S X=$P($G(^AUPNPAT(DFN,11)),U,18)
 I X="" S X="<NONE>"
 Q
G ;
 S X=$$GET1^DIQ(2,DFN,.02)
 I X="" S X="UNKNOWN"
 Q
M ;
 S X=$$GET1^DIQ(9002241,BDMX,6)
 I X="" S X="<NONE>"
 Q
W ;
 S X=$$GET1^DIQ(9002241,BDMX,10)
 I X="" S X="<NONE>"
 Q
TEST ;
 D BDMG("R",1,"A")
 Q
BDMG(BDMIEN,BDMREG,BDMAGET,BDMSTAT,BDMCOMT,BDMCOMM,BDMSEX,BDMCM,BDMWF,BDMSORT1,BDMSORT2,BDMTEMP,BDMDEMO,BDMSTMP) ;EP - GUI DMS Entry Point
 S BDMND=$G(BDMND)
 S BDMGUI=1
 S BDMLDAT=$G(BDMLDAT)
 I BDMAGET="" K BDMAGET
 I BDMSTMP]"" S BDMSNAM=$P(^DIBT(BDMSTMP,0),U)
 S BDMSOR1T=$S(BDMSORT1="P":"Patient Name","S":"Register Status","A":"Age","C":"Community","G":"Gender","M":"Case Manager","W":"Where Followed",1:"")
 S BDMSOR2T=$S(BDMSORT2="P":"Patient Name","S":"Register Status","A":"Age","C":"Community","G":"Gender","M":"Case Manager","W":"Where Followed",1:"Patient Name")
 I BDMSORT2="" S BDMSORT2="P"
 NEW BDMNOW,BDMOPT,BDMIEN
 S BDMOPT="Master List"
 D NOW^%DTC
 S BDMNOW=$G(%)
 K DD,DO,DIC
 S X=DUZ_BDMNOW
 S DIC("DR")=".02////"_DUZ_";.03////"_BDMNOW_";.06///"_$G(BDMOPT)_";.07////R"
 S DIC="^BDMGUI(",DIC(0)="L",DIADD=1,DLAYGO=9003201.4
 D FILE^DICN
 K DIADD,DLAYGO,DIC,DA
 I Y=-1 S BDMIEN=-1 Q
 S BDMIEN=+Y
 S BDMGIEN=BDMIEN  ;cmi/maw added
 D ^XBFMK
 K ZTSAVE S ZTSAVE("*")=""
 ;D GUIEP ;for interactive testing
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BDMRML",ZTDESC="GUI MASTER LIST" D ^%ZTLOAD
 D EXIT
 Q
GUIEP ;EP
 D PROC
 K ^TMP($J,"BDMRML")
 S IOM=80
 D GUIR^XBLM("PRINT^BDMRML","^TMP($J,""BDMRML"",")
  S X=0,C=0 F  S X=$O(^TMP($J,"BDMRML",X)) Q:X'=+X  D
 .S BDMDATA=^TMP($J,"BDMRML",X)
 .I BDMDATA="ZZZZZZZ" S BDMDATA=$C(12)
 .S ^BDMGUI(BDMIEN,11,X,0)=BDMDATA,C=C+1
 S ^BDMGUI(BDMIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BDMIEN,DIK="^BDMGUI(" D IX1^DIK
 D ENDLOG
 K ^TMP($J,"BDMRML")
 D EXIT
 S ZTREQ="@"
 Q
 ;
ENDLOG ;-- write the end of the log
 D NOW^%DTC
 S BDMNOW=$G(%)
 S DIE="^BDMGUI(",DA=BDMIEN,DR=".04////"_BDMNOW_";.07////C"
 D ^DIE
 K DIE,DR,DA
 Q
EN2 S BDMSTMP="",BDMSNAM=""
 S DIC="^DIBT(",DIC(0)="AELMQZ",DIC("A")="Search Template: ",DIC("S")="I $P(^(0),U,4)=9000001&($P(^(0),U,5)=DUZ)"
 W !
 D ^DIC
 I +Y<1 W !!,"No Search Template selected." H 2 Q
 S BDMDIC=DIC  ;ihs/cmi/maw 03/11/2014 patch 8
 S BDMSTMP=+Y,BDMSNAM=$P(^DIBT(BDMSTMP,0),U)
DUP I '$P(Y,U,3) D  I Q K BDMSTMP,Y G EN2
 .S Q=""
 .W !!,$C(7),$C(7)
 .S DIR(0)="Y",DIR("A")="That template already exists!!  Do you want to overwrite it",DIR("B")="N" K DA D ^DIR K DIR
 .I $D(DIRUT) S Q=1 Q
 .I 'Y S Q=1 Q
 .L +^DIBT(BDMSTMP):10
 .S BDMSTN=$P(^DIBT(BDMSTMP,0),U) S DA=BDMSTMP,DIK="^DIBT(" D ^DIK
 .S ^DIBT(BDMSTMP,0)=BDMSNAM,DA=BDMSTMP,DIK="^DIBT(" D IX1^DIK
 .L -^DIBT(BDMSTMP)
 .Q
 I BDMSTMP,$D(^DIBT(BDMSTMP)) D
 .W !!,?5,"An unduplicated patient list resulting from this report",!,?5,"will be stored in the.........>",!!?18,"**  ",BDMSNAM,"  ** Search Template."
 .K ^DIBT(BDMSTMP,1)
 .S DHIT="S ^DIBT("_BDMSTMP_",1,$P("_BDMDIC_"D0,0),U,2))="""""
 .S DIE="^DIBT(",DA=BDMSTMP,DR="2////"_DT_";3////M;4////9000001;5////"_DUZ_";6////M"
 .D ^DIE
 .K DIE,DA,DR
 Q
 ;Run Template in Background Mode
 ;
BACK ;
 S DHD="W ?0 D HDR^BDMSTMP",FLDS="!.01"
 W !!,"A brief report will be printed after the search template is complete.",!,"You must enter a device for this report OR you may queue at this time.",!
 Q
HDR ;
 W !!,?15,"***SEARCH TEMPLATE CREATION***"
 W !!,?1,"Template Created: ",$P(^DIBT(BDMSTMP,0),U)
 W !,?1,"Created by:  ",$P(^VA(200,DUZ,0),U)
 W !,"------------------------------------------------------------------------------",!
 Q
