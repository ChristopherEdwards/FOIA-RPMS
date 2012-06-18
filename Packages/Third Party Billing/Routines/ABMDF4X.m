ABMDF4X ; IHS/ASDST/DMJ - ADA-90 FORM ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;08/15/96 9:00 AM
 ;
MARG ;Set left and top margins
 S U="^",(ABM("LM"),ABM("TM"),ABM("LN"))=0
 I $D(^ABMDEXP(4,0)) S ABM("TM")=$P(^(0),U,3),ABM("LM")=$P(^(0),U,2)
 W $$EN^ABMVDF("IOF")
 I +ABM("TM") F ABM("I")=1:1:ABM("TM") W !
 ;
 ;Loop thru line number array
LOOP S ABM("LN")=$O(ABMF(ABM("LN"))) I +ABM("LN")=0!(ABM("LN")>62) G XIT
 ;
 ;Set to correct format line
 S ABM("FL")=ABM("LN")
 I ABM("LN")>34,ABM("LN")<49 S ABM("FL")=35 ;Lines 35 thru 48 are same
 I ABM("LN")>49,ABM("LN")<55 S ABM("FL")=50 ;Lines 50 thru 54 are same
 I ABM("LN")>58,ABM("LN")<63 S ABM("FL")=59 ;Lines 59 thru 62 are same
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
1 ;;1^41;;1^37
2 ;;1^41;;1^37
3 ;;41;;37
5 ;;28^33^58;;1^1^20R
6 ;;2^28^33^37^43^45^47^50^53^58;;24^1^1^5^1^1^2^2^4^20R
8 ;;2^50^68;;24^17^11C
9 ;;2^27^50^68;;24^11^17^11C
10 ;;2^27^39^42^45^50^68;;24^12^2^2^4^17^12C
12 ;;6^10^17^41^57;;1^1^24^15^22
13 ;;17^41^57;;24^15C^22
14 ;;11^14^17^41^57;;1^1^24^15C^22
16 ;;2^59^64;;26^1^1
17 ;;2^29^43^48^52^59^64^68;;26^11^2^2^4^1^1^5
20 ;;2^31^43^70;;26^8D^26^8D
23 ;;2^52^54^56;;38^1^1^22
25 ;;2^52^54^56;;38^1^1^22
27 ;;2^52^54^56;;38^1^1^22
29 ;;2^17^28^52^54^56^71;;13^10^12^1^1^13^8D
31 ;;2^12^16^19^22^34^36^38^52^54^64^76;;8D^1^1^1^1^1^1^2^1^1^8D^2
35 ;;13^17^23^49^51^53^56^64;;3R^5^25^2^2^2^7R^6$
50 ;;1^64;;62^6$
57 ;;2^27^42^61;;23^11R^8D^9$
59 ;;64;;6
