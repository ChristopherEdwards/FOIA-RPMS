ABMDE2X2 ; IHS/ASDST/DMJ - PAGE 2 - INSURER DATA CK PART 2 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - 10/30/02 - V2.5 P2 - QXX-0402-130120
 ;     Modified to make error codes 11 and 105 more specific when
 ;     checking for data
 ;
 ; IHS/SD/SDR/ - v2.5 p10 - IM20128
 ;   Put PH not patient in 11a/11b
 ;
 ; IHS/SD/SDR - v2.5 p11 - IM22893
 ;   Enhanced check for employer info just in case entry is incomplete
 ;
 ; *********************************************************************
 ;
 ; X2=PHDFN;NAME^RDFN;RELATIONSHIP^ADDR1^ADDR2^PHONE^SEX^DOB
 ; X3=EMPLOYER^ADDR1^ADDR2^PHONE^STATUS;DESC^GROUP^GROUP #^EMPL #
 ;
 I +ABMV("X2")="" G XIT
 I '$D(^AUPN3PPH(+ABMV("X2"),0)) S ABME(65)="" G XIT
 I $P($G(ABMV("X1")),U,5)]"" S $P(ABMV("X2"),";",2)=$P(ABMV("X1"),U,5)
 I $P($G(ABMV("X1")),U,6)]"" S $P(ABMV("X2"),U,7)=$P(ABMV("X1"),U,6)
 ;
GRP ;
 S ABMX("GRP")=$P(^AUPN3PPH(+ABMV("X2"),0),U,6)
 I ABMX("GRP")]"" D
 . I $D(^AUTNEGRP(ABMX("GRP"),0)) D
 .. S $P(ABMV("X3"),U,6)=$P(^AUTNEGRP(ABMX("GRP"),0),U)
 .. S $P(ABMV("X3"),U,7)=$S($D(^AUTNEGRP(ABMX("GRP"),11,ABMP("VTYP"),0)):$P(^(0),U,2),1:$P(^AUTNEGRP(ABMX("GRP"),0),U,2))
 ;
REG ;
 I $P(^AUPN3PPH(+ABMV("X2"),0),U,2)]"",($G(ABMP("PDFN"))'=$P(^AUPN3PPH(+ABMV("X2"),0),U,2)) S ABMX("HDFN")=$P(^AUPN3PPH(+ABMV("X2"),0),U,2)
 E  G PHINFO
 S $P(ABMV("X2"),U,6)=$P(^DPT(ABMX("HDFN"),0),U,2)
 S $P(ABMV("X2"),U,7)=$P(^DPT(ABMX("HDFN"),0),U,3)
 I '+$D(^DPT(ABMX("HDFN"),.11)) S ABME(105)="" Q
 I +$D(^DPT(ABMX("HDFN"),.11)) D
 . I '($P(^DPT(ABMX("HDFN"),.11),U)]"") S ABME(105)="" Q
 . I '($P(^DPT(ABMX("HDFN"),.11),U,4)]"") S ABME(105)="" Q
 . I '($P(^DPT(ABMX("HDFN"),.11),U,5)]"") S ABME(105)="" Q
 . I '($P(^DPT(ABMX("HDFN"),.11),U,6)]"") S ABME(105)="" Q
 . S $P(ABMV("X2"),U,3)=$P(^DPT(ABMX("HDFN"),.11),U)
 . S $P(ABMV("X2"),U,4)=$P(^DPT(ABMX("HDFN"),.11),U,4)_", "
 I $D(ABME(105)) G REMPL
 I $P(^DPT(ABMX("HDFN"),.11),U,5)]"" D
 . I $D(^DIC(5,$P(^DPT(ABMX("HDFN"),.11),U,5),0)) D
 .. S $P(ABMV("X2"),U,4)=$P(ABMV("X2"),U,4)_$P(^DIC(5,$P(^DPT(ABMX("HDFN"),.11),U,5),0),U,2)_"  "_$P(^DPT(ABMX("HDFN"),.11),U,6)
 .. S:$D(^DPT(ABMX("HDFN"),.13)) $P(ABMV("X2"),U,5)=$P(^DPT(ABMX("HDFN"),.13),U)
 E  S ABME(105)=""
 ;
REMPL ;
 I $P(^AUPNPAT(ABMX("HDFN"),0),U,19)]"" D
 .I $D(^AUTNEMPL($P(^AUPNPAT(ABMX("HDFN"),0),U,19),0)) D
 ..S $P(ABMV("X3"),U)=$P(^AUTNEMPL($P(^AUPNPAT(ABMX("HDFN"),0),U,19),0),U)
 ..S ABMX("E0")=$G(^AUTNEMPL($P(^AUPNPAT(ABMX("HDFN"),0),U,19),0))
 E  S ABME(73)="" G XIT
 I $G(ABMX("E0"))="" S ABME(73)=""
 I '($P($G(ABMX("E0")),U,2)]"") S ABME(75)=""
 I '($P($G(ABMX("E0")),U,3)]"") S ABME(75)=""
 I '($P($G(ABMX("E0")),U,4)]"") S ABME(75)=""
 I '($P($G(ABMX("E0")),U,5)]"") S ABME(75)=""
 I $D(ABME(75)) G REMST
 S $P(ABMV("X3"),U,2)=$P(ABMX("E0"),U,2)
 S $P(ABMV("X3"),U,3)=$P(ABMX("E0"),U,3)_", "
 I $D(^DIC(5,$P(ABMX("E0"),U,4),0)) S $P(ABMV("X3"),U,3)=$P(ABMV("X3"),U,3)_$P(^(0),U,2)_"  "_$P(ABMX("E0"),U,5)
 E  S ABME(75)=""
 S $P(ABMV("X3"),U,4)=$P(ABMX("E0"),U,6)
 ;
REMST ;
 S ABMX("Y")=$P(^AUPNPAT(ABMX("HDFN"),0),U,21)
 I ABMX("Y")="" D
 . S ABME(72)=""
 . S ABMX("Y")=9
 S ABMX("Y0")=$P(^DD(9000001,.21,0),U,3)
 S ABMX("Y0")=$P($P(ABMX("Y0"),ABMX("Y")_":",2),";",1)
 S $P(ABMV("X3"),U,5)=ABMX("Y")_";"_ABMX("Y0")
 S $P(ABMV("X3"),U,8)=$S($P(^DPT(ABMX("HDFN"),0),U,9)]""&($P(^(0),U,9)'["-"):$E($P(^(0),U,9),1,3)_"-"_$E($P(^(0),U,9),4,5)_"-"_$E($P(^(0),U,9),6,9),1:$P(^(0),U,9))
 G XIT
 ;
 ; *********************************************************************
PHINFO ; INSURER INFO FROM POLICY HOLDER FILE
 S $P(ABMV("X2"),U,6)=$P(^AUPN3PPH(+ABMV("X2"),0),U,8)
 S $P(ABMV("X2"),U,7)=$P(^AUPN3PPH(+ABMV("X2"),0),U,19)
 S ABMX("Y")=$P(^AUPN3PPH(+ABMV("X2"),0),U,15)
 I ABMX("Y")="" S ABME(72)="" G PHADD
 S ABMX("Y0")=$P(^DD(9000003.1,.15,0),U,3)
 S ABMX("Y0")=$P($P(ABMX("Y0"),ABMX("Y")_":",2),";",1)
 S $P(ABMV("X3"),U,5)=ABMX("Y")_";"_ABMX("Y0")
 ;
PHADD ;
 I $D(^AUPN3PPH(+ABMV("X2"),0)) D
 . I '($P(^AUPN3PPH(+ABMV("X2"),0),U,9)]"") S ABME(105)="" Q
 . I '($P(^AUPN3PPH(+ABMV("X2"),0),U,11)]"") S ABME(105)="" Q
 . I '($P(^AUPN3PPH(+ABMV("X2"),0),U,12)]"") S ABME(105)="" Q
 . I '($P(^AUPN3PPH(+ABMV("X2"),0),U,13)]"") S ABME(105)="" Q
 . S $P(ABMV("X2"),U,3)=$P(^AUPN3PPH(+ABMV("X2"),0),U,9)
 . S $P(ABMV("X2"),U,4)=$P(^AUPN3PPH(+ABMV("X2"),0),U,11)_", "
 I $D(ABME(105)) G PEMPL
 I $D(^DIC(5,$P(^AUPN3PPH(+ABMV("X2"),0),U,12),0)) D
 . S $P(ABMV("X2"),U,4)=$P(ABMV("X2"),U,4)_$P(^DIC(5,$P(^AUPN3PPH(+ABMV("X2"),0),U,12),0),U,2)_"  "_$P(^AUPN3PPH(+ABMV("X2"),0),U,13)
 . S $P(ABMV("X2"),U,5)=$P(^AUPN3PPH(+ABMV("X2"),0),U,14)
 E  S ABME(105)=""
 ;
PEMPL ;
 I $P(^AUPN3PPH(+ABMV("X2"),0),U,16)]"" D
 . I '$D(^AUTNEMPL($P(^AUPN3PPH(+ABMV("X2"),0),U,16),0)) S ABME(73)="" Q
 . S $P(ABMV("X3"),U)=$P(^AUTNEMPL($P(^AUPN3PPH(+ABMV("X2"),0),U,16),0),U)
 . S ABMX("E0")=^AUTNEMPL($P(^AUPN3PPH(+ABMV("X2"),0),U,16),0)
 E  S ABME(73)=""
 I $D(ABME(73)) G XIT
 I $P(ABMX("E0"),U,2)]"",$P(ABMX("E0"),U,3)]"",$P(ABMX("E0"),U,4)]"",$P(ABMX("E0"),U,5)]""
 E  S ABME(75)="" G XIT
 S $P(ABMV("X3"),U,2)=$P(ABMX("E0"),U,2)
 S $P(ABMV("X3"),U,3)=$P(ABMX("E0"),U,3)_", "
 I $D(^DIC(5,$P(ABMX("E0"),U,4),0)) S $P(ABMV("X3"),U,3)=$P(ABMV("X3"),U,3)_$P(^(0),U,2)_"  "_$P(ABMX("E0"),U,5)
 E  S ABME(75)=""
 S $P(ABMV("X3"),U,4)=$P(ABMX("E0"),U,6)
 ;
XIT ;
 K ABMX
 Q
