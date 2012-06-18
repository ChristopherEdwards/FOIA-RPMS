DGRPU ;ALB/MRL - REGISTRATION UTILITY ROUTINE ;06 JUN 88@2300
 ;;5.3;Registration;**33,114,489**;Aug 13, 1993
H ;Screen Header
 I DGRPS'=1.1 W @IOF S Z=$P($T(H1+DGRPS),";;",2)_", SCREEN <"_DGRPS_">"_$S($D(DGRPH):" HELP",1:""),X=79-$L(Z)\2 D W
 I DGRPS=1.1 W @IOF S Z="CONFIDENTIAL ADDRESS DATA, SCREEN <"_DGRPS_">"_$S($D(DGRPH):" HELP",1:""),X=79-$L(Z)\2 D W
 S X=$S($D(^DPT(+DFN,0)):^(0),1:""),SSN=$P(X,"^",9),SSN=$E(SSN,1,3)_"-"_$E(SSN,4,5)_"-"_$E(SSN,6,10)
 I '$D(DGRPH) W !,$P(X,"^",1),"; ",SSN S X=$S($D(DGRPTYPE):$P(DGRPTYPE,"^",1),1:"PATIENT TYPE UNKNOWN"),X1=79-$L(X) W ?X1,X
 S X="",$P(X,"=",80)="" W !,X Q
 Q
AL(DGLEN) ;DGLEN= Available length of line
A ;Format address(es)
 I '$D(DGLEN) N DGLEN S DGLEN=29
 N DGX
 F I=DGA1:1:DGA1+2 I $P(DGRP(DGAD),U,I)]"" S DGA(DGA2)=$P(DGRP(DGAD),U,I),DGA2=DGA2+2
 I DGA2=1 S DGA(1)="STREET ADDRESS UNKNOWN",DGA2=DGA2+2
 S J=$S('$D(^DIC(5,+$P(DGRP(DGAD),U,DGA1+4),0)):"",('$L($P(^(0),U,2))):$P(^(0),U,1),1:$P(^(0),U,2)),J(1)=$P(DGRP(DGAD),U,DGA1+3),J(2)=$P(DGRP(DGAD),U,DGA1+5),DGA(DGA2)=$S(J(1)]""&(J]""):J(1)_","_J,J(1)]"":J(1),J]"":J,1:"UNK. CITY/STATE")
 I ".33^.34^.211^.331^.311^.25^.21"[DGAD D
 .F I=1:1:7 I $P(".33^.34^.211^.331^.311^.25^.21",U,I)=DGAD S DGX=$P($G(^DPT(DFN,.22)),U,I)
 E  D
 .I DGAD=.141 S DGX=$P(DGRP(.141),U,6) Q
 .S DGX=$P(DGRP(DGAD),U,DGA1+11)
 S:$L(DGX)>5 DGX=$E(DGX,1,5)_"-"_$E(DGX,6,9)
 S DGA(DGA2)=$E($P(DGA(DGA2),",",1),1,(DGLEN-($L(DGX)+4)))_$S($L($P(DGA(DGA2),",",2)):",",1:"")_$P(DGA(DGA2),",",2)_" "_DGX
 F I=0:0 S I=$O(DGA(I)) Q:'I  S DGA(I)=$E(DGA(I),1,DGLEN)
 K DGA1,I,J
 Q
 ;
W I IOST="C-QUME",$L(DGVI)'=2 W ?X,Z Q
 W ?X,@DGVI,Z,@DGVO
 Q
 ;
H1 ;
 ;;PATIENT DEMOGRAPHIC DATA
 ;;PATIENT DATA
 ;;EMERGENCY CONTACT DATA
 ;;APPLICANT/SPOUSE EMPLOYMENT DATA
 ;;INSURANCE DATA
 ;;MILITARY SERVICE DATA
 ;;ELIGIBILITY STATUS DATA
 ;;FAMILY DEMOGRAPHIC DATA
 ;;INCOME SCREENING DATA
 ;;INELIGIBLE/MISSING DATA
 ;;ELIGIBILITY VERIFICATION DATA
 ;;ADMISSION INFORMATION
 ;;APPLICATION INFORMATION
 ;;APPOINTMENT INFORMATION
 ;;SPONSOR DEMOGRAPHIC INFORMATION
 ;
 ;
INCOME(DFN,DGDT) ; compute income for veteran...if not in 408.21, pass back file 2 data
 ; (called by PTF)
 ;
 ;
 ;  Input:  DFN as IEN of PATIENT file
 ;          DGDT as date to return income as of
 ;
 ; Output:  total income (computed function)
 ;          (from 408.21 if available...otherwise from file 2)
 ;
 ;
 N DGDEP,DGINC,DGREL,DGTOT,DGX,I S DGTOT=0
 D ALL^DGMTU21(DFN,"V",DGDT,"I")
 S DGX=$G(^DGMT(408.21,+$G(DGINC("V")),0)) I DGX]"" F I=8:1:17 S DGTOT=DGTOT+$P(DGX,"^",I)
 I DGX']"" S DGTOT=$P($G(^DPT(DFN,.362)),U,20)
 Q DGTOT
 ;
 ;
MTCOMP(DFN,DGDT) ; is current means test OR COPAY complete?
 ;
 ;  Input:  DFN as IEN of PATIENT file
 ;          DGDT as 'as of' date
 ;
 ; Output:  1 if means test/COPAY for year prior to DT passed is complete
 ;          0 otherwise
 ;          DGMTYPT 1=MT;2=CP;0=NONE
 ;
 N COMP,MT,X,YR
 S YR=$$LYR^DGMTSCU1(DGDT),MT=$$LST^DGMTCOU1(DFN,DGDT)
 S DGMTYPT=+$P(MT,U,5)
 S COMP=1
 I DGMTYPT=1 D  ;MT
 .I $P(MT,"^",4)']""!("^R^N^"[("^"_$P(MT,"^",4)_"^")) S COMP=0
 I DGMTYPT=2 D  ;CP
 .I $P(MT,"^",4)']""!("^I^L^"[("^"_$P(MT,"^",4)_"^")) S COMP=0
 S X=+$P(MT,"^",2) I ($E(X,1,3)-1)*10000<YR S COMP=0
 Q COMP
