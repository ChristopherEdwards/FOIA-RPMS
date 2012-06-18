ABME5QTY ; IHS/ASDST/DMJ - 837 QTY Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Transaction Set Header
 ;
EP(X) ;EP
 ;x=qualifier
 K ABMREC("QTY"),ABMR("QTY")
 S ABMEIC=X
 S ABME("RTYPE")="QTY"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:50 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("QTY"))'="" S ABMREC("QTY")=ABMREC("QTY")_"*"
 .S ABMREC("QTY")=$G(ABMREC("QTY"))_ABMR("QTY",I)
 Q
10 ;segment
 S ABMR("QTY",10)="QTY"
 Q
20 ;QTY01 - Quantity Qualifier
 S ABMR("QTY",20)=ABMEIC
 Q
30 ;QTY02 - Quantity
 S ABMR("QTY",30)=""
 I ABMEIC="NA" S ABMR("QTY",30)=$P(ABMB6,"^",6)
 I ABMEIC="CA" S ABMR("QTY",30)=$P(ABMB7,"^",3)
 I ABMEIC="PT" S ABMR("QTY",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,18)
 Q
40 ;QTY03 - Composite Unit of Measure
 S ABMR("QTY",40)=""
 Q:ABMEIC="PT"
 S ABMR("QTY",40)="DA"
 Q
50 ;QTY04 - Free-Form Message
 S ABMR("QTY",50)=""
 Q
