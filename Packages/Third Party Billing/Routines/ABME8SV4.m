ABME8SV4 ; IHS/ASDST/DMJ - 837 SV4 Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Transaction Set Header
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines bundled by rev code
 ;
EP ;EP
 K ABMREC("SV4"),ABMR("SV4")
 S ABME("RTYPE")="SV4"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:190 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("SV4"))'="" S ABMREC("SV4")=ABMREC("SV4")_"*"
 .S ABMREC("SV4")=$G(ABMREC("SV4"))_ABMR("SV4",I)
 Q
10 ;segment
 S ABMR("SV4",10)="SV4"
 Q
20 ;SV401 - Reference Identification
 ; Prescription Number
 S ABMR("SV4",20)=$P(ABMRV(ABMREV,ABMCODE,ABMCNTR),U,14)
 Q
30 ;SV402 - Composite Medical Procedure Identifier (Not used)
 S ABMR("SV4",30)=""
 Q
40 ;SV403 - Reference Identification (Not used)
 S ABMR("SV4",40)=""
 Q
50 ;SV404 - Yes/No Condition or Response Code (Not used)
 S ABMR("SV4",50)=""
 Q
60 ;SV405 - Dispense as Written Code (Not used)
 S ABMR("SV4",60)=""
 Q
70 ;SC406 - Level of Service Code (Not used)
 S ABMR("SV4",70)=""
 Q
80 ;SV407 - Prescription Origin Code (Not used)
 S ABMR("SV4",80)=""
 Q
90 ;SV408 - Description (Not used)
 S ABMR("SV4",90)=""
 Q
100 ;SV409 - Yes/No Condition or Response Code (Not used)
 S ABMR("SV4",100)=""
 Q
110 ;SV410 - Yes/No Condition or Response Code (Not used)
 S ABMR("SV4",110)=""
 Q
120 ;SV411 - Unit Dose Code (Not used)
 S ABMR("SV4",120)=""
 Q
130 ;SV412 - Basis of Cost Determination Code (Not used)
 S ABMR("SV4",130)=""
 Q
140 ;SV413 - Basis of Days Supply Determination Code (Not used)
 S ABMR("SV4",140)=""
 Q
150 ;SV414 - Dosage Form Code (Not used)
 S ABMR("SV4",150)=""
 Q
160 ;SV415 - Copay Status Code (Not used)
 S ABMR("SV4",160)=""
 Q
170 ;SV416 - Patient Location Code (Not used)
 S ABMR("SV4",170)=""
 Q
180 ;SV417 - Level of Care Code (Not used)
 S ABMR("SV4",180)=""
 Q
190 ;SV418 - Prior Authorization Type Code (Not used)
 S ABMR("SV4",190)=""
 Q
