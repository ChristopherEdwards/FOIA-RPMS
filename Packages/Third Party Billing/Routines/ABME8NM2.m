ABME8NM2 ; IHS/ASDST/DMJ - 837 NM1 Segment 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;other payer patient
 ;
EP(X,Y) ;EP - START HERE
 ;x=entity identifier
 ;y=file ien (optional)
 S ABMEIC=X
 S ABMIEN=$G(Y)
 K ABMREC("NM1"),ABMR("NM1")
 S ABME("RTYPE")="NM1"
 D LOOP
 K ABME,ABMEIC
 Q
 ;
LOOP ;LOOP HERE
 F I=10:10:120 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("NM1"))'="" S ABMREC("NM1")=ABMREC("NM1")_"*"
 .S ABMREC("NM1")=$G(ABMREC("NM1"))_ABMR("NM1",I)
 Q
 ;
10 ;segment
 S ABMR("NM1",10)="NM1"
 Q
 ;
20 ;NM101 - Entity Identifier Code
 S ABMR("NM1",20)=ABMEIC
 Q
 ;
30 ;NM102 - Entity Type Qualifier
 S ABMR("NM1",30)=1
 Q
 ;
40 ;NM103 - Name Last or Organization Name
 S ABMR("NM1",40)=""
 Q
 ;
50 ;NM104 - Name First
 S ABMR("NM1",50)=""
 Q
 ;
60 ;NM105 - Name Middle
 S ABMR("NM1",60)=""
 Q
 ;
70 ;NM106 - Name Prefix (Not used)
 S ABMR("NM1",70)=""
 Q
 ;
80 ;NM107 - Name Suffix
 S ABMR("NM1",80)=""
 Q
 ;
90 ;NM108 - Identification Code Qualifier
 S ABMR("NM1",90)=""
 I ABMEIC="QC" D
 .S ABMR("NM1",90)="MI"
 Q
 ;
100 ;NM109 - Identification Code
 S ABMR("NM1",100)=""
 I ABMEIC="QC" D
 .S ABMR("NM1",100)=$G(ABMP("PNUM",ABMIEN))
 .S:'ABMIEN ABMR("NM1",100)=$G(ABMP("PNUM"))
 Q
 ;
110 ;NM110 - Entity Relationship Code (Not used)
 S ABMR("NM1",110)=""
 Q
 ;
120 ;NM111 - Entity Identifier Code (Not used)
 S ABMR("NM1",120)=""
 Q
