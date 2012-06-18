IBINI01Z	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.6,2.01,1,1,1.4)
	;;=S DIH=$S($D(^IBE(350.6,DIV(0),2)):^(2),1:""),DIV=X S $P(^(2),U,3)=DIV,DIH=350.6,DIG=2.03 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350.6,2.01,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBE(350.6,D0,2)):^(2),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(350.6,2.01,1,1,2.4)
	;;^DD(350.6,2.01,1,1,2.4)
	;;=S DIH=$S($D(^IBE(350.6,DIV(0),2)):^(2),1:""),DIV=X S $P(^(2),U,3)=DIV,DIH=350.6,DIG=2.03 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350.6,2.01,1,1,"CREATE VALUE")
	;;=S X=DUZ
	;;^DD(350.6,2.01,1,1,"DELETE VALUE")
	;;=@
	;;^DD(350.6,2.01,1,1,"DT")
	;;=2920424
	;;^DD(350.6,2.01,1,1,"FIELD")
	;;=#2.03
	;;^DD(350.6,2.01,21,0)
	;;=^^2^2^2920427^^
	;;^DD(350.6,2.01,21,1,0)
	;;=The date/time that the archiving of data is initiated is automatically
	;;^DD(350.6,2.01,21,2,0)
	;;=stuffed into this field by the 'Archive' option.
	;;^DD(350.6,2.01,"DT")
	;;=2920424
	;;^DD(350.6,2.02,0)
	;;=ARCHIVE END DATE/TIME^D^^2;2^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.6,2.02,3)
	;;=
	;;^DD(350.6,2.02,21,0)
	;;=^^4^4^2920427^^
	;;^DD(350.6,2.02,21,1,0)
	;;=The date/time that the archiving of data was completed is automatically
	;;^DD(350.6,2.02,21,2,0)
	;;=stuffed into this field by the 'Archive' option.  The existence of this
	;;^DD(350.6,2.02,21,3,0)
	;;=field in the log entry assures that archiving was successful, and thus
	;;^DD(350.6,2.02,21,4,0)
	;;=the field is used as a flag to allow purging.
	;;^DD(350.6,2.03,0)
	;;=ARCHIVE INITIATOR^P200'^VA(200,^2;3^Q
	;;^DD(350.6,2.03,5,1,0)
	;;=350.6^2.01^1
	;;^DD(350.6,2.03,21,0)
	;;=^^2^2^2920427^^
	;;^DD(350.6,2.03,21,1,0)
	;;=This field contains the individual who archived the file.  The field is
	;;^DD(350.6,2.03,21,2,0)
	;;=updated by a trigger when the ARCHIVE BEGIN DATE/TIME field is updated.
	;;^DD(350.6,2.03,"DT")
	;;=2920408
	;;^DD(350.6,3.01,0)
	;;=PURGE BEGIN DATE/TIME^D^^3;1^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.6,3.01,1,0)
	;;=^.1
	;;^DD(350.6,3.01,1,1,0)
	;;=^^TRIGGER^350.6^3.03
	;;^DD(350.6,3.01,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBE(350.6,D0,3)):^(3),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X=DIV S X=DUZ X ^DD(350.6,3.01,1,1,1.4)
	;;^DD(350.6,3.01,1,1,1.4)
	;;=S DIH=$S($D(^IBE(350.6,DIV(0),3)):^(3),1:""),DIV=X S $P(^(3),U,3)=DIV,DIH=350.6,DIG=3.03 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350.6,3.01,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^IBE(350.6,D0,3)):^(3),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(350.6,3.01,1,1,2.4)
	;;^DD(350.6,3.01,1,1,2.4)
	;;=S DIH=$S($D(^IBE(350.6,DIV(0),3)):^(3),1:""),DIV=X S $P(^(3),U,3)=DIV,DIH=350.6,DIG=3.03 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(350.6,3.01,1,1,"CREATE VALUE")
	;;=S X=DUZ
	;;^DD(350.6,3.01,1,1,"DELETE VALUE")
	;;=@
	;;^DD(350.6,3.01,1,1,"DT")
	;;=2920424
	;;^DD(350.6,3.01,1,1,"FIELD")
	;;=#3.03
	;;^DD(350.6,3.01,21,0)
	;;=^^2^2^2920427^
	;;^DD(350.6,3.01,21,1,0)
	;;=The date/time that purging is initiated is automatically stuffed into
	;;^DD(350.6,3.01,21,2,0)
	;;=this field by the 'Purge' option.
	;;^DD(350.6,3.01,"DT")
	;;=2920424
	;;^DD(350.6,3.02,0)
	;;=PURGE END DATE/TIME^D^^3;2^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.6,3.02,3)
	;;=
	;;^DD(350.6,3.02,21,0)
	;;=^^3^3^2920427^
	;;^DD(350.6,3.02,21,1,0)
	;;=The date/time that the purging of data was completed is automatically
	;;^DD(350.6,3.02,21,2,0)
	;;=stuffed into this field by the 'Purge' option.  When this field is
	;;^DD(350.6,3.02,21,3,0)
	;;=updated the status of the log entry is updated to CLOSED.
	;;^DD(350.6,3.03,0)
	;;=PURGE INITIATOR^P200'^VA(200,^3;3^Q
