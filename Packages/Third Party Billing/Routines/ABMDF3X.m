ABMDF3X ; IHS/ASDST/DMJ - New HCFA-1500 Format ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ;IHS/DSD/DMJ - 3/8/1999 - Patch 1 NOIS HQW-0399-100108
 ;            Modified line 31 to change 2 units to 1
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM16876
 ;    (cont) removed from block 28/30 if payment
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM15591
 ;    Shift POS left 2 spaces to better align in box
 ;    Changed line37 piece3 from 20 to 18
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM21351
 ;    Extended block 33 group number field to hold 13
 ;    characters
 ;
 ; Import Array: ABMF(line #) = piece 1 ^ piece 2 ^....
 ;         where: line # is the printable horizontal row
 ;                piece is the data element to be printed
 ;
 ; Objective: Print designated form using data contained in the
 ;            ABMF array.
 ;
MARG ;Set left and top margins
 S (ABM("LM"),ABM("TM"),ABM("LN"))=0
 I $D(^ABMDEXP(3,0)),$G(IOT)'="HFS" S ABM("TM")=$P(^(0),U,3),ABM("LM")=$P(^(0),U,2)
 W $$EN^ABMVDF("IOF")
 I +ABM("TM") F ABM("I")=1:1:ABM("TM") W !
 D:$G(ABMP("INS")) OVER
 ;
LOOP ;Loop thru line number array
 S ABM("LN")=$O(ABMF(ABM("LN"))) I +ABM("LN")=0!(ABM("LN")>56) G XIT
 ;
 ;Check for invalid line numbers
 F ABM("I")=2,4,6,8,10,12,14,16,18,20,21,22,24,26,28,30,32,34,35,48,55,56,57 I ABM("LN")=ABM("I") Q
 I  G LOOP
 ;
 ;Set to correct format line
 S ABM("FL")=ABM("LN")
 I ABM("LN")>35,(ABM("LN")<48),$L(ABMF(ABM("LN")),"^")<3 S ABM("FL")=36
 I ABM("LN")>35,(ABM("LN")<48),$L(ABMF(ABM("LN")),"^")>3 S ABM("FL")=37
 ;
 ;Set tab & format variables
 S ABM("TABS")=$P($T(@ABM("FL")),";;",2)
 S ABM("FMAT")=$P($T(@ABM("FL")),";;",3)
 ;
 ;Skip to req'd line
 F  Q:$Y-ABM("TM")>(ABM("LN")+5)  W ! D
 .Q:($Y-ABM("TM")<1)!($Y-ABM("TM")>5)
 .Q:$D(ABMF("TEST"))
 .I $Y-ABM("TM")=5 W ?1,"XXX",?76,"XXX" Q
 .Q:'$D(ABMP("INS"))  K ABM("INS")
 .I ($Y-ABM("TM"))=1 D
 ..S ABM("J")=ABMP("BDFN"),ABM("I")=$P(^AUTNINS(ABMP("INS"),0),U)_"-"_ABMP("INS")
 ..S ABM("INS",ABM("I"),ABM("J"))=$S(ABM("I")["NON-BENEFICIARY PATIENT":$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",5),1:"")
 ..D BADDR^ABMDLBL1
 ..W ?33,"To:"
 .Q:'$D(ABM("ADD"))
 .W ?37,$P(ABM("ADD"),U,($Y-ABM("TM")))
 ;
 ; Test Modes for setting Data Fields
 G LOOP2:'$D(ABMF("TEST"))
 F ABM("I")=1:1:$L(ABM("FMAT"),U) I $P(ABM("TABS"),U,ABM("I"))]"" S ABM("FLD")="",$P(ABM("FLD"),"X",$P(ABM("FMAT"),U,ABM("I"))+1)="" I ABM("FLD")]"" W ?($P(ABM("TABS"),U,ABM("I"))+ABM("LM")) D FRMT
 G LOOP
 ;
LOOP2 ;Loop thru the pieces of the line array
 F ABM("I")=1:1:$L(ABMF(ABM("LN")),U) D
 .Q:'+$P(ABM("TABS"),U,ABM("I"))
 .S ABM("FLD")=$P(ABMF(ABM("LN")),U,ABM("I"))
 .I $G(ABMP("PTOT"))'=1,($D(ABMP("MORE"))),(ABM("LN")=49),(ABM("I")=7!(ABM("I")=9)) S ABM("FLD")=$G(ABM("LTOT"))
 .I ABM("FLD")]"" W ?($P(ABM("TABS"),U,ABM("I"))+ABM("LM")) D FRMT
 .;Put "cont" in total charges box if multi page.
 .I $D(ABMR("MORE")),ABM("LN")=49,ABM("I")=7,$G(ABMP("PTOT"))=1 W ?52,"(CONT.)"
 G LOOP
 ;
 ;Write the field in the designated format
FRMT S ABM("LTH")=$P(ABM("FMAT"),U,ABM("I")) I +ABM("LTH")=0 S ABM("LTH")=99
 I ABM("LTH")["$" S ABM("LTH")=$P(ABM("LTH"),"$") W $J($FN(+ABM("FLD"),",",2),ABM("LTH")) S:ABM("LN")'=49 ABM("LTOT")=+$G(ABM("LTOT"))+ABM("FLD") Q
 I ABM("LTH")["D" S ABM("LTH")=$P(ABM("LTH"),"D") W $E(ABM("FLD"),4,5)," ",$E(ABM("FLD"),6,7)," ",$E(ABM("FLD"),2,3) Q
 I ABM("LTH")["L" S ABM("LTH")=$P(ABM("LTH"),"L") F  Q:$L(ABM("FLD"))=ABM("LTH")!($L(ABM("FLD"))>ABM("LTH"))  S ABM("FLD")="0"_ABM("FLD")
 I ABM("LTH")["C" S ABM("LTH")=$P(ABM("LTH"),"C") S ABM("FLD")=$J("",ABM("LTH")-$L(ABM("FLD"))\2)_ABM("FLD")
 I ABM("LTH")["R" S ABM("LTH")=$P(ABM("LTH"),"R") S ABM("RT")=ABM("LTH")-$L(ABM("FLD"))+1 I ABM("RT")>1 S ABM("BLNK")="",$P(ABM("BLNK")," ",ABM("RT"))="",ABM("FLD")=ABM("BLNK")_ABM("FLD")
 W $E(ABM("FLD"),1,ABM("LTH"))
 Q
 ;
TEST S ABMF("TEST")=1
 F ABM=0:ABMF("TEST"):60 S ABMF(ABM)=""
 G MARG
 ;
OVER ;get override values from 3p insurer file
 S ABMOLN=0 F  S ABMOLN=$O(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",3,ABMOLN)) Q:'ABMOLN  D
 .S ABMOPC=0 F  S ABMOPC=$O(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",3,ABMOLN,ABMOPC)) Q:'ABMOPC  D
 ..K ABMOVTYP
 ..I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",3,ABMOLN,ABMOPC,0)) S ABMOVTYP=0
 ..I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",3,ABMOLN,ABMOPC,ABMP("VTYP"))) S ABMOVTYP=ABMP("VTYP")
 ..Q:'$D(ABMOVTYP)
 ..S ABMVALUE=^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",3,ABMOLN,ABMOPC,ABMOVTYP)
 ..I ABMOLN>36,ABMOLN<49 N I F I=37:2:47 D
 ...Q:'$D(ABMF(I))
 ...S $P(ABMF(I),"^",ABMOPC)=ABMVALUE
 ..I ABMOLN>36,ABMOLN<49 Q
 ..S $P(ABMF(ABMOLN),"^",ABMOPC)=ABMVALUE
 K ABMOLN,ABMOPC,ABMVALUE,ABMOVTYP
 Q
XIT K ABM I '$D(ABMR("MORE")) K ABMF
 Q
TEXT ;;TABS;;FIELD LENGTH
 ;            FORMAT ($-$ FORMAT,L-LNGTH REQ'D,C-CENTER,R-RIGHT,D-DATE)
1 ;;1^8^15^24^31^39^45^50;;1^1^1^1^1^1^1^29C
3 ;;1^31^42^47^50;;28^8D^1^1^29C
5 ;;1^33^38^42^47^50;;28^1^1^1^1^29C
7 ;;1^27^35^41^47^50^75;;24^2^1^1^1^23C^2
9 ;;1^15^35^41^47^50^64;;12^14^1^1^1^12C^14
11 ;;1^50;;28^29C
13 ;;1^35^41^54^68^75;;28^1^1^8D^1^1
15 ;;2^18^24^35^41^46^50;;8D^1^1^1^1^2^29C
17 ;;1^35^41^50;;28C^1^1^29C
19 ;;1^30^52^57;;28C^19C^1^1
23 ;;6^37^56;;24C^8D^23
25 ;;2^37^54^68;;8D^8D^8D^8D
27 ;;1^28^54^68;;26^21C^8D^8D
29 ;;1^52^57^62;;48^1^1^8$
31 ;;3^30^50;;25^19^29
33 ;;3^30^50;;25^19^29C
36 ;;25^71;;16^9
37 ;;2^11^18^22^25^42^50^59^62^65^68^71;;8D^8D^2R^2R^16^7C^8$^3R^2R^2R^2R^9
49 ;;1^17^19^23^38^43^50^61^71;;15^1^1^14C^1^1^10$^9$^8$
50 ;;65;;14
51 ;;23^50;;26^29
52 ;;1^23^50;;21^26^29
53 ;;1^23^50;;21^26^29
54 ;;8^23^49^67;;8^26^13R^13C
