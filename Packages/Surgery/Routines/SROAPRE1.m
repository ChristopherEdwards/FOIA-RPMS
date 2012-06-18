SROAPRE1 ;B'HAM ISC/MAM - EDIT PAGE 1 PREOP ; 25 MAR 1992  9:05 am
 ;;3.0; Surgery ;**38,47**;24 Jun 93
 K DA D @EMILY Q
1 ; edit general information
 W ! K DIR S X=$P(SRAO(1),"^") I X'="" S DIR("B")=X
 S DIR(0)="130,402",DIR("A")="GENERAL" D ^DIR K DIR I $D(DUOUT) S SRSOUT=1 Q
 I X="@" S SRCAT="General" D SURE Q:SRSOUT  G:'SRYN 1 S (SRAX,X)="",$P(^SRF(SRTN,200),"^")="" D NOGEN Q
 S:X="N" X="NO" S:X="Y" X="YES"
 S SRAX=$S(X="NS":"NS",1:$E(X)),$P(^SRF(SRTN,200),"^")=SRAX I X["N" D NOGEN Q
 I SRAX="Y" D GEN
 Q
2 ; edit pulmonary information
 W ! K DIR S X=$P(SRAO(2),"^") I X'="" S DIR("B")=X
 S DIR(0)="130,241",DIR("A")="PULMONARY" D ^DIR K DIR I $D(DUOUT) S SRSOUT=1 Q
 I X="@" S SRCAT="Pulmonary" D SURE Q:SRSOUT  G:'SRYN 2 S (SRAX,X)="",$P(^SRF(SRTN,200),"^",9)="" D NOPULM Q
 S:X="N" X="NO" S:X="Y" X="YES"
 S SRAX=$S(X="NS":"NS",1:$E(X)),$P(^SRF(SRTN,200),"^",9)=SRAX I X["N" D NOPULM Q
 I SRAX="Y" D PULM
 Q
3 ; edit hepatobiliary information
 W ! K DIR S X=$P(SRAO(3),"^") I X'="" S DIR("B")=X
 S DIR(0)="130,244",DIR("A")="HEPATOBILIARY" D ^DIR K DIR I $D(DUOUT) S SRSOUT=1 Q
 I X="@" S SRCAT="Hepatobiliary" D SURE Q:SRSOUT  G:'SRYN 3 S (SRAX,X)="",$P(^SRF(SRTN,200),"^",13)="" D NOHEP Q
 S:X="N" X="NO" S:X="Y" X="YES"
 S SRAX=$S(X="NS":"NS",1:$E(X)),$P(^SRF(SRTN,200),"^",13)=SRAX I X["N" D NOHEP Q
 I SRAX="Y" D HEP
 Q
GEN ; general
 W ! K DR,DIE S DA=SRTN,DIE=130,DR="346T;202T;202.1T;246T;325T;238T;240T" D ^DIE K DR
 S SRACLR=0
 Q
NOGEN ; no general problems
 S $P(^SRF(SRTN,200),"^",6)=$S(X="":"",1:1) F I=2,3,4,7 S $P(^SRF(SRTN,200),"^",I)=SRAX
 S $P(^SRF(SRTN,200),"^",8)=$S(X="":"",X="NS":"NS",1:1),$P(^SRF(SRTN,208),"^",9)=$S(X="":"",X="NS":"NS",1:0)
 Q
PULM ; pulmonary
 W ! K DR,DIE S DA=SRTN,DIE=130,DR="204T;203T;326T" D ^DIE K DR
 S SRACLR=0
 Q
NOPULM ; no pulmonary problems
 F I=10:1:12 S $P(^SRF(SRTN,200),"^",I)=SRAX
 Q
HEP ; hepatobiliary
 K DR,DIE S DIE=130,DA=SRTN,DR="212////Y" D ^DIE K DR
 S SRACLR=0
 Q
NOHEP ; no hepatobiliary problems
 S $P(^SRF(SRTN,200),"^",15)=SRAX
 Q
RET W !! K DIR S DIR(0)="E" D ^DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
SURE W ! K DIR S DIR("A")="   Sure you want to delete all "_SRCAT_" information ? ",DIR("B")="NO",DIR(0)="YA" D ^DIR K DIR S SRYN=Y I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
