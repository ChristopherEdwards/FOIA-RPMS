ABME5CR7 ; IHS/ASDST/DMJ - 837 CR7 Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Transaction Set Header
 ;
START ;START HERE
 K ABMREC("CR7"),ABMR("CR7")
 S ABME("RTYPE")="CR7"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:40 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("CR7"))'="" S ABMREC("CR7")=ABMREC("CR7")_"*"
 .S ABMREC("CR7")=$G(ABMREC("CR7"))_ABMR("CR7",I)
 Q
10 ;segment
 S ABMR("CR7",10)="CR7"
 Q
20 ;CR701 - Discipline Type Code
 S ABMR("CR7",20)=""
 Q
30 ;CR702 - Number
 S ABMR("CR7",30)=""
 Q
40 ;CR703 - Number
 S ABMR("CR7",40)=""
 Q
