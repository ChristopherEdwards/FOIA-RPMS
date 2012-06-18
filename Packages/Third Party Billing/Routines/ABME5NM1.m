ABME5NM1 ; IHS/ASDST/DMJ - 837 NM1 Segment 
 ;;2.6;IHS Third Party Billing System;**6,8**;NOV 12, 2009
 ;Submitter Name
 ;
EP(X,Y) ;EP - START HERE
 ;x=entity identifier
 ;y=file ien (optional)
 S ABMEIC=X
 S ABMNIEN=$G(Y)
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
 I '$D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D 837^ABMUTL8
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
 S:"40^41^85^87^PR^77^PW^45"[ABMEIC ABMR("NM1",30)=2
 Q
 ;
40 ;NM103 - Name Last or Organization Name
 ;
 S ABMR("NM1",40)=""
 ;
 ; Receiver
 I ABMEIC=40 D
 .;S ABMR("NM1",40)=$P($G(^AUTNINS(ABMP("INS"),2)),"^",13)  ;abm*2.6*8
 .;start new code abm*2.6*6 HEAT28891
 .I $D(^ABMRECVR("C",ABMP("INS"))) D
 ..S ABMCHIEN=$O(^ABMRECVR("C",ABMP("INS"),0))
 ..S ABMR("NM1",40)=$P($G(^ABMRECVR(ABMCHIEN,1,ABMP("INS"),0)),U,3)
 ..K ABMCHIEN
 .;end new code HEAT28891
 .S:ABMR("NM1",40)="" ABMR("NM1",40)=$P($G(^AUTNINS(ABMP("INS"),2)),"^",13)  ;abm*2.6*8
 .S:ABMR("NM1",40)="" ABMR("NM1",40)=$P($G(^AUTNINS(ABMP("INS"),0)),U)
 ;
 ; Submitter ^ Billing Provider
 I "41^85"[ABMEIC D
 .S ABMR("NM1",40)=$P($G(^DIC(4,DUZ(2),0)),U)
 ;
 ; Patient
 I ABMEIC="QC" D
 .S ABMR("NM1",40)=$$LNM^ABMUTLN(2,ABMP("PDFN"))
 ;
 ; Provider
 I "71^72^ZZ^82^QB^DK^DN^DQ^P3"[ABMEIC D
 .I +ABM("PRV")'=0 D
 ..S ABMR("NM1",40)=$$LNM^ABMUTLN(200,ABM("PRV"))
 .E  S ABMR("NM1",40)=$P(ABM("PRV"),",")
 ;
 ; Payer
 I ABMEIC="PR" D
 .S ABMR("NM1",40)=$P($G(^ABMNINS(DUZ(2),ABMNIEN,1,ABMP("VTYP"),1)),"^",2)
 .S:ABMR("NM1",40)="" ABMR("NM1",40)=$P($G(^AUTNINS(ABMNIEN,2)),"^",13)
 .S:ABMR("NM1",40)="" ABMR("NM1",40)=$P(^AUTNINS(ABMNIEN,0),U)
 ;
 ; Insured or Subscriber
 I ABMEIC="IL" D
 .S ABMR("NM1",40)=$$LNM^ABMUTLN(ABMSFILE,ABMSIEN)
 ;
 ; Facility
 I ABMEIC="77" D
 .S ABMR("NM1",40)=$P($G(^DIC(4,ABMP("LDFN"),0)),U)
 S:$G(ABMP("ITYPE"))'="D" ABMR("NM1",40)=$TR(ABMR("NM1",40),"-"," ")
 ;
 ; Ambulance Drop Off Location
 I ABMEIC="45" D
 .S ABMR("NM1",40)=$$GET1^DIQ("9002274.4",ABMP("BDFN"),".127")
 Q
 ;
50 ;NM104 - Name First
 S ABMR("NM1",50)=""
 ;
 ; Patient
 I ABMEIC="QC" D
 .S ABMR("NM1",50)=$$FNM^ABMUTLN(2,ABMP("PDFN"))
 ;
 ; Provider
 I "71^72^ZZ^82^QB^DK^DN^DQ^P3"[ABMEIC D
 .I +ABM("PRV")'=0 D
 ..S ABMR("NM1",50)=$$FNM^ABMUTLN(200,ABM("PRV"))
 .E  S ABMR("NM1",50)=$P(ABM("PRV"),",",2)
 ;
 ; Insured or Subscriber
 I ABMEIC="IL" D
 .S ABMR("NM1",50)=$$FNM^ABMUTLN(ABMSFILE,ABMSIEN)
 Q
 ;
60 ;NM105 - Name Middle
 S ABMR("NM1",60)=""
 ;
 ; Patient
 I ABMEIC="QC" D
 .S ABMR("NM1",60)=$$MI^ABMUTLN(2,ABMP("PDFN"))
 ;
 ; Insured or Subscriber
 I ABMEIC="IL" D
 .S ABMR("NM1",60)=$$MI^ABMUTLN(ABMSFILE,ABMSIEN)
 ;
 ; Provider
 I "71^72^ZZ^82^QB^DK^DN^DQ^P3"[ABMEIC D
 .S ABMR("NM1",50)=$$MI^ABMUTLN(200,ABM("PRV"))
 ;
 Q
 ;
70 ;NM106 - Name Prefix (Not Used)
 S ABMR("NM1",70)=""
 Q
 ;
80 ;NM107 - Name Suffix
 S ABMR("NM1",80)=""
 ;
 ; Patient
 I ABMEIC="QC" D
 .S ABMR("NM1",80)=$$SFX^ABMUTLN(2,ABMP("PDFN"))
 ;
 ; Insured or Subscriber
 I ABMEIC="IL" D
 .S ABMR("NM1",80)=$$SFX^ABMUTLN(ABMSFILE,ABMSIEN)
 ;
 ; Provider
 I "71^72^ZZ^82^QB^DK^DN^DQ^P3"[ABMEIC D
 .S ABMR("NM1",50)=$$SFX^ABMUTLN(200,ABM("PRV"))
 ;
 Q
 ;
90 ;NM108 - Identification Code Qualifier
 S ABMNPIU=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 S ABMR("NM1",90)=""
 I "40^41"[ABMEIC S ABMR("NM1",90)=46
 I ABMEIC=85 S ABMR("NM1",90)="XX"
 I "71^72^77^ZZ^82^DN^QB^DQ^DK"[ABMEIC S ABMR("NM1",90)="XX"
 I ABMEIC="PR" S ABMR("NM1",90)="PI"
 I ABMEIC="IL" S ABMR("NM1",90)="MI"
 Q
 ;
100 ;NM109 - Identification Code
 S ABMR("NM1",100)=""
 I ABMEIC=40 D
 .;S ABMR("NM1",100)=$$RCID^ABMUTLP(ABMP("INS"))  ;abm*2.6*8
 .;start new code abm*2.6*8 HEAT45044
 .I $D(^ABMRECVR("C",ABMP("INS"))) D
 ..S ABMCHIEN=$O(^ABMRECVR("C",ABMP("INS"),0))
 ..S:ABMCHIEN ABMR("NM1",100)=$P($G(^ABMRECVR(ABMCHIEN,1,ABMP("INS"),0)),U,2)
 .I ABMR("NM1",100)="" S ABMR("NM1",100)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,19)
 .I ABMR("NM1",100)="" S ABMR("NM1",100)=$$RCID^ABMUTLP(ABMP("INS"))
 .;end new code HEAT45044
 ;
 I ABMEIC=41 D
 .S ABMR("NM1",100)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,19)
 .I ABMR("NM1",100)="" S ABMR("NM1",100)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),0)),U,2)
 ;
 I ABMEIC=85 D
 .I ABMNPIU="N"!(ABMNPIU="B") D  Q
 ..S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 ..S ABMR("NM1",100)=$S($P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U),1:"")
 .S ABMR("NM1",100)=$P($G(^AUTTLOC(DUZ(2),0)),"^",18)
 ;
 ;attending/operating/other provider
 I "71^72^ZZ^82^DN^QB^DQ^DK^P3"[ABMEIC D
 .;I ABMEIC="DQ" S ABMR("NM1",100)=$P($G(ABMP("PRV","S",ABMIEN)),U,2) Q
 .S ABMR("NM1",100)=$P($$NPI^XUSNPI("Individual_ID",+ABM("PRV")),U) Q
 ;
 ; Payer
 I ABMEIC="PR" D
 .K Y
 .;S ABMR("NM1",100)=$$RCID^ABMUTLP(ABMP("INS"))  ;abm*2.6*8
 .;start new code abm*2.6*8 HEAT45044
 .I $D(^ABMRECVR("C",ABMP("INS"))) D
 ..S ABMCHIEN=$O(^ABMRECVR("C",ABMP("INS"),0))
 ..S:ABMCHIEN ABMR("NM1",100)=$P($G(^ABMRECVR(ABMCHIEN,1,ABMP("INS"),0)),U,2)
 .I ABMR("NM1",100)="" S ABMR("NM1",100)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,19)
 .I ABMR("NM1",100)="" S ABMR("NM1",100)=$$RCID^ABMUTLP(ABMP("INS"))
 .;end new code HEAT45044
 .S:$TR(ABMR("NM1",100)," ")="" ABMR("NM1",100)=99999
 ;
 ; Insured or Subscriber
 I ABMEIC="IL" D
 .S ABMR("NM1",100)=$G(ABMP("SNUM",ABMPST))
 .Q:ABMR("NM1",100)'=""
 .S ABMR("NM1",100)=$$PNUM^ABMUTLP(ABMP("BDFN"))
 ;
 ; Facility
 I ABMEIC="77" D
 .I ABMNPIU="N"!(ABMNPIU="B") D  Q
 ..S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 ..S ABMR("NM1",100)=$S($P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",+ABMLNPI),U),1:"")
 .S ABMR("NM1",100)=$$EIN^ABMUTLF(ABMP("LDFN"))
 S ABMR("NM1",100)=$$AN^ABMUTL8(ABMR("NM1",100))
 Q
 ;
110 ;NM110 - Entity Relationship Code (Not used)
 S ABMR("NM1",110)=""
 Q
 ;
120 ;NM111 - Entity Identifier Code (Not used)
 S ABMR("NM1",120)=""
 Q
 ;
130 ;NM112 - Name Last or Organization Name (Not used)
 S ABMR("NM1",130)=""
 Q
