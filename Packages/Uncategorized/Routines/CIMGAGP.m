CIMGAGP ; CMI/TUCSON/LAB - aberdeen area GPRA ;   [ 03/16/00  1:55 PM ]
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
 ;
 ;
 W:$D(IOF) @IOF
 W !!,$$CTR("Aberdeen Area GPRA Report",80)
INTRO ;
 D EXIT
 ;check for community taxonomy
 I $G(DUZ(2)) S CIMAREA=$P($G(^AUTTAREA(+$P($G(^AUTTLOC(DUZ(2),0)),U,4),0)),U)
 D SU^CIMGAGP0
 I $D(CIMQUIT) W !!,"Cannot find community taxonomy" H 4 Q
 I $O(CIMTAX(""))="" D GETTAX I $O(CIMTAX(""))="" D EXIT Q
 S CIMASUF=$P(^AUTTLOC(DUZ(2),0),U,10)
 S CIMSUC=$E(CIMASUF,1,4)
DATES ;
 K CIMBD,CIMED,CIMPER
 S CIMQTR=0
 D Y
 I $D(CIMQUIT) D EXIT Q
 S CIMQY=""
 S DIR(0)="S^Q:One Quarter in FY "_$$FMTE^XLFDT(CIMPER)_";F:Full Fiscal Year",DIR("A")="Run the report for a",DIR("B")="Q" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S CIMQY=Y
 I CIMQY="Q" D Q I $D(CIMQUIT) G DATES
HOME ;
 K DIC S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Please enter your HOME Location: " D ^DIC
 I Y=-1 W !,"No HOME Location entered!!!  PHN Visits counts to Home will be calculated",!,"using clinic 11 only!!" H 2 S CIMHOME="" G LISTS
 S CIMHOME=+Y
LISTS ;any lists with indicators?
 W !!
 S CIMLIST="" K CIMLIST
 S T="INDSL" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  W !,J,")",?5,X
 S DIR(0)="Y",DIR("A")="Should lists be generated for any of the above",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") G DATES
 I Y=0 G ZIS
 K CIMLIST
 S DIR(0)="L^1:16",DIR("A")="Which Ones" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LISTS
 F X=1:1 S Z=$P(Y,",",X) Q:Z=""  S CIMLIST(Z)=""
ZIS ;call to XBDBQUE
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 K DIC S X=CIMBD,DIC(0)="L",DIC="^CIMAGP(",DLAYGO=19255.01,DIADD=1,DIC("DR")=".02////"_CIMED_";.03////"_CIMPER_";.04///"_CIMQTR_";.05////"_CIMASUF_";.06////"_CIMSUC
 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S CIMQUIT=1 D EXIT Q
 S CIMRPT=+Y
 ;add communities to 28 multiple
 K ^CIMAGP(CIMRPT,28)
 S C=0,X="" F  S X=$O(CIMTAX(X)) Q:X=""  S C=C+1 S ^CIMAGP(CIMRPT,28,C,0)=X,^CIMAGP(CIMRPT,28,"B",X,C)=""
 S ^CIMAGP(CIMRPT,28,0)="^19255.28A^"_C_"^"_C
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 W !!,"A file will be created called G",$P(^AUTTLOC(DUZ(2),0),U,10)_"."_CIMRPT,".",!,"It will reside in the public/export directory.",!,"This file should be sent to your Area Office.",!!
 S XBRP="PRINT^CIMGAGPP",XBRC="PROC^CIMGAGP1",XBRX="EXIT1^CIMGAGP",XBNS="CIM"
 D ^XBDBQUE
 D EXIT
 Q
 ;
EXIT1 ;
 D ^%ZISC
 K IOPAR
 D EN^XBNEW("GS^CIMGAGP","CIMRPT")
EXIT ;
 D EN^XBVK("CIM")
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 D KILL^AUPNPAT
 D ^XBFMK
 D HOME^%ZIS
 Q
 ;
SET6 ;
 I $G(^CIMAGP(CIMRPT,X,X2,X3,X4,X5,X6))]"" S C=C+1,$P(^CIMGDATA(C),"|")=X,$P(^CIMGDATA(C),"|",2)=X2,$P(^CIMGDATA(C),"|",3)=X3
 S $P(^CIMGDATA(C),"|",4)=X4,$P(^CIMGDATA(C),"|",5)=X5,$P(^CIMGDATA(C),"|",6)=X6,$P(^CIMGDATA(C),"|",8)=^CIMAGP(CIMRPT,X,X2,X3,X4,X5,X6)
 Q
GS ;EP called from xbnew
 K ^CIMGDATA S X="",C=0 F  S X=$O(^CIMAGP(CIMRPT,X)) Q:X'=+X  D
 .I $G(^CIMAGP(CIMRPT,X))]"" S C=C+1,$P(^CIMGDATA(C),"|")=X,$P(^CIMGDATA(C),"|",8)=^CIMAGP(CIMRPT,X)
 .S X2="" F  S X2=$O(^CIMAGP(CIMRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^CIMAGP(CIMRPT,X,X2))]"" S C=C+1,$P(^CIMGDATA(C),"|")=X,$P(^CIMGDATA(C),"|",2)=X2,$P(^CIMGDATA(C),"|",8)=^CIMAGP(CIMRPT,X,X2)
 ..S X3="" F  S X3=$O(^CIMAGP(CIMRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^CIMAGP(CIMRPT,X,X2,X3))]"" S C=C+1,$P(^CIMGDATA(C),"|")=X,$P(^CIMGDATA(C),"|",2)=X2,$P(^CIMGDATA(C),"|",3)=X3,$P(^CIMGDATA(C),"|",8)=^CIMAGP(CIMRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^CIMAGP(CIMRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^CIMAGP(CIMRPT,X,X2,X3,X4))]"" S C=C+1,$P(^CIMGDATA(C),"|")=X,$P(^CIMGDATA(C),"|",2)=X2,$P(^CIMGDATA(C),"|",3)=X3,$P(^CIMGDATA(C),"|",4)=X4,$P(^CIMGDATA(C),"|",8)=^CIMAGP(CIMRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^CIMAGP(CIMRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^CIMAGP(CIMRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^CIMGDATA(C),"|")=X,$P(^CIMGDATA(C),"|",2)=X2,$P(^CIMGDATA(C),"|",3)=X3
 .....S $P(^CIMGDATA(C),"|",4)=X4,$P(^CIMGDATA(C),"|",5)=X5,$P(^CIMGDATA(C),"|",8)=^CIMAGP(CIMRPT,X,X2,X3,X4,X5)
 .....S X6="" F  S X6=$O(^CIMAGP(CIMRPT,X,X2,X3,X4,X5,X6)) Q:X6'=+X6  D SET6
 S XBGL="CIMGDATA"
 S F="G"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_CIMRPT
 S XBMED="F",XBFN=F,XBTLE="SAVE OF GPRA DATA BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBFLT=1
 D ^XBGSAVE
 K ^TMP($J),^CIMGDATA
 Q
GETTAX ;
 K CIMTAX
 S CIMTAX=""
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: " D ^DIC
 I Y=-1 Q
 S CIMX=+Y
 D SU1^CIMGAGP0
 Q
Q ;which quarter
 S DIR(0)="N^1:4:0",DIR("A")="Which Quarter" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!(Y="") S CIMQUIT="" Q
 S CIMQTR=Y
 I Y=1 S CIMBD=($E(CIMPER,1,3)-1)_"1001",CIMED=($E(CIMPER,1,3)-1)_"1231" Q
 I Y=2 S CIMBD=$E(CIMPER,1,3)_"0101",CIMED=$E(CIMPER,1,3)_"0331" Q
 I Y=3 S CIMBD=$E(CIMPER,1,3)_"0401",CIMED=$E(CIMPER,1,3)_"0630" Q
 I Y=4 S CIMBD=$E(CIMPER,1,3)_"0701",CIMED=$E(CIMPER,1,3)_"0930" Q
 Q
Y ;fiscal year
 W !
 S CIMVDT=""
 W !,"Enter the FY of interest.  Use a 4 digit year, e.g. 1999, 2000"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Fiscal year (e.g. 1999)"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR
 K DIC
 If $D(DUOUT) S DIRUT=1 S CIMQUIT="" Q
 S CIMVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G Y
 S CIMPER=CIMVDT,CIMBD=($E(CIMVDT,1,3)-1)_"1001",CIMED=$E(CIMVDT,1,3)_"0930"
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
 ;;1/1 Diabetes Prevalance - List of Patients with a Diabetes Diagnosis
 ;;1/1 Diabetes Incidence - List Patients Newly Diagnoses with Diabetes
 ;;2/2 Diabetes - List Diabetics and their Glycemic Control
 ;;3/3 Diabetes - List Diabetics/Hypertensives and their BP
 ;;4/4 Diabetes - List Diabetics and whether they had a an LDL
 ;;5/5 Diabetes - List Diabetics and whether they had a Urine Protein
 ;;6/6 Women's Health - List Women over 17 and whether they had a Pap
 ;;7/7 Women's Health - List women 49-64 and whether they had a Mammogram
 ;;8/8 Child Health - List Patients w/ 4 Well Child Visits by 27 months of age
 ;;11/12 Dental Health - List Patients with Access to Dental Services
 ;;12/13 Dental Health - List Patients who Received Dental Sealants
 ;;18/20 Child Health Immunization - List 2 y/o Pts w/ Immunization Status
 ;;20/23 Child Health - List Obese Children
 ;;21/2000 Adult Immunizations - List Patients >65 with Pneumovax Status
 ;;21/2000 Adult Immunizations - List Pts >65 with Flu Shot Status in Past yr
 ;;24/2000 Smoking Prevalance - List Current Tobacco Users
 ;;END
