IBDEI00R	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(358.5,0,"GL")
	;;=^IBE(358.5,
	;;^DIC("B","IMP/EXP DATA FIELD",358.5)
	;;=
	;;^DIC(358.5,"%D",0)
	;;=^^6^6^2940217^
	;;^DIC(358.5,"%D",1,0)
	;;= 
	;;^DIC(358.5,"%D",2,0)
	;;= 
	;;^DIC(358.5,"%D",3,0)
	;;= 
	;;^DIC(358.5,"%D",4,0)
	;;=This file is nearly identical to file #357.5. It is used by the
	;;^DIC(358.5,"%D",5,0)
	;;=Import/Export Utility as a temporary staging area for data from that file
	;;^DIC(358.5,"%D",6,0)
	;;=that is being imported or exported.
	;;^DD(358.5,0)
	;;=FIELD^^2^13
	;;^DD(358.5,0,"ID",.02)
	;;=W ""
	;;^DD(358.5,0,"ID",.03)
	;;=W ""
	;;^DD(358.5,0,"IX","B",358.5,.01)
	;;=
	;;^DD(358.5,0,"IX","C",358.5,.02)
	;;=
	;;^DD(358.5,0,"NM","IMP/EXP DATA FIELD")
	;;=
	;;^DD(358.5,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(358.5,.01,1,0)
	;;=^.1
	;;^DD(358.5,.01,1,1,0)
	;;=358.5^B
	;;^DD(358.5,.01,1,1,1)
	;;=S ^IBE(358.5,"B",$E(X,1,30),DA)=""
	;;^DD(358.5,.01,1,1,2)
	;;=K ^IBE(358.5,"B",$E(X,1,30),DA)
	;;^DD(358.5,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(358.5,.01,21,0)
	;;=^^3^3^2930419^^^
	;;^DD(358.5,.01,21,1,0)
	;;= 
	;;^DD(358.5,.01,21,2,0)
	;;=The name is used to identify the field within a block. It can be anything
	;;^DD(358.5,.01,21,3,0)
	;;=the designer of a form wants it to be.
	;;^DD(358.5,.01,"DT")
	;;=2930419
	;;^DD(358.5,.02,0)
	;;=BLOCK^RP358.1'^IBE(358.1,^0;2^Q
	;;^DD(358.5,.02,1,0)
	;;=^.1
	;;^DD(358.5,.02,1,1,0)
	;;=358.5^C
	;;^DD(358.5,.02,1,1,1)
	;;=S ^IBE(358.5,"C",$E(X,1,30),DA)=""
	;;^DD(358.5,.02,1,1,2)
	;;=K ^IBE(358.5,"C",$E(X,1,30),DA)
	;;^DD(358.5,.02,1,1,"DT")
	;;=2921118
	;;^DD(358.5,.02,3)
	;;=What block should this data field appear in?
	;;^DD(358.5,.02,21,0)
	;;=^^2^2^2930310^
	;;^DD(358.5,.02,21,1,0)
	;;= 
	;;^DD(358.5,.02,21,2,0)
	;;=The particular block the data field should appear in.
	;;^DD(358.5,.02,"DT")
	;;=2921118
	;;^DD(358.5,.03,0)
	;;=TYPE OF DATA^*P358.6'^IBE(358.6,^0;3^S DIC("S")="I $P(^(0),U,6)=2,$P(^(0),U,9)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(358.5,.03,3)
	;;=What data should be displayed in this field?
	;;^DD(358.5,.03,12)
	;;=Allows only available output routines
	;;^DD(358.5,.03,12.1)
	;;=S DIC("S")="I $P(^(0),U,6)=2,$P(^(0),U,9)=1"
	;;^DD(358.5,.03,21,0)
	;;=^^5^5^2930409^^
	;;^DD(358.5,.03,21,1,0)
	;;= 
	;;^DD(358.5,.03,21,2,0)
	;;=The particular interface that should be invoked to obtain the data for
	;;^DD(358.5,.03,21,3,0)
	;;=display. Some of the interfaces don't actually return data, but are
	;;^DD(358.5,.03,21,4,0)
	;;=instead 'dummy' interfaces for the purpose of printing things like blank
	;;^DD(358.5,.03,"DT")
	;;=2930309
	;;^DD(358.5,.04,0)
	;;=LAST ITEM INDICATOR^S^1:YES;0:NO;^0;4^Q
	;;^DD(358.5,.04,.1)
	;;=IS THIS THE LAST ONE THAT WILL FIT ON THE FORM?
	;;^DD(358.5,.04,3)
	;;=
	;;^DD(358.5,.04,4)
	;;=W "Enter YES if this is the last item that should print, else enter NO."
	;;^DD(358.5,.04,21,0)
	;;=^^4^4^2930408^^^^
	;;^DD(358.5,.04,21,1,0)
	;;= 
	;;^DD(358.5,.04,21,2,0)
	;;=This field is used to indicate which item on a list is the last to be
	;;^DD(358.5,.04,21,3,0)
	;;=printed to the form. The remaining items can be printed to a separate
	;;^DD(358.5,.04,21,4,0)
	;;=piece of paper.
	;;^DD(358.5,.04,"DT")
	;;=2930413
	;;^DD(358.5,.05,0)
	;;=NUMBER ON LIST^NJ3,0^^0;5^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(358.5,.05,.1)
	;;=WHICH ITEM ON THE LIST SHOULD BE DISPLAYED IN THIS FIELD?
	;;^DD(358.5,.05,3)
	;;=The data is a list of items. Which item on the list should be displayed?
	;;^DD(358.5,.05,21,0)
	;;=^^1^1^2930607^
	;;^DD(358.5,.05,21,1,0)
	;;=For data returned by the package interface that is in the form of a list, this field indicates which one of the items on the list should be displayed to this field.
