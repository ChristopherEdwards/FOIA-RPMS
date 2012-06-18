ABME8DMG ; IHS/ASDST/DMJ - 837 DMG Segment 
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;Demographic Information
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM13177/IM13285
 ;    Modified DOB to pull what's on file for subscriber of said
 ;    insurer before using what's on file for patient
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM19664 - Correction to DOB in patch 8
 ; IHS/SD/SDR - abm*2.6*1 - HEAT7074 - <UNDEF>40+5^ABME8DMG
 ;
EP(X,Y) ;EP
 ;x=file
 ;y=ien
 K ABMREC("DMG"),ABMR("DMG")
 S ABME("RTYPE")="DMG"
 S ABMFILE=X
 S ABMFIEN=Y  ;abm*2.6*1 HEAT7074
 S:X=3 ABMFILE=9000003.1
 D LOOP
 K ABME,ABM,ABMFILE
 Q
LOOP ;LOOP HERE
 F I=10:10:100 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("DMG"))'="" S ABMREC("DMG")=ABMREC("DMG")_"*"
 .S ABMREC("DMG")=$G(ABMREC("DMG"))_ABMR("DMG",I)
 Q
10 ;segment
 S ABMR("DMG",10)="DMG"
 Q
20 ;DMG01 - Date Time Period Format Qualifier
 S ABMR("DMG",20)="D8"
 Q
30 ;DMG02 - Date of Birth
 N ABMTMPT,ABMTMPI,ABMTMPHI
 S ABMDOB=0
 S ABMTMPT=$P(ABMP("INS",ABMI),U,2)  ;ins type
 ; if Medicaid or Kidscare, get Medicaid DOB
 I ABMTMPT="K"!(ABMTMPT="D") D
 .S ABMTMPI=$P(ABMP("INS",ABMI),U,6)  ;ien to MCD Elig.
 .Q:'+ABMTMPI
 .S ABMDOB=$P($G(^AUPNMCD(ABMTMPI,21)),U,2)
 ; else if Medicare, get Medicare DOB
 E  I ABMTMPT="R" S ABMDOB=$P($G(^AUPNMCR(ABMP("PDFN"),21)),U,2)
 ; else must be private, get Policy Holder DOB
 E  D
 .S ABMTMPI=$P(ABMP("INS",ABMI),U,8)  ;IEN ins mult of prvt elig
 .Q:'+ABMTMPI
 .S ABMTMPHI=$P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMTMPI,0)),U,8)
 .Q:'+ABMTMPHI
 .S:ABMCHILD ABMDOB=$P($G(^AUPN3PPH(ABMTMPHI,0)),U,19)
 ;if no DOB for subscriber, pull patient's DOB
 I '+ABMDOB S ABMDOB=$P($G(^DPT(ABMP("PDFN"),0)),U,3)
 I +ABMDOB S ABMR("DMG",30)=$$Y2KD2^ABMDUTL(ABMDOB)
 Q
40 ;DMG03 - Gender Code
 S ABMR("DMG",40)=""
 I ABMFILE=2 D
 .;S ABMR("DMG",40)=$P(^DPT(Y,0),"^",2)  ;abm*2.6*1 HEAT7074
 .S ABMR("DMG",40)=$P(^DPT(ABMFIEN,0),"^",2)  ;abm*2.6*1 HEAT7074
 I ABMFILE=9000003.1 D
 .;S ABMR("DMG",40)=$P(^AUPN3PPH(Y,0),"^",8)  ;abm*2.6*1 HEAT7074
 .S ABMR("DMG",40)=$P(^AUPN3PPH(ABMFIEN,0),"^",8)  ;abm*2.6*1 HEAT7074
 S:ABMR("DMG",40)="" ABMR("DMG",40)="U"
 Q
50 ;DMG04 - Marital Status Code
 S ABMR("DMG",50)=""
 Q
60 ;DMG05 - Race or Ethnicity Code
 S ABMR("DMG",60)=""
 Q
70 ;DMG06 - Citizenship Status Code
 S ABMR("DMG",70)=""
 Q
80 ;DMG07 - Country Code
 S ABMR("DMG",80)=""
 Q
90 ;DMG08 - Basis of Verification Code
 S ABMR("DMG",90)=""
 Q
100 ;DMG09 - Quantity
 S ABMR("DMG",100)=""
 Q
