ABME8ST ; IHS/ASDST/DMJ - 837 ST Segment (Transaction Set Header) ;    
 ;;2.6;IHS 3P BILLING SYSTEM;**8**;NOV 12, 2009
 ;Original;DMJ;07/08/96 4:53 PM Created routine
 ;
START ;START HERE
 K ABMREC("ST"),ABMR("ST")
 S ABMSTOT=1
 S ABME("RTYPE")="ST"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:30 D
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
 ;S ABMR("ST",30)="0001"  ;abm*2.6*8
 S ABMR("ST",30)=$$FMT^ABMERUTL(ABMER("CNT"),"4NR")  ;abm*2.6*8
 Q
