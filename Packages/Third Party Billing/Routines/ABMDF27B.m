ABMDF27B ; IHS/ASDST/DMJ - Set HCFA1500 (08/05) Print Array PART 2 ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**4**;NOV 12, 2009
 ; IHS/SD/SDR - abm*2.6*4 - HEAT12115 - Moved box 23 over 2 to allow for "extra" dx codes
 ;
 ; *********************************************************************
BNODES S ABM("B5")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),5)),ABM("B6")=$G(^(6)),ABM("B7")=$G(^(7)),ABM("B8")=$G(^(8)),ABM("B9")=$G(^(9)),ABM("B10")=$G(^(10))
 ;start old code abm*2.6*4 HEAT12115
 ;I $P(ABM("B5"),U,12)]"" S $P(ABMF(33),U,3)=$P(ABM("B5"),U,12)
 ;I $P($G(^DIC(40.7,ABMP("CLN"),0)),U)="AMBULANCE" S $P(ABMF(33),U,3)=$E($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,6),1,5)
 ;I +$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,0))'=0 D
 ;.I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U)'=0,($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,23)'="") S $P(ABMF(33),U,3)=$P($G(^ABMRLABS($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,23),0)),U,2)
 ;.I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U)=0 S $P(ABMF(33),U,3)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,22)  ;default in-house
 ;end old code start new code HEAT12115
 I $P(ABM("B5"),U,12)]"" S $P(ABMF(33),U,5)=$P(ABM("B5"),U,12)
 I $P($G(^DIC(40.7,ABMP("CLN"),0)),U)="AMBULANCE" S $P(ABMF(33),U,5)=$E($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,6),1,5)
 I +$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,0))'=0 D
 .I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U)'=0,($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,23)'="") S $P(ABMF(33),U,5)=$P($G(^ABMRLABS($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,23),0)),U,2)
 .I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U)=0 S $P(ABMF(33),U,5)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,22)  ;default in-house
 ;end new code HEAT12115
 ;no labs but CLIA wanted on form
 I +$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,0))=0 D
 .I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),1)),U,6)="R" D
 ..S $P(ABMF(33),U,3)=$P($G(^ABMRLABS($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,23),0)),U,2)
 .I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),1)),U,6)="I" D
 ..S $P(ABMF(33),U,3)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,22)
EMPL I $P(ABM("B9"),U)]"" S $P(ABMF(13),U,2)="X"
 E  S $P(ABMF(13),U,3)="X" G ACCD
 I $P(ABM("B9"),U,3)]"" S $P(ABMF(25),U,3)=$P(ABM("B9"),U,3)
 I $P(ABM("B9"),U,4)]"" S $P(ABMF(25),U,4)=$P(ABM("B9"),U,4)
 ;
ACCD S $P(ABMF(15),U,$S('$P(ABM("B8"),U,3):5,"12"[$P(ABM("B8"),U,3):4,1:5))="X"
 S $P(ABMF(17),U,$S("12"[$P(ABM("B8"),U,3):3,1:2))="X"
FSYM S $P(ABMF(25),U)=$P(ABM("B8"),U,6)
SIML S $P(ABMF(25),U,2)=$P(ABM("B8"),U,9)
REFR S $P(ABMF(27),U)=$P(ABM("B8"),U,8)
 S $P(ABMF(26),U)=$P(ABM("B8"),U,18)_$P(ABM("B8"),U,11)  ;ref QUALIFIER/ID
 S $P(ABMF(27),U,2)=$P(ABM("B8"),U,17)  ;ref NPI
BLK19 ;
 S ABMBLK19=$$SDT^ABMDUTL($P(ABM("B9"),U,11))  ;date last seen
 S ABMBLK19=ABMBLK19_" "_$P(ABM("B9"),U,24)  ;supervising prov UPIN
 S ABMBLK19=ABMBLK19_" "_$P(ABM("B9"),U,12)  ;supervising prov
 S ABMBLK19=ABMBLK19_" "_$$SDT^ABMDUTL($P(ABM("B9"),U,13))  ;last x-ray
 S ABMBLK19=ABMBLK19_" "_$S($P(ABM("B9"),U,14)="Y":"HOMEBOUND",1:"")
 S ABMBLK19=ABMBLK19_" "_$S($P(ABM("B9"),U,15)="Y":"HOSPICE EMP. PROV",1:"")
 S ABMBLK19=ABMBLK19_" "_$P(ABM("B10"),U,1)
 S $P(ABMF(29),U)=$E(ABMBLK19,1,48)
 K ABMBLK19
LAB I '$P(ABM("B8"),U) S $P(ABMF(29),U,3)="X"
 E  S $P(ABMF(29),U,2)="X",$P(ABMF(29),U,4)=$P(ABM("B8"),U)
 I $P(ABM("B7"),U,4)="Y" S ABMF("23")="SIGNATURE ON FILE"_U_DT
 I $P(ABM("B7"),U,5)="Y" S $P(ABMF("23"),U,3)="SIGNATURE ON FILE"
 ;
 I $P(ABMP("B0"),U,7)'=111,($P(ABMP("B0"),U,7)'=999),($P(ABMP("B0"),U,7)'=141) G XIT
 ;
 ; Hosp Info
ADMIT I $P(ABM("B6"),U,1)]"" S $P(ABMF(27),U,3)=$P(ABM("B6"),U,1)
DISCH I $P(ABM("B6"),U,3)]"" S $P(ABMF(27),U,4)=$P(ABM("B6"),U,3)
 ;
XIT K ABM,ABMV,ABMX
 Q
