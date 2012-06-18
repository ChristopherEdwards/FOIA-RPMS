ABME8SE ; IHS/ASDST/DMJ - 837 SE Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;**8**;NOV 12, 2009
 ;Transaction Set Header
 ;
START ;START HERE
 K ABMREC("SE"),ABMR("SE")
 S ABME("RTYPE")="SE"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:30 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("SE"))'="" S ABMREC("SE")=ABMREC("SE")_"*"
 .S ABMREC("SE")=$G(ABMREC("SE"))_ABMR("SE",I)
 Q
10 ;segment
 S ABMR("SE",10)="SE"
 Q
20 ;SE01 - Number of Included Segments
 S ABMR("SE",20)=ABMSTOT
 Q
30 ;SE02 - Transaction Set Control Number
 ;S ABMR("SE",30)="0001"  ;abm*2.6*8
 S ABMR("SE",30)=$$FMT^ABMERUTL(ABMER("CNT"),"4NR")  ;abm*2.6*8
 Q
