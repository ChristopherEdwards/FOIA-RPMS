ABME8SVD ; IHS/ASDST/DMJ - 837 SVD Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Transaction Set Header
 ;
START ;START HERE
 K ABMREC("SVD"),ABMR("SVD")
 S ABME("RTYPE")="SVD"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:70 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("SVD"))'="" S ABMREC("SVD")=ABMREC("SVD")_"*"
 .S ABMREC("SVD")=$G(ABMREC("SVD"))_ABMR("SVD",I)
 Q
10 ;segment
 S ABMR("SVD",10)="SVD"
 Q
20 ;SVD01 - Identification Code
 S ABMR("SVD",20)=""
 Q
30 ;SVD02 - Monetary Amount
 S ABMR("SVD",30)=""
 Q
40 ;SVD03 - Composite Medical Procedure Identifier
 S ABMR("SVD",40)=""
 Q
50 ;SVD04 - Product/Service ID
 S ABMR("SVD",50)=""
 Q
60 ;SVD05 - Quantity
 S ABMR("SVD",60)=""
 Q
70 ;SVD06 - Assigned Number
 S ABMR("SVD",70)=""
 Q
