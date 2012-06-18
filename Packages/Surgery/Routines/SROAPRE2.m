SROAPRE2 ;B'HAM ISC/MAM - EDIT PAGE 2 PREOP ; 25 MAR 1992  9:30 am
 ;;3.0; Surgery ;**38,47**;24 Jun 93
 D @EMILY Q
1 ; edit CNS information
 W ! K DIR S X=$P(SRAO(1),"^") I X'="" S DIR("B")=X
 S DIR(0)="130,210",DIR("A")="CENTRAL NERVOUS SYSTEM" D ^DIR K DIR I $D(DUOUT) S SRSOUT=1 Q
 I X="@" S SRCAT="Central Nervous System" D SURE Q:SRSOUT  G:'SRYN 1 S $P(^SRF(SRTN,200),"^",18)="" S (SRAX,X)="" D NOCNS Q
 S:X="N" X="NO" S:X="Y" X="YES"
 S SRAX=$S(X="NS":"NS",1:$E(X)),$P(^SRF(SRTN,200),"^",18)=SRAX I X["N" D NOCNS Q
 I $E(X)["Y" D CNS
 Q
2 ; edit nutritional/immune/other info
 W ! K DIR S X=$P(SRAO(2),"^") I X'="" S DIR("B")=X
 S DIR(0)="130,245",DIR("A")="NUTRITIONAL/IMMUNE/OTHER" D ^DIR K DIR I $D(DUOUT) S SRSOUT=1 Q
 I X="@" S SRCAT="Nutritional/Immune/Other" D SURE Q:SRSOUT  G:'SRYN 2 S $P(^SRF(SRTN,200),"^",44)="" S (SRAX,X)="" D NONUT Q
 S:X="N" X="NO" S:X="Y" X="YES"
 S SRAX=$S(X="NS":"NS",1:$E(X)),$P(^SRF(SRTN,200),"^",44)=SRAX I X["N" D NONUT Q
 I X["Y" D NUT
 Q
CNS ; cns
 W ! K DR,DIE S DIE=130,DA=SRTN,DR="332T;333T;400T;334T;335T;336T;401T" D ^DIE K DR,DIE
 S SRACLR=0
 Q
NOCNS ; no CNS problems
 F I=19,21,24:1:27,29 S $P(^SRF(SRTN,200),"^",I)=SRAX
 Q
NUT ; nutritional/immune/other
 W ! K DR,DIE S DIE=130,DA=SRTN,DR="338T;218T;339T;215T;216T;217T;338.1T;338.2T;218.1T" D ^DIE K DA,DIE,DR
 S SRACLR=0
 Q
NONUT ; no nutritional/immune/other
 F I=45:1:50 S $P(^SRF(SRTN,200),"^",I)=SRAX
 F I=3,4,8 S $P(^SRF(SRTN,206),"^",I)=SRAX
 Q
RET W !! K DIR S DIR(0)="E" D ^DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
SURE W ! K DIR S DIR("A")="   Sure you want to delete all "_SRCAT_" information ? ",DIR("B")="NO",DIR(0)="YA" D ^DIR K DIR S SRYN=Y I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
DEL W !!,?10,"Deleting all "_SRCAT_" information...  "
 Q
