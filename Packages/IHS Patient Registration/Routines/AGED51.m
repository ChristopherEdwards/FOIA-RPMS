AGED51 ; IHS/ASDS/EFG - PAGE 5 CONT'D ;
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
EDIT ;EP
 ;edit Medicaid #
 S DIR(0)="9000004,.03"
 S DIR("B")=$G(AG("MNUM"))
 D ^DIR
 K DIR
 G VAR^AGED5:$D(DTOUT)!(Y="^")!(Y="^^")!(Y="/.,")!(Y="^")
 I '$D(X) W *7 G VAR^AGED5
EDIT0 G EDIT1:(X=$G(AG("MNUM")))
 S DR=".03///"_X
 S DA=AG("MCD")
 S DIE="^AUPNMCD("
 D ^DIE
EDIT1 ;
 K DIR,DFOUT,DUOUT,DQOUT,DLOUT,DTOUT
 G DATES:'$D(^DD(9000004,.05)) W !!,"Enter the NAME OF THE INSURED person.",!,"(Enter SAME if the PATIENT is the primary insured person.)",!
 S DIR("B")=$P(^AUPNMCD(AG("MCD"),0),U,5)
 S DIR(0)="F"
 D ^DIR
 Q:$D(DTOUT)
 S:Y="/.,"!(Y="^^") DFOUT=""
 S:Y="" DLOUT=""
 S:Y="^" (DUOUT,Y)=""
 S:Y?1"?".E!(Y["^") (DQOUT,Y)=""
 G QUES3:$D(DQOUT),L34:$D(DLOUT)&($P(^AUPNMCD(AG("MCD"),0),U,5)]""),EDIT1:Y="" I Y="SAME" D SAME G EDIT1:$P(^AUPNMCD(AG("MCD"),0),U,5)="",DATES
 S DIE("NO^")=""
 S DR=".05///"_Y
 S DA=AG("MCD"),DIE="^AUPNMCD("
 D ^DIE
 G EDIT1:$P(^AUPNMCD(AG("MCD"),0),U,5)=""
L34 ;
 S DIC="^AUTTRLSH("
 S DIC(0)="QAZEM"
 S DIC("A")="Enter PATIENT'S RELATIONSHIP to the insured: "
 K DIC("B")
 S AGREL=+$P(^AUPNMCD(DA,0),U,6)
 I AGREL'=0,$D(^AUTTRLSH(AGREL,0)) S DIC("B")=$P(^AUTTRLSH(AGREL,0),U)
 K AGREL
 W !
 D ^DIC
 G EDIT1:$D(DUOUT),L34:+Y<1
 S DA=AG("MCD")
 S $P(^AUPNMCD(DA,0),U,6)=+Y
 K DIC
SEX W !
 S DIE="^AUPNMCD("
 S DA=AGELPTR
 S DR=.07,DIE("NO^")=""
 D ^DIE
DATES D DATES1
 D PCP
 D CCOPY
MCDNM W !
 S DIE="^AUPNMCD("
 S DA=AG("MCD")
 S DR=2101
 D ^DIE
 I '$D(^AUPNMCD(AG("MCD"),21)) G MCDDB
 D:$P(^AUPNMCD(AG("MCD"),21),U)]"" SETOTHER G MCDDB
SETOTHER ;
 Q
 S DIE="^DPT("
 S DA=DFN
 S DR="1///"_$P(^AUPNMCD(AG("MCD"),21),U)
 S DR(2,2.01)=.01
 D ^DIE
 Q
MCDDB W !
 S DIE="^AUPNMCD("
 S DA=AG("MCD")
 S DR=2102
 D ^DIE
 S DR=".11;.12"
 D ^DIE
 G VAR^AGED5
QUES3 W !!
 W "Enter the name of the person in whose name the main account is carried."
 W !,"The name must be in the same format as the patient names.",!!
 W "If the patient is the primary insured person, enter SAME.",!!
 G EDIT1
SAME S DA=AG("MCD")
 S DR=".05///"_$P(^DPT(DFN,0),U)
 S DIE="^AUPNMCD("
 D ^DIE
 S DR=".07///"_$P(^DPT(DFN,0),U,2)_";.06///SELF"
 D ^DIE
 Q
DATES1 ;
 KILL DIE("NO^")
 NEW AGBILL,AGDA,DA,DIC,DIE,DR
 S DIC="^AUPNMCD("_AG("MCD")_",11,"
 S DIC(0)="AEL"
 S DIC("A")="Select ELIG. DATE: "
 S DA(1)=AG("MCD")
 I '$D(^AUPNMCD(AG("MCD"),11)) S DIC("P")=$P(^DD(9000004,1101,0),U,2)
 E  I $P($G(^AUPNMCD(AG("MCD"),11,0)),U,4) S Y=$P(^AUPNMCD(AG("MCD"),11,$O(^AUPNMCD(AG("MCD"),11,0)),0),U,1) I Y D DD^%DT S DIC("B")=Y
 D ^DIC
 Q:+Y<1
 S AGDA=+Y
 S AGBILL=$$USED(DFN,$P(^AUPNMCD(AG("MCD"),0),U,2),7,+Y,AG("MCD"))
 I $L(AGBILL) S X="IORVON;IORVOFF" D ENDR^%ZISS,HELP^XBHELP("USED","AGED51"),KILL^%ZISS Q:'$$DIR^XBDIR("Y","Proceed with edit of Date Record","N")
 W !
 S DA(1)=AG("MCD")
 S DIE="^AUPNMCD("_DA(1)_",11,"
 S DR=".01:.03",DA=AGDA
 D ^DIE,UPDATE^AGED5
 Q
PCP ;
 S DA=AG("MCD")
 S DR=.14
 S DIE="^AUPNMCD("
 D ^DIE
 Q
CCOPY ;
 S DA=AG("MCD")
 S DR=.15
 S DIE="^AUPNMCD("
 D ^DIE
 I X["Y" D
 .S DR=.16
 .S DIE="^AUPNMCD("
 .D ^DIE
 I X["N" D
 .S DR=".16////@"
 .S DIE="^AUPNMCD("
 .D ^DIE
 Q
USED(DFN,AGINSPTR,AGP,AGDA,AGMCDDA) ;EP - Is this Eligibility date record used in a 3P Bill or Claim?
 ;;@;*7
 ;;@;IORVON
 ;;WARNING :
 ;;@;IORVOFF
 ;;          You have selected an Eligibility Date Record that is used
 ;;          by
 ;;@;AGBILL
 ;;          in 3PB. Modifying or deleting this Eligibility
 ;;          Date Record will degrade the integrity of your database
 ;;          and could adversely effect revenue recovery through 3PB!!
 ;;###
 ;
 NEW AGBILL,AGDUZ2,AGUSED,AG13,Y
 S (AGBILL,AGDUZ2,AGUSED)=0
 ;Check all Pt's bills.
 F  S AGDUZ2=$O(^ABMDBILL(AGDUZ2)) Q:'AGDUZ2  D  Q:AGUSED
 . F  S AGBILL=$O(^ABMDBILL(AGDUZ2,"D",DFN,AGBILL)) Q:'AGBILL  D  Q:AGUSED
 .. I $P(^ABMDBILL(AGDUZ2,AGBILL,0),U,4)="X" Q  ;Cancelled.
 .. S AG13=0
 .. F  S AG13=$O(^ABMDBILL(AGDUZ2,AGBILL,13,AG13)) Q:'AG13  D  Q:AGUSED
 ... ;Same multiple?
 ... Q:'($P(^ABMDBILL(AGDUZ2,AGBILL,13,AG13,0),U,AGP)=AGDA)
 ... ;If MCD, same IEN?
 ... I AGP=7,'($P(^ABMDBILL(AGDUZ2,AGBILL,13,AG13,0),U,6)=AGMCDDA) Q
 ... S AGUSED=$P(^ABMDBILL(AGDUZ2,AGBILL,0),U)_" ("_$P(^DIC(4,AGDUZ2,0),U)_")" ; Bill number (Site).
 ...Q
 ..Q
 .Q
 I AGUSED Q "Bill # "_AGUSED
 ;
 S (AGBILL,AGDUZ2,AGUSED)=0
 ;Check all Pt's claims.
 F  S AGDUZ2=$O(^ABMDCLM(AGDUZ2)) Q:'AGDUZ2  D  Q:AGUSED
 . F  S AGBILL=$O(^ABMDCLM(AGDUZ2,"B",DFN,AGBILL)) Q:'AGBILL  D  Q:AGUSED
 .. S AG13=0
 .. F  S AG13=$O(^ABMDCLM(AGDUZ2,AGBILL,13,AG13)) Q:'AG13  D  Q:AGUSED
 ... ;Same multiple?
 ... Q:'($P(^ABMDCLM(AGDUZ2,AGBILL,13,AG13,0),U,AGP)=AGDA)
 ... ;If MCD, same IEN?
 ... I AGP=7,'($P(^ABMDCLM(AGDUZ2,AGBILL,13,AG13,0),U,6)=AGMCDDA) Q
 ... S AGUSED=AGBILL_" ("_$P(^DIC(4,AGDUZ2,0),U)_")" ;Claim number (Site).
 ...Q
 ..Q
 .Q
 I AGUSED Q "Claim # "_AGUSED
 Q ""
 ;
 ; MEDICARE MULTIPLE (NJ6,0), [0;4]
 ; RAILROAD MULTIPLE (NJ6,0), [0;5]
 ; MEDICAID ELIG POINTER (*P9000004'), [0;6]
 ; MEDICAID MULTIPLE (NJ4,0), [0;7]
 ; PRIVATE INSURANCE MULTIPLE (NJ6,0), [0;8]
