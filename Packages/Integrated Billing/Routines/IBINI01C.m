IBINI01C	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.1,0,"GL")
	;;=^IBE(350.1,
	;;^DIC("B","IB ACTION TYPE",350.1)
	;;=
	;;^DIC(350.1,"%D",0)
	;;=^^5^5^2940214^
	;;^DIC(350.1,"%D",1,0)
	;;=This file contains the types of actions that a service can use with IB.
	;;^DIC(350.1,"%D",2,0)
	;;=Data in this file provides links from the application to IB to AR that
	;;^DIC(350.1,"%D",3,0)
	;;=are associated with the type rather than each entry.
	;;^DIC(350.1,"%D",4,0)
	;;= 
	;;^DIC(350.1,"%D",5,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.1,0)
	;;=FIELD^^.11^15
	;;^DD(350.1,0,"DT")
	;;=2930729
	;;^DD(350.1,0,"IX","ANEW",350.1,.04)
	;;=
	;;^DD(350.1,0,"IX","ANEW1",350.1,.05)
	;;=
	;;^DD(350.1,0,"IX","B",350.1,.01)
	;;=
	;;^DD(350.1,0,"IX","C",350.1,.04)
	;;=
	;;^DD(350.1,0,"IX","D",350.1,.02)
	;;=
	;;^DD(350.1,0,"IX","E",350.1,.08)
	;;=
	;;^DD(350.1,0,"NM","IB ACTION TYPE")
	;;=
	;;^DD(350.1,0,"PT",52,105)
	;;=
	;;^DD(350.1,0,"PT",350,.03)
	;;=
	;;^DD(350.1,0,"PT",350.1,.06)
	;;=
	;;^DD(350.1,0,"PT",350.1,.07)
	;;=
	;;^DD(350.1,0,"PT",350.1,.09)
	;;=
	;;^DD(350.1,0,"PT",350.2,.03)
	;;=
	;;^DD(350.1,0,"PT",350.4,.03)
	;;=
	;;^DD(350.1,0,"PT",350.41,.03)
	;;=
	;;^DD(350.1,0,"PT",350.41,.04)
	;;=
	;;^DD(350.1,0,"PT",399.1,.14)
	;;=
	;;^DD(350.1,0,"PT",399.1,.15)
	;;=
	;;^DD(350.1,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(350.1,.01,1,0)
	;;=^.1
	;;^DD(350.1,.01,1,1,0)
	;;=350.1^B
	;;^DD(350.1,.01,1,1,1)
	;;=S ^IBE(350.1,"B",$E(X,1,30),DA)=""
	;;^DD(350.1,.01,1,1,2)
	;;=K ^IBE(350.1,"B",$E(X,1,30),DA)
	;;^DD(350.1,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(350.1,.01,21,0)
	;;=3
	;;^DD(350.1,.01,21,1,0)
	;;=Enter the  unique name of this action type.  The name should begin
	;;^DD(350.1,.01,21,2,0)
	;;=with the namespace of the application that will use this action type and
	;;^DD(350.1,.01,21,3,0)
	;;=should describe the function being billed.
	;;^DD(350.1,.01,"DEL",1,0)
	;;=I 1 W !,"Deleting entries not allowed"
	;;^DD(350.1,.02,0)
	;;=ABBREVIATION^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>8!($L(X)<2) X
	;;^DD(350.1,.02,1,0)
	;;=^.1
	;;^DD(350.1,.02,1,1,0)
	;;=350.1^D
	;;^DD(350.1,.02,1,1,1)
	;;=S ^IBE(350.1,"D",$E(X,1,30),DA)=""
	;;^DD(350.1,.02,1,1,2)
	;;=K ^IBE(350.1,"D",$E(X,1,30),DA)
	;;^DD(350.1,.02,1,1,"DT")
	;;=2910830
	;;^DD(350.1,.02,3)
	;;=Answer must be 2-8 characters in length.
	;;^DD(350.1,.02,21,0)
	;;=^^1^1^2920224^^^^
	;;^DD(350.1,.02,21,1,0)
	;;=Enter a short description that can be output on space limited reports.
	;;^DD(350.1,.02,"DT")
	;;=2910830
	;;^DD(350.1,.03,0)
	;;=CHARGE CATEGORY^P430.2'^PRCA(430.2,^0;3^Q
	;;^DD(350.1,.03,21,0)
	;;=^^3^3^2910305^^
	;;^DD(350.1,.03,21,1,0)
	;;=This is the pointer to the ACCOUNT RECEIVABLE CATEGORY file.  This data
	;;^DD(350.1,.03,21,2,0)
	;;=will get passed to AR when an IB ACTION for this ACTION type gets passed
	;;^DD(350.1,.03,21,3,0)
	;;=to AR.
	;;^DD(350.1,.04,0)
	;;=SERVICE^P49'^DIC(49,^0;4^Q
	;;^DD(350.1,.04,1,0)
	;;=^.1
	;;^DD(350.1,.04,1,1,0)
	;;=350.1^C
	;;^DD(350.1,.04,1,1,1)
	;;=S ^IBE(350.1,"C",$E(X,1,30),DA)=""
	;;^DD(350.1,.04,1,1,2)
	;;=K ^IBE(350.1,"C",$E(X,1,30),DA)
	;;^DD(350.1,.04,1,2,0)
	;;=350.1^ANEW^MUMPS
	;;^DD(350.1,.04,1,2,1)
	;;=I $P(^IBE(350.1,DA,0),U,5) S ^IBE(350.1,"ANEW",X,$P(^(0),U,5),DA)=""
	;;^DD(350.1,.04,1,2,2)
	;;=I $P(^IBE(350.1,DA,0),U,5) K ^IBE(350.1,"ANEW",X,$P(^(0),U,5),DA)
	;;^DD(350.1,.04,21,0)
	;;=^^2^2^2910305^^
	;;^DD(350.1,.04,21,1,0)
	;;=Enter the name of the Service/Section that will be using this action
	;;^DD(350.1,.04,21,2,0)
	;;=type.  This is required by Accounts Receivable.
