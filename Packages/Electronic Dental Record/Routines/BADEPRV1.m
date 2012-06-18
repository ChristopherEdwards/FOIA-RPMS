BADEPRV1 ;IHS/SAIC/FJE  MSC/AMF - Dentrix Dental Visit Count ;14-Sep-2010 13:59;EDR
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 Q
FINDDLOC ;EP Display all Dental Location of Encounter ASUFACs in RPMS
 ;Optional Begin Date filter to limit data to current period of time
 ;If null, all Dental visits will be viewed
 ;This report displays all ASUFAC values and names associated with Dental Visits Only
 ;
 N BADEIEN,BADEVSIT,BADEVDT,BADESTRT,BADEASUF,BADEXX,BADENAME,BADEACT,BADEDT
 N X,%ZIS,IORVON,IORVOFF,VER,PKG,K
 ; Display statistics
 I $E($G(IOST),1,2)'="C-" W !,"Your terminal Type is not defined correctly for this report.",!!  S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR Q
 S VER="Version "_$G(VER,1.0),PKG=$G(PKG,"RPMS-Dentrix Dental ASUFAC Display")
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 U IO
 K %DT D NOW^%DTC S BADEDT=X
 W !!,"This report will display visits for each Dental Facility for a specific time period.",!
 S DIR(0)="D"_BADEDT_":EP",DIR("B")="T-365",DIR("A")="Enter the start date for the search"
 S DIR("?")="Specify the earliest date for your search." D ^DIR K DIR
 Q:Y=U  S BADESTRT=+Y
 ;S BADESTRT=0 I +Y>0 S BADESTRT=+Y
 W !,"Searching..." S K=0
 K BADEXX
 S BADEIEN=0 F  S BADEIEN=$O(^AUPNVDEN(BADEIEN)) Q:+BADEIEN'>0  D
 .S K=K+1 W:'(K#5000) "."
 .Q:'$D(^AUPNVDEN(BADEIEN,0))
 .S BADEVSIT=+$P($G(^AUPNVDEN(BADEIEN,0)),U,3)  ; VisitIEN
 .Q:'BADEVSIT
 .S BADEVDT=+$P($G(^AUPNVSIT(BADEVSIT,0)),U,1)     ; Visit Date/Time
 .Q:BADEVDT<BADESTRT  ;;Less Than Start Visit Date
 .S BADEASUF=$S(+$P($G(^AUPNVSIT(BADEVSIT,0)),U,6):$P($G(^AUPNVSIT(BADEVSIT,0)),U,6),1:0)  ;ASUFAC IEN
 .I '$D(BADEXX(BADEASUF)) S BADEXX(BADEASUF)=0
 .S BADEXX(BADEASUF)=BADEXX(BADEASUF)+1
 ;
 W @IOF,IORVON,$$GET1^DIQ(4,DUZ(2),.01),?(IOM-$L(PKG)\2),PKG,?(IOM-$L(VER)),VER,!,IORVOFF
 I '$D(BADEXX) W !,"No visits were found for this time period.",!!  S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR Q
 W !!,"Dental Facility",?32,"ASUFAC     Status Dental Visit Count"
 W !,"----------------------------------------------------------------------"
 S BADEIEN="" F  S BADEIEN=$O(BADEXX(BADEIEN)) Q:+BADEIEN=0  D
 .S BADENAME=$S($L($P($G(^DIC(4,BADEIEN,0)),U,1)):$P($G(^DIC(4,BADEIEN,0)),U,1),1:"No Name")
 .S BADEASUF=$S(+$P($G(^AUTTLOC(BADEIEN,0)),"^",10):$P($G(^AUTTLOC(BADEIEN,0)),"^",10),1:"None")
 .S BADEACT=$S(+$P($G(^AUTTLOC(BADEIEN,0)),"^",21):"Inactive",1:"Active")
 .W !,BADENAME,?32,BADEASUF,?43,BADEACT,?50,BADEXX(BADEIEN)
 W !!
 S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR
 Q
 ;
FINDVLOC ;EP Display all Location of Encounter ASUFACs in RPMS
 ;Optional Begin Date filter to limit data to current period of time
 ;If null, all Dental visits will be viewed
 ;This report displays all ASUFAC values and names associated with All Visits
 ;
 N BADEIEN,BADEVSIT,BADEVDT,BADESTRT,BADEASUF,BADEXX,BADENAME,BADEACT
 N X,%ZIS,IORVON,IORVOFF,VER,PKG
 ; Display statistics
 Q:$E($G(IOST),1,2)'="C-"
 S VER="Version "_$G(VER,1.0),PKG=$G(PKG,"RPMS-Dentrix Visit LOE ASUFAC Display")
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 U IO
 K %DT D NOW^%DTC S BADEDT=X
 S DIR(0)="D^:"_BADEDT_":EP",DIR("A")="Enter Start Date of Scan:  " KILL DA D ^DIR KILL DIR
 S BADESTRT=0 I +Y>0 S BADESTRT=+Y
 S DIR(0)="E",DIR("A")="Press Enter to Continue" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$G(DIRUT)=1
 W !,"Thinking...",!
 K BADEXX
 S BADEIEN=0 F  S BADEIEN=$O(^AUPNVSIT(BADEIEN)) Q:+BADEIEN'>0  D
 .Q:'$D(^AUPNVSIT(BADEIEN,0))
 .S BADEVDT=+$P($G(^AUPNVSIT(BADEIEN,0)),U,1)  ;Visit Date/Time
 .Q:BADEVDT<BADESTRT  ;;Less Than Start Visit Date
 .S BADEASUF=$S(+$P($G(^AUPNVSIT(BADEIEN,0)),U,6):$P($G(^AUPNVSIT(BADEIEN,0)),U,6),1:0)  ;ASUFAC IEN
 .I '$D(BADEXX(BADEASUF)) S BADEXX(BADEASUF)=0
 .S BADEXX(BADEASUF)=BADEXX(BADEASUF)+1
 ;
 W @IOF,IORVON,$$GET1^DIQ(4,DUZ(2),.01),?(IOM-$L(PKG)\2),PKG,?(IOM-$L(VER)),VER,!,IORVOFF
 W !!,"Visit LOC Name",?32,"ASUFAC     Status Visit Count"
 W !,"----------------------------------------------------------------------"
 S BADEIEN=0 F  S BADEIEN=$O(BADEXX(BADEIEN)) Q:+BADEIEN=0  D
 .S BADENAME=$S($L($P($G(^DIC(4,BADEIEN,0)),U,1)):$P($G(^DIC(4,BADEIEN,0)),U,1),1:"No Name")
 .S BADEASUF=$S(+$P($G(^AUTTLOC(BADEIEN,0)),"^",10):$P($G(^AUTTLOC(BADEIEN,0)),"^",10),1:"None")
 .S BADEACT=$S(+$P($G(^AUTTLOC(BADEIEN,0)),"^",21):"Inact",1:"Act")
 .W !,BADENAME,?32,BADEASUF,?43,BADEACT,?50,BADEXX(BADEIEN)
 W !!
 S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR
 Q
 ;
