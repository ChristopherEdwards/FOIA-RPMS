DWCONSRB ; PIMC - CONSULTANT RECORD BRIEF 1/15/97 1:42 PM ;  [ 01/16/97  9:20 AM ]
 ; WRITTEN BY WALZ 
NODFN ; ENTRY POINT - No Pre-Defined Patient Number.
 
 D PTLK^AG
 Q:'$D(DFN)
DFN ; ENTRY POINT - Pre-Defined Patient Number.
L1 K AG Q:'$D(DFN)  D ^AGDATCK I AG("DTOT")>0 D ^AGBADATA
DEV S %ZIS="NQ" D ^%ZIS
 I $D(POP) I POP=1 Q  ;; ADDED BY WALZ
 I IO'=IO(0) D QUE,HOME^%ZIS K AG Q
 I $D(IO("S")) S IOP=ION,$P(IOP,";",2)=IOST,$P(IOP,";",3)=IOM,$P(IOP,";",4)=IOSL D ^%ZIS
START ; ENTRY POINT - From TaskMan.
 D ^AGVAR,LINES^AG,NOW^AG S AG("LOC")=$P(^DIC(4,DUZ(2),0),U)
 S AG("PAGE")=0 D HDR
ALIAS ;OTHER NAMES
 I $O(^DPT(DFN,.01,0)) D
 .W !,"OTHER NAME(S):"
 .N I S I=0 F  S I=$O(^DPT(DFN,.01,I)) Q:'I  D
 ..W ?16,$P(^DPT(DFN,.01,I,0),"^",1),!
 E  W !
 S DR=.09,DIC=2 D ^AGDICLK
 I $D(AG("LKPRINT")) W "SSN: ",AG("LKPRINT") D
 .I $P(^AUPNPAT(DA,0),U,23) W ?40,"SSN STATUS: ",$P(^AUTTSSN($P(^(0),U,23),0),U,2)
 .E  W ?40,"SSN STATUS UNKNOWN"
 W !,"CLASS: " S DR=1111,DIC=9000001 D ^AGDICLK W:$D(AG("LKPRINT")) AG("LKPRINT")
 W ?62,"SEX: " S DR=.02,DIC=2 D ^AGDICLK W:$D(AG("LKPRINT")) AG("LKPRINT")
 W !,"COMMUNITY: " S DR=1118,DIC=9000001 D ^AGDICLK W:$D(AG("LKPRINT")) AG("LKPRINT") I AGOPT(14)="Y",$D(^AUPNPAT(DFN,11)) W " (",$S($P(^(11),U,21)="Y":"Verified",1:"Unverified"),")"
 W ?57,"BIRTHDAY: " S DR=.03,DIC=2 D ^AGDICLK W:$D(AG("LKPRINT")) AG("LKPRINT")
 W !?3,"COUNTY: " S DIC=9000001.51,DR=.03,AG("DRENT")=0 D ^AGDICLK I '$D(AG("LKERR")),AG("LKDATA")]"",$D(^AUTTCOM(AG("LKDATA"),0)) S AG=$P(^(0),U,2) I AG,$D(^AUTTCTY(AG,0)) W $P(^(0),U)
 W ?62,"AGE: " S DR=1102.98,DIC=9000001 D ^AGDICLK I '$D(AG("LKERR")),$D(AG("LKPRINT")),+AG("LKPRINT") W AG("LKPRINT")
 W !,"HOME ADDRESS:" S DR=.111,DIC=2 D ^AGDICLK I $D(AG("LKPRINT")),AG("LKPRINT")]"" W !?5,AG("LKPRINT")
 S AG="",DR=.114 D ^AGDICLK I $D(AG("LKPRINT")),AG("LKPRINT")]"" S AG=AG_AG("LKPRINT")_","
 F DR=.115,.116 D ^AGDICLK I $D(AG("LKPRINT")),AG("LKPRINT")]"" S AG=AG_" "_AG("LKPRINT")
 W:AG]"" !?5,AG
 K AGQUIT
 D ^DWCONSR7,^AGFACE4,^AGFACE5
 I $D(AGQUIT) K AGQUIT Q
END W !,AG("-"),! D CONF
 S Y=1 I $E(IOST)="C" S DIR(0)="E" D ^DIR K DIR W $$S^AGVDF("IOF")
END1 D ^%ZISC
 K AG,AGIO,AGTIME,G,AGL,AGLAST,AG("LKERR"),AG("LKDATA"),AG("LKPRINT"),AGPCC,X,Y,Z
 D:$D(ZTQUEUED) KILL^%ZTLOAD
 Q
HDR ;EP - CONSULTANT RECORD SHEET
 S AG("PAGE")=AG("PAGE")+1
 I AG("PAGE")>1 D RTRN^AG I 'Y S AGQUIT="" D END1 Q
 W:AG("PAGE")>1 $$S^AGVDF("IOF")
 D CPI^AG
 W !?40-($L(AG("LOC"))\2),AG("LOC"),!?27,"CONSULTANT RECORD BRIEF",!?25,"------------------------------",!,AGTIME,?70,"Page: ",AG("PAGE"),!,AG("="),!
 W "PATIENT: " S DIC=2,DA=DFN,DR=.01 D ^AGDICLK W:$D(AG("LKPRINT")) AG("LKPRINT") I $D(^DPT(DFN,"VET")),^("VET")="Y" W " (VETERAN)"
 W ?59,"CHART #: " W:$D(^AUPNPAT(DFN,41,DUZ(2),0)) $P(^(0),U,2) W !,AG("="),!
 Q
QUE ;QUE TO TASKMAN
 S ZTRTN="START^DWCONSRB",ZTDESC="CONSULTANT SHEET for "_$P(^DPT(DFN,0),U)_"."
 S ZTDTH=$H
 S ZTSAVE("DFN")=""
 K ZTSK D ^%ZTLOAD W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 Q
CONF W ?20,"*** CONFIDENTIAL CLIENT INFORMATION ***"
 W !,?10,"This information has been disclosed to you from client records"
 W !,?10,"whose confidentiality is protected by Federal law.  CFR42, Part 2"
 W !,?10,"prohibits you from making any further disclosure without the"
 W !,?10,"specific written consent of the person to whom it pertains, or"
 W !,?10,"as otherwise permitted by such regulations.  A general authorization"
 W !,?10,"for the release of medical or other information is NOT sufficient"
 W !,?10,"for this purpose."
 W !,?20,"*** CONFIDENTIAL CLIENT INFORMATION ***"
 Q
