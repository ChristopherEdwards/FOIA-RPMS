ABME5K3 ; IHS/ASDST/DMJ - 837 K3 Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Transaction Set Header
 ;
EP ;EP - START HERE
 K ABMREC("K3"),ABMR("K3")
 S ABME("RTYPE")="K3"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:40 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("K3"))'="" S ABMREC("K3")=ABMREC("K3")_"*"
 .S ABMREC("K3")=$G(ABMREC("K3"))_ABMR("K3",I)
 Q
10 ;segment
 S ABMR("K3",10)="K3"
 Q
20 ;K301 - Fixed Format Information
 S ABMR("K3",20)=""
 S ABMSTR=""
 S ABMPRI=0
 F  S ABMPRI=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABMPRI)) Q:+ABMPRI=0  D
 .S ABMMIEN=0
 .F  S ABMMIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABMPRI,ABMMIEN))  Q:+ABMMIEN=0  D
 ..S ABMSTR=$G(ABMSTR)_$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,ABMMIEN,0)),U,5)
 I $G(ABMSTR)'="" S ABMR("K3",20)="POA"_ABMSTR_"Z"
 Q
30 ;K302 - Record Format Code - not used
 S ABMR("K3",30)=""
 Q
40 ;K303 - Composite Unit of Measure - not used
 S ABMR("K3",40)=""
 Q
