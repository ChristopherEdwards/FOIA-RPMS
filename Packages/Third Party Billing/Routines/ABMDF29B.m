ABMDF29B ; IHS/ASDST/DMJ - ADA 2006 Dental Export -part 2 ;    
 ;;2.6;IHS Third Party Billing;**1,2,3,4,6,8**;NOV 12, 2009
 ;abm*2.6*1 - split from ABMDF29A due to routine size
 ;IHS/SD/SDR - abm*2.6*2 - FIXPMS10006 - check what date to print FL37
 ;IHS/SD/PMT - abm*2.6*3 - HEAT8604 - moved entire form up one line
 ;IHS/SD/SDR - abm*2.6*3 - HEAT13493 - put facility NPI in box54 if UTAH MEDICAID
 ;IHS/SD/SDR - abm*2.6*6 - NOHEAT - AIDC local mods
 ;
INS ;Ins Info
 S ABM("I")=0
 F  S ABM("I")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABM("I"))) Q:'ABM("I")  D
 .S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABM("I"),0))
 .S ABM=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM,0),U)
 .I ABM'=ABMP("INS") D  Q
 ..I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM,0)),U,3)="U" Q
 ..I $P($G(^AUTNINS(ABM,2)),U)="N"!($P($G(^AUTNINS(ABM,2)),U)="I") Q  ;ben/non-ben don't count
 ..S Y=ABM
 ..S ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","
 ..D SEL^ABMDE2X
 ..Q:$G(ABMP("INS2"))=""
 ..S $P(ABMF(14),U)=$P($P(ABMV("X2"),U),";",2)  ;(5)  ;HEAT8604
 ..S $P(ABMF(16),U)=$P(ABMV("X2"),U,7)  ;(6)  ;HEAT8604
 ..I $P($G(^AUTNINS(ABMP("INS2"),2)),U)="P" D
 ...S ABMPIEN=$O(^AUPNPRVT(ABMP("PDFN"),11,"B",ABMP("INS2"),0))
 ...S $P(ABMF(14),U)=$P($G(^AUPN3PPH($P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMPIEN,0)),U,8),0)),U)  ;(5)  ;HEAT8604
 ...S $P(ABMF(16),U)=$P($G(^AUPN3PPH($P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMPIEN,0)),U,8),0)),U,19)  ;(6)  ;HEAT8604
 ..I $P($G(^AUTNINS(ABMP("INS2"),2)),U)="D" D
 ...S $P(ABMF(14),U)=$P($G(^DPT(ABMP("PDFN"),0)),U)  ;(5)  ;HEAT8604
 ...S $P(ABMF(16),U)=$P($G(^DPT(ABMP("PDFN"),0)),U,3)  ;(6)  ;HEAT8604
 ..S $P(ABMF(12),U,2)="X"  ;Other cov(4)
 S:$P($G(ABMF(12)),U,2)="" $P(ABMF(12),U)="X"  ;No other cov(4)  ;HEAT8604
 S $P(ABMF(1),U)="X"  ;stmt/actual svcs (1)  ;HEAT8604
 I $P($G(^AUTNINS(ABMP("INS"),2)),"^")="D"&($P($G(^ABMDVTYP(ABMP("VTYP"),0)),U)["EPSDT") S $P(ABMF(2),U)="X"  ;EPSDT/Title 19(1)  ;HEAT8604
BNODES ; Bill nodes
 I $D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)) D
 .S ABM("B4")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4))
 .S ABM("B5")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),5))
 .S ABM("B7")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7))
 .S ABM("B8")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8))
 .S ABM("B9")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9))
 S $P(ABMF(4),U)=$P(ABM("B5"),U,12)  ;Prior Auth(2)  ;abm*2.6*1 HEAT6673 and  abm*2.6*3 HEAT8604
 I $P(ABM("B9"),U)]"" S $P(ABMF(49),U,3)="X"  ;Occup. illness(45)  ;HEAT8604
ACCD ;Accident?
 I $P(ABM("B8"),U,3)'="" D
 .I "12"[$P(ABM("B8"),U,3) D  Q
 ..S $P(ABMF(49),U,4)="X"  ;auto accident(45)  ;HEAT8604
 ..S $P(ABMF(50),U)=$P(ABM("B8"),U,2)  ;acc. dt(46)  ;HEAT8604
 ..S $P(ABMF(50),U,2)=$P($G(^DIC(5,$P(ABM("B8"),U,16),0)),"^",2)  ;acc. st(47)  ;HEAT8604
 .I "5"[$P(ABM("B8"),U,3) D  Q
 ..S $P(ABMF(49),U,5)="X"  ;other accident(45)  ;HEAT8604
 .S $P(ABMF(50),U)=$P(ABM("B8"),U,2)   ;acc. dt(46)  ;HEAT8604
 .S $P(ABMF(50),U,2)=$P($G(^DIC(5,$P(ABM("B8"),U,16),0)),"^",2)  ;acc. st(47)  ;HEAT8604
FSYM I $P(ABM("B7"),U,4)="Y" D  ;ROI
 .S $P(ABMF(45),U)="SIGNATURE ON FILE"  ;(36)  ;HEAT8604
 .S $P(ABMF(45),U,2)=$P(ABM("B7"),U,11)  ;(36)  ;abm*2.6*1 HEAT5760 and abm*2.6*3 HEAT8604
 I $P(ABM("B7"),U,5)="Y" D  ;AOB
 .S $P(ABMF(49),U)="SIGNATURE ON FILE"  ;(37)  ;abm*2.6*2 FIXPMS10006 and abm*2.6*3 HEAT8604
 .S $P(ABMF(49),U,2)=$S($G(ABMP("PRINTDT"))="O":$P($G(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7),0)),U),1:DT)  ;(37)  ;abm*2.6*1 HEAT5760  ;abm*2.6*2 FIXPMS10006 and abm*2.6*3 HEAT8604  abm*2.6*4 HEAT17615
 I $P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2)="AIDC" S $P(ABMF(49),U,2)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U,12)  ;abm*2.6*6 NOHEAT
 I ABMP("BTYP")=111 S $P(ABMF(43),U,2)="X"  ;Hosp(38)  ;HEAT8604
 I $$POS^ABMERUTL=32 S $P(ABMF(43),U,3)="X"  ;EFC(38)  ;HEAT8604
 I $$POS^ABMERUTL'=32,(ABMP("BTYP")'=111) S $P(ABMF(43),U)="X"  ;Provider office(dflt)(38)  ;HEAT8604
 S $P(ABMF(43),U,5)=$P($G(ABM("B4")),U,3)  ;Radiographs(39)  ;HEAT8604
 S $P(ABMF(43),U,6)=$P($G(ABM("B9")),U,18)  ;Oral Images(39)  ;HEAT8604
 S $P(ABMF(43),U,7)=$P($G(ABM("B9")),U,19)  ;Models(39)  ;HEAT8604
XRAY ;#/X-rays included
ORTHO ;Ortho. Related?
 S $P(ABMF(45),U,$S($P(ABM("B4"),U,4):4,1:3))="X"  ;(40)  ;HEAT8604
 ; Ortho. Placement Dt
 I $P(ABM("B4"),U,4) S $P(ABMF(45),U,5)=$P(ABM("B4"),U,5)  ;(41)  ;HEAT8604
 I $P(ABM("B4"),U,13) S $P(ABMF(47),U)=$P(ABM("B4"),U,13)  ;(42)  ;HEAT8604
PROTH ;Proth. Included?
 S $P(ABMF(47),U,$S($P(ABM("B4"),U,6):3,1:2))="X"  ;(43)  ;HEAT8604
 ; Prior Placement Dt
 I $P(ABM("B4"),U,6) S $P(ABMF(47),U,4)=$P(ABM("B4"),U,7)  ;(44)  ;HEAT8604
 ;
 S ABMBIL=$P(ABMP("B0"),U)  ;Bill#
 S ABMSFX=$P($G(^ABMDPARM(DUZ(2),1,2)),U,4)  ;Bill# suffix
 S ABMAHRN=$P($G(^ABMDPARM(DUZ(2),1,1,3)),U,3)  ;Append HRN?
 S ABMHRN=$P($G(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)),U,2)  ;HRN
 S $P(ABMF(22),U,5)=ABMBIL_"-"_ABMSFX_" "_ABMHRN  ;Pt ID(23)  ;HEAT8604
 I $D(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,0)) D
 .S ABMIEN=0
 .S ABMLINE=40
 .F  S ABMIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,ABMIEN)) Q:+ABMIEN=0!(ABMLINE>42)  D
 ..S ABMF(ABMLINE)=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,ABMIEN,0))
 ..S ABMLINE=ABMLINE+1
 Q
PAT ;
 S ABM("P0")=^DPT(ABMP("PDFN"),0)  ;0 node pt file
 S ABMF(17)=$P(ABM("P0"),U)  ;Name(20)  ;HEAT8604
 S ABM("P11")=$G(^DPT(ABMP("PDFN"),.11))
 S $P(ABMF(18),U,6)=$P(ABM("P11"),U)  ;Mailing addr(20)  ;HEAT8604
 S $P(ABMF(19),U)=$P(ABM("P11"),U,4)  ;Mailing-city(20)  ;HEAT8604
 S $P(ABMF(19),U)=$P(ABMF(19),U)_", "_$P(^DIC(5,$P(ABM("P11"),U,5),0),U,2)  ;Mailing-St(20)  ;HEAT8604
 S $P(ABMF(19),U)=$P(ABMF(19),U)_"  "_$P(ABM("P11"),U,6)  ;Mailing-Zip(20)  ;HEAT8604
 S $P(ABMF(22),U,2)=$P(ABM("P0"),U,3)  ;dob(21)  ;HEAT8604
 I $P(ABM("P0"),U,2)="M" S $P(ABMF(22),U,3)="X"  ;sex-male(22)  ;HEAT8604
 E  S $P(ABMF(22),U,4)="X"  ;sex-female(22)  ;HEAT8604
 K ABM("P0"),ABM("P11")
 S (ABMV("X1"),ABMV("X2"),ABMV("X3"))=""
 D PAT^ABMDE1X
 D REMPL^ABMDE1X1
 D LOC^ABMDE1X1
 K ABME
 Q
PRV ;
 S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 I ABM("X") D
 .D SELBILL^ABMDE4X
 .D PAYED^ABMERUTL
 .S $P(ABMF(54),U,2)=$P(ABM("A"),U)  ;(53)  ;HEAT8604
 .I $P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2)="AIDC",($P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL") S $P(ABMF(54),U,2)=""  ;abm*2.6*6 NOHEAT
 .S $P(ABMF(54),U,3)=$S($G(ABMP("PRINTDT"))="O":$P($G(^ABMDTXST(DUZ(2),$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,7),0)),U),1:DT)  ;(53)  ;abm*2.6*2 FIXPMS10006 and  ;HEAT8604  ;abm*2.6*4 HEAT17615
 .S $P(ABMF(56),U,2)=$S($P($$NPI^XUSNPI("Individual_ID",$P(ABM("A"),U,2)),U)>0:$P($$NPI^XUSNPI("Individual_ID",$P(ABM("A"),U,2)),U),1:"")  ;Dent NPI (54)  ;HEAT8604
 .I $P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2)="AIDC",((ABMP("INS")=1722)!($P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL")) S $P(ABMF(56),U,2)=""  ;abm*2.6*6 NOHEAT
 .I $P($G(^AUTNINS(ABMP("INS"),0)),U)["MEDICAID UTAH" S $P(ABMF(56),U,2)=$S($P($$NPI^XUSNPI("Organization_ID",ABMP("LDFN")),U)>0:$P($$NPI^XUSNPI("Organization_ID",ABMP("LDFN")),U),1:"")  ;Fac NPI for UTAH MEDICAID (54)  ;abm*2.6*3 HEAT13493
 .S $P(ABMF(59),U,2)=$$SLN^ABMEEPRV($P(ABM("A"),U,2))  ;Dent Lic(55)  ;HEAT8604
 .;start new code abm*2.6*6 NOHEAT
 .I $P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2)="AIDC" D
 ..I ((ABMP("INS")=1722)!($P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL")) S $P(ABMF(57),U,2)=""
 ..S $P(ABMF(59),U,2)=""
 ..I ABMP("INS")=5 S $P(ABMF(59),U,2)="NM008A76"
 ..I $P($G(^AUTNINS(ABMP("INS"),0)),U)["UNITED CONCORDIA" S $P(ABMF(59),U,2)=601046
 ..I $P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL" S $P(ABMF(59),U,2)=8886
 .;end new code NOHEAT
 .S $P(ABMF(56),U,3)=$$SLN^ABMEEPRV($P(ABM("A"),U,2))  ;(55)  ;HEAT8604
 .I $P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2)="AIDC" D  ;abm*2.6*6 NOHEAT
 ..I (ABMP("INS")=1722)!($P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL") S $P(ABMF(56),U,3)=$S(ABMP("INS")=5:"NM008A76",ABMP("INS")["UNITED CONCORDIA":601046,($P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL"):8886,1:"")  ;abm*2.6*6 NOHEAT
 .S $P(ABMF(60),U,4)=ABM("PNUM")  ;Prov#(58)  ;HEAT8604
 .;S $P(ABMF(60),U,4)=ABM("PNUM")  ;Prov#(58)  ;HEAT8604
 .I $P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2)="AIDC" D  ;abm*2.6*6 NOHEAT
 ..S $P(ABMF(60),U,4)=$S(ABMP("INS")=5:"NM008A76",ABMP("INS")["UNITED CONCORDIA":601046,($P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL"):8886,1:"")  ;abm*2.6*6 NOHEAT
 .S $P(ABMF(60),U,2)=ABM("INUM")  ;loc id(52a)  ;HEAT8604
 .;S $P(ABMF(60),U,2)=ABM("INUM")  ;loc id(52a)  ;HEAT8604
 .I $P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2)="AIDC" D  ;abm*2.6*6 NOHEAT
 ..S $P(ABMF(60),U,2)=$S(ABMP("INS")=5:"NM008A76",ABMP("INS")["UNITED CONCORDIA":601046,($P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL"):8886,1:"")  ;abm*2.6*6 NOHEAT
 .S $P(ABMF(60),U,3)=$P($G(^VA(200,$P(ABM("A"),U,2),.13)),U,2)  ;off. phone(57)  ;HEAT8604
 .;S $P(ABMF(60),U,3)=$P($G(^VA(200,$P(ABM("A"),U,2),.13)),U,2)  ;off. phone(57)  ;HEAT8604
 .I $P(ABMF(60),U,3)="" S $P(ABMF(60),U,3)=$P($G(^AUTTLOC(ABMP("LDFN"),0)),U,11)  ;loc phone(57)  ;HEAT8604
 .;I $P(ABMF(60),U,3)="" S $P(ABMF(60),U,3)=$P($G(^AUTTLOC(ABMP("LDFN"),0)),U,11)  ;loc phone(57)  ;HEAT8604
 .S $P(ABMF(57),U)=$$PTAX^ABMEEPRV($P(ABM("A"),U,2))  ;specialty(tax. code)(56a)  ;HEAT8604
 .I $P($G(^AUTTLOC(ABMP("LDFN"),0)),U,2)="AIDC" D  ;abm*2.6*6 NOHEAT
 ..I $P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL" S $P(ABMF(57),U)=""  ;abm*2.6*6 NOHEAT
 Q
POL ;
 N I
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I)) Q:'I  D
 .I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),U,3)="I" S ABM("XIEN")=I
 S Y=ABMP("INS")
 S ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","
 D SEL^ABMDE2X  ;ABMV("X2")  ;Pol. holder info
 I ABM("ADD")["NON-BEN" D
 .S ABM("ADD")=ABMV("X2")
 S $P(ABMF(5),U)=$P($P(ABMV("X2"),U),";",2)  ;Sub. name(12)  ;HEAT8604
 S $P(ABMF(6),U)=$P(ABMV("X2"),U,3)  ;Addr(12)  ;HEAT8604
 S ABMCSZ=$P(ABMV("X2"),"^",4)
 S $P(ABMF(7),U,2)=$P(ABMCSZ,",",1)  ;City(12)  ;HEAT8604
 S ABMCSZ=$P(ABMCSZ,",",2)
 S $P(ABMF(7),U,2)=$P(ABMF(7),U,2)_", "_$P(ABMCSZ," ",2)  ;St(12)  ;HEAT8604
 S $P(ABMF(7),U,2)=$P(ABMF(7),U,2)_"  "_$P(ABMCSZ," ",4)  ;Zip(12)  ;HEAT8604
 K ABMCSZ
 S $P(ABMF(10),U,$S($P(ABMV("X2"),U,6)="M":2,1:3))="X"  ;Sex(14)  ;HEAT8604
 S $P(ABMF(10),U,4)=$P(ABMV("X1"),U,4)  ;Emp. id(15)  ;HEAT8604
 S $P(ABMF(10),U)=$P(ABMV("X2"),U,7)  ;dob(13)  ;HEAT8604
 S ABMSTAT=$P($P(ABMV("X3"),U,5),";")
 I $P(ABMV("X3"),U)="STUDENT" D  ;check if student
 . I ABMSTAT=1 S $P(ABMF(15),U,5)="X"  ;full-time student(19)  ;HEAT8604
 . I ABMSTAT=2 S $P(ABMF(15),U,6)="X"  ;part-time student(19)  ;HEAT8604
 Q
