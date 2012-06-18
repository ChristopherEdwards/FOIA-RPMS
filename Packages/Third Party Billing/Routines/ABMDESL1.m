ABMDESL1 ; IHS/ASDST/DMJ - Selective Looping Parameters-PART 2 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM13359
 ;    Added code to select range of patients
 ;
LOC ;EP for selecting location
 W ! K DIC,ABMY("LOC")
 S DIC="^BAR(90052.05,DUZ(2),"
 S DIC(0)="AEQM"
 S DIC("A")="Select LOCATION: "
 D ^DIC K DIC
 Q:+Y<1
 S ABMY("LOC")=+Y
 Q
 ;
TYP ;EP for selecting Billing Entity
 K DIR,ABMY("TYP"),ABMY("INS"),ABMY("PAT")
 S DIR(0)="SO^1:MEDICARE;2:MEDICAID;3:PRIVATE INSURANCE;4:NON-BENEFICIARY PATIENTS;5:BENEFICIARY PATIENTS;6:SPECIFIC INSURER"
 I '$D(ABMY("RNG")) S DIR(0)=DIR(0)_";7:SPECIFIC PATIENT"
 S DIR("A")="Select TYPE of BILLING ENTITY to Display"
 D ^DIR K DIR Q:$D(DIRUT)!$D(DIROUT)
 S ABMY("TYP")=$S(Y=1:"R",Y=2:"D",Y=3:"P",Y=4:"N",Y=5:"I",1:Y),ABMY("TYP","NM")=Y(0)
 G INS:Y=6,PAT:Y=7
 Q
 ;
INS K ABMY("TYP"),ABMY("INS") W ! S DIC="^AUTNINS(",DIC(0)="QEAM" D ^DIC
 Q:+Y<1  S ABMY("INS")=+Y
 Q
 ;
PAT K ABMY("TYP"),ABMY("PAT")
 W ! S DIC="^AUPNPAT(",DIC(0)="QEAM" D ^DIC K AUPNLK("ALL")
 Q:+Y<1  S ABMY("PAT")=+Y
 Q
 ;
DT ;EP for selecting Visit Date Range
 K DIR,ABMY("DT")
 S ABMY("DT")="V"
 S Y="VISIT DATE"
 W !!," ============ Entry of ",Y," Range ============="
 W ! S DIR("A")="Enter STARTING "_Y_" for the Looping",DIR(0)="DO^::E" D ^DIR
 I $D(DIRUT)!$D(DIROUT) K ABMY("DT"),DIR Q
 S ABMY("DT",1)=Y
 W ! S DIR("A")="Enter ENDING DATE for the Looping" D ^DIR K DIR
 I $D(DIRUT)!$D(DIROUT) K ABMY("DT") Q
 S ABMY("DT",2)=Y
 I ABMY("DT",1)>ABMY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT
 Q
 ;
CLN ;EP for selecting CLINIC
 K ABMY("CLN"),DIC W ! S DIC="^DIC(40.7,",DIC(0)="QEAM" D ^DIC
 S:+Y>0 ABMY("CLN")=+Y
 Q
 ;
VTYP ;EP for selecting Visit Type
 K ABMY("VTYP"),DIC W ! S DIC="^ABMDVTYP(",DIC(0)="QEAM" D ^DIC
 S:+Y>0 ABMY("VTYP")=+Y
 Q
 ;
PRV ;EP for selecting Provider
 K ABMY("PRV"),DIC W ! S DIC="^VA(200,",DIC(0)="QEAM" D ^DIC
 S:+Y>0 ABMY("PRV")=+Y
 Q
 ;
ELIG ;EP for selecting Bene Class
 K DIR S DIR(0)="SO^1:INDIAN BENEFICIARY PATIENTS;2:NON-BENEFICIARY PATIENTS"
 S DIR("A")="Select the PATIENT ELIGIBILITY STATUS"
 S DIR("?")="Selection of an Eligibility Status will restrict the report to only those visits in which the patient is of the type designated."
 D ^DIR K DIR Q:$D(DIRUT)
 S ABMY("PTYP")=Y,ABMY("PTYP","NM")=Y(0)
 Q
RANGE ;
 K DIR,ABMY("RNG")
STARTR W !!,"Select RANGE OF PATIENTS to display:"
 W ! S DIR("A")="Start with Patient Name"
 S DIR("?")="Response must be three alpha characters"
 S DIR(0)="F^3:3" D ^DIR
 I $D(DIRUT)!$D(DIROUT) K ABMY("RNG"),DIR Q
 S ABMCK=$$ALPHACK(Y)
 I ABMCK=0 W !!?4,"Must be alpha characters only! (NO numbers, punctuation, etc)" K Y G STARTR
 S ABMY("RNG",1)=$$UPC^ABMERUTL(Y)
ENDR W !
 S DIR(0)="F^3:3"
 S DIR("?")="Response must be three alpha characters"
 S DIR("B")=$G(ABMY("RNG",1))
 S DIR("A")="Go to Patient Name" D ^DIR K DIR
 I $D(DIRUT)!$D(DIROUT) K ABMY("RNG") Q
 S ABMCK=$$ALPHACK(Y)
 I ABMCK=0 W !!?4,"Must be alpha characters only! (NO numbers, punctuaton, etc)" K Y G ENDR
 S ABMY("RNG",2)=$$UPC^ABMERUTL(Y)
 D SEQCK  ;check if start name before go to name
 I '$D(ABMY("RNG")) W !!?4,"Invalid range...please try again!" G RANGE
 Q
ALPHACK(X) ;
 N ABMI,ABMTST,ABMPCE
 N ABMCK
 S ABMCK=1
 S ABMTST=$$UPC^ABMERUTL(X)
 S ABMI=""
 F ABMI=1:1:$L(ABMTST) D
 .S ABMPCE=$E(ABMTST,ABMI)
 .I $A(ABMPCE)<65 S ABMCK=0  ;before A
 .I $A(ABMPCE)>90 S ABMCK=0  ;after Z
 Q ABMCK
SEQCK ;
 K ABMPCE
 F ABMI=1,2 D
 .F ABMJ=1:1:3 D
 ..S ABMPCE(ABMI)=$G(ABMPCE(ABMI))_$A($E(ABMY("RNG",ABMI),ABMJ))
 I ABMPCE(1)>ABMPCE(2) K ABMY("RNG")
 Q
