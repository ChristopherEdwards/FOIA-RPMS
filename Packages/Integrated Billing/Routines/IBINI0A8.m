IBINI0A8	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,53,.1)
	;;=CPT PROCEDURE CODE (3)
	;;^DD(399,53,1,0)
	;;=^.1^^0
	;;^DD(399,53,3)
	;;=CPT outpatient procedure codes may only be selected if CPT is specified as the Procedure Coding Method for this outpatient bill.
	;;^DD(399,53,12)
	;;=Only CPT codes may be selected!!
	;;^DD(399,53,12.1)
	;;=S DIC("S")="I $P(^(0),""^"",1)?5N"
	;;^DD(399,53,21,0)
	;;=^^3^3^2911104^^
	;;^DD(399,53,21,1,0)
	;;=This is a CPT outpatient procedure code.
	;;^DD(399,53,21,2,0)
	;;= 
	;;^DD(399,53,21,3,0)
	;;=This field has been marked for deletion on 11/4/91.
	;;^DD(399,53,"DT")
	;;=2920122
	;;^DD(399,54,0)
	;;=*ICD PROCEDURE CODE (1)^P80.1'^ICD0(^C;4^Q
	;;^DD(399,54,1,0)
	;;=^.1^^0
	;;^DD(399,54,3)
	;;=Enter ICD procedure code associated with the outpatient episode of care.
	;;^DD(399,54,21,0)
	;;=^^3^3^2911104^^^
	;;^DD(399,54,21,1,0)
	;;=This is an ICD outpatient procedure code.
	;;^DD(399,54,21,2,0)
	;;= 
	;;^DD(399,54,21,3,0)
	;;=This field is marked for deletion on 11/4/91.
	;;^DD(399,54,"DT")
	;;=2920122
	;;^DD(399,55,0)
	;;=*ICD PROCEDURE CODE (2)^P80.1'^ICD0(^C;5^Q
	;;^DD(399,55,.1)
	;;=ICD PROCEDURE CODE (2)
	;;^DD(399,55,1,0)
	;;=^.1^^0
	;;^DD(399,55,3)
	;;=Enter ICD procedure code associated with this outpatient episode of care.
	;;^DD(399,55,21,0)
	;;=^^3^3^2920526^^^
	;;^DD(399,55,21,1,0)
	;;=This is an ICD outpatient procedure code.
	;;^DD(399,55,21,2,0)
	;;= 
	;;^DD(399,55,21,3,0)
	;;=This field is marked of deletion on 11/4/91.
	;;^DD(399,55,"DT")
	;;=2920122
	;;^DD(399,56,0)
	;;=*ICD PROCEDURE CODE (3)^P80.1'^ICD0(^C;6^Q
	;;^DD(399,56,.1)
	;;=ICD PROCEDURE CODE (3)
	;;^DD(399,56,1,0)
	;;=^.1^^0
	;;^DD(399,56,3)
	;;=Enter ICD procedure code associated with this outpatient episode of care.
	;;^DD(399,56,21,0)
	;;=^^3^3^2911104^^
	;;^DD(399,56,21,1,0)
	;;=This is an ICD outpatient procedure code.
	;;^DD(399,56,21,2,0)
	;;= 
	;;^DD(399,56,21,3,0)
	;;=This field is marked for deletion on 11/4/91.
	;;^DD(399,56,"DT")
	;;=2920122
	;;^DD(399,57,0)
	;;=*HCFA PROCEDURE CODE (1)^*P81'X^ICPT(^C;7^S D="F" D IX^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399,57,.1)
	;;=HCFA PROCEDURE CODE (1)
	;;^DD(399,57,1,0)
	;;=^.1^^0
	;;^DD(399,57,3)
	;;=Enter HCFA procedure code associated with this outpatient episode of care.
	;;^DD(399,57,12)
	;;=Only HCFA codes may be selected!!
	;;^DD(399,57,12.1)
	;;=S DIC("S")="I $P(^(0),""^"",1)?1A.N"
	;;^DD(399,57,21,0)
	;;=^^3^3^2911104^^^^
	;;^DD(399,57,21,1,0)
	;;=This is a HCFA outpatient procedure code.
	;;^DD(399,57,21,2,0)
	;;= 
	;;^DD(399,57,21,3,0)
	;;=This field is marked for deletion on 11/4/91.
	;;^DD(399,57,"DT")
	;;=2920122
	;;^DD(399,58,0)
	;;=*HCFA PROCEDURE CODE (2)^*P81'X^ICPT(^C;8^S D="F" D IX^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399,58,.1)
	;;=HCFA PROCEDURE CODE (2)
	;;^DD(399,58,1,0)
	;;=^.1^^0
	;;^DD(399,58,3)
	;;=Enter HCFA procedure code associated with this outpatient episode of care.
	;;^DD(399,58,12)
	;;=Only HCFA codes may be selected!!
	;;^DD(399,58,12.1)
	;;=S DIC("S")="I $P(^(0),""^"",1)?1A.N"
	;;^DD(399,58,21,0)
	;;=^^3^3^2911104^^
	;;^DD(399,58,21,1,0)
	;;=This is a HCFA outpatient procedure code.
	;;^DD(399,58,21,2,0)
	;;= 
	;;^DD(399,58,21,3,0)
	;;=This field has been marked for deletion on 11/4/91.
	;;^DD(399,58,"DT")
	;;=2920122
	;;^DD(399,59,0)
	;;=*HCFA PROCEDURE CODE (3)^*P81'X^ICPT(^C;9^S D="F" D IX^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399,59,.1)
	;;=*HCFA PROCDURE CODE (3)
	;;^DD(399,59,1,0)
	;;=^.1^^0
	;;^DD(399,59,3)
	;;=Enter HCFA procedure code associated with this outpatient episode of care.
	;;^DD(399,59,12)
	;;=Only HCFA codes may be selected!!
