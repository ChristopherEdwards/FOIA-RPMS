ABMDF2X ; IHS/ASDST/DMJ - PRINT HCFA 1500 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
MARG ;Set left and top margins
 S U="^",(ABM("LM"),ABM("TM"),ABM("LN"))=0
 I $D(^ABMDEXP(2,0)) S ABM("TM")=$P(^(0),U,3),ABM("LM")=$P(^(0),U,2)
 W $$EN^ABMVDF("IOF")
 I +ABM("TM") F ABM("I")=1:1:ABM("TM") W !
 ;
 ;Loop thru line number array
LOOP S ABM("LN")=$O(ABMF(ABM("LN"))) I +ABM("LN")=0!(ABM("LN")>56) G XIT
 ;
 ;Check for invalid line numbers
 F ABM("I")=2,3,5,11,18,21,22,24,26,28,30,35,49 I ABM("LN")=ABM("I") Q
 I  G LOOP
 ;
 ;Set to correct format line
 S ABM("FL")=$S(ABM("LN")=8:9,ABM("LN")=15:7,ABM("LN")=32:31,ABM("LN")>37&(ABM("LN")<49)&(ABM("LN")#2=1):37,ABM("LN")>37&(ABM("LN")<49)&(ABM("LN")#2=0):38,1:ABM("LN"))
 ;
 ;Set tab & format variables
 S ABM("TABS")=$P($T(@ABM("FL")),";;",2)
 S ABM("FMAT")=$P($T(@ABM("FL")),";;",3)
 ;
 ;Skip to req'd line
 F  Q:$Y-ABM("TM")>(ABM("LN")+3)  W ! D
 .Q:($Y-ABM("TM")<1)!($Y-ABM("TM")>4)
 .I $Y-ABM("TM")=4 W "** Send PAYMENT to PROVIDER in Block 31 **"
 .Q:'$D(ABMP("INS"))  K ABM("INS")
 .I ($Y-ABM("TM"))=1 D
 ..S ABM("J")=ABMP("BDFN"),ABM("I")=$P(^AUTNINS(ABMP("INS"),0),U)_"-"_ABMP("INS")
 ..S ABM("INS",ABM("I"),ABM("J"))=$S(ABM("I")["NON-BENEFICIARY PATIENT":$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",5),1:"")
 ..S ABM("IDFN")=ABMP("INS") D BADDR^ABMDLBL1
 ..W "To:"
 .Q:'$D(ABM("ADD"))
 .W ?4,$P(ABM("ADD"),U,($Y-ABM("TM")))
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
 I ABM("LTH")["L" S ABM("LTH")=$P(ABM("LTH"),"L") F  Q:$L(ABM("FLD"))=ABM("LTH")!($L(ABM("FLD"))>ABM("LTH"))  S ABM("FLD")="0"_ABM("FLD")
 I ABM("LTH")["C" S ABM("LTH")=$P(ABM("LTH"),"C") S ABM("FLD")=$J("",ABM("LTH")-$L(ABM("FLD"))\2)_ABM("FLD")
 I ABM("LTH")["R" S ABM("LTH")=$P(ABM("LTH"),"R") S ABM("RT")=ABM("LTH")-$L(ABM("FLD")) I ABM("RT")>1 S ABM("BLNK")="",$P(ABM("BLNK")," ",ABM("RT"))="",ABM("FLD")=ABM("BLNK")_ABM("FLD")
 W $E(ABM("FLD"),1,ABM("LTH"))
 Q
 ;
TEST S ABMF("TEST")=1
 F ABM=0:ABMF("TEST"):60 S ABMF(ABM)=""
 G MARG
 ;
XIT K ABM I '$D(ABMR("MORE")) K ABMF
 Q
TEXT ;;TABS;;FIELD LENGTH/FORMAT ($-$ FORMAT,L-LNGTH REQ'D,C-CENTER,R-RIGHT)
1 ;;1^13^26^39^52^65;;1^1^1^1^1^1
4 ;;0^32^38^44^50;;29^2^2^2^27C
6 ;;0^37^42^50;;29^1^1^27C
7 ;;0;;29
9 ;;0^50;;29^27C
10 ;;7^32^37^42^47^55;;21^1^1^1^1^1
12 ;;0^50;;29^27
13 ;;0^37^42^50;;29^1^1^27
14 ;;0^58;;29^18
16 ;;0^37^42^55^61;;29^1^1^1^1
17 ;;0^55^68;;29^1^9C
19 ;;50;;27C
20 ;;4^39;;31^10
23 ;;0^30^50^72;;11^19C^17C^1
25 ;;0^17^34^53^68;;12^11^14^10^9
27 ;;0^54^69;;48^9^8
29 ;;0^53^55^63;;48^1^1^9$
31 ;;1^69^72;;48^1^1
33 ;;1;;48
34 ;;1^62;;48^15
36 ;;22;;3
37 ;;0^13^18^27^47^53^62^66^69;;12^3C^8C^20^6C^8$^3R^2R^9C
38 ;;0^13^18^27^47^53^62^66^69;;12R^3C^8C^20^6C^8$^3R^2R^9C
50 ;;0^49^62^71;;29^12$^8R^8C
51 ;;0^37^42;;29^1^1
52 ;;0^50;;29^27
53 ;;0^31^50;;29^18C^27
54 ;;3^50;;24^27
55 ;;50;;27
56 ;;0^31^53;;29C^18C^24C
