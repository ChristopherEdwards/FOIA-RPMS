IBINI03X	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(354.2,.03,21,2,0)
	;;=exemption of Pharmacy Copay based on Income, only the type
	;;^DD(354.2,.03,21,3,0)
	;;=COPAY INCOME EXEMPTION reason can be selected.
	;;^DD(354.2,.03,21,4,0)
	;;= 
	;;^DD(354.2,.03,21,5,0)
	;;=In a future release additional types of exemptions may be created.
	;;^DD(354.2,.03,21,6,0)
	;;=Do not modify this field.
	;;^DD(354.2,.03,"DT")
	;;=2921208
	;;^DD(354.2,.04,0)
	;;=STATUS^S^0:NON-EXEMPT;1:EXEMPT;^0;4^Q
	;;^DD(354.2,.04,.1)
	;;=
	;;^DD(354.2,.04,1,0)
	;;=^.1
	;;^DD(354.2,.04,1,1,0)
	;;=354.2^AS
	;;^DD(354.2,.04,1,1,1)
	;;=S ^IBE(354.2,"AS",$E(X,1,30),DA)=""
	;;^DD(354.2,.04,1,1,2)
	;;=K ^IBE(354.2,"AS",$E(X,1,30),DA)
	;;^DD(354.2,.04,1,1,"%D",0)
	;;=^^1^1^2921110^
	;;^DD(354.2,.04,1,1,"%D",1,0)
	;;=Cross-reference of Status.
	;;^DD(354.2,.04,1,1,"DT")
	;;=2921110
	;;^DD(354.2,.04,3)
	;;=
	;;^DD(354.2,.04,21,0)
	;;=^^3^3^2930430^^^^
	;;^DD(354.2,.04,21,1,0)
	;;=This is the status of this type of record.  Whether it is an exempt
	;;^DD(354.2,.04,21,2,0)
	;;=or non-exempt reason.  This status will be automatically stored
	;;^DD(354.2,.04,21,3,0)
	;;=in the Billing Exemptions file.
	;;^DD(354.2,.04,"DT")
	;;=2921208
	;;^DD(354.2,.05,0)
	;;=CODE^NJ4,0I^^0;5^K:+X'=X!(X>9999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(354.2,.05,1,0)
	;;=^.1
	;;^DD(354.2,.05,1,1,0)
	;;=354.2^ACODE
	;;^DD(354.2,.05,1,1,1)
	;;=S ^IBE(354.2,"ACODE",$E(X,1,30),DA)=""
	;;^DD(354.2,.05,1,1,2)
	;;=K ^IBE(354.2,"ACODE",$E(X,1,30),DA)
	;;^DD(354.2,.05,1,1,3)
	;;=DO NOT DELETE
	;;^DD(354.2,.05,1,1,"%D",0)
	;;=^^3^3^2921110^
	;;^DD(354.2,.05,1,1,"%D",1,0)
	;;=Cross-reference of code field.  To be used in routines to look up correct
	;;^DD(354.2,.05,1,1,"%D",2,0)
	;;=entry.  The internal codes will be used in routines to locate the correct
	;;^DD(354.2,.05,1,1,"%D",3,0)
	;;=entry.
	;;^DD(354.2,.05,1,1,"DT")
	;;=2921110
	;;^DD(354.2,.05,1,2,0)
	;;=354.2^C
	;;^DD(354.2,.05,1,2,1)
	;;=S ^IBE(354.2,"C",$E(X,1,30),DA)=""
	;;^DD(354.2,.05,1,2,2)
	;;=K ^IBE(354.2,"C",$E(X,1,30),DA)
	;;^DD(354.2,.05,1,2,"DT")
	;;=2930105
	;;^DD(354.2,.05,3)
	;;=Type a Number between 1 and 9999, 0 Decimal Digits
	;;^DD(354.2,.05,9)
	;;=^
	;;^DD(354.2,.05,21,0)
	;;=^^2^2^2930430^^^^
	;;^DD(354.2,.05,21,1,0)
	;;=This is the internal code used to look up entries by the billing
	;;^DD(354.2,.05,21,2,0)
	;;=system.  This should not be altered except by the developing ISC.
	;;^DD(354.2,.05,23,0)
	;;=^^9^9^2930430^^^^
	;;^DD(354.2,.05,23,1,0)
	;;=The data in this field is returned as the third piece from the call to
	;;^DD(354.2,.05,23,2,0)
	;;=RXST^IBARXEU and RXEXMT^IBARXEU0.  Programmers can determine certain
	;;^DD(354.2,.05,23,3,0)
	;;=attributes from the code.  Codes of 2 digits are reserved for exemption
	;;^DD(354.2,.05,23,4,0)
	;;=reasons that can automatically be determined by the system but not
	;;^DD(354.2,.05,23,5,0)
	;;=based on income.  Codes of 3 digits are reserved for exemptions based
	;;^DD(354.2,.05,23,6,0)
	;;=on income.  Codes of 4 digits are reserved for exemptions that only
	;;^DD(354.2,.05,23,7,0)
	;;=can be manually entered that would generally over-ride all other
	;;^DD(354.2,.05,23,8,0)
	;;=determinations.
	;;^DD(354.2,.05,23,9,0)
	;;= 
	;;^DD(354.2,.05,"DT")
	;;=2930115
	;;^DD(354.2,.1,0)
	;;=ACTIVE^S^1:ACTIVE;0:INACTIVE;^10;1^Q
	;;^DD(354.2,.1,1,0)
	;;=^.1
	;;^DD(354.2,.1,1,1,0)
	;;=354.2^AA
	;;^DD(354.2,.1,1,1,1)
	;;=S ^IBE(354.2,"AA",$E(X,1,30),DA)=""
	;;^DD(354.2,.1,1,1,2)
	;;=K ^IBE(354.2,"AA",$E(X,1,30),DA)
	;;^DD(354.2,.1,1,1,"%D",0)
	;;=^^1^1^2921110^
	;;^DD(354.2,.1,1,1,"%D",1,0)
	;;=Cross-reference of Active records.
