ABME5MIA ; IHS/ASDST/DMJ - 837 MIA Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
START ;START HERE
 K ABMREC("MIA"),ABMR("MIA")
 S ABME("RTYPE")="MIA"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:250 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("MIA"))'="" S ABMREC("MIA")=ABMREC("MIA")_"*"
 .S ABMREC("MIA")=$G(ABMREC("MIA"))_ABMR("MIA",I)
 Q
10 ;segment
 S ABMR("MIA",10)="MIA"
 Q
20 ;MIA01 - Quantity
 S ABMR("MIA",20)=""
 Q
30 ;MIA02 - Quantity
 S ABMR("MIA",30)=""
 Q
40 ;MIA03 - Quantity
 S ABMR("MIA",40)=""
 Q
50 ;MIA04 - Monetary Amount
 S ABMR("MIA",50)=""
 Q
60 ;MIA05 - Reference Identification
 S ABMR("MIA",60)=""
 Q
70 ;MIA06 - Monetary Amount
 S ABMR("MIA",70)=""
 Q
80 ;MIA07 - Monetary Amount
 S ABMR("MIA",80)=""
 Q
90 ;MIA08 - Monetary Amount
 S ABMR("MIA",90)=""
 Q
100 ;MIA09 - Monetary Amount
 S ABMR("MIA",100)=""
 Q
110 ;MIA10 - Monetary Amount
 S ABMR("MIA",110)=""
 Q
120 ;MIA11 - Monetary Amount
 S ABMR("MIA",120)=""
 Q
130 ;MIA12 - Monetary Amount
 S ABMR("MIA",130)=""
 Q
140 ;MIA13 - Monetary Amount
 S ABMR("MIA",140)=""
 Q
150 ;MIA14 - Monetary Amount
 S ABMR("MIA",150)=""
 Q
160 ;MIA15 - Quantity
 S ABMR("MIA",160)=""
 Q
170 ;MIA16 - Monetary Amount
 S ABMR("MIA",170)=""
 Q
180 ;MIA17 - Monetary Amount
 S ABMR("MIA",180)=""
 Q
190 ;MIA18 - Monetary Amount
 S ABMR("MIA",190)=""
 Q
200 ;MIA19 - Monetary Amount
 S ABMR("MIA",200)=""
 Q
210 ;MIA20 - Reference Identification
 S ABMR("MIA",210)=""
 Q
220 ;MIA21 - Reference Identification
 S ABMR("MIA",220)=""
 Q
230 ;MIA22 - Reference Identification
 S ABMR("MIA",230)=""
 Q
240 ;MIA23 - Reference Identification
 S ABMR("MIA",240)=""
 Q
250 ;MIA24 - Monetary Amount
 S ABMR("MIA",250)=""
 Q
