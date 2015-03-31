APSPESAL ;IHS/MSC/MGH;20-Aug-2012 15:36;DU;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1016**;Sep 23, 2004;Build 74
 ;================================================================
 ;Return var     TYPE =          11th piece From 120.8-0,P20) (FA,DA,MA)
 ;       Allergy =       3rd (From 120.8-0,p3)
 ;       Severity =      9th (From 120.85-0,P14)
 ;       Reaction =      10th (From 120.8-10,P1->120.83)
 ;       ID Date =       4th (From 120.85-0,P1) $$HLDATE^HLFNC(DT)
 ; msc/gjg modified 3/2/11 - artf11068
 ; msc/ses modified 5/22/12 - artf12697
 Q
GETADR(RESULT,DFN,ALL,AL1) ;get adverse reaction
 K RESULT N B,I,EIE,HASAL,CNT,INAC,C,J,K,PCNT,TIDDT,TATYPE,TI,TT,ZERO
 S HASAL=0,EIE=0
 I '$D(^DPT(+$G(DFN),0)) S RESULT(1)="-1^INVALID PATIENT" Q
 ;go through allergies.
 S CNT=0
 F I=0:0 S I=$O(^GMR(120.8,"B",DFN,I)) Q:'I  S ZERO=$G(^GMR(120.8,I,0)),EIE=+$G(^("ER")) D
 .Q:+EIE       ; Do not send entered in error Allergies
 .I 'EIE S HASAL=1
 .S INAC=$$INACTIVE^GMRADSP6(I)
 .I INAC=1,ALL="A" Q  ;Not active
 .S (B,C)=""
 .S B=$$GET1^DIQ(120.8,I,"GMR ALLERGY"),PCNT=CNT
 .F J=0:0 S J=$O(^GMR(120.8,I,10,J)) Q:'J  S ZERO(1)=$P(^GMRD(120.83,+$G(^(J,0)),0),U),C=C_$P(ZERO(1),U)_","
 .F K=0:0 S K=$O(^GMR(120.85,"C",I,K)) Q:'K  S ZERO(2)=$G(^GMR(120.85,+K,0)) D ADR
 .I CNT=PCNT S ZERO(2)="" D ADR ;no adversion reporting
 I ('HASAL)&($P($G(^GMR(120.86,+DFN,0)),U,2)=0) S ZERO=$G(^(0)) D
 . K RESULT
 . S RESULT=0,AL1=0
 Q
ADR S CNT=CNT+1
 S TIDDT=$$HLDATE^HLFNC($P(ZERO,U,4))
 S TATYPE=$P(ZERO,U,20),TT=""
 F TI=1:1:$L(TATYPE) S $P(TT,"~",TI)=$S($E(TATYPE,TI)="D":"DA",$E(TATYPE,TI)="F":"FA",$E(TATYPE,TI)="O":"MA",1:"")
 S TATYPE=TT
 ; 1st, 2nd, 3rd, 4th, 5th
 S RESULT(CNT)=I_U_$S(B=$P(ZERO,U,2):$P(ZERO,U,3),1:"")_U_$P(ZERO,U,2)_U_TIDDT_U_$S(B=$P(ZERO,U,2):0,1:1)
 ; 6th, 7th, 8th
 S RESULT(CNT)=RESULT(CNT)_U_$P(ZERO,U,14)_U_$S($P(ZERO,U,16):"VERIFIED",1:"")_U_EIE
 ; 9th,10th,11th
 S RESULT(CNT)=RESULT(CNT)_U_$P("MI^MO^SV",U,$P(ZERO(2),U,14))_U_$E(C,1,$L(C)-1)_U_TATYPE
 Q
