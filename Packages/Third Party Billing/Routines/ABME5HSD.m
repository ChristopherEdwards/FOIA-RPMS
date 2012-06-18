ABME5HSD ; IHS/ASDST/DMJ - 837 HSD Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Transaction Set Header
 ;
START ;START HERE
 K ABMREC("HSD"),ABMR("HSD")
 S ABME("RTYPE")="HSD"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:90 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("HSD"))'="" S ABMREC("HSD")=ABMREC("HSD")_"*"
 .S ABMREC("HSD")=$G(ABMREC("HSD"))_ABMR("HSD",I)
 Q
10 ;segment
 S ABMR("HSD",10)="HSD"
 Q
20 ;HSD01 - Quantity Qualifier
 S ABMR("HSD",20)=""
 Q
30 ;HSD02 - Quantity
 S ABMR("HSD",30)=""
 Q
40 ;HSD03 - Unit or Basis for Measurement Code
 S ABMR("HSD",40)=""
 Q
50 ;HSD04 - Sample Selection Modulus
 S ABMR("HSD",50)=""
 Q
60 ;HSD05 - Time Period Qualifier
 S ABMR("HSD",60)=""
 Q
70 ;HSD06 - Number of Periods
 S ABMR("HSD",70)=""
 Q
80 ;HSD07 - Ship/Delivery or Calendar Pattern Code
 S ABMR("HSD",80)=""
 Q
90 ;HSD08 - Ship/Delivery Pattern Time Code
 S ABMR("HSD",90)=""
 Q
