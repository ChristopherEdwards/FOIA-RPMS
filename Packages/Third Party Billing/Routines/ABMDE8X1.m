ABMDE8X1 ; IHS/ASDST/DMJ - Page 8 - ERROR CHECKS-CONT ;
 ;;2.6;IHS 3P BILLING SYSTEM;**8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code for page 8K error checks; also added
 ;    to page 8H error checks for ambulance billing
 ; IHS/SD/SDR - v2.5 p9 - task 1
 ;    Added code to check for provider address
 ; IHS/SD/SDR - v2.5 p10 - IM20394
 ;   Added code for new error 217
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;   Added code for NPI errors 220 and 221
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
E1 ;EP - Entry Point Page 8E error checks cont
 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,0)
 I ^ABMDEXP(ABMMODE(5),0)["UB" D
 .I $P(ABMX("X0"),U,2)="" S ABME(121)=""
 I (^ABMDEXP(ABMMODE(5),0)["HCFA")!(^ABMDEXP(ABMMODE(5),0)["CMS") D
 .I $P(ABMX("X0"),"^",9)="" S ABME(122)=""
 .S ABMCODXS=$P(ABMX("X0"),U,9)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...;start old code abm*2.6*8 NOHEAT
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX
 ...;end old code start new code
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ...;end new code
 I $P(ABMX("X0"),U,3)="" S ABME(123)=""
 I $P(ABMX("X0"),U,4)="" S ABME(126)=""
 I +$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",$P(ABMX("X0"),U),0))'=0 D
 .Q:ABMMODE(5)'=22  ;837P only
 .Q:'$D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",$P(ABMX("X0"),U)))
 .S ABMIIEN=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,"B",$P(ABMX("X0"),U),0))
 .Q:$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),4,ABMIIEN,0)),U,2)'="Y"  ;quit if not required
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,0)),U,19)="" S ABME(233)=""
 .I +$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,0)),U,21)=0 S ABME(233)=""  ;lab result req'd
 I ABMMODE(5)=22!(ABMMODE(5)=27) D
 .S ABMPIEN=0
 .F  S ABMPIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,"P",ABMPIEN)) Q:+ABMPIEN=0  D
 ..S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,"P",ABMPIEN,0)),U)
 ..;start old code abm*2.6*8 NOHEAT
 ..;I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX,1:ABME(220)_","_ABMX)
 ..;I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX,1:ABME(221)_","_ABMX)
 ..;end old code start new code
 ..I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX("I"),1:ABME(220)_","_ABMX("I"))
 ..I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX("I"),1:ABME(221)_","_ABMX("I"))
 ..;end new code
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,"P",ABMPIEN,0)),U,2)'="D"
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),37,ABMX,"P",ABMPIEN,0)),U)
 ..I $P($G(^VA(200,ABMPRV,.11)),U)="" S ABME(216)=ABMX  ;provider street
 ..I $P($G(^VA(200,ABMPRV,.11)),U,4)="" S ABME(216)=ABMX  ;city
 ..I $P($G(^VA(200,ABMPRV,.11)),U,5)="" S ABME(216)=ABMX  ;state
 ..I $P($G(^VA(200,ABMPRV,.11)),U,6)="" S ABME(216)=ABMX  ;zip
 K ABMPIEN
 Q
 ;
F1 ;EP - Entry Point Page 8F error checks cont
 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,0)
 I ^ABMDEXP(ABMMODE(6),0)["UB" D
 .I $P(ABMX("X0"),U,2)="" S ABME(121)=""
 I (^ABMDEXP(ABMMODE(6),0)["HCFA")!(^ABMDEXP(ABMMODE(6),0)["CMS") D
 .I $P(ABMX("X0"),"^",8)="" S ABME(122)=""
 .S ABMCODXS=$P(ABMX("X0"),U,8)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...;start old code abm*2.6*8 NOHEAT
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX
 ...;end old code start new code
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ...;end new code
 I $P(ABMX("X0"),U,3)="" S ABME(123)=""
 I $P(ABMX("X0"),U,4)="" S ABME(126)=""
 I ABMMODE(6)=22!(ABMMODE(6)=27) D
 .S ABMPIEN=0
 .F  S ABMPIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,"P",ABMPIEN)) Q:+ABMPIEN=0  D
 ..S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,"P",ABMPIEN,0)),U)
 ..;start old code abm*2.6*8 NOHEAT
 ..;I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX,1:ABME(220)_","_ABMX)
 ..;I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX,1:ABME(221)_","_ABMX)
 ..;end old code start new code
 ..I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX("I"),1:ABME(220)_","_ABMX("I"))
 ..I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX("I"),1:ABME(221)_","_ABMX("I"))
 ..;end new code
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,"P",ABMPIEN,0)),U,2)'="D"
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),35,ABMX,"P",ABMPIEN,0)),U)
 ..I $P($G(^VA(200,ABMPRV,.11)),U)="" S ABME(216)=ABMX  ;provider street
 ..I $P($G(^VA(200,ABMPRV,.11)),U,4)="" S ABME(216)=ABMX  ;city
 ..I $P($G(^VA(200,ABMPRV,.11)),U,5)="" S ABME(216)=ABMX  ;state
 ..I $P($G(^VA(200,ABMPRV,.11)),U,6)="" S ABME(216)=ABMX  ;zip
 K ABMPIEN
 Q
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
 ...;start old code abm*2.6*8 NOHEAT
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX
 ...;end old code start new code
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ...;end new code
 I $P(ABMX("X0"),U,3)="" S ABME(132)=""
 I $P(ABMX("X0"),U,4)="" S ABME(126)=""
 I ABMMODE(7) D
 .S ABMPIEN=0
 .F  S ABMPIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,"P",ABMPIEN)) Q:+ABMPIEN=0  D
 ..S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABMX,"P",ABMPIEN,0)),U)
 ..;start old code abm*2.6*8 NOHEAT
 ..;I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX,1:ABME(220)_","_ABMX)
 ..;I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX,1:ABME(221)_","_ABMX)
 ..;end old code start new code
 ..I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX("I"),1:ABME(220)_","_ABMX("I"))
 ..I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX("I"),1:ABME(221)_","_ABMX("I"))
 ..;end new code
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
 I $P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)["A3" D
 .S ABMCIEN=0
 .F  S ABMCIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,"B",ABMCIEN)) Q:ABMCIEN=""  D
 ..I $P($$CPT^ABMCVAPI(ABMCIEN,ABMP("VDT")),U,2)="J3490",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),10)),U)="") S ABME(210)=""  ;CSV-c
 ..S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,"B",ABMCIEN,0))
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMIEN,0)),U,5)="QL" S ABME(212)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMIEN,0)),U,8)="QL" S ABME(212)=""
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMIEN,0)),U,9)="QL" S ABME(212)=""
 I ABMMODE(8)=22!(ABMMODE(8)=27) D
 .S ABMPIEN=0
 .F  S ABMPIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,"P",ABMPIEN)) Q:+ABMPIEN=0  D
 ..S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABMX,"P",ABMPIEN,0)),U)
 ..;start old code abm*2.6*8 NOHEAT
 ..;I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX,1:ABME(220)_","_ABMX)
 ..;I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX,1:ABME(221)_","_ABMX)
 ..;end old code start new code
 ..I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX("I"),1:ABME(220)_","_ABMX("I"))
 ..I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX("I"),1:ABME(221)_","_ABMX("I"))
 ..;end new code
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
 I (^ABMDEXP(ABMMODE(8),0)["HCFA")!(^ABMDEXP(ABMMODE(8),0)["CMS") D
 .I $P(ABMX("X0"),"^",6)="" S ABME(122)=""
 .S ABMCODXS=$P(ABMX("X0"),U,6)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...;start old code abm*2.6*8 NOHEAT
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX
 ...;end old code start new code
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ...;end new code
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
