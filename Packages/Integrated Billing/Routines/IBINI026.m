IBINI026	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.8)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.8,0,"GL")
	;;=^IBE(350.8,
	;;^DIC("B","IB ERROR",350.8)
	;;=
	;;^DIC(350.8,"%D",0)
	;;=^^11^11^2940214^^^^
	;;^DIC(350.8,"%D",1,0)
	;;=This file contains errors for billing functions.  It may be used by
	;;^DIC(350.8,"%D",2,0)
	;;=applications, IB or AR.  The normal format for a routine to return
	;;^DIC(350.8,"%D",3,0)
	;;=an error is to return the variable:
	;;^DIC(350.8,"%D",4,0)
	;;=  Y=1^... a successful event occured
	;;^DIC(350.8,"%D",5,0)
	;;=  Y=-1^error code[;error code;error code...]^additional text
	;;^DIC(350.8,"%D",6,0)
	;;=The error messages can be displayed by calling routine ^IBAERR.  If
	;;^DIC(350.8,"%D",7,0)
	;;=the error occurs in a tasked job ($D(ZTQUEUED)'=0) the routine will
	;;^DIC(350.8,"%D",8,0)
	;;=put the error message in a bulletin and post it to the group defined
	;;^DIC(350.8,"%D",9,0)
	;;=in the IB SITE PARAMETER FILE.
	;;^DIC(350.8,"%D",10,0)
	;;= 
	;;^DIC(350.8,"%D",11,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.8,0)
	;;=FIELD^^10^7
	;;^DD(350.8,0,"DDA")
	;;=N
	;;^DD(350.8,0,"DT")
	;;=2930322
	;;^DD(350.8,0,"ID",.03)
	;;=W "   ",$P(^(0),U,3)
	;;^DD(350.8,0,"IX","AC",350.8,.03)
	;;=
	;;^DD(350.8,0,"IX","B",350.8,.01)
	;;=
	;;^DD(350.8,0,"IX","C",350.8,.03)
	;;=
	;;^DD(350.8,0,"NM","IB ERROR")
	;;=
	;;^DD(350.8,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(350.8,.01,1,0)
	;;=^.1
	;;^DD(350.8,.01,1,1,0)
	;;=350.8^B
	;;^DD(350.8,.01,1,1,1)
	;;=S ^IBE(350.8,"B",$E(X,1,30),DA)=""
	;;^DD(350.8,.01,1,1,2)
	;;=K ^IBE(350.8,"B",$E(X,1,30),DA)
	;;^DD(350.8,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(350.8,.01,21,0)
	;;=^^2^2^2910305^^
	;;^DD(350.8,.01,21,1,0)
	;;=This is a free text name of the entry.  It should be namespaced with
	;;^DD(350.8,.01,21,2,0)
	;;=the namespace of the package reporting the error.
	;;^DD(350.8,.02,0)
	;;=ERROR MESSAGE^F^^0;2^K:$L(X)>80!($L(X)<3) X
	;;^DD(350.8,.02,3)
	;;=Answer must be 3-80 characters in length.
	;;^DD(350.8,.02,21,0)
	;;=^^3^3^2940209^^^^
	;;^DD(350.8,.02,21,1,0)
	;;=This is the text of the message as it will be displayed to a user or
	;;^DD(350.8,.02,21,2,0)
	;;=posted in a bulletin.  It should be as meaningful as possible to the
	;;^DD(350.8,.02,21,3,0)
	;;=person seeing the message.
	;;^DD(350.8,.03,0)
	;;=ERROR CODE^F^^0;3^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>9!($L(X)<1) X
	;;^DD(350.8,.03,1,0)
	;;=^.1
	;;^DD(350.8,.03,1,1,0)
	;;=350.8^AC
	;;^DD(350.8,.03,1,1,1)
	;;=S ^IBE(350.8,"AC",$E(X,1,30),DA)=""
	;;^DD(350.8,.03,1,1,2)
	;;=K ^IBE(350.8,"AC",$E(X,1,30),DA)
	;;^DD(350.8,.03,1,2,0)
	;;=350.8^C
	;;^DD(350.8,.03,1,2,1)
	;;=S ^IBE(350.8,"C",$E(X,1,30),DA)=""
	;;^DD(350.8,.03,1,2,2)
	;;=K ^IBE(350.8,"C",$E(X,1,30),DA)
	;;^DD(350.8,.03,3)
	;;=Answer must be 1-9 characters in length.
	;;^DD(350.8,.03,21,0)
	;;=^^9^9^2920219^^^^
	;;^DD(350.8,.03,21,1,0)
	;;=This is the error code that will be passed to or determined by
	;;^DD(350.8,.03,21,2,0)
	;;=Integrated Billing.  The format for the Error Code should be
	;;^DD(350.8,.03,21,3,0)
	;;=nnxxx, where nn is the reporting package namespace and xxx are numeric
	;;^DD(350.8,.03,21,4,0)
	;;=values.
	;;^DD(350.8,.03,21,5,0)
	;;= 
	;;^DD(350.8,.03,21,6,0)
	;;=This is the error code that will be passed as the second piece of
	;;^DD(350.8,.03,21,7,0)
	;;=the variable Y to IB when +Y=-1.  More than one error code can be
	;;^DD(350.8,.03,21,8,0)
	;;=placed in the second ^ piece of Y delimited by semi-colons.  Applications
	;;^DD(350.8,.03,21,9,0)
	;;=may call ^IBAERR to display the error message(s).
