ABMDE8B ; IHS/ASDST/DMJ - Edit Page 8 - WORKSHEET SURG PROC ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;A few lines have been added in the ICD subrtn so that surgery page
 ;can accommodate surgical CPT's entered by claim generator
 ;
 ; IHS/SD/SDR - V2.5 P2 - 5/9/02 - NOIS HQW-0302-100190 - Modified to include 2nd and 3rd modifiers and well as units
 ; IHS/SD/SDR - V2.5 P8 - IM10618/IM11164 - Prompt/display provider
 ; IHS/SD/SDR - v2.5 p9 - IM16660 - 4-digit revenue codes
 ; IHS/SD/SDR - v2.5 p9 - task 1 - Use new service line provider multiple
 ; IHS/SD/SDR - v2.5 p10 - IM19843 - Added code for new SERVICE DATE TO prompt
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - v2.5 p13 - IM25777 - Medical charges duplicating because all line items not displaying (BAD X-REF)
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - v2.6 p6 - HEAT28973 - If 55 modifier present use '1' as units for charges
 ; *********************************************************************
 ;
DISP2 K ABMZ S ABMZ("TITL")="SURGICAL PROCEDURES",ABMZ("PG")="8B"
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
APRV G MS:'$D(ABMP(638))
 N I F I="A","O" D
 .S ABMZ("D")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C",I,0))
 .I $G(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,+ABMZ("D"),0)),$P($G(^VA(200,$P(^(0),U),9999999)),U)=2 S ABMZ("CONTRACT")=""
 ;
MS ; Surgical Procedures
 D B^ABMDE8X S ABMZ("SUB")=21,ABMZ("CAT")=11
 S ABMZ("DR")=";W !;.05//"_ABMP("VISTDT")
 S ABMZ("DR")=ABMZ("DR")_";W !;.19//"_ABMP("VISTDT")
 S ABMDPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","O",0))
 S ABMDPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,+ABMDPRV,0)),U)
 S ABMZ("DR")=ABMZ("DR")_";.13//1"
 S ABMZ("CHRG")=";W !;.07"
 S ABMZ("ITEM")="Surgical (CPT Code)"
 S ABMZ("DIC")="^ICPT("
 S ABMZ("X")="X",ABM("TOTL")=0
 S ABMZ("NARR")=";.06////"_U_2_U_7
 D MODE^ABMDE8X
 I ^ABMDEXP(ABMMODE(2),0)["UB" S ABMZ("DR")=";W !;.03//960"_ABMZ("DR")
 S:((^ABMDEXP(ABMMODE(2),0)["HCFA")!(^ABMDEXP(ABMMODE(2),0)["CMS")) ABMZ("DIAG")=";.04"
 D HD G LOOP
 G:'$D(ABMP("VTYP",999)) ^ABMDE8B1
HD ;
 W !,"BIL",?5,"SERV",?12,"REVN",?19,"CORR",?26,"CPT"
 W !,"SEQ",?5,"DATE",?12,"CODE",?19,"DIAG",?26,"CODE",?41,"PROVIDER'S NARRATIVE",?64,"UNITS",?72,"CHARGE"
 W !,"===",?5,"=====",?12,"====",?18,"======",?26,"===========================================",?71,"========"
 Q
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABM)) Q:'ABM  S ABM("X")=ABM,ABMZ("NUM")=ABM("I") D MS1
 S ABM("L")=ABMZ("LNUM")+1,ABMZ("DR2")=";.02////"_ABM("L")
 S ABMZ("MOD")=.09_U_3_U_.11_U_.12
TOTL I ABM("TOTL")>0 W !?70,"=========",!?68,$J(("$"_$FN(ABM("TOTL"),",",2)),11)
 G XIT
 ;
MS1 ;
 ; If no data in surgical multiple, kill the x-ref that brought us here
 I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABM("X"),0)) K ^ABMDCLM(DUZ(2),ABMP("CDFN"),21,"C",ABM,ABM("X")) Q
 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABM("X"),0)
 S ABM("X1")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABM("X"),1))
 S:ABMZ("LNUM")<$P(ABM("X0"),U,2) ABMZ("LNUM")=$P(ABM("X0"),U,2)
 ;
ICD ;     
 K ABM("ICD0")
 S ABM("ICD")=0
 S ABMZ(ABM("I"))=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,2)_U_ABM("X")_U_$P(ABM("X0"),U)_U_$P(ABM("X0"),U,3,13)  ;CSV-c
EOP I $Y>(IOSL-5) D PAUSE^ABMDE1,HD
 S ABMZ("MOD")=""
 F ABM("M")=9,11,12 D
 .S:$P($S(ABM("M")=9:ABM("X0"),1:ABM("X1")),U,ABM("M"))]"" ABMZ("MOD")=ABMZ("MOD")_"-"_$P($S(ABM("M")=9:ABM("X0"),1:ABM("X1")),U,ABM("M"))
 S ABM("LITMTOTAL")=$P(ABM("X0"),"^",7)*$P(ABM("X0"),"^",13)
 I ABMZ("MOD")["55" S ABM("LITMTOTAL")=$P(ABM("X0"),"^",7)*(1)  ;IHS/SD/AML 2/10/2011 - HEAT28973
 S:'+ABM("LITMTOTAL") ABM("LITMTOTAL")=$P(ABM("X0"),"^",7)
 K ABMU S ABMU(1)="?70"_U_$J($FN(ABM("LITMTOTAL"),",",2),9)
 S ABM("TOTL")=ABM("TOTL")+ABM("LITMTOTAL")
 W !,$J(ABM("I"),2)
 W ?5,"CHARGE DATE: ",$$SDT^ABMDUTL($P(ABM("X0"),U,5))
 I $P(ABM("X0"),U,19)'="",($P(ABM("X0"),U,19)'=$P(ABM("X0"),U,5)) W "-",$$SDT^ABMDUTL($P(ABM("X0"),U,19))
 I $P(ABM("X0"),U,14) D
 .W " ("_$P($G(^VA(200,$P(ABM("X0"),U,14),0)),U)_")"
 S ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABM,"P","C","D",0))
 S:ABMRPRV="" ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABM,"P","C","R",0))
 I ABMRPRV'="" D  ;rendering provider on line item
 .W " ("_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABM,"P",ABMRPRV,0),U),0)),U)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABM,"P",ABMRPRV,0),U,2)_")"
 W !,?12,$$GETREV^ABMDUTL($P(ABM("X0"),U,3))
 W ?18,$P(ABM("X0"),U,4)
 W ?26,$P(ABMZ(ABM("I")),U) W:ABMZ("MOD")]"" ABMZ("MOD")
 S ABMU("TXT")=$S($P(ABM("X0"),U,6)]"":$P($G(^AUTNPOV($P(ABM("X0"),U,6),0)),U),1:"")
 S ABMU("LM")=32+$L(ABMZ("MOD"))
 S ABMU("RM")=70
 S ABMU("TAB")=$L(ABMZ("MOD"))
 S ABMU("2TXT")=$P($G(ABM("X0")),U,13)
 S ABMU("2LM")=68
 S ABMU("2RM")=72
 D ^ABMDWRAP
 W:$X<33 ?68,$J(("$"_$FN(ABM("LITMTOTAL"),",",2)),11)
 Q
 ;
XIT I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 K ABM,ABMMODE
 Q
