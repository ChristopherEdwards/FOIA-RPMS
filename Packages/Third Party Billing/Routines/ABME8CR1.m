ABME8CR1 ; IHS/SD/SDR - 837 CR1 Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Transaction Set Header
 ;
EP ;EP - START HERE
 K ABMREC("CR1"),ABMR("CR1")
 S ABME("RTYPE")="CR1"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:110 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("CR1"))'="" S ABMREC("CR1")=ABMREC("CR1")_"*"
 .S ABMREC("CR1")=$G(ABMREC("CR1"))_ABMR("CR1",I)
 Q
10 ;segment
 S ABMR("CR1",10)="CR1"
 Q
20 ;CR101 - Unit or Basis for Measurement Code
 S ABMR("CR1",20)=$S($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,11)'="":"LB",1:"")
 Q
30 ;CR102 - Weight
 S ABMR("CR1",30)=""
 S ABMR("CR1",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,11)
 Q
40 ;CR103 - Ambulance Transport Code
 S ABMR("CR1",40)=""
 S ABMR("CR1",40)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,12)
 Q
50 ;CR104 - Ambualnce Transport Reason Code
 S ABMR("CR1",50)=""
 S ABMR("CR1",50)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,13)
 Q
60 ;CR105 - Unit or Basis for Measurement Code
 S ABMR("CR1",60)="DH"
 Q
70 ;CR106 - Quantity
 S ABMR("CR1",70)=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,8)
 Q
80 ;CR107 - Address Information (not used)
 S ABMR("CR1",80)=""
 Q
90 ;CR108 - Address Information (not used)
 S ABMR("CR1",90)=""
 Q
100 ;CR109 - Description
 S ABMR("CR1",100)=""
 Q
110 ;CR110 - Description
 S ABMR("CR1",110)=""
 Q
