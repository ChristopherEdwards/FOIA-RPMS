IBDEI01F	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(358.6,.08,21,0)
	;;=^^4^4^2930527^
	;;^DD(358.6,.08,21,1,0)
	;;= 
	;;^DD(358.6,.08,21,2,0)
	;;=This field is used to determine what should happen if the data does not
	;;^DD(358.6,.08,21,3,0)
	;;=fit in the space allocated to it on the form. If answered YES the data
	;;^DD(358.6,.08,21,4,0)
	;;=will be printed on another page.
	;;^DD(358.6,.08,"DT")
	;;=2930507
	;;^DD(358.6,.09,0)
	;;=AVAILABLE? (Y/N)^RS^0:NO;1:YES;^0;9^Q
	;;^DD(358.6,.09,3)
	;;=Is this package interface now available for use?
	;;^DD(358.6,.09,21,0)
	;;=^^3^3^2930527^
	;;^DD(358.6,.09,21,1,0)
	;;= 
	;;^DD(358.6,.09,21,2,0)
	;;=This field should be set to YES if the interface is available, NO if it is
	;;^DD(358.6,.09,21,3,0)
	;;=not available. Interfaces that are not available are not called.
	;;^DD(358.6,.09,"DT")
	;;=2921213
	;;^DD(358.6,.1,0)
	;;=HEALTH SUMMARY?^S^0:NO;1:YES;^0;10^Q
	;;^DD(358.6,.1,.1)
	;;=ARE YOU REQUESTING A HEALTH SUMMARY?
	;;^DD(358.6,.1,2.1)
	;;=S:Y=+Y Y=Y+1
	;;^DD(358.6,.1,3)
	;;= Are you requesting a HEALTH SUMMARY to print?
	;;^DD(358.6,.1,21,0)
	;;=^^7^7^2930616^
	;;^DD(358.6,.1,21,1,0)
	;;= 
	;;^DD(358.6,.1,21,2,0)
	;;=This field will determine how to go about printing the report or form. It
	;;^DD(358.6,.1,21,3,0)
	;;=applies only to Package Interfaces of ACTION TYPE = PRINT REPORT. Health
	;;^DD(358.6,.1,21,4,0)
	;;=Summaries use the field HEALTH SUMMARY to determine the type of Health
	;;^DD(358.6,.1,21,6,0)
	;;=fields ENTRY POINT or ROUTINE, since all Health Summaries are printed in
	;;^DD(358.6,.1,21,7,0)
	;;=the same way.
	;;^DD(358.6,.1,"DT")
	;;=2930616
	;;^DD(358.6,.11,0)
	;;=TYPE OF HEALTH SUMMARY^*P142'^GMT(142,^0;11^S DIC("S")="I $P(^(0),U)'=""GMTS HS ADHOC OPTION""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(358.6,.11,3)
	;;=Which Health Summary do you want printed?
	;;^DD(358.6,.11,12)
	;;=EXCLUDES AD HOC HEALTH SUMMARIES
	;;^DD(358.6,.11,12.1)
	;;=S DIC("S")="I $P(^(0),U)'=""GMTS HS ADHOC OPTION"""
	;;^DD(358.6,.11,"DT")
	;;=2930617
	;;^DD(358.6,.12,0)
	;;=TOOL KIT MEMBER?^S^0:NO;1:YES;^0;12^Q
	;;^DD(358.6,.12,.1)
	;;=SHOULD THIS PACKAGE INTERFACE BE PART OF THE TOOL KIT?
	;;^DD(358.6,.12,3)
	;;=Enter YES if this PACKAGE INTERFACE was added by the package developers as part of the tool kit, enter NO otherwise.
	;;^DD(358.6,.12,"DT")
	;;=2930811
	;;^DD(358.6,1,0)
	;;=DESCRIPTION^358.61^^1;0
	;;^DD(358.6,1,21,0)
	;;=^^1^1^2930210^^^
	;;^DD(358.6,1,21,1,0)
	;;=Should describe the data being exchanged by the package interface.
	;;^DD(358.6,2.01,0)
	;;=PIECE 1 DESCRIPTIVE NAME^F^^2;1^K:$L(X)>30!($L(X)<3) X
	;;^DD(358.6,2.01,.1)
	;;=WHAT IS THE FIRST PIECE OF DATA RETURNED BY THE INTERFACE?
	;;^DD(358.6,2.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(358.6,2.01,21,0)
	;;=^^3^3^2930527^
	;;^DD(358.6,2.01,21,1,0)
	;;= 
	;;^DD(358.6,2.01,21,2,0)
	;;=Should be a descriptive name of the first field in the record returned by
	;;^DD(358.6,2.01,21,3,0)
	;;=the interface.
	;;^DD(358.6,2.01,"DT")
	;;=2930726
	;;^DD(358.6,2.02,0)
	;;=PIECE 1 MAXIMUM LENGTH^NJ3,0^^2;2^K:+X'=X!(X>210)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(358.6,2.02,.1)
	;;=WHAT IS ITS MAXIMUM LENGTH?
	;;^DD(358.6,2.02,3)
	;;=Type a Number between 0 and 210, 0 Decimal Digits
	;;^DD(358.6,2.02,21,0)
	;;=^^3^3^2930527^
	;;^DD(358.6,2.02,21,1,0)
	;;= 
	;;^DD(358.6,2.02,21,2,0)
	;;=The maximum length of the first field of the record returned by the
	;;^DD(358.6,2.02,21,3,0)
	;;=interface.
	;;^DD(358.6,2.02,"DT")
	;;=2930726
	;;^DD(358.6,2.03,0)
	;;=PIECE 2 DESCRIPTIVE NAME^F^^2;3^K:$L(X)>30!($L(X)<3) X
	;;^DD(358.6,2.03,.1)
	;;=WHAT IS THE SECOND PIECE OF DATA RETURNED BY THE INTERFACE?
