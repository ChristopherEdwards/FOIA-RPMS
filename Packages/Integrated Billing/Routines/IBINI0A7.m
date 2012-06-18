IBINI0A7	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,40,21,1,0)
	;;=This identifies the condition(s) relating to this bill that may affect
	;;^DD(399,40,21,2,0)
	;;=payer processing.
	;;^DD(399,41,0)
	;;=OCCURRENCE CODE^399.041IPA^^OC;0
	;;^DD(399,41,12)
	;;=Valid MCCR Occurrence Codes only!
	;;^DD(399,41,12.1)
	;;=S DIC("S")="I $D(^DGCR(399.1,+Y,0)) I $P(^DGCR(399.1,+Y,0),""^"",4)=1 X ^DD(399.041,9.1)"
	;;^DD(399,41,21,0)
	;;=^^2^2^2920430^^^^
	;;^DD(399,41,21,1,0)
	;;=This identifies the significant event(s) relating to this bill that may
	;;^DD(399,41,21,2,0)
	;;=affect payer processing.
	;;^DD(399,42,0)
	;;=REVENUE CODE^399.042PAI^^RC;0
	;;^DD(399,42,21,0)
	;;=^^2^2^2940307^^^^
	;;^DD(399,42,21,1,0)
	;;=This identifies specific accommodation(s), ancillary service(s) or billing
	;;^DD(399,42,21,2,0)
	;;=calculation(s).
	;;^DD(399,43,0)
	;;=OP VISITS DATE(S)^399.043DA^^OP;0
	;;^DD(399,43,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,43,21,1,0)
	;;=This identifies the outpatient visit date(s) which are included on this bill.
	;;^DD(399,44,0)
	;;=REASON(S) DISAPPROVED-INITIAL^399.044PA^^D1;0
	;;^DD(399,44,21,0)
	;;=^^2^2^2880831^
	;;^DD(399,44,21,1,0)
	;;=This defines the reason(s) why this billing record was disapproved during
	;;^DD(399,44,21,2,0)
	;;=the initial review phase.
	;;^DD(399,45,0)
	;;=REASON(S) DISAPPROVED-SECOND^399.045PA^^D2;0
	;;^DD(399,45,21,0)
	;;=^^2^2^2880831^
	;;^DD(399,45,21,1,0)
	;;=This defines the reason(s) why this billing record was disapproved during
	;;^DD(399,45,21,2,0)
	;;=the secondary review phase.
	;;^DD(399,46,0)
	;;=RETURNED LOG DATE/TIME^399.046DA^^R;0
	;;^DD(399,46,21,0)
	;;=^^4^4^2911025^^^
	;;^DD(399,46,21,1,0)
	;;=This field provides the audit trail of who edited a bill after is has
	;;^DD(399,46,21,2,0)
	;;=been returned from being Audited for correction by the approving service.
	;;^DD(399,46,21,3,0)
	;;=Data in this field is automatically entered by the system whenever a
	;;^DD(399,46,21,4,0)
	;;=returned bill is edited and/or returned to fiscal.
	;;^DD(399,47,0)
	;;=VALUE CODE^399.047PA^^CV;0
	;;^DD(399,51,0)
	;;=*CPT PROCEDURE CODE (1)^*P81'^ICPT(^C;1^S DIC("S")="I $P(^(0),""^"",1)?5N" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399,51,.1)
	;;=CPT PROCEDURE CODE (1)
	;;^DD(399,51,1,0)
	;;=^.1^^0
	;;^DD(399,51,3)
	;;=CPT procedure codes may be selected if CPT is specified as the Procedure Coding Method for this bill.
	;;^DD(399,51,12)
	;;=Only CPT codes may be selected!!
	;;^DD(399,51,12.1)
	;;=S DIC("S")="I $P(^(0),""^"",1)?5N"
	;;^DD(399,51,21,0)
	;;=^^3^3^2940214^^^^
	;;^DD(399,51,21,1,0)
	;;=This is a CPT outpatient procedure code.
	;;^DD(399,51,21,2,0)
	;;= 
	;;^DD(399,51,21,3,0)
	;;=This field has been marked for deletion 11/4/91.
	;;^DD(399,51,"DT")
	;;=2920122
	;;^DD(399,52,0)
	;;=*CPT PROCEDURE CODE (2)^*P81'^ICPT(^C;2^S DIC("S")="I $P(^(0),""^"",1)?5N" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(399,52,.1)
	;;=CPT PROCEDURE CODE (2)
	;;^DD(399,52,1,0)
	;;=^.1^^0
	;;^DD(399,52,3)
	;;=CPT outpatient procedure codes may only be selected if CPT is specified as the Procedure Coding Method for this outpatient bill.
	;;^DD(399,52,12)
	;;=Only CPT codes may be selected!!
	;;^DD(399,52,12.1)
	;;=S DIC("S")="I $P(^(0),""^"",1)?5N"
	;;^DD(399,52,21,0)
	;;=^^3^3^2911104^^
	;;^DD(399,52,21,1,0)
	;;=This is a CPT outpatient procedure code.
	;;^DD(399,52,21,2,0)
	;;= 
	;;^DD(399,52,21,3,0)
	;;=This field has been marked for deletion on 11/4/91.
	;;^DD(399,52,"DT")
	;;=2920122
	;;^DD(399,53,0)
	;;=*CPT PROCEDURE CODE (3)^*P81'^ICPT(^C;3^S DIC("S")="I $P(^(0),""^"",1)?5N" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
