IBINI07I	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357,.1,0)
	;;=PAGE LENGTH^RNJ3,0^^0;10^K:+X'=X!(X>300)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(357,.1,.1)
	;;=FORM'S PAGE LENGTH (IN LINES)
	;;^DD(357,.1,3)
	;;=How many lines should the form have?
	;;^DD(357,.1,21,0)
	;;=^^2^2^2921213^
	;;^DD(357,.1,21,1,0)
	;;= 
	;;^DD(357,.1,21,2,0)
	;;=This is the number of usable lines on the page.
	;;^DD(357,.1,"DT")
	;;=2930420
	;;^DD(357,.11,0)
	;;=NUMBER OF PAGES^RNJ2,0^^0;11^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(357,.11,3)
	;;=How many pages should the encounter form have?
	;;^DD(357,.11,21,0)
	;;=^^1^1^2930602^
	;;^DD(357,.11,21,1,0)
	;;=The encounter form may have multiple pages.
	;;^DD(357,.11,"DT")
	;;=2930602
