ABME5CR2 ; IHS/SD/SDR - 837 CR2 Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Transaction Set Header
 ;
EP ;EP - START HERE
 K ABMREC("CR2"),ABMR("CR2")
 S ABME("RTYPE")="CR2"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:130 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("CR2"))'="" S ABMREC("CR2")=ABMREC("CR2")_"*"
 .S ABMREC("CR2")=$G(ABMREC("CR2"))_ABMR("CR2",I)
 Q
10 ;segment
 S ABMR("CR2",10)="CR2"
 Q
20 ;CR201 - Count
 S ABMR("CR2",20)=""
 Q
30 ;CR202 - Quantity
 S ABMR("CR2",30)=""
 Q
40 ;CR203 - Subluxation Level Code
 S ABMR("CR2",40)=""
 Q
50 ;CR204 - Subluxation Level Code
 S ABMR("CR2",50)=""
 Q
60 ;CR205 - Unit or Basis for Measurement Code
 S ABMR("CR2",60)=""
 Q
70 ;CR206 - Quantity
 S ABMR("CR2",70)=""
 Q
80 ;CR207 - Quantity
 S ABMR("CR2",80)=""
 Q
90 ;CR208 - Nature of Condition Code
 S ABMR("CR2",90)=""
 Q
100 ;CR209 - Yes/No Condition or Response Code
 S ABMR("CR2",100)=""
 Q
110 ;CR210 - Description
 S ABMR("CR2",110)=""
 Q
120 ;CR211 - Description
 S ABMR("CR2",120)=""
 Q
130 ;CR212 - Yes/No Condition or Response Code
 S ABMR("CR2",130)=""
 Q
