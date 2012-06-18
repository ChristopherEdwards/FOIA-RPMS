ABME8L9 ; IHS/ASDST/DMJ - Header 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Header Segments
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM14722
 ;    Added code to check for FL override for FL32
 ;
 ; IHS/SD/SDR - V2.5 P8 - IM12418/IM14732/IM16264/IM16363/IM16618
 ;    Treat rendering/attending the same
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Don't send rendering if ambulance; send 77 for ambulance
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM19291
 ;    UPIN for Supervising Provider
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM16962
 ;    Removed check for Medicare Part B
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20111
 ;   Added quit if POS=12
 ;
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;
 ; IHS/SD/SDR - v2.5 p11 - IM24200
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM24898
 ;   Change qualifier for supervising provider to 1G
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM25247
 ;   Add missing REF segment for TIN if NPI ONLY
 ;
EP ;START HERE
 N ABM
 K ABMP("PRV")  ;reset provider array
 D GETPRV^ABMEEPRV             ; Build Claim Level Provider array
 S ABMPAYER=ABMP("INS")
 ;
 ; Loop 2310A - Referring Physician Name
 I $D(ABMP("PRV","F")) D
 .S ABM("PRV")=$O(ABMP("PRV","F",0))
 .S ABMLOOP="2310A"
 .D EP^ABME8NM1("DN")
 .D WR^ABMUTL8("NM1")
 .I $$PTAX^ABMEEPRV(ABM("PRV"))'="" D
 ..D EP^ABME8PRV("RF",ABM("PRV"))
 ..D WR^ABMUTL8("PRV")
 .I ABMNPIU="N" D
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))
 ..D WR^ABMUTL8("REF")
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF($S($P($G(ABMB8),U,18)'="":$P(ABMB8,U,18),1:ABMP("RTYPE")),200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 ;
 ; Loop 2310B - Rendering Physician Name
 I $D(ABMP("PRV","R"))!($D(ABMP("PRV","A"))) D
 .Q:$G(ABMP("VTYP"))=831  ;don't write provider info for ASC
 .Q:$G(ABMP("CLIN"))="A3"
 .S ABM("PRV")=$S($D(ABMP("PRV","R")):$O(ABMP("PRV","R",0)),1:$O(ABMP("PRV","A",0)))
 .S ABMLOOP="2310B"
 .D EP^ABME8NM1("82")
 .D WR^ABMUTL8("NM1")
 .D EP^ABME8PRV("PE",ABM("PRV"))
 .D WR^ABMUTL8("PRV")
 .Q:$P($G(^AUTNINS(ABMP("INS"),0)),U)["OKLAHOMA MEDICAID"
 .I ABMNPIU="N" D
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))
 ..Q:((ABMRCID="99999")!(ABMRCID="AHCCCS866004791"))  ;AZ Medicaid
 ..D WR^ABMUTL8("REF")
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 .K ABMLOOP
 ;
 ; Loop 2310C - Purchased Service Physician Name
 I $D(ABMP("PRV","P")) D
 .S ABM("PRV")=$O(ABMP("PRV","P",0))
 .D EP^ABME8NM1("QB")
 .D WR^ABMUTL8("NM1")
 .I ABMNPIU="N" D
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))
 ..D WR^ABMUTL8("REF")
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF(ABMP("RTYPE"),200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 ;
 ;
 ; Loop 2310D - Service Facility Name
 S ABMLOOP="2310D"
 S ABMTRUE=(ABMP("LDFN")'=DUZ(2))
 S:$G(ABMTRUE)="" ABMTRUE=(ABMP("CLIN"))="A3"
 I 'ABMTRUE D
 .Q:$$POS^ABMERUTL<12
 .Q:$$POS^ABMERUTL=12
 .S ABMTRUE=1
 I ABMTRUE D
 .D EP^ABME8NM1($S($G(ABMP("CLIN"))="A3":77,1:"FA"))
 .D OVER^ABMUTLP(51)
 .D WR^ABMUTL8("NM1")
 .I $G(ABMP("CLIN"))="A3" S ABMFILE=9002274.4,ABMIEN=ABMP("BDFN")
 .E  S ABMFILE=4,ABMIEN=ABMP("LDFN")
 .D EP^ABME8N3(ABMFILE,ABMIEN)
 .D OVER^ABMUTLP(52)
 .D WR^ABMUTL8("N3")
 .I $G(ABMP("CLIN"))="A3" S ABMFILE=9002274.4,ABMIEN=ABMP("BDFN")
 .E  S ABMFILE=4,ABMIEN=ABMP("LDFN")
 .D EP^ABME8N4(ABMFILE,ABMIEN)
 .D OVER^ABMUTLP(53)
 .D WR^ABMUTL8("N4")
 .Q:$G(ABMP("CLIN"))="A3"
 .I ABMNPIU'="N" D
 ..I ABMP("ITYPE")="R" D
 ...D EP^ABME8REF("1C",9999999.06,ABMP("LDFN"))
 ...D WR^ABMUTL8("REF")
 ..I ABMP("ITYPE")="D"!(ABMP("ITYPE")="K") D
 ...D EP^ABME8REF("1D",9999999.06,ABMP("LDFN"))
 ...D WR^ABMUTL8("REF")
 ;
 ; Loop 2310E - Supervising Physician Name
 I $D(ABMP("PRV","S")) D
 .S ABM("PRV")=$O(ABMP("PRV","S",0))
 .D EP^ABME8NM1("DQ")
 .D WR^ABMUTL8("NM1")
 .I ABMNPIU="N" D
 ..D EP^ABME8REF("EI",9999999.06,DUZ(2))
 ..D WR^ABMUTL8("REF")
 .I ABMNPIU'="N" D
 ..D EP^ABME8REF("1G",200,ABM("PRV"))
 ..D WR^ABMUTL8("REF")
 Q
