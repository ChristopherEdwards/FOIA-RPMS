ABME5SV5 ; IHS/ASDST/DMJ - 837 SV5 Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Transaction Set Header
 ;
EP ;EP
 K ABMREC("SV5"),ABMR("SV5")
 S ABME("RTYPE")="SV5"
 D LOOP
 K ABME
 Q
LOOP ;LOOP HERE
 F I=10:10:80 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("SV5"))'="" S ABMREC("SV5")=ABMREC("SV5")_"*"
 .S ABMREC("SV5")=$G(ABMREC("SV5"))_ABMR("SV5",I)
 Q
10 ;segment
 S ABMR("SV5",10)="SV5"
 Q
20 ;SV501 - Composite Medical Procedure Identifier
 ;SV501-1 Product Service ID Qualifier
 ;SV501-2 Product Service ID (Procedure Code)
 I $P(ABMRV(ABMI,ABMJ,ABMK),U,2)'="" D
 .S ABMR("SV5",20)="HC"
 .S $P(ABMR("SV5",20),":",2)=$P(ABMRV(ABMI,ABMJ,ABMK),U,2)
 Q
30 ;SV502 - Unit or Basis for Measurement Code
 S ABMR("SV5",30)="DA"
 Q
40 ;SV503 - Quantity
 S ABMR("SV5",40)=+$P(ABMRV(ABMI,ABMJ,ABMK),U,33)
 Q
50 ;SV504 - Monetary Amount (DME Rental Price)
 S ABMR("SV5",50)=+$P(ABMRV(ABMI,ABMJ,ABMK),U,34)
 Q
60 ;SV505 - Monetary Amount (DME Purchase Price)
 S ABMR("SV5",60)=+$P(ABMRV(ABMI,ABMJ,ABMK),U,35)
 Q
70 ;SV506 - Frequency Code
 S ABMR("SV5",70)=+$P(ABMRV(ABMI,ABMJ,ABMK),U,36)
 Q
80 ;SV507 - Prognosis Code
 S ABMR("SV5",80)=""
 Q
