ABMDRSL1 ; IHS/ASDST/DMJ - Selective Report Parameters-PART 2 ; 
 ;;2.6;IHS Third Party Billing;**1,4,6**;NOV 12, 2009
 ;Original;TMD;07/14/95 12:27 PM
 ;
 ; IHS/SD/SDR - V2.5 P8 - Added code for Cancelling official
 ; IHS/SD/SDR - v2.5 p8 - Added code for pending status (12)
 ; IHS/SD/SDR - v2.5 p13 - NO IM
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4482 - Added claim status prompt
 ; IHS/SD/SDR  - abm*2.6*4 - NOHEAT - fixed report headers for closed/exported dates
 ;
LOC ;EP
 W ! K DIC,ABMY("LOC")
 S DIC="^BAR(90052.05,DUZ(2),"
 S DIC(0)="AEMQ"
 S DIC("A")="Select LOCATION: "
 D ^DIC K DIC
 Q:+Y<1
 S ABMY("LOC")=+Y
 Q
INS ;EP
 K ABMY("TYP"),ABMY("INS")
 W !
 S DIC="^AUTNINS("
 S DIC(0)="QEAM"
 D ^DIC
 Q:+Y<0
 S ABMY("INS")=+Y
 Q
 ;
PAT ;
 K ABMY("TYP"),ABMY("PAT")
 W !
 S DIC="^AUPNPAT("
 S DIC(0)="QEAM"
 D ^DIC
 K AUPNLK("ALL")
 Q:+Y<0
 S ABMY("PAT")=+Y
 Q
 ;
TYP ;EP
 K DIR,ABMY("TYP"),ABMY("INS"),ABMY("PAT")
 S DIR(0)="SO^1:MEDICARE;2:MEDICAID;3:PRIVATE INSURANCE;4:NON-BENEFICIARY PATIENTS;5:BENEFICIARY PATIENTS;6:SPECIFIC INSURER;7:SPECIFIC PATIENT;8:WORKMEN'S COMP;9:PRIVATE + WORKMEN'S COMP;10:CHIP"
 S DIR("A")="Select TYPE of BILLING ENTITY to Display"
 D ^DIR
 K DIR
 Q:$D(DIRUT)!$D(DIROUT)
 S ABMY("TYP")=$S(Y=1:"R",Y=2:"D",Y=3:"PHFM",Y=4:"N",Y=5:"I",Y=8:"W",Y=9:"PHFMW",Y=10:"K",1:Y)
 S ABMY("TYP","NM")=Y(0)
 ;
 I Y'=6,Y'=7 Q  ;Only want specific insurer or patient
 D CK ; Check for date range
 Q:$D(DIRUT)!$D(DIROUT)
 G INS:ABMY("TYP","NM")["INS",PAT:ABMY("TYP","NM")["PAT" ;Y has changed
 Q
 ;
CK I $D(ABMY("DT",2)) Q  ;Already has dates set
 D DT ; Go get date range
 I '$D(ABMY("DT",2)) S DIROUT=1 ; Set quit if date not set
 Q
 ;
STATUS ;EP
 K DIR
 ;S DIR(0)="SO^1:FLAGGED AS BILLABLE;2:IN EDIT MODE;3:BILLED AND UNEDITABLE;4:COMPLETED ALL BILLING;5:ROLLED FROM A/R AND IN EDIT MODE"  ;abm*2.6*1 HEAT4482
 ;I $G(ABM("STA"))="I" S DIR(0)=DIR(0)_";6:INCOMPLETE STATUS;7:ALL",DIR("B")="INCOMPLETE STATUS"  ;abm*2.6*1 HEAT4482
 ;E  S DIR(0)=DIR(0)_";6:ALL"  ;abm*2.6*1 HEAT4482
 ;S DIR(0)="SO^1:FLAGGED AS BILLABLE (includes IN EDIT MODE);1:IN EDIT MODE;3:BILLED AND UNEDITABLE;4:COMPLETED ALL BILLING;5:ROLLED FROM A/R AND IN EDIT MODE;6:ALL"  ;abm*2.6*1 HEAT4482  ;abm*2.6*6 HEAT16168
 S DIR(0)="SO^1:FLAGGED AS BILLABLE (includes IN EDIT MODE);2:IN EDIT MODE;3:BILLED AND UNEDITABLE;4:COMPLETED ALL BILLING;5:ROLLED FROM A/R AND IN EDIT MODE;6:ALL"  ;abm*2.6*1 HEAT4482  ;abm*2.6*6 HEAT16168
 S DIR("A")="Select TYPE of CLAIM STATUS to Display"
 D ^DIR
 K DIR
 Q:$D(DIRUT)!$D(DIROUT)
 S ABM("STA")=$S(Y=1:"F",Y=2:"E",Y=3:"U",Y=4:"C",Y=5:"O",1:"")
 S ABM("STA","NM")=Y(0)
 Q
 ;
DT ;EP
 K DIR,ABMY("DT")
 I $G(ABM("DT"))="C" S Y=4 G DTYP
 ;I $D(ABM("STA")),($G(ABM("STA"))'="X") S Y=2 G DTYP  ;abm*2.6*4 NOHEAT
 I $D(ABM("STA")),($G(ABM("STA"))'="M") S Y=2 G DTYP  ;abm*2.6*4 NOHEAT
 S DIR(0)="SO^1:Approval Date;2:Visit Date"
 G DDIR:$G(ABMP("TYP"))=2
 I $D(ABM("PAY")) S DIR(0)=DIR(0)_";3:Payment Date"
 E  S DIR(0)=DIR(0)_";3:Export Date"
 ;I $G(ABM("STA"))="X" G DTYP2  ;Closed  ;abm*2.6*4 NOHEAT
 I $G(ABM("STA"))="M" G DTYP2  ;Closed  ;abm*2.6*4 NOHEAT
 ;
DDIR ;
 S DIR("A")="Select TYPE of DATE Desired"
 D ^DIR
 Q:$D(DIROUT)!$D(DIRUT)
 I Y=3 S Y=$S(DIR(0)["Pay":5,1:3)
 ;
DTYP ;
 Q:$D(DIRUT)
 S ABMY("DT")=$S(Y=1:"A",Y=2:"V",Y=3:"X",Y=4:"C",1:"P")
 S Y=$S(Y=1:"APPROVAL",Y=2:"VISIT",Y=3:"EXPORT",Y=4:"CANCELLATION",1:"PAYMENT")_" DATE"
 W !!," ============ Entry of ",Y," Range =============",!
 S DIR("A")="Enter STARTING "_Y_" for the Report"
 S DIR(0)="DO^::EP"
 D ^DIR
 G DT:$D(DIRUT)
 S ABMY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING DATE for the Report"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S ABMY("DT",2)=Y
 I ABMY("DT",1)>ABMY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT
 Q
DTYP2 ;
 S DIR(0)="SO^1:Closed Date;2:Visit Date"
 S DIR("A")="Select TYPE of DATE Desired"
 D ^DIR
 Q:$D(DIROUT)!$D(DIRUT)
 ;S ABMY("DT")=$S(Y=1:"X",1:"V")  ;abm*2.6*4 NOHEAT
 S ABMY("DT")=$S(Y=1:"M",1:"V")  ;abm*2.6*4 NOHEAT
 S Y=$S(Y=1:"CLOSED",1:"VISIT")_" DATE"
 W !!," ============ Entry of ",Y," Range =============",!
 S DIR("A")="Enter STARTING "_Y_" for the Report"
 S DIR(0)="DO^::EP"
 D ^DIR
 G DT:$D(DIRUT)
 S ABMY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING DATE for the Report"
 D ^DIR
 K DIR
 G DT:$D(DIRUT)
 S ABMY("DT",2)=Y
 I ABMY("DT",1)>ABMY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DT
 Q
 ;
APPR ;EP
 K ABMY("APPR")
 W !
 S DIC="^VA(200,"
 S DIC(0)="QEAM"
 D ^DIC
 S:+Y>0 ABMY("APPR")=+Y
 Q
 ;
CANC ;EP
 K ABMY("CANC")
 W !
 S DIC="^VA(200,"
 S DIC(0)="QEAM"
 D ^DIC
 S:+Y>0 ABMY("CANC")=+Y
 Q
CLOS ;EP
 K ABMY("CLOS")
 W !
 S DIC="^VA(200,"
 S DIC(0)="QEAM"
 D ^DIC
 S:+Y>0 ABMY("CLOS")=+Y
 Q
 ;
PRV ;EP
 K ABMY("PRV")
 W !
 S DIC="^VA(200,"
 S DIC(0)="QEAM"
 D ^DIC
 S:+Y>0 ABMY("PRV")=+Y
 Q
INC ;EP - choose status updater
 K DIR,DIC,DIE,DR
 S DIC(0)="AEMQ"
 S DIC="^VA(200,"
 D ^DIC
 I +Y<0 S ABMY("STATUS UPDATER")=""
 E  S ABMY("STATUS UPDATER")=+Y
 Q
