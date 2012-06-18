ABME5TOO ; IHS/ASDST/DMJ - 837 TOO Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Tooth Identification
 ;
 ;EP - START HERE
 K ABMREC("TOO"),ABMR("TOO")
 S ABME("RTYPE")="TOO"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:40 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("TOO"))'="" S ABMREC("TOO")=ABMREC("TOO")_"*"
 .S ABMREC("TOO")=$G(ABMREC("TOO"))_ABMR("TOO",I)
 Q
10 ;segment
 S ABMR("TOO",10)="TOO"
 Q
20 ;TOO01 - Code List Qualifier Code
 S ABMR("TOO",20)="JP"
 Q
30 ;TOO02 - Tooth Number
 N I
 S I=$P(ABMRV(ABMI,ABMJ,ABMK),U,23)
 S ABMR("TOO",30)=$G(^ADEOPS(+I,88))
 Q
40 ;TOO03 - Tooth Surface
 N I,J
 S I=$P(ABMRV(ABMI,ABMJ,ABMK),U,24)
 I I="" S ABMR("TOO",40)="" Q
 F J=1:1:$L(I) D
 .S $P(ABMR("TOO",40),":",J)=$E(I,J)
 Q
