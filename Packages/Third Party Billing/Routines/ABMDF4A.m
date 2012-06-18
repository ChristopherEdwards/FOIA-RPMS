ABMDF4A ; IHS/ASDST/DMJ - ADA Dental Export -part 2 ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ;  IHS/DSD/DMJ - 7/20/98 - Patch 2 - NOIS XFA-0698-200102
 ;                Meds showing up on split bill for ADA  & HCFA.
 ;                Modified to show meds on HCFA only.
 ;                Also add code so claim generator will not bomb
 ;                if auto approve is turned on and Y2K fix to
 ;                print 4 digit year in 3 birthdate fields.
 ; IHS/ASDS/DMJ - 04/18/00 - V2.4 Patch 1 - NOIS HQW-0500-100040
 ;     Modified location code to check for satellite first.  If no
 ;     satellite use parent.
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM12859
 ;    Modified code to print Dentist License Number
 ;
ENT ;EP for getting data
 S ABMP("B0")=^ABMDBILL(DUZ(2),ABMP("BDFN"),0),ABMP("INS")=$P(^(0),U,8)
 S ABMP("PDFN")=$P(ABMP("B0"),U,5),ABMP("LDFN")=$P(ABMP("B0"),U,3)
 S ABMP("VTYP")=$P(ABMP("B0"),U,7),ABMP("BTYP")=$P(ABMP("B0"),U,2)
 Q:'ABMP("PDFN")!'ABMP("LDFN")!'ABMP("INS")
 S ABMP("VDT")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),U)
 ;
BADDR S ABM("J")=ABMP("BDFN"),ABM("I")=$P(^AUTNINS(ABMP("INS"),0),U)_"-"_ABMP("INS")
 S ABM("INS",ABM("I"),ABM("J"))=""
 I $P($G(^AUTNINS(ABMP("INS"),2)),U)="N" D
 .S ABM("INS",ABM("I"),ABM("J"))=ABMP("PDFN")
 S ABM("IDFN")=ABMP("INS") D BADDR^ABMDLBL1 G PAT:'$D(ABM("ADD"))
 S ABMF(1)=U_$P(ABM("ADD"),U,1),ABMF(2)="X"_U_$P(ABM("ADD"),U,2),ABMF(3)=$P(ABM("ADD"),U,3)
 ;
PAT S ABM("P0")=^DPT(ABMP("PDFN"),0)
 S ABMF(6)=$P(ABM("P0"),U)_U_U_U_U_$S($P(ABM("P0"),U,2)="M":"X"_U,1:U_"X")
 S ABMF(6)=ABMF(6)_"^"_$E($P(ABM("P0"),U,3),4,5)_U_$E($P(ABM("P0"),U,3),6,7)_U_($E($P(ABM("P0"),U,3),1,3)+1700)
 K ABM("P0")
 S (ABMV("X1"),ABMV("X2"),ABMV("X3"))=""
 D PAT^ABMDE1X,REMPL^ABMDE1X1,LOC^ABMDE1X1 K ABME
LOC S $P(ABMF(23),U)=$P($P(ABMV("X1"),U),";",2)
 S $P(ABMF(25),U)=$P(ABMV("X1"),U,3),$P(ABMF(27),U)=$P(ABMV("X1"),U,4)
 S $P(ABMF(29),U)=$P(ABMV("X1"),U,6),$P(ABMF(29),U,3)=$P(ABMV("X1"),U,5)
 ;
INSNUM ;
 S ABM("INUM")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,$P(ABMP("B0"),U,7),0)),U,8)
 S:ABM("INUM")="" ABM("INUM")=$P($G(^AUTNINS(ABMP("INS"),15,ABMP("LDFN"),0)),U,2)
 I ABM("INUM")="" D
 .S ABMPRV=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 .S:ABMPRV ABMPRV=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,ABMPRV,0)),U)
 .S:ABMPRV ABM("INUM")=$P($G(^VA(200,ABMPRV,9999999.18,ABMP("INS"),0)),U,2)
 S $P(ABMF(29),U,2)=ABM("INUM")
 ;
PRV S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0)) I ABM("X") D
 .D SELBILL^ABMDE4X
 .S ABMF(57)=$P(ABM("A"),U)_U_ABM("PNUM")_U_DT
POL ;POLICY INFORMATION
 N I S I=0 F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I)) Q:'I  D
 .I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",3)="I" S ABM("XIEN")=I
 S Y=ABMP("INS"),ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_"," D SEL^ABMDE2X
 S $P(ABMF(8),U)=$P($P(ABMV("X2"),U),";",2)
 S $P(ABMF(9),U)=$P(ABMV("X2"),U,3)
 S $P(ABMF(10),U)=$P(ABMV("X2"),U,4)
 S $P(ABMF(10),U,2)=$P(ABMV("X1"),U,4)
 S $P(ABMF(10),U,3)=$E($P(ABMV("X2"),U,7),4,5)
 S $P(ABMF(10),U,4)=$E($P(ABMV("X2"),U,7),6,7)
 S $P(ABMF(10),U,5)=($E($P(ABMV("X2"),U,7),1,3)+1700)
EMPL S $P(ABMF(8),U,2)=$P(ABMV("X3"),U),$P(ABMF(9),U,3)=$P(ABMV("X3"),U,2),$P(ABMF(10),U,6)=$P(ABMV("X3"),U,3)
 S $P(ABMF(9),U,4)=$P(ABMV("X3"),U,6),$P(ABMF(10),U,7)=$P(ABMV("X3"),U,7)
REL G INS:'$P(ABMV("X2"),U,2)
 S ABM=+$P($G(^AUTTRLSH(+$P(ABMV("X2"),U,2),0)),U,2)
 I ABM,ABM<8,ABM'=2 S $P(ABMF(5),U,$S(ABM=1:1,1:2))="X"
 E  S $P(ABMF(6),U,$S(ABM=2:2,1:3))="X"
INS S ABM("I")=0 F  S ABM("I")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABM("I"))) Q:'ABM("I")  D
 .S ABM("XIEN")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABM("I"),0))
 .S ABM("INSCO")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM("XIEN"),0),U)
 .I ABM("INSCO")'=ABMP("INS") D  S ABM("I")=99
 ..I "U"[$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM("XIEN"),0)),U,3) Q
 ..S Y=ABM("INSCO"),ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_"," D SEL^ABMDE2X
 ..S $P(ABMF(12),U,3)=$P(^AUTNINS(ABM("INSCO"),0),U),$P(ABMF(13),U)=$P(^(0),U,2),$P(ABMF(14),U,3)=$$CSZ^ABMDUTL($P(^(0),U,3,5))
 ..S $P(ABMF(13),U,2)=$P(ABMV("X3"),U,6),$P(ABMF(14),U,4)=$P(ABMV("X3"),U,7)
 ..S $P(ABMF(12),U,5)=$P(ABMV("X3"),U),$P(ABMF(13),U,3)=$P(ABMV("X3"),U,2),$P(ABMF(14),U,5)=$P(ABMV("X3"),U,3)
 ..S $P(ABMF(17),U)=$P($P(ABMV("X2"),U),";",2)
 ..S $P(ABMF(17),U,2)=$P(ABMV("X1"),U,4)
 ..S $P(ABMF(17),U,3)=$E($P(ABMV("X2"),U,7),4,5)
 ..S $P(ABMF(17),U,4)=$E($P(ABMV("X2"),U,7),6,7)
 ..S $P(ABMF(17),U,5)=($E($P(ABMV("X2"),U,7),1,3)+1700)
 ..I $P(ABMV("X2"),U,2) D
 ...S ABM=+$P($G(^AUTTRLSH(+$P(ABMV("X2"),U,2),0)),U,2)
 ...I ABM,ABM<8,ABM'=2 S $P(ABMF(16),U,$S(ABM=1:2,1:3))="X"
 ...E  S $P(ABMF(17),U,$S(ABM=2:6,1:7))="X"
 ..I $P($G(^AUTNINS(ABM("INSCO"),2)),U,5)="O" S $P(ABMF(12),U)="X"
 ..E  S $P(ABMF(14),U)="X"
 S:$P($G(ABMF(12)),U)="" $P(ABMF(12),U,2)="X"
 S:$P($G(ABMF(14)),U)="" $P(ABMF(14),U,2)="X"
 ;
BNODES I $D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)) S ABM("B4")=$G(^(4)),ABM("B7")=$G(^(7)),ABM("B8")=$G(^(8)),ABM("B9")=$G(^(9))
 I $P(ABM("B9"),U)]"" S $P(ABMF(23),U,3)="X"
 E  S $P(ABMF(23),U,2)="X"
 ;
ACCD S $P(ABMF(25),U,$S('$P(ABM("B8"),U,3):2,"12"[$P(ABM("B8"),U,3):3,1:2))="X"
 S $P(ABMF(27),U,$S("12"[$P(ABM("B8"),U,3):2,1:3))="X"
FSYM S $P(ABMF(31),U)=$P(ABM("B8"),U,6)
 I $P(ABM("B7"),U,4)="Y" S ABMF(20)="SIGNATURE ON FILE"_U_DT
 I $P(ABM("B7"),U,5)="Y" S $P(ABMF(20),U,3)="SIGNATURE ON FILE",$P(ABMF(20),U,4)=DT
 S $P(ABMF(31),U,2)="X"
XRAY S $P(ABMF(31),U,$S($P(ABM("B4"),U,3):7,1:6))="X"
 S $P(ABMF(31),U,8)=$P(ABM("B4"),U,3)
ORTHO S $P(ABMF(31),U,$S($P(ABM("B4"),U,4):10,1:9))="X"
 I $P(ABM("B4"),U,4) S $P(ABMF(31),U,11)=$P(ABM("B4"),U,5)
PROTH S $P(ABMF(29),U,$S($P(ABM("B4"),U,6):5,1:4))="X"
 I $P(ABM("B4"),U,6) S $P(ABMF(29),U,6)=$P(ABM("B4"),U,7)
 S $P(ABMF(54),U)="Bill Number: "_$P(ABMP("B0"),U)_$S($P($G(^ABMDPARM(DUZ(2),1,1,2)),U,4)]"":"-"_$P(^(2),U,4),1:"") I $P($G(^(3)),U,3),$P($G(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)),U,2) S $P(ABMF(54),U)=$P(ABMF(54),U)_" "_$P(^(0),U,2)
 ;
XIT K ABM,ABMV
 Q
