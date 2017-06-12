ABMDF35B ; IHS/SD/SDR - Set HCFA1500 (02/12) Print Array PART 2 ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**13,14**;NOV 12, 2009;Build 238
 ;IHS/SD/SDR - 2.6*14 - HEAT156735 - Populated box 19 with:
 ;  1. VA CONTRACT NUMBER (existing code)
 ;  2. claim attachments from page 9G (new code)
 ;  3. what it did before (existing code)
 ;
 ; *********************************************************************
BNODES S ABM("B5")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),5)),ABM("B6")=$G(^(6)),ABM("B7")=$G(^(7)),ABM("B8")=$G(^(8)),ABM("B9")=$G(^(9)),ABM("B10")=$G(^(10))
 I $P(ABM("B5"),U,12)]"" S $P(ABMF(33),U,5)=$P(ABM("B5"),U,12)
 I $P($G(^DIC(40.7,ABMP("CLN"),0)),U)="AMBULANCE" S $P(ABMF(33),U,5)=$E($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,6),1,5)
 I +$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,0))'=0 D
 .I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U)'=0,($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,23)'="") S $P(ABMF(33),U,5)=$P($G(^ABMRLABS($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,23),0)),U,2)
 .I +$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U)=0 S $P(ABMF(33),U,5)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,22)  ;default in-house
 ;no labs but CLIA wanted on form
 I +$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),37,0))=0 D
 .I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),1)),U,6)="R" D
 ..S $P(ABMF(33),U,3)=$P($G(^ABMRLABS($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,23),0)),U,2)
 .I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),1)),U,6)="I" D
 ..S $P(ABMF(33),U,3)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,22)
 ;
 I ((ABMP("ITYPE")="V")!($$GET1^DIQ(9999999.18,ABMP("INS"),".01","E")["VMBP"))&($P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,12)'="") S $P(ABMF(33),U,5)=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,12) ;
EMPL I $P(ABM("B9"),U)]"" S $P(ABMF(13),U,2)="X"
 E  S $P(ABMF(13),U,3)="X" G ACCD
 I $P(ABM("B9"),U,3)]"" S $P(ABMF(25),U,3)=$P(ABM("B9"),U,3)
 I $P(ABM("B9"),U,4)]"" S $P(ABMF(25),U,4)=$P(ABM("B9"),U,4)
 ;
ACCD ;
 ;S $P(ABMF(15),U,$S('$P(ABM("B8"),U,3):5,"12"[$P(ABM("B8"),U,3):4,1:5))="X"  ;abm*2.6*13 remove box 9B
 S $P(ABMF(15),U,$S('$P(ABM("B8"),U,3):2,"12"[$P(ABM("B8"),U,3):1,1:2))="X"  ;abm*2.6*13 remove box 9B
 ;S $P(ABMF(17),U,$S("12"[$P(ABM("B8"),U,3):3,1:2))="X"  ;abm*2.6*13 remove box 9C
 S $P(ABMF(17),U,$S("12"[$P(ABM("B8"),U,3):2,1:1))="X"  ;abm*2.6*13 remove box 9C
FSYM ; (box 14)
 ;S $P(ABMF(25),U)=$P(ABM("B8"),U,6)  ;abm*2.6*13 box 14
 ;start new code abm*2.6*13 box 14
 K ABMLMP,ABMONSET
 S ABMTMP=0
 F  S ABMTMP=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),51,ABMTMP)) Q:'ABMTMP  D
 .S ABMOCD=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),51,ABMTMP,0)),U)
 .I $$GET1^DIQ(9002274.03,ABMOCD,".02","I")="O" D
 ..I $$GET1^DIQ(9002274.03,ABMOCD,".01")=10 S ABMLMP=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),51,ABMTMP,0)),U,2)
 ..I $$GET1^DIQ(9002274.03,ABMOCD,".01")=11 S ABMONSET=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),51,ABMTMP,0)),U,2)
 I +$G(ABMLMP)'=0 D
 .S $P(ABMF(25),U)=$$SDT^ABMDUTL(ABMLMP)_"    484"
 I $P($G(ABMF(25)),U)="",+$G(ABMONSET)'=0 D
 .S $P(ABMF(25),U)=$$SDT^ABMDUTL(ABMONSET)_"    431"
 ;end new code box 14
SIML ;
 ;S $P(ABMF(25),U,2)=$P(ABM("B8"),U,9)  ;abm*2.6*13 box 15
 ;start new abm*2.6*13 box 15
 S ABMBOX15=""
 I $P(ABM("B8"),U,23)'="" S ABMBOX15="454    "_$$SDT^ABMDUTL($P(ABM("B8"),U,23))  ;Initial Treatment
 I ABMBOX15="",$P(ABM("B9"),U,11)'="" S ABMBOX15="304    "_$$SDT^ABMDUTL($P(ABM("B9"),U,11))  ;Latest Visit or Consultation/Date Last Seen
 I ABMBOX15="",$P(ABM("B7"),U,27)'="" S ABMBOX15="453    "_$$SDT^ABMDUTL($P(ABM("B7"),U,27))  ;Acute Manifestation of a Chronic Condition
 I ABMBOX15="",$P(ABM("B8"),U,2)'="" S ABMBOX15="439    "_$$SDT^ABMDUTL($P(ABM("B8"),U,2))  ;Accident
 I ABMBOX15="",$P(ABM("B9"),U,13)'="" S ABMBOX15="455    "_$$SDT^ABMDUTL($P(ABM("B9"),U,13))  ;Last X-Ray
 I ABMBOX15="",$P(ABM("B7"),U,14)'="" S ABMBOX15="471    "_$$SDT^ABMDUTL($P(ABM("B7"),U,14))  ;Prescription
 I ABMBOX15="",$P(ABM("B7"),U,19)'="" S ABMBOX15="090    "_$$SDT^ABMDUTL($P(ABM("B7"),U,19))  ;Assumed Care Date
 I ABMBOX15="",$P(ABM("B7"),U,21)'="" S ABMBOX15="091    "_$$SDT^ABMDUTL($P(ABM("B7"),U,21))  ;Relinquished Care Date
 I ABMBOX15="",$P(ABM("B7"),U,22)'="" S ABMBOX15="444    "_$$SDT^ABMDUTL($P(ABM("B7"),U,22))  ;First Visit or Consultation
 S $P(ABMF(25),U,2)=ABMBOX15
 ;end new box 15
BLK17 ;
 S $P(ABMF(27),U)=$P(ABM("B8"),U,25)_$P(ABM("B8"),U,24)  ;ord/ref/sup phys qual and name
 S $P(ABMF(27),U,2)=$P(ABM("B8"),U,26)  ;ord/ref/sup NPI
BLK19 ;
 S ABMBLK19=$$SDT^ABMDUTL($P(ABM("B9"),U,11))  ;date last seen
 S ABMBLK19=ABMBLK19_" "_$P(ABM("B9"),U,24)  ;supervising prov UPIN
 S ABMBLK19=ABMBLK19_" "_$P(ABM("B9"),U,12)  ;supervising prov
 ;S ABMBLK19=ABMBLK19_" "_$$SDT^ABMDUTL($P(ABM("B9"),U,13))  ;last x-ray  ;abm*2.6*13
 S ABMBLK19=ABMBLK19_" "_$S($P(ABM("B9"),U,14)="Y":"HOMEBOUND",1:"")
 S ABMBLK19=ABMBLK19_" "_$S($P(ABM("B9"),U,15)="Y":"HOSPICE EMP. PROV",1:"")
 S ABMBLK19=ABMBLK19_" "_$P(ABM("B10"),U,1)
 S $P(ABMF(29),U)=$E(ABMBLK19,1,48)
 ;start new code abm*2.6*14 HEAT156735
 I $D(^ABMDBILL(DUZ(2),ABMP("BDFN"),71,0)) D
 .S ABMI=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),71,0))
 .S ABMBLK19="PWK"_$$GET1^DIQ(9002274.03,$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),71,ABMI,0)),U),".01","E")_$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),71,ABMI,0)),U,2)_$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),71,ABMI,0)),U,3)
 .S $P(ABMF(29),U)=$E(ABMBLK19,1,48)
 ;end new code HEAT156735
 I ((ABMP("ITYPE")="V")!($$GET1^DIQ(9999999.18,ABMP("INS"),".01","E")["VMBP"))&($P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,13)'="") S $P(ABMF(29),U)=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,13)  ;abm*2.6*11 VMBP RQMT_108  ;abm*2.6*12 VMBP
 K ABMBLK19
LAB I '$P(ABM("B8"),U) S $P(ABMF(29),U,3)="X"
 E  S $P(ABMF(29),U,2)="X",$P(ABMF(29),U,4)=$P(ABM("B8"),U)
 I $P(ABM("B7"),U,4)="Y" S ABMF("23")="SIGNATURE ON FILE"_U_$P(ABM("B7"),U,11)
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
