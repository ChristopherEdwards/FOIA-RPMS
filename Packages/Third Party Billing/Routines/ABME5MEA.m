ABME5MEA ; IHS/SD/SDR - 837 MEA Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
EP ;EP - START HERE
 K ABMREC("MEA"),ABMR("MEA")
 S ABME("RTYPE")="MEA"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:130 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("MEA"))'="" S ABMREC("MEA")=ABMREC("MEA")_"*"
 .S ABMREC("MEA")=$G(ABMREC("MEA"))_ABMR("MEA",I)
 Q
10 ;segment
 S ABMR("MEA",10)="MEA"
 Q
20 ;MEA01 - Measurement Reference ID code
 S ABMR("MEA",20)="TR"
 Q
30 ;MEA02 - Measurement Qualifier
 S ABMR("MEA",30)=""
 S ABMR("MEA",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,ABMJ,0)),U,19)
 Q
40 ;MEA03 - Measurement Value
 S ABMR("MEA",40)=""
 S ABMR("MEA",40)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,ABMJ,0)),U,21)
50 ;MEA04 - Composite unit of measure
 S ABMR("MEA",50)=""
60 ;MEA05 - Range Minimum
 S ABMR("MEA",60)=""
70 ;MEA06 - Range Maximum
 S ABMR("MEA",70)=""
80 ;MEA07 - Measurement Significance Code
 S ABMR("MEA",80)=""
90 ;MEA08 - Measurement Attribute Code
 S ABMR("MEA",90)=""
100 ;MEA09 - Surface/Layer/Position Code
 S ABMR("MEA",100)=""
110 ;MEA10 - Measurement Method or Device
 S ABMR("MEA",110)=""
120 ;MEA11 - Code List Qualifier Code
 S ABMR("MEA",120)=""
130 ;MEA12 - Industry Code
 S ABMR("MEA",130)=""
 Q
