IBINI0BR	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399.3)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.3,.06,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399.3,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,7)=DIV,DIH=399.3,DIG=.07 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399.3,.06,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399.3,D0,0)):^(0),1:"") S X=$P(Y(1),U,7),X=X S DIU=X K Y S X="" X ^DD(399.3,.06,1,1,2.4)
	;;^DD(399.3,.06,1,1,2.4)
	;;=S DIH=$S($D(^DGCR(399.3,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,7)=DIV,DIH=399.3,DIG=.07 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(399.3,.06,1,1,"%D",0)
	;;=^^2^2^2931217^
	;;^DD(399.3,.06,1,1,"%D",1,0)
	;;=This triggers the correct value for WHO's RESPONSIBLE for any AR Category
	;;^DD(399.3,.06,1,1,"%D",2,0)
	;;=that is entered.
	;;^DD(399.3,.06,1,1,"CREATE VALUE")
	;;=D ARCAT^IBCU
	;;^DD(399.3,.06,1,1,"DELETE VALUE")
	;;=S X=""
	;;^DD(399.3,.06,1,1,"DT")
	;;=2931217
	;;^DD(399.3,.06,1,1,"FIELD")
	;;=#.07
	;;^DD(399.3,.06,3)
	;;=Select the 'Accounts Receivable Category' which corresponds to this rate type.
	;;^DD(399.3,.06,12)
	;;=Only Accounts Receivable categories may be selected
	;;^DD(399.3,.06,12.1)
	;;=S DIC("S")="I $P(^(0),U,7)>9"
	;;^DD(399.3,.06,21,0)
	;;=^^1^1^2920107^^^
	;;^DD(399.3,.06,21,1,0)
	;;=This points to the corresponding Accounts Receivable category.
	;;^DD(399.3,.06,"DT")
	;;=2931217
	;;^DD(399.3,.07,0)
	;;=WHO'S RESPONSIBLE^SI^p:PATIENT;i:INSURER;o:OTHER (INSTITUTION);^0;7^Q
	;;^DD(399.3,.07,3)
	;;=Enter the Expected debtor for this rate type.
	;;^DD(399.3,.07,5,1,0)
	;;=399.3^.06^1
	;;^DD(399.3,.07,21,0)
	;;=4
	;;^DD(399.3,.07,21,1,0)
	;;=This field is triggered when an Accounts Receivable Category is entered.
	;;^DD(399.3,.07,21,2,0)
	;;=It is used to provide consistency between packages so the the debtor for
	;;^DD(399.3,.07,21,3,0)
	;;=the bill is from the correct file.  Debtors can be from the Patient file,
	;;^DD(399.3,.07,21,4,0)
	;;=the Insurance Company file, or the Institution file.
	;;^DD(399.3,.07,"DT")
	;;=2900214
	;;^DD(399.3,.08,0)
	;;=REIMBURSABLE INSURANCE?^S^1:YES;0:NO;^0;8^Q
	;;^DD(399.3,.08,3)
	;;=Answer '1' or 'YES' if you want the Medicare statement to print on all UB bills of this Rate Type.
	;;^DD(399.3,.08,21,0)
	;;=^^7^7^2940120^^^^
	;;^DD(399.3,.08,21,1,0)
	;;=This field should be answered 'YES' if this is a Reimbursable Insurance
	;;^DD(399.3,.08,21,2,0)
	;;=rate type, all other rate types should be answered 'NO'.  This field
	;;^DD(399.3,.08,21,3,0)
	;;=will be used to determine if a bill is reimbursable Insurance.
	;;^DD(399.3,.08,21,4,0)
	;;= 
	;;^DD(399.3,.08,21,5,0)
	;;=Primarily, this field will be used by the bill print option to determine 
	;;^DD(399.3,.08,21,6,0)
	;;=if the 7 line statement that begins "For your information..."
	;;^DD(399.3,.08,21,7,0)
	;;=should be printed on the UB claim form. (Only applies to the UB form types.)
	;;^DD(399.3,.08,"DT")
	;;=2920406
	;;^DD(399.3,.09,0)
	;;=NSC STATEMENT ON UB BILLS^S^1:YES;0:NO;^0;9^Q
	;;^DD(399.3,.09,3)
	;;=Enter '1' or 'YES' if you want the statement "The undersigned certifies that treatment rendered is not for a service connected disablility." to print on UB bills of this rate type.
	;;^DD(399.3,.09,21,0)
	;;=^^6^6^2940120^^^^
	;;^DD(399.3,.09,21,1,0)
	;;=The statement "The undersigned certifies that treatment rendered is not
	;;^DD(399.3,.09,21,2,0)
	;;=for a service connected disablity." will be printed on UB claim forms of
	;;^DD(399.3,.09,21,3,0)
	;;=this Rate Type if this field is answered 'YES'.
	;;^DD(399.3,.09,21,4,0)
	;;= 
	;;^DD(399.3,.09,21,5,0)
	;;=This field should be answered 'YES' for all rate types where the bill
