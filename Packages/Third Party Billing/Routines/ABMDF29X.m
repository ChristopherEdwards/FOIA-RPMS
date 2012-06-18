ABMDF29X ; IHS/ASDST/DMJ - ADA-2006 FORM ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**3,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM25568 - Corrected alignment issues
 ; IHS/SD/PMT - abm*2.6*3 - HEAT8604 - Corrected report to start at line 1, not line 2
 ; IHS/SD/SDR - abm*2.6*3 - HEAT12620 - Moved last lin of box 48 one space left
 ;************************************************************************************
 ;
MARG ;Set left and top margins
 S U="^",(ABM("LM"),ABM("TM"),ABM("LN"))=0
 I $D(^ABMDEXP(29,0)) S ABM("TM")=$P(^(0),U,3),ABM("LM")=$P(^(0),U,2)
 W $$EN^ABMVDF("IOF")
 I +ABM("TM") F ABM("I")=1:1:ABM("TM") W !
 ;
LOOP ;
 ;Loop thru line number array
 S ABM("LN")=$O(ABMF(ABM("LN"))) I +ABM("LN")=0!(ABM("LN")>63) G XIT
 ;
 ;Set to correct format line
 S ABM("FL")=ABM("LN")
 ;I ABM("LN")>27,ABM("LN")<37 S ABM("FL")=27 ;Lines 27 thru 36 are same  HEAT8604
 I ABM("LN")>25,ABM("LN")<37 S ABM("FL")=26 ;Lines 27 thru 36 are same
 ;I ABM("LN")>39,ABM("LN")<44 S ABM("FL")=40 ;Lines 40 thru 42 are same  HEAT8604
 I ABM("LN")>38,ABM("LN")<43 S ABM("FL")=40 ;Lines 39 thru 42 are same
  ;
 ;Set tab & format variables
 S ABM("TABS")=$P($T(@ABM("FL")),";;",2)
 S ABM("FMAT")=$P($T(@ABM("FL")),";;",3)
 ;
 ;start new code abm*2.6*8 HEAT41791
 ;added NE Medicaid code for W0047 to print first
 I $P(ABMF(7),U)["NEBRASKA MEDICAID" D
 .F ABMLOOP=26:1:36 D
 ..Q:'$D(ABMF(ABMLOOP))
 ..S ABMCHK=$TR($P(ABMF(ABMLOOP),U,6)," ","")
 ..I ABMCHK["T1015",ABMLOOP'=26 D
 ...S ABMF("TMP")=$G(ABMF(26))
 ...S ABMF(26)=$G(ABMF(ABMLOOP))
 ...S ABMF(ABMLOOP)=$G(ABMF("TMP"))
 K ABMLOOP,ABMCHK,ABMF("TMP")
 ;end new code abm*2.6*8 HEAT41791
 ;
 ;Skip to req'd line
 F  Q:$Y-ABM("TM")>(ABM("LN")+0)  W !
 ;
 ; Test Modes for setting Data Fields
 G LOOP2:'$D(ABMF("TEST"))
 F ABM("I")=1:1:$L(ABM("FMAT"),U) D
 .I $P(ABM("TABS"),U,ABM("I"))]"" D
 ..S ABM("FLD")=""
 ..S $P(ABM("FLD"),"X",$P(ABM("FMAT"),U,ABM("I"))+1)=""
 ..I ABM("FLD")]"" D
 ...W ?($P(ABM("TABS"),U,ABM("I"))+ABM("LM"))
 ...D FRMT
 G LOOP
 ;
LOOP2 ;
 ;Loop thru the pieces of the line array
 F ABM("I")=1:1:$L(ABMF(ABM("LN")),U) D
 .I $P(ABM("TABS"),U,ABM("I"))]"" D
 ..S ABM("FLD")=$P(ABMF(ABM("LN")),U,ABM("I"))
 ..I ABM("FLD")]"" D
 ...W ?($P(ABM("TABS"),U,ABM("I"))+ABM("LM"))
 ...D FRMT
 G LOOP
 ;
FRMT ;
 ;Write the field in the designated format
 S ABM("LTH")=$P(ABM("FMAT"),U,ABM("I"))
 I +ABM("LTH")=0 S ABM("LTH")=99
 ;
 I ABM("LTH")["$" D  Q
 .S ABM("LTH")=$P(ABM("LTH"),"$")
 .S ABM("FLD")=$TR($FN(+ABM("FLD"),"",2),".")
 .S ABM("RT")=ABM("LTH")-$L(ABM("FLD"))+1
 .I ABM("RT")>1 D
 ..S ABM("BLNK")=""
 ..S $P(ABM("BLNK")," ",ABM("RT"))=""
 ..S ABM("FLD")=ABM("BLNK")_ABM("FLD")
 .W $E(ABM("FLD"),1,ABM("LTH"))
 ;
 I ABM("LTH")["D" D  Q
 .S ABM("LTH")=$P(ABM("LTH"),"D")
 .W $E(ABM("FLD"),4,5),"/",$E(ABM("FLD"),6,7),"/",($E(ABM("FLD"),1,3)+1700)
 ;
 I ABM("LTH")["L" D
 .S ABM("LTH")=$P(ABM("LTH"),"L")
 .F  Q:$L(ABM("FLD"))=ABM("LTH")!($L(ABM("FLD"))>ABM("LTH"))  D
 ..S ABM("FLD")="0"_ABM("FLD")
 ;
 I ABM("LTH")["C" D
 .S ABM("LTH")=$P(ABM("LTH"),"C")
 .S ABM("FLD")=$J("",ABM("LTH")-$L(ABM("FLD"))\2)_ABM("FLD")
 ;
 I ABM("LTH")["R" D
 .S ABM("LTH")=$P(ABM("LTH"),"R")
 .S ABM("RT")=ABM("LTH")-$L(ABM("FLD"))+1
 .I ABM("RT")>1 D
 ..S ABM("BLNK")=""
 ..S $P(ABM("BLNK")," ",ABM("RT"))=""
 ..S ABM("FLD")=ABM("BLNK")_ABM("FLD")
 ;
 W $E(ABM("FLD"),1,ABM("LTH"))
 Q
 ;
TEST ;
 S ABMF("TEST")=1
 F ABM=0:ABMF("TEST"):63 S ABMF(ABM)=""
 G MARG
 ;
XIT ;
 I '$D(ABM("MORE")) K ABMF,ABM
 E  K ABM("MORE")
 Q
TEXT ;;TABS;;FIELD LENGTH
 ;            FORMAT ($-$ FORMAT,L-LNGTH REQ'D,C-CENTER,R-RIGHT,D-DATE)
 ;2 ;;1;;1  HEAT8604
1 ;;1;;1
 ;3 ;;1;;1  HEAT8604
2 ;;1;;1
 ;5 ;;1;;30  HEAT8604
4 ;;1;;30
 ;6 ;;42;;30  HEAT8604
5 ;;42;;30
 ;7 ;;42;;30  HEAT8604
6 ;;42;;30
 ;8 ;;5^42;;34^30  HEAT8604
7 ;;5^42;;34^30
 ;9 ;;5;;34  HEAT8604
8 ;;5;;34
 ;10 ;;5;;34  HEAT8604
9 ;;5;;34
 ;11 ;;42^56^59^64;;10D^1^1^15  HEAT8604
10 ;;42^56^59^64;;10D^1^1^15
 ;13 ;;16^26^42^55;;1^1^12^20  HEAT8604
12 ;;16^26^42^55;;1^1^12^20
 ;15 ;;1;;30  HEAT8604
14 ;;1;;30
 ;16 ;;42^47^53^62^70^75;;1^1^1^1^1^1  HEAT8604
15 ;;42^47^53^62^70^75;;1^1^1^1^1^1
 ;17 ;;1^15^18^23;;10D^1^1^10  HEAT8604
16 ;;1^15^18^23;;10D^1^1^10
 ;18 ;;42;;30  HEAT8604
17 ;;42;;30
 ;19 ;;1^15^20^26^33^42;;11^1^1^1^1^30  HEAT8604
18 ;;1^15^20^26^33^42;;11^1^1^1^1^30
 ;20 ;;42;;30  HEAT8604
19 ;;42;;30
 ;21 ;;1;;30  HEAT8604
20 ;;1;;30
 ;22 ;;1;;30  HEAT8604
21 ;;1;;30
 ;23 ;;1^42^56^59^63;;30^10D^1^1^16  HEAT8604
22 ;;1^42^56^59^63;;30^10D^1^1^16
 ;27 ;;1^12^15^18^30^36^42^74;;10D^2^2^11^5^5^30^6$  HEAT8604
26 ;;1^12^15^18^30^36^42^74;;10D^2^2^11^5^5^30^6$
 ;38 ;;74;;6$  HEAT8604
37 ;;74;;6$
 ;39 ;;74;;6$  HEAT8604
38 ;;74;;6$
 ;40 ;;5;;73  HEAT8604
39 ;;5;;73
 ;44 ;;42^50^55^59^67^72^77;;1^1^1^1^2R^2R^2R  HEAT8604
43 ;;42^50^55^59^67^72^77;;1^1^1^1^2R^2R^2R
 ;46 ;;1^28^42^51^65;;25^10D^1^1^10D  HEAT8604
45 ;;1^28^42^51^65;;25^10D^1^1^10D
 ;48 ;;47^51^54^65;;2^1^1^10D  HEAT8604
47 ;;47^51^54^65;;2^1^1^10D
 ;50 ;;2^29^43^58^68;;25^10D^1^1^1  HEAT8604
49 ;;2^29^43^58^68;;25^10D^1^1^1
 ;51 ;;56^77;;10D^2  HEAT8604
50 ;;56^77;;10D^2
 ;55 ;;2^42^69;;30^25^10D  HEAT8604
54 ;;2^42^69;;30^25^10D
 ;56 ;;2;;30  HEAT8604
55 ;;2;;30
 ;57 ;;3^48^69;;30^10^10  HEAT8604 & HEAT12620
56 ;;2^48^69;;30^10^10
 ;58 ;;68;;10  HEAT8604
57 ;;68;;10
 ;59 ;;43;;30  HEAT8604
58 ;;43;;30
 ;60 ;;1^14^27^43;;10^10^11^30  HEAT8604
59 ;;1^14^27^43;;10^10^11^30
 ;61 ;;6^28^46^68;;14^14^12^10  HEAT8604
60 ;;6^28^46^68;;14^14^14^10
 ;60 ;;6^28^46^68;;14^14^12^10  ;abm*2.6*8
