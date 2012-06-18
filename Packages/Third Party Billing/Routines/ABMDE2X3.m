ABMDE2X3 ; IHS/ASDST/DMJ - PAGE 2 - INSURER DATA CK PART 3 ;    
 ;;2.6;IHS Third Party Billing System;**3,8**;NOV 12, 2009
 ;
 ; IHS/ASDS/DMJ - 10/04/00 - V2.4 P3 - NOIS HQW-1000-100062
 ;     Modified code to be CACHE compliant
 ;
 ; IHS/SD/SDR - 10/30/02 - V2.5 P2 - QXX-0402-130120
 ;     Updated error codes 11 and 105 so they would be a little more
 ;     specific and come on if none of the data was there instead of
 ;     just checking the pieces
 ;
 ; IHS/SD/SDR - v2.5 p11 - IM22822
 ;    Fixed <UNDEF>REMPL+16^ABMDE2X3
 ; IHS/SD/SDR - abm*2.6*3 - HEAT8996 - made group number/name print for Medicaid
 ;
 ; *********************************************************************
 ;
 ; X2=PHDFN;NAME^RDFN;RELATIONSHIP^ADDR1^ADDR2^PHONE^SEX^DOB
 ; X3=EMPLOYER^ADDR1^ADDR2^PHONE^STATUS^GROUP^GROUP #^EMPL #
 ;
 S ABMVREL=$P(ABMV("X2"),"^",2)
 I $P(ABMVREL,";",2)="SELF"&($P(ABMV("X1"),U,5)]"") D  G XIT
 .S $P(ABMVREL,";",2)=$P(ABMV("X1"),"^",5)
 .S $P(ABMV("X2"),"^",2)=ABMVREL
 I $P(ABMV("X2"),U)]"" G XIT
 ;
 ;start new code abm*2.6*3 HEAT8996
GRP ;
 ;I $P($G(^AUTNINS(ABMP("INS"),2)),U)="D" D  ;abm*2.6*8 HEAT37612
 I +$G(ABMP("INS"))'=0,$P($G(^AUTNINS(ABMP("INS"),2)),U)="D" D  ;abm*2.6*8 HEAT37612
 .S:(+$G(ABMX("2"))'=0) ABMX("GRP")=$P($G(^AUPNMCD(+ABMX("2"),0)),U,17)
 .I $G(ABMX("GRP"))]"" D
 ..I $D(^AUTNEGRP(ABMX("GRP"),0)) D
 ...S $P(ABMV("X3"),U,6)=$P(^AUTNEGRP(ABMX("GRP"),0),U)
 ...S $P(ABMV("X3"),U,7)=$S($D(^AUTNEGRP(ABMX("GRP"),11,ABMP("VTYP"),0)):$P(^(0),U,2),1:$P(^AUTNEGRP(ABMX("GRP"),0),U,2))
 ;end new code abm*2.6*3 HEAT8996
 ;
REG ;
 S ABMX("HDFN")=ABMP("PDFN")
 S ABMV("X2")=ABMP("PDFN")_";"_$S($P(ABMV("X1"),U,5)]"":$P(ABMV("X1"),U,5),1:$P(^DPT(ABMP("PDFN"),0),U))
 I $P(^DPT(ABMP("PDFN"),0),U,2)]"" S $P(ABMV("X2"),U,6)=$P(^(0),U,2)
 E  S ABME(13)=""
 S $P(ABMV("X2"),U,7)=$P(^DPT(ABMP("PDFN"),0),U,3)
 S $P(ABMV("X2"),U,2)=$O(^AUTTRLSH("B","SELF",""))_";SELF"
 I '+$D(^DPT(ABMX("HDFN"),.11)) S ABME(11)="" Q
 I +$D(^DPT(ABMX("HDFN"),.11)) D
 .I '($P(^DPT(ABMX("HDFN"),.11),U)]"") S ABME(11)="" Q
 .I '($P(^DPT(ABMX("HDFN"),.11),U,4)]"") S ABME(11)="" Q
 .I '($P(^DPT(ABMX("HDFN"),.11),U,5)]"") S ABME(11)="" Q
 .I '($P(^DPT(ABMX("HDFN"),.11),U,6)]"") S ABME(11)="" Q
 .S $P(ABMV("X2"),U,3)=$P(^DPT(ABMX("HDFN"),.11),U)
 .S $P(ABMV("X2"),U,4)=$P(^DPT(ABMX("HDFN"),.11),U,4)_", "
 I $D(ABME(11)) G REMPL
 I $P(^DPT(ABMX("HDFN"),.11),U,5)]"" D
 .I $D(^DIC(5,$P(^DPT(ABMX("HDFN"),.11),U,5),0)) D
 ..S $P(ABMV("X2"),U,4)=$P(ABMV("X2"),U,4)_$P(^DIC(5,$P(^DPT(ABMX("HDFN"),.11),U,5),0),U,2)_"  "_$P(^DPT(ABMX("HDFN"),.11),U,6)
 ..S:$D(^DPT(ABMX("HDFN"),.13)) $P(ABMV("X2"),U,5)=$P(^DPT(ABMX("HDFN"),.13),U)
 E  S ABME(11)=""
 ;
REMPL ; X3=EMPLOYER;ADDR 1^ADDR 2^PHONE^STATUS
 ;
 I $P(^AUPNPAT(ABMX("HDFN"),0),U,19)]"" D
 .I $D(^AUTNEMPL($P(^AUPNPAT(ABMX("HDFN"),0),U,19),0)) D
 ..S ABMX("Y")=^AUTNEMPL($P(^AUPNPAT(ABMX("HDFN"),0),U,19),0)
 ..S $P(ABMV("X3"),U)=$P(ABMX("Y"),U)
 E  S ABME(73)="" G XIT
 I $D(ABMX("Y")) D
 .I '($P(ABMX("Y"),U,2)]"") S ABME(75)="" Q
 .I '($P(ABMX("Y"),U,3)]"") S ABME(75)="" Q
 .I '($P(ABMX("Y"),U,4)]"") S ABME(75)="" Q
 .I '($P(ABMX("Y"),U,5)]"") S ABME(75)="" Q
 .S $P(ABMV("X3"),U,2)=$P(ABMX("Y"),U,2)
 .S $P(ABMV("X3"),U,3)=$P(ABMX("Y"),U,3)_", "
 .I $D(^DIC(5,$P(ABMX("Y"),U,4),0)) D
 ..S $P(ABMV("X3"),U,3)=$P(ABMV("X3"),U,3)_$P(^DIC(5,$P(ABMX("Y"),U,4),0),U,2)_"  "_$P(ABMX("Y"),U,5)
 .S $P(ABMV("X3"),U,4)=$P(ABMX("Y"),U,6)
 S ABMX("Y")=$P(^AUPNPAT(ABMX("HDFN"),0),U,21)
 I ABMX("Y")="" S ABME(72)="" G XIT
 S ABMX("Y0")=$P(^DD(9000001,.21,0),U,3)
 S ABMX("Y0")=$P(ABMX("Y0"),ABMX("Y")_":",2)
 S ABMX("Y0")=$P(ABMX("Y0"),";",1)
 S $P(ABMV("X3"),U,5)=ABMX("Y")_";"_ABMX("Y0")
 ;
XIT ;
 Q
