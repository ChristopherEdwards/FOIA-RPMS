ABMDE8G ; IHS/ASDST/DMJ - Page 8 - ANESTHESIA ;   
 ;;2.6;IHS Third Party Billing;**1,3,6,8**;NOV 12, 2009
 ;
 ; IHS/ASDS/DMJ - v2.4 p7 - 9/7/01 NOIS HQW-0701-100066
 ;     Modifications made related to Medicare Part B.
 ;
 ; IHS/SD/SDR - 11/4/02 - V2.5 P2 - ZZZ-0301-210046
 ;     Modified to capture modifiers from PCC
 ; IHS/SD/SDR - V2.5 P8 - IM10618/IM11164
 ;    Prompt/display provider
 ; IHS/SD/SDR - v2.5 p9 - IM16660
 ;    4-digit revenue codes
 ; IHS/SD/SDR - v2.5 p9 - task 1
 ;   Use new service line provider multiple
 ; IHS/SD/SDR - v2.5 p10 - IM21539
 ;   Made changes to correct display and calculations to be
 ;   correct amounts (was doing stuff that the payer does
 ;   and we shouldn't be)
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - v2.5 p12 - IM24277
 ;   Added code for 2nd and 3rd modifier
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6566 - Added code to do anes.
 ;   one way for Medicare and another for everyone else.
 ; IHS/SD/SDR - abm*2.6*3 - HEAT12742 - corrections to MCR/non-MCR; Adrian spoke with Medicare; they said
 ;   it should be like it was; removed all changes for 6566 so it was back to original code
 ;
DISP K ABMZ S ABMZ("TITL")="ANESTHESIA SERVICES",ABMZ("PG")="8G",ABMZ("ADD1")=""
 I $D(ABMP("DDL")),$Y>(IOSL-9) D PAUSE^ABMDE1 G:$D(DUOUT)!$D(DTOUT)!$D(DIROUT) XIT I 1
 E  D SUM^ABMDE1
 ;
 D G^ABMDE8X
FEE S ABMZ("CAT")=23
 ;S ABMP("ITYP")=$P($G(^AUTNINS(ABMP("INS"),2)),U)  ;abm*2.6*1 HEAT6566  ;abm*2.6*8
 S:ABMP("INS") ABMP("ITYP")=$P($G(^AUTNINS(ABMP("INS"),2)),U)  ;abm*2.6*1 HEAT6566  ;abm*2.6*8
 ;abm*2.6*8 switched below line back; user couldn't manually enter codes
 S ABMZ("DICS")="I ($P(^ICPT(Y,0),""^"")<70000)&($P($$CPT^ABMCVAPI(Y,ABMP(""VDT"")),""^"",7)'=1)"  ;CSV-c  ;abm*2.6*6
 ;S ABMZ("DICS")="I ($P(^ICPT(Y,0),""^"")<70000)&($P($$CPT^ABMCVAPI(Y,ABMP(""VDT"")),""^"",7)=1)"  ;CSV-c  ;abm*2.6*6
 S ABMZ("SUB")=39
 D MODE^ABMDE8X
 S:((^ABMDEXP(ABMMODE(7),0)["HCFA")!(^ABMDEXP(ABMMODE(7),0)["CMS")) ABMZ("DIAG")=";.1"
 S ABMZ("DR")=""
 ;start old code abm*2.6*6 NOHEAT
 ;D
 ;.S ABMDPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,"C","R",0))
 ;.S ABMDPRV=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),41,+ABMDPRV,0)),U)
 ;.K ABMDPRV
 ;end old code NOHEAT
 S ABMZ("CHRG")=";W !;.04"
 S ABMZ("MOD")=.06_U_2_U_.14_U_2_U_.19
 S ABMZ("ITEM")="Anesthesia (CPT Code)"
 S ABMZ("DIC")="^ICPT(",ABMZ("X")="X",ABMZ("TOTL")=0,ABMZ("ANTH")=""
 I ^ABMDEXP(ABMMODE(7),0)["UB" S ABMZ("DR")=ABMZ("DR")_";W !;.02//370"  ;abm*2.6*1 HEAT6566
 ;I ^ABMDEXP(ABMMODE(7),0)["UB",(ABMP("ITYP")'="R") S ABMZ("DR")=";W !;.02//370"_ABMZ("DR")  ;abm*2.6*1 HEAT6566
 ;I ^ABMDEXP(ABMMODE(7),0)["UB",(ABMP("ITYP")="R") S ABMZ("DR")=ABMZ("DR")_";W !;.02//370"  ;abm*2.6*1 HEAT6566
 D HD G LOOP
HD ;
 ;start old code abm*2.6*1 HEAT6566
 W !?5,"REVN",?72,"TOTAL"
 W !?5,"CODE",?10,"        CPT - ANESTHESIA SERVICES",?66,"MIN",?72,"CHARGE"
 W !?5,"====",?10,"======================================================",?66,"===",?71,"========"
 ;end old code start new code HEAT6566
 ;I ABMP("ITYP")'="R" D
 ;.;W !?5,"REVN",?55,"BASE",?64,"TIME",?72,"TOTAL"  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.W !?5,"REVN",?60,"BASE",?64,?72,"TOTAL"  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.;W !?5,"CODE",?10,"         CPT - ANESTHESIA SERVICES",?54,"CHARGE",?63,"CHARGE",?72,"CHARGE"  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.W !?5,"CODE",?10,"         CPT - ANESTHESIA SERVICES",?59,"CHARGE",?72,"CHARGE"  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.;W !?5,"====",?10,"===========================================",?53,"========",?62,"========",?71,"========"  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.W !?5,"====",?10,"===========================================",?58,"========",?71,"========"  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;I ABMP("ITYP")="R" D
 ;.W !?5,"REVN",?72,"TOTAL"
 ;.W !?5,"CODE",?10,"        CPT - ANESTHESIA SERVICES",?66,"MIN",?72,"CHARGE"
 ;.W !?5,"====",?10,"======================================================",?66,"===",?71,"========"
 ;end new code HEAT6566
 Q
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM)) Q:'ABM  D
 .S ABM("X")=ABM,D1=ABM
 .S ABMZ("NUM")=ABM("I")
 .D PC1
 I ABMZ("NUM")>0 W !?69,"==========",!?69,$J("$"_($FN(ABMZ("TOTL"),",",2)),10)
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 G XIT
 ;
PC1 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM("X"),0)
 S ABMZ(ABM("I"))=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,2)_U_ABM("X")_U_$P(ABM("X0"),U,3)  ;CSV-c
 I $Y>(IOSL-5) D PAUSE^ABMDE1,HD
 W !,"[",ABM("I"),"]",?5,$$GETREV^ABMDUTL($P(ABM("X0"),U,2))
 W ?10,$P(ABMZ(ABM("I")),U)
 W:$P($G(ABM("X0")),U,6)'="" "-",$P(ABM("X0"),U,6)
 W:$P($G(ABM("X0")),U,14)'="" "-",$P(ABM("X0"),U,14)
 W:$P($G(ABM("X0")),U,19)'="" "-",$P(ABM("X0"),U,19)
 W " "
 ;start old code abm*2.6*1 HEAT6566
 K ABMU
 S ABMU(1)="?66"_U_$$TM^ABMDUTL($P(ABM("X0"),U,7),$P(ABM("X0"),U,8))
 S ABMU(2)="?71"_U_$J($FN($P(ABM("X0"),U,4),",",2),8)
 S ABMZ("TOTL")=$P(ABM("X0"),U,4)+ABMZ("TOTL")
 ;end old code start new code HEAT6566
 ;I ABMP("ITYP")="R" D
 ;.S ABMU(1)="?66"_U_$$TM^ABMDUTL($P(ABM("X0"),U,7),$P(ABM("X0"),U,8))
 ;.S ABMU(2)="?71"_U_$J($FN(($P(ABM("X0"),U,4)+$P(ABM("X0"),U,3)),",",2),8)
 ;.S ABMZ("TOTL")=$P(ABM("X0"),U,4)+$P(ABM("X0"),U,3)+ABMZ("TOTL")
 ;I ABMP("ITYP")'="R" D
 ;.;K ABMU S ABMU(1)="?53"_U_$J($FN($P(ABM("X0"),U,4),",",2),8)  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.K ABMU S ABMU(1)="?58"_U_$J($FN($P(ABM("X0"),U,4),",",2),8)  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.;S ABM("AN")=+$P(ABM("X0"),"^",3),ABMU(2)="?62"_U_$J($FN(ABM("AN"),",",2),8)  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.S ABM("AN")=+$P(ABM("X0"),"^",3)  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.;S ABMU(3)="?71"_U_$J($FN((ABM("AN")+$P(ABM("X0"),U,4)),",",2),8)  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.S ABMU(2)="?71"_U_$J($FN((+$P(ABM("X0"),U,4)),",",2),8)  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.;S ABMZ("TOTL")=ABM("AN")+$P(ABM("X0"),U,4)+ABMZ("TOTL")  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;.S ABMZ("TOTL")=+$P(ABM("X0"),U,4)+ABMZ("TOTL")  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;end new code HEAT6566
 I $P(^ABMDPARM(DUZ(2),1,0),U,14)'="Y" S ABMU("TXT")=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,3)  ;CSV-c
 ;start CSV-c
 E  D
 .S ABMU("TXT")=""
 .K ABMZCPTD
 .D IHSCPTD^ABMCVAPI($P(ABM("X0"),U),"ABMZCPTD","",ABMP("VDT"))
 .S ABM("CP")=0
 .F  S ABM("CP")=$O(ABMZCPTD(ABM("CP"))) Q:(+ABM("CP")=0)  D
 ..Q:($G(ABMZCPTD(ABM("CP")))="")
 ..S ABMU("TXT")=ABMU("TXT")_ABMZCPTD(ABM("CP"))_" "
 ;end CSV-c
 S ABMU("RM")=51,ABMU("LM")=$S(ABMZ("MOD"):19,1:16) S:ABMZ("MOD") ABMU("TAB")=3 D ^ABMDWRAP
 S ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM,"P","C","D",0))
 S:ABMRPRV="" ABMRPRV=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM,"P","C","R",0))
 I ABMRPRV'="" D  ;rendering provider on line item
 .W !?11," ("_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM,"P",ABMRPRV,0),U),0)),U)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM,"P",ABMRPRV,0),U,2)_")"  ;abm*2.6*1 HEAT6566
 .;I ABMP("ITYP")'="R" W "("_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM,"P",ABMRPRV,0),U),0)),U)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM,"P",ABMRPRV,0),U,2)_")"  ;abm*2.6*1 HEAT6566  ;IHS/SD/SDR 4/27/10 HEAT12742
 .;I ABMP("ITYP")'="R" W !?11,"("_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM,"P",ABMRPRV,0),U),0)),U)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM,"P",ABMRPRV,0),U,2)_")"  ;abm*2.6*1 HEAT6566  ;IHS/SD/SDR 4/27/10 HEAT12742
 .;I ABMP("ITYP")="R" W !?11,"("_$P($G(^VA(200,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM,"P",ABMRPRV,0),U),0)),U)_"-"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),39,ABM,"P",ABMRPRV,0),U,2)_")"  ;abm*2.6*1 HEAT6566
 W !,?11,"Start Date/Time: ",$$MDT^ABMDUTL($P(ABM("X0"),"^",7)),!,?12,"Stop Date/Time: ",$$MDT^ABMDUTL($P(ABM("X0"),"^",8))
 S ABMZ("MOD")=".06"_U_2_U_".14"_U_".19" Q
 ;
XIT K ABM,ABMMODE
 Q
 ;
DICS I $D(ABMP("FEE"))
 Q
