APCL8A ; IHS/CMI/LAB - APC visits by primary provider ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
START ; 
 D INFORM
 K DUOUT,DTOUT
FY S %DT="AE",%DT("A")="Enter the Fiscal Year for this 1A report: ",%DT("B")=$E(DT,2,3) D ^%DT I $D(DTOUT) G EOJ
 I X="^" G EOJ
 I Y=-1 D ERR G FY
 I $E(Y,4,7)'="0000" D ERR G FY
 S X1=$E(Y,1,3)_"0930",X2=-365 D C^%DTC S APCLFY=$E(X,1,3)_"1001"
F ;
 S DIC("A")="Run for which Facility of Encounter: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 FY
 S APCLLOC=+Y
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G FY
ZIS ;
 S XBRP="^APCL8AP",XBRC="^APCL8A1",XBRX="EOJ^APCL8A",XBNS="APCL"
 D ^XBDBQUE
 D EOJ
 Q
ERR W $C(7),$C(7),!,"Must be a valid Year.  Enter a year only!!" Q
EOJ K APCLFY,APCLLOC,APCLSD,APCLVDFN,APCLVREC,APCLSKIP,APCLCLIN,APCL1,APCL2,APCLDISC,APCLAP,APCLPPOV,APCLX,APCLDPTR,APCLVLOC,APCLMOL,APCLFYD,APCLMOS,APCLBT,APCLJOB
 K APCLDT,APCLAREA,APCLLOCP,APCLLOC,APCLAREC,APCLSU,APCLSUC,APCLGRAN,APCLPG,APCLQUIT,APCLMON,APCLTAB,APCLJ,APCLDISN,APCLPRIM,APCLP,APCLT,APCLPRIT,APCL80,APCLFYE,APCLLOCC,APCLCOMP,APCLCOMX
 K X,X1,X2,IO("Q"),%,Y,%DT,%Y,%W,%T,%H,DUOUT,DTOUT,POP,ZTSK,ZTQUEUED,H,S,TS,M
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"**********  PCC/APC REPORT 1A - VISITS NOT EXPORTED  **********",!
 W !,"This report will process exactly like the 1A report, except instead of ",!,"producing the 1A report it will list all visits that would be ",!,"included in the 1A that have NOT been exported to the ",!,"National Data Warehouse (NDW).",!
 Q
 ;
 ;
