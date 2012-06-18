IBINI01X	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.6,.02,21,5,0)
	;;=because the template is deleted from the file after the entries have
	;;^DD(350.6,.02,21,6,0)
	;;=been purged.  The name of the template is the string "IB ARCHIVE/PURGE #"
	;;^DD(350.6,.02,21,7,0)
	;;=concatenated with the Archive Log # (field .01).
	;;^DD(350.6,.02,"DT")
	;;=2920408
	;;^DD(350.6,.03,0)
	;;=ARCHIVE FILE^P1'^DIC(^0;3^Q
	;;^DD(350.6,.03,1,0)
	;;=^.1
	;;^DD(350.6,.03,1,1,0)
	;;=350.6^D
	;;^DD(350.6,.03,1,1,1)
	;;=S ^IBE(350.6,"D",$E(X,1,30),DA)=""
	;;^DD(350.6,.03,1,1,2)
	;;=K ^IBE(350.6,"D",$E(X,1,30),DA)
	;;^DD(350.6,.03,1,1,"DT")
	;;=2920408
	;;^DD(350.6,.03,1,2,0)
	;;=350.6^AF^MUMPS
	;;^DD(350.6,.03,1,2,1)
	;;=I $D(^IBE(350.6,DA,1)),^(1) S ^IBE(350.6,"AF",X,-^(1),DA)=""
	;;^DD(350.6,.03,1,2,2)
	;;=I $D(^IBE(350.6,DA,1)),^(1) K ^IBE(350.6,"AF",X,-^(1),DA)
	;;^DD(350.6,.03,1,2,"%D",0)
	;;=^^5^5^2920408^
	;;^DD(350.6,.03,1,2,"%D",1,0)
	;;=Cross-reference of all ARCHIVE/PURGE LOG entries (by Archive file [#.03]
	;;^DD(350.6,.03,1,2,"%D",2,0)
	;;=and the inverse Search Begin Date/Time [#1.01]) for which a search has
	;;^DD(350.6,.03,1,2,"%D",3,0)
	;;=been initiated.  The cross-reference will be used to find the most recent
	;;^DD(350.6,.03,1,2,"%D",4,0)
	;;=log entry for a file.  The "AF1" cross-reference on the Search Begin
	;;^DD(350.6,.03,1,2,"%D",5,0)
	;;=Date/Time field (#1.01) is the companion to this cross-reference.
	;;^DD(350.6,.03,1,2,"DT")
	;;=2920408
	;;^DD(350.6,.03,21,0)
	;;=^^7^7^2940209^^
	;;^DD(350.6,.03,21,1,0)
	;;=This field points to the FILE file (#1) and represents the file to be
	;;^DD(350.6,.03,21,2,0)
	;;=archived/purged.  The Billing data files subject to archiving/purging
	;;^DD(350.6,.03,21,3,0)
	;;=currently are:
	;;^DD(350.6,.03,21,4,0)
	;;= 
	;;^DD(350.6,.03,21,5,0)
	;;=  350  INTEGRATED BILLING ACTION
	;;^DD(350.6,.03,21,6,0)
	;;=  351  CATEGORY C BILLING CLOCK
	;;^DD(350.6,.03,21,7,0)
	;;=  399  BILL/CLAIMS
	;;^DD(350.6,.03,"DT")
	;;=2920408
	;;^DD(350.6,.04,0)
	;;=# RECORDS ARCHIVED^NJ15,0^^0;4^K:+X'=X!(X>999999999999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(350.6,.04,3)
	;;=Type a Number between 1 and 999999999999999, 0 Decimal Digits
	;;^DD(350.6,.04,21,0)
	;;=^^7^7^2920427^
	;;^DD(350.6,.04,21,1,0)
	;;=This field will contain the number of entries which have been processed
	;;^DD(350.6,.04,21,2,0)
	;;=in each sequential archive/purge operation.  The 'Search' option will
	;;^DD(350.6,.04,21,3,0)
	;;=update the field with the number of entries which have met the search
	;;^DD(350.6,.04,21,4,0)
	;;=criteria.  The 'Archive' option will update this field with the number
	;;^DD(350.6,.04,21,5,0)
	;;=of entries archived.  The 'Purge' option will update the field with the
	;;^DD(350.6,.04,21,6,0)
	;;=number of entries purged.  Also, the 'Delete Entry From Search Template'
	;;^DD(350.6,.04,21,7,0)
	;;=option will update the field when entries from the template are deleted.
	;;^DD(350.6,.04,"DT")
	;;=2920408
	;;^DD(350.6,.05,0)
	;;=LOG STATUS^S^1:OPEN;2:CLOSED;3:CANCELLED;^0;5^Q
	;;^DD(350.6,.05,1,0)
	;;=^.1
	;;^DD(350.6,.05,1,1,0)
	;;=350.6^E
	;;^DD(350.6,.05,1,1,1)
	;;=S ^IBE(350.6,"E",$E(X,1,30),DA)=""
	;;^DD(350.6,.05,1,1,2)
	;;=K ^IBE(350.6,"E",$E(X,1,30),DA)
	;;^DD(350.6,.05,1,1,"DT")
	;;=2920408
	;;^DD(350.6,.05,21,0)
	;;=^^4^4^2920427^^^
	;;^DD(350.6,.05,21,1,0)
	;;=This field contains the current status of the archive/purge operation.
	;;^DD(350.6,.05,21,2,0)
	;;=The status will be OPEN when the log entry is created, and CLOSED after
	;;^DD(350.6,.05,21,3,0)
	;;=successfully purging archived entries.  The entry will be CANCELLED if an
