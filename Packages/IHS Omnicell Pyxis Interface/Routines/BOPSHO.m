BOPSHO ;IHS/ILC/ALG/CIA/PLS - What's In The Queue;09-Feb-2006 22:38;DU
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
SITE ;combining queue summary with a detailed queue
 N SITID,RECFAC,SITE,DISP,CNT,SITCHK,ANS,RECFAC S CNT=0 W @IOF
 S SITID=$O(^BOP(90355,"B",0)) Q:'SITID  S SITE=$O(^(SITID,0))
 Q:'$D(^BOP(90355,SITE,3))
 S RECFAC=0 F  S RECFAC=$O(^BOP(90355,SITE,3,RECFAC)) Q:RECFAC'>0  D
 .S CNT=CNT+1,RECFAC(CNT)=CNT_U_RECFAC_U_$P(^DG(40.8,RECFAC,0),U)
AGAIN S CNT=0 F  S CNT=$O(RECFAC(CNT)) Q:CNT'>0  D
 .S SITID=$P(RECFAC(CNT),U,2),SITCHK=$P(RECFAC(CNT),U,3) D SHOW
 S DIR("A")="Press 'return' to refresh, 'D' detailed, '^' to quit "
 S DIR(0)="FO" D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)
 W @IOF G AGAIN
 I '$D(^BOP(90355,SITE,"LOC","B")) D  G AGAIN
 .S SITID=$P(RECFAC(1),U,2),SITCHK=$P(RECFAC(1),U,3) W @IOF D DETAIL
 I $D(^BOP(90355,SITE,"LOC","B")) D  G AGAIN
 .S CNT=0 F  S CNT=$O(RECFAC(CNT)) Q:CNT=""  D
 ..W !?12,$P(RECFAC(CNT),U),?18,$P(RECFAC(CNT),U,3)
 .W !!,"Select the Receiving Faciity to show queue (1-"_$E($O(RECFAC(CNT),-1))_")",!
 .S DIR("A")=" or '^' to exit // ",DIR(0)="N" D ^DIR K DIR Q:$D(DIRUT)
 .Q:'Y
 .S ANS=+Y
 .I '$D(RECFAC(ANS)) W @IOF,"Not a valid entry.  Try again.",$C(7) Q
 .S SITID=$P(RECFAC(ANS),U,2),SITCHK=$P(RECFAC(ANS),U,3) W @IOF D DETAIL
 E  W @IOF,"Not a valid entry.  Try again.",$C(7) G AGAIN
 Q
SHOW ;
 S BOPWHO=$$INTFACE^BOPTU(1) S BOPWHO=$S(BOPWHO="O":"Omnicell",1:"Pyxis")
 W !!!,$G(BOPWHO)_" Queue Summary for "_SITCHK
 N COUNT,KOUNT,MKOUNT,MT,I,STAT S COUNT=0,STAT=""
 S I=0 F  S I=$O(^BOP(90355.1,"AS",0,I)) Q:'I  D
 .I '$D(^BOP(90355.1,I,0)) K ^BOP(90355.1,"AS",0,I) Q  ;->
 .I $D(^BOP(90355.1,I,0)) S STAT=$P(^BOP(90355.1,I,0),U,10) I STAT>0 K ^BOP(90355.1,"AS",0,I) S ^BOP(90355.1,"AS",STAT,I)="" Q
 .I SITID,$P(^BOP(90355.1,I,0),U,12)'=SITID Q
 .S COUNT=COUNT+1
 .S MT=$P($G(^BOP(90355.1,I,0)),U,4)
 .S:MT="" MKOUNT=$G(MKOUNT)+1
 .S:MT'="" KOUNT(MT)=$G(KOUNT(MT))+1
 W !!,"There are ",COUNT," 'Ready to Send' messages in the "_$G(BOPWHO)_" Queue."
 W !,"There are ",+$G(KOUNT("ADT"))," ADT messages in the Queue."
 W !,"There are ",+$G(KOUNT("RDE"))," ORDER messages in the Queue."
 I +$G(MKOUNT)>0 W !,"There are ",+$G(MKOUNT)," Passthru messages in the Queue."
 Q
 ;
DETAIL ;detailed queue of message (up to 40 characters)
 W @IOF,"Parts of last 5 messages and next 5 queued for today.......",SITCHK,!
 N LINE,ANSW,AS,CONT,STAT S (LINE,AS,CONT,STAT)=0
 S LINE=$O(^BOPMTMP("SEND",DT,":"),-1) I LINE="" W !,"No active messages!",!! G AS
 S LINE=LINE-5 I LINE<1 S LINE=0
 F  S LINE=$O(^BOPMTMP("SEND",DT,LINE)) Q:LINE<1  W !,LINE_" = "_$E(^BOPMTMP("SEND",DT,LINE),1,40)
AS I '$D(^BOP(90355.1,"AS",0)) W !!,"No queued messages!" G RE
 F  S AS=$O(^BOP(90355.1,"AS",0,AS)) Q:AS<1!(CONT>4)  D
 .I '$D(^BOP(90355.1,AS,0)) K ^BOP(19233.1,"AS",0,AS) Q
 .I $D(^BOP(90355.1,AS,0)) S STAT=$P(^BOP(90355.1,AS,0),U,10) I STAT>0 K ^BOP(90355.1,"AS",0,AS) S ^BOP(19233.1,"AS",STAT,AS)="" Q  ;->
 .I SITID,$P(^BOP(90355.1,AS,0),U,12)'=SITID Q
 .S CONT=CONT+1 W !,"Queued messages...",AS
RE S DIR("A")="Enter <return> to refresh, '^' to quit // ",DIR(0)="FO" D ^DIR K DIR Q:$D(DIRUT)
 D DETAIL Q
 ;
PATLOOK ;EP -  display queue for a patient
 N DFN,DIC,Y,ANS,X,A,B
 S DIC="^DPT(",DIC(0)="QEAM" D ^DIC Q:Y'>0  S DFN=+Y
 S DIR("A")="Is this the correct patient",DIR(0)="Y",DIR("B")="YES" D ^DIR K DIR Q:$D(DIRUT)
 I 'Y G PATLOOK
 I '$D(^BOP(90355.1,"ADFN",DFN)) W !,"Not in transmission file",$C(7) G PATLOOK
 S A=0 F  S A=$O(^BOP(90355.1,"ADFN",DFN,A)) Q:'A  D  I X["^" G PATLOOK
 .S B=$O(^BOP(90355.1,A,"O",1,""))
 .S B=0 F  S B=$O(^BOP(90355.1,A,B)) Q:'B
 .D ^BOPSLK
 .S DIR("A")="Enter ^ to quit <return> to continue",DIR(0)="FO" D ^DIR K DIR Q:$D(DIRUT)
 W !,"No more entries",! G PATLOOK
 ;
START ;EP - called by option "Activate Receiving Facility"
 N SITID,RECFAC,SITE,DISP,CNT,SITCHK,ANS,RECFAC,RFIEN,ACTION,DIR S CNT=0,ACTION="" W @IOF
 S SITID=$O(^BOP(90355,"B",0)),SITE=$O(^(SITID,0))
 Q:'$D(^BOP(90355,SITE,3))
 S RECFAC=0 F  S RECFAC=$O(^BOP(90355,SITE,3,"B",RECFAC)) Q:RECFAC'>0  D
 .S RFIEN=$O(^BOP(90355,SITE,3,"B",RECFAC,0))
 .S CNT=CNT+1,RECFAC(CNT)=CNT_U_RECFAC_U_$P(^DG(40.8,RECFAC,0),U)
 S CNT=0 F  S CNT=$O(RECFAC(CNT)) Q:CNT'>0  D
 .W !!,$P(RECFAC(CNT),U),"  ",$P(RECFAC(CNT),U,3)
BK S DIR("A")="Which Receiving Facility do you want to activate",DIR(0)="N" D ^DIR K DIR Q:$D(DIRUT)
 I Y S ANS=+Y
 F CNT=1:1 Q:'$D(RECFAC(CNT))  I ANS=$P(RECFAC(CNT),U) S RECFAC=$P(RECFAC(CNT),U,2) G ON
ON W !,"You are logged into the "_$P(^DG(40.8,RECFAC,0),U)_" Receiving Facility."
 I $P($G(^BOP(90355,SITE,3,RFIEN,0)),U,2)=1 S ACTION=1
 E  S ACTION=0
 I ACTION W !,"The site interface is already on. Bye!" Q
 S DIR("A")="Are you sure you want to activate?"
 S DIR(0)="Y",DIR("B")="YES" D ^DIR I Y'=1 W !,"QUITTING" Q
 S $P(^BOP(90355,SITE,3,RFIEN,0),U,2)=1
 W !!,"The receiving facilty "_$P(^DG(40.8,RECFAC,0),U)_" is activated."
 Q
 ;
STOP ;EP - called by option "Deactivate Receiving Facility"
 N SITID,RECFAC,SITE,DISP,CNT,SITCHK,ANS,RECFAC,RFIEN,DIR,ACTION S CNT=0,ACTION="" W @IOF
 S SITID=$O(^BOP(90355,"B",0)),SITE=$O(^(SITID,0))
 Q:'$D(^BOP(90355,SITE,3))
 S RECFAC=0 F  S RECFAC=$O(^BOP(90355,SITE,3,"B",RECFAC)) Q:RECFAC'>0  D
 .S RFIEN=$O(^BOP(90355,SITE,3,"B",RECFAC,0))
 .S CNT=CNT+1,RECFAC(CNT)=CNT_U_RECFAC_U_$P(^DG(40.8,RECFAC,0),U)
 S CNT=0 F  S CNT=$O(RECFAC(CNT)) Q:CNT'>0  D
 .W !!,$P(RECFAC(CNT),U),"  ",$P(RECFAC(CNT),U,3)
BKS S DIR("A")="Which Receiving Facility do you want to deactivate",DIR(0)="N" D ^DIR K DIR Q:$D(DIRUT)
 S ANS=+Y
 F CNT=1:1 Q:'$D(RECFAC(CNT))  I ANS=$P(RECFAC(CNT),U) S RECFAC=$P(RECFAC(CNT),U,2) G ONS
ONS W !,"You are logged into the "_$P(^DG(40.8,RECFAC,0),U)_" Receiving Facility."
 I $P($G(^BOP(90355,SITE,3,RFIEN,0)),U,2)=1 S ACTION=1
 E  S ACTION=0
 I 'ACTION W !,"The receiving facility is already deactivated. Bye!" Q
 S DIR("A")="Are you sure you want to deactivate?"
 S DIR(0)="Y",DIR("B")="YES" D ^DIR K DIR I Y'=1 W !,"No deactivation. Bye!" Q
 S $P(^BOP(90355,SITE,3,RFIEN,0),U,2)=0
 W !!,"The receiving facility "_$P(^DG(40.8,RECFAC,0),U)_" is deactivated."
 Q
 ;
END ;EP - stop the interface
 N SITID,SITE
 S SITID=$O(^BOP(90355,"B",0)),SITE=$O(^(SITID,0))
 S ^BOP(90355,SITE,12)=1
 W !,"Stop flag is set. The interface will attempt to restart in 15 minutes."
 Q
