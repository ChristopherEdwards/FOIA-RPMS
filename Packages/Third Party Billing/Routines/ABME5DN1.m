ABME5DN1 ; IHS/SD/SDR - 837 DN1 Segment 
 ;;2.6;IHS Third Party Billing System;**11**;NOV 12, 2009;Build 133
 ;Transaction Set Header
 ;
EP ;START HERE
 K ABMREC("DN1"),ABMR("DN1")
 S ABME("RTYPE")="DN1"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:50 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("DN1"))'="" S ABMREC("DN1")=ABMREC("DN1")_"*"
 .S ABMREC("DN1")=$G(ABMREC("DN1"))_ABMR("DN1",I)
 Q
10 ;segment
 S ABMR("DN1",10)="DN1"
 Q
20 ;DN101 - Quantity - Treatment Months Count
 S ABMR("DN1",20)=""
 I $P(ABMB4,U,5)'="" D
 S X1=ABMP("VDT")
 S X2=$P(ABMB4,U,5)
 D ^%DTC
 S ABMR("DN1",20)=(X\30)
 I +$P(ABMB4,U,13)>0 S ABMR("DN1",20)=+$G(ABMR("DN1",20))+$P(ABMB4,U,13)
 Q
30 ;DN102 - Quantity - Treatment Months Remaining Count
 S ABMR("DN1",30)=""
 S ABMR("DN1",30)=$P(ABMB4,U,13)
 Q
40 ;DN103 - Yes/No Conditon or Response Code - Not Used
 S ABMR("DN1",40)=""
 Q
50 ;DN104 - Description - Orthodontic Treatment Indicator
 S ABMR("DN1",50)=""
 Q
