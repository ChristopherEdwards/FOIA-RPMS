BOPSLK ;IHS/ILC/ALG/CIA/PLS - Display Patient Info from BOPSHO;10-Feb-2006 10:34;DU
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
 ;
 N Y,B,E,P,D,F
 S B=$G(^BOP(90355.1,A,"O",0))
 W !,"**********************************************************************"
 W !,"Item: ",A,?18,"D/T Received: ",$$FMTE^XLFDT(B,"2Z"),?52,"Message Type: "
 S B=$G(^BOP(90355.1,A,0)),E=B W $S($P(B,U,4)="RDE":"ORDER",1:$P(B,U,4))
 W !,"D/T of Event: " W $$FMTE^XLFDT($P(B,U,3),"2Z")
 W ?37,"D/T of Message: " W $$FMTE^XLFDT($P(B,U,5),"2Z")
 W !,"D/T Logged for Send: " W $$FMTE^XLFDT($P(B,U),"2Z")
 W ?55,"Facility ID: ",$P(B,U,12)
 W !,"----------------------------------------------------------------------"
 S B=$G(^BOP(90355.1,A,1)) W !,"PT Name: ",$E($P(B,U,3),1,15),?26,"PT HRN: ",$P(B,U,14),?47,"PT ID: ",$P(B,U)
 S B=$G(^BOP(90355.1,A,10)) W !,"PT Class: ",$S($P(B,U)="I":"IN",1:"OUT"),"PATIENT",?23,"Nursing Unit: ",$P(B,U,2),?50,"Room/Bed: ",$P(B,U,3)
 I $P(E,U,4)="ADT" D
 .W !," Short Diagnosis: ",$G(^BOP(90355.1,A,12))
 .S B=$G(^BOP(90355.1,A,9))
 .W !,"PT Height: ",$P(B,U)," (cm)",?25,"PT Weight: ",$P(B,U,2)," (kg)"
 .W !," Allergy: "
 .S B=0 F  S B=$O(^BOP(90355.1,A,11,B)) Q:'B  D
 ..W ?15,$P($G(^BOP(90355.1,A,11,B,0)),U),!
 W !,"----------------------------------------------------------------------"
 I $P(E,U,4)="RDE" D
 .W !,"Order Code: " S B=$G(^BOP(90355.1,A,2))
 .W $P(B,U),?18,"Internal Order #: ",$P(B,U,2),?42,"Order Status: ",$P(B,U,3)
 .W !,"Posting Date: ",$$FMTE^XLFDT($P(B,U,4),"2Z")
 .W ?36,"Q/T Freq: " S B=$G(^BOP(90355.1,A,3)) W $P(B,U)
 .W !,"Q/T Order Start D/T: ",$$FMTE^XLFDT($P(B,U,3),"2Z")
 .W !,"Q/T Order End D/T: ",$$FMTE^XLFDT($P(B,U,4),"2Z")
 .S B=$G(^BOP(90355.1,A,8))
 .W !,"Route: ",$P(B,U)
 .S B=$G(^BOP(90355.1,A,4))
 .W ?40,"Drug #: ",$P(B,U)
 .W !,"Drug Description: ",$P(B,U,2)
 Q
