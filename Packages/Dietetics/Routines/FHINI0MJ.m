FHINI0MJ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(119.5,0,"GL")
	;;=^FH(119.5,
	;;^DIC("B","DIETETIC CONSULTS",119.5)
	;;=
	;;^DIC(119.5,"%D",0)
	;;=^^3^3^2871124^
	;;^DIC(119.5,"%D",1,0)
	;;=This file contains the list of types of dietetic consultations
	;;^DIC(119.5,"%D",2,0)
	;;=performed as well as 'time-units' necessary to complete such
	;;^DIC(119.5,"%D",3,0)
	;;=consultations for workload purposes.
	;;^DD(119.5,0)
	;;=FIELD^^99^7
	;;^DD(119.5,0,"ID",99)
	;;=W:$D(^("I")) "   (** INACTIVE **)"
	;;^DD(119.5,0,"IX","AC",119.5,99)
	;;=
	;;^DD(119.5,0,"IX","B",119.5,.01)
	;;=
	;;^DD(119.5,0,"NM","DIETETIC CONSULTS")
	;;=
	;;^DD(119.5,0,"PT",115.03,1)
	;;=
	;;^DD(119.5,0,"SCR")
	;;=I '$D(^FH(119.5,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(119.5,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>50!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(119.5,.01,1,0)
	;;=^.1
	;;^DD(119.5,.01,1,1,0)
	;;=119.5^B
	;;^DD(119.5,.01,1,1,1)
	;;=S ^FH(119.5,"B",$E(X,1,30),DA)=""
	;;^DD(119.5,.01,1,1,2)
	;;=K ^FH(119.5,"B",$E(X,1,30),DA)
	;;^DD(119.5,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(119.5,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(119.5,.01,3)
	;;=ANSWER MUST BE 3-50 CHARACTERS IN LENGTH
	;;^DD(119.5,.01,21,0)
	;;=^^2^2^2880709^
	;;^DD(119.5,.01,21,1,0)
	;;=This is the name of the consultation as it would normally be
	;;^DD(119.5,.01,21,2,0)
	;;=known by ward/medical personnel.
	;;^DD(119.5,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(119.5,.01,"DT")
	;;=2850625
	;;^DD(119.5,1,0)
	;;=BRIEF NAME^RF^^0;2^K:$L(X)>10!($L(X)<1) X
	;;^DD(119.5,1,3)
	;;=ANSWER MUST BE 1-10 CHARACTERS IN LENGTH
	;;^DD(119.5,1,21,0)
	;;=^^1^1^2880717^
	;;^DD(119.5,1,21,1,0)
	;;=This is a short abbreviation of the dietetic consult type.
	;;^DD(119.5,2,0)
	;;=ASK INITIAL/FOLLOW-UP?^S^Y:YES;N:NO;^0;3^Q
	;;^DD(119.5,2,21,0)
	;;=^^3^3^2880709^
	;;^DD(119.5,2,21,1,0)
	;;=This field, if answered YES, will prompt the clinician completing
	;;^DD(119.5,2,21,2,0)
	;;=the consult to indicate whether it was an initial consultation
	;;^DD(119.5,2,21,3,0)
	;;=or a follow-up to prior consultations.
	;;^DD(119.5,2,"DT")
	;;=2850606
	;;^DD(119.5,3,0)
	;;=TU FOR INITIAL CONSULT^RNJ6,2^^0;4^K:+X'=X!(X>100)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(119.5,3,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 100
	;;^DD(119.5,3,21,0)
	;;=^^3^3^2880709^
	;;^DD(119.5,3,21,1,0)
	;;=This field contains the number of 'time-units' associated
	;;^DD(119.5,3,21,2,0)
	;;=with an initial consultation. The values of these 'time-units'
	;;^DD(119.5,3,21,3,0)
	;;=are left to local discretion.
	;;^DD(119.5,3,"DT")
	;;=2850618
	;;^DD(119.5,4,0)
	;;=TU FOR FOLLOW-UP^NJ6,2^^0;5^K:+X'=X!(X>100)!(X<0)!(X?.E1"."3N.N) X
	;;^DD(119.5,4,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 100
	;;^DD(119.5,4,21,0)
	;;=^^4^4^2880709^
	;;^DD(119.5,4,21,1,0)
	;;=This field contains the number of 'time-units' associated
	;;^DD(119.5,4,21,2,0)
	;;=with a follow-up consultation and need be present only when
	;;^DD(119.5,4,21,3,0)
	;;=the follow-up prompt has been selected. The values of these
	;;^DD(119.5,4,21,4,0)
	;;='time-units' is left to local discretion.
	;;^DD(119.5,4,"DT")
	;;=2850618
	;;^DD(119.5,5,0)
	;;=USER TO BULLETIN^P200'^VA(200,^0;6^Q
	;;^DD(119.5,5,21,0)
	;;=^^4^4^2880709^
	;;^DD(119.5,5,21,1,0)
	;;=If a bulletin to a designated clinician is desired whenever
	;;^DD(119.5,5,21,2,0)
	;;=this consult is ordered, the clinician should be selected.
	;;^DD(119.5,5,21,3,0)
	;;=An example might be a renal dialysis consult or a nutrition
	;;^DD(119.5,5,21,4,0)
	;;=support consult.
	;;^DD(119.5,5,"DT")
	;;=2850821
	;;^DD(119.5,99,0)
	;;=INACTIVE?^SX^Y:YES;N:NO;^I;1^Q
	;;^DD(119.5,99,1,0)
	;;=^.1
	;;^DD(119.5,99,1,1,0)
	;;=119.5^AC^MUMPS
	;;^DD(119.5,99,1,1,1)
	;;=K:X'="Y" ^FH(119.5,DA,"I")
	;;^DD(119.5,99,1,1,2)
	;;=K ^FH(119.5,DA,"I")
	;;^DD(119.5,99,1,1,"%D",0)
	;;=^^2^2^2940818^
	;;^DD(119.5,99,1,1,"%D",1,0)
	;;=This cross-reference is used to create an 'I' node for
	;;^DD(119.5,99,1,1,"%D",2,0)
	;;=inactive entries.
	;;^DD(119.5,99,21,0)
	;;=^^2^2^2880709^
	;;^DD(119.5,99,21,1,0)
	;;=This field, when answered YES, will prohibit further selection
	;;^DD(119.5,99,21,2,0)
	;;=of this consult type by ward or dietetic personnel.
	;;^DD(119.5,99,"DT")
	;;=2871025
