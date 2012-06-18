ABME5LQ ; IHS/SD/SDR - 837 LQ Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Form Identification Code
 ;
START ;START HERE
 K ABMREC("LQ"),ABMR("LQ")
 S ABME("RTYPE")="LQ"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:30 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("LQ"))'="" S ABMREC("LQ")=ABMREC("LQ")_"*"
 .S ABMREC("LQ")=$G(ABMREC("LQ"))_ABMR("LQ",I)
 Q
10 ;segment
 S ABMR("LQ",10)="LQ"
 Q
20 ;LQ01 - Code List Qualifier Code
 S ABMR("LQ",20)=""
 Q
30 ;LQ02 - Industry Code
 S ABMR("LQ",30)=""
 Q
