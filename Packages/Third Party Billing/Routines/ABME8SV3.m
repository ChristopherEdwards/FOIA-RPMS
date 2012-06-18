ABME8SV3 ; IHS/ASDST/DMJ - 837 SV3 Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Transaction Set Header
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines bundled by rev code
 ;
EP ;EP
 K ABMREC("SV3"),ABMR("SV3")
 S ABME("RTYPE")="SV3"
 D LOOP
 K ABME
 Q
LOOP ;LOOP HERE
 F I=10:10:120 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("SV3"))'="" S ABMREC("SV3")=ABMREC("SV3")_"*"
 .S ABMREC("SV3")=$G(ABMREC("SV3"))_ABMR("SV3",I)
 Q
10 ;segment
 S ABMR("SV3",10)="SV3"
 Q
20 ;SV301 - Composite Medical Procedure Identifier
 ;SV301-1 Product Service ID Qualifier
 ;SV301-2 Product Service ID (Procedure Code)
 S ABMR("SV3",20)="AD"
 S $P(ABMR("SV3",20),":",2)=$P(ABMRV(ABMI,ABMJ,ABMK),U,2)
 N I
 F I=3,4,12,22 D
 .Q:$P(ABMRV(ABMI,ABMJ,ABMK),U,I)=""
 .S ABMR("SV3",20)=ABMR("SV3",20)_":"_$P(ABMRV(ABMI,ABMJ,ABMK),U,I)
 Q
30 ;SV302 - Monetary Amount (Charges)
 S ABMR("SV3",30)=$P(ABMRV(ABMI,ABMJ,ABMK),U,6)
 S ABMR("SV3",30)=$J(ABMR("SV3",30),0,2)
 Q
40 ;SV303 - Place of service
 S ABMR("SV3",40)=""
 Q
50 ;SV304 - Oral Cavity Designation
 S ABMR("SV3",50)=""
 Q
60 ;SV305 - Prothesis, Crown, or Inlay Code
 S ABMR("SV3",60)=""
 Q
70 ;SV306 - Quantity
 S ABMR("SV3",70)=$P(ABMRV(ABMI,ABMJ,ABMK),U,5)
 Q
80 ;SV307 - Description
 S ABMR("SV3",80)=""
 Q
90 ;SV308 - Copay Status Code
 S ABMR("SV3",90)=""
 Q
100 ;SV309 - Provider Agreement Code
 S ABMR("SV3",100)=""
 Q
110 ;SV310 - not used
 S ABMR("SV3",110)=""
 Q
120 ;SV311 - Composite DX Code Pointer
 S ABMR("SV3",120)=""
 Q
