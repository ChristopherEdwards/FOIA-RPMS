BDMD20 ; IHS/CMI/LAB - IHS Diabetes Audit 2000 ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
BEGIN ;EP - called from option
 D TAXCHK^BDMD209
 W:$D(IOF) @IOF
 W !!!,$$CTR("ASSESSMENT OF DIABETES CARE, 2000")
 W !!,$$CTR("PCC DIABETES AUDIT")
 W !!
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Official Diabetes Register: " D ^DIC
 I Y=-1 S BDMDMRG="" W !,"NO Register Selected!!!  The CMS register will not be used in retrieving",!,"any data."
 S BDMDMRG=$S(Y=-1:"",1:+Y)
 S BDMJOB=$J,BDMBTH=$H
GETDATES ;
 S BDMSTP=0 D TIME I BDMSTP D XIT1,XIT Q
TYPE ;
 S BDMSTP=0
 K ^XTMP("BDMDM20",BDMJOB,BDMBTH),^TMP($J,"PATS")
 S BDMTYPE=""
 S DIR(0)="S^P:Individual Patients;S:Search Template of Patients;C:Members of a CMS Register",DIR("A")="Run the audit for",DIR("B")="P" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) GETDATES
 S BDMTYPE=Y
 S BDMSTP=0 D @BDMTYPE
 I BDMSTP G TYPE
IF ;EP - called from BDM indivdual or epi
 S BDMSTP=0
 K DIR S DIR(0)="S^1:Print Individual Reports;2:Create EPI INFO file;3:Cumulative Audit Only;4:Both Individual and Cumulative Audits",DIR("A")="Enter Print option",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G TYPE
 S BDMPREP=Y
 I BDMPREP=2 D FLAT Q:BDMSTP
ZIS ;
DEMO ;
 D DEMOCHK^BDMUTL(.BDMDEMO)
 I BDMDEMO=-1 G IF
 I BDMPREP'=2 S XBRP="^BDMD20P",XBRC="^BDMD200",XBRX="XIT^BDMD20",XBNS="BDM"
 I BDMPREP=2 S XBRP="",XBRC="^BDMD200",XBRX="XIT^BDMD20",XBNS="BDM"
 D ^XBDBQUE
 D XIT
 Q
P ;
 S BDMSTP=0 K ^XTMP("BDMDM20",BDMJOB,BDMBTH),^TMP($J,"PATS")
P1 ;
 K DIC S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1,'$D(^XTMP("BDMDM20",BDMJOB,BDMBTH,"PATS")) W !,"No patients selected" S BDMSTP=1 Q
 I Y=-1 Q
 S ^XTMP("BDMDM20",BDMJOB,BDMBTH,"PATS",+Y)=""
 G P1
 Q
S ; Get patient name or cohort
 K ^XTMP("BDMDM20",BDMJOB,BDMBTH),^TMP($J,"PATS") S BDMSTP=0
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
 K ^XTMP("BDMDM20",BDMJOB,BDMBTH),^TMP($J,"PATS")
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
 I Y="A" S C=0 F  S C=$O(^TMP($J,"PATS",C)) Q:C'=+C  S X=$O(^TMP($J,"PATS",C,0)),^XTMP("BDMDM20",BDMJOB,BDMBTH,"PATS",X)=""
 I Y="A" K ^TMP($J,"PATS") Q
 S DIR(0)="N^2:"_BDMCNT_":0",DIR("A")="How many patients do you want in your random sample" KILL DA D ^DIR KILL DIR
 ;get random sample AND set xtmp
 I $D(DIRUT) S BDMSTP=1 Q
 S C=0 F N=1:1:BDMCNT Q:C=Y  S I=$R(BDMCNT) I I,$D(^TMP($J,"PATS",I)) S X=$O(^TMP($J,"PATS",I,0)),^XTMP("BDMDM20",BDMJOB,BDMBTH,"PATS",X)="",C=C+1 K ^TMP($J,"PATS",I,X)
 K ^TMP($J,"PATS")
 Q
TIME ;EP - called from BDM Get fiscal year or time frame
 S BDMSTP=0
 S (BDMRBD,BDMRED,BDMADAT)=""
 W !!,"Enter the date of the audit.  This date will be considered the ending",!,"date of the audit period.  For most data items all data for the period one",!,"year prior to this date will be reviewed.",!
 S DIR(0)="D^::EPX",DIR("A")="Enter the Audit Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BDMSTP=1 Q
 I Y>DT W !!,"Future dates not allowed.",! G TIME
 S BDMADAT=Y
 S BDMRED=$$FMTE^XLFDT(BDMADAT)
 S BDMBDAT=$$FMADD^XLFDT(BDMADAT,-365)
 S BDMRBD=$$FMTE^XLFDT(BDMBDAT)
 Q
 ;
XIT1 ;
 K ^BDMDATA($J),^BDMDATA("BDMEPI",$J)
 K ^XTMP("BDMDM20",BDMJOB,BDMBTH),BDMJOB,BDMBTH
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
 W !!,"I am going to create a file called ",BDMFILE," which will reside in ",!,"the ",$S($P(^AUTTSITE(1,0),U,21)=1:"/usr/spool/uucppublic",1:"C:\EXPORT")," directory.",!
 W "Actually, the file will be placed in the same directory that the data export"
 W !,"globals are placed.  See your site manager for assistance in finding the file",!,"after it is created.  PLEASE jot down and remember the following file name:",!?15,"**********    ",BDMFILE,"    **********",!
 W "It may be several hours (or overnight) before your report and flat file are ",!,"finished.",!
 W !,"The records that are generated and placed in file ",BDMFILE
 W !,"are in a format readable by EPI INFO.  For a definition of the format",!,"please see your user manual.",!
 S DIR(0)="Y",DIR("A")="Is everything ok?  Do you want to continue?",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT) S BDMSTP=1 Q
 I 'Y S BDMSTP=1 Q
 Q
WRITEF ;EP write flat file
 K ^BDMDATA($J)
 Q:'$D(^BDMDATA("BDMEPI",$J))
 ;load in epi definition to ^BDMDATA($J,"BDM EPI"
 S (X,N)=0 F  S X=$O(^BDMRECD(13,13,X)) Q:X'=+X  S N=N+1,^BDMDATA($J,N)=^BDMRECD(13,13,X,0)
 ;MOVE RECORDS TO ^BDMDATA($J,"BDM EPI"
 S X=0 F  S X=$O(^BDMDATA("BDMEPI",$J,X)) Q:X'=+X  S N=N+1,^BDMDATA($J,N)=^BDMDATA("BDMEPI",$J,X)
 S XBGL="BDMDATA("
 S XBMED="F",XBFN=BDMFILE,XBTLE="SAVE OF DM AUDIT EPI INFO RECORDS GENERATED BY -"_$P(^VA(200,DUZ,0),U)
 S XBQ="N",XBFLT=1,XBE=$J,XBF=$J
 D ^XBGSAVE
 ;check for error
 K ^BDMDATA("BDMEPI",$J)
 K XBGL,XBMED,XBTLE,XBFN,XBF,XBQ,XBFLT,XBE
 K ^BDMDATA($J)
 K ^XTMP("BDMDM20",BDMJOB,BDMBTH),BDMJOB,BDMBTH
 Q
