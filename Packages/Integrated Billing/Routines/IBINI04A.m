IBINI04A	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.6,1,23,3,0)
	;;=will not print properly.
	;;^DD(354.6,1,"DT")
	;;=2930428
	;;^DD(354.6,2,0)
	;;=HEADER^354.62^^2;0
	;;^DD(354.6,2,21,0)
	;;=^^3^3^2940213^^
	;;^DD(354.6,2,21,1,0)
	;;=The first six lines in this field will be centered at the top of plain
	;;^DD(354.6,2,21,2,0)
	;;=paper to form the header of the letter.  The data in this field should
	;;^DD(354.6,2,21,3,0)
	;;=be edited to the correct station name and address of your facility.
	;;^DD(354.6,2,23,0)
	;;=^^3^3^2940213^^
	;;^DD(354.6,2,23,1,0)
	;;=The data in this field will be printed as it is entered.  VA FileMan
	;;^DD(354.6,2,23,2,0)
	;;=utilities are not used to format the data, hence, any imbedded functions
	;;^DD(354.6,2,23,3,0)
	;;=will not print properly.
	;;^DD(354.61,0)
	;;=MAIN BODY SUB-FIELD^^.01^1
	;;^DD(354.61,0,"DT")
	;;=2930428
	;;^DD(354.61,0,"NM","MAIN BODY")
	;;=
	;;^DD(354.61,0,"UP")
	;;=354.6
	;;^DD(354.61,.01,0)
	;;=MAIN BODY^W^^0;1^Q
	;;^DD(354.61,.01,21,0)
	;;=^^2^2^2930504^^^
	;;^DD(354.61,.01,21,1,0)
	;;=This field contains the main body of the letter that will be printed
	;;^DD(354.61,.01,21,2,0)
	;;=after the salutation and includes the signature line.  
	;;^DD(354.61,.01,23,0)
	;;=^^3^3^2930504^^
	;;^DD(354.61,.01,23,1,0)
	;;=The data in this field will be printed as it is entered.  VA FileMan
	;;^DD(354.61,.01,23,2,0)
	;;=utilities are not used to format the data, hence, any imbedded functions
	;;^DD(354.61,.01,23,3,0)
	;;=will not print properly.
	;;^DD(354.61,.01,"DT")
	;;=2930428
	;;^DD(354.62,0)
	;;=HEADER SUB-FIELD^^.01^1
	;;^DD(354.62,0,"DT")
	;;=2930428
	;;^DD(354.62,0,"NM","HEADER")
	;;=
	;;^DD(354.62,0,"UP")
	;;=354.6
	;;^DD(354.62,.01,0)
	;;=HEADER^W^^0;1^Q
	;;^DD(354.62,.01,21,0)
	;;=^^3^3^2940213^^
	;;^DD(354.62,.01,21,1,0)
	;;=The first six lines in this field will be centered at the top of plain
	;;^DD(354.62,.01,21,2,0)
	;;=paper to form the header of the letter.  The data in this field should
	;;^DD(354.62,.01,21,3,0)
	;;=be edited to the correct station name and address of your facility.
	;;^DD(354.62,.01,23,0)
	;;=^^3^3^2940213^^^
	;;^DD(354.62,.01,23,1,0)
	;;=The data in this field will be printed as it is entered.  VA FileMan
	;;^DD(354.62,.01,23,2,0)
	;;=utilities are not used to format the data, hence, any imbedded functions
	;;^DD(354.62,.01,23,3,0)
	;;=will not print properly.
	;;^DD(354.62,.01,"DT")
	;;=2930428
