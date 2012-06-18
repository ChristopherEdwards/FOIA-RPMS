IBINI017	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350,.05,21,14,0)
	;;=added more easily, and permit various characteristics to be assigned
	;;^DD(350,.05,21,15,0)
	;;=to the statuses to facilitate system processing.  IT IS IMPERATIVE
	;;^DD(350,.05,21,16,0)
	;;=THAT THESE NEW POINTED-TO ENTRIES HAVE AN INTERNAL ENTRY NUMBER IN
	;;^DD(350,.05,21,17,0)
	;;=FILE #350.21 WHICH IS EQUAL TO THEIR PREVIOUS CODE VALUE.  PLEASE
	;;^DD(350,.05,21,18,0)
	;;=CAREFULLY READ THE IB ACTION STATUS FILE DESCRIPTION FOR MORE
	;;^DD(350,.05,21,19,0)
	;;=INFORMATION.
	;;^DD(350,.05,"DT")
	;;=2930823
	;;^DD(350,.06,0)
	;;=UNITS^NJ4,0I^^0;6^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350,.06,3)
	;;=Type a Number between 1 and 9999, 0 Decimal Digits
	;;^DD(350,.06,21,0)
	;;=^^3^3^2910301^^
	;;^DD(350,.06,21,1,0)
	;;=This is the number of units that will be multiplied times a specific
	;;^DD(350,.06,21,2,0)
	;;=charge that will be calculated to create the total charge.  This is
	;;^DD(350,.06,21,3,0)
	;;=passed to IB from the application.
	;;^DD(350,.06,"DT")
	;;=2910304
	;;^DD(350,.07,0)
	;;=TOTAL CHARGE^NJ10,2I^^0;7^S:X["$" X=$P(X,"$",2) K:X'?.N.1".".2N!(X>9999999)!(X<0) X
	;;^DD(350,.07,3)
	;;=Type a Dollar Amount between 0 and 9999999, 2 Decimal Digits
	;;^DD(350,.07,21,0)
	;;=^^10^10^2940209^^^
	;;^DD(350,.07,21,1,0)
	;;=This is the total charge for this entry, that will be passed to
	;;^DD(350,.07,21,2,0)
	;;=AR.  It is calculated and stored by IB routines.  NOTE: Several IB
	;;^DD(350,.07,21,3,0)
	;;=ACTION entries may be combined into one pass to AR so that there may
	;;^DD(350,.07,21,4,0)
	;;=not be a one to one relationship between this entry and one in AR.
	;;^DD(350,.07,21,5,0)
	;;= 
	;;^DD(350,.07,21,6,0)
	;;=The TOTAL CHARGE for all entries will always be positive.  It is
	;;^DD(350,.07,21,7,0)
	;;=necessary to refer to the IB ACTION TYPE file to determine if this
	;;^DD(350,.07,21,8,0)
	;;=is a NEW, CANCEL or UPDATE.  Cancel action types will cause a decrease
	;;^DD(350,.07,21,9,0)
	;;=adjustment to a bill for this amount.  New and Update action types
	;;^DD(350,.07,21,10,0)
	;;=will cause an increase adjustment to a bill for this amount.
	;;^DD(350,.07,"DT")
	;;=2910304
	;;^DD(350,.08,0)
	;;=BRIEF DESCRIPTION^FI^^0;8^K:$L(X)>20!($L(X)<3) X
	;;^DD(350,.08,3)
	;;=Answer must be 3-20 characters in length.
	;;^DD(350,.08,21,0)
	;;=^^8^8^2910403^^
	;;^DD(350,.08,21,1,0)
	;;=This is a brief description of the application entry that caused this
	;;^DD(350,.08,21,2,0)
	;;=IB ACTION entry to be created.  For example, for Pharmacy co-payments
	;;^DD(350,.08,21,3,0)
	;;=it might indicate '100999-ENDURAL-2' which would indicate that this was
	;;^DD(350,.08,21,4,0)
	;;=prescription number 100999, the drug name started with ENDURAL and
	;;^DD(350,.08,21,5,0)
	;;=2 units (30-60 days supply) were given.
	;;^DD(350,.08,21,6,0)
	;;= 
	;;^DD(350,.08,21,7,0)
	;;=The logic to calculate this will be supplied by the application and
	;;^DD(350,.08,21,8,0)
	;;=stored with the IB ACTION TYPE entry for this action.
	;;^DD(350,.08,"DT")
	;;=2910304
	;;^DD(350,.09,0)
	;;=PARENT CHARGE^P350'I^IB(^0;9^Q
	;;^DD(350,.09,1,0)
	;;=^.1
	;;^DD(350,.09,1,1,0)
	;;=350^AD
	;;^DD(350,.09,1,1,1)
	;;=S ^IB("AD",$E(X,1,30),DA)=""
	;;^DD(350,.09,1,1,2)
	;;=K ^IB("AD",$E(X,1,30),DA)
	;;^DD(350,.09,1,2,0)
	;;=350^APDT^MUMPS
	;;^DD(350,.09,1,2,1)
	;;=I $D(^IB(DA,1)),$P(^(1),"^",2) S ^IB("APDT",$E(X,1,30),-$P(^(1),"^",2),DA)=""
	;;^DD(350,.09,1,2,2)
	;;=I $D(^IB(DA,1)),$P(^(1),"^",2) K ^IB("APDT",$E(X,1,30),-$P(^(1),"^",2),DA)
	;;^DD(350,.09,1,2,"%D",0)
	;;=^^5^5^2910417^^
