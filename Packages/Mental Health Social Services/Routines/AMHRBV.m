AMHRBV ; IHS/CMI/LAB - print billable visits ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
START ;
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! Q
 W:$D(IOF) @IOF
 W !!,"This Option prints who are a list of Potentially Billable Visits for all ",!,"patients registered at the Facility that you select who have been seen",!,"by Mental Health and Social Services.",!
 W "The user will select which third party coverage type that they are interested",!,"in seeing billable visits for."
 W !,"This report displays visits during a period when this patient had third",!,"party coverage, but does not consider the diagnostic category which may be",!,"excluded by some types of coverage.",!
 D DBHUSR^AMHUTIL
F ;
 S DIC("A")="Run the report for Patients registered at which Facility: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 EOJ
 S AMHSU=+Y
SD ;
 W !
 S Y=DT X ^DD("DD") S AMHDTP=Y
 S %DT("A")="Starting Visit Date for Billable Visits: ",%DT="AEPX" W ! D ^%DT
 I Y=-1 G F
 S AMHSD=Y X ^DD("DD") S AMHSDY=Y
ED S %DT("A")="Ending Visit Date for Billable Visits: " W ! D ^%DT K %DT
 I Y=-1 G SD
 S AMHED=Y X ^DD("DD") S AMHEDY=Y
 I AMHED<AMHSD W !!,"Ending Date cannot be before Starting Date! Please reenter.",! G SD
 ;
CT ;
 S DIR(0)="SO^1:Commissioned Officers/Dependents;2:Medicare Part A;3:Medicare Part B;4:Medicaid;5:Private Insurance;6:Non-Indians",DIR("A")="Select Third Party Coverage" D ^DIR K DIR
 G:$D(DIRUT) SD
 S AMHPROC=Y,AMHNAR=Y(0)
ZIS ;
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G EOJ
 I $G(Y)="B" D BROWSE,EOJ Q
 S XBRP="^AMHRBV1",XBRC="^AMHRBV2",XBRX="EOJ^AMHRBV",XBNS="AMH"
 D ^XBDBQUE
 D EOJ
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^AMHRBV1"")"
 S XBNS="AMH",XBRC="^AMHRBV2",XBRX="EOJ^AMHRBV",XBIOP=0 D ^XBDBQUE
 Q
EOJ ;ENTRY POINT
 K POP,ZTSK,ZTQUEUED,DFN,%DT,%,X,Y,DIRUT,DTOUT,J,K,%XX,%YY,DDBN,DDBX,HS,IX,C,IO("Q"),DIR,DIRUT,DIC,DA,DR,DIQ,H,M,S,TS,ABHN
 K AMHSD,AMHSDY,AMHED,AMHEDY,AMHPROC,AMHNAR,AMH,AMHSU,AMHLENG,AMHDTP,AMHCAT,AMHMDFN,AMHGOT,AMHBT,AMHNAMEP,AMHJOB,AMHMIN
 K AMHS,AMHCOAR,AMHCOPN,AMHVDFN,AMHVN0,AMHCOP,AMHPN,AMHVAL,AMHTRI,AMHTRIC
 K AMHCHMP,AMH80E,AMH80D,AMHPG,AMHEOJ,AMHX,AMHVDFN,AMHVREC,AMHDATE,AMH1,AMH2,AMHAP,AMHDISC,AMHY,AMHSKIP,AMHMN,AMHMDOB,AMHMEDN,DOB,AMHHRN,AMHVAL
 K AMHNDFN,AMHREC,AMHNREC,AMHACT,AMHINI,AMHRDFN
 Q
