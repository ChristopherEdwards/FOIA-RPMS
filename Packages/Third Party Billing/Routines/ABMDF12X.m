ABMDF12X ; IHS/ASDST/DMJ - ADA-94 FORM ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;09/12/95 8:49 AM
 ; IHS/SD/SDR - V2.5 P2 - 4/17/02 - NOIS PJB-0302-90027
 ;     Modified to fix problem with format for ADA-94 17b print
 ;     format
 ;
 ; IHS/SD/EFG - V2.5 P8 - IM16385
 ;    Fix year displaying in wrong position
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM14774
 ;    Changed line1 piece3 to 1 from 32
 ;    Changed line6 piece2 to 32 from 33
 ;    Changed line7 piece2 to 32 from 33
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM17574
 ;    Changed line13 from 6^10 to 4^8
 ;    Changed line 15 from 10^13 to 6^11
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM18707
 ;    Changed line30 ;;13^10 to ;;13^12
 ;                
MARG ;Set left and top margins
 S U="^",(ABM("LM"),ABM("TM"),ABM("LN"))=0
 I $D(^ABMDEXP(4,0)) S ABM("TM")=$P(^(0),U,2),ABM("LM")=$P(^(0),U,3)
 W $$EN^ABMVDF("IOF")
 I +ABM("TM") F ABM("I")=1:1:ABM("TM") W !
 ;
 ;Loop thru line number array
LOOP S ABM("LN")=$O(ABMF(ABM("LN"))) I +ABM("LN")=0!(ABM("LN")>62) G XIT
 ;
 ;Set to correct format line
 S ABM("FL")=ABM("LN")
 I ABM("LN")>35,ABM("LN")<50 S ABM("FL")=36 ;Lines 36 thru 49 are same
 I ABM("LN")>50,ABM("LN")<56 S ABM("FL")=51 ;Lines 51 thru 55 are same
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
 F ABM("I")=1:1:$L(ABM("FMAT"),U) I $P(ABM("TABS"),U,ABM("I"))]"" S ABM("FLD")="",$P(ABM("FLD"),"X",$P(ABM("FMAT"),U,ABM("I"))+1)="" I ABM("FLD")]"" W ?($P(ABM("TABS"),U,ABM("I"))+ABM("LM")) D FRMT
 G LOOP
 ;
 ;Loop thru the pieces of the line array
LOOP2 F ABM("I")=1:1:$L(ABMF(ABM("LN")),U) I $P(ABM("TABS"),U,ABM("I"))]"" S ABM("FLD")=$P(ABMF(ABM("LN")),U,ABM("I")) I ABM("FLD")]"" W ?($P(ABM("TABS"),U,ABM("I"))+ABM("LM")) D FRMT
 G LOOP
 ;
 ;Write the field in the designated format
FRMT S ABM("LTH")=$P(ABM("FMAT"),U,ABM("I")) I +ABM("LTH")=0 S ABM("LTH")=99
 I ABM("LTH")["$" S ABM("LTH")=$P(ABM("LTH"),"$") W $J($FN(+ABM("FLD"),",",2),ABM("LTH")) Q
 I ABM("LTH")["D" S ABM("LTH")=$P(ABM("LTH"),"D") W $E(ABM("FLD"),4,5),"-",$E(ABM("FLD"),6,7),"-",$E(ABM("FLD"),2,3) Q
 I ABM("LTH")["L" S ABM("LTH")=$P(ABM("LTH"),"L") F  Q:$L(ABM("FLD"))=ABM("LTH")!($L(ABM("FLD"))>ABM("LTH"))  S ABM("FLD")="0"_ABM("FLD")
 I ABM("LTH")["C" S ABM("LTH")=$P(ABM("LTH"),"C") S ABM("FLD")=$J("",ABM("LTH")-$L(ABM("FLD"))\2)_ABM("FLD")
 I ABM("LTH")["R" S ABM("LTH")=$P(ABM("LTH"),"R") S ABM("RT")=ABM("LTH")-$L(ABM("FLD"))+1 I ABM("RT")>1 S ABM("BLNK")="",$P(ABM("BLNK")," ",ABM("RT"))="",ABM("FLD")=ABM("BLNK")_ABM("FLD")
 W $E(ABM("FLD"),1,ABM("LTH"))
 Q
 ;
TEST S ABMF("TEST")=1
 F ABM=0:ABMF("TEST"):62 S ABMF(ABM)=""
 G MARG
 ;
XIT I '$D(ABM("MORE")) K ABMF,ABM
 E  K ABM("MORE")
 Q
TEXT ;;TABS;;FIELD LENGTH
 ;            FORMAT ($-$ FORMAT,L-LNGTH REQ'D,C-CENTER,R-RIGHT,D-DATE)
1 ;;1^22^46;;1^1^32
2 ;;1^22^46;;1^1^32
3 ;;1^46;;12^32
4 ;;7^27^46;;11^17^32
6 ;;28^32^58;;1^1^20R
7 ;;2^28^32^37^43^45^47^50^53^58;;24^1^1^5^1^1^2^2^4^20R
9 ;;2^50^68;;24^17^11C
10 ;;2^27^50^68;;24^11^17^12C
11 ;;2^26^41^42^45^50^68;;24^14^2^2^4^17^11C
13 ;;4^8^16^41^57;;1^1^23^15^22
14 ;;16^41^57;;23^15C^22
15 ;;6^11^16^41^57;;1^1^23^15C^22
17 ;;2^58^63;;25^1^1
18 ;;2^28^42^47^51^58^63^68;;25^11^2^2^4^1^1^6
21 ;;2^30^42^70;;25^8D^25^8D
24 ;;2^52^54^56;;37^1^1^22
26 ;;2^52^54^56;;37^1^1^22
28 ;;2^52^54^56;;37^1^1^22
30 ;;2^17^30^52^54^56^71;;13^12^12^1^1^13^8D
32 ;;2^12^16^19^22^34^36^38^52^54^64^76;;8D^1^1^1^1^1^1^2^1^1^8D^2
36 ;;13^17^23^49^51^53^56^64;;3R^5^25^2^2^2^7R^6$
51 ;;1^64;;62^6$
56 ;;61;;9$
58 ;;2^27^42^61;;23^11R^8D^9$
60 ;;69;;12
61 ;;1^33^45^50^69;;30^9^2^5^12
62 ;;69;;12
63 ;;69;;12
