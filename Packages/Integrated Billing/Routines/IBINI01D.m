IBINI01D	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.1,.04,"DT")
	;;=2910214
	;;^DD(350.1,.05,0)
	;;=SEQUENCE NUMBER^S^1:NEW;2:CANCEL;3:UPDATE;81:MEDICARE DEDUCTIBLE;82:CHAMPVA LIMIT;91:HOSPITAL ADMISSION;92:NHCU ADMISSION;^0;5^Q
	;;^DD(350.1,.05,1,0)
	;;=^.1
	;;^DD(350.1,.05,1,1,0)
	;;=350.1^ANEW1^MUMPS
	;;^DD(350.1,.05,1,1,1)
	;;=I $P(^IBE(350.1,DA,0),U,4) S ^IBE(350.1,"ANEW",$P(^(0),U,4),X,DA)=""
	;;^DD(350.1,.05,1,1,2)
	;;=I $P(^IBE(350.1,DA,0),U,4) K ^IBE(350.1,"ANEW",$P(^(0),U,4),X,DA)
	;;^DD(350.1,.05,3)
	;;=Enter the appropriate entry to indicate the sequencing that this action type should be filed with AR, or the appropriate code for the non-billable action type.
	;;^DD(350.1,.05,21,0)
	;;=^^12^12^2911101^^^^
	;;^DD(350.1,.05,21,1,0)
	;;=This field tells the IB filer the order in which to file entries with
	;;^DD(350.1,.05,21,2,0)
	;;=AR.  A new entry must be filed before it can be cancelled.  An update
	;;^DD(350.1,.05,21,3,0)
	;;=action type will generate two actions, a cancel of previous entry, and
	;;^DD(350.1,.05,21,4,0)
	;;=an updated entry containing the correct data.  The update will be filed
	;;^DD(350.1,.05,21,5,0)
	;;=after the cancel.  The ordering must be maintained so that the last full
	;;^DD(350.1,.05,21,6,0)
	;;=entry in the INTEGRATED BILLING ACTION file for a parent is the most
	;;^DD(350.1,.05,21,7,0)
	;;=current entry.  (an inverse date x-ref on the parent field will indicate
	;;^DD(350.1,.05,21,8,0)
	;;=the most recent entry to the updated parent)
	;;^DD(350.1,.05,21,9,0)
	;;=Additional numbering series are also available for IB ACTION TYPES which
	;;^DD(350.1,.05,21,10,0)
	;;=do not explicitly represent billable charges.  These series are set so that
	;;^DD(350.1,.05,21,11,0)
	;;=they do not conflict with the ordering required for correct processing of
	;;^DD(350.1,.05,21,12,0)
	;;=IB ACTION charges in AR.
	;;^DD(350.1,.05,"DT")
	;;=2930727
	;;^DD(350.1,.06,0)
	;;=CANCELLATION ACTION TYPE^P350.1'^IBE(350.1,^0;6^Q
	;;^DD(350.1,.06,21,0)
	;;=^^4^4^2920415^^
	;;^DD(350.1,.06,21,1,0)
	;;=This is the IB ACTION TYPE entry that will be the 'CANCEL' type for
	;;^DD(350.1,.06,21,2,0)
	;;=this entry.  If this is a 'CANCEL' type entry, then this will be itself.
	;;^DD(350.1,.06,21,3,0)
	;;=Every 'NEW' type entry should have an associated 'CANCEL' and 'UPDATE'
	;;^DD(350.1,.06,21,4,0)
	;;=type entry.
	;;^DD(350.1,.06,"DT")
	;;=2910213
	;;^DD(350.1,.07,0)
	;;=UPDATE ACTION TYPE^P350.1^IBE(350.1,^0;7^Q
	;;^DD(350.1,.07,21,0)
	;;=^^4^4^2940209^^^
	;;^DD(350.1,.07,21,1,0)
	;;=This is the IB ACTION TYPE entry that will be the 'UPDATE' type for
	;;^DD(350.1,.07,21,2,0)
	;;=this entry.  If this entry is an UPDATE type then it will be itself.
	;;^DD(350.1,.07,21,3,0)
	;;=For every 'NEW' type of entry, there should be an associated 'CANCEL'
	;;^DD(350.1,.07,21,4,0)
	;;=and 'UPDATE' type.
	;;^DD(350.1,.07,"DT")
	;;=2910213
	;;^DD(350.1,.08,0)
	;;=USER LOOKUP NAME^F^^0;8^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>22!($L(X)<3) X
	;;^DD(350.1,.08,1,0)
	;;=^.1
	;;^DD(350.1,.08,1,1,0)
	;;=350.1^E
	;;^DD(350.1,.08,1,1,1)
	;;=S ^IBE(350.1,"E",$E(X,1,30),DA)=""
	;;^DD(350.1,.08,1,1,2)
	;;=K ^IBE(350.1,"E",$E(X,1,30),DA)
	;;^DD(350.1,.08,1,1,"DT")
	;;=2920224
	;;^DD(350.1,.08,3)
	;;=Answer must be 3-22 characters in length.
	;;^DD(350.1,.08,21,0)
	;;=^^3^3^2920415^^^
	;;^DD(350.1,.08,21,1,0)
	;;=This is the name of the action that may be used for look-up and 
	;;^DD(350.1,.08,21,2,0)
	;;=printing on reports.  The name will only exist for IB ACTION TYPE
	;;^DD(350.1,.08,21,3,0)
	;;=entries whose SEQUENCE NUMBER is "1" for NEW.
