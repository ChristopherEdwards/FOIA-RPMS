APCLRPL ; IHS/CMI/LAB - r-dmg-510 PATIENT LIST ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;
 K APCLQUIT
 D INIT
 G:$D(APCLQUIT) QUIT
F ;
 W !!
 K APCLLOC S DIC("A")="Run report for patients registered at which Facility: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 QUIT
 S APCLLOC=+Y
 W !!
 S APCLNCAN=1 D ADD^APCLVL01 I $D(APCLQUIT) D DEL^APCLVL K APCLQUIT G QUIT
SCREEN ;
 S APCLTCW=0,APCLPTVS="P",APCLTYPE="P",APCLCTYP=""
 K ^APCLVRPT(APCLRPT,11) S APCLCNTL="S" D ^APCLVL4 K APCLCNTL I $D(APCLQUIT) D DEL^APCLVL G QUIT
 D SORT^APCLVL3
 I $D(APCLQUIT) D DEL^APCLVL G QUIT
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G F
 K APCLSEL,APCLDISP
 S XBRP="^APCLRPLP",XBRC="^APCLRPL1",XBRX="QUIT^APCLRPL",XBNS="APCL"
 D ^XBDBQUE
 D QUIT
 Q
QUIT ;
 K APCLLOC,APCLNCAN,APCLQUIT,APCLTCW,APCLSEL,APCLDISP,APCLPTVS,APCLTYPE,APCLCTYP,APCLRPT,APCLBT,APCLBTH,APCLET,APCLRCNT,APCLPTCT,APCLJOB,APCLSPEC,APCLSKIP,APCLSRT,APCSRTV,APCLPRNT,APCLCRIT,APCLSORT,APCLX,APCLI,APCLFOUN,APCLPG,APCLFRST
 K DFN
 Q
INIT ;
 W:$D(IOF) @IOF
 W !,?15,"********** DETAILED PATIENT REGISTER *********",!!
 W !,"This Option will search the Patient file for all patients that you select.",!
 W "A Report will result which will resemble the output from the R-DMG-510 report"
 W !,"received from the data center.",!
 W !,"You will be asked to select which facilities chart number should be displayed",!,"on the report.",!
 W !,"Two additional screens will also be displayed.  The 1st Screen allows the User",!,"SEARCH for a selected group of patients."
 W "  The 2nd Screen allows the User",!," to SORT the report output as desired",!
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT)!('Y) S APCLQUIT=""
 Q
