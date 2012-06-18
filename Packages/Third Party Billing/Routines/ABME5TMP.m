ABME5TMP ; IHS/ASDST/DMJ - 837 TMP Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Transaction Set Header
 ;
START ;START HERE
 K ABMREC("TMP"),ABMR("TMP")
 S ABME("RTYPE")="TMP"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:30 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("TMP"))'="" S ABMREC("TMP")=ABMREC("TMP")_"*"
 .S ABMREC("TMP")=$G(ABMREC("TMP"))_ABMR("TMP",I)
 Q
10 ;segment
 S ABMR("TMP",10)="TMP"
 Q
20 ;TMP01 - Transaction Set Identifier Code
 S ABMR("TMP",20)=""
 Q
30 ;TMP02 - File Sequence & Serial Number
 S ABMR("TMP",30)=""
 Q
