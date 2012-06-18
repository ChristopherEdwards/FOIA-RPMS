ABME8REF ; IHS/ASDST/DMJ - 837 REF Segment 
 ;;2.6;IHS Third Party Billing;**1,8**;NOV 12, 2009
 ;other payer provider info
 ;
 ; IHS/SD/SDR - v2.5 p5 - 5/17/04 - Added code to pull referring provider
 ;     from page 3 (primarily used from diagnostic claims)
 ; IHS/SD/SDR - v2.5 p8 - IM12246/IM17548
 ;    Added code from CLIA REF segment
 ; IHS/SD/SDR - v2.5 p9 - IM19291
 ;    Supervising provider UPIN
 ; IHS/SD/SDR - v2.5 p9 - IM16962
 ;    Added code for Provider if PI
 ; IHS/SD/SDR - v2.5 p9 - IM18032
 ;   Put Medicaid Resubmission Number as REF*F8
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines bundled by rev code
 ; IHS/SD/SDR - v2.5 p10 - IM19940
 ;   Fix for supervising provider UPIN
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - v2.5 p11 - IM21946
 ;   CLIA number changes
 ; IHS/SD/SDR - v2.5 p12 - IM24898
 ;   Change for supervising provider qualifier
 ; IHS/SD/SDR - v2.5 p12 - IM24975
 ;   Changes for Value Options
 ; IHS/SD/SDR - v2.5 p12 - IM23560
 ;   Made changes for CLIA (qualifier not showing up
 ;   for referring lab charges)
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4158 - mammography cert#
 ;
EP(X,Y,Z) ;EP
 ;x=entity identifier code from nm1
 ;y=file number
 ;z=internal entry number
 K ABMREC("REF"),ABMR("REF")
 S ABMEIC=X
 S ABMFILE=+$G(Y)
 S ABMIEN=+$G(Z)
 ;S ABMSIEN=$G(Z)  ;abm*2.6*8
 S ABME("RTYPE")="REF"
 D LOOP
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:50 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D @(^(I))
 .I $G(ABMREC("REF"))'="" S ABMREC("REF")=ABMREC("REF")_"*"
 .S ABMREC("REF")=$G(ABMREC("REF"))_ABMR("REF",I)
 Q
10 ;segment
 S ABMR("REF",10)="REF"
 Q
20 ;REF01 - Reference Identification Qualifier
 S ABMR("REF",20)=ABMEIC
 I $G(ABMCLIA)="SV" D
 .I $G(ABMI)=37,(ABMEIC="X4"),($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,13)'=""),($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,13)=($P($G(ABMB9),U,2))) S ABMR("REF",20)=""
 .I $G(ABMI)=37,($G(ABMEIC)="F4"),($P($G(ABMRV(ABMI,ABMJ,ABMK)),U,3)'=90),($P($G(ABMRV(ABMI,ABMJ,ABMK)),U,4)'=90)&($P($G(ABMRV(ABMI,ABMJ,ABMK)),U,12)'=90) S ABMR("REF",20)=""
 I $G(ABMR("REF",20))="",ABMIEN=0,($G(ABMFILE)=200),$D(ABMP("PRV","F")) S ABMR("REF",20)="1G"
 I +$G(Z)'=0,$D(ABMP("PRV","S",Z)) S ABMR("REF",20)="1D"  ;supervising
 Q
30 ;REF02 - Reference Identification
 I ABMEIC=87 D
 .S:ABMP("EXP")=21 ABMR("REF",30)="004010X096A1"
 .S:ABMP("EXP")=22 ABMR("REF",30)="004010X098A1"
 .S:ABMP("EXP")=23 ABMR("REF",30)="004010X097A1"
 I ABMEIC="G4" D
 .S ABMR("REF",30)=$P(ABMB5,"^",8)
 I ABMEIC="9F" D
 .S ABMR("REF",30)=$P(ABMB5,"^",11)
 I ABMEIC="G1" D
 .S ABMR("REF",30)=$P(ABMB5,"^",12)
 ;start new code abm*2.6*1 HEAT4158
 ;mammography cert#
 I ABMEIC="EW" D
 .S ABMR("REF",30)=$P($G(^ABMDPARM(ABMP("LDFN"),1,5)),U,4)
 ;end new code HEAT4158
 I ABMEIC="F4" D
 .S ABMR("REF",30)=""
 .I ABMCLIA="SV" D  ;service lines
 ..; if outside lab (determined by use of 90 modifier)
 ..; ABMOUTLB will be used later to determine whether other segments should be written
 ..I $P(ABMRV(ABMI,ABMJ,ABMK),U,3)=90!($P(ABMRV(ABMI,ABMJ,ABMK),U,4)=90)!($P(ABMRV(ABMI,ABMJ,ABMK),U,12)=90) D
 ...I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0),"^",14)'="" S ABMR("REF",30)=$P(^ABMRLABS($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0),"^",14),0),"^",2) Q
 ...I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),"^",23)'="" S ABMR("REF",30)=$P(^ABMRLABS($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),"^",23),0),"^",2)
 ..; if in-house lab (lack of 90 modifier)
 I ABMEIC="X4" D
 .S ABMR("REF",30)=""
 .I ABMCLIA="CLM" S ABMR("REF",30)=$P(ABMB9,U,22) Q  ;in-house CLIA from claim header
 .I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,13)'="",($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,13)'=($P($G(ABMB9),U,22))) S ABMR("REF",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMJ,0)),U,13)
 .E  S ABMR("REF",30)=$P($G(ABMB9),U,22)
 I ABMEIC="EA" D
 .S ABMR("REF",30)=$$HRN^ABMUTL8(ABMP("PDFN"))
 I ABMEIC="1C" D
 .I ABMFILE=9999999.06 D
 ..S ABMR("REF",30)=$$MCR^ABMUTLF(ABMIEN)
 .I ABMFILE=200 D
 ..S ABMR("REF",30)=$$MCR^ABMEEPRV(ABMIEN)
 ..Q:$$RCID^ABMUTLP(ABMP("INS"))'="C00900"
 ..Q:$$RCID^ABMUTLP(ABMP("INS"))'="04402"
 ..S ABMR("REF",30)=$$NPI^ABMEEPRV(ABMIEN,ABMP("LDFN"),ABMP("INS"))
 I ABMEIC="1D" D
 .I ABMFILE=9999999.06 D
 ..S ABMR("REF",30)=$$MCD^ABMUTLF(ABMIEN)
 .I ABMFILE=200 D
 ..S ABMR("REF",30)=$$MCD^ABMEEPRV(ABMIEN,+$G(ABMPAYER))
 I ABMEIC="0B" D
 .S ABMR("REF",30)=$$SLN^ABMEEPRV(ABMIEN)
 I ABMEIC="1G" D
 .S ABMR("REF",30)=$$MCD^ABMUTLF(ABMIEN)
 .S:ABMR("REF",30)="" ABMR("REF",30)=$$UPIN^ABMEEPRV(ABMIEN)
 I "^BQ^G2^1A^1B^B3^1H^1J^EI^FH^G5^LU^SY^U3^X5^"[("^"_ABMEIC_"^") D
 .I ABMFILE=9999999.06 D
 ..I ABMRCID="FHC&AFFILIATES"&(ABMEIC="LU") D
 ...S ABMR("REF",30)=$P($G(^AUTNINS(ABMP("INS"),15,ABMIEN,0)),U,2)
 ..E  S ABMR("REF",30)=$$PI^ABMUTLF(ABMIEN)
 .I ABMFILE=200 D
 ..I ABMRCID="FHC&AFFILIATES"&(ABMEIC="LU") D
 ...S ABMR("REF",30)=$P($G(^AUTNINS(ABMP("INS"),15,ABMIEN,0)),U,2)
 ..E  S ABMR("REF",30)=$$PI^ABMUTLF(ABMP("LDFN"))
 I ABMEIC="F8" D
 .S ABMR("REF",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,9)
 I +ABMIEN=0,$D(ABMP("PRV","F")),($G(Z)'="") S ABMR("REF",30)=$P($G(ABMP("PRV","F",Z)),"^")
 ;I +$G(Z)=0,($G(ABMSIEN)'=""),(ABMR("REF",30)="") S ABMR("REF",30)=$P($G(ABMP("PRV","S",Z)),U)  ;abm*2.6*8
 I +$G(Z)=0,($G(ABMIEN)'=""),(ABMR("REF",30)="") S ABMR("REF",30)=$P($G(ABMP("PRV","S",Z)),U)  ;abm*2.6*8
 Q
40 ;REF03 - Description-not used
 S ABMR("REF",40)=""
 Q
50 ;REF04 - Reference Identifier-not used
 S ABMR("REF",50)=""
 Q
