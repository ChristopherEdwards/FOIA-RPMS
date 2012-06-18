ABME5FRM ; IHS/SD/SDR - 837 FRM Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Supporting Documentation
 ;
START ;START HERE
 K ABMREC("FRM"),ABMR("FRM")
 S ABME("RTYPE")="FRM"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:60 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("FRM"))'="" S ABMREC("FRM")=ABMREC("FRM")_"*"
 .S ABMREC("FRM")=$G(ABMREC("FRM"))_ABMR("FRM",I)
 Q
10 ;segment
 S ABMR("FRM",10)="FRM"
 Q
20 ;FRM01 - Assigned Identification
 S ABMR("FRM",20)=""
 Q
30 ;FRM02 - Yes/No Condition or Response Code
 S ABMR("FRM",30)=""
 Q
40 ;FRM03 - Reference Identification
 S ABMR("FRM",40)=""
 Q
50 ;FRM04 - Date
 S ABMR("FRM",50)=""
 Q
60 ;FRM05 - Percent, Decimal Format
 S ABMR("FRM",60)=""
 Q
