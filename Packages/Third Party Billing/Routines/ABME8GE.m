ABME8GE ; IHS/ASDST/DMJ - 837 GE Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;**8**;NOV 12, 2009
 ;Functional Group Trailer
 ;
START ;START HERE
 K ABMREC("GE"),ABMR("GE")
 S ABME("RTYPE")="GE"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:30 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("GE"))'="" S ABMREC("GE")=ABMREC("GE")_"*"
 .S ABMREC("GE")=$G(ABMREC("GE"))_ABMR("GE",I)
 Q
10 ;segment
 S ABMR("GE",10)="GE"
 Q
20 ;GE01 - Number of Included Functional Groups
 ;S ABMR("GE",20)=1  ;abm*2.6*8
  S ABMR("GE",20)=ABMER("LAST")  ;abm*2.6*8
  Q
30 ;GE02 - Interchange Contol Number
 S ABMR("GE",30)=$$TCN^ABMERUTL(ABMPXMIT)
 Q
