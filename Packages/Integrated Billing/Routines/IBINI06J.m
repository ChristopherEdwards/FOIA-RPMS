IBINI06J	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356.4,0,"GL")
	;;=^IBE(356.4,
	;;^DIC("B","CLAIMS TRACKING NON-ACUTE CLASSIFICATIONS",356.4)
	;;=
	;;^DIC(356.4,"%D",0)
	;;=^^7^7^2940214^^^
	;;^DIC(356.4,"%D",1,0)
	;;=This file contains the list of approved non-acute classifications provided
	;;^DIC(356.4,"%D",2,0)
	;;=by the UM office in VACO.  The codes are used in roll up of national data
	;;^DIC(356.4,"%D",3,0)
	;;= 
	;;^DIC(356.4,"%D",4,0)
	;;=Do NOT add, edit, or delete entries in this file without instructions
	;;^DIC(356.4,"%D",5,0)
	;;=from your ISC.
	;;^DIC(356.4,"%D",6,0)
	;;= 
	;;^DIC(356.4,"%D",7,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356.4,0)
	;;=FIELD^^10^5
	;;^DD(356.4,0,"DT")
	;;=2931029
	;;^DD(356.4,0,"ID",.02)
	;;=W "   ",$P(^(0),U,2)
	;;^DD(356.4,0,"ID",.04)
	;;=W "   ",@("$P($P($C(59)_$S($D(^DD(356.4,.04,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,4)_"":"",2),$C(59),1)")
	;;^DD(356.4,0,"IX","B",356.4,.01)
	;;=
	;;^DD(356.4,0,"IX","C",356.4,.02)
	;;=
	;;^DD(356.4,0,"IX","D",356.4,.04)
	;;=
	;;^DD(356.4,0,"NM","CLAIMS TRACKING NON-ACUTE CLASSIFICATIONS")
	;;=
	;;^DD(356.4,0,"PT",356.112,.01)
	;;=
	;;^DD(356.4,0,"PT",356.113,.01)
	;;=
	;;^DD(356.4,.01,0)
	;;=SHORT NAME^RF^^0;1^K:$L(X)>80!($L(X)<3) X
	;;^DD(356.4,.01,1,0)
	;;=^.1
	;;^DD(356.4,.01,1,1,0)
	;;=356.4^B
	;;^DD(356.4,.01,1,1,1)
	;;=S ^IBE(356.4,"B",$E(X,1,30),DA)=""
	;;^DD(356.4,.01,1,1,2)
	;;=K ^IBE(356.4,"B",$E(X,1,30),DA)
	;;^DD(356.4,.01,3)
	;;=Answer must be 3-80 characters in length.
	;;^DD(356.4,.01,21,0)
	;;=^^2^2^2930715^^^
	;;^DD(356.4,.01,21,1,0)
	;;=This is the first 30-60 characters of the description of the non-acute
	;;^DD(356.4,.01,21,2,0)
	;;=classification.
	;;^DD(356.4,.01,"DT")
	;;=2940201
	;;^DD(356.4,.02,0)
	;;=CODE^RFI^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>5!($L(X)<4)!'(X?1.2N1"."2N) X
	;;^DD(356.4,.02,1,0)
	;;=^.1
	;;^DD(356.4,.02,1,1,0)
	;;=356.4^C
	;;^DD(356.4,.02,1,1,1)
	;;=S ^IBE(356.4,"C",$E(X,1,30),DA)=""
	;;^DD(356.4,.02,1,1,2)
	;;=K ^IBE(356.4,"C",$E(X,1,30),DA)
	;;^DD(356.4,.02,1,1,"DT")
	;;=2930715
	;;^DD(356.4,.02,3)
	;;=Enter the unique code for this factor in the format of nn.nn or n.nn where n is any number.
	;;^DD(356.4,.02,21,0)
	;;=^^3^3^2940213^^^^
	;;^DD(356.4,.02,21,1,0)
	;;=This is the external reference number by which this data is
	;;^DD(356.4,.02,21,2,0)
	;;=uniquely known.  This is the value that will be transmitted 
	;;^DD(356.4,.02,21,3,0)
	;;=in the national roll up.
	;;^DD(356.4,.02,"DT")
	;;=2931014
	;;^DD(356.4,.04,0)
	;;=FACTOR^SI^1:SOCIAL FACTORS;2:ENVIRONMENTAL FACTORS;3:SCHEDULING;4:BED/SERVICE AVAILIBILITY;5:PRACTITIONER FACTOR;6:ADMINISTRATIVE;7:COMMUNICATION PROBLEMS;8:OTHER;^0;4^Q
	;;^DD(356.4,.04,1,0)
	;;=^.1
	;;^DD(356.4,.04,1,1,0)
	;;=356.4^D
	;;^DD(356.4,.04,1,1,1)
	;;=S ^IBE(356.4,"D",$E(X,1,30),DA)=""
	;;^DD(356.4,.04,1,1,2)
	;;=K ^IBE(356.4,"D",$E(X,1,30),DA)
	;;^DD(356.4,.04,1,1,"DT")
	;;=2930715
	;;^DD(356.4,.04,21,0)
	;;=^^1^1^2931029^^
	;;^DD(356.4,.04,21,1,0)
	;;=Enter the name of the factor that best describes this classification.
	;;^DD(356.4,.04,"DT")
	;;=2931220
	;;^DD(356.4,.05,0)
	;;=DAY OR ADMISSION^SI^1:ADMISSION (NON-ACUTE);2:DAY(S) OF CARE (NON ACUTE);^0;5^Q
	;;^DD(356.4,.05,21,0)
	;;=^^2^2^2930715^
	;;^DD(356.4,.05,21,1,0)
	;;=Enter whether this classification for not meeting criteria is for
	;;^DD(356.4,.05,21,2,0)
	;;=admissions or days of care.
	;;^DD(356.4,.05,"DT")
	;;=2931220
	;;^DD(356.4,10,0)
	;;=REASON^356.41^^1;0
	;;^DD(356.4,10,21,0)
	;;=^^1^1^2940213^
	;;^DD(356.4,10,21,1,0)
	;;=This is the long description of the non-acute classification.
