APCDACP ; IHS/CMI/LAB - list V POV's that have Accept command ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
INFORM ;inform user what is going on
 W:$D(IOF) @IOF
 F APCDJ=1:1:5 S APCDX=$P($T(HDR+APCDJ),";;",2) W !?80-$L(APCDX)\2,APCDX
 F APCDJ=1:1:6 W !,$P($T(TEXT+APCDJ),";;",2)
 K APCDX,APCDJ
 ;
RDPV ; Determine to run by Posting date or Visit date
 S APCDBEEP=$C(7)_$C(7),APCDSITE="" S:$D(DUZ(2)) APCDSITE=DUZ(2)
 I APCDSITE="" S APCDSITE=+^AUTTSITE(1,0)
 S DIR(0)="S^1:Posting Date;2:Visit Date",DIR("A")="Run Report by",DIR("B")="P" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S Y=$E(Y),APCDX=$S(Y=1:"P",Y=2:"V",1:Y)
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning "_$S(APCDX="P":"Posting",APCDX="V":"Visit",1:"Posting")_" Date for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCDBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCDBD_":DT:EP",DIR("A")="Enter ending "_$S(APCDX="P":"Posting",APCDX="V":"Visit",1:"Posting")_" Date for Search: " S Y=APCDBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDED=Y
 S X1=APCDBD,X2=-1 D C^%DTC S APCDSD=X
TYPE ;
 S DIR(0)="S^1:Purpose of Visit Records;2:Operations/Procedure Records;3:V Hospitalization Records;4:All of the Above",DIR("A")="List ACCEPT commands for which of the above" D ^DIR K DIR
 G:$D(DIRUT) BD
 S (APCDT,APCDACCT)=+Y
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G TYPE
ZIS ;
 W !! S %ZIS="PQ" D ^%ZIS
 I POP G XIT
 I $D(IO("Q")) G TSKMN
DRIVER ;EP;entry point from taskman
 S U="^"
 K ^XTMP("APCDACP",$J)
 D @APCDX
 U IO
 S APCDDT=$$FMTE^XLFDT(DT)
 D ^APCDACP1
 I '$D(ZTQUEUED) U IO(0)
 I $D(ZTQUEUED) S ZTREQ="@"
 G XIT
P ; Run by Posting date  
 S APCDODAT=$O(^AUPNVSIT("AMRG",APCDSD)) Q:APCDODAT=""
 S APCDVDFN=$O(^AUPNVSIT("AMRG",APCDODAT,"")) I APCDVDFN="" W !,"An error has occurred in the AMRG cross reference.  Please notify your Supervisor" Q
 S APCDVDFN=APCDVDFN-1
 F APCDL=0:0 S APCDVDFN=$O(^AUPNVSIT(APCDVDFN)) Q:APCDVDFN'=+APCDVDFN  I $D(^AUPNVSIT(APCDVDFN,0)) S APCDODAT=$P(^AUPNVSIT(APCDVDFN,0),U,2) Q:(APCDODAT>APCDED)  D PROC^APCDACP2
 Q
V ; Run by visit date
 S APCDODAT=$O(^AUPNVSIT("B",APCDSD)) Q:APCDODAT=""
 S APCDODAT=APCDSD_".9999" F APCDL=0:0 S APCDODAT=$O(^AUPNVSIT("B",APCDODAT)) Q:APCDODAT=""!((APCDODAT\1)>APCDED)  D V1
 Q
V1 ;
 S APCDVDFN="" F APCDL=0:0 S APCDVDFN=$O(^AUPNVSIT("B",APCDODAT,APCDVDFN)) Q:APCDVDFN'=+APCDVDFN  I $D(^AUPNVSIT(APCDVDFN,0)) D PROC^APCDACP2
 Q
ERR W APCDBEEP,!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
TSKMN ;
 K ZTSAVE F %="APCDX","APCDT","APCDBD","APCDED","APCDSD","APCDBDD","APCDBEEP","APCDSITE","APCDACCT","APCDFILE","APCDG","APCDTITL" S ZTSAVE(%)=""
 S ZTCPU=$G(IOCPU),ZTIO=ION,ZTRTN="DRIVER^APCDACP",ZTDTH="",ZTDESC="REVIEW ACCEPT POVS - DATA ENTRY" D ^%ZTLOAD D XIT Q
XIT K APCDBEEP,APCDX,APCDT,APCDBD,APCDED,APCDSD,APCDODAT,APCDVDFN,%,APCDL,X,X1,X2,IO("Q"),APCDDT,APCDSITE,APCDLC,APCDPG,APCDCAT,APCDTYPE,APCDADM,APCDPS,APCDPVP,APCDFILE,APCDOVAG,Y,POP,ZTSK,APCDJ
 K AUPNPAT,AUPNDAYS,AUPNDOB,AUPNSEX,AUPNDOD
 K APCDACCT,APCDG,APCDTITL,APCDFILE,APCDVIGR,DIRUT
 D ^%ZISC
 K ^XTMP("APCDACP",$J)
 Q
HDR ;
 ;;PCC Data Entry Module
 ;;
 ;;*****************************
 ;;*   PRINT ACCEPT Commands   *
 ;;*****************************
 ;;
 ;
TEXT ;informing paragraph
 ;;
 ;;This option will allow you to print all of the Purpose of Visit, Procedures
 ;;and/or Hospitalization records that have had  the ACCEPT command applied.
 ;;The ACCEPT command is used to override an edit in the IHS Direct Inpatient
 ;;and/or PCIS Systems.
 ;;
