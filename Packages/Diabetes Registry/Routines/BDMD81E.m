BDMD81E ; IHS/CMI/LAB - IHS Diabetes Audit 2008 ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
BEGIN ;EP - called from option
 D TAXCHK^BDMD819
 W:$D(IOF) @IOF
REGASK ;
 W !,$$CTR("ASSESSMENT OF DIABETES CARE, 2008")
 W !,$$CTR("PCC DIABETES E-AUDIT")
 W !!,"This option is used to run the 2008 Electronic Diabetes Audit for a"
 W !,"predefined set of patients.  The patients selected are 'Active Diabetic"
 W !,"Patients' as defined by the Clinical Reporting system (GPRA).  In "
 W !,"addition you can optionally only include the patient if they are an"
 W !,"active member of the Diabetes register."
 W !,"The definition used to select patients is the following:"
 W !?3,"1. Must reside in a community specified in the official GPRA "
 W !?6,"community taxonomy."
 W !?3,"2. Must be alive on the audit date."
 W !?3,"3. Indian/Alaska Natives Only - based on Classification of 01."
 W !?3,"4. Must have 2 visits to medical clinics in the 3 years prior to the"
 W !?6,"audit date. At least one visit must include: 01 General,"
 W !?6,"06 Diabetic, 10 GYN, 12 Immunization, 13 Internal Med,"
 W !?6,"20 Pediatrics, 24 Well Child, 28 Family Practice, 57 EPSDT,"
 W !?6,"70 Women's Health, 80 Urgent, 89 Evening."
 W !?3,"5. The patient must have been diagnosed with diabetes at"
 W !?6,"least 1 year prior to the audit date."
 W !?3,"6. The patient must have had at least 2 visits during the"
 W !?6,"year prior to the Audit date, AND 2 DM-related visits ever."
 W !
 K DIR S DIR(0)="E",DIR("A")="Please press enter to continue" D ^DIR K DIR
 W !!
 S BDMDMRG=""
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Official Diabetes Register: " D ^DIC K DIC
 I Y=-1 S BDMDMRG="" W !,"NO Register Selected!!!  The CMS register will not be used in retrieving",!,"any data."
 S BDMDMRG=$S(Y=-1:"",1:+Y)
 S BDMJOB=$J,BDMBTH=$H
SDPI ;
 S BDMSDPI="",BDMSDPG=""
 S DIR(0)="S^1:Yes;2:No;3:Don't know",DIR("A")="Does your community receive SDPI grant funds" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT1,XIT Q
 S BDMSDPI=Y
 I BDMSDPI=1 D
 .S DIR(0)="FO^1:11",DIR("A")="Enter the SDPI Grant #" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) Q
 .S BDMSDPG=Y
 .Q
GETDATES ;
 S BDMSTP=0 D TIME I BDMSTP D XIT1,XIT Q
COMM ;get gpra community taxonomy
 W !!,"Specify the community taxonomy to determine which patients will be",!,"included in the report.  You should have created this taxonomy using QMAN.",!
 K BDMTAX
 S BDMTAXI=""
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: "
 S B=$P($G(^BGPSITE(DUZ(2),0)),U,5) I B S DIC("B")=$P(^ATXAX(B,0),U)
 D ^DIC K DIC
 I Y=-1 Q
 S BDMTAXI=+Y
COM1 S X=0
 F  S X=$O(^ATXAX(BDMTAXI,21,X)) Q:'X  D
 .S BDMTAX($P(^ATXAX(BDMTAXI,21,X,0),U))=""
 .Q
 I '$D(BDMTAX) W !!,"There are no communities in that taxonomy." G COMM
BEN ;
 S BDMBEN=1
ACT ;
 S BDMACTI=0 I BDMDMRG="" G IF
 S DIR(0)="Y",DIR("A")="Include only ACTIVE members of the "_$P(^ACM(41.1,BDMDMRG,0),U)_" register",DIR("B")="N" KILL DA
 D ^DIR KILL DIR
 I $D(DIRUT) G COMM
 S BDMACTI=Y
IF ;PEP - called from BDM indivdual or epi
 S BDMSTP=0
 K DIR S DIR(0)="S^1:Print Individual Reports;2:Create EPI INFO file;3:Cumulative Audit Only;4:Both Individual and Cumulative Audits",DIR("A")="Enter Print option",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G GETDATES
 S BDMPREP=Y
 I BDMPREP=2 D FLAT Q:BDMSTP
ZIS ;
 I BDMPREP'=2 S XBRP="^BDMD81P",XBRC="EAUDIT^BDMD810",XBRX="XIT^BDMD81",XBNS="BDM"
 I BDMPREP=2 S XBRP="",XBRC="EAUDIT^BDMD810",XBRX="XIT^BDMD81",XBNS="BDM"
 D ^XBDBQUE
 D XIT
 Q
P ;
 S BDMSTP=0 K ^XTMP("BDMDM81",BDMJOB,BDMBTH),^TMP($J,"PATS")
P1 ;
 K DIC S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1,'$D(^XTMP("BDMDM81",BDMJOB,BDMBTH,"PATS")) W !,"No patients selected" S BDMSTP=1 Q
 I Y=-1 Q
 S ^XTMP("BDMDM81",BDMJOB,BDMBTH,"PATS",+Y)=""
 G P1
 Q
S ; Get patient name or cohort
 K ^XTMP("BDMDM81",BDMJOB,BDMBTH),^TMP($J,"PATS") S BDMSTP=0
 K DIC S DIC("A")="Enter Search Template Name: ",DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)"
 S DIC="^DIBT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 S BDMSTP=1 W !,"No template selected." Q
 S BDMCNT=0 F BDMPD=0:0 S BDMPD=$O(^DIBT(+Y,1,BDMPD)) Q:'BDMPD  S BDMCNT=BDMCNT+1,^TMP($J,"PATS",BDMCNT,BDMPD)=""
 W !!,"There are ",BDMCNT," patients in the ",$P(^DIBT(+Y,0),U)," template/cohort.",!
 D PCP
 Q:BDMSTP
 D CC
 Q:BDMSTP
 D RAND
 Q
PCP ;
 S BDMSTP=0
 W !,"You have selected a register or template/cohort of patients. ",!,"You can run the audit just for the subset of patients in the cohort or register",!,"who live in a particular community or have a particular primary care provider.",!
 S DIR(0)="Y",DIR("A")="Limit the audit to a particular primary care provider ",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BDMSTP=1 Q
 Q:'Y
 K DIC S DIC=$S($P(^DD(9000001,.14,0),U,2)[200:200,1:6),DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G PCP
 S BDMPCP=+Y
 S X=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S P=$O(^TMP($J,"PATS",X,0)) I $P(^AUPNPAT(P,0),U,14)'=BDMPCP K ^TMP($J,"PATS",X,P)
 S (X,C)=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S C=C+1
 W !!,C," patients will be used in the audit.",!
 Q
CC ;current community
 S BDMSTP=0
 W ! K DIR S DIR(0)="Y",DIR("A")="Limit the patients who live in a particular community ",DIR("B")="N" KILL DA D ^DIR K DIR
 I $D(DIRUT) S BDMSTP=1 Q
 Q:'Y
 K DIC S DIC="^AUTTCOM(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G CC
 S BDMCOM=$P(^AUTTCOM(+Y,0),U)
 S X=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S P=$O(^TMP($J,"PATS",X,0)) I $P($G(^AUPNPAT(P,11)),U,18)'=BDMCOM K ^TMP($J,"PATS",X,P)
 S (X,C)=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S C=C+1
 W !!,C," patients will be used in the audit.",!
 Q
C ;get register, status, random or not
 K ^XTMP("BDMDM81",BDMJOB,BDMBTH),^TMP($J,"PATS")
 S BDMCMS="",BDMSTP=0
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 W !,"No register selected." S BDMSTP=1 Q
 S BDMCMS=+Y
 ;get status
 S BDMSTAT=""
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular status",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G C
 I Y=0 G C1
 ;which status
 S DIR(0)="9002241,1",DIR("A")="Which status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G C
 S BDMSTAT=Y
C1 ;
 ;gather up patients from register in ^XTMP
 K ^TMP($J,"PATS") S BDMCNT=0,X=0 F  S X=$O(^ACM(41,"B",BDMCMS,X)) Q:X'=+X  D
 .I BDMSTAT]"",$P($G(^ACM(41,X,"DT")),U,1)=BDMSTAT S BDMCNT=BDMCNT+1,^TMP($J,"PATS",BDMCNT,$P(^ACM(41,X,0),U,2))="" Q
 .I BDMSTAT="" S BDMCNT=BDMCNT+1,^TMP($J,"PATS",BDMCNT,$P(^ACM(41,X,0),U,2))=""
 I '$D(^TMP($J,"PATS")) W !,"No patients with that status in that register!" S BDMSTP=1 G C
 W !!,"There are ",BDMCNT," patients in the ",$P(^ACM(41.1,BDMCMS,0),U)," register with a status of ",BDMSTAT,".",!!
 D PCP
 Q:BDMSTP
 D CC
 Q:BDMSTP
 D RAND
 Q
RAND ;random sample or not
 S (X,BDMCNT)=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S BDMCNT=BDMCNT+1
 W !!,"There are ",BDMCNT," patients selected so far to be used in the audit.",!
 S DIR(0)="S^A:ALL Patients selected so far;R:RANDOM Sample of the patients selected so far",DIR("A")="Do you want to select",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) C
 I Y="A" S C=0 F  S C=$O(^TMP($J,"PATS",C)) Q:C'=+C  S X=$O(^TMP($J,"PATS",C,0)),^XTMP("BDMDM81",BDMJOB,BDMBTH,"PATS",X)=""
 I Y="A" K ^TMP($J,"PATS") Q
 S DIR(0)="N^2:"_BDMCNT_":0",DIR("A")="How many patients do you want in your random sample" KILL DA D ^DIR KILL DIR
 ;get random sample AND set xtmp
 I $D(DIRUT) S BDMSTP=1 Q
 S C=0 F N=1:1:BDMCNT Q:C=Y  S I=$R(BDMCNT) I I,$D(^TMP($J,"PATS",I)) S X=$O(^TMP($J,"PATS",I,0)),^XTMP("BDMDM81",BDMJOB,BDMBTH,"PATS",X)="",C=C+1 K ^TMP($J,"PATS",I,X)
 K ^TMP($J,"PATS")
 Q
TIME ;PEP - called from BDM Get fiscal year or time frame
 S BDMSTP=0
 S (BDMRBD,BDMRED,BDMADAT)=""
 W !!,"Enter the date of the audit.  This date will be considered the ending",!,"date of the audit period.  For most data items all data for the period one",!,"year prior to this date will be reviewed.",!
 S DIR(0)="D^::EPX",DIR("A")="Enter the Audit Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BDMSTP=1 Q
 S BDMADAT=Y
 S BDMRED=$$FMTE^XLFDT(BDMADAT)
 S BDMBDAT=$$FMADD^XLFDT(BDMADAT,-365)
 S BDMRBD=$$FMTE^XLFDT(BDMBDAT)
 Q
 ;
XIT1 ;
 K ^BDMDATA($J),^BDMDATA("BDMEPI",$J)
 K ^XTMP("BDMDM81",BDMJOB,BDMBTH),BDMJOB,BDMBTH
XIT ;
 I '$D(BDMGUI) D EN^XBVK("BDM"),EN^XBVK("AUPN")
 D ^XBFMK,KILL^AUPNPAT
 K ^TMP($J,"PATS")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
FLAT ;
 S BDMFILE=""
 S DIR(0)="F^3:8",DIR("A")="Enter the name of the FILE to be Created (3-8 characters)" K DA D ^DIR K DIR
 I $D(DIRUT) S BDMSTP=1 Q
 I X'?1.8AN W !!,"Invalid format, must be letters and numbers",! G FLAT
 S BDMFILE=$$LOW^XLFSTR(Y)_".rec"
 W !!,"I am going to create a file called ",BDMFILE," which will reside in ",!,"the ",$S($P(^AUTTSITE(1,0),U,21)=1:"/usr/spool/uucppublic",$P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")," directory on your RPMS server. ",!
 W "It is the same directory that the data export globals are placed."
 W !,"See your site manager for assistance in finding the file",!,"after it is created.  PLEASE jot down and remember the following file name:",!?15,"**********    ",BDMFILE,"    **********",!
 W "It may be several hours (or overnight) before your report and flat file are ",!,"finished.",!
 W !,"The records that are generated and placed in file ",BDMFILE
 W !,"are in a format readable by EPI INFO.  For a definition of the format",!,"please see your user manual.",!
 S DIR(0)="Y",DIR("A")="Is everything ok?  Do you want to continue",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT) S BDMSTP=1 Q
 I 'Y S BDMSTP=1 Q
 Q
WRITEF ;EP write flat file
 K ^BDMDATA($J)
 Q:'$D(^BDMDATA("BDMEPI",$J))
 ;load in epi definition to ^BDMDATA($J,"BDM EPI"
 S I=$O(^BDMRECD("B","DM AUDIT 2008 EPI REC 1",0))
 S (X,N)=0 F  S X=$O(^BDMRECD(I,13,X)) Q:X'=+X  S N=N+1,^BDMDATA($J,N)=^BDMRECD(I,13,X,0)
 ;MOVE RECORDS TO ^BDMDATA($J,"BDM EPI"
 S X=0 F  S X=$O(^BDMDATA("BDMEPI",$J,X)) Q:X'=+X  S N=N+1,^BDMDATA($J,N)=^BDMDATA("BDMEPI",$J,X)
 K ^BDMDATA("BDMEPI",$J)
 S XBGL="BDMDATA("
 K XBUF I $P($G(^APCCCTRL(DUZ(2),0)),U,11)]"" S XBUF=$P(^APCCCTRL(DUZ(2),0),U,11)
 S XBMED="F",XBFN=BDMFILE,XBTLE="SAVE OF DM AUDIT 2008 EPI INFO RECORDS GENERATED BY -"_$P(^VA(200,DUZ,0),U)
 S XBQ="N",XBFLT=1,XBE=$J,XBF=$J
 D ^XBGSAVE
 ;check for error
 K ^BDMDATA("BDMEPI",$J)
 K XBGL,XBMED,XBTLE,XBFN,XBF,XBQ,XBFLT,XBE
 K ^BDMDATA($J)
 K ^XTMP("BDMDM81",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
BDMG(BDMJOB,BDMBTH,BDMDMRG,BDMADAT,BDMTYPE,BDMSTMP,BDMPCP,BDMCOM,BDMRAND,BDMRCNT,BDMCMS,BDMSTAT,BDMPREP,BDMFILE,BDMDSP,BDMGIEN,BDMSDPI,BDMSDPG) ;PEP - gui call
 F X="BDMJOB","BDMBTH","BDMDMRG","BDMADAT","BDMTYPE","BDMSTMP","BDMPCP","BDMCOM","BDMRAND","BDMRCNT","BDMCMS","BDMSTAT","BDMPREP","BDMFILE","BDMDSP" S @X=$G(@X)
 I $G(BDMJOB)="" S BDMIEN=-1 Q
 I $G(BDMBTH)="" S BDMIEN=-1 Q
 I $G(BDMADAT)="" S BDMIEN=-1 Q
 ;I $G(BDMTYPE)="" S BDMIEN=-1 Q
 I $G(BDMPREP)="" S BDMIEN=-1 Q
 ;using variable BDMRAND as taxonomy
 S BDMGUI=1
 S BDMTAXI=BDMRAND
 S BDMACTI=0
 S BDMBEN=1
 I BDMSTAT="A" D
 . S BDMACTI=1
 S X=0
 F  S X=$O(^ATXAX(BDMTAXI,21,X)) Q:'X  D
 .S BDMTAX($P(^ATXAX(BDMTAXI,21,X,0),U))=""
 .Q
 I BDMPREP=2,BDMFILE="" S BDMIEN=-1 Q
 S BDMRED=$$FMTE^XLFDT(BDMADAT)
 S BDMBDAT=$$FMADD^XLFDT(BDMADAT,-365)
 S BDMRBD=$$FMTE^XLFDT(BDMBDAT)
 I $G(BDMDSP) D GUIEP Q
 ;create entry in fileman file to hold output
 N BDMOPT  ;maw
 S BDMOPT="Run the 2008 Audit w/predefined set of Pts"  ;maw
 D NOW^%DTC
 S BDMNOW=$G(%)
 K DD,D0,DIC
 S X=BDMJOB_"."_BDMBTH
 S DIC("DR")=".02////"_DUZ_";.03////"_BDMNOW_";.05////"_$G(BDMPREP)_";.06///"_$G(BDMOPT)_";.07////R"
 S DIC="^BDMGUI(",DIC(0)="L",DIADD=1,DLAYGO=9003201.4
 D FILE^DICN
 K DIADD,DLAYGO,DIC,DA
 I Y=-1 S BDMIEN=-1 Q
 S BDMIEN=+Y
 S BDMGIEN=BDMIEN  ;cmi/maw added
 D ^XBFMK
 K ZTSAVE S ZTSAVE("*")=""
 ;D GUIEP for interactive testing
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BDMD81E",ZTDESC="GUI DM AUDIT" D ^%ZTLOAD
 D XIT
 Q
GUIEP ;EP - called from taskman
 D EAUDIT^BDMD810
 I BDMPREP=2,'$G(BDMDSP) D ENDLOG Q
 K ^TMP($J,"BDMDM81")
 S IOM=80  ;cmi/maw added
 D GUIR^XBLM("^BDMD81P","^TMP($J,""BDMDM81"",")
 Q:$G(BDMDSP)  ;quit if to screen
 S X=0,C=0 F  S X=$O(^TMP($J,"BDMDM81",X)) Q:X'=+X  D
 .S BDMDATA=^TMP($J,"BDMDM81",X)
 .I BDMDATA="ZZZZZZZ" S BDMDATA=$C(12)
 .S ^BDMGUI(BDMIEN,11,X,0)=BDMDATA,C=C+1
 S ^BDMGUI(BDMIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BDMIEN,DIK="^BDMGUI(" D IX1^DIK
 D ENDLOG
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
 ;
TEST ;
 S BDMJOB=7,BDMBTH="59812,48383"
 F X=1:1:10 S ^XTMP("BDMDM81",BDMJOB,BDMBTH,"PATS",X)=""
 D BDMG^BDMD81(BDMJOB,BDMBTH,1,DT,"P","","","","","","","",4,"TESTEPI",.BDMIEN)
 Q
