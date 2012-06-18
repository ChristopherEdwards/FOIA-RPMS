ABSPOSM2 ; IHS/FCS/DRS - Report Master (.61) ;    [ 09/12/2002  10:12 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,11,20,29,37,40**;JUN 21, 2001
 ;
 ; ABSPOSM2 - headers called from some Fileman reports
 ;  D0 points to 9002313.61
 ;-----------------------------------------------------
 ;IHS/SD/lwj 06/04/04 patch 11
 ; Subroutine was named "DUPLICAT" but the option was
 ; calling "DUPLICATE" for the possible duplicates report.
 ; This was not an issue until Cache, since MSM only
 ; recognized the first 8 characters of the subroutine.
 ; Subroutine was renamed to DUPLICATE to match the option.
 ;------------------------------------------------------
 ;IHS/SD/RLT - 3/26/07 - Patch 20
 ;             Added NPI
 ;             
 ;------------------------------------------------------
 ;IHS/OIT/SCR - 12/12/08 - Patch 29 added SITE reports
 ;------------------------------------------------------
 Q
PAYABLE ;W @IOF
 W $$HDR1("PAYABLE"),!
 W $$PHARMACY,!
 W $$PHARMNO,!
 W $$INSURER,!
 W !
 W ?0,"Trans. Date"
 W ?35,"Presc/Fill"
 W ?46,"$billed"
 W ?54,"Ins.Pd."
 W !
 W !
 Q
REJECTED ;
 ;W @IOF
 W $$HDR1("REJECTED"),!
 W $$PHARMACY,!
 W $$PHARMNO,!
 W $$INSURER,!
 W !
 W ?0,"Trans. Date/Time"
 W ?20,"Claim ID"
 W ?42,"Presc/Fill"
 W ?64,"NDC Number"
 W !
 W ?0,"Cardholder ID"
 W ?20,"Group Number"
 W ?41,"Qty"
 W ?46,"$billed"
 W !
 W !
 Q
CAPTURED ;
 ; W @IOF
 W $$HDR1("CAPTURED"),!
 W $$PHARMACY,!
 W $$PHARMNO,!
 W $$INSURER,!
 W !
 W ?0,"Trans. Date"
 W ?35,"Presc/Fill"
 W ?46,"$billed"
 W !
 W !
 Q
DUPLICATE ;IHS/SD/lwj 6/4/04 patch 11 tag added to match option
DUPLICAT ;
 ;W !IOF
 W $$HDR1("DUPLICATE"),!
 W $$PHARMACY,!
 W $$PHARMNO,!
 W $$INSURER,!
 W !
 W ?0,"Trans. Date"
 W ?35,"Presc/Fill"
 W ?46,"$billed"
 W !
 W !
 Q
PAPER ;
 ;W @IOF
 W $$HDR1("PAPER"),!
 W $$PHARMACY,!
 W $$PHARMNO,!
 W $$INSURER,!
 W !
 W ?0,"Trans. Date"
 W ?35,"Presc/Fill"
 W ?46,"$amount"
 W !
 W !
 Q
UNINS ;W @IOF
 W $$HDR1("UNINSURED"),!
 W $$PHARMACY,!
 W $$PHARMNO,!
 W $$ELIG,!
 W !
 W ?0,"Trans. Date"
 W ?35,"Presc/Fill"
 W ?46,"$amount"
 W !
 W !
 Q
 ; - subroutines -
ELIG() ;
 N IEN57 S IEN57=$$IEN57 Q:'IEN57 ""
 N PAT S PAT=$P($G(^ABSPTL(IEN57,0)),U,6)
 Q "ELIGIBILITY STATUS: "_$$GET1^DIQ(9000001,PAT_",",1112)
INSURER() N IEN4 S IEN4=$$IEN4 Q:'IEN4 ""
 N X,Y
 S X=$P($G(^AUTNINS(IEN4,0)),U) Q:X="" ""
 S Y=$$INSHELP^ABSPOSM(D0)
 I Y]"" S X=X_"   Help Desk:"_Y
 Q X
PHARMACY() ;
 N IEN56 S IEN56=$$IEN56 Q:'IEN56 ""
 N X
 S X=$G(^ABSP(9002313.56,IEN56,0))
 Q $P(X,U)
PHARMNO() ;
 N IEN56 S IEN56=$$IEN56 Q:'IEN56 ""
 N X,Y
 S Y=$G(^ABSP(9002313.56,IEN56,0))
 S X="NPI #"_$$NPI
 S X=X_"   NCPDP (NABP) #"_$P(Y,U,2)
 S X=X_"   Medicaid #"_$P($G(^ABSP(9002313.56,IEN56,"CAID")),U)
 Q X
NPI() ;
 N IEN57 S IEN57=$$IEN57 Q:'IEN57 ""
 N OPS,INST,NPI
 S OPS=$P($G(^ABSPTL(IEN57,1)),U,4)           ;outpatient site
 S INST=""
 I OPS'="" D
 . S INST=$P($G(^PS(59,OPS,"INI")),U,2)       ;institution
 ;
 S NPI=""                                     ;pharmacy NPI
 I INST'="" D
 . S NPI=$P($$NPI^XUSNPI("Organization_ID",INST),U)
 . S:NPI'>0 NPI=""
 Q NPI
IEN4() N X S X=$$IEN57 Q:'X ""
 Q $P($G(^ABSPTL(X,1)),U,6)
IEN56() N X S X=$$IEN57 Q:'X ""
 Q $P($G(^ABSPTL(X,1)),U,7)
IEN57() Q:'D0 "" Q $P($G(^ABSPECX("RPT",D0,0)),U,3) ; TRANSACTION
RELDATE() Q:'D0 "" N Y S Y=$P($G(^ABSPECX("RPT",D0,0)),U) X ^DD("DD") Q Y
HDR1(X) N R S R=$$RELDATE
 N A S A="POS "_X_" claims for prescriptions RELEASED"
 I R]"" S A=A_" on "_R
 N B S B=$$NOW^ABSPOS
 S B=$E(B,4,5)_"/"_$E(B,6,7)_"@"_$E(B,9,10)_":"_$E(B,11,12)
 Q A_$J(B,80-1-$L(A))
 ;IHS/OIT/SCR 12/12/08 - START CHANGES FOR SITE REPORTS patch 29
PAYPHARM  ;
 W $$HDR1("PHARMACY PAYABLE"),!
 W $$PHARMACY,!
 W $$PHARMNO,!
 W $$INSURER,!
 W !
 W ?0,"Trans. Date"
 W ?35,"Presc/Fill"
 W ?46,"$billed"
 W ?54,"Ins.Pd."
 W !
 W !
 Q
ASKPHARM()  ;
 N Y,DIR
 S DIR(0)="P^ABSP(9002313.56,:QEM"
 D ^DIR
 Q Y
HDR2(ABSPTYP,ABSPSITE)  ;
 N ABSPDATE,ABSPSTRN,ABSPNOW
 S ABSPSTRN="POS "_ABSPNAME_" :"_ABSPTYP_" claims for prescriptions RELEASED"
 S ABSPDATE=$$RELDATE
 I ABSPDATE]"" S ABSPSTRN=ABSPSTRN_" on "_ABSPDATE
 N ABSPNOW S ABSPNOW=$$NOW^ABSPOS
 S ABSPNOW=$E(ABSPNOW,4,5)_"/"_$E(ABSPNOW,6,7)_"@"_$E(ABSPNOW,9,10)_":"_$E(ABSPNOW,11,12)
 Q ABSPSTRN_$J(ABSPNOW,80-1-$L(ABSPSTRN))
 ;
CLOSED ;IHS/OIT/SCR 021810 patch 37
 W $$HDR1("CLOSED"),!
 W $$PHARMACY,!
 W $$PHARMNO,!
 ;W $$INSURER,!
 W !
 W ?0,"Internal RX#"
 W ?20,"Cardholder ID"
 W ?40,"Group Number"
 W !
 W ?3,"Closed Date"
 W ?23,"Closed By"
 W ?43,"Closed Reason"
 ;/IHS/OIT/CNI/RAN 09/13/2010 patch 40 Added header for Rejects, and $Billed
 W !,?6,"Rejects",?26,"$Billed"
 W !,!
 Q
