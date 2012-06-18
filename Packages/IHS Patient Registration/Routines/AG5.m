AG5 ; IHS/ASDS/EFG - ENTER MEDICAID DATA ;    
 ;;7.1;PATIENT REGISTRATION;**2**;JAN 31, 2007
 ;
L1 I AGOPT(4)'="Y" G ^AG6
 I $D(^AUPNMCD("AB",DFN)) D  Q
 . W !!,"Any more MEDICAID COVERAGE? (Y/N)  NO// "
 . S AG("DFLT")="YES"
 . G L2
 S AG("DFLT")="NO"
 W !!,"Does this patient have MEDICAID COVERAGE? (Y/N)  NO// "
L2 D READ^AG
 S AG("LT")=$S($E(Y)="Y":"YES",1:"NO")
 ;TESTING USE OF EDIT SCREEN FOR ADDING INSURANCE TO NEW PATIENT 5/13/2005
 I $G(^AGFAC(DUZ(2),"NEWADDINS")) I AG("LT")="YES" S AGPAT=$P($G(^DPT(DFN,0)),U) S AGXTERN=1 D EN^AGEDMCD("","",1,"",XQY0) K AGXTERN G:$G(NEWENTRY)=0 ^AG6 G L1
 I $G(^AGFAC(DUZ(2),"NEWADDINS")),$D(DUOUT) G DUOUT^AG4
 I $G(^AGFAC(DUZ(2),"NEWADDINS")),($G(AG("LT"))="NO") G ^AG6
 ;TESTING
 Q:$D(DTOUT)!$D(DFOUT)
 G DUOUT^AG4:$D(DUOUT)
 G STATE:Y?1"Y".E,END:Y?1"N".E!$D(DLOUT)
 D YN^AG
 G L1
ADDNEW ;EP - Add/Edit MediCAID Client.
STATE ;EP - STATE LOOP
 W !!,"Enter the MEDICAID STATE: "
 D READ^AG
 ;I $D(DUOUT)!$D(DFOUT)!$D(DLOUT)!$D(DTOUT)!$D(DQOUT)!$D(DIRUT)!(Y=" ") W !,"This is a required field." G STATE
 I $D(DUOUT)!$D(DFOUT)!$D(DLOUT)!$D(DTOUT)!(Y=" ") W !,"This is a required field." G STATE  ;AG*7.1*2 PROBLEM REPORTED DURING ALPHA TESTING
 I $D(DQOUT) D
 . S AG("ST")=0
 . W !!,"Enter the Medicaid account state."
 . W:$D(^AUPNMCD("AB",DFN)) "  The following are on file:"
 . F AGZ("I")=1:1 S AG("ST")=$O(^AUPNMCD("AB",DFN,AG("ST"))) G:AG("ST")="" STATE W !,$P(^DIC(5,AG("ST"),0),U)
 S X=Y
 S DIC=5
 S DIC(0)="QEM"
 D ^DIC
 G STATE:+Y<1
 S AG("STATE")=+Y
 I $D(AG("STPTR")) S $P(^AUPNMCD(AGELPTR,0),U,4)=+Y
 Q:$D(AG("STPTR"))
NUMB W !!,"Enter the MEDICAID NUMBER: "
 D READ^AG
 I $D(DLOUT) W !,"This is a Required field" G NUMB
 I $D(DUOUT)!$D(DTOUT)!$D(DFOUT) W !,"This is a Required field" G NUMB  ;AG*7.1*2 REPORTED DURING ALPHA
 G ^AGED4A:$D(DUOUT)!$D(DTOUT)!$D(DFOUT)
 I $D(DQOUT) D
 .S I=""
 . F AGZ("I")=1:1 S I=$O(^AUPNMCD("AB",DFN,AG("STATE"),I)) Q:I=""  W !,I
 S (X,AG("NUM"))=Y
 X $P(^DD(9000004,.03,0),U,5,99) I '$D(X) W !,^(3) G NUMB
L5 ;
 LOCK ^AUPNMCD(0)
 S (D,DA)=$P(^AUPNMCD(0),"^",3)
 F AGZ("I")=1:1 S D=$O(^AUPNMCD(D)) Q:D=""!(D]"@")  S DA=D
 K D
 S DA=DA+1
 S ^AUPNMCD(DA,0)=DFN_U_$O(^AUTNINS("B","MEDICAID",0))
 S ^AUPNMCD("B",DFN,DA)=""
 S $P(^AUPNMCD(0),U,3)=DA
 S $P(^AUPNMCD(0),U,4)=$P(^AUPNMCD(0),U,4)+1
 LOCK
 S AG("MCD")=DA
 S DIE="^AUPNMCD("
 S DR=".03///"_AG("NUM")_";.04///"_$P(^DIC(5,AG("STATE"),0),U)
 D ^DIE
 S AGELPTR=DA
 S ADDCHK=""
L6 G MCNM:'$D(^DD(9000004,.05)) W !!,"Enter the NAME OF THE INSURED person.",!,"(Enter SAME if the PATIENT is the primary insured person.)",!!,"? " W:$P(^AUPNMCD(AG("MCD"),0),U,5)]"" " ",$P(^AUPNMCD(AG("MCD"),0),U,5),"// " D READ^AG
 I $D(DQOUT) W !!,"Enter the name of the person in whose name the main account is carried.",!,"The name must be in the same format as the patient names.",!!,"If the patient is the primary insured person, enter SAME.",!! G L6
 G REL:$D(DLOUT)&($P(^AUPNMCD(AG("MCD"),0),U,5)]""),L6:Y="" I Y="SAME" D SAME G L6:$P(^AUPNMCD(AG("MCD"),0),U,5)="" G MCNM
 S DIE("NO^")="",DR=".05///"_Y,DA=AG("MCD"),DIE="^AUPNMCD(" D ^DIE G L6:$P(^AUPNMCD(AG("MCD"),0),U,5)=""
REL ;
 S DIC="^AUTTRLSH("
 S DIC(0)="QAZEM"
 S DIC("A")="Enter PATIENT'S RELATIONSHIP to the insured: "
 W !
 D ^DIC
 G REL:+Y<1
 S DA=AG("MCD")
 S $P(^AUPNMCD(DA,0),U,6)=+Y
 K DIC("S"),DIC("A")
SEX W !
 S DIE="^AUPNMCD("
 S DA=AG("MCD")
 S DR=.07
 S DIE("NO^")=""
 D ^DIE
MCNM ;
 I $P($G(^AUPNMCD(AG("MCD"),21)),U)="" D
 . S DR=2101
 . D ^DIE
PCP W !
 S DIE="^AUPNMCD("
 S DA=AG("MCD")
 S DR=.14
 D ^DIE
GROUP W !
 S DIE="^AUPNMCD("
 S DA=AG("MCD")
 S DR=.17
 D ^DIE
CC W !
 S DIE="^AUPNMCD("
 S DA=AG("MCD")
 S DR=.15
 D ^DIE
CCD W !
 S DIE="^AUPNMCD("
 S DA=AG("MCD")
 S DR=.16
 D ^DIE
 I '$D(^AUPNMCD(AG("MCD"),21)) G MCDB
 D:$P(^AUPNMCD(AG("MCD"),21),U)]"" SETOTHER G MCDB
SETOTHER ;
 Q
MCDB ;
 I $P($G(^AUPNMCD(AG("MCD"),21)),U,2)="" D
 . S DR=2102
 . D ^DIE
 . W !
 ;
 K DIC("DR"),DR
 S DIE("NO^")=""
 S DR="1101R",DIE="^AUPNMCD(",DA=AG("MCD")
 D ^DIE
 D:$D(AG("EDIT")) UPDATE^AGED5
 I '$D(AG("EDIT")) K DR S DR=".08///"_DT,DA=AG("MCD"),DIE="^AUPNMCD(" D ^DIE
 K DR
 W !
 S DR=".11;.12"
 D ^DIE
END Q:$D(AG("EDIT"))
 K AG G ^AG6
SAME S DR=".05///"_$P(^DPT(DFN,0),U)
 S DIE="^AUPNMCD("
 D ^DIE
 S DR=".07///"_$P(^DPT(DFN,0),U,2)_";.06///SELF"
 D ^DIE
 S DR="2101///"_$P(^DPT(DFN,0),U)
 D ^DIE
 S DR="2102///"_$P($G(^DPT(DFN,0)),U,3)
 D ^DIE
 Q
DUOUT ;EP
 G L1:AGOPT(4)="Y",DUOUT^AG4
