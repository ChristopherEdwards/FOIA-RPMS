ABME8CR6 ; IHS/ASDST/DMJ - 837 CR6 Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Transaction Set Header
 ;
START ;START HERE
 K ABMREC("CR6"),ABMR("CR6")
 S ABME("RTYPE")="CR6"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:220 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("CR6"))'="" S ABMREC("CR6")=ABMREC("CR6")_"*"
 .S ABMREC("CR6")=$G(ABMREC("CR6"))_ABMR("CR6",I)
 Q
10 ;segment
 S ABMR("CR6",10)="CR6"
 Q
20 ;CR601 - Prognosis Code
 S ABMR("CR6",20)=""
 Q
30 ;CR602 - Date
 S ABMR("CR6",30)=""
 Q
40 ;CR603 - Date Time Period Format Qualifier
 S ABMR("CR6",40)=""
 Q
50 ;CR604 - Date Time Period
 S ABMR("CR6",50)=""
 Q
60 ;CR605 - Date
 S ABMR("CR6",60)=""
 Q
70 ;CR606 - Yes/No Condition or Response Code
 S ABMR("CR6",70)=""
 Q
80 ;CR607 - Yes/No Condition of Response Code
 S ABMR("CR6",80)=""
 Q
90 ;CR608 - Certification Type Code
 S ABMR("CR6",90)=""
 Q
100 ;CR609 - Date
 S ABMR("CR6",100)=""
 Q
110 ;CR610 - Product/Service ID Qualifier
 S ABMR("CR6",110)=""
 Q
120 ;CR611 - Medical Code Value
 S ABMR("CR6",120)=""
 Q
130 ;CR612 - Date
 S ABMR("CR6",130)=""
 Q
140 ;CR613 - Date
 S ABMR("CR6",140)=""
 Q
150 ;CR614 - Date
 S ABMR("CR6",150)=""
 Q
160 ;CR615 - Date Time Period Format Qualifier
 S ABMR("CR6",160)=""
 Q
170 ;CR616 - Date Time Period
 S ABMR("CR6",170)=""
 Q
180 ;CR617 - Patient Location Code
 S ABMR("CR6",180)=""
 Q
190 ;CR618 - Date
 S ABMR("CR6",190)=""
 Q
200 ;CR619 - Date
 S ABMR("CR6",200)=""
 Q
210 ;CR620 - Date
 S ABMR("CR6",210)=""
 Q
220 ;CR621 - Date
 S ABMR("CR6",220)=""
 Q
