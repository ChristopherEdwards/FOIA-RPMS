IBINI01Y	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.6,.05,21,4,0)
	;;=error is detected during processing which invalidates the operation.
	;;^DD(350.6,.05,"DT")
	;;=2920408
	;;^DD(350.6,1.01,0)
	;;=SEARCH BEGIN DATE/TIME^D^^1;1^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.6,1.01,1,0)
	;;=^.1
	;;^DD(350.6,1.01,1,1,0)
	;;=^^TRIGGER^350.6^1.03
	;;^DD(350.6,1.01,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBE(350.6,D0,1)):^(1),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(350.6,1.01,1,1,1.4)
	;;^DD(350.6,1.01,1,1,1.4)
	;;=S DIH=$S($D(^IBE(350.6,DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,3)=DIV,DIH=350.6,DIG=1.03 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350.6,1.01,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBE(350.6,D0,1)):^(1),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(350.6,1.01,1,1,2.4)
	;;^DD(350.6,1.01,1,1,2.4)
	;;=S DIH=$S($D(^IBE(350.6,DIV(0),1)):^(1),1:""),DIV=X S $P(^(1),U,3)=DIV,DIH=350.6,DIG=1.03 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350.6,1.01,1,1,"CREATE VALUE")
	;;=S X=DUZ
	;;^DD(350.6,1.01,1,1,"DELETE VALUE")
	;;=@
	;;^DD(350.6,1.01,1,1,"DT")
	;;=2920424
	;;^DD(350.6,1.01,1,1,"FIELD")
	;;=SEARCH INITIATOR
	;;^DD(350.6,1.01,1,2,0)
	;;=350.6^AF1^MUMPS
	;;^DD(350.6,1.01,1,2,1)
	;;=I $D(^IBE(350.6,DA,0)),$P(^(0),"^",3) S ^IBE(350.6,"AF",$P(^(0),"^",3),-X,DA)=""
	;;^DD(350.6,1.01,1,2,2)
	;;=I $D(^IBE(350.6,DA,0)),$P(^(0),"^",3) K ^IBE(350.6,"AF",$P(^(0),"^",3),-X,DA)
	;;^DD(350.6,1.01,1,2,"%D",0)
	;;=^^5^5^2920410^
	;;^DD(350.6,1.01,1,2,"%D",1,0)
	;;=Cross-reference of all ARCHIVE/PURGE LOG entries (by Archive file [#.03]
	;;^DD(350.6,1.01,1,2,"%D",2,0)
	;;=and the inverse Search Begin Date/Time [#1.01]) for which a search has
	;;^DD(350.6,1.01,1,2,"%D",3,0)
	;;=been initiated.  The cross-reference will be used to find the most recent
	;;^DD(350.6,1.01,1,2,"%D",4,0)
	;;=log entry for a file.  The "AF" cross-reference on the Archive File field
	;;^DD(350.6,1.01,1,2,"%D",5,0)
	;;=(#.03) is the companion to this cross-reference.
	;;^DD(350.6,1.01,1,2,"DT")
	;;=2920410
	;;^DD(350.6,1.01,21,0)
	;;=^^2^2^2920427^^
	;;^DD(350.6,1.01,21,1,0)
	;;=The date/time at which the search was initiated is automatically stuffed
	;;^DD(350.6,1.01,21,2,0)
	;;=into this field by the 'Search' option.
	;;^DD(350.6,1.01,"DT")
	;;=2920424
	;;^DD(350.6,1.02,0)
	;;=SEARCH END DATE/TIME^D^^1;2^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.6,1.02,3)
	;;=
	;;^DD(350.6,1.02,21,0)
	;;=^^4^4^2920427^^
	;;^DD(350.6,1.02,21,1,0)
	;;=The date/time at which the search was completed is automatically stuffed
	;;^DD(350.6,1.02,21,2,0)
	;;=into this field by the 'Search' option.  The existence of this field in
	;;^DD(350.6,1.02,21,3,0)
	;;=the log entry assures that the search on the file was successful, and
	;;^DD(350.6,1.02,21,4,0)
	;;=thus the field is used as the flag to allow archiving.
	;;^DD(350.6,1.03,0)
	;;=SEARCH INITIATOR^P200'^VA(200,^1;3^Q
	;;^DD(350.6,1.03,5,1,0)
	;;=350.6^1.01^1
	;;^DD(350.6,1.03,21,0)
	;;=^^3^3^2920427^
	;;^DD(350.6,1.03,21,1,0)
	;;=This field conatins the individual who queued the search on the file.
	;;^DD(350.6,1.03,21,2,0)
	;;=The field is updated by a trigger when the SEARCH BEGIN DATE/TIME field
	;;^DD(350.6,1.03,21,3,0)
	;;=is updated.
	;;^DD(350.6,1.03,"DT")
	;;=2920408
	;;^DD(350.6,2.01,0)
	;;=ARCHIVE BEGIN DATE/TIME^D^^2;1^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.6,2.01,1,0)
	;;=^.1
	;;^DD(350.6,2.01,1,1,0)
	;;=^^TRIGGER^350.6^2.03
	;;^DD(350.6,2.01,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBE(350.6,D0,2)):^(2),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(350.6,2.01,1,1,1.4)
