IBINI05F	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(356,.09,"DT")
	;;=2940131
	;;^DD(356,.1,0)
	;;=REFILL DATE^NJ2,0^^0;10^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(356,.1,1,0)
	;;=^.1
	;;^DD(356,.1,1,1,0)
	;;=356^ARXFL^MUMPS
	;;^DD(356,.1,1,1,1)
	;;=S:$P(^IBT(356,DA,0),U,8) ^IBT(356,"ARXFL",$P(^(0),U,8),X,DA)=""
	;;^DD(356,.1,1,1,2)
	;;=K ^IBT(356,"ARXFL",+$P(^IBT(356,DA,0),U,8),X,DA)
	;;^DD(356,.1,1,1,"%D",0)
	;;=^^2^2^2940213^^
	;;^DD(356,.1,1,1,"%D",1,0)
	;;=This is a cross reference of all prescriptions and refills.  It is used
	;;^DD(356,.1,1,1,"%D",2,0)
	;;=to ensure that only 1 entry for each refill is created.
	;;^DD(356,.1,1,1,"DT")
	;;=2930813
	;;^DD(356,.1,3)
	;;=Type a Number between 1 and 99, 0 Decimal Digits
	;;^DD(356,.1,21,0)
	;;=^^4^4^2930813^
	;;^DD(356,.1,21,1,0)
	;;=This is the internal entry number of the refill, it will have an
	;;^DD(356,.1,21,2,0)
	;;=input and output transform to make it look like its a date.  The
	;;^DD(356,.1,21,3,0)
	;;=system will store the number value.
	;;^DD(356,.1,21,4,0)
	;;= 
	;;^DD(356,.1,"DT")
	;;=2930813
	;;^DD(356,.11,0)
	;;=INITIAL BILL NUMBER^P399'^DGCR(399,^0;11^Q
	;;^DD(356,.11,1,0)
	;;=^.1^^-1
	;;^DD(356,.11,1,1,0)
	;;=356^E
	;;^DD(356,.11,1,1,1)
	;;=S ^IBT(356,"E",$E(X,1,30),DA)=""
	;;^DD(356,.11,1,1,2)
	;;=K ^IBT(356,"E",$E(X,1,30),DA)
	;;^DD(356,.11,1,1,"DT")
	;;=2930712
	;;^DD(356,.11,1,2,0)
	;;=^^TRIGGER^356^.17
	;;^DD(356,.11,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y S X=DIV S X=$$BILL^IBTUTL(DA) X ^DD(356,.11,1,2,1.4)
	;;^DD(356,.11,1,2,1.4)
	;;=S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,.11,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y S X=DIV S X=$$BILL^IBTUTL(DA) X ^DD(356,.11,1,2,2.4)
	;;^DD(356,.11,1,2,2.4)
	;;=S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(356,.11,1,2,"%D",0)
	;;=^^1^1^2930827^^
	;;^DD(356,.11,1,2,"%D",1,0)
	;;=Re-sets Earliest Auto Bill Date each time Initial Bill Number is modified.
	;;^DD(356,.11,1,2,"CREATE VALUE")
	;;=S X=$$BILL^IBTUTL(DA)
	;;^DD(356,.11,1,2,"DELETE VALUE")
	;;=S X=$$BILL^IBTUTL(DA)
	;;^DD(356,.11,1,2,"DT")
	;;=2930825
	;;^DD(356,.11,1,2,"FIELD")
	;;=EARLIEST AUTO BILL DATE
	;;^DD(356,.11,5,1,0)
	;;=356.399^.02^3
	;;^DD(356,.11,9)
	;;=^
	;;^DD(356,.11,21,0)
	;;=^^3^3^2940213^^^^
	;;^DD(356,.11,21,1,0)
	;;=This is the bill number in the BILL/CLAIMS file for the initial
	;;^DD(356,.11,21,2,0)
	;;=bill number for this entry.  It is the bill to the third
	;;^DD(356,.11,21,3,0)
	;;=party for this claim.
	;;^DD(356,.11,"DT")
	;;=2930825
	;;^DD(356,.12,0)
	;;=OTHER TYPE OF BILL^S^1:TORT FEASOR;2:FEDERAL OWCP;3:WORKMAN'S COMP;4:OTHER;^0;12^Q
	;;^DD(356,.12,1,0)
	;;=^.1
	;;^DD(356,.12,1,1,0)
	;;=356^AC
	;;^DD(356,.12,1,1,1)
	;;=S ^IBT(356,"AC",$E(X,1,30),DA)=""
	;;^DD(356,.12,1,1,2)
	;;=K ^IBT(356,"AC",$E(X,1,30),DA)
	;;^DD(356,.12,1,1,"DT")
	;;=2930712
	;;^DD(356,.12,1,2,0)
	;;=356^ASPC^MUMPS
	;;^DD(356,.12,1,2,1)
	;;=S:$P(^IBT(356,DA,0),U,2) ^IBT(356,"ASPC",+$P(^(0),U,2),X,DA)=""
	;;^DD(356,.12,1,2,2)
	;;=K ^IBT(356,"ASPC",+$P(^IBT(356,DA,0),U,2),X,DA)
	;;^DD(356,.12,1,2,"%D",0)
	;;=^^1^1^2930820^^^
	;;^DD(356,.12,1,2,"%D",1,0)
	;;=Cross reference of special types of bills by patient.
	;;^DD(356,.12,1,2,"DT")
	;;=2930712
	;;^DD(356,.12,1,3,0)
	;;=^^TRIGGER^356^.17
	;;^DD(356,.12,1,3,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBT(356,D0,0)):^(0),1:"") S X=$P(Y(1),U,17),X=X S DIU=X K Y S X="" S DIH=$S($D(^IBT(356,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,17)=DIV,DIH=356,DIG=.17 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
