ABMDF1X ; IHS/ASDST/DMJ - PRINT UB82 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 K ABM
 U IO
 ;
MARG ;Set left and top margins
 W $$EN^ABMVDF("IOF")
 S U="^",(ABM("LM"),ABM("TM"),ABM("LN"))=0
 I $D(^ABMDEXP(1,0)) S ABM("LM")=$P(^(0),U,2),ABM("TM")=$P(^(0),U,3)
 I +ABM("TM") F ABM("I")=1:1:ABM("TM") W !
 ;
 ;Loop thru line number array
LOOP S ABM("LN")=$O(ABMF(ABM("LN"))) I +ABM("LN")=0!(ABM("LN")>63) G XIT
 ;
 ;Check for invalid line numbers
 F ABM("I")=7,9,40,45 I ABM("I")=ABM("LN") Q
 I  G LOOP
 ;
 ;Set to correct format line
 S ABM("FL")=$S(ABM("LN")=1:2,ABM("LN")=3:4,ABM("LN")=5:6,ABM("LN")=11:12,ABM("LN")=13:14,ABM("LN")=15:14,ABM("LN")>17&(ABM("LN")<40):17,ABM("LN")=42:41,ABM("LN")=43:41,ABM("LN")=47:46,1:99)
 I ABM("FL")=99 S ABM("FL")=$S(ABM("LN")=48:46,ABM("LN")=49:50,ABM("LN")=51:50,ABM("LN")=58:59,ABM("LN")=60:61,ABM("LN")=62:63,1:ABM("LN"))
 ;
 ;Set tab & format variables
 S ABM("TABS")=$P($T(@ABM("FL")),";;",2)
 S ABM("FMAT")=$P($T(@ABM("FL")),";;",3)
 ;
 ;Skip to req'd line
 F  Q:$Y-ABM("TM")>(ABM("LN")-2)  W !
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
 I ABM("LTH")["$" S ABM("LTH")=$P(ABM("LTH"),"$") W $J($FN(ABM("FLD"),",",2),ABM("LTH")) Q
 I ABM("LTH")["L" S ABM("LTH")=$P(ABM("LTH"),"L") F  Q:$L(ABM("FLD"))=ABM("LTH")!($L(ABM("FLD"))>ABM("LTH"))  S ABM("FLD")="0"_ABM("FLD")
 I ABM("LTH")["C" S ABM("LTH")=$P(ABM("LTH"),"C") S ABM("CTR")=(ABM("LTH")-$L(ABM("FLD")))\2 I ABM("CTR")>1 S ABM("BLNK")="",$P(ABM("BLNK")," ",ABM("CTR"))="",ABM("FLD")=ABM("BLNK")_ABM("FLD")
 I ABM("LTH")["R" S ABM("LTH")=$P(ABM("LTH"),"R") S ABM("RT")=ABM("LTH")-$L(ABM("FLD")) I ABM("RT")>1 S ABM("BLNK")="",$P(ABM("BLNK")," ",ABM("RT"))="",ABM("FLD")=ABM("BLNK")_ABM("FLD")
 W $E(ABM("FLD"),1,ABM("LTH"))
 Q
 ;
TEST S ABMF("TEST")=1
 F ABM=0:ABMF("TEST"):60 S ABMF(ABM)=""
 G MARG
 ;
XIT K ABMF,ABM
 Q
 ;
TEXT ;;TABS;;FIELD LENGTH/FORMAT ($-$ FORMAT,L-LNTH REQ'D,C-CENTER,R-RIGHT)
2 ;;0^26^58^77;;25^31C^17C^3
4 ;;0^26^40^51^60^73;;25^13C^10C^8C^12C^6C
6 ;;0^32;;30^47C
8 ;;0^9^12^14^23^26^29^31^34^37^40^49^58^62^66^69^72;;8^1^1^8^2L^1^1^2L^2L^2L^8^8^3C^3C^2^2^8C
10 ;;0^3^12^15^24^27^36^39^48^51^60^63^72;;2L^8^2L^8^2L^8^2L^8^2L^8^2L^8^8
12 ;;0^32^35^38^41^44^47^50^53^57^60^63;;31^2L^2L^2L^2L^2L^2^2^2^1^2L^17C
14 ;;0^32^35^44^47^56^59^68^71;;31^2L^8$^2L^8$^2L^8$
16 ;;51^61^71;;9C^9C^9C
17 ;;0^25^33^37^41^51^61^71;;24^7^3^3C^9$^9$^9$^9$
41 ;;0^26^29^31^41^51^61^71;;25^1^1^9$^9$^9$^9$^9$
44 ;;51^61^71;;9$^9$^9$
46 ;;0^25^28^31^48^63;;24^1^2L^16C^14^17C
50 ;;0^3^6^31^43;;2^1^24^11^37
52 ;;19;;26
53 ;;0^46^53^60^67^74;;45^6^6^6^6
54 ;;22;;22
55 ;;1^3^45^51^57^63^69^75;;1^41^5^5^5^5^5^5
56 ;;45^67;;12C^13C
57 ;;1^3^12^21^24^35^58;;1^8^8^1^10C^22^22
58 ;;0;;39C
59 ;;0^40^49^59^63^72;;39C^8^9^4^8^8C
61 ;;0^40^51^55^59^63^72;;39C^10^3^3^3^8^8
63 ;;0^47^70;;39C^20^9
