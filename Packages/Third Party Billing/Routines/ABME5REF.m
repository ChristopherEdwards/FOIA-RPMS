ABME5REF ; IHS/ASDST/DMJ - 837 REF Segment 
 ;;2.6;IHS Third Party Billing;**6,8**;NOV 12, 2009
 ;other payer provider info
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
 I '$D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),ABME("RTYPE"),I)) D 837^ABMUTL8
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
30 ;REF02 - Reference Secondary Identification
 I ABMEIC="EI" S ABMR("REF",30)=$P($G(^AUTTLOC(DUZ(2),0)),U,18)
 I ABMEIC="G4" S ABMR("REF",30)=$P(ABMB5,"^",8)
 I ABMEIC="9F" S ABMR("REF",30)=$P(ABMB5,"^",11)
 I ABMEIC="G1" S ABMR("REF",30)=$P(ABMB5,"^",12)
 I ABMEIC="Y4" S ABMR("REF",30)=$P(ABMB7,U,13)
 I ABMEIC="XZ" S ABMR("REF",30)=$P(ABMRV(ABMI,ABMJ,ABMK),U,2)
 I ABMEIC="SY"!(ABMEIC="1W") S ABMR("REF",30)=$P(ABMB7,U,26)
 I ABMEIC="BT" S ABMR("REF",30)=$P(ABMRV(ABMI,ABMJ,ABMK),U,37)  ;immun. batch#
 I ABMEIC="6R" S ABMR("REF",30)=$P($G(ABMRV(ABMI,ABMJ,ABMK)),U,38)  ;line item control number
 ;mammography cert#
 I ABMEIC="EW" S ABMR("REF",30)=$P($G(^ABMDPARM(ABMP("LDFN"),1,5)),U,4)
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
 .I ABMFILE=0,ABMEIC="LU" S ABMR("REF",30)=$$GET1^DIQ(5,$P(ABMB8,U,16),1,"E")  ;abm*2.6*8 5010
 I ABMEIC="F8" D
 .S ABMR("REF",30)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,9)
 I +ABMIEN=0,$D(ABMP("PRV","F")),($G(Z)'="") S ABMR("REF",30)=$P($G(ABMP("PRV","F",Z)),"^")
 ;I +$G(Z)=0,($G(ABMSIEN)'=""),(ABMR("REF",30)="") S ABMR("REF",30)=$P($G(ABMP("PRV","S",Z)),U)  ;abm*2.6*8
 Q:($G(ABMR("REF",30))'="")  ;abm*2.6*8
 I +$G(Z)=0,($G(ABMIEN)'=""),(ABMR("REF",30)="") S ABMR("REF",30)=$P($G(ABMP("PRV","S",Z)),U)  ;abm*2.6*8
 Q
40 ;REF03 - Description-not used
 S ABMR("REF",40)=""
 Q
50 ;REF04 - Reference Identifier-not used
 S ABMR("REF",50)=""
 Q
