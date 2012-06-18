SROVER3 ;BIR/ADM - Case Coding and Verification ; [ 09/22/99  12:23 AM ]
 ;;3.0; Surgery ;**86,88**;24 Jun 93
 S SROVER=1,SRAO(1)=26,SRAO(2)=27,SRAO(3)="",SRAO(4)=$S(SRNON:33,1:34),SRAO(5)=66,SRAO(6)=""
ASK W ! K DIR S DIR("A")="Select Information to Edit: ",DIR(0)="FOA",DIR("?",1)="Enter the number corresponding to the information you want to update.  You may"
 S DIR("?",2)="enter 'ALL' to update all the information displayed on this screen, or a",DIR("?")="range of numbers separated by a ':' to update more than one item." D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
 I X="" S SREDIT=1 Q
 S:$E(X)="a" X="A" I '$D(SRAO(X)),(X'?.N1":".N),($E(X)'="A") D HELP Q:SRSOUT  G ASK
 I $E(X)="A" S X="1:6"
 I X?.N1":".N S Y=$E(X),Z=$P(X,":",2) I Y<1!(Z>6)!(Y>Z) D HELP Q:SRSOUT  G ASK
 D HDR^SROVER2 I X?.N1":".N D RANGE Q
 S EMILY=X D ONE Q
 Q
HELP W !!,"Enter the number corresponding to the information you want to update.  You may",!,"enter 'ALL' to update all the information displayed on this screen, or a"
 W !,"range of numbers separated by a ':' to update more than one item."
 Q
PRESS W ! K DIR S DIR("A")="Press RETURN to continue ",DIR(0)="FOA" D ^DIR K DIR
 Q
RANGE ; range of numbers
 S SHEMP=$P(X,":"),CURLEY=$P(X,":",2) F EMILY=SHEMP:1:CURLEY Q:SRSOUT  W ! D ONE
 Q
ONE ; edit one item
 I EMILY=3 D POTH Q
 I EMILY=6 D DOTH Q
 W ! K DR,DIE,DA S DIE=130,DA=SRTN,DR=SRAO(EMILY)_"T" D ^DIE K DR,DIE I $D(Y) S SRSOUT=1
 Q
POTH W !,"Other Procedures:",!
 N SRSHT K SRSEL S CNT=1,OTH=0 F  S OTH=$O(^SRF(SRTN,13,OTH)) Q:'OTH!(SRSOUT)  D
 .S OTHER=$P(^SRF(SRTN,13,OTH,0),"^"),X=$P($G(^SRF(SRTN,13,OTH,2)),"^"),CPT="NOT ENTERED",CPT1=""
 .I X S CPT1=X,Y=$$CPT^ICPTCOD(X),SRCPT=$P(Y,"^",2),SRSHT=$P(Y,"^",3),Y=SRCPT,SRDA=OTH D SSOTH^SROCPT S SRCPT=Y,CPT=SRCPT_"  "_SRSHT
 .W !,CNT_". "_OTHER,!,?6,"CPT Code: "_CPT S SRSEL(CNT)=OTH_"^"_OTHER_"^CPT Code: "_CPT_"^"_CPT1
 .S CNT=CNT+1
 W !,CNT_". Enter NEW Other Procedure",! K DIR S DIR("A")="Enter selection",DIR(0)="NO^1:"_CNT D ^DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
 Q:'Y  S SRDA=Y W !! I SRDA<CNT D  G PH
 .W ?3,$P(SRSEL(SRDA),"^",2),!,?6,$P(SRSEL(SRDA),"^",3)
 .S OTH=$P(SRSEL(SRDA),"^") K SRDES S CPT1=$P(SRSEL(SRDA),"^",4),X=$$CPTD^ICPTCOD(CPT1,"SRDES") I $O(SRDES(0)) F I=1:1:X W !,?6,SRDES(I)
 .K DA,DIE,DIR,DR W ! S DA=$P(SRSEL(SRDA),"^"),DA(1)=SRTN,DIE="^SRF(SRTN,13,",DR=".01;3" D ^DIE K DA,DIE,DR Q:$D(Y)  D PRESS
 K DIR S DIR("A")="Enter new OTHER PROCEDURE",DIR(0)="130.16,.01" D ^DIR K DIR S SRNEW=Y I $D(DTOUT)!$D(DUOUT)!(Y="") G PH
 K DD,DO S DIC="^SRF(SRTN,13,",X=SRNEW,DIC(0)="L",DIC("P")=$P(^DD(130,.42,0),"^",2) D FILE^DICN K DIC,DD,DO I +Y<0 Q
 K DA,DIE,DIR,DR S DA=+Y,DA(1)=SRTN,DIE="^SRF(SRTN,13,",DR="3" D ^DIE K DA,DIE,DR Q:$D(Y)  D PRESS
PH D HDR^SROVER2 D POTH
 Q
DOTH W !,"Other Postop Diagnosis:",!
 K SRSEL S CNT=1,OTH=0 F  S OTH=$O(^SRF(SRTN,15,OTH)) Q:'OTH!(SRSOUT)  D
 .S OTHER=$P(^SRF(SRTN,15,OTH,0),"^"),X=$P($G(^SRF(SRTN,15,OTH,0)),"^",3),SRDIAG="NOT ENTERED"
 .I X S Y=^ICD9(X,0),SRNUM=$P(Y,"^"),SRDES=$P(Y,"^",3),SRDIAG=SRNUM_"  "_SRDES
 .W !,CNT_". "_OTHER,!,?6,"ICD9 Code: "_SRDIAG S SRSEL(CNT)=OTH_"^"_OTHER_"^ICD9 Code: "_SRDIAG
 .S CNT=CNT+1
 W !,CNT_". Enter NEW Other Postop Diagnosis",! K DIR S DIR("A")="Enter selection",DIR(0)="NO^1:"_CNT D ^DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
 Q:'Y  S SRDA=Y W !! I SRDA<CNT D  G DH
 .W ?3,$P(SRSEL(SRDA),"^",2),!,?6,$P(SRSEL(SRDA),"^",3)
 .K DA,DIE,DIR,DR W ! S DA=$P(SRSEL(SRDA),"^"),DA(1)=SRTN,DIE="^SRF(SRTN,15,",DR=".01;3" D ^DIE K DA,DIE,DR
 K DIR S DIR("A")="Enter new OTHER POSTOP DIAGNOSIS",DIR(0)="130.18,.01" D ^DIR K DIR S SRNEW=Y I $D(DTOUT)!$D(DUOUT)!(Y="") G DH
 S DIR(0)="130.18,3" D ^DIR K DIR S SRCODE=$P(Y,"^") I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
 S SRCODE=Y K DD,DO S DIC="^SRF(SRTN,15,",X=SRNEW,DIC(0)="L",DIC("DR")="3////"_SRCODE,DIC("P")=$P(^DD(130,.74,0),"^",2) D FILE^DICN K DA,DD,DIC,DO,DR
DH D HDR^SROVER2 D DOTH
 Q
