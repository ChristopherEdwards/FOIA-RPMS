GMPLI008	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(125.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(125.12,3,21,3,0)
	;;=Lexicon Utility and an 'Unresolved' entry was returned, this will be the
	;;^DD(125.12,3,21,4,0)
	;;=text as specified by the user.
	;;^DD(125.12,3,"DT")
	;;=2931005
	;;^DD(125.12,4,0)
	;;=CODE^F^^0;5^K:$L(X)>15!($L(X)<2) X
	;;^DD(125.12,4,3)
	;;=Enter the code (ICD, CPT, etc) you wish to have displayed with this problem.
	;;^DD(125.12,4,21,0)
	;;=^^3^3^2931007^
	;;^DD(125.12,4,21,1,0)
	;;=This is a code which is to be displayed with the text of this problem;
	;;^DD(125.12,4,21,2,0)
	;;=it may be from any coding system, but will generally be assumed to be
	;;^DD(125.12,4,21,3,0)
	;;=an ICD Diagnosis in the Problem List context.
	;;^DD(125.12,4,"DT")
	;;=2931007
