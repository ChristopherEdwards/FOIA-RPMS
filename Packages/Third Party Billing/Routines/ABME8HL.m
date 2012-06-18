ABME8HL ; IHS/ASDST/DMJ - 837 HL Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Hierarchical Level
 ;
EP(X,Y) ;EP - START HERE
 ;x=level
 ;y=child code
 K ABMREC("HL"),ABMR("HL")
 S ABMHL=X
 S ABMCHILD=Y
 S ABMHLCNT=+$G(ABMHLCNT)+1
 S ABMHL(ABMHL)=ABMHLCNT
 S ABME("RTYPE")="HL"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:50 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("HL"))'="" S ABMREC("HL")=ABMREC("HL")_"*"
 .S ABMREC("HL")=$G(ABMREC("HL"))_ABMR("HL",I)
 Q
10 ;segment
 S ABMR("HL",10)="HL"
 Q
20 ;HL01 - Hierarchical ID Number
 S ABMR("HL",20)=ABMHLCNT
 Q
30 ;HL02 - Hierarchical Parent ID Number
 S ABMR("HL",30)=$O(ABMHL(ABMHL),-1)
 S ABMR("HL",30)=$G(ABMHL(+ABMR("HL",30)))
 Q
40 ;HL03 - Hierarchical Level Code
 S ABMR("HL",40)=ABMHL
 Q
50 ;HL04 - Hierarchical Child Code
 S ABMR("HL",50)=ABMCHILD
 Q
