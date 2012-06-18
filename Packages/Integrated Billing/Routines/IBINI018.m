IBINI018	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350,.09,1,2,"%D",1,0)
	;;=Cross-reference of all IB ACTION entries by parent link (#.09) field and
	;;^DD(350,.09,1,2,"%D",2,0)
	;;=the minus (negative or inverse) date entry added (#12) field.  The most current ACTION
	;;^DD(350,.09,1,2,"%D",3,0)
	;;=for the original entry can be found using this cross-reference.  The "APDT1"
	;;^DD(350,.09,1,2,"%D",4,0)
	;;=cross-reference on the DATE ENTRY ADDED (#12) field is the companion to this
	;;^DD(350,.09,1,2,"%D",5,0)
	;;=cross-reference.
	;;^DD(350,.09,3)
	;;=
	;;^DD(350,.09,21,0)
	;;=^^12^12^2911105^^^^
	;;^DD(350,.09,21,1,0)
	;;=This is a pointer to the original IB ACTION entry that this entry refers
	;;^DD(350,.09,21,2,0)
	;;=to.  For a NEW entry, it will point to itself.  For all other entries it
	;;^DD(350,.09,21,3,0)
	;;=will point to the original entry.
	;;^DD(350,.09,21,4,0)
	;;= 
	;;^DD(350,.09,21,5,0)
	;;=An application then only needs to maintain the pointer to the original
	;;^DD(350,.09,21,6,0)
	;;=entry and can find the most recent entry for this entry as
	;;^DD(350,.09,21,7,0)
	;;= 
	;;^DD(350,.09,21,8,0)
	;;=  S x=$O(^IB("APDT",parent,0),x=$O(^(x,0))
	;;^DD(350,.09,21,9,0)
	;;= 
	;;^DD(350,.09,21,10,0)
	;;=If x '= parent then this is an updated entry, the pointer to the
	;;^DD(350,.09,21,11,0)
	;;=IB ACTION TYPE file will give you the sequence number which will indicate
	;;^DD(350,.09,21,12,0)
	;;=if this is cancelled or an updated entry.
	;;^DD(350,.09,"DT")
	;;=2911105
	;;^DD(350,.1,0)
	;;=CANCELLATION REASON^P350.3^IBE(350.3,^0;10^Q
	;;^DD(350,.1,3)
	;;=
	;;^DD(350,.1,21,0)
	;;=^^1^1^2910301^^
	;;^DD(350,.1,21,1,0)
	;;=This is the reason that this charge was cancelled.
	;;^DD(350,.1,"DT")
	;;=2910301
	;;^DD(350,.11,0)
	;;=AR BILL NUMBER^F^^0;11^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>12!($L(X)<6) X
	;;^DD(350,.11,1,0)
	;;=^.1
	;;^DD(350,.11,1,1,0)
	;;=350^ABIL
	;;^DD(350,.11,1,1,1)
	;;=S ^IB("ABIL",$E(X,1,30),DA)=""
	;;^DD(350,.11,1,1,2)
	;;=K ^IB("ABIL",$E(X,1,30),DA)
	;;^DD(350,.11,3)
	;;=Answer must be 6-12 characters in length.
	;;^DD(350,.11,21,0)
	;;=^^4^4^2910301^
	;;^DD(350,.11,21,1,0)
	;;=This is the free text bill number that this entry is charged to.  It
	;;^DD(350,.11,21,2,0)
	;;=is in the format of a PAT number.  It will be calculated by accounts
	;;^DD(350,.11,21,3,0)
	;;=receivable from the AR BILL NUMBER file for the service in the IB
	;;^DD(350,.11,21,4,0)
	;;=ACTION TYPE entry associated with this entry.
	;;^DD(350,.11,"DT")
	;;=2910306
	;;^DD(350,.12,0)
	;;=AR TRANSACTION NUMBER^NJ6,0^^0;12^K:+X'=X!(X>999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350,.12,1,0)
	;;=^.1
	;;^DD(350,.12,1,1,0)
	;;=350^AT
	;;^DD(350,.12,1,1,1)
	;;=S ^IB("AT",$E(X,1,30),DA)=""
	;;^DD(350,.12,1,1,2)
	;;=K ^IB("AT",$E(X,1,30),DA)
	;;^DD(350,.12,3)
	;;=Type a Number between 1 and 999999, 0 Decimal Digits
	;;^DD(350,.12,21,0)
	;;=^^4^4^2910301^
	;;^DD(350,.12,21,1,0)
	;;=This is the pointer value to the AR TRANSACTION file.  An entry that
	;;^DD(350,.12,21,2,0)
	;;=causes a new bill number to be created will not have an AR TRANSACTION
	;;^DD(350,.12,21,3,0)
	;;=file entry associated with it as the charge data will be stored with
	;;^DD(350,.12,21,4,0)
	;;=the original bill.
	;;^DD(350,.12,"DT")
	;;=2910329
	;;^DD(350,.13,0)
	;;=INSTITUTION^P4'I^DIC(4,^0;13^Q
	;;^DD(350,.13,3)
	;;=
	;;^DD(350,.13,21,0)
	;;=^^3^3^2910301^
	;;^DD(350,.13,21,1,0)
	;;=This is the facility that caused this bill.  The station number field of
	;;^DD(350,.13,21,2,0)
	;;=the institution file will be used in determining the reference number.
	;;^DD(350,.13,21,3,0)
	;;=Accounts Receivable will use the station number in the bill number.
