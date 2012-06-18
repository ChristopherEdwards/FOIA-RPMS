ABME5PRV ; IHS/ASDST/DMJ - 837 PRV Segment 
 ;;2.6;IHS Third Party Billing System;**6**;NOV 12, 2009
 ;Provider Information
 ;
EP(X,Y) ;EP - START HERE
 ;x=type
 ;y=ien
 I $G(^ABMDPARM(DUZ(2),1,19,ABMP("INS"),0))'="" S ABMR("PRV")="",ABMREC("PRV")="" Q
 I +Y=0 S Y=$P(ABMP("PRV","F",Y),"^",2)
 K ABMREC("PRV"),ABMR("PRV")
 S ABMPRVC=X
 S ABME("RTYPE")="PRV"
 D LOOP
 K ABME
 Q
LOOP ;LOOP HERE
 F I=10:10:70 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("PRV"))'="" S ABMREC("PRV")=ABMREC("PRV")_"*"
 .S ABMREC("PRV")=$G(ABMREC("PRV"))_ABMR("PRV",I)
 Q
10 ;segment
 S ABMR("PRV",10)="PRV"
 Q
20 ;PRV01 - Provider Code
 S ABMR("PRV",20)=ABMPRVC
 Q
30 ;PRV02 - Reference Identification Qualifier
 S ABMR("PRV",30)="PXC"
 Q
40 ;PRV03 - Reference Identification
 S ABMR("PRV",40)=""
 I "AT^SU^OP^OY^PE^RF"[ABMPRVC D
 .S ABMR("PRV",40)=$$PTAX^ABMEEPRV(Y)
 I ABMPRVC="BI" D
 .S ABMR("PRV",40)=$$PTAX^ABMUTLF(DUZ(2))
 .I ABMP("VTYP")=831 S ABMR("PRV",40)="261QA1903X"
 I ABMPRVC="RP" D
 .S ABMR("PRV",40)=$$PTAX^ABMUTLF(ABMP("LDFN"))
 Q
50 ;PRV04 - State or Province Code
 S ABMR("PRV",50)=""
 Q
60 ;PRV05 - Provider Specialty Information
 S ABMR("PRV",60)=""
 Q
70 ;PRV06 - Provider Organization Code
 S ABMR("PRV",70)=""
 Q
