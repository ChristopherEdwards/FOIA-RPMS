IBINI0AP	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,451,23,0)
	;;=^^4^4^2931216^^^^
	;;^DD(399,451,23,1,0)
	;;=Unlabled Form Locator 11 on the UB-92.  On the form the block is two lines
	;;^DD(399,451,23,2,0)
	;;=of 12 and 13 characters, with the upper line optional.  Therefore, if
	;;^DD(399,451,23,3,0)
	;;=string is longer than 13 characters it must be split and printed on both
	;;^DD(399,451,23,4,0)
	;;=lines.
	;;^DD(399,451,"DT")
	;;=2931216
	;;^DD(399,452,0)
	;;=FORM LOCATOR 31^F^^UF3;3^K:$L(X)>11!($L(X)<3) X
	;;^DD(399,452,3)
	;;=Answer must be 3-11 characters in length.
	;;^DD(399,452,21,0)
	;;=^^2^2^2931216^^^
	;;^DD(399,452,21,1,0)
	;;=Printed in Form Locator 31 on the UB-92.  If more than 6 characters are
	;;^DD(399,452,21,2,0)
	;;=entered this will be printed on two lines.
	;;^DD(399,452,23,0)
	;;=^^3^3^2931216^^^
	;;^DD(399,452,23,1,0)
	;;=Unlabled Form Locator 31 on the UB-92.  On the form the block is two lines
	;;^DD(399,452,23,2,0)
	;;=of 5 and 6 characters.  Therefore, if the string is longer than 6
	;;^DD(399,452,23,3,0)
	;;=characters it must be split and printed on both lines.
	;;^DD(399,452,"DT")
	;;=2931216
	;;^DD(399,453,0)
	;;=FORM LOCATOR 37A^F^^UF3;4^K:$L(X)>23!($L(X)<3) X
	;;^DD(399,453,3)
	;;=Answer must be 3-23 characters in length.
	;;^DD(399,453,21,0)
	;;=^^4^4^2931216^^
	;;^DD(399,453,21,1,0)
	;;=Unlabled Form Locator 37A on the UB-92.  This field is nationally reserved
	;;^DD(399,453,21,2,0)
	;;=on adjustment/replacement type bills for the Internal Control
	;;^DD(399,453,21,3,0)
	;;=Number (ICN)/Document Control Number (DCN) assigned to the original bill
	;;^DD(399,453,21,4,0)
	;;=by the primary payer (in 50A).
	;;^DD(399,453,"DT")
	;;=2931216
	;;^DD(399,454,0)
	;;=FORM LOCATOR 37B^F^^UF3;5^K:$L(X)>23!($L(X)<3) X
	;;^DD(399,454,3)
	;;=Answer must be 3-23 characters in length.
	;;^DD(399,454,21,0)
	;;=^^4^4^2931216^^
	;;^DD(399,454,21,1,0)
	;;=Unlabled Form Locator 37B on the UB-92.  This field is nationally reserved
	;;^DD(399,454,21,2,0)
	;;=on adjustment/replacement type bills for the Internal Control
	;;^DD(399,454,21,3,0)
	;;=Number (ICN)/Document Control Number (DCN) assigned to the original bill
	;;^DD(399,454,21,4,0)
	;;=by the secondary payer (in 50B).
	;;^DD(399,454,"DT")
	;;=2931216
	;;^DD(399,455,0)
	;;=FORM LOCATOR 37C^F^^UF3;6^K:$L(X)>23!($L(X)<3) X
	;;^DD(399,455,3)
	;;=Answer must be 3-23 characters in length.
	;;^DD(399,455,21,0)
	;;=^^4^4^2931216^
	;;^DD(399,455,21,1,0)
	;;=Unlabled Form Locator 37C on the UB-92.  This field is nationally reserved
	;;^DD(399,455,21,2,0)
	;;=on adjustment/replacement type bills for the Internal Control
	;;^DD(399,455,21,3,0)
	;;=Number (ICN)/Document Control Number (DCN) assigned to the original bill
	;;^DD(399,455,21,4,0)
	;;=by the tertiary payer (in 50C).
	;;^DD(399,455,"DT")
	;;=2931216
	;;^DD(399,456,0)
	;;=FORM LOCATOR 56^F^^UF3;7^K:$L(X)>69!($L(X)<3) X
	;;^DD(399,456,3)
	;;=Answer must be 3-69 characters in length.
	;;^DD(399,456,21,0)
	;;=^^2^2^2931216^^
	;;^DD(399,456,21,1,0)
	;;=Printed in Form Locator 56 on the UB-92.  If more than 14 characters are
	;;^DD(399,456,21,2,0)
	;;=entered this will be printed on multiple lines.
	;;^DD(399,456,23,0)
	;;=^^4^4^2931216^
	;;^DD(399,456,23,1,0)
	;;=Unlabled Form Locator 56 on the UB-92.  On the form the block is five lines
	;;^DD(399,456,23,2,0)
	;;=of 13 and 14 characters.  Therefore, if the string is longer than 14
	;;^DD(399,456,23,3,0)
	;;=characters it must be split and printed on multiple lines.  The top line of
	;;^DD(399,456,23,4,0)
	;;=13 characters will be used last.
	;;^DD(399,456,"DT")
	;;=2931216
