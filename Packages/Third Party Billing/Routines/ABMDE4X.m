ABMDE4X ; IHS/ASDST/DMJ - Edit Page 4 - Providers DATA CK ;    
 ;;2.6;IHS Third Party Billing;**1,3,8**;NOV 12, 2009
 ;
 ; IHS/DSD/LSL - 05/20/98 - NOIS HQW-0598-100109
 ;               Modified to check file 200, payer assigned provider
 ;               number, first on dental form
 ; IHS/ASDS/LSL - 10/21/01 - V2.4 Patch 9
 ;     Display Medicare part B pin number on page 4 if professional
 ;     component, medicare insurer type and mode of export contain
 ;     HCFA-1500.  If the above are true and no pin number, set errror
 ;     189.
 ;
 ; IHS/SD/SDR - v2.5 p5 - 5/17/2004 - IM12881 - Made change to display
 ;     provider number correctly
 ; IHS/SD/SDR - v2.5 p8 - IM14693/IM16105
 ;    Added code to check error 190 for export mode 25
 ; IHS/SD/SDR - v2.5 p9 - IM19302
 ;   Correction to error 170
 ; IHS/SD/SDR - v2.5 p9 - IM16942
 ;   For OK Medicaid - if VT 999 - print payer assigned provider#
 ;                     if not VT 999-PIN# from Insurer file
 ; IHS/SD/SDR - v2.5 p10 - IM20310
 ;   Update 170 error check to check Payer Assigned Provider Number
 ;   for Medicare
 ; IHS/SD/SDR - v2.5 p10 - IM20776
 ;   Made change to 190 error to check for Rendering provider
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - abm*2.6*1 - NO HEAT - remove error 189 if NPI ONLY
 ; IHS/SD/SDR - abm*2.6*3 - HEAT12442 - made error 92 display for all 837s
 ; 
 ; *********************************************************************
 ;
PROV ; Provider Info
ERR S ABME("TITL")="PAGE 4 - PROVIDER INFORMATION"
 K ABM("A"),ABM("O")
 S ABM=""
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C",ABM)) Q:ABM=""  D
 .S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C",ABM,0))
 .S ABM("NUM")=ABM("I")
 .D SEL
 I '$D(ABM("A")) D
 .Q:ABMP("EXP")=22  ;abm*2.6*3 HEAT12442
 .S ABME(92)=""
OP I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","O")),$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,0)),ABMP("PAGE")'[8 S ABME(2)=""
 I ABMP("EXP")=2!(ABMP("EXP")=3)!(ABMP("EXP")=14),$P(^ABMDPARM(DUZ(2),1,0),U,17)=2 K ABME
 K ABM
 Q
 ;
SEL ;EP - Entry Point for select provider, Claim File Error Check
 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),41,ABM("X"),0) G GET
SELBILL ;EP - Entry Point for Bill file provider error check
 ;
 ;  input var: ABM(X) = the IEN of the Provider for the Bill
 ;
 ;  output var: ABM("A") - attending name ^ Prv IEN ^ Claim IEN
 ;              ABM("O") - operating name ^ Prv IEN ^ Claim IEN
 ;              ABM("PNUM") - provider number
 ;              ABM("DISC") - provider discipline
 ;
 S ABM("X0")=^ABMDBILL(DUZ(2),ABMP("BDFN"),41,ABM("X"),0),ABMP("C0")=ABMP("B0")
 ;
GET S (ABM("DISC"),ABM("PNUM"))=""
 Q:$P(ABM("X0"),U,2)=""
 I '$D(^VA(200,$P(ABM("X0"),U),0)) S ABME(119)="DFN:"_$P(ABM("X0"),U) Q
 S ABM($P(ABM("X0"),U,2))=$P(^VA(200,$P(ABM("X0"),U),0),U)_U_$P(ABM("X0"),U)_U_ABM("X")
 S ABM("DISC")=$P($G(^VA(200,$P(ABM("X0"),U),"PS")),U,5)
 I ABM("DISC")]"",$D(^DIC(7,ABM("DISC"),0)) S ABM("DISC")=$E($P(^(0),U),1,30)
 E  S ABME(118)=""
DR ;PHYSICIAN'S PROVIDER NUMBER
 S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)<0)&($P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)<0) S ABME(220)=""
 I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)<0)&($P($$NPI^XUSNPI("Organization_ID",+ABMP("LDFN")),U)<0) S ABME(221)=""
 I (ABMNPIUS="N"!(ABMNPIUS="B")),($P($$NPI^XUSNPI("Individual_ID",+ABM("X0")),U)<0)&($P($$NPI^XUSNPI("Organization_ID",ABMP("LDFN")),U)>0) S ABME(232)=""
 I '$D(ABMP("CDFN")),$D(ABMP("BDFN")) S ABMP("CDFN")=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)
 I +ABMP("CDFN") D  Q:$D(ABME(189))
 .S:ABMP("VTYP")="" ABMP("VTYP")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,7)
 .S:ABMP("INS")="" ABMP("INS")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,8)
 .S:ABMP("INS")'="" ABMP("ITYP")=$P($G(^AUTNINS(ABMP("INS"),2)),U)
 .S:ABMP("EXP")="" ABMP("EXP")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,14)
 .S:ABMP("LDFN")="" ABMP("LDFN")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,3)
 .I ABMP("VTYP")=999 D
 ..I $G(ABMP("ITYP"))="R" D  ;abm*2.6*1 NO HEAT
 ..;I $G(ABMP("ITYP"))="R",(ABMNPIUS'="N") D  ;abm*2.6*1 NO HEAT
 ...I +ABMP("EXP"),(($P($G(^ABMDEXP(+ABMP("EXP"),0)),U)["HCFA")!($P($G(^ABMDEXP(+ABMP("EXP"),0)),U)["CMS")) D
 ....S ABM("PNUM")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),3,+ABM("X0"),0)),U,2)
 ....S:ABM("PNUM")="" ABME(189)=""
 ..I $P(^AUTNINS(ABMP("INS"),0),U)["OKLAHOMA MEDICAID" D
 ...S ABM("PNUM")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),3,+ABM("X0"),0)),U,2)
 I $G(ABM("PNUM"))="" D
 .S ABM("PNUM")=$P($G(^VA(200,+ABM("X0"),9999999.18,+ABMP("INS"),0)),"^",2)
 I ABM("PNUM")="" D
 .I $P($G(^AUTNINS(+ABMP("INS"),2)),U)="R" D
 ..S ABM("PNUM")=$P($G(^VA(200,+ABM("X0"),9999999)),U,6)
 ..S:ABM("PNUM")="" ABM("PNUM")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),3,+ABM("X0"),0)),U,2)
 ..I ABM("PNUM")="" S ABME(170)=""
 ..S:ABM("PNUM")="" ABM("PNUM")=$P($G(^VA(200,+ABM("X0"),9999999)),"^",8)
 ..S:ABM("PNUM")="" ABM("PNUM")="PHS000"
 .;I $P($G(^AUTNINS(+ABMP("INS"),2)),U)="D" D  ;IHS/SD/SDR 9/25/09
 .I $P($G(^AUTNINS(+ABMP("INS"),2)),U)="D",(ABMNPIUS'="N") D  ;IHS/SD/SDR 9/25/09
 ..S ABM("PNUM")=$P($G(^VA(200,+ABM("X0"),9999999)),U,7)
 ..S:ABM("PNUM")="" ABME(170)=""
 I ABM("PNUM")="",(ABMNPIUS'="N") D
 .S ABM("ST")=$P(ABMP("C0"),U,3)
 .S ABM("ST")=$P($G(^AUTTLOC(+ABM("ST"),0)),U,23)
 .S:ABM("ST")="" ABM("ST")=$P($G(^AUTTLOC(+ABM("ST"),0)),U,14)
 .I ABM("ST")="" S ABME(120)=""
 .S ABM("PNUM")=$$SLN^ABMERUTL(+ABM("X0"),ABM("ST"))
 S:ABM("PNUM")="" ABM("PNUM")=$P($G(^VA(200,+ABM("X0"),9999999)),U,8)
 I ABM("PNUM")="",(ABMNPIUS'="N") S ABME(115)=""
 ;
COV ;
 I $P(^ABMDEXP(ABMP("EXP"),0),U)[837!($G(ABMP("EXP"))=25) D
 .Q:'("OAR"[$P(ABM("X0"),U,2))
 .Q:$$PTAX^ABMEEPRV(+ABM("X0"))'=""
 .S ABME(190)=""
 Q:$G(ABMP("COV"))=""
 Q:$G(ABM("DISC"))=""
 F ABMX("C")=1:1 S ABM("COVD")=$P(ABMP("COV"),";",ABMX("C")) Q:'ABM("COVD")  D
 .S ABM("COVD")=$P($G(^VA(200,$P(ABM("X0"),U),"PS")),U,5)
 .Q:$P($G(^AUTTPIC(ABMP("COV"),15,ABM("COVD"),0)),"^",2)'="U"
 .S ABME(160)=""
 Q
 ;
CONTR ;EP - Entry Point to determine if Contract Provider
 S:'$D(ABMP("CDFN")) ABMP("CDFN")=ABMP("BDFN")
 S ABM("CONTRACT")=0
 S ABMX("D")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","A","")) I ABMX("D")]"",$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,ABMX("D"),0)),$P($G(^VA(200,$P(^(0),U),9999999)),U)=2 S ABM("CONTRACT")=1 Q
 S ABMX("D")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","O","")) I ABMX("D")]"",$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,ABMX("D"),0)),$P($G(^VA(200,$P(^(0),U),9999999)),U)=2 S ABM("CONTRACT")=1
 Q
 ;
AFFL ;EP - Entry Point to determine Provider's Affiliation
 Q:ABM("MD")  Q:$P($G(^VA(200,+ABM("X0"),"PS")),U,5)=""  Q:$P($G(^DIC(7,$P(^("PS"),U,5),9999999)),U)=""  S ABM("MD")=$P(^(9999999),U)
 S ABM("MD")=$S(ABM("MD")="00"!(ABM("MD")>69&(ABM("MD")<87))!(ABM("MD")=49)!(ABM("MD")=18)!(ABM("MD")=25)!(ABM("MD")=33)!(ABM("MD")=41)!(ABM("MD")=44)!(ABM("MD")=45):1,1:0)
 Q
