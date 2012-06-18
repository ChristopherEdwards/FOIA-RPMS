ABME5LX ; IHS/ASDST/DMJ - 837 LX Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;Transaction Set Header
 ;  
EP ;EP - START HERE
 K ABMREC("LX"),ABMR("LX")
 S ABME("RTYPE")="LX"
 D LOOP
 K ABME
 Q
LOOP ;LOOP HERE
 F I=10:10:20 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("LX"))'="" S ABMREC("LX")=ABMREC("LX")_"*"
 .S ABMREC("LX")=$G(ABMREC("LX"))_ABMR("LX",I)
 Q
10 ;segment
 S ABMR("LX",10)="LX"
 Q
20 ;LX01 - Assigned Number
 S ABMR("LX",20)=$G(ABMLXCNT)
 Q
