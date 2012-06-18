IBINI03F	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(353)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(353,0,"GL")
	;;=^IBE(353,
	;;^DIC("B","BILL FORM TYPE",353)
	;;=
	;;^DIC(353,"%D",0)
	;;=^^13^13^2940214^^^^
	;;^DIC(353,"%D",1,0)
	;;=This is a reference file containing the types of health insurance
	;;^DIC(353,"%D",2,0)
	;;=claim forms used in billing.
	;;^DIC(353,"%D",3,0)
	;;= 
	;;^DIC(353,"%D",4,0)
	;;=Sites may add local forms to this file however, the number of entries
	;;^DIC(353,"%D",5,0)
	;;=for locally added forms should be in the stations number range of
	;;^DIC(353,"%D",6,0)
	;;=Station number time 1000.  
	;;^DIC(353,"%D",7,0)
	;;= 
	;;^DIC(353,"%D",8,0)
	;;=If other than UB-82 forms are pointed to by the BILL/CLAIMS file, then
	;;^DIC(353,"%D",9,0)
	;;=the follow-up letter job will create a separate tasked job for each
	;;^DIC(353,"%D",10,0)
	;;=bill to the Follow-up Printer for that form using the specified routine
	;;^DIC(353,"%D",11,0)
	;;=for that form.
	;;^DIC(353,"%D",12,0)
	;;= 
	;;^DIC(353,"%D",13,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(353,0)
	;;=FIELD^^.001^5
	;;^DD(353,0,"DDA")
	;;=N
	;;^DD(353,0,"DT")
	;;=2940112
	;;^DD(353,0,"IX","B",353,.01)
	;;=
	;;^DD(353,0,"NM","BILL FORM TYPE")
	;;=
	;;^DD(353,0,"PT",36,.14)
	;;=
	;;^DD(353,0,"PT",350.9,1.26)
	;;=
	;;^DD(353,0,"PT",399,.19)
	;;=
	;;^DD(353,.001,0)
	;;=NUMBER^NJ7,0^^ ^K:+X'=X!(X>9999999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(353,.001,3)
	;;=Type a Number between 1 and 9999999, 0 Decimal Digits
	;;^DD(353,.001,21,0)
	;;=^^2^2^2920427^^
	;;^DD(353,.001,21,1,0)
	;;=Enter a number that is within the number range for your facility,
	;;^DD(353,.001,21,2,0)
	;;=that is xxx000 to xxx999 where xxx is your station number.
	;;^DD(353,.001,"DT")
	;;=2920427
	;;^DD(353,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>20!($L(X)<3)!'(X'?1P.E) X
	;;^DD(353,.01,1,0)
	;;=^.1
	;;^DD(353,.01,1,1,0)
	;;=353^B
	;;^DD(353,.01,1,1,1)
	;;=S ^IBE(353,"B",$E(X,1,30),DA)=""
	;;^DD(353,.01,1,1,2)
	;;=K ^IBE(353,"B",$E(X,1,30),DA)
	;;^DD(353,.01,3)
	;;=Answer must be 3-20 characters in length.
	;;^DD(353,.01,21,0)
	;;=^^1^1^2920427^^^
	;;^DD(353,.01,21,1,0)
	;;=This field names a type of form that is available for billing purposes.
	;;^DD(353,.01,"DEL",1,0)
	;;=I DA<999 W !,"Deleting Standard entries not allowed"
	;;^DD(353,.01,"DT")
	;;=2920410
	;;^DD(353,.02,0)
	;;=DEFAULT PRINTER (BILLING)^FX^^0;2^S IBL=X,X=$P(X,";"),DIC=3.5,DIC(0)="EQ" D ^DIC K:Y'>0!(X=" ") X S:$D(X) X=X_$S(IBL[";":";"_$P(IBL,";",2,99),1:"") K IBL S DIC=DIE
	;;^DD(353,.02,3)
	;;=Enter the device that is the default billing printer for this form.
	;;^DD(353,.02,4)
	;;=S DIC=3.5,DIC(0)="E",X="?" D ^DIC S DIC=DIE
	;;^DD(353,.02,21,0)
	;;=^^2^2^2940112^^
	;;^DD(353,.02,21,1,0)
	;;=This is the default printer that will appear at selected prompts for
	;;^DD(353,.02,21,2,0)
	;;=this form type.
	;;^DD(353,.02,"DT")
	;;=2920427
	;;^DD(353,.03,0)
	;;=FOLLOW-UP PRINTER (A/R)^FX^^0;3^S IBL=X,X=$P(X,";"),DIC=3.5,DIC(0)="EQ" D ^DIC K:Y'>0!(X=" ") X S:$D(X) X=X_$S(IBL[";":";"_$P(IBL,";",2,99),1:"") K IBL S DIC=DIE
	;;^DD(353,.03,3)
	;;=Enter the device that is the default printer for follow-up bills for this form type.
	;;^DD(353,.03,4)
	;;=S DIC=3.5,DIC(0)="E",X="?" D ^DIC S DIC=DIE
	;;^DD(353,.03,21,0)
	;;=^^2^2^2940213^^^^
	;;^DD(353,.03,21,1,0)
	;;=For forms other than the UB-82/UB-92, this is the default printer that has this
	;;^DD(353,.03,21,2,0)
	;;=form mounted for follow-up letter/forms for Accounts Receivable.
	;;^DD(353,.03,"DT")
	;;=2920427
	;;^DD(353,1.01,0)
	;;=ROUTINE^FX^^1;E1,245^K:$L(X)>25!($L(X)<1)!(X'?.1ANP.7AN.1"^"1ANP.7AN) X
