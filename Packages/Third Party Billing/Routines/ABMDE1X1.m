ABMDE1X1 ; IHS/ASDST/DMJ - PAGE 1 - DATA CHECK CONT. ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6,8**;NOV 12, 2009
 ;
 ; IHS/ASDS/DMJ - 05/16/00 - V2.4 Patch 1 - NOIS HQW-0500-100040
 ;     Modified Location code to check for satellite first.  If no
 ;     satellite (ABMP("LDFN")), then use parent (DUZ(2))
 ;
 ; IHS/SD/SDR - V2.5 p12 - UFMS - Added errors 227 and 228 to check for parent/satellite ASUFACs
 ; IHS/SD/SDR - abm*2.6*6 - Added error 235 for facility missing NPI
 ; *********************************************************************
 ;
REMPL ;EP - Entry Pont for setting X3 array Employer Info
 ;
 ; Export Var: ABMV("X3")=EMPLOYER;ADDR 1^ADDR 2^PHONE^STATUS
 ;
 ;     where: EMPLOYER is the patient's employer
 ;
 I $P(^AUPNPAT(ABMP("PDFN"),0),U,19)]"",$D(^AUTNEMPL($P(^(0),U,19),0)) D
 .S ABMX("Y")=^AUTNEMPL($P(^AUPNPAT(ABMP("PDFN"),0),U,19),0)
 .S ABMV("X3")=$P(ABMX("Y"),U)
 E  S ABME(71)="" Q
 I $P(ABMX("Y"),U,2)]"",$P(ABMX("Y"),U,3)]"",$P(ABMX("Y"),U,4)]"",$P(ABMX("Y"),U,5)]""
 I  D
 .S $P(ABMV("X3"),U,2)=$P(ABMX("Y"),U,2)
 .S $P(ABMV("X3"),U,3)=$P(ABMX("Y"),U,3)_","
 .I $D(^DIC(5,$P(ABMX("Y"),U,4),0)) S $P(ABMV("X3"),U,3)=$P(ABMV("X3"),U,3)_$P(^(0),U,2)_"  "_$P(ABMX("Y"),U,5)
 E  S ABME(75)=""
 S $P(ABMV("X3"),U,4)=$P(ABMX("Y"),U,6)
 S ABMX("Y")=$P(^AUPNPAT(ABMP("PDFN"),0),U,21)
 I ABMX("Y")="" S ABME(72)="" Q
 S ABMX("Y0")=$P(^DD(9000001,.21,0),U,3)
 S ABMX("Y0")=$P($P(ABMX("Y0"),ABMX("Y")_":",2),";",1)
 S $P(ABMV("X3"),U,5)=ABMX("Y")_";"_ABMX("Y0")
 Q
 ;
 ; *********************************************************************
LOC ;EP - Entry Pont for setting X3 array Location Info
 ;
 ; export var: ABMV(X1)=LDFN;FACILTY^ADDR 1^ADDR 2^ADDR 3^PHONE^TAX NO
 ;
 ;    where: ADDR 1 - is only defined when payment is to be sent to
 ;                    another location (C/O)
 ;           ADDR 2 - is always the street address
 ;           ADDR 3 - is the city, state zip code
 ;
 ;    Note: The address corresponds to the facility's address when the
 ;          site is 638 or the Area Office's when it is not.
 ;
 I ABMP("LDFN")="" Q
 I '$D(^AUTTLOC(ABMP("LDFN"),0)) S ABME(108)="" Q
 I '$P($G(^ABMDPARM(DUZ(2),1,2)),U,3) S ABME(7)=""
 S ABMV("X1")=ABMP("LDFN")_";"
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),"^",6)="" D
 .S ABMV("X1")=ABMV("X1")_$S($P($G(^ABMDPARM(DUZ(2),1,2)),U,6)]"":$P(^(2),U,6),$D(^DIC(4,ABMP("LDFN"),0)):$P(^(0),U),1:$P(^AUTTLOC(ABMP("LDFN"),0),U,2))
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),"^",6)'="" D
 .S ABMV("X1")=ABMV("X1")_$P(^ABMDPARM(ABMP("LDFN"),1,2),"^",6)
 I $D(^AUTTLOC(ABMP("LDFN"),11,0))'=1 S ABME(151)=""
 S ABMX("AFFL")=""
 S ABMX("I")=0
 F  S ABMX("I")=$O(^AUTTLOC(ABMP("LDFN"),11,ABMX("I"))) Q:'ABMX("I")  D
 .S ABMX("IDT")=$S($P(^AUTTLOC(ABMP("LDFN"),11,ABMX("I"),0),U,2)]"":$P(^(0),U,2),1:9999999)
 .I ABMP("VDT")>$P(^AUTTLOC(ABMP("LDFN"),11,ABMX("I"),0),U)&(ABMP("VDT")<ABMX("IDT")) S ABMX("AFFL")=$P(^(0),U,3)
 I ABMX("AFFL")="" D
 .S ABME(151)=""
 .S ABMX("AFFL")=1
 ;start new code abm*2.6*6 5010
 I +$G(ABMP("EXP"))>20 D
 .Q:(ABMP("INS"))=""  ;abm*2.6*8 HEAT37612
 .S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 .I $P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U)<1 S ABME(235)=""
 ;end new code abm*2.6*6 5010
 I +$P($G(^ABMDPARM(DUZ(2),1,2)),U,3) D  G SITE
 .S ABMX("LOC")=$P(^ABMDPARM(DUZ(2),1,2),U,3)
 I ABMX("AFFL")=1,$P(^AUTTLOC(ABMP("LDFN"),0),U,4)]"",$D(^AUTTAREA($P(^(0),U,4),0)),$P(^(0),U,2)]"" S ABMX("LOC")=$O(^AUTTLOC("C",$P(^(0),U,2)_"0000","")) I ABMX("LOC")]""
 E  S ABMX("LOC")=ABMP("LDFN")
 ;
SITE ;
 S ABM("SA")=$S(ABMX("LOC")=ABMP("LDFN"):1,1:0)
 I 'ABM("SA") D
 . S $P(ABMV("X1"),U,2)=$S($P($G(^ABMDPARM(DUZ(2),1,2)),U,6)]"":$P(^(2),U,6),1:"C/O "_$S($D(^DIC(4,ABMX("LOC"),0)):$E($P(^(0),U),1,26),1:$P(^AUTTLOC(ABMX("LOC"),0),U,2)))
 I $D(^AUTTLOC(ABMX("LOC"),0)) D
 .S ABMNOTOK=1
 .Q:'($P(^AUTTLOC(ABMX("LOC"),0),U,12)]"")
 .Q:'($P(^AUTTLOC(ABMX("LOC"),0),U,13)]"")
 .Q:'($P(^AUTTLOC(ABMX("LOC"),0),U,14)]"")
 .Q:'($P(^AUTTLOC(ABMX("LOC"),0),U,15)]"")
 .K ABMNOTOK
 .S $P(ABMV("X1"),U,3)=$P(^AUTTLOC(ABMX("LOC"),0),U,12)
 .S $P(ABMV("X1"),U,4)=$P(^AUTTLOC(ABMX("LOC"),0),U,13)_", "
 I $G(ABMNOTOK),$D(ABMX("AFFL")) D  G TAX
 .S:ABM("SA") ABME(109)=""
 .S:'ABM("SA") ABME(152)=""
 .K ABMNOTOK
 S ABMX("STATE")=$P(^AUTTLOC(ABMX("LOC"),0),"^",14)
 S ABMX("STATE")=$P($G(^DIC(5,+ABMX("STATE"),0)),"^",2)
 I ABMX("STATE")'="" D
 .S $P(ABMV("X1"),U,4)=$P(ABMV("X1"),U,4)_ABMX("STATE")_"  "_$P(^AUTTLOC(ABMX("LOC"),0),U,15)
 .S $P(ABMV("X1"),U,5)=$P(^AUTTLOC(ABMX("LOC"),0),U,11)
 E  D
 .S:ABM("SA") ABME(109)=""
 .S:'ABM("SA") ABME(152)=""
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,14)=1 D  ;export
 .S:$G(ABMPAR)="" ABMPAR=$$FINDLOC^ABMUCUTL
 .S ABMPASUF=$$ASUFAC^ABMUCUTL(ABMPAR,ABMP("VDT"))
 .I ABMPASUF="" S ABME(227)=""
 .I ABMX("LOC")'=ABMP("LDFN") D
 ..S ABMUAOF=$P($G(^ABMDPARM(ABMP("LDFN"),1,4)),U,17)  ;use ASUFAC of
 ..S ABMSASUF=$$ASUFAC^ABMUCUTL($S(+$G(ABMUAOF)'=0:ABMUAOF,1:ABMP("LDFN")),ABMP("VDT"))
 ..I ABMSASUF="" S ABME(228)=""
 .K ABMPASUF,ABMSASUF
 ;
TAX ;
 S $P(ABMV("X1"),U,6)=$P(^AUTTLOC(ABMP("LDFN"),0),U,18)
 I $P(ABMV("X1"),U,6)="" S ABME(6)=$P(^AUTTLOC(ABMP("LDFN"),0),U,2)
 Q
