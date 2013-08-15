BCHEGR2 ; IHS/CMI/LAB - GROUP DEFINTION ENTRY OF PATIENTS ; 
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
 ;
GETPAT ;EP
 W !
 ;W:$D(IOF) @IOF
 S (BCHPT,BCHPTT)=""
 W !!?15,"******   P A T I E N T   I N F O R M A T I O N   ******",!!
 W !,"If this encounter involved a particular patient, please enter the patient's",!,"chart # or name now.  If this is not a single patient encounter,",!,"but a group encounter, simply HIT the RETURN key to continue.",!
 W !,"Please enter the patient information now.",!
 S DFN=""
 S DIR(0)="FO^1:30",DIR("A")="Enter PATIENT NAME or CHART #"
 S DIR("?",1)="     To find a patient, you can enter the patient's chart number;"
 S DIR("?",2)="     lastname,firstname; SSN; or DOB."
 S DIR("?",3)=" "
 S DIR("?",4)="     If the patient cannot be found in the Patient Registration"
 S DIR("?",5)="     database and you would like to capture demographic information"
 S DIR("?",6)="     for this patient into the CHR database, answer NO when asked"
 S DIR("?",7)="     if you would like to try another lookup.  You will then be"
 S DIR("?",8)="     given the opportunity to capture the patient's demographic"
 S DIR("?",9)="     data on the following screen."
 S DIR("?",10)=""
 S DIR("?",11)="     Registered patient demographic data can only be edit via the"
 S DIR("?")="     Patient Registration system."
 ;W !,"So far you have entered ",BCHHIT," patient records out of a total of ",BCHNUM,".",!
 ;I BCHHIT W "You have entered records for: " D  W !!
 ;.S X=0 F  S X=$O(^BCHGROUP(BCHFID,21,X)) Q:X'=+X  W !?5,$P($G(^BCHR(X,11)),U)
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No patient entered!! - Required",! G GETPAT
 I $D(DIRUT) W !,"No patient entered!! - Required." S BCHQUIT=1 Q
 S (X,BCHNAME)=Y,DIC="^AUPNPAT(",DIC(0)="MQE" D ^DIC K DIC
 I Y=-1 D NOREG Q
 W !?25,"Ok" S %=1 D YN^DICN I %'=1 W !!,"Try again.",! G GETPAT
 S BCHPT=+Y
 S BCHPTT="R"
 Q
 ;
NOREG ;
 K BCHAGAIN
 W !,"That patient cannot be found in the Registration database."
 W ! S DIR(0)="Y",DIR("A")="Do you want to try to lookup the patient in registration again",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"Exiting..." S BCHQUIT=1 Q
 I Y G GETPAT
 W !!,"Please select a patient from the Non-Registered Patient Database",!,"or enter a new Non-Registered Patient.",!
 S DIC="^BCHRPAT(",DIC(0)="AEMQL" D ^DIC K DIC
 I Y=-1 W !!,"A patient is Required" G GETPAT
 S BCHNRPAT=+Y,BCHPT=+Y,BCHPTT="N"
 I $P(Y,U,3) D  I 1
 .W !!,"Please review and update if necessary this non-registered patient's data:"
 .S DIE="^BCHRPAT(",DR="[BCH EDIT NON REG PT]",DA=BCHNRPAT D ^DIE K DA,DIE,DR
 E  D
 .W !!,"You now have the opportunity to update this patient's demographic data,"
 .W !,"(DOB, Gender, Community of Residene, Tribe)",!
 .S DIR(0)="Y",DIR("A")="Do you want to update this patient's demographic information?",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I 'Y Q
 .I $D(DIRUT) Q
 .S DIE="^BCHRPAT(",DR="[BCH EDIT NON REG PT]",DA=BCHNRPAT D ^DIE K DA,DIE,DR
 Q
