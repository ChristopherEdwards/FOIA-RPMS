ABMDE2E ; IHS/ASDST/DMJ - DSD/DMJ - Check visit for elig ;     
 ;;2.6;IHS 3P BILLING SYSTEM;**8**;NOV 12, 2009
 ;
 ; IHS/ASDS/SDH - 06/08/01 - V2.4 Patch 9 - NOIS QDA-0399-130023
 ;     Modified to update Mode of Export in Insurer has changed.
 ; IHS/ASDS/LSL - 07/25/01 - V2.4 Patch 9 - NOIS HQW-0798-100082
 ;     Loop through all of ABML to update claim with unbillable 
 ;     insurers.  Currently only loops if at least one good insurer.
 ;     Only create new entry in Insurer multiple if billable insurer.
 ;     Loop all eligibility occurances for PI (08/29/01)
 ; IHS/ASDS/SDH - 9/27/01 - V2.4 Patch 9 - NOIS XAA-0901-200095
 ;     After moving Kidscare to Page 5 from Page 7 found that there are
 ;     checks that are done for Medicaid that should also be done for
 ;     Kidscare.
 ; IHS/ASDS/DMJ - 12/10/01 - V2.4 Patch 10 - NOIS HQW-1201-100014
 ;     Loop PCC visit multiple (11) ignoring those that have been
 ;     merged/deleted.
 ;
 ; IHS/SD/SDR - v2.5 p3 - 2/28/03 - QEA-0702-130030
 ;     Modified to check for manually entered insurer
 ; IHS/SD/SDR V2.5 P5 - 3/10/2004
 ;     Jim Gray provided code change to fix problem with with array not
 ;     being killed before use.
 ; IHS/SD/SDR - v2.5 p8 - task 8
 ;    Added code to check for replacment insurer
 ; IHS/SD/SDR - v2.5 p9 - IM17864
 ;    Check if insurer is merged
 ; IHS/SD/SDR - v2.5 p10 - IM20320
 ;   Added check to MERGECK to see if manually added insurer; if so,
 ;   don't delete
 ;
 ; *********************************************************************
 ;
 S ABMP("VDT")=$P(ABMP("C0"),U,2)
 S ABMP("CLN")=$P(ABMP("C0"),U,6)
 S DFN=ABMP("PDFN")
 S ABMVDT=ABMP("VDT")
 S I=0
 F  S I=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,"AC","P",I)) Q:'I  D
 .Q:$P($G(^AUPNVSIT(I,0)),"^",11)
 .S ABMVDFN=I
 S:'$G(ABMVDFN) ABMVDFN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,0))
 D ELG^ABMDLCK(ABMVDFN,.ABML,DFN,ABMVDT)
 D MERGECK
 ;
ENT ;EP - Entry Point to update Elig Info
 S ABM("PRI")=""
 F  S ABM("PRI")=$O(ABML(ABM("PRI"))) Q:'ABM("PRI")  D INS
 ;
HITCHK ;HIT CHECK
 N I
 ;start old code abm*2.6*8
 ;S I=0
 ;F  S I=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I)) Q:'I  D
 ;.I '$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0),U) D  Q
 ;..K ^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0)
 ;.S ABM("INS")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0),U)
 ;.S ABM("ITYPE")=$P($G(^AUTNINS(ABM("INS"),2)),U)
 ;.I ABM("ITYPE")="D"!(ABM("ITYPE")="K") D DCFX^ABMDEFIP(ABMP("CDFN"),I)
 ;.D HITCHK2
 ;end old code start new code
 N K
 S K=0
 F  S K=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",K)) Q:'K  D
 .S I=0
 .F  S I=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",K,I)) Q:'I  D
 ..I '$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0),U) D  Q
 ...K ^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0)
 ..S ABM("INS")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0),U)
 ..S ABM("ITYPE")=$P($G(^AUTNINS(ABM("INS"),2)),U)
 ..I ABM("ITYPE")="D"!(ABM("ITYPE")="K") D DCFX^ABMDEFIP(ABMP("CDFN"),I)
 ..D HITCHK2
 ;end new code
 G PRIM
 ;
 ; *********************************************************************
HITCHK2 ;
 K ABM("HIT")
 S ABM("PRI")=""
 F  S ABM("PRI")=$O(ABML(ABM("PRI"))) Q:'ABM("PRI")  D HITCHK3
 I $D(ABM("HIT")) Q
 I $G(ABMP("DERP OPT")) Q   ;No editing from inq
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U)'="Y" D
 .I '$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3) D
 ..I "FPUI"[$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0),U,3),$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0)),U,9)!($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,4)="F") D
 ...S DA=I
 ...D KILL
 ..;I ABM("INS")'=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8) D  ;abm*2.6*8
 ..I ABM("INS")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8),($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0),U,3)="U") D  ;abm*2.6*8
 ...S DA=ABMP("CDFN")
 ...S DIE="^ABMDCLM(DUZ(2),"
 ...S DR=".08///@"
 ...D ^DIE
 ...K DR
 Q
 ;
 ; *********************************************************************
HITCHK3 ;
 S ABM("FINS")=""
 F  S ABM("FINS")=$O(ABML(ABM("PRI"),ABM("FINS"))) Q:'ABM("FINS")  D
 . I ABM("FINS")=ABM("INS") S ABM("HIT")=""
 Q
 ;
 ; *********************************************************************
INS ;
 S ABM("INS")=""
 F  S ABM("INS")=$O(ABML(ABM("PRI"),ABM("INS"))) Q:'ABM("INS")  D ADDCHK
 Q
 ;
MERGECK ;mark entries unbillable that aren't in eligibility array
 Q:("CU"[$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4))  ;quit if billed/complete
 S ABMIIEN=0
 F  S ABMIIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",ABMIIEN)) Q:+ABMIIEN=0  D
 .S ABMPRI=0,ABMMATCH=0
 .F  S ABMPRI=$O(ABML(ABMPRI)) Q:+ABMPRI=0  D
 ..I $O(ABML(ABMPRI,0))=ABMIIEN S ABMMATCH=1
 .I ABMMATCH'=1 D
 ..;start old code abm*2.6*8 HEAT37612
 ..;S DA(1)=ABMP("CDFN")
 ..;S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",ABMIIEN,0))
 ..;Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,DA,0)),U,9)="Y"
 ..;S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 ..;D ^DIK
 ..;end old code start new code HEAT37612
 ..S DA(1)=ABMP("CDFN")
 ..S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",ABMIIEN,0))
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,DA,0)),U,9)="Y"
 ..Q:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,DA,0)),U,3)="C"
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 ..S DR=".03////U"  ;set status to unbillable if not returned in elig array
 ..D ^DIE
 ..;end new code HEAT37612
 Q
 ; *********************************************************************
ADDCHK ; EP
 I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",ABM("INS"))) D  Q
 .I ABM("PRI")>96,'$D(^ABMDPARM(DUZ(2),1,6,ABM("INS"))) Q
 .D ADD
 .D COVCHK
 I $P(ABML(ABM("PRI"),ABM("INS")),"^",3)="P" D
 .N I
 .S I=0
 .S ABM("ADD")=1
 .F  S I=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I)) Q:'I  D
 ..Q:$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0),U)'=ABM("INS")
 ..I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0),"^",8)=$P(ABML(ABM("PRI"),ABM("INS")),"^",2) K ABM("ADD")
 I $G(ABM("ADD")),ABM("PRI")<97 D  Q
 .D ADD
 .D COVCHK
 S DA(1)=ABMP("CDFN")
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 I '$G(ADD),$P(ABML(ABM("PRI"),ABM("INS")),U,3)="P" D  Q
 .S DA=0
 .F  S DA=$O(^ABMDCLM(DUZ(2),DA(1),13,"B",ABM("INS"),DA)) Q:'+DA  D
 ..Q:$P(^ABMDCLM(DUZ(2),DA(1),13,DA,0),U,8)'=$P(ABML(ABM("PRI"),ABM("INS")),U,2)
 ..D UPDATE
 S DA=$O(^ABMDCLM(DUZ(2),DA(1),13,"B",ABM("INS"),0))
 Q:'+DA
 D UPDATE
 Q
 ;
 ; *********************************************************************
UPDATE ;
 K ^ABMDCLM(DUZ(2),DA(1),13,DA,11)
 I $P(^ABMDCLM(DUZ(2),DA(1),13,DA,0),U,3)="U",ABM("PRI")<97 D  G COVCHK
 .S DR=".03////P"
 .D ^DIE
 I "IP"[$P(^ABMDCLM(DUZ(2),DA(1),13,DA,0),U,3),ABM("PRI")>96 D
 .S DR=".03////U"
 .D ^DIE
 ;
COVCHK ;
 S ABM("C")=""
 F  S ABM("C")=$O(ABML(ABM("PRI"),ABM("INS"),"COV",ABM("C"))) Q:'ABM("C")  D
 .I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,DA,11,ABM("C"),0)) D ADDCOV
 Q
 ;
 ; *********************************************************************
ADD ;EP - Entry Pont for adding Elig Info to Claim
 K DIC
 S (ABM("L"),ABML("I"))=0
 F  S ABML("I")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABML("I"))) Q:'ABML("I")  S:$P(^(ABML("I"),0),U,2)>ABM("L") ABM("L")=$P(^(0),U,2)
 K ABML("I")
 S ABM("L")=ABM("L")+1
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 S DIC(0)="LE"
 S DIC("P")=$P(^DD(9002274.3,13,0),U,2)
 I ABM("L")=1,'$D(ABML(97)) S ABM("STATUS")="I"
 E  S ABM("STATUS")="P"
 S:ABM("PRI")>96 ABM("STATUS")="U"
 S X=ABM("INS")
 S DIC("DR")=".02///"_ABM("L")_";.03///"_ABM("STATUS")
 I $P(ABML(ABM("PRI"),ABM("INS")),U,3)?1(1"P",1"A",1"W") D
 .S DIC("DR")=DIC("DR")_";.08////"_$P(ABML(ABM("PRI"),ABM("INS")),U,2)
 I $P(ABML(ABM("PRI"),ABM("INS")),U,3)="M" D
 .S DIC("DR")=DIC("DR")_";.04////"_$P(ABML(ABM("PRI"),ABM("INS")),U,2)
 I $P(ABML(ABM("PRI"),ABM("INS")),U,3)="R" D
 .S DIC("DR")=DIC("DR")_";.05////"_$P(ABML(ABM("PRI"),ABM("INS")),U,2)
 I $P(ABML(ABM("PRI"),ABM("INS")),U,3)="D" D
 .S DIC("DR")=DIC("DR")_";.06////"_$P(ABML(ABM("PRI"),ABM("INS")),U,1)
 .S DIC("DR")=DIC("DR")_";.07////"_$P(ABML(ABM("PRI"),ABM("INS")),U,2)
 I $P(ABML(ABM("PRI"),ABM("INS")),U,7)="M" D
 .S DIC("DR")=DIC("DR")_";.09////Y"
 K DD,DO
 D FILE^DICN
 S (DA,ABM("XIEN"))=+Y
 K DIC
 Q
 ;
 ; *********************************************************************
ADDCOV ; EP for adding Coverage Types
 I ABM("C")]"",$D(^AUTTPIC(ABM("C"),0)),$P(^(0),U,2)=ABM("INS")
 E  Q
 K DIC
 S DA(1)=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",ABM("INS"),0))
 S DA(2)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(2)_",13,"_DA(1)_",11,"
 S DIC(0)="LE"
 S DIC("P")=$P(^DD(9002274.3013,11,0),U,2)
 K DD,DO,DR,DIC("DR")
 S (X,DINUM)=ABM("C")
 K DD,DO
 D FILE^DICN
 K DIC
 Q
 ;
 ; *********************************************************************
KILL ;
 S DA(1)=ABMP("CDFN")
 S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 D ^DIK
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8)=ABM("INS") D
 .S DA=ABMP("CDFN")
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DR=".08///@"
 .D ^DIE
 .K DR
 Q
 ;
 ; *********************************************************************
PRIM ; Changed code under this line tag for readability in addition to those
 ; changes documented.
 ;
 S ABMYES=0
 S ABMP("INS")=""
 S ABM("DR")=""
 F  S ABM("DR")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM("DR"))) Q:'ABM("DR")  D  Q:'ABM("DR")
 .S ABM("DA")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM("DR"),""))
 .Q:ABM("DA")=""
 .Q:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("DA"),0))
 .K ABM("DRI")
 .S ABM("I0")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("DA"),0))
 .I "UCB"[$P(ABM("I0"),U,3) Q
 .S ABM("INSCO")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("DA"),0),U)
 .I +ABMYES,$P(ABM("I0"),U,3)="I" S ABM("DRI")=".03////P"
 .I '+ABMYES D
 ..I $P(ABM("I0"),U,3)'="I" D
 ...S ABM("DRI")=".03////I"
 ..S ABMYES=1
 ..I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8)'=ABM("INSCO") D
 ...S ABMINSCK=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",ABM("INSCO"),0))
 ...;replacement insurer?
 ...Q:$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMINSCK,0)),U,11)
 ...S DIE="^ABMDCLM(DUZ(2),"
 ...S DA=ABMP("CDFN")
 ...S DR=".08////^S X=ABM(""INSCO"")"
 ...D ^DIE
 ...K DR
 .I $D(ABM("DRI")) D
 ..S DA(1)=ABMP("CDFN")
 ..S DA=ABM("DA")
 ..S DR=ABM("DRI")
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 ..D ^DIE
 ..K DR
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 I $P(ABMP("C0"),U,8)="" S ABME(111)="" G XIT
 S ABMP("INS")=$P(ABMP("C0"),U,8)
 S ABMTEXP=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,4)
 Q:ABMTEXP=""
 S ABMP("EXP")=ABMTEXP
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 S DR=".14////"_ABMP("EXP")
 D ^DIE
 K DR
 ;
XIT ;
 K ABML
 Q
