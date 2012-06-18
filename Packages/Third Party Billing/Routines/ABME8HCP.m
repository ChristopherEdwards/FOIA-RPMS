ABME8HCP ; IHS/ASDST/DMJ - 837 HCP Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Transaction Set Header
 ;
START ;START HERE
 K ABMREC("HCP"),ABMR("HCP")
 S ABME("RTYPE")="HCP"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:160 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("HCP"))'="" S ABMREC("HCP")=ABMREC("HCP")_"*"
 .S ABMREC("HCP")=$G(ABMREC("HCP"))_ABMR("HCP",I)
 Q
10 ;segment
 S ABMR("HCP",10)="HCP"
 Q
20 ;HCP01 - Pricing Methodology
 S ABMR("HCP",20)=""
 Q
30 ;HCP02 - Monetary Amount
 S ABMR("HCP",30)=""
 Q
40 ;HCP03 - Monetary Amount
 S ABMR("HCP",40)=""
 Q
50 ;HCP04 - Reference Identification
 S ABMR("HCP",50)=""
 Q
60 ;HCP05 - Rate
 S ABMR("HCP",60)=""
 Q
70 ;HCP06 - Reference Identification
 S ABMR("HCP",70)=""
 Q
80 ;HCP07 - Monetary Amount
 S ABMR("HCP",80)=""
 Q
90 ;HCP08 - Product/Service ID
 S ABMR("HCP",90)=""
 Q
100 ;HCP09 - Product/Service ID Qualifier
 S ABMR("HCP",100)=""
 Q
110 ;HCP10 - Product/Service ID
 S ABMR("HCP",110)=""
 Q
120 ;HCP11 - Unit or Basis for Measurement Code
 S ABMR("HCP",120)=""
 Q
130 ;HCP12 - Quantity
 S ABMR("HCP",130)=""
 Q
140 ;HCP13 - Reject Reason Code
 S ABMR("HCP",140)=""
 Q
150 ;HCP14 - Policy Compliance Code
 S ABMR("HCP",150)=""
 Q
160 ;HCP15 - Exception Code
 S ABMR("HCP",160)=""
 Q
