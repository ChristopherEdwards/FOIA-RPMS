ABMDF27C ; IHS/ASDST/DMJ - Set HCFA1500 (08/05) Print Array ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; *********************************************************************
 ;
 D VAR
 D LOOP
 D VAR
 D XIT
 Q
VAR S ABM("CNT")=0
 S ABMP("C0")=^ABMDBILL(DUZ(2),ABMP("BDFN"),0)
 S ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","
 S ABMP("VDT")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),U),$P(ABMP("C0"),U,2)=ABMP("VDT")
 S ABMP("VTYP")=$P(ABMP("C0"),U,7)
 Q
LOOP S ABM("IN")="" F ABM("I")=41:1:43 S ABM("IN")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABM("IN"))) Q:'ABM("IN")  S ABM("XIEN")=$O(^(ABM("IN"),"")) S ABM("Z")=$S(ABM("I")=41:"A",ABM("I")=42:"B",1:"C") D INS
 Q
 ;
XIT K ABM,ABME,ABMV
 Q
 ;
INS Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM("XIEN"),0))  S ABM("INSCO")=$P(^(0),U)
 Q:$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM("XIEN"),0),U,3)="U"
 I ABM("INSCO")=$P(ABMP("B0"),U,8),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM("XIEN"),0),"^",3)="I" D
 .D ^ABMDE2X1
 .I $D(ABMP("FLAT")) D
 ..S $P(ABMP("FLAT"),U)=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U)  ;bill amt
 ..S:ABMP("VTYP")=111 $P(ABMP("FLAT"),U)=$P(ABMP("FLAT"),U)/$P(ABMP("FLAT"),U,3)
 .S ABMP("EXP")=27
PAYOR S Y=ABM("INSCO") D SEL^ABMDE2X
 S ABM("I0")=+ABMV("X1")
 I ABM("INSCO")'=$P(ABMP("B0"),U,8),ABM("CNT")=0,"IN"'[$P($G(^AUTNINS(ABM("I0"),2)),U) D
 .Q:$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM("XIEN"),0)),U,11)=$P(ABMP("B0"),U,8)
 .S $P(ABMF(19),U,3)="X",$P(ABMF(19),U,4)=""
 .S $P(ABMF(19),U)=$P(^AUTNINS(ABM("I0"),0),U)
 .S $P(ABMF(11),U)=$P($P(ABMV("X2"),U),";",2)
 .S $P(ABMF(15),U)=$P(ABMV("X2"),U,7)
 .I $P(ABMV("X2"),U,6)]"" S $P(ABMF(15),U,$S($P(ABMV("X2"),U,6)="F":3,1:2))="X"
 .S $P(ABMF(13),U)=$P(ABMV("X1"),U,4)_"  "_$P(ABMV("X3"),U,7)
 .S $P(ABMF(17),U)=$P(ABMV("X3"),U)
 .S ABM("CNT")=ABM("CNT")+1
PRIM I ((ABM("INSCO")=$P(ABMP("B0"),U,8))!($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM("XIEN"),0)),U,11)=$P(ABMP("B0"),U,8))),($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM("XIEN"),0),"^",3)="I") D
 .S ABM("SPOUSE")=0
 .I $P(^AUPNPAT(ABMP("PDFN"),0),U,22) S ABM("SPOUSE")=1
 .I $P($G(^AUPNPAT(ABMP("PDFN"),28)),U,2),$P($G(^AUTTRLSH($P(^(28),U,2),0)),U,3)="02" S ABM("SPOUSE")=1
 .I $P($G(^AUPNPAT(ABMP("PDFN"),31)),U,2),$P($G(^AUTTRLSH($P(^(31),U,2),0)),U,3)="02" S ABM("SPOUSE")=1
 .I $P(ABMV("X2"),U,2),$P($G(^AUTTRLSH(+$P(ABMV("X2"),U,2),0)),U,3)="02" S ABM("SPOUSE")=1
 .S ABMPIECE=3
 .S:ABM("SPOUSE") ABMPIECE=4
 .S ABMMSTAT=$P(^DPT(ABMP("PDFN"),0),"^",5)
 .I ABMMSTAT D
 ..S ABMPIECE=5
 ..S:ABMMSTAT=8 ABMPIECE=3
 ..S:ABMMSTAT=2 ABMPIECE=4
 .S $P(ABMF(7),"^",ABMPIECE)="X"
 .S:$P($G(ABMF(19)),U,3)="" $P(ABMF(19),U,4)="X"
 .S $P(ABMF(3),U,5)=$P($P(ABMV("X2"),U),";",2)
 .I $P(ABMV("X3"),U,1)]"",$P(ABMV("X3"),U,6)]"" S ABMF(1)="",$P(ABMF(1),U,5)="X"
 .S $P(ABMF(1),U,8)=$S($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,8)'="":$P(^(4),U,8),$P($G(ABMV("X1")),U,12)'="":$P(ABMV("X1"),U,12),1:$P(ABMV("X1"),U,4))
 .I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),1)),U,7)="N" S $P(ABMF(1),U,8)=$TR($P(ABMF(1),U,8),"-","")
 .S $P(ABMF(15),U,7)=$P(ABMV("X3"),U,1)
 .S $P(ABMF(17),U,4)=$P($P(ABMV("X1"),U),";",2)
 .S $P(ABMF(11),U,2)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),1)),U,3)  ;group name/number
 .I $P(ABMF(11),U,2)="",($P(ABMV("X3"),U,7)]"") S $P(ABMF(11),U,2)=$P(ABMV("X3"),U,7)_"/"_$P(ABMV("X3"),U,6)
 .S $P(ABMF(13),U,4)=$P(ABMV("X2"),U,7)
 .I $P(ABMV("X2"),U,6)]"" S $P(ABMF(13),U,$S($P(ABMV("X2"),U,6)="F":6,1:5))="X"
 .S $P(ABMF(5),U,6)=$P(ABMV("X2"),U,3)
 .S $P(ABMF(7),U,6)=$P($P(ABMV("X2"),U,4),", ")
 .S $P(ABMF(7),U,7)=$P($P($P(ABMV("X2"),U,4),", ",2),"  ")
 .S $P(ABMF(9),U,6)=$P($P($P(ABMV("X2"),U,4),", ",2),"  ",2)
 .S $P(ABMF(9),U,7)=$S($E($P(ABMV("X2"),U,5))="(":"",1:" ")_$P(ABMV("X2"),U,5)
 .S ABM("RLSH")=$S($P(ABMV("X2"),U,2)]"":+$P($G(^AUTTRLSH(+$P(ABMV("X2"),U,2),0)),U,2),1:"")
 .I ABM("RLSH")>0&(ABM("RLSH")<4) S ABM("RLSH")=ABM("RLSH")+1
 .E  S ABM("RLSH")=$S(ABM("RLSH")=5:4,1:5)
 .S $P(ABMF(5),U,ABM("RLSH"))="X"
 Q
