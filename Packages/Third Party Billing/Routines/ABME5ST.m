ABME5ST ; IHS/ASDST/DMJ - 837 ST Segment (Transaction Set Header) ;    
 ;;2.6;IHS Third Party Billing System;**6,8**;NOV 12, 2009
 ;Original;DMJ;07/08/96
 ;
START ;START HERE
 K ABMREC("ST"),ABMR("ST")
 S ABMSTOT=1
 S ABME("RTYPE")="ST"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:40 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("ST"))'="" S ABMREC("ST")=ABMREC("ST")_"*"
 .S ABMREC("ST")=$G(ABMREC("ST"))_ABMR("ST",I)
 Q
10 ;segment
 S ABMR("ST",10)="ST"
 Q
20 ;ST01 - Transaction Set Identifier Code
 S ABMR("ST",20)=837
 Q
30 ;ST02 - Transaction Set Control Number
 S ABMR("ST",30)=$$FMT^ABMERUTL(ABMER("CNT"),"4NR")
 Q
40 ;ST03 - Implementation Convention Reference
 ;S ABMR("ST",40)="005010X222A1"  ;abm*2.6*8 5010
 S:ABMP("EXP")=32 ABMR("ST",40)="005010X222A1"  ;abm*2.6*8 5010
 S:ABMP("EXP")=31 ABMR("ST",40)="005010X223A2"  ;abm*2.6*8 5010
 S:ABMP("EXP")=33 ABMR("ST",40)="005010X224A2"  ;abm*2.6*8 5010
 Q
