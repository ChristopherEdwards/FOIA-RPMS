ABMDF34A ; IHS/SD/SDR - ADA 2012 Dental Export -part 2 ;    
 ;;2.6;IHS 3P BILLING SYSTEM;**11**;NOV 12, 2009;Build 133
 ;********************************************
ENT ; EP for getting data
 S ABMP("B0")=^ABMDBILL(DUZ(2),ABMP("BDFN"),0)  ;3P Bill 0 node
 S ABMP("INS")=$P(ABMP("B0"),U,8)  ;Active ins
 S ABMP("PDFN")=$P(ABMP("B0"),U,5)  ;Pt IEN
 S ABMP("LDFN")=$P(ABMP("B0"),U,3)  ;Loc IEN
 S ABMP("VTYP")=$P(ABMP("B0"),U,7)  ;VTyp
 S ABMP("BTYP")=$P(ABMP("B0"),U,2)  ;BTyp
 Q:'ABMP("PDFN")!'ABMP("LDFN")!'ABMP("INS")
 S ABMP("VDT")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),U)  ;Vst Dt
BADDR ;
 ; Billing Addr
 S ABM("J")=ABMP("BDFN")
 S ABM("I")=$P(^AUTNINS(ABMP("INS"),0),U)_"-"_ABMP("INS")
 S ABM("INS",ABM("I"),ABM("J"))=""
 I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS"),".211","I"),1,"I")="N" D
 .S ABM("INS",ABM("I"),ABM("J"))=ABMP("PDFN")
 S ABM("IDFN")=ABMP("INS")
 D BADDR^ABMDLBL1
 G PAT:'$D(ABM("ADD"))
 S ABMF(7)=$P(ABM("ADD"),U,1)  ;Ins Name(3)
 S ABMF(8)=$P(ABM("ADD"),U,2)  ;Ins Addr(3)
 S ABMF(9)=$P(ABMCSZ,U)  ;City(3)
 S ABMSTATE=$P(ABMCSZ,U,2)  ;St(3)
 S ABMF(9)=ABMF(9)_", "_$P($G(^DIC(5,+ABMSTATE,0)),U,2)
 S ABMF(9)=ABMF(9)_"  "_$P(ABMCSZ,U,3)  ;Zip(3)
 K ABMCSZ,ABMSTATE
 ;2ndary info
 S ABMPIIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"B",ABMP("INS"),0))
 K ABMSCNT,ABMSINS,ABMP("INS2")
 I +$G(ABMPIIEN)'=0 D
 .S ABMPINS=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMPIIEN,0)),U,2)  ;get priority of active ins
 .S ABMIFLG=0
 .S ABMSCNT=ABMPINS
 .F  S ABMSCNT=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABMSCNT)) Q:+ABMSCNT=0  D  Q:ABMIFLG=1
 ..S ABMSINS=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABMSCNT,0))
 ..I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U,3)="U" K ABMSINS Q  ;unbillable
 ..S ABMIFLG=1
 I $G(ABMSINS)'="" S ABMP("INS2")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U)
 I $G(ABMP("INS2"))'="" D
 .S ABMPISAV=ABMP("INS")
 .S ABMP("INS")=ABMP("INS2")
 .S ABM("J")=ABMP("BDFN")
 .S ABM("I")=$P(^AUTNINS(ABMP("INS"),0),U)_"-"_ABMP("INS")
 .S ABM("INS",ABM("I"),ABM("J"))=""
 .I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS"),".211","I"),1,"I")="N" D
 ..S ABM("INS",ABM("I"),ABM("J"))=ABMP("PDFN")
 .S ABM("IDFN")=ABMP("INS")
 .D BADDR^ABMDLBL1
 .G PAT:'$D(ABM("ADD"))
 .S $P(ABMF(20),U)=$P(ABM("ADD"),U,1)  ;2ndary Name(11)
 .S $P(ABMF(21),U)=$P(ABM("ADD"),U,2)  ;2ndary Addr(11)
 .S $P(ABMF(22),U)=$P(ABMCSZ,U)  ;2ndary City(11)
 .S ABMSTATE=$P(ABMCSZ,U,2)  ;2ndary ST(11)
 .S $P(ABMF(22),U)=$P(ABMF(22),U)_", "_$P($G(^DIC(5,+ABMSTATE,0)),U,2)  ;2ndary ST(11)
 .S $P(ABMF(22),U)=$P(ABMF(22),U)_"  "_$P(ABMCSZ,U,3)  ;2ndary Zip(11)
 .K ABMCSZ,ABMSTATE
 .S ABMP("INS")=ABMPISAV
 .;2ndary grp#(9)
 .I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U,4) S ABMX("PH")=ABMP("PDFN")
 .I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U,5) S ABMX("PH")=ABMP("PDFN")
 .I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U,6) S ABMX("PH")=$P($G(^AUPNMCD($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0),U,6),0)),U,9)
 .I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U,8),($P($G(^AUPNPRVT(ABMP("PDFN"),11,$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0),U,8),0)),U,8)'="") D
 ..S ABMX("PH")=$P(^AUPNPRVT(ABMP("PDFN"),11,$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0),U,8),0),U,8)
 .I +$G(ABMX("PH"))'=0 D
 ..S ABMX("GRP")=$P($G(^AUPN3PPH(+ABMX("PH"),0)),U,6)
 ..I $P($G(^AUPN3PPH(+ABMX("PH"),0)),U,8)="M" S $P(ABMF(16),U,2)="X"  ;sex(7)
 ..I $P($G(^AUPN3PPH(+ABMX("PH"),0)),U,8)="F" S $P(ABMF(16),U,3)="X"  ;sex(7)
 ..S $P(ABMF(16),U,4)=$P($G(^AUPN3PPH(+ABMX("PH"),0)),U,4)  ;Pol#(8)
 ..;rel (10)
 ..I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS2"),".211","I"),1,"I")="P" D
 ...S ABMSINS=$O(^AUPNPRVT(ABMP("PDFN"),11,"B",ABMP("INS2"),0))
 ...S ABMP("REL")=$P($G(^AUTTRLSH($P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMSINS,0)),U,5),0)),U,5)
 ...I ABMP("REL")=17 S $P(ABMF(18),U,2)="X"
 ...I ABMP("REL")="01" S $P(ABMF(18),U,3)="X"
 ...I ABMP("REL")=18 S $P(ABMF(18),U,4)="X"
 ...I ABMP("REL")'=17&(ABMP("REL")'=18)&(ABMP("REL")'="01") S $P(ABMF(18),U,5)="X"
 .I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS2"),".211","I"),1,"I")="D" D
 ..I $P($G(^DPT(+ABMP("PDFN"),0)),U,2)="M" S $P(ABMF(16),U,2)="X"  ;sex(7)
 ..I $P($G(^DPT(+ABMP("PDFN"),0)),U,2)="F" S $P(ABMF(16),U,3)="X"  ;sex(7)
 ..S:(+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U,6)'=0) $P(ABMF(16),U,4)=$P($G(^AUPNMCD($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0),U,6),0)),U,3)  ;Policy#(8)
 ..S $P(ABMF(18),U,2)="X"  ;rel.(10)
 .I $G(ABMX("GRP"))'="" D
 ..I $D(^AUTNEGRP(ABMX("GRP"),0)) D
 ...S $P(ABMF(18),U)=$S($D(^AUTNEGRP(ABMX("GRP"),11,ABMP("VTYP"),0)):$P(^(0),U,2),1:$P(^AUTNEGRP(ABMX("GRP"),0),U,2))
PAT ;Pt Info
 D PAT^ABMDF34B
LOC ;loc info
 S $P(ABMF(54),U)=$S($P(ABMV("X1"),U,2)]"":$P(ABMV("X1"),U,2),1:$P($P(ABMV("X1"),U),";",2))  ;billing entity name(48)
 S $P(ABMF(55),U)=$P(ABMV("X1"),U,3)  ;addr(48)
 I DUZ(2)=1581 S $P(ABMF(55),U)="PO BOX 4342"
 S ABMCSZ=$P(ABMV("X1"),U,4)
 S $P(ABMF(56),U)=$P(ABMCSZ,",",1)  ;City(48)
 S ABMCSZ=$P(ABMCSZ,",",2)
 S $P(ABMF(56),U)=$P(ABMF(56),U)_", "_$P(ABMCSZ," ",2)  ;ST(48)
 S $P(ABMF(56),U)=$P(ABMF(56),U)_"  "_$P(ABMCSZ," ",4)  ;zip(48)
 I DUZ(2)=1581 S $P(ABMF(56),U)="San Felipe Pueblo, NM  87001"
 ;
 I $P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL" D
 .S $P(ABMF(55),U)=$P($G(^DIC(4,ABMP("LDFN"),1)),U)  ;addr(48)
 .S $P(ABMF(56),U)=$P($G(^DIC(4,ABMP("LDFN"),1)),U,3)  ;city(48)
 .S ABMX("STATE")=$P($G(^DIC(4,ABMP("LDFN"),0)),U,2)  ;st(48)
 .S ABMX("STATE")=$P($G(^DIC(5,+ABMX("STATE"),0)),U,2)
 .I ABMX("STATE")'="" D
 ..S $P(ABMF(56),U)=$P(ABMF(56),U)_", "_ABMX("STATE")_" "_$P($G(^DIC(4,ABMP("LDFN"),1)),U,4)  ;zip(48)
 .I $P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2)="AIDC" D
 ..S $P(ABMF(55),U)="P.O. Box 31001-0674"  ;addr(48)
 ..S $P(ABMF(56),U)="Pasadena, CA  91110-0674"  ;city(48)
 K ABMCSZ
 S $P(ABMF(59),U,3)=$P(ABMV("X1"),U,6)  ;SSN/TIN(51)
 I DUZ(2)=1581 S $P(ABMF(59),U,3)="850210848"
 S $P(ABMF(60),U,1)=$P(ABMV("X1"),U,5)  ;Phone(52)
 S $P(ABMF(60),U,1)=$P(ABMV("X1"),U,5)  ;Phone(52)
 S ABMLOC=$P(ABMP("B0"),U,3)
 S ABMV("X1")=$G(^AUTTLOC(ABMLOC,0))
 S $P(ABMF(58),U)=$P($G(^DIC(4,ABMP("LDFN"),1)),U)  ;addr(56)
 S $P(ABMF(59),U,4)=$P($G(^DIC(4,ABMP("LDFN"),1)),U,3)  ;city(56)
 S ABMX("STATE")=$P($G(^DIC(4,ABMP("LDFN"),0)),U,2)  ;st(56)
 S ABMX("STATE")=$P($G(^DIC(5,+ABMX("STATE"),0)),U,2)
 I ABMX("STATE")'="" D
 .S $P(ABMF(59),U,4)=$P(ABMF(59),U,4)_", "_ABMX("STATE")_" "_$P($G(^DIC(4,ABMP("LDFN"),1)),U,4)  ;zip(56)
 I $P(ABMF(58),U)="" D  ;default to mailing addr if no physical addr
 .S $P(ABMF(58),U)=$P(ABMV("X1"),U,12)  ;addr(56)
 .S $P(ABMF(59),U,4)=$P(ABMV("X1"),U,13)  ;city(56)
 .S ABML=$P(ABMV("X1"),U,14)
 .S $P(ABMF(59),U,4)=$P(ABMF(59),U,4)_", "_$P(^DIC(5,ABML,0),U,2)  ;st(56)
 .S $P(ABMF(59),U,4)=$P(ABMF(59),U,4)_"  "_$P(ABMV("X1"),U,15)  ;zip(56)
 S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 S $P(ABMF(59),U)=$S($P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U)>0:$P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U),1:"")  ;Location NPI (49)
 I DUZ(2)=1581 S $P(ABMF(59),U)="1265511299"
 I ABMP("LDFN")=5440 D  ;Klamath
 .S $P(ABMF(58),U)="330 Chiloquin BLVD"  ;addr(56)
 .S $P(ABMF(59),U,4)="Chiloquin"  ;city(56)
 .S ABMX("STATE")="Oregon"  ;st(56)
 .S $P(ABMF(59),U,4)=$P(ABMF(59),U,4)_", "_ABMX("STATE")_" 97624"  ;zip(56)
INSNUM ;Ins Info
 S ABM("INUM")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,$P(ABMP("B0"),U,7),0)),U,8)
 S:ABM("INUM")="" ABM("INUM")=$P($G(^AUTNINS(ABMP("INS"),15,ABMP("LDFN"),0)),U,2)
 I ABM("INUM")="" D
 .S ABMPRV=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 .S:ABMPRV ABMPRV=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,ABMPRV,0)),U)
 .S:ABMPRV ABM("INUM")=$P($G(^VA(200,ABMPRV,9999999.18,ABMP("INS"),0)),U,2)
 S $P(ABMF(59),U,2)=ABM("INUM")  ;Dent Lic(55)
 S ABMP("ITYP")=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMP("INS"),".211","I"),1,"I")  ;Ins.type
 I ABMP("ITYP")="D" D
 .S ABMMCD=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMP("INS"),0)),U,6)
PRV ;Prov?
 D PRV^ABMDF34B
POL ;Pol. Info
 D POL^ABMDF34B
EMPL ;Emp. info
 I ABMP("ITYP")'="P" S $P(ABMF(12),U,4)=$P(ABMV("X3"),U)  ;Employer name(17)
 E  D
 .S ABMP("PH")=$P(ABMV("X2"),U)
 .S ABMEMPL=$P($G(^AUPN3PPH(+ABMP("PH"),0)),U,16)
 .S:+ABMEMPL $P(ABMF(12),U,4)=$P($G(^AUTNEMPL(ABMEMPL,0)),U)
 S $P(ABMF(12),U,3)=$P(ABMV("X3"),U,7)  ;Grp#(16)
REL ;Rel
 G INS:'$P(ABMV("X2"),U,2)
 S ABM=+$P($G(^AUTTRLSH(+$P(ABMV("X2"),U,2),0)),U,2)
 I ABM,ABM<8,ABM'=2 S $P(ABMF(15),U,$S(ABM=1:1,ABM=3:3,1:4))="X"  ;Rel to subscbr(18)
 E  S $P(ABMF(15),U,$S(ABM=2:2,ABM=1:1,1:4))="X"
INS ;
 D ^ABMDF34B
XIT ;
 K ABM,ABMV
 Q
