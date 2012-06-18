ABMDF25X ; IHS/ASDST/DMJ - ADA-99 FORM ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;09/12/95 8:49 AM
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM19963
 ;   Changed all 1s to 2s in alignment lines
 ;
 ; IHS/SD/SDR v2.5 p10 - IM20078/IM20198
 ;   Shorten dollar amounts to stop wrapping
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20337
 ;   Add code to look at page 9F
 ;
MARG ;Set left and top margins
 S U="^",(ABM("LM"),ABM("TM"),ABM("LN"))=0
 I $D(^ABMDEXP(25,0)) S ABM("TM")=$P(^(0),U,3),ABM("LM")=$P(^(0),U,2)
 W $$EN^ABMVDF("IOF")
 I +ABM("TM") F ABM("I")=1:1:ABM("TM") W !
 ;
LOOP ;
 ;Loop thru line number array
 S ABM("LN")=$O(ABMF(ABM("LN"))) I +ABM("LN")=0!(ABM("LN")>63) G XIT
 ;
 ;Set to correct format line
 S ABM("FL")=ABM("LN")
 I ABM("LN")>27,ABM("LN")<37 S ABM("FL")=27 ;Lines 27 thru 36 are same
 I ABM("LN")>40,ABM("LN")<44 S ABM("FL")=41 ;Lines 41 thru 43 are same
 ;
 ;Set tab & format variables
 S ABM("TABS")=$P($T(@ABM("FL")),";;",2)
 S ABM("FMAT")=$P($T(@ABM("FL")),";;",3)
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
 .W $J($FN(+ABM("FLD"),",",2),ABM("LTH"))
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
2 ;;2;;1
3 ;;2;;1
5 ;;2;;30
6 ;;43;;30
7 ;;43;;30
8 ;;2^43;;30^30
9 ;;2;;30
10 ;;2;;30
11 ;;41^56^59^65;;10D^1^1^15
13 ;;16^26^41^57;;1^1^12^20
15 ;;2;;30
16 ;;42^47^53^62^70^75;;1^1^1^1^1^1
17 ;;2^15^18^23;;10D^1^1^10
18 ;;43;;30
19 ;;2^15^20^26^33^43;;10^1^1^1^1^30
20 ;;43;;30
21 ;;2;;30
22 ;;2;;30
23 ;;1^41^56^59^63;;30^10D^1^1^16
27 ;;2^10^14^18^30^36^43^71;;10D^2^2^8^6^5^29^8$
38 ;;71;;9$
39 ;;71;;9$
41 ;;2;;79
44 ;;42^50^55^58^68^73^78;;1^1^1^1^1^1^1
46 ;;2^28^42^51^67;;24^10D^1^1^10D
48 ;;43^51^54^69;;3^1^1^10D
50 ;;2^28^42^57^67;;27^10D^1^1^1
51 ;;56^77;;10D^2
55 ;;2^41^69;;30^27^10D
56 ;;2;;30
57 ;;2^47^68;;30^12^12
59 ;;43;;30
60 ;;2^13^26^43;;12^12^12^30
61 ;;9^46^68;;14^12^10
