ABMDE8X3 ; IHS/SD/SDR - Page 8 - ERROR CHECKS-CONT ;
 ;;2.6;IHS 3P BILLING SYSTEM;**8,9,13**;NOV 12, 2009;Build 213
 ;IHS/SD/SDR - 2.6*13 - Added check for new export mode 35
 ;
G1 ;EP - Entry Point Page 8G error checks cont
 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,0)
 I ^ABMDEXP(ABMMODE(7),0)["UB" D
 .I $P(ABMX("X0"),U,2)="" S ABME(121)=""
 I (^ABMDEXP(ABMMODE(7),0)["HCFA")!(^ABMDEXP(ABMMODE(7),0)["CMS") D
 .I $P(ABMX("X0"),"^",10)="" S ABME(122)=""
 .S ABMCODXS=$P(ABMX("X0"),U,10)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...;start old abm*2.6*8 NOHEAT
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX
 ...;end old start new
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ...;end new
 I $P(ABMX("X0"),U,3)="" S ABME(132)=""
 I $P(ABMX("X0"),U,4)="" S ABME(126)=""
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U)))&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,2)),U,2)="") D  ;abm*2.6*9 NARR
 .Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;abm*2.6*9 NARR
 .K ABMP("CPTNT") S ABMP("CPTNT")=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U),0))  ;abm*2.6*9 NARR
 .Q:($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMP("CPTNT"),0)),U,2)'="Y")  ;abm*2.6*9 NARR
 .S ABME(241)=$S('$D(ABME(241)):ABMX("I"),1:ABME(241)_","_ABMX("I"))  ;abm*2.6*9 NARR
 I ABMMODE(7) D
 .S ABMPIEN=0
 .F  S ABMPIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,"P",ABMPIEN)) Q:+ABMPIEN=0  D
 ..S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,"P",ABMPIEN,0)),U)
 ..;start old abm*2.6*8 NOHEAT
 ..;I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX,1:ABME(220)_","_ABMX)
 ..;I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX,1:ABME(221)_","_ABMX)
 ..;end old start new
 ..I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX("I"),1:ABME(220)_","_ABMX("I"))
 ..I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX("I"),1:ABME(221)_","_ABMX("I"))
 ..;end new
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,"P",ABMPIEN,0)),U,2)'="D"
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,"P",ABMPIEN,0)),U)
 ..I $P($G(^VA(200,ABMPRV,.11)),U)="" S ABME(216)=ABMX  ;provider street
 ..I $P($G(^VA(200,ABMPRV,.11)),U,4)="" S ABME(216)=ABMX  ;city
 ..I $P($G(^VA(200,ABMPRV,.11)),U,5)="" S ABME(216)=ABMX  ;state
 ..I $P($G(^VA(200,ABMPRV,.11)),U,6)="" S ABME(216)=ABMX  ;zip
 K ABMPIEN
 Q
 ;
H1 ;EP - Entry Point Page 8H error checks cont
 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,0)
 I ^ABMDEXP(ABMMODE(8),0)["UB" D
 .I $P(ABMX("X0"),U,2)="" S ABME(121)=""
 I (^ABMDEXP(ABMMODE(8),0)["HCFA")!(^ABMDEXP(ABMMODE(8),0)["CMS") D
 .I $P(ABMX("X0"),"^",6)="" S ABME(122)=""
 .S ABMCODXS=$P(ABMX("X0"),U,6)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 I $P(ABMX("X0"),U,3)="" S ABME(123)=""
 I $P(ABMX("X0"),U,4)="" S ABME(126)=""
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U)))&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,2)),U,2)="") D  ;abm*2.6*9 NARR
 .Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;abm*2.6*9 NARR
 .K ABMP("CPTNT") S ABMP("CPTNT")=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U),0))  ;abm*2.6*9 NARR
 .Q:($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMP("CPTNT"),0)),U,2)'="Y")  ;abm*2.6*9 NARR
 .S ABME(241)=$S('$D(ABME(241)):ABMX("I"),1:ABME(241)_","_ABMX("I"))  ;abm*2.6*9 NARR
 I $P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)["A3" D
 .S ABMCIEN=0
 .F  S ABMCIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,"B",ABMCIEN)) Q:ABMCIEN=""  D
 ..I $P($$CPT^ABMCVAPI(ABMCIEN,ABMP("VDT")),U,2)="J3490",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),10)),U)="") S ABME(210)=""  ;CSV-c
 ..S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,"B",ABMCIEN,0))
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMIEN,0)),U,5)="QL" S ABME(212)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMIEN,0)),U,8)="QL" S ABME(212)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMIEN,0)),U,9)="QL" S ABME(212)=""
 ;I ABMMODE(8)=22!(ABMMODE(8)=27) D  ;abm*2.6*13 export mode 35
 I ABMMODE(8)=22!(ABMMODE(8)=27)!(ABMMODE(8)=35) D  ;abm*2.6*13 export mode 35
 .S ABMPIEN=0
 .F  S ABMPIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,"P",ABMPIEN)) Q:+ABMPIEN=0  D
 ..S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,"P",ABMPIEN,0)),U)
 ..;start old abm*2.6*8 NOHEAT
 ..;I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX,1:ABME(220)_","_ABMX)
 ..;I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX,1:ABME(221)_","_ABMX)
 ..;end old start new
 ..I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX("I"),1:ABME(220)_","_ABMX("I"))
 ..I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX("I"),1:ABME(221)_","_ABMX("I"))
 ..;end new
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,"P",ABMPIEN,0)),U,2)'="D"
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,"P",ABMPIEN,0)),U)
 ..I $P($G(^VA(200,ABMPRV,.11)),U)="" S ABME(216)=ABMX  ;provider street
 ..I $P($G(^VA(200,ABMPRV,.11)),U,4)="" S ABME(216)=ABMX  ;city
 ..I $P($G(^VA(200,ABMPRV,.11)),U,5)="" S ABME(216)=ABMX  ;state
 ..I $P($G(^VA(200,ABMPRV,.11)),U,6)="" S ABME(216)=ABMX  ;zip
 K ABMPIEN
 Q
K1 ;EP - Entry Point Page 8K error checks cont
 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMX,0)
 I ^ABMDEXP(ABMMODE(8),0)["UB" D
 .I $P(ABMX("X0"),U,2)="" S ABME(121)=""
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U)))&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMX,2)),U,2)="") D  ;abm*2.6*9 NARR
 .Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;abm*2.6*9 NARR
 .K ABMP("CPTNT") S ABMP("CPTNT")=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",$P(ABMX("X0"),U),0))  ;abm*2.6*9 NARR
 .Q:($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMP("CPTNT"),0)),U,2)'="Y")  ;abm*2.6*9 NARR
 .S ABME(241)=$S('$D(ABME(241)):ABMX("I"),1:ABME(241)_","_ABMX("I"))  ;abm*2.6*9 NARR
 I (^ABMDEXP(ABMMODE(8),0)["HCFA")!(^ABMDEXP(ABMMODE(8),0)["CMS") D
 .I $P(ABMX("X0"),"^",6)="" S ABME(122)=""
 .S ABMCODXS=$P(ABMX("X0"),U,6)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...;start old abm*2.6*8 NOHEAT
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX
 ...;end old start new
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ...;end new
 I $P(ABMX("X0"),U,3)="" S ABME(123)=""
 I $P(ABMX("X0"),U,4)="" S ABME(126)=""
 I $P(ABMX("X0"),U,5)="" D
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,14)="",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,16)="") S ABME(209)=""
 I $P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)["A3" D
 .S ABMIEN=0
 .F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMIEN)) Q:ABMIEN=""  D
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMIEN,0)),U,5)="QL" S ABME(212)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMIEN,0)),U,8)="QL" S ABME(212)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),47,ABMIEN,0)),U,9)="QL" S ABME(212)=""
 Q