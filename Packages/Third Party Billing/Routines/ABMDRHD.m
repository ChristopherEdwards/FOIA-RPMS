ABMDRHD ; IHS/ASDST/DMJ - Report Header Generator ; 
 ;;2.6;IHS Third Party Billing;**1,3,4**;NOV 12, 2009
 ;Original;TMD;03/25/96 11:34 AM
 ;
 ; IHS/SD/SDR - v2.5 p8 - Added code for cancellation dates
 ; IHS/SD/SDR - abm*2.6*1 - NO HEAT - Added time to report headers
 ; IHS/SD/SDR - abm*2.6*3 - HEAT12210 - fix header if 132 (was wrapping)
 ; IHS/SD/SDR - abm*2.6*4 - NO HEAT - Fixed header for closed/exported dates
 ;
HD ;EP for setting Report Header
 S ABM("LVL")=0,ABM("CONJ")="for ",ABM("TXT")="ALL BILLING SOURCES"
 I $D(ABMY("INS")) S ABM("TXT")=$P(^AUTNINS(ABMY("INS"),0),U) G LOC
 I $D(ABMY("PAT")) S ABM("TXT")=$P(^DPT(ABMY("PAT"),0),U) G LOC
 I $D(ABMY("TYP")) D
 .I ABMY("TYP")="R" S ABM("TXT")="MEDICARE" Q
 .I ABMY("TYP")="D" S ABM("TXT")="MEDICAID" Q
 .I ABMY("TYP")="W" S ABM("TXT")="WORKMEN'S COMP" Q
 .I ABMY("TYP")["W" S ABM("TXT")="PRIVATE+WORKMEN'S COMP" Q
 .I ABMY("TYP")["P" S ABM("TXT")="PRIVATE INSURANCE" Q
 .I ABMY("TYP")="N" S ABM("TXT")="NON-BENEFICIARY PATIENTS" Q
 .I ABMY("TYP")="I" S ABM("TXT")="BENEFICIARY PATIENTS" Q
 .I ABMY("TYP")="K" S ABM("TXT")="CHIP" Q
 .S ABM("TXT")="UNSPECIFIED"
 ;
LOC ;EP
 D CHK I $D(ABMY("LOC")) S ABM("TXT")=$P(^DIC(4,ABMY("LOC"),0),U),ABM("CONJ")="at " D CHK
DT I '$D(ABMY("DT")) G APPR
 S ABM("CONJ")="with "
 ;S ABM("TXT")=$S(ABMY("DT")="A":"APPROVAL DATES",ABMY("DT")="V":"VISIT DATES",ABMY("DT")="P":"PAYMENT DATES",ABMY("DT")="C":"CANCELLATION DATES",ABMY("DT")="X":"CLOSED DATES",1:"EXPORT DATES") D CHK  ;abm*2.6*4 NOHEAT
 S ABM("TXT")=$S(ABMY("DT")="A":"APPROVAL DATES",ABMY("DT")="V":"VISIT DATES",ABMY("DT")="P":"PAYMENT DATES",ABMY("DT")="C":"CANCELLATION DATES",ABMY("DT")="M":"CLOSED DATES",1:"EXPORT DATES") D CHK  ;abm*2.6*4 NOHEAT
 S ABM("CONJ")="from ",ABM("TXT")=$$SDT^ABMDUTL(ABMY("DT",1)) D CHK
 S ABM("CONJ")="to ",ABM("TXT")=$$SDT^ABMDUTL(ABMY("DT",2)) D CHK
APPR I '$D(ABM("APPR")),$D(ABMY("APPR")) S ABM("CONJ")="by ",ABM("TXT")=$P(^VA(200,ABMY("APPR"),0),U) D CHK
PRV I $D(ABMY("PRV")) S ABM("CONJ")="provided by ",ABM("TXT")=$P(^VA(200,ABMY("PRV"),0),U) D CHK
DX I '$D(ABMY("DX")) G PX
 S ABM("CONJ")="with ",ABM("TXT")="DIAGNOSIS RANGE" D CHK
 S ABM("CONJ")="from ",ABM("TXT")=ABMY("DX",1) D CHK
 S ABM("CONJ")="to ",ABM("TXT")=ABMY("DX",2) D CHK
PX I '$D(ABMY("PX")) G XIT
 S ABM("CONJ")="with ",ABM("TXT")="PROCEDURE RANGE" D CHK
 S ABM("CONJ")="from ",ABM("TXT")=ABMY("PX",1) D CHK
 S ABM("CONJ")="to ",ABM("TXT")=ABMY("PX",2) D CHK
 ;
XIT K ABM("CONJ"),ABM("TXT"),ABM("LVL")
 Q
 ;
CHK I ($L(ABM("HD",ABM("LVL")))+1+$L(ABM("CONJ"))+$L(ABM("TXT")))<($S($D(ABM(132)):104,1:52)+$S(ABM("LVL")>0:28,1:0)) S ABM("HD",ABM("LVL"))=ABM("HD",ABM("LVL"))_" "_ABM("CONJ")_ABM("TXT")
 E  S ABM("LVL")=ABM("LVL")+1,ABM("HD",ABM("LVL"))=ABM("CONJ")_ABM("TXT")
 Q
 ;
WHD ;EP for writing Report Header
 W $$EN^ABMVDF("IOF"),!
 I $D(ABM("PRIVACY")) W ?($S($D(ABM(132)):34,1:8)),"WARNING: Confidential Patient Information, Privacy Act Applies",!
 K ABM("LINE") S $P(ABM("LINE"),"=",$S($D(ABM(132)):132,1:80))="" W ABM("LINE"),!
 ;W ABM("HD",0),?$S($D(ABM(132)):108,1:57) S Y=DT X ^DD("DD") W Y,"   Page ",ABM("PG")  ;abm*2.6*1 NO HEAT
 D NOW^%DTC  ;abm*2.6*1 NO HEAT
 ;W ABM("HD",0),?$S($D(ABM(132)):108,1:48) S Y=% X ^DD("DD") W Y,"   Page ",ABM("PG")  ;abm*2.6*1 NO HEAT  ;abm*2.6*3 HEAT12210
 W ABM("HD",0),?$S($D(ABM(132)):103,1:48) S Y=% X ^DD("DD") W Y,"   Page ",ABM("PG")  ;abm*2.6*1 NO HEAT  ;abm*2.6*3 HEAT12210
 W:$G(ABM("HD",1))]"" !,ABM("HD",1)
 W:$G(ABM("HD",2))]"" !,ABM("HD",2)
 W !,"Billing Location: ",$P($G(^AUTTLOC(DUZ(2),0)),U,2)
 W !,ABM("LINE") K ABM("LINE")
 Q
