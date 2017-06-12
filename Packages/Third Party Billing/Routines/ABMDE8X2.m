ABMDE8X2 ; IHS/SD/SDR - Page 8 - ERROR CHECKS ; 
 ;;2.6;IHS Third Party Billing System;**13,19**;NOV 12, 2009;Build 300
 ;IHS/SD/SDR - 2.6*19 - HEAT173117 - Split from ABMDE8X due to size.
 ;
B1 ;
 S ABMX("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABMX(1),0)
 I $P($$IHSCPT^ABMCVAPI(+ABMX("X0"),ABMP("VDT")),U,2) S ABME(171)=$S('$D(ABME(171)):+ABMX("X0"),1:ABME(171)_","_+ABMX("X0"))  ;CSV-c
 I ^ABMDEXP(ABMMODE(2),0)["UB" D
 .I $P(ABMX("X0"),U,3)="" S ABME(121)=""
 I $P(ABMX("X0"),U,13)="" S ABME(123)=""
 I (^ABMDEXP(ABMMODE(2),0)["HCFA")!(^ABMDEXP(ABMMODE(2),0)["CMS") D
 .I $P(ABMX("X0"),U,4)="" S ABME(122)=""
 .S ABMCODXS=$P(ABMX("X0"),U,4)
 .I ABMCODXS'="" D
 ..F ABMJ=1:1 S ABMCODX=$P(ABMCODXS,",",ABMJ) Q:+$G(ABMCODX)=0  D
 ...;end old start new  ;abm*2.6*8
 ...;I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;ABM*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))'="") Q:ABME(217)[(ABMX("I"))  S ABME(217)=$G(ABME(217))_","_ABMX("I")  ;abm*2.6*14 HEAT163747
 ...I +$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMCODX,0))=0,($G(ABME(217))="") S ABME(217)=ABMX("I")
 ...;end new
 I $P(ABMX("X0"),U,5)="" S ABME(125)=""
 I $P(ABMX("X0"),U,6)="" S ABME(124)=""
 I $P(ABMX("X0"),U,7)="" S ABME(126)=""
 I $P(ABMX("X0"),U,8)="Y" S ABME(164)=$S('$D(ABME(164)):ABMX("I"),1:ABME(164)_","_ABMX("I"))
 I $P(ABMX("X0"),U,5)]"",$P(ABMX("X0"),U,5)<ABMP("VDT") S ABME(127)=""
 I $G(ABMP("DDT")),$P(ABMX("X0"),U,5)]"",($P(ABMX("X0"),U,5)\1)>ABMP("DDT") S ABME(130)=""
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",+ABMX("X0")))&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABMX,2)),U,2)="") D  ;abm*2.6*9 NARR
 .Q:$P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["5010"  ;abm*2.6*9 NARR
 .K ABMP("CPTNT") S ABMP("CPTNT")=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,"B",+ABMX("X0"),0))  ;abm*2.6*9 NARR
 .Q:($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),5,ABMP("CPTNT"),0)),U,2)'="Y")  ;abm*2.6*9 NARR
 .S ABME(241)=$S('$D(ABME(241)):ABMX("I"),1:ABME(241)_","_ABMX("I"))  ;abm*2.6*9 NARR
 ;I ABMMODE(2)=22!(ABMMODE(2)=27) D  ;abm*2.6*13 export mode 35
 I ABMMODE(2)=22!(ABMMODE(2)=27)!(ABMMODE(2)=35) D  ;abm*2.6*13 export mode 35
 .S ABMPIEN=0
 .F  S ABMPIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABMX,"P",ABMPIEN)) Q:+ABMPIEN=0  D
 ..S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABMX,"P",ABMPIEN,0)),U)
 ..;start old new abm*2.6*8 NOHEAT
 ..I ABMNPIUS="N",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(220)=$S('$D(ABME(220)):ABMX("I"),1:ABME(220)_","_ABMX("I"))
 ..I ABMNPIUS="B",($P($$NPI^XUSNPI("Individual_ID",ABMPRV),U)<0) S ABME(221)=$S('$D(ABME(221)):ABMX("I"),1:ABME(221)_","_ABMX("I"))
 ..;end new
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABMX,"P",ABMPIEN,0)),U,2)'="D"
 ..S ABMPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABMX,"P",ABMPIEN,0)),U)
 ..I $P($G(^VA(200,ABMPRV,.11)),U)="" S ABME(216)=ABMX  ;provider street
 ..I $P($G(^VA(200,ABMPRV,.11)),U,4)="" S ABME(216)=ABMX  ;city
 ..I $P($G(^VA(200,ABMPRV,.11)),U,5)="" S ABME(216)=ABMX  ;state
 ..I $P($G(^VA(200,ABMPRV,.11)),U,6)="" S ABME(216)=ABMX  ;zip
 K ABMPIEN
 Q
 ;
D2 ;EP - this next section compares entries in V Med vs 23 multiple; will
 ;display warning if entry in V Med that's not in 23 multiple
 ;build array of V Med entries by drug with count of occurances
 ;  ABMMEDS(V MED IEN)=  P1=# OF V MED ENTRIES
 ;                       P2=# OF 23 MULTIPLE ENTRIES
 ;                       P3=DATE DISCONTINUED
 ;                       P4=RETURN TO STOCK DATE
 S ABMVIEN=0
 K ABMMEDS
 F  S ABMVIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMVIEN)) Q:+ABMVIEN=0  D
 .S ABMVDFN=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMVIEN,0)),U)
 .S ABM=0
 .F  S ABM=$O(^AUPNVMED("AD",ABMVDFN,ABM)) Q:'ABM  D
 ..I $P($G(^AUPNVMED(ABM,0)),U)'="" D
 ...S ABMMEDS($P(^AUPNVMED(ABM,0),U))=+$G(ABMMEDS($P(^AUPNVMED(ABM,0),U)))+1
 ...S $P(ABMMEDS($P(^AUPNVMED(ABM,0),U)),U,3)=$P($G(^AUPNVMED(ABM,0)),U,8)  ;date disc.
 ...S $P(ABMMEDS($P(^AUPNVMED(ABM,0),U)),U,4)=$P($G(^PSDRUG($P($G(^AUPNVMED(ABM,0)),U),2)),U,15)  ;RTS
 ;build array of 23-multiple entries by drug with count of occurances
 S ABMVIEN=0
 F  S ABMVIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMVIEN)) Q:+ABMVIEN=0  D
 .S ABMVDATA=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,ABMVIEN,0)),U)
 .S $P(ABMMEDS(ABMVDATA),U,2)=$P(+$G(ABMMEDS(ABMVDATA)),U,2)+1
 ;now compare p1 and p2; p1 must be < or = p2
 S ABMVIEN=0,ABMVFLG=0
 K ABME(213)
 F  S ABMVIEN=$O(ABMMEDS(ABMVIEN)) Q:+ABMVIEN=0  D
 .K ABMVMED,ABM23M
 .S ABMVMED=$P(ABMMEDS(ABMVIEN),U)
 .S ABM23M=$P(ABMMEDS(ABMVIEN),U,2)
 .Q:ABMVMED=ABM23M
 .Q:ABM23M>ABMVMED
 .S ABMVFLG=1
 I $G(ABMVFLG)=1 S ABME(213)=""
 K ABMVFLG,ABMVIEN,ABMVMED,ABM23M
 Q
