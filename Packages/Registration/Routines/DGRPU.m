DGRPU ;ALB/MRL,TMK - REGISTRATION UTILITY ROUTINE ;19 OCT 2005
 ;;5.3;Registration;**33,114,489,624,672,689,1015**;Aug 13, 1993;Build 20
H ;Screen Header
 I DGRPS'=1.1 W @IOF S Z=$P($T(H1+DGRPS),";;",2)_", SCREEN <"_DGRPS_">"_$S($D(DGRPH):" HELP",1:""),X=79-$L(Z)\2 D W
 I DGRPS=1.1 W @IOF S Z="ADDITIONAL PATIENT DEMOGRAPHIC DATA, SCREEN <"_DGRPS_">"_$S($D(DGRPH):" HELP",1:""),X=79-$L(Z)\2 D W
 S X=$$SSNNM(DFN)
 I '$D(DGRPH) W !,X S X=$S($D(DGRPTYPE):$P(DGRPTYPE,"^",1),1:"PATIENT TYPE UNKNOWN"),X1=79-$L(X) W ?X1,X
 S X="",$P(X,"=",80)="" W !,X Q
 Q
 ;
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
 ;
HLP1010 ;* This is called by the Executable Help for Patient field #1010.159
 ;   (APPOINTMENT REQUEST ON 1010EZ)
 W !!,"    Enter a 'Y' if the veteran applicant has requested an"
 W !,"    appointment with a VA doctor or provider and wants to be"
 W !,"    seen as soon as one becomes available  Enter a 'N'"
 W !,"    if the veteran applicant has not requested an appointment."
 W !!,"    This question may ONLY be entered ONCE for the veteran."
 W !,"    The answer to this question CANNOT be changed after the"
 W !,"    initial entry.",!
 Q
 ;
HLPCS ; * This is called by the Executable Help for Income Relation field #.1
 Q:X="?"
 N DIR,DGRDVAR
 W !?8,"Enter in this field a Yes or No to indicate whether the veteran"
 W !?8,"contributed any dollar amount to the child's support last calendar"
 W !?8,"year.  The contributions do not have to be in regular set amounts."
 W !?8,"For example, a veteran who paid a child's school tuition or"
 W !?8,"medical bills would be contributing to the child's support.",!
 W !,"Enter RETURN to continue:" R DGRDVAR:DTIME W !
 Q
 ;
HLP1823 ;*This is called by the Executable Help for Patient Relation field #.18
 N DIR,DGRDVAR
 W !?7,"Enter 'Y' if the child is currently 18 to 23 years old and the child"
 W !?7,"attended school last calendar year.  Enter 'N' if the child is currently"
 W !?7,"18 to 23 years old but the child did not attend school last calendar"
 W !?7,"year.  Enter 'N' if the child is not currently 18 to 23 years old.",!
 I $G(DA) W !,"Enter RETURN to continue:" R DGRDVAR:DTIME W !
 Q
 ;
HLPMLDS ;* This is called by the Executable Help for Patient field #.362
 ;   (DISABILITY RET. FROM MILITARY?)
 N X,Y,DIR
 W !!,"  Enter '0' or 'NO' if the veteran:"
 W !,"    -- Is NOT retired from the military OR"
 W !,"    -- Is retired from the military due to length of service AND"
 W !,"       does NOT have a disability confirmed by the Military Branch"
 W !,"       to have been incurred in or aggravated while on active duty."
 W !!,"  Enter '1' or 'YES, RECEIVING MILITARY RETIREMENT' if the veteran:"
 W !,"    -- Is confirmed by the Military Branch to have been discharged"
 W !,"       or released due to a disability incurred in or aggravated"
 W !,"       while on active duty AND"
 W !,"       -- Has NOT filed a claim for VA compensation benefits OR"
 W !,"       -- Has been rated by the VA to be NSC OR"
 W !,"       -- Has been rated by the VA to have noncompensable 0%"
 W !,"          SC conditions."
 S DIR(0)="E" D ^DIR Q:+Y<1
 W !!,"  Enter '2' or 'YES, RECEIVING MILITARY RETIREMENT IN LIEU OF VA"
 W !,"                COMPENSATION' if the veteran:"
 W !,"       -- Is confirmed by the Military Branch to have been discharged"
 W !,"          or released due to a disability incurred in or aggravated"
 W !,"          while on active duty AND"
 W !,"       -- Is receiving military disability retirement pay AND"
 W !,"       -- Has been rated by VA to have compensable SC conditions"
 W !,"          but is NOT receiving compensation from the VA"
 W !!,"          Once eligibility has been verified, this field will no longer"
 W !,"          be editable to any user who does not hold the designated security"
 W !,"          key."
 Q
HLP3602 ;help text for field .3602, Rec'ing Disability in Lieu of VA Comp
 W !,"     Enter 'Y' if this veteran applicant is receiving disability"
 W !,"     retirement pay from the Military instead of VA compensation."
 W !,"     Enter 'N' if this veteran applicant is not receiving disability"
 W !,"     retirement pay from the Military instead of VA compensation."
 W !,"     Once eligibility has been verified by HEC this field will no longer "
 W !,"     be editable by VistA users. Send updates and/or requests to HEC."
 Q
HLP3603 ;help text for field .3603, Discharge Due to LOD Disability
 W !,"     Enter 'Y' if this veteran applicant was discharged from the"
 W !,"     military for a disability incurred or aggravated in the line "
 W !,"     of duty.  Enter 'N' if this veteran applicant was not discharged"
 W !,"     from the military for a disability incurred or aggravated in the"
 W !,"     line of duty. Once eligibility has been verified by HEC this field"
 W !,"     will no longer be editable by VistA users. Send updates and/or requests"
 W !,"     to HEC."
 Q
SSNNM(DFN) ; SSN and name on first line of screen
 N X,SSN
 S X=$S($D(^DPT(+DFN,0)):^(0),1:""),SSN=$P(X,"^",9),SSN=$E(SSN,1,3)_"-"_$E(SSN,4,5)_"-"_$E(SSN,6,10)
 S X=$P(X,U)_"; "_SSN
 Q X
 ;
