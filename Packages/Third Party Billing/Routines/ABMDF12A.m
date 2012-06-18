ABMDF12A ; IHS/ASDST/DMJ - ADA Dental Export -part 2 ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;Original;TMD;08/13/96 11:47 AM
 ;
 ;  IHS/DSD/DMJ - 7/20/98 - NOIS XFA-0698-200102
 ;                Meds showing up on split bill for ADA & HCFA.
 ;                Modified to show meds on HCFA only
 ;                Also add code so claim generator will not bomb
 ;                if auto approve is turned on and Y2K fix to
 ;                print 4 digit year in 3 birthdate fields.
 ;
 ;IHS/DSD/DMJ - 5/5/1999 - NOIS PCB-0599-90008 Patch 1
 ;     Previous payments not printing in block #42
 ;     Payment by other plan, added a call to ABMERUTL and set 4th
 ;     piece of ABMF(58).
 ; IHS/ASDS/DMJ - 04/18/00 - V2.4 Patch 1 - NOIS HQW-0500-100040
 ;     Modified location code to check for satellite first.  If no
 ;     satellite use parent.
 ;
 ; IHS/ASDS/SDH - 04/10/2001 - V2.4 Patch 9 - NOIS NCA-0600-180055
 ;     Place provider number in box 1
 ;
 ; IHS/ASDS/SDH - 03/28/2001 - V2.4 Patch 9 - NOIS NEA-0301-180042
 ;     Correct ADA-94 form to print address of patient instead of 
 ;     NON-BENEFICIARY insurer.
 ;
 ; IHS/ASDS/SDH - 07/20/2001 - V2.4 Patch 9 - NOIS QAA-0601-130017
 ;     Modified code to print location of service as the site, not
 ;     where the bills are going.  This was a problem because of
 ;     payments going to PNC.  This affects form locator 40.
 ;
 ; IHS/ASDS/LSL - 08/20/2001 - V2.4 Patch 9 - NOIS HQW-0798-100082
 ;     For Policy holder information, if there is not an insurer in
 ;     "I" status in the insurer multiple of the bill, use the
 ;     active insurer.
 ;
 ; IHS/SD/SDR - V2.5 P2 - 4/17/02 - NOIS XXX-0302-200036 - Modified to append HRN to bill number
 ; IHS/SD/SDR - v2.5 p9 - IM14774 - Correction to block 1; shifted block 5 one to the left
 ; IHS/SD/SDR - v2.5 p9 - IM16991 - Added code for San Felipe VT 998
 ; IHS/SD/SDR - v2.5 p10 - IM20337 - Added code for page 9F
 ; IHS/SD/SDR - v2.5 p10 - IM21043 - Changed treatment address to physical address
 ;IHS/SD/SDR - abm*2.6*6 - HEAT27940 - Fix Today/Originate Date printing
 ;
 ; *********************************************************************
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
 S ABMF(2)="^^"_$P(ABM("ADD"),U,1),ABMF(3)="X^"_$P(ABM("ADD"),U,2),ABMF(4)="^^"_$P(ABM("ADD"),U,3)
 ;
PAT S ABM("P0")=^DPT(ABMP("PDFN"),0)
 S ABMF(7)=$P(ABM("P0"),U)_U_U_U_U_$S($P(ABM("P0"),U,2)="M":"X"_U,1:U_"X")_U
 S ABMF(7)=ABMF(7)_$E($P(ABM("P0"),U,3),4,5)_U_$E($P(ABM("P0"),U,3),6,7)_U_($E($P(ABM("P0"),U,3),1,3)+1700)
 K ABM("P0")
 ;
 S (ABMV("X1"),ABMV("X2"),ABMV("X3"))=""
 D PAT^ABMDE1X,REMPL^ABMDE1X1,LOC^ABMDE1X1 K ABME
LOC S $P(ABMF(24),U)=$S($P(ABMV("X1"),U,2)]"":$P(ABMV("X1"),U,2),1:$P($P(ABMV("X1"),U),";",2))
 I DUZ(2)=1581,(ABMP("VTYP")=998) S $P(ABMF(24),U)="SAN FELIPE HS"
 S $P(ABMF(26),U)=$P(ABMV("X1"),U,3),$P(ABMF(28),U)=$P(ABMV("X1"),U,4)
 I DUZ(2)=1581,(ABMP("VTYP")=998) S $P(ABMF(26),U)="PO BOX 4339",$P(ABMF(28),U)="SAN FELIPE, NM 87001"
 S $P(ABMF(30),U)=$P(ABMV("X1"),U,6),$P(ABMF(30),U,3)=$P(ABMV("X1"),U,5)
 I DUZ(2)=1581,(ABMP("VTYP")=998) S $P(ABMF(30),U)=850210848
 S ABMLOC=$P(ABMP("B0"),U,3)
 S ABMV("X1")=$G(^AUTTLOC(ABMLOC,0))
 S $P(ABMF(61),U)=$P(ABMV("X1"),U,12)
 S $P(ABMF(61),U,2)=$P(ABMV("X1"),U,13)
 S ABML=$P(ABMV("X1"),U,14)
 S $P(ABMF(61),U,3)=$P(^DIC(5,ABML,0),U,2)
 S $P(ABMF(61),U,4)=$P(ABMV("X1"),U,15)
 I $P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL" D
 .S $P(ABMF(26),U)=$P($G(^DIC(4,ABMP("LDFN"),1)),U)  ;address
 .S $P(ABMF(28),U)=$P($G(^DIC(4,ABMP("LDFN"),1)),U,3)  ;city
 .S ABMX("STATE")=$P($G(^DIC(4,ABMP("LDFN"),0)),U,2)  ;state
 .S $P(ABMF(28),U)=$P(ABMF(28),U)_", "_$P($G(^DIC(5,+ABMX("STATE"),0)),U,2)
 .S $P(ABMF(28),U)=$P(ABMF(28),U)_" "_$P($G(^DIC(4,ABMP("LDFN"),1)),U,4)  ;zip
 ;
INSNUM ;
 S ABM("INUM")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,$P(ABMP("B0"),U,7),0)),U,8)
 S:ABM("INUM")="" ABM("INUM")=$P($G(^AUTNINS(ABMP("INS"),15,ABMP("LDFN"),0)),U,2)
 S $P(ABMF(30),U,2)=ABM("INUM")
 ;
PRV S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0)) I ABM("X") D
 .D SELBILL^ABMDE4X
 .S $P(ABMF(4),U)=$G(ABM("PNUM"))
 .D PAYED^ABMERUTL
 .;S ABMF(58)=$P(ABM("A"),U)_U_ABM("PNUM")_U_DT_U_$G(ABMP("PAYED"))  ;abm*2.6*6 HEAT27940
 .S ABMF(58)=$P(ABM("A"),U)_U_ABM("PNUM")_U_U_$G(ABMP("PAYED"))  ;abm*2.6*6 HEAT27940
 .S $P(ABMF(58),U,3)=$S($G(ABMP("PRINTDT"))="O":$P($G(^ABMDTXST(DUZ(2),$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,7),0)),U),1:DT)  ;abm*2.6*6 HEAT27940
POL ;POLICY INFORMATION
 N I S I=0 F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I)) Q:'I  D
 .I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",3)="I" S ABM("XIEN")=I
 S:$G(ABM("XIEN"))="" ABM("XIEN")=+$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"B",ABMP("INS"),0))
 S Y=ABMP("INS"),ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","
 D SEL^ABMDE2X
 I ABM("ADD")["NON-BEN" D
 .S ABM("ADD")=ABMV("X2")
 .S ABMF(2)="^^"_$P($P(ABM("ADD"),U),";",2)
 .S ABMF(3)="^"_$P(ABM("ADD"),U,3)
 .S ABMF(4)="^^"_$P(ABM("ADD"),U,4)
 S $P(ABMF(9),U)=$P($P(ABMV("X2"),U),";",2)
 S $P(ABMF(10),U)=$P(ABMV("X2"),U,3)
 S $P(ABMF(11),U)=$P(ABMV("X2"),U,4)
 S $P(ABMF(11),U,2)=$P(ABMV("X1"),U,4)
 S $P(ABMF(11),U,3)=$E($P(ABMV("X2"),U,7),4,5)
 S $P(ABMF(11),U,4)=$E($P(ABMV("X2"),U,7),6,7)
 S $P(ABMF(11),U,5)=($E($P(ABMV("X2"),U,7),1,3)+1700)
EMPL S $P(ABMF(9),U,2)=$P(ABMV("X3"),U),$P(ABMF(10),U,3)=$P(ABMV("X3"),U,2),$P(ABMF(11),U,6)=$P(ABMV("X3"),U,3)
 S $P(ABMF(10),U,4)=$P(ABMV("X3"),U,6),$P(ABMF(11),U,7)=$P(ABMV("X3"),U,7)
REL G INS:'$P(ABMV("X2"),U,2)
 S ABM=+$P($G(^AUTTRLSH(+$P(ABMV("X2"),U,2),0)),U,2)
 I ABM,ABM<8,ABM'=2 S $P(ABMF(6),U,$S(ABM=1:1,1:2))="X"
 E  S $P(ABMF(7),U,$S(ABM=2:2,1:3))="X"
INS ;
 S ABM("I")=0
 F  S ABM("I")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABM("I"))) Q:'ABM("I")  S ABM=$O(^(ABM("I"),0)) D
 .S ABM=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM,0),U)
 .I ABM'=ABMP("INS") D  Q
 ..I "U"[$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM,0)),U,3) Q
 ..S Y=ABM
 ..S ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","
 ..D SEL^ABMDE2X
 ..S $P(ABMF(13),U,3)=$P(^AUTNINS(ABM,0),U)
 ..S $P(ABMF(14),U)=$P(^AUTNINS(ABM,0),U,2)
 ..S $P(ABMF(15),U,3)=$$CSZ^ABMDUTL($P(^AUTNINS(ABM,0),U,3,5))
 ..S $P(ABMF(14),U,2)=$P(ABMV("X3"),U,6)
 ..S $P(ABMF(15),U,4)=$P(ABMV("X3"),U,7)
 ..S $P(ABMF(13),U,5)=$P(ABMV("X3"),U)
 ..S $P(ABMF(14),U,3)=$P(ABMV("X3"),U,2)
 ..S $P(ABMF(15),U,5)=$P(ABMV("X3"),U,3)
 ..S $P(ABMF(18),U)=$P($P(ABMV("X2"),U),";",2)
 ..S $P(ABMF(18),U,2)=$P(ABMV("X1"),U,4)
 ..S $P(ABMF(18),U,3)=$E($P(ABMV("X2"),U,7),4,5)
 ..S $P(ABMF(18),U,4)=$E($P(ABMV("X2"),U,7),6,7)
 ..S $P(ABMF(18),U,5)=($E($P(ABMV("X2"),U,7),1,3)+1700)
 ..I $P(ABMV("X2"),U,2) D
 ...S ABMREL=+$P($G(^AUTTRLSH(+$P(ABMV("X2"),U,2),0)),U,2)
 ...I ABMREL,ABMREL<8,ABMREL'=2 S $P(ABMF(17),U,$S(ABMREL=1:2,1:3))="X"
 ...E  S $P(ABMF(18),U,$S(ABMREL=2:6,1:7))="X"
 ..I $P($G(^AUTNINS(ABM,2)),U,5)="O" S $P(ABMF(13),U)="X"
 ..E  S $P(ABMF(15),U)="X"
 S:$P($G(ABMF(13)),U)="" $P(ABMF(13),U,2)="X"
 S:$P($G(ABMF(15)),U)="" $P(ABMF(15),U,2)="X"
 ;
BNODES I $D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)) S ABM("B4")=$G(^(4)),ABM("B7")=$G(^(7)),ABM("B8")=$G(^(8)),ABM("B9")=$G(^(9))
 I $P(ABM("B9"),U)]"" S $P(ABMF(24),U,3)="X"
 E  S $P(ABMF(24),U,2)="X"
 ;
ACCD S $P(ABMF(26),U,$S('$P(ABM("B8"),U,3):2,"12"[$P(ABM("B8"),U,3):3,1:2))="X"
 S $P(ABMF(28),U,$S("12"[$P(ABM("B8"),U,3):2,1:3))="X"
FSYM S $P(ABMF(32),U)=$P(ABM("B8"),U,6)
 I $P(ABM("B7"),U,4)="Y" S ABMF(21)="SIGNATURE ON FILE"_U_DT
 I $P(ABM("B7"),U,5)="Y" S $P(ABMF(21),U,3)="SIGNATURE ON FILE",$P(ABMF(21),U,4)=DT
 S $P(ABMF(32),U,2)="X"
XRAY S $P(ABMF(32),U,$S($P(ABM("B4"),U,3):7,1:6))="X"
 S $P(ABMF(32),U,8)=$P(ABM("B4"),U,3)
ORTHO S $P(ABMF(32),U,$S($P(ABM("B4"),U,4):10,1:9))="X"
 I $P(ABM("B4"),U,4) S $P(ABMF(32),U,11)=$P(ABM("B4"),U,5)
PROTH S $P(ABMF(30),U,$S($P(ABM("B4"),U,6):5,1:4))="X"
 I $P(ABM("B4"),U,6) S $P(ABMF(30),U,6)=$P(ABM("B4"),U,7)
 S $P(ABMF(55),U)="Bill Number: "_$P(ABMP("B0"),U)_$S($P($G(^ABMDPARM(DUZ(2),1,2)),U,4)]"":"-"_$P(^(2),U,4),1:"") I $P($G(^(3)),U,3),$P($G(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)),U,2) S $P(ABMF(55),U)=$P(ABMF(55),U)_" "_$P(^(0),U,2)
 I $D(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,0)) D
 .S ABMIEN=0
 .S ABMLINE=51
 .F  S ABMIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,ABMIEN)) Q:+ABMIEN=0!(ABMLINE>54)  D
 ..S ABMF(ABMLINE)=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,ABMIEN,0))
 ..S ABMLINE=ABMLINE+1
 ;
XIT K ABM,ABMV
 Q
