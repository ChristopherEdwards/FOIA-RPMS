ABME8MOA ; IHS/ASDST/DMJ - 837 MOA Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Transaction Set Header
 ;
START ;START HERE
 K ABMREC("MOA"),ABMR("MOA")
 S ABME("RTYPE")="MOA"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:100 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("MOA"))'="" S ABMREC("MOA")=ABMREC("MOA")_"*"
 .S ABMREC("MOA")=$G(ABMREC("MOA"))_ABMR("MOA",I)
 Q
10 ;segment
 S ABMR("MOA",10)="MOA"
 Q
20 ;MOA01 - Percent
 S ABMR("MOA",20)=""
 Q
30 ;MOA02 - Monetary Amount
 S ABMR("MOA",30)=""
 Q
40 ;MOA03 - Reference Identification
 S ABMR("MOA",40)=""
 Q
50 ;MOA04 - Reference Identification
 S ABMR("MOA",50)=""
 Q
60 ;MOA05 - Reference Identification
 S ABMR("MOA",60)=""
 Q
70 ;MOA06 - Reference Identification
 S ABMR("MOA",70)=""
 Q
80 ;MOA07 - Reference Identification
 S ABMR("MOA",80)=""
 Q
90 ;MOA08 - Monetary Amount
 S ABMR("MOA",90)=""
 Q
100 ;MOA09 - Monetary Amount
 S ABMR("MOA",100)=""
 Q
