ABMDE1X ; IHS/ASDST/DMJ - SCRN 1 - CLaim Iden Data Ck ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ;IHS/DSD/DMJ  - 03/23/98 - Modified to clear an undef error.
 ;add $G around expression
 ;
 ; IHS/SD/SDR - 10/30/02 - V2.5 P2 - QXX-0402-130120
 ;     Modified to make error codes 11 and 105 more specific when
 ;     checking for data
 ;
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;
 ; *********************************************************************
 ;
 K ABME
 S ABME("CTR")=0
 S (ABMV("X1"),ABMV("X2"),ABMV("X3"))=""
 I '$D(ABMP("DERP OPT")) D
 .I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,6)="" D
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABMP("CDFN")
 ..S DR=".06////1"
 ..D ^DIE
 .I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),"^",14)="" D
 ..S DIE="^ABMDCLM(DUZ(2),"
 ..S DA=ABMP("CDFN")
 ..S DR=".14////"_$G(ABMP("EXP"))
 ..D ^DIE
 ;
D ;EP
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 N I
 F I=1:1:14 S ABM(I)=$P(ABMP("C0"),"^",I)
 S ABMP("VTYP")=ABM(7)
 S:ABMP("VTYP")]"" ABM(7)=$P($G(^ABMDVTYP(ABMP("VTYP"),0)),U)
 S ABMP("LDFN")=ABM(3)
 S ABM(71)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U)
 S ABM(72)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,2)
 S ABMP("VDT")=ABM(71)
 I ABM(6)]"",$D(^DIC(40.7,ABM(6),0)) S ABM(6)=$P(^(0),U,1)
 E  S ABME(106)=""
 S ABM("PN")=$P(^DPT(ABMP("PDFN"),0),U)
 S ABMP("DOB")=$P(^DPT(ABMP("PDFN"),0),U,3)
 I $G(^DPT(ABMP("PDFN"),.35)) S ABMP("DOD")=$P(^DPT(ABMP("PDFN"),.35),U)
 ;
EMODE ;
 S ABMNPIUS=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 I ABMP("EXP")<21,(ABMNPIUS="B"!(ABMNPIUS="N")) S ABME(222)=""
DOB ;
 S X2=ABMP("DOB")
 S X1=DT
 D ^%DTC
 K DIC
 ;I (X\365)>100,'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),53,38,0)) D
 ;.S (DINUM,X)=38
 ;.S DA(1)=ABMP("CDFN")
 ;.S DIC="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_",53,"
 ;.S DIC(0)="LE"
 ;.S DIC("P")=$P(^DD(9002274.3,53,0),U,2)
 ;.K DD,DO
 ;.D FILE^DICN
 I ABM(71)]"" S ABM(71)=$$SDT^ABMDUTL(ABM(71))
 I ABM(72)]"" S ABM(72)=$$SDT^ABMDUTL(ABM(72))
 E  S ABME(107)=""
 S ABMP("VISTDT")=ABM(71)
 D PAT
 D REMPL^ABMDE1X1
 D LOC^ABMDE1X1
 G XIT
 ;
 ; X2=PDFN;NAME (HRN)^SEX^ADDR 1^ADDR 2^PHONE^DOB^MARTIAL STATUS
 ;
PAT ;EP - Entry Point for setting X2 array for Registered Patient
 I '$D(^DPT(ABMP("PDFN"),0)) S ABME(10)="" Q
 ;
HRN ;
 S ABMV("X2")=ABMP("PDFN")_";"_$P(^DPT(ABMP("PDFN"),0),U,1)
 I ABMP("LDFN")]"" S ABMV("X2")=ABMV("X2")_$S($D(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)):" ("_$P(^(0),U,2)_")",1:" (no HRN)")
 S $P(ABMV("X2"),U,2)=$P(^DPT(ABMP("PDFN"),0),U,2)
 S $P(ABMV("X2"),U,6)=$$HDT^ABMDUTL($P(^DPT(ABMP("PDFN"),0),U,3))
 S $P(ABMV("X2"),U,7)=$S($P($G(^AUPNPAT(ABMP("PDFN"),2)),U,2):"M;MARRIED",1:"U;UNKNOWN")
 I $P(ABMV("X2"),U,2)="" S ABME(13)=""
 I $P(ABMV("X2"),U,6)="" S ABME(12)=""
 I ABMP("VDT")]"" D
 .I $G(^DPT(ABMP("PDFN"),.35)) D
 ..I ABMP("VDT")>$P(^DPT(ABMP("PDFN"),.35),U) D
 ...S ABME(102)=""
 I '+$D(^DPT(ABMP("PDFN"),.11)) S ABME(11)="" Q
 I +$D(^DPT(ABMP("PDFN"),.11)) D
 .I '($P(^DPT(ABMP("PDFN"),.11),U)]"") S ABME(11)="" Q
 .I '($P(^DPT(ABMP("PDFN"),.11),U,4)]"") S ABME(11)="" Q
 .I '($P(^DPT(ABMP("PDFN"),.11),U,5)]"") S ABME(11)="" Q
 .I '($P(^DPT(ABMP("PDFN"),.11),U,6)]"") S ABME(11)="" Q
 .S $P(ABMV("X2"),U,3)=$P(^DPT(ABMP("PDFN"),.11),U)
 .S $P(ABMV("X2"),U,4)=$P(^DPT(ABMP("PDFN"),.11),U,4)_", "
 Q:$D(ABME(11))
 I $P(^DPT(ABMP("PDFN"),.11),U,5)]"" D
 . I $D(^DIC(5,$P(^DPT(ABMP("PDFN"),.11),U,5),0)) D  Q
 ..S $P(ABMV("X2"),U,4)=$P(ABMV("X2"),U,4)_$P(^DIC(5,$P(^DPT(ABMP("PDFN"),.11),U,5),0),U,2)_"  "_$P(^DPT(ABMP("PDFN"),.11),U,6)
 ..S:$D(^DPT(ABMP("PDFN"),.13)) $P(ABMV("X2"),U,5)=$P(^DPT(ABMP("PDFN"),.13),U)
 .S ABME(11)=""
 Q
 ;
 ; *********************************************************************
XIT ;
 K ABMX
 Q
 ;
 ; *********************************************************************
ERR ;
 D ABMDE1X
 S ABME("TITL")="PAGE 1 - CLAIM IDENTIFIERS"
 K ABMV,ABMX,ABM
 Q
