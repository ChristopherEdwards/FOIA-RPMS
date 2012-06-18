IBINI015	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350,.02,21,1,0)
	;;=This is the patient that received services, care, or medications that
	;;^DD(350,.02,21,2,0)
	;;=caused this entry to be created.  If the debtor is the patient, this
	;;^DD(350,.02,21,3,0)
	;;=patient is the debtor.
	;;^DD(350,.02,"DT")
	;;=2930728
	;;^DD(350,.03,0)
	;;=ACTION TYPE^P350.1'I^IBE(350.1,^0;3^Q
	;;^DD(350,.03,1,0)
	;;=^.1^^-1
	;;^DD(350,.03,1,1,0)
	;;=350^AE
	;;^DD(350,.03,1,1,1)
	;;=S ^IB("AE",$E(X,1,30),DA)=""
	;;^DD(350,.03,1,1,2)
	;;=K ^IB("AE",$E(X,1,30),DA)
	;;^DD(350,.03,3)
	;;=
	;;^DD(350,.03,21,0)
	;;=^^7^7^2940209^^^^
	;;^DD(350,.03,21,1,0)
	;;=This field points to an entry in the IB ACTION TYPE file.  Entries in
	;;^DD(350,.03,21,2,0)
	;;=the IB ACTION TYPE file provide specific information about the type
	;;^DD(350,.03,21,3,0)
	;;=of entry that is being created and provides data necessary to AR and
	;;^DD(350,.03,21,4,0)
	;;=to resolve the data from the application.
	;;^DD(350,.03,21,5,0)
	;;= 
	;;^DD(350,.03,21,6,0)
	;;=Applications passing data to IB determine the Action Type and pass this
	;;^DD(350,.03,21,7,0)
	;;=to IB.
	;;^DD(350,.03,"DT")
	;;=2910304
	;;^DD(350,.04,0)
	;;=RESULTING FROM^FI^^0;4^K:$L(X)>20!($L(X)<1) X
	;;^DD(350,.04,3)
	;;=Answer must be 1-20 characters in length.
	;;^DD(350,.04,21,0)
	;;=^^8^8^2940209^^^^
	;;^DD(350,.04,21,1,0)
	;;=This will be the soft-link back to the entry in any file that caused
	;;^DD(350,.04,21,2,0)
	;;=this transaction to be set.  It will be in the format of:
	;;^DD(350,.04,21,3,0)
	;;= 
	;;^DD(350,.04,21,4,0)
	;;=    filenumber:entry;[node:sub-entry];[node:sub-entry]...
	;;^DD(350,.04,21,5,0)
	;;= 
	;;^DD(350,.04,21,6,0)
	;;=The number of node:sub-entry pieces will depend on the level of
	;;^DD(350,.04,21,7,0)
	;;=multiples that cause the entry.  For example, a new prescription
	;;^DD(350,.04,21,8,0)
	;;=might be '52:345678'  but the first refill might be '52:345678;1,1'.
	;;^DD(350,.04,"DT")
	;;=2910304
	;;^DD(350,.05,0)
	;;=STATUS^P350.21'^IBE(350.21,^0;5^Q
	;;^DD(350,.05,1,0)
	;;=^.1
	;;^DD(350,.05,1,1,0)
	;;=350^AC
	;;^DD(350,.05,1,1,1)
	;;=S ^IB("AC",$E(X,1,30),DA)=""
	;;^DD(350,.05,1,1,2)
	;;=K ^IB("AC",$E(X,1,30),DA)
	;;^DD(350,.05,1,2,0)
	;;=^^TRIGGER^350^13
	;;^DD(350,.05,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IB(D0,1)):^(1),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X=DIV S X=$S($D(IBDUZ):IBDUZ,$D(DUZ):DUZ,1:.5) X ^DD(350,.05,1,2,1.4)
	;;^DD(350,.05,1,2,1.4)
	;;=S DIH=$S($D(^IB(DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,3)=DIV,DIH=350,DIG=13 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350,.05,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IB(D0,1)):^(1),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X=DIV S X=$S($D(IBDUZ):IBDUZ,$D(DUZ):DUZ,1:.5) X ^DD(350,.05,1,2,2.4)
	;;^DD(350,.05,1,2,2.4)
	;;=S DIH=$S($D(^IB(DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,3)=DIV,DIH=350,DIG=13 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350,.05,1,2,"CREATE VALUE")
	;;=S X=$S($D(IBDUZ):IBDUZ,$D(DUZ):DUZ,1:.5)
	;;^DD(350,.05,1,2,"DELETE VALUE")
	;;=S X=$S($D(IBDUZ):IBDUZ,$D(DUZ):DUZ,1:.5)
	;;^DD(350,.05,1,2,"FIELD")
	;;=#13
	;;^DD(350,.05,1,3,0)
	;;=^^TRIGGER^350^14
	;;^DD(350,.05,1,3,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IB(D0,1)):^(1),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y X ^DD(350,.05,1,3,1.1) X ^DD(350,.05,1,3,1.4)
	;;^DD(350,.05,1,3,1.1)
	;;=S X=DIV S %=$P($H,",",2),X=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100)
	;;^DD(350,.05,1,3,1.4)
	;;=S DIH=$S($D(^IB(DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,4)=DIV,DIH=350,DIG=14 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350,.05,1,3,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IB(D0,1)):^(1),1:"") S X=$P(Y(1),U,4),X=X S DIU=X K Y X ^DD(350,.05,1,3,2.1) X ^DD(350,.05,1,3,2.4)
