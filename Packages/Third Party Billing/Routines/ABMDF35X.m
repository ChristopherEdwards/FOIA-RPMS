ABMDF35X ; IHS/SD/SDR - New HCFA-1500 (02/12) Format ;   
 ;;2.6;IHS Third Party Billing;**13,14,17**;NOV 12, 2009;Build 272
 ;
 ; Objective: Print designated form using data contained in the
 ;            ABMF array.
 ;IHS/SD/SDR - 2.6*14 - HEAT164158 - fixed format of lines 31, 32, and 33; had extra '^' that was throwing things off
 ;IHS/SD/SDR - 2.6*17 - HEAT238640 - Expanded DX fields from 7 to 8 characters
 ;
MARG ;Set left and top margins
 S (ABM("LM"),ABM("TM"),ABM("LN"))=0
 I $G(IOT)'="HFS" S ABM("TM")=$P(^ABMDEXP(35,0),U,3),ABM("LM")=$P(^(0),U,2)
 W $$EN^ABMVDF("IOF")
 I +ABM("TM") F ABM("I")=1:1:ABM("TM") W !
 D:$G(ABMP("INS")) OVER
 ;
LOOP ;Loop thru line number array
 S ABM("LN")=$O(ABMF(ABM("LN"))) I +ABM("LN")=0!(ABM("LN")>56) G XIT
 ;
 ;Check for invalid line numbers
 F ABM("I")=2,4,6,8,10,12,14,16,18,20,21,22,24,28,34,35,48,55,56,57 I ABM("LN")=ABM("I") Q
 I  G LOOP
 ;
 ;Set to correct format line
 S ABM("FL")=ABM("LN")
 I ABM("LN")>35,(ABM("LN")<48),$L(ABMF(ABM("LN")),"^")<4 S ABM("FL")=36
 I ABM("LN")>35,(ABM("LN")<48),$L(ABMF(ABM("LN")),"^")>3 S ABM("FL")=37
 ;
 ;Set tab & format variables
 S ABM("TABS")=$P($T(@ABM("FL")),";;",2)
 S ABM("FMAT")=$P($T(@ABM("FL")),";;",3)
 ;
 ;added NE Medicaid code for W0047 to print first
 ;I $P(ABMF(17),U,4)["NEBRASKA MEDICAID",ABMP("VTYP")=131 D  ;abm*2.6*13 remove box 9C
 I $P(ABMF(17),U,3)["NEBRASKA MEDICAID",ABMP("VTYP")=131 D  ;abm*2.6*13 remove box 9C
 .F ABMLOOP=37:2:47 D
 ..Q:'$D(ABMF(ABMLOOP))
 ..S ABMCHK=$TR($P(ABMF(ABMLOOP),U,5)," ","")
 ..I ABMCHK["W0047",ABMLOOP'=37 D
 ...S ABMF("TMP")=$G(ABMF(37))
 ...S ABMF(37)=$G(ABMF(ABMLOOP))
 ...S ABMF(ABMLOOP)=$G(ABMF("TMP"))
 K ABMLOOP,ABMCHK,ABMF("TMP")
 ;
 ;I $P(ABMF(17),U,4)["IOWA MEDICAID" D  ;abm*2.6*13 remove box 9C
 I $G(ABMP("ITYPE"))="D" D  ;abm*2.6*13
 .F ABMLOOP=37:2:47 D
 ..Q:'$D(ABMF(ABMLOOP))
 ..S ABMCHK=$TR($P(ABMF(ABMLOOP),U,5)," ","")
 ..I ABMCHK["T1015",ABMLOOP'=37 D
 ...S ABMF("TMP")=$G(ABMF(37))
 ...S ABMF(37)=$G(ABMF(ABMLOOP))
 ...S ABMF(ABMLOOP)=$G(ABMF("TMP"))
 K ABMLOOP,ABMCHK,ABMF("TMP")
 ;
 ;Skip to req'd line
 F  Q:$Y-ABM("TM")>(ABM("LN")+5)  W ! D
 .Q:($Y-ABM("TM")<1)!($Y-ABM("TM")>5)
 .Q:$D(ABMF("TEST"))
 .I $Y-ABM("TM")=5 W ?1,"XXX",?32,"Page "_ABMPGCNT_" of "_ABMPGTOT,?76,"XXX" S ABMPGCNT=ABMPGCNT+1 Q
 .Q:'$D(ABMP("INS"))  K ABM("INS")
 .I ($Y-ABM("TM"))=1 D
 ..S ABM("J")=ABMP("BDFN"),ABM("I")=$P(^AUTNINS(ABMP("INS"),0),U)_"-"_ABMP("INS")
 ..S ABM("INS",ABM("I"),ABM("J"))=$S(ABM("I")["NON-BENEFICIARY PATIENT":$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",5),1:"")
 ..D BADDR^ABMDLBL1
 ..W ?34,"To: "
 .Q:'$D(ABM("ADD"))
 .W ?38,$E($P(ABM("ADD"),U,($Y-ABM("TM"))),1,39)
 ;
 ; Test Modes for setting Data Fields
 G LOOP2:'$D(ABMF("TEST"))
 F ABM("I")=1:1:$L(ABM("FMAT"),U) I $P(ABM("TABS"),U,ABM("I"))]"" S ABM("FLD")="",$P(ABM("FLD"),"X",$P(ABM("FMAT"),U,ABM("I"))+1)="" I ABM("FLD")]"" W ?($P(ABM("TABS"),U,ABM("I"))+ABM("LM")) D FRMT
 G LOOP
 ;
LOOP2 ;Loop thru the pieces of the line array
 F ABM("I")=1:1:$L(ABMF(ABM("LN")),U) D
 .Q:'+$P(ABM("TABS"),U,ABM("I"))
 .I ABM("LN")=29,(ABM("I")=4),ABMPGCNT>2 Q
 .;I ABM("LN")>30,(ABM("LN")<34),(ABM("I")<3),($P(ABMF(17),U,4)["MAINE MEDICAID") D  ;abm*2.6*13 remove box 9C
 .I ABM("LN")>30,(ABM("LN")<34),(ABM("I")<3),($P(ABMF(17),U,3)["MAINE MEDICAID") D  ;abm*2.6*13 remove box 9C
 ..S $P(ABMF(ABM("LN")),U,ABM("I"))=$TR($P(ABMF(ABM("LN")),U,ABM("I")),".","")
 .;if Maine Medicaid take commas of out box 24E
 .;I ABM("LN")>36,(ABM("LN")<48),(ABM("I")=6),($P(ABMF(17),U,4)["MAINE MEDICAID") D  ;abm*2.6*13 remove box 9C
 .I ABM("LN")>36,(ABM("LN")<48),(ABM("I")=6),($P(ABMF(17),U,3)["MAINE MEDICAID") D  ;abm*2.6*13 remove box 9C
 ..S $P(ABMF(ABM("LN")),U,ABM("I"))=$TR($P(ABMF(ABM("LN")),U,ABM("I")),",","")
 .S ABM("FLD")=$P(ABMF(ABM("LN")),U,ABM("I"))
 .I $G(ABMP("PTOT"))'=1,($D(ABMP("MORE"))),(ABM("LN")=49),(ABM("I")=7!(ABM("I")=9)) S ABM("FLD")=$G(ABM("LTOT"))
 .I ABM("FLD")]"" W ?($P(ABM("TABS"),U,ABM("I"))+ABM("LM")) D FRMT
 .;Put "cont" in total charges box if multi page.
 .I $D(ABMR("MORE")),ABM("LN")=49,ABM("I")=7,$G(ABMP("PTOT"))=1 W ?52,"(CONT.)"
 G LOOP
 ;
 ;Write the field in the designated format
FRMT S ABM("LTH")=$P(ABM("FMAT"),U,ABM("I")) I +ABM("LTH")=0 S ABM("LTH")=99
 ;I $P(ABMF(17),U,4)="PHC MEDICAID",ABM("LTH")["$" S ABM("LTH")=$P(ABM("LTH"),"$") W $J($TR($FN(+ABM("FLD"),",",2),"."),ABM("LTH")) S:ABM("LN")'=49 ABM("LTOT")=+$G(ABM("LTOT"))+ABM("FLD") Q  ;abm*2.6*13 remove box 9C
 I $P(ABMF(17),U,3)="PHC MEDICAID",ABM("LTH")["$" S ABM("LTH")=$P(ABM("LTH"),"$") W $J($TR($FN(+ABM("FLD"),",",2),"."),ABM("LTH")) S:ABM("LN")'=49 ABM("LTOT")=+$G(ABM("LTOT"))+ABM("FLD") Q  ;abm*2.6*13 remove box 9C
 I ABM("LTH")["$" S ABM("LTH")=$P(ABM("LTH"),"$") W $J($FN(+ABM("FLD"),",",2),ABM("LTH")) S:(ABM("LN")'=49&(ABM("LN")'=29)) ABM("LTOT")=+$G(ABM("LTOT"))+ABM("FLD") Q
 ;if Maine Medicaid take spaces out of dates
 ;I $P(ABMF(17),U,4)["MAINE MEDICAID",(ABM("LTH")["D") S ABM("LTH")=$P(ABM("LTH"),"D") W $E(ABM("FLD"),4,5),$E(ABM("FLD"),6,7),$E(ABM("FLD"),1,3)+1700 Q  ;abm*2.6*13 remove box 9C
 I $P(ABMF(17),U,3)["MAINE MEDICAID",(ABM("LTH")["D") S ABM("LTH")=$P(ABM("LTH"),"D") W $E(ABM("FLD"),4,5),$E(ABM("FLD"),6,7),$E(ABM("FLD"),1,3)+1700 Q  ;abm*2.6*13 remove box 9C
 I ABM("LTH")["T" S ABM("LTH")=$P(ABM("LTH"),"T") W $E(ABM("FLD"),4,5)," ",$E(ABM("FLD"),6,7)," ",$E(ABM("FLD"),2,3) Q
 I ABM("LTH")["D" S ABM("LTH")=$P(ABM("LTH"),"D") W $E(ABM("FLD"),4,5)," ",$E(ABM("FLD"),6,7)," ",$E(ABM("FLD"),1,3)+1700 Q
 I ABM("LTH")["Y" S ABM("LTH")=$P(ABM("LTH"),"Y") W $E(ABM("FLD"),4,7),$E(ABM("FLD"),1,3)+1700 Q
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
OVER ;GET OVRRIDE VALUES FROM 3P INSURER FILE
 S ABMOLN=0 F  S ABMOLN=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",35,ABMOLN)) Q:'ABMOLN  D
 .S ABMOPC=0 F  S ABMOPC=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",35,ABMOLN,ABMOPC)) Q:'ABMOPC  D
 ..K ABMOVTYP
 ..I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",35,ABMOLN,ABMOPC,0)) S ABMOVTYP=0
 ..I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",35,ABMOLN,ABMOPC,ABMP("VTYP"))) S ABMOVTYP=ABMP("VTYP")
 ..Q:'$D(ABMOVTYP)
 ..S ABMVALUE=^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",35,ABMOLN,ABMOPC,ABMOVTYP)
 ..I ABMOLN>35,ABMOLN<49 N I F I=36:1:47 D
 ...Q:'$D(ABMF(I))
 ...Q:$L(ABMF(I),"^")<3
 ...Q:((I#2)'=(ABMOLN#2))
 ...S $P(ABMF(I),"^",ABMOPC)=ABMVALUE
 ..S $P(ABMF(ABMOLN),"^",$S((ABMOLN=53&ABMOPC=1):ABMOPC,(ABMOLN=53):(ABMOPC-1),(ABMOLN=54):(ABMOPC+1),1:ABMOPC))=ABMVALUE
 K ABMOLN,ABMOPC,ABMVALUE,ABMOVTYP
 Q
XIT K ABM
 I '$D(ABMR("MORE")) K ABMF
 Q
TEXT ;;TABS;;FIELD LENGTH
 ;            FORMAT ($-$ FORMAT,L-LNGTH REQ'D,C-CENTER,R-RIGHT,D-DATE)
1 ;;1^8^15^24^31^39^45^50;;1^1^1^1^1^1^1^29C
3 ;;1^31^42^47^50;;28^10D^1^1^29C
5 ;;1^33^38^42^47^50;;28^1^1^1^1^29C
7 ;;1^27^50^75;;24^3^23C^4
 ;;1^27^35^41^47^50^75;;24^3^1^1^1^23C^4  ;abm*2.6*13 remove box 8
9 ;;1^14^50^64;;12^13^12C^13
 ;;1^14^35^41^47^50^64;;12^13^1^1^1^12C^13  ;abm*2.6*13 remove box 8
11 ;;1^50;;28^29C
13 ;;1^35^41^53^68^75;;28^1^1^10D^1^1
15 ;;35^41^46^50;;1^1^2^29C
 ;;2^18^24^35^41^46^50;;10D^1^1^1^1^2^29C  ;abm*2.6*13 remove box 9B
17 ;;35^41^50;;1^1^29C
 ;;1^35^41^50;;28C^1^1^29C  ;abm*2.6*13 remove box 9C
19 ;;1^30^52^57;;28C^19C^1^1
23 ;;6^37^56;;24C^10D^23
25 ;;2^30^54^68;;17^17^10D^10D
26 ;;30;;19
27 ;;2^32^54^68;;26^10^10D^10D
29 ;;1^52^57^62;;48^1^1^8$
30 ;;42;;1
31 ;;3^16^29^42^50;;8^8^8^8^29
 ;;3^16^29^42^50;;7^7^7^7^29  ;abm*2.6*17 IHS/SD/SDR HEAT238640 original line
 ;;3^16^29^42^50;;^7^7^7^7^29  ;abm*2.6*14 IHS/SD/AML 5/6/14 HEAT164158 original line
32 ;;3^16^29^42;;8^8^8^8
 ;;3^16^29^42;;7^7^7^7  ;abm*2.6*17 IHS/
 ;;3^16^29^42;;^7^7^7^7  ;abm*2.6*14 IHS/SD/AML 5/6/14 HEAT164158 original line
33 ;;3^16^29^42^50;;8^8^8^8^29C
 ;;3^16^29^42^50;;7^7^7^7^29C  ;abm*2.6*17 IHS/SD/SDR HEAT238640
 ;;3^16^29^42^50;;^7^7^7^7^29C  ;abm*2.6*14 IHS/SD/AML 5/6/14 HEAT164158 original line
36 ;;1^65^68;;61^2^12
37 ;;1^10^19^22^23^45^50^59^63^65^68;;8T^8T^2R^1R^19^4^8$^4C^2R^2R^10 
49 ;;1^17^19^23^38^43^51^61;;15^1^1^14C^1^1^9$^8$
50 ;;65;;14
51 ;;23^50;;26^29
52 ;;1^23^50;;21^26^29
53 ;;1^23^50;;21^26^29
54 ;;12^23^33^50^62;;10D^10^14R^10C^17
