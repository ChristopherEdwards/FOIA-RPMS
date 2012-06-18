ABMDESM ; IHS/ASDST/DMJ - Display Summarized Claim Info ;    
 ;;2.6;IHS 3P BILLING SYSTEM;**6,8**;NOV 12, 2009
 ;
 ; IHS/ASDS/DMJ - 04/18/00 - V2.4 Patch 1 - NOIS XAA-0400-200044
 ;     Modified mode of export loop to include 16 and 17
 ; IHS/ASDS/LSL - 05/15/00 - V2.4 Patch 1 - NOIS NDA-0500-180042
 ;     Modified to populate total by export mode properly.
 ; IHS/ASDS/DMJ - 07/24/01 - v2.4 Patch 7 - NOIS HQW-0701-100066
 ;     Modified mode of export loop to include 20
 ; IHS/ASDS/SDH - 08/14/01 - V2.4 Patch 9 - NOIS NDA-1199-180065
 ;     Modified to include groupler allowance, non-covered, and 
 ;     penalties in the writeoff category.
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM21581 - Added active insurer print to summary
 ; IHS/SD/SDR - v2.5 p11 - NPI; Added checks for new export modes (27/28/29)
 ; IHS/SD/SDR - v2.5 p13 - IM25002 - Change for Medi-Cal when Medi/Medi
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added export mode 32
 ;
 ; *********************************************************************
 ;
 S ABMP("GL")="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_",",ABMP("TOT")=0,ABMP("NC")=0
 I '$G(ABMQUIET) W $$EN^ABMVDF("IOF")
 S ABMP("TMP-EXP")=ABMP("EXP")
 ;F ABMP("EXP")=1,10,11,2,3,13,14,15,16,17,19,20,21,22,23,24,27,28,51 I $D(ABMP("EXP",ABMP("EXP"))) D  ;abm*2.6*6 5010
 ;F ABMP("EXP")=1,10,11,2,3,13,14,15,16,17,19,20,21,22,23,24,27,28,32,51 I $D(ABMP("EXP",ABMP("EXP"))) D  ;abm*2.6*6 5010  ;abm*2.6*8 5010
 F ABMP("EXP")=1,10,11,2,3,13,14,15,16,17,19,20,21,22,24,27,28,31,32,51 I $D(ABMP("EXP",ABMP("EXP"))) D  ;abm*2.6*6 5010  ;abm*2.6*8 5010
 .D ^ABMDESM1
 .S ABMP("EXP",ABMP("EXP"))=+ABMS("TOT")
 .I $P(^ABMDEXP(ABMP("EXP"),0),U)["UB" D  Q
 ..S ABMP("NC")=$S($P($G(ABMP("FLAT")),U,2):$P(ABMS($P(ABMP("FLAT"),U,2)),U,5),1:0)
 ..I ABMS("TOT"),'$G(ABMQUIET) D ^ABMDES1,^ABMPPADJ
 .Q:'ABMS("TOT")
 .Q:$G(ABMQUIET)
 .I $P($G(^ABMDEXP(ABMP("EXP"),1)),U)]"" D @("^"_$P(^(1),U)),^ABMPPADJ Q
 .D @("^ABMDES"_ABMP("EXP")),^ABMPPADJ
 Q:($G(ABMSFLG)=1)
 S ABMP("EXP")=ABMP("TMP-EXP") K ABMP("TMP-EXP")
 I $G(ABMTFLAG)=1 S (ABMP("TOT"),ABMP("EXP",ABMEXPMS))=+$G(ABMP("CBAMT")) Q  ;don't do summary below if 2NDARY with one export mode
 ;
VTYP S ABMP=3 F  S ABMP=$O(ABMP("EXP",ABMP)) Q:'ABMP  D
 .Q:ABMP=10
 .Q:ABMP=11
 .Q:ABMP=13
 .Q:ABMP=14
 .Q:ABMP=15
 .Q:ABMP=16
 .Q:ABMP=17
 .Q:ABMP=19
 .Q:ABMP=20
 .Q:ABMP=21
 .Q:ABMP=22
 .;Q:ABMP=23  ;abm*2.6*8
 .Q:ABMP=24
 .Q:ABMP=27
 .Q:ABMP=28
 .Q:ABMP=31  ;abm*2.6*8 5010
 .Q:ABMP=32  ;abm*2.6*6 5010
 .Q:ABMP=51
 .I $P($G(^ABMDEXP(ABMP,1)),U)]"" D @("^"_$P(^(1),U)) I 1
 .E  D @("^ABMDES"_ABMP)
 .S:$G(ABMP("EXP",ABMP)) ABMP("TOT")=ABMP("TOT")+ABMP("EXP",ABMP)
 ;
 Q:$G(ABMQUIET)
 D PREV^ABMDFUTL
 S ABMP("RATIO")=1/$S((ABMP("TOT")-ABMP("NC"))>0:(ABMP("TOT")-ABMP("NC")),1:1)
 ;
 W $$EN^ABMVDF("IOF")
 S $P(ABM("="),"=",80)=""
 W !,?35,"SUMMARY",!,ABM("=")
 W !!,"Active Insurer: ",$P($G(^AUTNINS(ABMP("INS"),0)),U),!
 W !!,?30,"Previous",?68,"Bill"
 W !,?8,"Form",?18,"Charges",?30,"Payments",?41,"Write-offs",?54,"Non-cvd",?67,"Amount"
 W !?5,"----------  ----------  ----------  ----------  ----------  ----------"
 S ABM("NT")=ABMP("NC")
 F ABM=0:0 S ABM=$O(ABMP("EXP",ABM)) Q:'ABM  D
 .W !?1,$P(^ABMDEXP(ABM,0),U)  ;form name
 .W ?17,$J($FN(ABMP("EXP",ABM),",",2),10)  ;charges
 .S ABM("P")=+$FN(ABMP("PD")*ABMP("RATIO")*(ABMP("EXP",ABM)-ABM("NT")),"",3)
 .W ?29,$J($FN(ABM("P"),",",2),10)  ;payments
 .S ABMP("WO")=ABMP("WO")+($G(ABMP("GRP")))+$G(ABMP("NONC"))
 .S ABMP("WO")=ABMP("WO")+$G(ABMP("PENS"))
 .S ABM("W")=+$FN(ABMP("WO")*ABMP("RATIO")*(ABMP("EXP",ABM)-ABM("NT")),"",3)
 .W ?41,$J($FN(ABM("W"),",",2),10)  ;writeoffs
 .D MEDICHK  ;check for Medicare/Medi-Cal
 .I $G(ABMMFLG)'=1 S ABMP("EXP",ABM)=ABMP("EXP",ABM)-ABM("P")-ABM("W")-ABM("NT")
 .S:ABMP("EXP",ABM)<0 ABMP("EXP",ABM)=0
 .W ?53,$J($FN(ABM("NT"),",",2),10)  ;non-covered
 .I ABMP("NC") S ABM("NT")=0
 .W ?65,$J($FN(ABMP("EXP",ABM),",",2),10)  ;amount
 W !?17,"==========  ==========  ==========  ==========  =========="
 W !?17,$J($FN(ABMP("TOT"),",",2),10)
 W ?29,$J($FN(ABMP("PD"),",",2),10)
 W ?41,$J($FN(ABMP("WO"),",",2),10)
 W ?53,$J($FN(ABMP("NC"),",",2),10)
 S ABMP("TOT")=ABMP("TOT")-ABMP("NC")
 S ABMP("TOT")=+$FN($S(ABMP("TOT")<1:0,1:ABMP("TOT")),"",3)
 W ?65,$J($FN(ABMP("TOT"),",",2),10)
 ;
XIT K ABMS
 Q
 ;
MEDICHK ;EP
 S ABMI=0
 K ABMMCRC,ABMMCDI
 F  S ABMI=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMI)) Q:+ABMI=0  D
 .S ABMIREC=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABMI,0))
 .I $P(ABMIREC,U,3)="C"&($P(ABMIREC,U)=2) S ABMMCRC=1
 .I $P(ABMIREC,U,3)="I"&($$RCID^ABMUTLP($P(ABMIREC,U))["61044") S ABMMCDI=1
 I $G(ABMMCRC)=1&($G(ABMMCDI)=1) S ABMMFLG=1
 Q
