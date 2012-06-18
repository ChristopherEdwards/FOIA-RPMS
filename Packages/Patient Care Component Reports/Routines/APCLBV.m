APCLBV ; IHS/CMI/LAB - print billable visits ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
START ;
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! Q
 W:$D(IOF) @IOF
 W !!,"This Option prints a list of Potentially Billable Visits for all patients",!,"registered at the Facility that you select.",!
 W "The user will select which third party coverage type that they are interested",!,"in seeing billable visits for."
 W !,"This report displays visits during a period when this patient had third",!,"party coverage, but does not consider the diagnostic category which may be",!,"excluded by some types of coverage.",!
 W "Only visits at the location where the patient is registered will be displayed.",!
F ;
 S DIC("A")="Run the report for which Facility: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 EOJ
 S APCLSU=+Y
SD ;
 W !
 S Y=DT X ^DD("DD") S APCLDTP=Y
 S %DT("A")="Starting Visit Date for Billable Visits: ",%DT="AEPX" W ! D ^%DT
 I Y=-1 G F
 S APCLSD=Y X ^DD("DD") S APCLSDY=Y
ED S %DT("A")="Ending Visit Date for Billable Visits: " W ! D ^%DT K %DT
 I Y=-1 G SD
 S APCLED=Y X ^DD("DD") S APCLEDY=Y
 I APCLED<APCLSD W !!,"Ending Date cannot be before Starting Date! Please reenter.",! G SD
 ;
SC ;
 K DIR,APCLSC,APCLSCP
 W ! S DIR(0)="YO",DIR("B")="NO",DIR("A")="Do you want a particular SERVICE CATEGORY",DIR("?")="" D ^DIR K DIR
 I $E(X)=U!($D(DTOUT)) G SD
 I $E(X)="N" S APCLSC="AIHOS",APCLSCP="ALL VISIT SERVICE CATEGORIES" G CLIN
SC1 S DIR(0)="9000010,.07",DIR("A")="Which Service Category" D ^DIR K DIR
 I $D(DTOUT)!($E(X)=U) G SC
 I "AHIOS"'[Y W !!,$C(7),$C(7),"Sorry, we only display visits for the following service categories: ",!,"H - Hospitalizations, A - Ambulatory, I - In Hospital, O - Observation",!,"and S - Day Surgery.  Please re-enter your choice.",! G SC1
 S APCLSC=Y,APCLSCP=Y(0)
 ;
CLIN ;CLIN Screening
 S APCLCLN=""
 W ! S DIR(0)="YO",DIR("B")="NO",DIR("A")="Do you want a particular CLINIC",DIR("?")="" D ^DIR K DIR
 I $E(X)=U!($D(DTOUT)) G SD
 I Y=0 G CT
CLIN1 ;CLIN1 SubRoutine
 S DIC("A")="Which Clinic: ",DIC="^DIC(40.7,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 CLIN
 S APCLCLN=+Y
CT ;
 S DIR(0)="SO^1:Commissioned Officers/Dependents;2:Medicare Part A;3:Medicare Part B;4:Medicaid;5:Private Insurance;6:Non-Indians;7:All Above Coverages",DIR("A")="     Select Third Party Coverage"
 D ^DIR K DIR W !!
 G:$D(DIRUT) SD
 S APCLNAR(1)="Commissioned Officers/Dependents"
 S APCLNAR(2)="Medicare Part A"
 S APCLNAR(3)="Medicare Part B"
 S APCLNAR(4)="Medicaid"
 S APCLNAR(5)="Private Insurance"
 S APCLNAR(6)="Non-Indians"
 I Y=7 S APCLPALL=Y,APCLRNUM=1
 I Y<7 S (APCLPROC,APCLRNUM)=Y,APCLNAR=APCLNAR(APCLRNUM)
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G CT
 S XBRP="^APCLBV1",XBRC="^APCLBV2",XBRX="EOJ^APCLBV",XBNS="APCL"
 D ^XBDBQUE
 D EOJ
 Q
EOJ ;ENTRY POINT
 K POP,ZTSK,ZTQUEUED,DFN,%DT,%,X,Y,DIRUT,DTOUT,J,K,%XX,%YY,DDBN,DDBX,HS,C,IO("Q"),DIR,DIRUT,DIC,DA,DR,DIQ,SSN,H,M,S,TS
 K APCLSD,APCLSDY,APCLED,APCLEDY,APCLPROC,APCLNAR,APCL,APCLSU,APCLLENG,APCLDTP,APCLCAT,APCLMDFN,APCLGOT,APCLBT,APCLET,APCLNAME,APCLSC,APCLSCP,APCLJOB,APCLCLN
 K APCLS,APCLCOAR,APCLCOPN,APCLVDFN,APCLVN0,APCLCOP,APCLPN,APCLVAL,APCLTRI,APCLTRIC
 K APCLCHMP,APCL80E,APCL80D,APCLPG,APCLEOJ,APCLX,APCLVDFN,APCLVREC,APCLDATE,APCL1,APCL2,APCLAP,APCLDISC,APCLY,APCLSKIP,APCLMN,APCLMDOB,APCLMEDN,DOB,APCLHRN,APCLVAL
 K APCLERCO,APCLPALL,APCLRNUM,APCLCNTR,APCLSAVE,APCLQUIT
 K APCLNDFN,APCLREC,APCLNREC
 Q
