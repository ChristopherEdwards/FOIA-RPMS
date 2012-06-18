ABMDE2X4 ; IHS/ASDST/DMJ - PAGE 2 - INSURER ADDRESS ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 P3 - 1/24/03 - NEA-0301-180044
 ;     Modified to display patient info when workers comp
 ;
 ; *********************************************************************
 ;
 ; X5=BILLING OFFICE^ADDR1^ADDR2^PHONE
 ;
BADDR ;
 S ABMX("INS")=$P(ABMP("C0"),U,8)
 Q:'$D(^AUTNINS(ABMX("INS"),0))
 S $P(ABMV("X5"),U)=$S($P($G(^AUTNINS(ABMX("INS"),1)),U)]"":$P(^(1),U),1:$P(^(0),U))
 I $D(^AUTNINS(ABMX("INS"),1)) D
 . I '($P(^AUTNINS(ABMX("INS"),1),U,2)]"") S ABMFLAG=1 Q
 . I '($P(^AUTNINS(ABMX("INS"),1),U,3)]"") S ABMFLAG=1 Q
 . I '($P(^AUTNINS(ABMX("INS"),1),U,4)]"") S ABMFLAG=1 Q
 . I '($P(^AUTNINS(ABMX("INS"),1),U,5)]"") S ABMFLAG=1 Q
 . S $P(ABMV("X5"),U,2)=$P(^AUTNINS(ABMX("INS"),1),U,2)
 . S $P(ABMV("X5"),U,3)=$P(^AUTNINS(ABMX("INS"),1),U,3)_", "
 I $G(ABMFLAG) K ABMFLAG G MADDR
 I $P(^AUTNINS(ABMX("INS"),1),U,4)]"" D
 . I $D(^DIC(5,$P(^AUTNINS(ABMX("INS"),1),U,4),0)) D
 .. S $P(ABMV("X5"),U,3)=$P(ABMV("X5"),U,3)_$P(^DIC(5,$P(^AUTNINS(ABMX("INS"),1),U,4),0),U,2)_"  "_$P(^AUTNINS(ABMX("INS"),1),U,5)
 E  K ABMV("X5")
 ;
MADDR ;
 I $D(^AUTNINS(ABMX("INS"),0)) D
 . I '($P(^AUTNINS(ABMX("INS"),0),U,2)]"") S ABMFLAG=1 Q
 . I '($P(^AUTNINS(ABMX("INS"),0),U,3)]"") S ABMFLAG=1 Q
 . I '($P(^AUTNINS(ABMX("INS"),0),U,4)]"") S ABMFLAG=1 Q
 . I '($P(^AUTNINS(ABMX("INS"),0),U,5)]"") S ABMFLAG=1 Q
 . S $P(ABMV("X5"),U,4)=$P(^AUTNINS(ABMX("INS"),0),U,6)
 . S $P(ABMV("X5"),U,2)=$P(^AUTNINS(ABMX("INS"),0),U,2)
 . S $P(ABMV("X5"),U,3)=$P(^AUTNINS(ABMX("INS"),0),U,3)_", "
 I $G(ABMFLAG) K ABMFLAG G NO
 I $P(^AUTNINS(ABMX("INS"),0),U,4)]"" D  Q
 . I $D(^DIC(5,$P(^AUTNINS(ABMX("INS"),0),U,4),0)) D
 .. S $P(ABMV("X5"),U,3)=$P(ABMV("X5"),U,3)_$P(^DIC(5,$P(^AUTNINS(ABMX("INS"),0),U,4),0),U,2)_"  "_$P(^AUTNINS(ABMX("INS"),0),U,5)
 ;
NO ;
 S ABME(112)=""
 S ABMV("X5")=$P(^AUTNINS(ABMX("INS"),0),U)
 ;
XIT ;
 Q
 ;
 ; *********************************************************************
NONBEN ;
 S ABMV("X5")=$P(^DPT(ABMP("PDFN"),0),U)
 S $P(ABMV("X5"),U,4)=$P($G(^DPT(ABMP("PDFN"),.13)),U)
 I '$D(^DPT(ABMP("PDFN"),.11)) S ABME(112)=""
 I $D(^DPT(ABMP("PDFN"),.11)) D
 . I '($P(^DPT(ABMP("PDFN"),.11),U)]"") S ABME(112)="" Q
 . I '($P(^DPT(ABMP("PDFN"),.11),U,4)]"") S ABME(112)="" Q
 . I '($P(^DPT(ABMP("PDFN"),.11),U,5)]"") S ABME(112)="" Q
 . I '($P(^DPT(ABMP("PDFN"),.11),U,6)]"") S ABME(112)="" Q
 . S $P(ABMV("X5"),U,2)=$P(^DPT(ABMP("PDFN"),.11),U)
 . S $P(ABMV("X5"),U,3)=$P(^DPT(ABMP("PDFN"),.11),U,4)_", "
 I $D(ABME(112)) G XIT
 I $D(^DIC(5,$P(^DPT(ABMP("PDFN"),.11),U,5),0)) D
 . S $P(ABMV("X5"),U,3)=$P(ABMV("X5"),U,3)_$P(^DIC(5,$P(^DPT(ABMP("PDFN"),.11),U,5),0),U,2)_"  "_$P(^DPT(ABMP("PDFN"),.11),U,6)
 E  S ABME(112)=""
 G XIT
