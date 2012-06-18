FHINI0I0	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(113.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(113.1,0,"GL")
	;;=^FH(113.1,
	;;^DIC("B","STORAGE LOCATION",113.1)
	;;=
	;;^DIC(113.1,"%D",0)
	;;=^^3^3^2880424^
	;;^DIC(113.1,"%D",1,0)
	;;=This is the file of storage locations where ingredients are
	;;^DIC(113.1,"%D",2,0)
	;;=stored by the dietetic service. It is primarily used to sort
	;;^DIC(113.1,"%D",3,0)
	;;=various ingredient pull lists.
	;;^DD(113.1,0)
	;;=FIELD^^2^3
	;;^DD(113.1,0,"IX","B",113.1,.01)
	;;=
	;;^DD(113.1,0,"IX","C",113.1,1)
	;;=
	;;^DD(113.1,0,"NM","STORAGE LOCATION")
	;;=
	;;^DD(113.1,0,"PT",113,11)
	;;=
	;;^DD(113.1,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>15!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(113.1,.01,1,0)
	;;=^.1
	;;^DD(113.1,.01,1,1,0)
	;;=113.1^B
	;;^DD(113.1,.01,1,1,1)
	;;=S ^FH(113.1,"B",$E(X,1,30),DA)=""
	;;^DD(113.1,.01,1,1,2)
	;;=K ^FH(113.1,"B",$E(X,1,30),DA)
	;;^DD(113.1,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(113.1,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(113.1,.01,3)
	;;=ANSWER MUST BE 3-15 CHARACTERS IN LENGTH
	;;^DD(113.1,.01,21,0)
	;;=^^4^4^2920812^^
	;;^DD(113.1,.01,21,1,0)
	;;=This is the name of a storage location where ingredients are
	;;^DD(113.1,.01,21,2,0)
	;;=stored (e.g., particular freezers, dry goods rooms, etc.). It
	;;^DD(113.1,.01,21,3,0)
	;;=is used by the Ingredient file to indicate where the
	;;^DD(113.1,.01,21,4,0)
	;;=ingredient is stocked.
	;;^DD(113.1,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(113.1,1,0)
	;;=CODE^RF^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>5!($L(X)<1) X
	;;^DD(113.1,1,1,0)
	;;=^.1
	;;^DD(113.1,1,1,1,0)
	;;=113.1^C
	;;^DD(113.1,1,1,1,1)
	;;=S ^FH(113.1,"C",$E(X,1,30),DA)=""
	;;^DD(113.1,1,1,1,2)
	;;=K ^FH(113.1,"C",$E(X,1,30),DA)
	;;^DD(113.1,1,3)
	;;=ANSWER MUST BE 1-5 CHARACTERS IN LENGTH
	;;^DD(113.1,1,21,0)
	;;=^^2^2^2880709^
	;;^DD(113.1,1,21,1,0)
	;;=This is a short abbreviation used on various print-outs in lieu
	;;^DD(113.1,1,21,2,0)
	;;=of the longer full name. It should be unique.
	;;^DD(113.1,1,"DT")
	;;=2901119
	;;^DD(113.1,2,0)
	;;=PRINT ORDER^RNJ2,0^^0;3^K:+X'=X!(X>49)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(113.1,2,3)
	;;=Type a Number between 1 and 49, 0 Decimal Digits
	;;^DD(113.1,2,21,0)
	;;=^^4^4^2920812^^^^
	;;^DD(113.1,2,21,1,0)
	;;=When ingredient pull lists are generated and sorted by storage
	;;^DD(113.1,2,21,2,0)
	;;=location, this field contains the print order of the various
	;;^DD(113.1,2,21,3,0)
	;;=storage locations. It is numeric and will print from low to
	;;^DD(113.1,2,21,4,0)
	;;=high.
	;;^DD(113.1,2,"DT")
	;;=2880328
