IBINI0AX	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.042,.06,1,1,2)
	;;=K ^DGCR(399,"ASC1",$E(X,1,30),DA(1),DA)
	;;^DD(399.042,.06,1,1,"%D",0)
	;;=^^1^1^2940310^^^^
	;;^DD(399.042,.06,1,1,"%D",1,0)
	;;=All Billable Ambulatory Surgery Codes (BASC) that have been billed.
	;;^DD(399.042,.06,1,1,"DT")
	;;=2930903
	;;^DD(399.042,.06,1,2,0)
	;;=399^ASC2^MUMPS
	;;^DD(399.042,.06,1,2,1)
	;;=I $$RC^IBEFUNC1(DA(1),DA) S ^DGCR(399,"ASC2",DA(1),$E(X,1,30),DA)=""
	;;^DD(399.042,.06,1,2,2)
	;;=K ^DGCR(399,"ASC2",DA(1),$E(X,1,30),DA)
	;;^DD(399.042,.06,1,2,"%D",0)
	;;=^^1^1^2940310^^^^
	;;^DD(399.042,.06,1,2,"%D",1,0)
	;;=All bills with charges for Billable Ambulatory Surgery Codes (BASC).
	;;^DD(399.042,.06,1,2,"DT")
	;;=2930903
	;;^DD(399.042,.06,21,0)
	;;=3^^9^9^2930707^^
	;;^DD(399.042,.06,21,1,0)
	;;=This field may be used to associate the revenue code with a procedure.
	;;^DD(399.042,.06,21,2,0)
	;;=This will be needed primarily to accomodate the HCFA 1500 which allows
	;;^DD(399.042,.06,21,3,0)
	;;=charges by procedure not revenue code.  The charge associated with the
	;;^DD(399.042,.06,21,4,0)
	;;=revenue code will be printed on the HCFA 1500 claim form in the same line
	;;^DD(399.042,.06,21,5,0)
	;;=item as the procedure.
	;;^DD(399.042,.06,21,6,0)
	;;= 
	;;^DD(399.042,.06,21,7,0)
	;;=This field is also used for revenue codes that are for Billable Ambulatory
	;;^DD(399.042,.06,21,8,0)
	;;=Surgeries (BASC).  It identifies the CPT code of the surgery which is
	;;^DD(399.042,.06,21,9,0)
	;;=being billed for.
	;;^DD(399.042,.06,"DT")
	;;=2930903
	;;^DD(399.042,.07,0)
	;;=DIVISION^P40.8'X^DG(40.8,^0;7^Q
	;;^DD(399.042,.07,1,0)
	;;=^.1^^-1
	;;^DD(399.042,.07,1,1,0)
	;;=399^ASC11^MUMPS
	;;^DD(399.042,.07,1,1,1)
	;;=I $$RC^IBEFUNC1(DA(1),DA) S ^DGCR(399,"ASC1",$P(^DGCR(399,DA(1),"RC",DA,0),U,6),DA(1),DA)=""
	;;^DD(399.042,.07,1,1,2)
	;;=K ^DGCR(399,"ASC1",+$P(^DGCR(399,DA(1),"RC",DA,0),U,6),DA(1),DA)
	;;^DD(399.042,.07,1,1,"%D",0)
	;;=^^1^1^2940310^^^^
	;;^DD(399.042,.07,1,1,"%D",1,0)
	;;=All Billable Ambulatory Surgery Codes (BASC) that have been billed.
	;;^DD(399.042,.07,1,1,"DT")
	;;=2940310
	;;^DD(399.042,.07,1,2,0)
	;;=399^ASC21^MUMPS
	;;^DD(399.042,.07,1,2,1)
	;;=I $$RC^IBEFUNC1(DA(1),DA) S ^DGCR(399,"ASC2",DA(1),$P(^DGCR(399,DA(1),"RC",DA,0),U,6),DA)=""
	;;^DD(399.042,.07,1,2,2)
	;;=K ^DGCR(399,"ASC2",DA(1),+$P(^DGCR(399,DA(1),"RC",DA,0),U,6),DA)
	;;^DD(399.042,.07,1,2,"%D",0)
	;;=^^1^1^2940310^^^^
	;;^DD(399.042,.07,1,2,"%D",1,0)
	;;=All bills with charges for Billable Ambulatory Surgery Codes (BASC).
	;;^DD(399.042,.07,1,2,"DT")
	;;=2940307
	;;^DD(399.042,.07,3)
	;;=
	;;^DD(399.042,.07,21,0)
	;;=^^2^2^2920415^
	;;^DD(399.042,.07,21,1,0)
	;;=This field is completed only if the revenue code is for a Billable Ambulatory
	;;^DD(399.042,.07,21,2,0)
	;;=Surgery. It identifies the division where the surgery was performed.
	;;^DD(399.042,.07,"DT")
	;;=2940310
	;;^DD(399.042,.08,0)
	;;=AUTO^S^1:YES;^0;8^Q
	;;^DD(399.042,.08,3)
	;;=This field sould be automatically added by the software, user entry is not necessary.
	;;^DD(399.042,.08,21,0)
	;;=^^2^2^2940207^^
	;;^DD(399.042,.08,21,1,0)
	;;=True if the revenue code and charge were added by the automatic charge
	;;^DD(399.042,.08,21,2,0)
	;;=calculation routine, blank if added manually by the user.
	;;^DD(399.042,.08,23,0)
	;;=^^5^5^2940207^^
	;;^DD(399.042,.08,23,1,0)
	;;=Should only be true if the automatic charge calculator created the 
	;;^DD(399.042,.08,23,2,0)
	;;=revenue code and charge based on the chargable items on the bill.  Should
	;;^DD(399.042,.08,23,3,0)
	;;=be null for any rev code manually entered by a user.  (FILE^IBCU62) 
