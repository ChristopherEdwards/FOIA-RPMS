APCLP61 ; IHS/CMI/LAB - IHS PRE Diabetes Audit 2006 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
BEGIN ;EP - called from option
 D TAXCHK^APCLP619  ;LORI RECHECK THIS
 W:$D(IOF) @IOF
 W !!!,$$CTR("ASSESSMENT OF PREDIABETES/METABOLIC SYNDROME CARE, 2006")
 W !!,$$CTR("PCC PREDIABETES/METABOLIC SYNDROME AUDIT")
 W !!
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Official Pre-Diabetes Register: " D ^DIC
 I Y=-1 S APCLDMRG="" W !,"NO Register Selected!!!  The CMS register will not be used in retrieving",!,"any data."
 S APCLDMRG=$S(Y=-1:"",1:+Y)
 S APCLJOB=$J,APCLBTH=$H
GETDATES ;
 S APCLSTP=0 D TIME I APCLSTP D XIT1,XIT Q
TYPE ;
 S APCLSTP=0
 K ^XTMP("APCLP61",APCLJOB,APCLBTH),^TMP($J,"PATS")
 S APCLTYPE=""
 S DIR(0)="S^P:Individual Patients;S:Search Template of Patients;C:Members of a CMS Register",DIR("A")="Run the audit for",DIR("B")="P" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) GETDATES
 S APCLTYPE=Y
 S APCLSTP=0 D @APCLTYPE
 I APCLSTP G TYPE
IF ;PEP - called from BDM indivdual or epi
 S APCLSTP=0
 K DIR S DIR(0)="S^1:Print Individual Reports;2:Cumulative Audit Only;3:Both Individual and Cumulative Audits",DIR("A")="Enter Print option",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G TYPE
 S APCLPREP=Y
 ;I APCLPREP=2 D FLAT Q:APCLSTP
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G IF
 S XBRP="^APCLP61P",XBRC="^APCLP610",XBRX="XIT^APCLP61",XBNS="APCL"
 ;I APCLPREP=2 S XBRP="",XBRC="^APCLP610",XBRX="XIT^APCLP61",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
P ;
 S APCLSTP=0 K ^XTMP("APCLP61",APCLJOB,APCLBTH),^TMP($J,"PATS")
P1 ;
 K DIC S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1,'$D(^XTMP("APCLP61",APCLJOB,APCLBTH,"PATS")) W !,"No patients selected" S APCLSTP=1 Q
 I Y=-1 Q
 S ^XTMP("APCLP61",APCLJOB,APCLBTH,"PATS",+Y)=""
 G P1
 Q
S ; Get patient name or cohort
 K ^XTMP("APCLP61",APCLJOB,APCLBTH),^TMP($J,"PATS") S APCLSTP=0
 K DIC S DIC("A")="Enter Search Template Name: ",DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)"
 S DIC="^DIBT(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 S APCLSTP=1 W !,"No template selected." Q
 S APCLCNT=0 F APCLPD=0:0 S APCLPD=$O(^DIBT(+Y,1,APCLPD)) Q:'APCLPD  S APCLCNT=APCLCNT+1,^TMP($J,"PATS",APCLCNT,APCLPD)=""
 W !!,"There are ",APCLCNT," patients in the ",$P(^DIBT(+Y,0),U)," template/cohort.",!
 D PCP
 Q:APCLSTP
 D CC
 Q:APCLSTP
 D RAND
 Q
PCP ;
 S APCLSTP=0
 W !,"You have selected a register or template/cohort of patients. ",!,"You can run the audit just for the subset of patients in the cohort or register",!,"who live in a particular community or have a particular primary care provider.",!
 S DIR(0)="Y",DIR("A")="Limit the audit to a particular primary care provider ",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCLSTP=1 Q
 Q:'Y
 K DIC S DIC=$S($P(^DD(9000001,.14,0),U,2)[200:200,1:6),DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G PCP
 S APCLPCP=+Y
 S X=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S P=$O(^TMP($J,"PATS",X,0)) I $P(^AUPNPAT(P,0),U,14)'=APCLPCP K ^TMP($J,"PATS",X,P)
 S (X,C)=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S C=C+1
 W !!,C," patients will be used in the audit.",!
 Q
CC ;current community
 S APCLSTP=0
 W ! K DIR S DIR(0)="Y",DIR("A")="Limit the patients who live in a particular community ",DIR("B")="N" KILL DA D ^DIR K DIR
 I $D(DIRUT) S APCLSTP=1 Q
 Q:'Y
 K DIC S DIC="^AUTTCOM(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G CC
 S APCLCOM=$P(^AUTTCOM(+Y,0),U)
 S X=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S P=$O(^TMP($J,"PATS",X,0)) I $P($G(^AUPNPAT(P,11)),U,18)'=APCLCOM K ^TMP($J,"PATS",X,P)
 S (X,C)=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S C=C+1
 W !!,C," patients will be used in the audit.",!
 Q
C ;get register, status, random or not
 K ^XTMP("APCLP61",APCLJOB,APCLBTH),^TMP($J,"PATS")
 S APCLCMS="",APCLSTP=0
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register: " D ^DIC
 I Y=-1 W !,"No register selected." S APCLSTP=1 Q
 S APCLCMS=+Y
 ;get status
 S APCLSTAT=""
 S DIR(0)="Y",DIR("A")="Do you want to select register patients with a particular status",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G C
 I Y=0 G C1
 ;which status
 S DIR(0)="9002241,1",DIR("A")="Which status",DIR("B")="A" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G C
 S APCLSTAT=Y
C1 ;
 ;gather up patients from register in ^XTMP
 K ^TMP($J,"PATS") S APCLCNT=0,X=0 F  S X=$O(^ACM(41,"B",APCLCMS,X)) Q:X'=+X  D
 .I APCLSTAT]"",$P($G(^ACM(41,X,"DT")),U,1)=APCLSTAT S APCLCNT=APCLCNT+1,^TMP($J,"PATS",APCLCNT,$P(^ACM(41,X,0),U,2))="" Q
 .I APCLSTAT="" S APCLCNT=APCLCNT+1,^TMP($J,"PATS",APCLCNT,$P(^ACM(41,X,0),U,2))=""
 I '$D(^TMP($J,"PATS")) W !,"No patients with that status in that register!" S APCLSTP=1 G C
 W !!,"There are ",APCLCNT," patients in the ",$P(^ACM(41.1,APCLCMS,0),U)," register with a status of ",APCLSTAT,".",!!
 D PCP
 Q:APCLSTP
 D CC
 Q:APCLSTP
 D RAND
 Q
RAND ;random sample or not
 S (X,APCLCNT)=0 F  S X=$O(^TMP($J,"PATS",X)) Q:X'=+X  S APCLCNT=APCLCNT+1
 W !!,"There are ",APCLCNT," patients selected so far to be used in the audit.",!
 S DIR(0)="S^A:ALL Patients selected so far;R:RANDOM Sample of the patients selected so far",DIR("A")="Do you want to select",DIR("B")="A" KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) C
 I Y="A" S C=0 F  S C=$O(^TMP($J,"PATS",C)) Q:C'=+C  S X=$O(^TMP($J,"PATS",C,0)),^XTMP("APCLP61",APCLJOB,APCLBTH,"PATS",X)=""
 I Y="A" K ^TMP($J,"PATS") Q
 S DIR(0)="N^2:"_APCLCNT_":0",DIR("A")="How many patients do you want in your random sample" KILL DA D ^DIR KILL DIR
 ;get random sample AND set xtmp
 I $D(DIRUT) S APCLSTP=1 Q
 S C=0 F N=1:1:APCLCNT Q:C=Y  S I=$R(APCLCNT) I I,$D(^TMP($J,"PATS",I)) S X=$O(^TMP($J,"PATS",I,0)),^XTMP("APCLP61",APCLJOB,APCLBTH,"PATS",X)="",C=C+1 K ^TMP($J,"PATS",I,X)
 K ^TMP($J,"PATS")
 Q
TIME ;PEP - called from BDM Get fiscal year or time frame
 S APCLSTP=0
 S (APCLRBD,APCLRED,APCLADAT)=""
 W !!,"Enter the date of the audit.  This date will be considered the ending",!,"date of the audit period.  For most data items all data for the period one",!,"year prior to this date will be reviewed.",!
 S DIR(0)="D^::EPX",DIR("A")="Enter the Audit Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCLSTP=1 Q
 S APCLADAT=Y
 S APCLRED=$$FMTE^XLFDT(APCLADAT)
 S APCLBDAT=$$FMADD^XLFDT(APCLADAT,-365)
 S APCLRBD=$$FMTE^XLFDT(APCLBDAT)
 Q
 ;
XIT1 ;
 K ^APCLDATA($J),^APCLDATA("APCLEPI",$J)
 K ^XTMP("APCLP61",APCLJOB,APCLBTH),APCLJOB,APCLBTH
XIT ;
 D EN^XBVK("APCL"),EN^XBVK("AUPN")
 D ^XBFMK,KILL^AUPNPAT
 K ^TMP($J,"PATS")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
FLAT ;
 S APCLFILE=""
 S DIR(0)="F^3:8",DIR("A")="Enter the name of the FILE to be Created (3-8 characters)" K DA D ^DIR K DIR
 I $D(DIRUT) S APCLSTP=1 Q
 I X'?1.8AN W !!,"Invalid format, must be letters and numbers",! G FLAT
 S APCLFILE=$$LOW^XLFSTR(Y)_".rec"
 W !!,"I am going to create a file called ",APCLFILE," which will reside in ",!,"the ",$S($P(^AUTTSITE(1,0),U,21)=1:"/usr/spool/uucppublic",$P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")," directory on your RPMS server. ",!
 W "It is the same directory that the data export globals are placed."
 W !,"See your site manager for assistance in finding the file",!,"after it is created.  PLEASE jot down and remember the following file name:",!?15,"**********    ",APCLFILE,"    **********",!
 W "It may be several hours (or overnight) before your report and flat file are ",!,"finished.",!
 W !,"The records that are generated and placed in file ",APCLFILE
 W !,"are in a format readable by EPI INFO.  For a definition of the format",!,"please see your user manual.",!
 S DIR(0)="Y",DIR("A")="Is everything ok?  Do you want to continue",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT) S APCLSTP=1 Q
 I 'Y S APCLSTP=1 Q
 Q
WRITEF ;EP write flat file
 K ^APCLDATA($J)
 Q:'$D(^APCLDATA("APCLEPI",$J))
 ;load in epi definition to ^APCLDATA($J,"APCL EPI"
 S I=$O(^APCLRECD("B","DM AUDIT 2003 EPI REC 1",0))
 S (X,N)=0 F  S X=$O(^APCLRECD(I,13,X)) Q:X'=+X  S N=N+1,^APCLDATA($J,N)=^APCLRECD(I,13,X,0)
 ;MOVE RECORDS TO ^APCLDATA($J,"APCL EPI"
 S X=0 F  S X=$O(^APCLDATA("APCLEPI",$J,X)) Q:X'=+X  S N=N+1,^APCLDATA($J,N)=^APCLDATA("APCLEPI",$J,X)
 K ^APCLDATA("APCLEPI",$J)
 S XBGL="APCLDATA("
 K XBUF I $P($G(^APCCCTRL(DUZ(2),0)),U,11)]"" S XBUF=$P(^APCCCTRL(DUZ(2),0),U,11)
 S XBMED="F",XBFN=APCLFILE,XBTLE="SAVE OF DM AUDIT 2003 EPI INFO RECORDS GENERATED BY -"_$P(^VA(200,DUZ,0),U)
 S XBQ="N",XBFLT=1,XBE=$J,XBF=$J
 D ^XBGSAVE
 ;check for error
 K ^APCLDATA("APCLEPI",$J)
 K XBGL,XBMED,XBTLE,XBFN,XBF,XBQ,XBFLT,XBE
 K ^APCLDATA($J)
 K ^XTMP("APCLP61",APCLJOB,APCLBTH),APCLJOB,APCLBTH
 Q
BDMG(APCLJOB,APCLBTH,APCLDMRG,APCLADAT,APCLTYPE,APCLSTMP,APCLPCP,APCLCOM,APCLRAND,APCLRCNT,APCLCMS,APCLSTAT,APCLPREP,APCLFILE,APCLDSP,BDMGIEN,APCLSDPI,APCLSDPG) ;PEP - gui call
 F X="APCLJOB","APCLBTH","APCLDMRG","APCLADAT","APCLTYPE","APCLSTMP","APCLPCP","APCLCOM","APCLRAND","APCLRCNT","APCLCMS","APCLSTAT","APCLPREP","APCLFILE","APCLDSP" S @X=$G(@X)
 I $G(APCLJOB)="" S APCLIEN=-1 Q
 I $G(APCLBTH)="" S APCLIEN=-1 Q
 I $G(APCLADAT)="" S APCLIEN=-1 Q
 I $G(APCLTYPE)="" S APCLIEN=-1 Q
 I $G(APCLPREP)="" S APCLIEN=-1 Q
 ;I APCLPREP=2,APCLFILE="" S APCLIEN=-1 Q
 S APCLRED=$$FMTE^XLFDT(APCLADAT)
 S APCLBDAT=$$FMADD^XLFDT(APCLADAT,-365)
 S APCLRBD=$$FMTE^XLFDT(APCLBDAT)
 S APCLGUI=1
 I $G(APCLDSP) D GUIEP Q
 ;create entry in fileman file to hold output
 D NOW^%DTC
 S APCLNOW=$G(%)
 N APCLOPT  ;maw
 S APCLOPT="DM 2006 Pre-Diabetes Audit"  ;maw
 K DD,D0,DIC
 S X=APCLJOB_"."_APCLBTH
 S DIC("DR")=".02////"_DUZ_";.03////"_APCLNOW_";.05////"_$G(APCLPREP)_";.06///"_$G(APCLOPT)_";.07////R"
 S DIC="^APCLGUIR(",DIC(0)="L",DIADD=1,DLAYGO=9001004.4
 D FILE^DICN
 K DIADD,DLAYGO,DIC,DA
 I Y=-1 S APCLIEN=-1 Q
 S APCLIEN=+Y
 S BDMGIEN=APCLIEN  ;cmi/maw added
 D ^XBFMK
 K ZTSAVE S ZTSAVE("*")=""
 ;D GUIEP  ;for interactive testing
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^APCLP61",ZTDESC="GUI DM AUDIT" D ^%ZTLOAD
 D XIT
 Q
GUIEP ;EP - called from taskman
 D ^APCLP610
 ;I APCLPREP=2,'$G(APCLDSP) D ENDLOG Q
 K ^TMP($J,"APCLP61")
 S IOM=80  ;cmi/maw added
 D GUIR^XBLM("^APCLP61P","^TMP($J,""APCLP61"",")
 Q:$G(APCLDSP)  ;quit if to screen
 S X=0,C=0 F  S X=$O(^TMP($J,"APCLP61",X)) Q:X'=+X  D
 .S APCLDATA=^TMP($J,"APCLP61",X)
 .I APCLDATA="ZZZZZZZ" S APCLDATA=$C(12)
 .S ^APCLGUIR(APCLIEN,11,X,0)=APCLDATA,C=C+1
 S ^APCLGUIR(APCLIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=APCLIEN,DIK="^APCLGUIR(" D IX1^DIK
 D ENDLOG
 S ZTREQ="@"
 Q
 ;
ENDLOG ;-- write the end of the log
 D NOW^%DTC
 S APCLNOW=$G(%)
 S DIE="^APCLGUIR(",DA=APCLIEN,DR=".04////"_APCLNOW_";.07////C"
 D ^DIE
 K DIE,DR,DA
 Q
 ;
TEST ;
 S APCLJOB=7,APCLBTH="59812,48383"
 F X=1:1:10 S ^XTMP("APCLP61",APCLJOB,APCLBTH,"PATS",X)=""
 D BDMG^APCLP61(APCLJOB,APCLBTH,1,DT,"P","","","","","","","",4,"TESTEPI",.APCLIEN)
 Q
