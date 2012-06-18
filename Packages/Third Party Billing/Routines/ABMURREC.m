ABMURREC ; IHS/SD/SDR - 3PB/UFMS Resend transaction (bill) Option   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; New routine - v2.5 p12 SDD item 4.9.2.5
 Q
SEL W !!
 K DIC
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="QZEAM"
 S ABMY=$G(ABMY)+1
 S ABM("E")=$E(ABMY,$L(ABMY))
 S DIC("A")="Select "_ABMY_$S(ABMY>3&(ABMY<21):"th",ABM("E")=1:"st",ABM("E")=2:"nd",ABM("E")=3:"rd",1:"th")_" BILL to Re-Send: "
 S DIC("S")="I $P(^(0),U)'=+^(0),""ABTCP""[$P(^(0),""^"",4)"
 D BENT^ABMDBDIC
 G XIT:$D(DUOUT)!$D(DTOUT)
 I '$G(ABMP("BDFN")) G QUE:ABMY>1,XIT
 D CKMULT
 I '$G(ABMP("BDFN")) S ABMY=ABMY-1 G SEL
 S ABMY(ABMP("BDFN"))=""
 G SEL
 Q
XIT ;
 D WTOT^ABMDFUTL:$G(ABMY("TOT"))
 K ABMP,ABMY,DIQ
 Q
CKMULT ; check 69 mult. if bill has been transmitted all ready (msg/don't send if not)
 S ABMTFLG=$$TRANSMIT^ABMUEAPI(DUZ(2),+Y)
 I ABMTFLG=0 D
 .W !!?3,"This bill has not been transmitted before so it can't be resent!"
 .W !?3,"Please select another bill for retransmission."
 .S ABMPINS=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,8)
 .S ABMPITYP=$P($G(^AUTNINS(ABMPINS,2)),U)
 .I ABMPITYP="I"!(ABMPITYP="T") W !!?3,"Also note Beneficiary/Third Party Liability claims will NOT be sent to UFMS."
 .K ABMP("BDFN"),ABMPINS,ABMPITYP
 Q
QUE ; Que for resending in UFMS Cashiering Sessions file
 I $D(ABMY) W !!,"The following bills have been requeued in your session:"
 S ABM=0
 F  S ABM=$O(ABMY(ABM)) Q:+ABM=0  D
 .D REQBILL^ABMUCUTL(ABM)
 .I Y>0 W !?5,$P(Y,U,2)
 S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q
