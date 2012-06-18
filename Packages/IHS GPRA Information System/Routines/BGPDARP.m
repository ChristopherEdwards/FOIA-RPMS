BGPDARP ; IHS/CMI/LAB - IHS area GPRA ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 W:$D(IOF) @IOF
 W !!,$$CTR("IHS GPRA Indicator Report - for Export to Area",80)
INTRO ;
 D EXIT
 W !!,"This report will produce a GPRA Indicator Report for an AREA DIRECTOR's",!,"reporting year, defined as, JULY 1 to JUNE 30.  You will be asked to enter the",!,"year.  Reporting year 2002 would be July 1, 2001 though June 30, 2002."
 W !,"You will also be asked to enter the BASELINE year that should have been provided",!,"to you by Area office personnel.",!
 W !,"In addition you will be asked to enter the community taxonomy to be used.",!!
 W "This option will produce a report in export format for the Area Office to use",!,"in Area aggregated data.  Depending on site-specific configuration, the",!
 W "export file will either be automatically transmitted directly to the Area or ",!,"the site will have to send the file manually.",!
 W !,"You will be provided the opportunity to have lists of patients printed for",!,"the indicators.  Please be careful when answering this question as the",!,"lists can be very long and use lots of paper.",!
 D TAXCHK^BGPDT
DATES ;
 S BGPFTA=1
 K BGPBD,BGPED,BGPPER
 S BGPQTR=0
 D Y
 I $D(BGPQUIT) D EXIT Q
BY ;get baseline year
 W !
 S BGPVDT=""
 W !,"Enter the Baseline Year that you would like to compare the data to.",!,"Use a 4 digit year, e.g. 1999, 2000"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year (e.g. 1999)"
 D ^DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 G DATES
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G BY
 S BGPBBD=($E(BGPVDT,1,3)-1)_"0701",BGPBED=$E(BGPVDT,1,3)_"0630" G N
N S BGPPBD=($E(BGPBD,1,3)-1)_$E(BGPBD,4,7)
 S BGPPED=($E(BGPED,1,3)-1)_$E(BGPED,4,7)
 W !!,"The date ranges for this report are:"
 W !?5,"Reporting Period: ",?31,$$FMTE^XLFDT(BGPBD)," to ",?31,$$FMTE^XLFDT(BGPED)
 W !?5,"Previous Year Period: ",?31,$$FMTE^XLFDT(BGPPBD)," to ",?31,$$FMTE^XLFDT(BGPPED)
 W !?5,"Baseline Period: ",?31,$$FMTE^XLFDT(BGPBBD)," to ",?31,$$FMTE^XLFDT(BGPBED)
COMM ;
 W !!,"Specify the community taxonomy to use to determine which",!,"patients will be included in the GPRA report.  You should have created",!,"this taxonomy using QMAN or some other software.",!
 K BGPTAX
 S BGPX=""
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: " D ^DIC
 I Y=-1 G INTRO
 S BGPX=+Y
COM1 S X=0
 F  S X=$O(^ATXAX(BGPX,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPX,21,X,0),U))=""
 .Q
 I '$D(BGPTAX) W !!,"There are no communities in that taxonomy." G COMM
HOME ;
 K DIC S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Please enter the Location for HOME Visits: " D ^DIC
 I Y=-1 W !,"No HOME Location entered!!!  PHN Visits counts to Home will be calculated",!,"using clinic 11 only!!" H 2 S BGPHOME="" G LISTS
 S BGPHOME=+Y
LISTS ;any lists with indicators?
 F X=1:1:35 S BGPIND(X)=""  ;all indicators
 K BGPIND(23)  ;no indicator 23 this version
 W !!
 K BGPLIST
 S DIR(0)="Y",DIR("A")="Do you want individual patient lists for the indicators",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") G HOME
 I Y=0 G ZIS
 K BGPLIST
 D EN^BGPDL
 I '$D(BGPLIST) W !!,"No lists selected.",!
ZIS ;call to XBDBQUE
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPD(",DLAYGO=90240.01,DIADD=1
 S DIC("DR")=".02////"_BGPED_";.03////"_BGPPER_";.04///"_BGPQTR_";.05////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.06////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.08////"_BGPBBD_";.09////"_BGPBED
 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BGPQUIT=1 D EXIT Q
 S BGPRPT=+Y
 ;add communities to 28 multiple
 K ^BGPD(BGPRPT,28)
 S C=0,X="" F  S X=$O(BGPTAX(X)) Q:X=""  S C=C+1 S ^BGPD(BGPRPT,28,C,0)=X,^BGPD(BGPRPT,28,"B",X,C)=""
 S ^BGPD(BGPRPT,28,0)="^19257.28A^"_C_"^"_C
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 W !!,"A file will be created called BG",$P(^AUTTLOC(DUZ(2),0),U,10)_"."_BGPRPT," and will reside",!,"in the export/public directory.",!
 W !,"Depending on your site configuration, this file may need to be manually",!,"sent to your Area Office.",!
 ;
 W !! S %ZIS="PQM" D ^%ZIS
 I POP W !,"Report Aborted" S DA=BGPRPT,DIK="^BGPD(" D ^DIK K DIK D EXIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D ^BGPD1
 U IO
 D ^BGPDP
 D ^%ZISC
 D GS
 D EXIT
 Q
 ;
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGPDFTA",ZTDTH="",ZTDESC="GPRA REPORT" D ^%ZTLOAD D EXIT Q
EXIT1 ;
 D HOME^%ZIS
 K IOPAR
 D GS
EXIT ;
 D EN^XBVK("BGP")
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 D KILL^AUPNPAT
 D ^XBFMK
 D HOME^%ZIS
 Q
 ;
SET6 ;
 I $G(^BGPD(BGPRPT,X,X2,X3,X4,X5,X6))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",6)=X6,$P(^BGPDATA(C),"|",8)=^BGPD(BGPRPT,X,X2,X3,X4,X5,X6)
 Q
GS ;EP called from xbnew
 L +^BGPDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 ;NOTE:  Kill of unscripted global.  Export to area.  Using standar name.
 K ^BGPDATA S X="",C=0 F  S X=$O(^BGPD(BGPRPT,X)) Q:X'=+X  D
 .I $G(^BGPD(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPD(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPD(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPD(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPD(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPD(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPD(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPD(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPD(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPD(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPD(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPD(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPD(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPD(BGPRPT,X,X2,X3,X4,X5)
 .....S X6="" F  S X6=$O(^BGPD(BGPRPT,X,X2,X3,X4,X5,X6)) Q:X6'=+X6  D SET6
 S XBGL="BGPDATA"
 S F="BG"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_BGPRPT
 S XBMED="F",XBFN=F,XBTLE="SAVE OF GPRA DATA BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBFLT=1
 D ^XBGSAVE
 L -^BGPDATA
 K ^TMP($J),^BGPDATA ;NOTE:  kill of unsubscripted global for use in export to area.
 Q
Y ;fiscal year
 W !
 S BGPVDT=""
 W !,"Enter the appropriate AREA REPORTING YEAR.  Use a 4 digit year, e.g. 2002"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter AREA REPORTING Year year (e.g. 1999)"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR
 K DIC
 I $D(DUOUT) S DIRUT=1 S BGPQUIT="" Q
 S BGPVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G Y
 S BGPPER=BGPVDT,BGPBD=($E(BGPVDT,1,3)-1)_"0701",BGPED=$E(BGPVDT,1,3)_"0630"
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
 ;
INDSL ;;
 ;;1C  Diabetes Prevalence - List of Patients with a Diabetes Diagnosis
 ;;1C  Diabetes Incidence - List Patients Newly Diagnoses with Diabetes
 ;;2C  Diabetes - List Diabetics and their Glycemic Control
 ;;3C  Diabetes - List Diabetics/Hypertensives and their BP
 ;;4   Diabetes - List Diabetics and whether they had a an LDL
 ;;4   Diabetes - List Diabetics with LDL>130 or TG>200
 ;;5   Diabetes - List Diabetics and whether they had a Urine Protein
 ;;5   Diabetes - List Diabetics with Microalbuminuria >30
 ;;6C  Women's Health - List Women over 17 and whether they had a Pap
 ;;7C  Women's Health - List women 40 and over and whether they had a Mammogram
 ;;7CC Women's Health - List women over 17 and whether they had a Brast Exam
 ;;8   Child Health - List Patients w/ 4 Well Child Visits by 27 months of age
 ;;10  Fetal Alcohol Syndrome - List Women w/ Prenatal Risk Screening
 ;;12  Dental Health - List Patients with Access to Dental Services
 ;;13  Dental Health - List Patients who Received Dental Sealants
 ;;23  Child Health Immunization - List 2 mon/o Pts w/ Immunization Status
 ;;24  List all Patient Injuries
 ;;29C Child Health - List Obese Children
 ;;24  Adult Immunizations - List Patients >65 with Pneumovax Status
 ;;24  Adult Immunizations - List Pts >65 with Flu Shot Status in Past yr
 ;;30C Smoking Prevalence - List Current Tobacco Users
 ;;C1  Mental Health - List Diabetic Patients w/depressive disorder
 ;;C2  Prostate Cancer - List males 40 yr/age and over and DRE status
 ;;C3  Colorectal Cancer - List patients over 44 and annual screening status
 ;;END
