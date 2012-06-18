ABMPSTRD ; IHS/SD/SDR - Re-Print Selected Pt statements ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
START ;
 K ABMY,ABMP
 S ABMP("XMIT")=0
 S ABMY("TOT")="0^0^0"
 W !!,"Re-Print Statements for:"
 K DIR
 S DIR(0)="SO^1:SELECTIVE STATEMENT(S);2:ALL STATEMENTS WITHIN APPROVED DATE RANGE;3:APPROVING OFFICIAL"
 S DIR("A")="Select Desired Option"
 D ^DIR
 K DIR
 G XIT:$D(DIRUT)!$D(DIROUT),SEL:Y=1,DTRANGE:Y=2
 ;
APOFF ; by approving official
 K DIC,X,Y
 S DIC="^VA(200,"
 S DIC(0)="AEM"
 S DIC("A")="Approving Official: "
 D ^DIC
 I Y>0 S ABMY("AOFF",+Y)=""
 I '$O(ABMY("AOFF",0)) W !!,"NO APPROVING OFFICIAL SELECTED!" G START
 ;
DTRANGE ; by date range
 W !
 S DIR("A")="Enter STARTING APPROVAL DATE for the Report"
 S DIR("B")=$$SDT^ABMDUTL(DT)
 S DIR(0)="DO^::EP"
 D ^DIR
 G START:($D(DIRUT)!$D(DIROUT))
 S ABMY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING APPROVAL DATE for the Report"
 D ^DIR
 K DIR
 G DTRANGE:$D(DIRUT)
 S ABMY("DT",2)=Y
 I ABMY("DT",1)>ABMY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! G DTRANGE
 G ZIS
 ;
SEL ; by individual bill
 W !!
 K DIC
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="QZEAM"
 S ABMY=$G(ABMY)+1
 S ABM("E")=$E(ABMY,$L(ABMY))
 S DIC("A")="Select "_ABMY_$S(ABMY>3&(ABMY<21):"th",ABM("E")=1:"st",ABM("E")=2:"nd",ABM("E")=3:"rd",1:"th")_" BILL to Re-Print: "
 S DIC("S")="I $P(^(0),U)'=+^(0),""BTCP""[$P(^(0),""^"",4)"
 D BENT^ABMDBDIC  ;returns ABMP("BDFN")
 G XIT:$D(DUOUT)!$D(DTOUT)
 I '$G(ABMP("BDFN")) G ZIS:ABMY>1,XIT
 I '$G(ABMP("BDFN")) S ABMY=ABMY-1 G SEL
 S ABMP("PDFN")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,5)
 D COVRG^ABMPTSMT
 I $G(ABMISNB)=0 D
 .K DIR
 .S DIR("A",1)="YOU HAVE SELECTED A STATEMENT FOR AN INDIAN BENEFICIARY."
 .S DIR("A")="DO YOU WISH TO CONTINUE PRINTING"
 .S DIR("B")="N"
 .S DIR(0)="Y"
 .D ^DIR
 Q:Y=0  ;don't print it-they are ben
 ; do they want to edit message at bottom of statement?
 W !!
 K DIR,X,Y
 S ABMMSG=$S(+$O(ABML(0))'=0:"Your insurance has been billed",$G(ABMABEN)=1:"Summary of services rendered",1:"First notice of balance due. Please remit payment promptly")
 S DIR("A",1)="This message will print on bottom of statement:"
 S DIR("A",2)=""
 S DIR("A",3)=ABMMSG
 S DIR("A",4)=""
 S DIR("A")="Would you like to edit it?"
 S DIR("B")="N"
 S DIR(0)="Y"
 D ^DIR K DIR
 I +Y>0 D
 .K X,Y
 .S DIR("A")=ABMMSG
 .S DIR(0)="F^0:70"
 .D ^DIR K DIR
 .I '$D(DIROUT),'$D(DUOUT),'$D(DTOUT),'$D(DIRUT) S ABMMSG=$G(X)
 ;
 S ABMY(ABMP("BDFN"))=ABMMSG
 G SEL
 ;
ZIS ;
 W !!?15,"(NOTE: "
 W "Plain Paper needs"
 W " to be loaded in the printer.)"
 W !!
 S %ZIS("A")="Output DEVICE: "
 S %ZIS="PQ"
 D ^%ZIS
 G XIT:POP
 I IO'=IO(0),IOT'="HFS" D  Q
 .D QUE2
 .D HOME^%ZIS
 U IO(0)
 W:'$D(IO("S")) !!,"Printing..."
 U IO
 G ENT
 ;
QUE2 ;
 I IO=IO(0) W !,"Cannot Queue to Screen or Slave Printer!",! G ZIS
 S ZTRTN="TSK^ABMPSTRD"
 S ZTDESC="3P Re-Print of Selective Bill."
 F ABM="ZTRTN","ZTDESC","ABMP(","ABMY(" S ZTSAVE(ABM)=""
 D ^%ZTLOAD
 I $D(ZTSK) W !,"(Job Queued, Task Number: ",ZTSK,")"
 G OUT
 ;
TSK ; Taskman Entry Point
 S ABMP("Q")=""
 ;
ENT ;
 I '$D(ABMY("DT")) D  G OUT
 .S ABMY=0
 .F  S ABMY=$O(ABMY(ABMY)) Q:'ABMY  D
 ..S ABMP("BDFN")=ABMY
 ..D STMTS
 S ABMYDT=$G(ABMY("DT",1))-.5
 F  S ABMYDT=$O(^ABMDBILL(DUZ(2),"AP",ABMYDT)) Q:'ABMYDT!(ABMYDT>ABMY("DT",2))  D
 .S ABMP("BDFN")=0
 .F  S ABMP("BDFN")=$O(^ABMDBILL(DUZ(2),"AP",ABMYDT,ABMP("BDFN"))) Q:'ABMP("BDFN")  D
 ..; Quit if bill status is Reviewed, Approved, or Cancelled
 ..Q:"RAX"[$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,4)
 ..;if approving official selected and not a match
 ..I $D(ABMY("AOFF")),$O(ABMY("AOFF",0))'=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,4) Q
 ..Q:$G(^ABMDCLM(DUZ(2),+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U),0))=""  ;manually created bill
 ..S ABMP("PDFN")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,5)
 ..K ABMISNB,ABMBEN
 ..D COVRG^ABMPTSMT
 ..I $G(ABMBEN)=1 Q  ;don't print statements for bens when batching
 ..I ABMBILLD=1 Q  ;has completed insurer; don't print when batching
 ..I +$O(ABML(0))'=0 S ABMY(ABMP("BDFN"))="Your insurance has been billed"
 ..D STMTS
 G OUT
 ;
STMTS ; Reprint Statements
 K ABMP("PAYED")
 D @("^ABMPTSMT")
 Q
 ;
OUT ;
 D ^%ZISC
 ;
XIT ;
 K ABMP,ABMY,DIQ
 Q
