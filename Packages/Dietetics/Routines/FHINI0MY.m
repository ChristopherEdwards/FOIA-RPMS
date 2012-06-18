FHINI0MY	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.74)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(119.74,0,"GL")
	;;=^FH(119.74,
	;;^DIC("B","SUPPLEMENTAL FEEDING SITE",119.74)
	;;=
	;;^DIC(119.74,"%D",0)
	;;=^^3^3^2911204^
	;;^DIC(119.74,"%D",1,0)
	;;=This file contains a list of Supplemental Feeding Sites and associated
	;;^DIC(119.74,"%D",2,0)
	;;=parameters. A Supplemental Feeding Site prepares orders for a 
	;;^DIC(119.74,"%D",3,0)
	;;=group of wards for which it is responsible.
	;;^DD(119.74,0)
	;;=FIELD^^21^5
	;;^DD(119.74,0,"DT")
	;;=2911203
	;;^DD(119.74,0,"IX","B",119.74,.01)
	;;=
	;;^DD(119.74,0,"IX","C",119.74,1)
	;;=
	;;^DD(119.74,0,"NM","SUPPLEMENTAL FEEDING SITE")
	;;=
	;;^DD(119.74,0,"PT",119.6,7)
	;;=
	;;^DD(119.74,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(119.74,.01,1,0)
	;;=^.1
	;;^DD(119.74,.01,1,1,0)
	;;=119.74^B
	;;^DD(119.74,.01,1,1,1)
	;;=S ^FH(119.74,"B",$E(X,1,30),DA)=""
	;;^DD(119.74,.01,1,1,2)
	;;=K ^FH(119.74,"B",$E(X,1,30),DA)
	;;^DD(119.74,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(119.74,.01,21,0)
	;;=^^3^3^2911204^^
	;;^DD(119.74,.01,21,1,0)
	;;=This field contains the name of the Supplemental Feeding Site. It is
	;;^DD(119.74,.01,21,2,0)
	;;=responsible for the assembly and delivery of supplemental feedings
	;;^DD(119.74,.01,21,3,0)
	;;=to a group of Dietetic Wards.
	;;^DD(119.74,1,0)
	;;=SHORT NAME^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>6!($L(X)<1) X
	;;^DD(119.74,1,1,0)
	;;=^.1
	;;^DD(119.74,1,1,1,0)
	;;=119.74^C
	;;^DD(119.74,1,1,1,1)
	;;=S ^FH(119.74,"C",$E(X,1,30),DA)=""
	;;^DD(119.74,1,1,1,2)
	;;=K ^FH(119.74,"C",$E(X,1,30),DA)
	;;^DD(119.74,1,1,1,"DT")
	;;=2930427
	;;^DD(119.74,1,3)
	;;=Answer must be 1-6 characters in length.
	;;^DD(119.74,1,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.74,1,21,1,0)
	;;=This field contains a short 6-character name to be used on various
	;;^DD(119.74,1,21,2,0)
	;;=reports.
	;;^DD(119.74,1,"DT")
	;;=2930427
	;;^DD(119.74,2,0)
	;;=PRODUCTION FACILITY^RP119.71'^FH(119.71,^0;3^Q
	;;^DD(119.74,2,21,0)
	;;=^^3^3^2950614^^
	;;^DD(119.74,2,21,1,0)
	;;=This field indicates the production facility that is responsible for
	;;^DD(119.74,2,21,2,0)
	;;=preparing the food used in the supplemental feedings distributed by
	;;^DD(119.74,2,21,3,0)
	;;=this site.
	;;^DD(119.74,2,"DT")
	;;=2911108
	;;^DD(119.74,20,0)
	;;=SEPARATE SUPP FDG LABELS?^S^Y:YES;N:NO;^0;4^Q
	;;^DD(119.74,20,21,0)
	;;=^^3^3^2930423^^
	;;^DD(119.74,20,21,1,0)
	;;=This field, if answered YES, indicates that each supplemental
	;;^DD(119.74,20,21,2,0)
	;;=feeding item should be on an individual label rather than having
	;;^DD(119.74,20,21,3,0)
	;;=all items on the item.
	;;^DD(119.74,20,"DT")
	;;=2930423
	;;^DD(119.74,21,0)
	;;=INGREDIENTS ON WARD LISTS?^S^Y:YES;N:NO;^0;5^Q
	;;^DD(119.74,21,21,0)
	;;=^^3^3^2880718^^
	;;^DD(119.74,21,21,1,0)
	;;=This field, if answered YES, will result in the Ward Supplemental
	;;^DD(119.74,21,21,2,0)
	;;=Feeding lists printing the consolidated ingredient requirements
	;;^DD(119.74,21,21,3,0)
	;;=following each ward.
	;;^DD(119.74,21,"DT")
	;;=2850308
