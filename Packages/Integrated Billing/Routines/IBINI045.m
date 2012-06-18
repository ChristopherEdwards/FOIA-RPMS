IBINI045	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(354.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(354.5,0,"GL")
	;;=^IBE(354.5,
	;;^DIC("B","BILLING ALERT DEFINITION",354.5)
	;;=
	;;^DIC(354.5,"%D",0)
	;;=^^9^9^2940214^^^^
	;;^DIC(354.5,"%D",1,0)
	;;=This file contains data used to generate alerts.  This information 
	;;^DIC(354.5,"%D",2,0)
	;;=is used to determine recipients and the contents of the alerts.
	;;^DIC(354.5,"%D",3,0)
	;;=Sites should not normally need to delete or edit these entries.
	;;^DIC(354.5,"%D",4,0)
	;;=Specific users and mailgroups can be assigned to receive each alert message.
	;;^DIC(354.5,"%D",5,0)
	;;= 
	;;^DIC(354.5,"%D",6,0)
	;;=Do not add, edit, or delete entries in this file without instructions
	;;^DIC(354.5,"%D",7,0)
	;;=from your ISC.
	;;^DIC(354.5,"%D",8,0)
	;;= 
	;;^DIC(354.5,"%D",9,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(354.5,0)
	;;=FIELD^^200^10
	;;^DD(354.5,0,"DDA")
	;;=N
	;;^DD(354.5,0,"DT")
	;;=2930204
	;;^DD(354.5,0,"IX","B",354.5,.01)
	;;=
	;;^DD(354.5,0,"NM","BILLING ALERT DEFINITION")
	;;=
	;;^DD(354.5,0,"PT",350.8,.06)
	;;=
	;;^DD(354.5,0,"PT",354.4,.01)
	;;=
	;;^DD(354.5,.001,0)
	;;=NUMBER^NJ5,0^^ ^K:+X'=X!(X>99999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(354.5,.001,3)
	;;=Type a Number between 1 and 99999, 0 Decimal Digits
	;;^DD(354.5,.001,21,0)
	;;=^^5^5^2930430^^^
	;;^DD(354.5,.001,21,1,0)
	;;=This is the internal entry number assigned to this billing alert
	;;^DD(354.5,.001,21,2,0)
	;;=type.  Entries 1 through 999 are reserved for IB.
	;;^DD(354.5,.001,21,3,0)
	;;= 
	;;^DD(354.5,.001,21,4,0)
	;;=The internal number is used by the ib routines to find entries in this
	;;^DD(354.5,.001,21,5,0)
	;;=file.  Do not delete, edit, or add entries to this file.
	;;^DD(354.5,.001,"DT")
	;;=2930204
	;;^DD(354.5,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(354.5,.01,1,0)
	;;=^.1
	;;^DD(354.5,.01,1,1,0)
	;;=354.5^B
	;;^DD(354.5,.01,1,1,1)
	;;=S ^IBE(354.5,"B",$E(X,1,30),DA)=""
	;;^DD(354.5,.01,1,1,2)
	;;=K ^IBE(354.5,"B",$E(X,1,30),DA)
	;;^DD(354.5,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(354.5,.01,21,0)
	;;=^^2^2^2930210^
	;;^DD(354.5,.01,21,1,0)
	;;=This is the name of this alert.  It should be close in name or meaning
	;;^DD(354.5,.01,21,2,0)
	;;=to the message text which the users are familiar with seeing.
	;;^DD(354.5,.02,0)
	;;=PACKAGE ID^F^^0;2^K:$L(X)>5!($L(X)<2) X
	;;^DD(354.5,.02,3)
	;;=Answer must be 2-5 characters in length.
	;;^DD(354.5,.02,21,0)
	;;=^^3^3^2930210^^
	;;^DD(354.5,.02,21,1,0)
	;;=This is the package prefix for the package using this notification.
	;;^DD(354.5,.02,21,2,0)
	;;=It will be concatenated with the internal number in the BILLING ALERTS file
	;;^DD(354.5,.02,21,3,0)
	;;=to form the variable XQAID for look up and deleting alerts.
	;;^DD(354.5,.02,23,0)
	;;=^^2^2^2930210^^
	;;^DD(354.5,.02,23,1,0)
	;;=This is used to build the XQAID variable when passed to the alerts
	;;^DD(354.5,.02,23,2,0)
	;;=API.
	;;^DD(354.5,.02,"DT")
	;;=2930204
	;;^DD(354.5,.03,0)
	;;=MESSAGE TEXT^F^^0;3^K:$L(X)>51!($L(X)<3) X
	;;^DD(354.5,.03,3)
	;;=Answer must be 3-51 characters in length.
	;;^DD(354.5,.03,21,0)
	;;=^^3^3^2930430^^^
	;;^DD(354.5,.03,21,1,0)
	;;=This is the message text that will be appended to the patient's name and
	;;^DD(354.5,.03,21,2,0)
	;;=ssn and will be displayed to users when first notified about
	;;^DD(354.5,.03,21,3,0)
	;;=the alert.
	;;^DD(354.5,.03,"DT")
	;;=2930204
	;;^DD(354.5,.05,0)
	;;=ACTION FLAG^S^I:INFORMATION ONLY;R:RUN ROUTINE;^0;5^Q
	;;^DD(354.5,.05,21,0)
	;;=^^7^7^2930430^^^
	;;^DD(354.5,.05,21,1,0)
	;;=Enter 'I' if the user is to take no follow-up action for this
