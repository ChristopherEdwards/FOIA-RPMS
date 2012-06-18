IBINI00Z	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.181,1,2,"%D",1,0)
	;;=When changing or deleting CLAIMS (RX) STREET ADDRESS 1 delete CLAIMS (RX) STREET ADDRESS 2.
	;;^DD(36,.181,1,2,"CREATE VALUE")
	;;=@
	;;^DD(36,.181,1,2,"DELETE VALUE")
	;;=@
	;;^DD(36,.181,1,2,"DT")
	;;=2940104
	;;^DD(36,.181,1,2,"FIELD")
	;;=#.183
	;;^DD(36,.181,3)
	;;=If the prescription claims address of this company is different from its main address, enter Line 1 of the prescription claims address.  Answer must be 3-30 characters in length.
	;;^DD(36,.181,21,0)
	;;=^^1^1^2940104^^^
	;;^DD(36,.181,21,1,0)
	;;=Enter the first line of the street address for the prescription claims office of this insurance carrier.
	;;^DD(36,.181,"DT")
	;;=2940104
	;;^DD(36,.182,0)
	;;=CLAIMS (RX) STREET ADDRESS 2^F^^.18;2^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.182,1,0)
	;;=^.1
	;;^DD(36,.182,1,1,0)
	;;=^^TRIGGER^36^.183
	;;^DD(36,.182,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.18)):^(.18),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.182,1,1,1.4)
	;;^DD(36,.182,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.18)):^(.18),1:""),DIV=X S $P(^(.18),U,3)=DIV,DIH=36,DIG=.183 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.182,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.18)):^(.18),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.182,1,1,2.4)
	;;^DD(36,.182,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.18)):^(.18),1:""),DIV=X S $P(^(.18),U,3)=DIV,DIH=36,DIG=.183 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.182,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.182,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.182,1,1,"FIELD")
	;;=#.183
	;;^DD(36,.182,3)
	;;=If the prescription claims address of this company is different from its main address, enter Line 2 of the prescription claims address.  Answer must be 3-30 characters in length.
	;;^DD(36,.182,5,1,0)
	;;=36^.181^1
	;;^DD(36,.182,21,0)
	;;=^^1^1^2940103^
	;;^DD(36,.182,21,1,0)
	;;=If this insurance company's prescription claims office street address is longer than one line, enter the second line here.
	;;^DD(36,.182,"DT")
	;;=2940104
	;;^DD(36,.183,0)
	;;=CLAIMS (RX) STREET ADDRESS 3^F^^.18;3^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.183,3)
	;;=If the prescription clais office address of this company is different from its main address, enter Line 3 of the prescription claims street address.  Answer must be 3-30 characters in length.
	;;^DD(36,.183,5,1,0)
	;;=36^.181^2
	;;^DD(36,.183,5,2,0)
	;;=36^.182^1
	;;^DD(36,.183,21,0)
	;;=^^1^1^2940103^
	;;^DD(36,.183,21,1,0)
	;;=If this insurance company's prescription claims office street address is longer than two lines, enter the third line here.
	;;^DD(36,.183,"DT")
	;;=2940103
	;;^DD(36,.184,0)
	;;=CLAIMS (RX) CITY^F^^.18;4^K:$L(X)>25!($L(X)<2) X
	;;^DD(36,.184,3)
	;;=If the prescription claims office address of this company is different from its main address, enter city of the prescription claims address.  Answer must be 2-25 characters in length.
	;;^DD(36,.184,21,0)
	;;=^^1^1^2940103^
	;;^DD(36,.184,21,1,0)
	;;=Enter the city in which this insurance company's prescription claims office is located.
	;;^DD(36,.184,"DT")
	;;=2940103
	;;^DD(36,.185,0)
	;;=CLAIMS (RX) STATE^P5'^DIC(5,^.18;5^Q
	;;^DD(36,.185,3)
	;;=If the prescription clais office address of this company is different from its main address, enter state of the prescription claims office.
	;;^DD(36,.185,21,0)
	;;=^^1^1^2940103^^
	;;^DD(36,.185,21,1,0)
	;;=Enter the state in which this insurance company's prescription claims office is located.  Enter state even if it is the same as the state of the company's main address.
