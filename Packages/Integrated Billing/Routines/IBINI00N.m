IBINI00N	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.122,1,1,0)
	;;=^^TRIGGER^36^.123
	;;^DD(36,.122,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.12)):^(.12),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.122,1,1,1.4)
	;;^DD(36,.122,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.12)):^(.12),1:""),DIV=X S $P(^(.12),U,3)=DIV,DIH=36,DIG=.123 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.122,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.12)):^(.12),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.122,1,1,2.4)
	;;^DD(36,.122,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.12)):^(.12),1:""),DIV=X S $P(^(.12),U,3)=DIV,DIH=36,DIG=.123 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.122,1,1,"%D",0)
	;;=^^2^2^2930715^^
	;;^DD(36,.122,1,1,"%D",1,0)
	;;=When changing or deleting CLAIMS (OPT) STREET ADDRESS 2 delete
	;;^DD(36,.122,1,1,"%D",2,0)
	;;=CLAIMS (OPT) STREET ADDRESS 3.
	;;^DD(36,.122,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.122,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.122,1,1,"DT")
	;;=2930401
	;;^DD(36,.122,1,1,"FIELD")
	;;=CLAIMS STREET ADDRESS [LINE 3]
	;;^DD(36,.122,3)
	;;=If the inpatient claims process address of this company is different from its main address, enter Line 2 of the inpatient claims street address.  Answer must be 3-30 characters in length.
	;;^DD(36,.122,5,1,0)
	;;=36^.121^1
	;;^DD(36,.122,21,0)
	;;=^^2^2^2930715^^^^
	;;^DD(36,.122,21,1,0)
	;;=If this insurance company's inpatient claims office street address 
	;;^DD(36,.122,21,2,0)
	;;=is longer than one line, enter the second line here.
	;;^DD(36,.122,"DT")
	;;=2930715
	;;^DD(36,.123,0)
	;;=CLAIMS (INPT) STREET ADDRESS 3^F^^.12;3^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.123,3)
	;;=If the inpatient claims process address of this company is different from its main address, enter Line 3 of the inpatient claims street address.  Answer must be 3-30 characters in length.
	;;^DD(36,.123,5,1,0)
	;;=36^.121^2
	;;^DD(36,.123,5,2,0)
	;;=36^.122^1
	;;^DD(36,.123,21,0)
	;;=^^2^2^2930715^^^
	;;^DD(36,.123,21,1,0)
	;;=If this insurance company's inpatient claims office street address is longer
	;;^DD(36,.123,21,2,0)
	;;=than two lines, enter the third line here.
	;;^DD(36,.123,"DT")
	;;=2930715
	;;^DD(36,.124,0)
	;;=CLAIMS (INPT) PROCESS CITY^F^^.12;4^K:$L(X)>25!($L(X)<2) X
	;;^DD(36,.124,3)
	;;=If the inpatient claims process address of this company is different from its main address, enter city of the inpatient claims process address.  Answer must be 2-25 characters in length.
	;;^DD(36,.124,21,0)
	;;=^^2^2^2930715^^^
	;;^DD(36,.124,21,1,0)
	;;=Enter the city in which this insurance company's inpatient claims office is
	;;^DD(36,.124,21,2,0)
	;;=located.
	;;^DD(36,.124,"DT")
	;;=2930715
	;;^DD(36,.125,0)
	;;=CLAIMS (INPT) PROCESS STATE^P5'^DIC(5,^.12;5^Q
	;;^DD(36,.125,3)
	;;=If the inpatient claims process address of this company is different from its main address, enter state of the inpatient claims process address.
	;;^DD(36,.125,21,0)
	;;=^^3^3^2931007^^^^
	;;^DD(36,.125,21,1,0)
	;;=Enter the state in which this insurance company's inpatient claims 
	;;^DD(36,.125,21,2,0)
	;;=office is located.  Enter state even if it is the same as the state
	;;^DD(36,.125,21,3,0)
	;;=of the company's main address.
	;;^DD(36,.125,"DT")
	;;=2931007
	;;^DD(36,.126,0)
	;;=CLAIMS (INPT) PROCESS ZIP^FXO^^.12;6^K:$L(X)>20!($L(X)<5) X I $D(X) D ZIPIN^VAFADDR
	;;^DD(36,.126,2)
	;;=S Y(0)=Y D ZIPOUT^VAFADDR
	;;^DD(36,.126,2.1)
	;;=D ZIPOUT^VAFADDR
	;;^DD(36,.126,3)
	;;=If the inpatient claims process address of this company is different from its main address, enter zip code of the inpatient claims process address.  Answer with either 5 digit or 9 digit zip code.
