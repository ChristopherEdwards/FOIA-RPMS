SROAPR1A ;B'HAM ISC/MAM - EDIT PREOP INFO ; 25 MAR 1992  7:25 am
 ;;3.0; Surgery ;**38**;24 Jun 93
 K DA D @EMILY Q
4 ; edit cardiac information
 W ! K DIR S X=$P(SRAO(4),"^") I X'="" S DIR("B")=X
 S DIR(0)="130,242",DIR("A")="CARDIAC" D ^DIR K DIR I $D(DUOUT) S SRSOUT=1 Q
 I X="@" S SRCAT="Cardiac" D SURE Q:SRSOUT  G:'SRYN 4 S (SRAX,X)="",$P(^SRF(SRTN,200),"^",30)="" D NOCARD Q
 S:X="N" X="NO" S:X="Y" X="YES"
 S SRAX=$S(X="NS":"NS",1:$E(X)),$P(^SRF(SRTN,200),"^",30)=SRAX I X["N" D NOCARD Q
 I SRAX="Y" D CARD
 Q
5 ; edit renal information
 W ! K DIR S X=$P(SRAO(5),"^") I X'="" S DIR("B")=X
 S DIR(0)="130,243",DIR("A")="RENAL" D ^DIR K DIR I $D(DUOUT) S SRSOUT=1 Q
 I X="@" S SRCAT="Renal" D SURE Q:SRSOUT  G:'SRYN 5 S $P(^SRF(SRTN,200),"^",37)="" S (SRAX,X)="" D NOREN Q
 S:X="N" X="NO" S:X="Y" X="YES"
 S SRAX=$S(X="NS":"NS",1:$E(X)),$P(^SRF(SRTN,200),"^",37)=SRAX I X["N" D NOREN Q
 I X["Y" D REN
 Q
CARD ; cardiac
 K DIE S DA=SRTN,DIE=130,DR="396////Y" D ^DIE K DR
 S SRACLR=0
 Q
NOCARD ; no cardiac problems
 S $P(^SRF(SRTN,200),"^",35)=SRAX
 Q
REN ; renal
 W ! K DR,DIE S DA=SRTN,DIE=130,DR="328T;211T" D ^DIE K DR
 S SRACLR=0
 Q
NOREN ; no renal problems
 F I=38,39 S $P(^SRF(SRTN,200),"^",I)=SRAX
 Q
RET W !! K DIR S DIR(0)="E" D ^DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
SURE W ! K DIR S DIR("A")="   Sure you want to delete all "_SRCAT_" information ? ",DIR("B")="NO",DIR(0)="YA" D ^DIR K DIR S SRYN=Y I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
