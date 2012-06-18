IBINI088	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.6,5.01,21,0)
	;;=^^3^3^2930528^
	;;^DD(357.6,5.01,21,1,0)
	;;= 
	;;^DD(357.6,5.01,21,2,0)
	;;=This code will be executed after the interface routine is called.
	;;^DD(357.6,5.01,21,3,0)
	;;=The effect of the NEW done on the PROTECTED VARIABLES is still in effect.
	;;^DD(357.6,5.01,"DT")
	;;=2930518
	;;^DD(357.6,6,0)
	;;=PROTECTED LOCAL VARIABLES^357.66^^6;0
	;;^DD(357.6,6,21,0)
	;;=^^11^11^2930608^^
	;;^DD(357.6,6,21,1,0)
	;;= 
	;;^DD(357.6,6,21,2,0)
	;;=This is a list of variables that should be newed before the entry action
	;;^DD(357.6,6,21,3,0)
	;;=or calling the interface routine. It is protection against interfaces that
	;;^DD(357.6,6,21,4,0)
	;;=alter or kill variables, or entry actions that do so. Note that REQUIRED
	;;^DD(357.6,6,21,5,0)
	;;=VARIABLES should not also be PROTECTED VARIABLES. If an interface routine
	;;^DD(357.6,6,21,6,0)
	;;=changes a required variable, however, there is a way to protect it.
	;;^DD(357.6,6,21,7,0)
	;;=Supposing, for example, DFN is killed by the interface. This will protect
	;;^DD(357.6,6,21,8,0)
	;;=it:
	;;^DD(357.6,6,21,9,0)
	;;=     PROTECTED VARIABLE:   IBDFN
	;;^DD(357.6,6,21,10,0)
	;;=     ENTRY ACTION:  S IBDFN=DFN
	;;^DD(357.6,6,21,11,0)
	;;=     EXIT ACTION:   S DFN=IBDFN
	;;^DD(357.6,7,0)
	;;=REQUIRED LOCAL VARIABLES^357.67^^7;0
	;;^DD(357.6,7,21,0)
	;;=^^4^4^2930528^
	;;^DD(357.6,7,21,1,0)
	;;= 
	;;^DD(357.6,7,21,2,0)
	;;=The interface may require inputs. This field is a list of the required
	;;^DD(357.6,7,21,3,0)
	;;=local variables. The interface will not be called unless the variables are
	;;^DD(357.6,7,21,4,0)
	;;=determined to exist.
	;;^DD(357.6,8.01,0)
	;;=PIECE 1 NODE^F^^8;1^K:$L(X)>10!($L(X)<1) X
	;;^DD(357.6,8.01,3)
	;;=You can optionally specify the subscript to store the data.
	;;^DD(357.6,8.01,21,0)
	;;=^^1^1^2931014^
	;;^DD(357.6,8.01,21,1,0)
	;;=For record type data, the node of the field can be optionally specified.
	;;^DD(357.6,8.01,"DT")
	;;=2931014
	;;^DD(357.6,8.02,0)
	;;=PIECE 2 NODE^F^^8;2^K:$L(X)>10!($L(X)<1) X
	;;^DD(357.6,8.02,3)
	;;=You can optionally specify the subscript to store the data.
	;;^DD(357.6,8.02,21,0)
	;;=^^1^1^2931014^
	;;^DD(357.6,8.02,21,1,0)
	;;=For records you can optionally specify the node to store the field.
	;;^DD(357.6,8.02,"DT")
	;;=2931014
	;;^DD(357.6,8.03,0)
	;;=PIECE 3 NODE^F^^8;3^K:$L(X)>10!($L(X)<1) X
	;;^DD(357.6,8.03,3)
	;;=You can optionally specify the subscript to store the data.
	;;^DD(357.6,8.03,21,0)
	;;=^^1^1^2931014^
	;;^DD(357.6,8.03,21,1,0)
	;;=For record type data you can optionally specify the node to store the data.
	;;^DD(357.6,8.03,"DT")
	;;=2931014
	;;^DD(357.6,8.04,0)
	;;=PIECE 4 NODE^F^^8;4^K:$L(X)>10!($L(X)<1) X
	;;^DD(357.6,8.04,3)
	;;=You can optionally specify the subscript to store the data.
	;;^DD(357.6,8.04,21,0)
	;;=^^1^1^2931014^
	;;^DD(357.6,8.04,21,1,0)
	;;=For record type data you can optionally specify the node to store the field.
	;;^DD(357.6,8.04,"DT")
	;;=2931014
	;;^DD(357.6,8.05,0)
	;;=PIECE 5 NODE^F^^8;5^K:$L(X)>10!($L(X)<1) X
	;;^DD(357.6,8.05,3)
	;;=You can optionally specify the subscript to store the data.
	;;^DD(357.6,8.05,21,0)
	;;=^^1^1^2931014^
	;;^DD(357.6,8.05,21,1,0)
	;;=For record type data you can optionally specify the node to store the field.
	;;^DD(357.6,8.05,"DT")
	;;=2931014
	;;^DD(357.6,8.06,0)
	;;=PIECE 6 NODE^F^^8;6^K:$L(X)>10!($L(X)<1) X
	;;^DD(357.6,8.06,3)
	;;=You can optionally specify the subscript to store the data.
	;;^DD(357.6,8.06,21,0)
	;;=^^1^1^2931014^
	;;^DD(357.6,8.06,21,1,0)
	;;=For records you can optionally specify the node to store the field.
