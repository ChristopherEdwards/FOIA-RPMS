APCLACG ; IHS/CMI/LAB - IHS GPRA 09 SELECTED REPORT DRIVER 21 May 2008 12:10 PM ; 
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 W:$D(IOF) @IOF
 W !!,$$CTR("Anticoagulation INR Management Report",80)
INTRO ;
 D XIT
 W !,"This will produce a report on anticoagulation therapy for a population you",!,"select."
 W !,"Group definitions:"
 W !,"W - Warfarin Patients = All patients with a prescription for Warfarin during"
 W !,"    the report period.  For the monthly report the time period will be in the"
 W !,"    45 days prior to the report period."
 W !,"A - Anticoagulation Clinic Patients = All patients with a documented visit to"
 W !,"    the anticoagulation clinic  (clinic code D1) in the specifed report date "
 W !,"    range.  For the monthly report the time period will be 45 days."
 W !,"S - Search Template = All patients in a search template you select."
 W !,"I - iCare panel = All patients in an iCare panel you select."
 W !,"E - EHR Personal List = All patients on an EHR Personal list that you select."
 W !
GRP ;
 S DIR(0)="S^W:Warfarin Patients;A:Anticoagulation Clinic Patients;S:Search Template of Patients;I:iCare Panel;E:EHR Personal List",DIR("A")="Which group of patients do you wish to report on" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S APCLGRP=Y
 K APCLPTS
 D @APCLGRP
 I $G(APCLQUIT) W !!,"No GROUP selected." H 2 G INTRO
 I APCLGRP="A" G TP
ACCL ;
 K APCLACCL
 W !!,"The following clinics have beeen identified as Anticoagulation clinics:"
 W !?5,"D1 - Anticoagulation clinic"
 S DIR(0)="Y",DIR("A")="Do you wish to add another clinic(s)",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!('Y) S X=$O(^DIC(40.7,"C","D1",0)) I X S APCLACCL(X)="" G TP
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" Q
 D PEP^AMQQGTX0(+Y,"APCLACCL(")
 I '$D(APCLACCL) G A
 I $D(APCLACCL("*")) W !!,"That is not a valid response, please select certain clinics" K APCLACCL G A
 S X=$O(^DIC(40.7,"C","D1",0)) I X S APCLACCL(X)=""
TP ;
 W !!,"This is a monthly report.  Enter the month and year."
 S APCLRTYP="",(APCLBD,APCLED)=""
 ;S DIR(0)="S^MOS:Monthly Report;QUA:Quarterly Report;YEAR:Calendar Year Report",DIR("A")="Report Date Option",DIR("B")="MOS" KILL DA D ^DIR KILL DIR
 ;I $D(DIRUT) G GRP
 S APCLRTYP="MOS"
 S (APCLBD,APCLED)=""
 D @APCLRTYP
 I APCLBD="" G ACCL
LISTS ;any lists with measures?
 I APCLRTYP'="MOS" G COMM  ;lists are only on the monthly report
 K APCLLIST
 W !!,"PATIENT LISTS"
 W !,"The following patient lists are available to be printed with this report."
 W !,"Please select which reports you would like to include with the report."
 W !,"1 - All patients in the population selected."
 W !,"2 - Only patients in INR Goal Range and monitored this month"
 W !,"3 - Only patients in INR Goal Range but NOT monitored this month"
 W !,"4 - Only patients NOT in INR Goal Range but are monitored this month"
 W !,"5 - Only patients NOT in INR Goal Range and are NOT monitored this month"
 K APCLLIST
 S DIR(0)="LO^1:5",DIR("A")="Which population would you like to view/print" KILL DA D ^DIR KILL DIR
 S APCLANS=Y,APCLC="" F APCLI=1:1 S APCLC=$P(APCLANS,",",APCLI) Q:APCLC=""  S APCLLIST(APCLC)=""
 I '$D(APCLLIST) W !!,"No lists selected.  Will print statistics only.",!
COMM ;get community taxonomy for user population
 W !!,"Specify the community taxonomy to determine which patients will be",!
 W "included in the user population/active clinical population.  You should "
 W !,"have created this taxonomy using QMAN.",!
 K APCLTAX
 S APCLTAXI=""
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: "
 S B=$P($G(^BGPSITE(DUZ(2),0)),U,5) I B S DIC("B")=$P(^ATXAX(B,0),U)
 D ^DIC
 I Y=-1 Q
 S APCLTAXI=+Y
 ;
SUM ;display summary of this report
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF ANTICOAGULATION REPORT TO BE GENERATED")
 W !
 W !?5,"Report Period: ",?31,$$FMTE^XLFDT(APCLBD)," to ",?31,$$FMTE^XLFDT(APCLED)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(APCLTAXI,0),U)
 I $D(APCLLIST) W !!,"Patient Lists will be produced.",!
ZIS ;call to XBDBQUE
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D XIT Q
 S APCLOPT=Y
 I Y="B" D BROWSE,XIT Q
 S XBRP="PRINT^APCLACG",XBRC="PROC^APCLACG",XBRX="XIT^APCLACG",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCLACG"")"
 S XBRC="PROC^APCLACG",XBRX="XIT^APCLACG",XBIOP=0 D ^XBDBQUE
 Q
 ;
XIT ;
 ;D ^%ZISC
 D EN^XBVK("APCL") I $D(ZTQUEUED) S ZTREQ="@"
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
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
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
QUA ;
 S (APCLBD,APCLED,APCLQTR)=""
 S DIR(0)="S^1:October 1 - September 30;2:january 1 - December 31;3:April 1 - March 31;4:July 1 - June 30",DIR("A")="Enter the quarter for your report" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S APCLQTR=Y
 I APCLQTR'=5 D F
 I APCLPER="" W !,"Year not entered.",! G TP
 I APCLQTR=2 S APCLBD=$E(APCLPER,1,3)_"0101",APCLED=$E(APCLPER,1,3)_"1231"
 I APCLQTR=3 S APCLBD=($E(APCLPER,1,3)-1)_"0401",APCLED=$E(APCLPER,1,3)_"0331"
 I APCLQTR=4 S APCLBD=($E(APCLPER,1,3)-1)_"0701",APCLED=$E(APCLPER,1,3)_"0630"
 I APCLQTR=1 S APCLBD=($E(APCLPER,1,3)-1)_"1001",APCLED=$E(APCLPER,1,3)_"0930"
 I APCLED>DT D  G:APCLDO=1 QUA
 .W !!,"You have selected Current Report period ",$$FMTE^XLFDT(APCLBD)," through ",$$FMTE^XLFDT(APCLED),"."
 .W !,"The end date of this report is in the future; your data will not be",!,"complete.",!
 .K DIR S APCLDO=0 S DIR(0)="Y",DIR("A")="Do you want to change your Current Report Dates",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCLDO=1 Q
 .I Y S APCLDO=1 Q
 Q
YEAR ;calendar year
 S (APCLPER,APCLVDT)=""
 W !!,"Enter the Calendar Year for the report END date.  Use a 4 digit",!,"year, e.g. 2009"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S APCLVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G YEAR
 S APCLPER=APCLVDT
 S APCLBD=$E(APCLVDT,1,3)_"0101"
 S APCLBD=$E(APCLVDT,1,3)_"1231"
 W !!,"You chose ",$$FMTE^XLFDT(APCLBD)," through ",$$FMTE^XLFDT(APCLED),"."
 S DIR(0)="Y",DIR("A")="Is this correct",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G YEAR
 I 'Y G YEAR
 Q
S ;get search template
 S APCLQUIT=0
 S DIC("S")="I $P(^(0),U,4)=2!($P(^(0),U,4)=9000001)" S DIC="^DIBT(",DIC("A")="Enter SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 S APCLQUIT=1 Q
 S APCLPTS="S"
 S APCLSTMP=+Y
 S X=0,C=0 F  S X=$O(^DIBT(APCLSTMP,1,X)) Q:X'=+X  S C=C+1,APCLPTS(X)=""
 W !!,"There are ",C," patients in that search template that will be reported on."
 Q
E ;EHR PERSONAL LIST
 S APCLQUIT=0
 S APCLPTS="E"
 S APCLDATA=""
 K ^TMP("BQITABLE",$J)
 D TAB^BQIUTB(.APCLDATA,"PERS")
 I $P($G(^TMP("BQITABLE",$J,1)),U,2)="" W !!,"You do not have any EHR Personal Lists defined." S APCLQUIT=1 Q
 S APCLICP=""  ;will set to OWNER^IEN^NAME OF LIST
 D EN^APCLACGI
 I APCLICP="" W !!,"no list selected." S APCLQUIT=1 Q
 W !!,"You have selected EHR Personal List: ",$P(APCLICP,U,3)
 Q
I ;ICARE GROUP
 ; GET THIS USERS LISTS AND PRESENT THEM
 S APCLPTS="I",APCLQUIT=0
 K ^TMP("BQIPLRT",$J)
 ;get list of this users panels in iCare
 S APCLDATA=""
 D LISTS^BQIPLRT(.APCLDATA)
 I $P($G(^TMP("BQIPLRT",$J,1)),U,2)="" W !!,"You do not have any iCare panels defined." S APCLQUIT=1 Q
 S APCLICP=""  ;will set to owner^ien
 D EN^APCLACGI
 I APCLICP="" W !!,"no panel selected." S APCLQUIT=1 Q
 W !!,"You have selected iCare panel: ",$P(APCLICP,U,3)
 Q
A ;ANTICOAGULATION
 S APCLPTS="A",APCLQUIT=0
 K APCLACCL
 W !!,"The following clinics have beeen identified as Anticoagulation clinics:"
 W !?5,"D1 - Anticoagulation clinic"
 S DIR(0)="Y",DIR("A")="Do you wish to add another clinic(s)",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT)!('Y) S X=$O(^DIC(40.7,"C","D1",0)) I X S APCLACCL(X)="" Q
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" Q
 D PEP^AMQQGTX0(+Y,"APCLACCL(")
 I '$D(APCLACCL) G A
 I $D(APCLACCL("*")) W !!,"That is not a valid response, please select certain clinics" K APCLACCL G A
 S X=$O(^DIC(40.7,"C","D1",0)) I X S APCLACCL(X)=""
 Q
W ;WARFARIN
 S APCLPTS="W",APCLQUIT=0
 Q
 ;
PROC ;
 D PROC^APCLACG1
 Q
PRINT ;
 I APCLRTYP="MOS" D ^APCLACGM
 Q
MOS ;
 S APCLVDT=""
 S DIR(0)="FO^6:7",DIR("A")="Enter Month (e.g. 1/1999)",DIR("?")="Enter a month and 4 digit year in the following format:  1/1999, 01/2000.  The slash is required between the month and year.  Date must be in the past." KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 Q:X=""
 I Y'?1.2N1"/"4N W !,"Enter the month/4 digit year in the format 1/1999.  Slash is required and ",!,"4 digit year is required.",! G MOS
 K %DT S X=Y,%DT="EP" D ^%DT
 I Y=-1 W !!,"Enter a month and 4 digit year.  Date must be in the past.  E.g.  04/1999 or 01/2000." G MOS
 I Y>DT W !!,"No future dates allowed!",! G MOS
 S APCLVDT=Y
 S APCLBD=$E(APCLVDT,1,3)_$E(APCLVDT,4,5)_"01"
 S M=$E(APCLVDT,4,5)
 S D=""
 I M="09"!(M="04")!(M="06")!(M="11") S D=30
 I D="",M'="02" S D=31
 I M="02" S X=$E(APCLVDT,1,3)_"0229",%DT="P" D ^%DT D
 .I Y=-1 S D=28 Q
 .S D=29
 S APCLED=$E(APCLVDT,1,3)_M_D
 W !!,"You chose ",$$FMTE^XLFDT(APCLBD)," through ",$$FMTE^XLFDT(APCLED),"."
 S DIR(0)="Y",DIR("A")="Is this correct",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G MOS
 I 'Y G MOS
 Q
Y ;
F ;calendar year
 S (APCLPER,APCLVDT)=""
 W !!,"Enter the Calendar Year for the report END date.  Use a 4 digit",!,"year, e.g. 2009"
 S DIR(0)="D^::EP"
 S DIR("A")="Enter Year"
 S DIR("?")="This report is compiled for a period.  Enter a valid date."
 D ^DIR KILL DIR
 I $D(DIRUT) Q
 I $D(DUOUT) S DIRUT=1 Q
 S APCLVDT=Y
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G F
 S APCLPER=APCLVDT
 Q
