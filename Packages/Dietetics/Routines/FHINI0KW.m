FHINI0KW	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(115.2,0,"GL")
	;;=^FH(115.2,
	;;^DIC("B","FOOD PREFERENCES",115.2)
	;;=
	;;^DIC(115.2,"%D",0)
	;;=^^5^5^2950221^^^^
	;;^DIC(115.2,"%D",1,0)
	;;=This file contains the items which can be selected as patient
	;;^DIC(115.2,"%D",2,0)
	;;=preference items. It contains both items which can be selected,
	;;^DIC(115.2,"%D",3,0)
	;;=such as coffee or tea, as well as food preferences (such as 
	;;^DIC(115.2,"%D",4,0)
	;;=no liver) which will result in certain recipes being excluded
	;;^DIC(115.2,"%D",5,0)
	;;=for the patient.
	;;^DD(115.2,0)
	;;=FIELD^^99^7
	;;^DD(115.2,0,"DT")
	;;=2940225
	;;^DD(115.2,0,"ID",99)
	;;=W:$D(^("I")) "   (** INACTIVE **)"
	;;^DD(115.2,0,"IX","AC",115.2,99)
	;;=
	;;^DD(115.2,0,"IX","B",115.2,.01)
	;;=
	;;^DD(115.2,0,"NM","FOOD PREFERENCES")
	;;=
	;;^DD(115.2,0,"PT",111.119,.01)
	;;=
	;;^DD(115.2,0,"PT",115.09,.01)
	;;=
	;;^DD(115.2,0,"SCR")
	;;=I '$D(^FH(115.2,+Y,"I"))!$D(^XUSEC("FHMGR",DUZ))!(DUZ(0)["@")
	;;^DD(115.2,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(115.2,.01,1,0)
	;;=^.1
	;;^DD(115.2,.01,1,1,0)
	;;=115.2^B
	;;^DD(115.2,.01,1,1,1)
	;;=S ^FH(115.2,"B",$E(X,1,30),DA)=""
	;;^DD(115.2,.01,1,1,2)
	;;=K ^FH(115.2,"B",$E(X,1,30),DA)
	;;^DD(115.2,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(115.2,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(115.2,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(115.2,.01,21,0)
	;;=^^2^2^2880901^
	;;^DD(115.2,.01,21,1,0)
	;;=This field contains the name of a selectable food preference, such
	;;^DD(115.2,.01,21,2,0)
	;;=as coffee or tea, or a generic preference, such as 'no liver'.
	;;^DD(115.2,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(115.2,1,0)
	;;=LIKE OR DISLIKE^RS^L:LIKE;D:DISLIKE;^0;2^Q
	;;^DD(115.2,1,21,0)
	;;=^^2^2^2880913^^
	;;^DD(115.2,1,21,1,0)
	;;=This field indicates whether the item is a selectable item or
	;;^DD(115.2,1,21,2,0)
	;;=a food preference.
	;;^DD(115.2,1,"DT")
	;;=2880913
	;;^DD(115.2,3,0)
	;;=RECIPE^P114'^FH(114,^0;4^Q
	;;^DD(115.2,3,21,0)
	;;=^^2^2^2910506^^
	;;^DD(115.2,3,21,1,0)
	;;=In the case of a selectable item, this field points to the selection
	;;^DD(115.2,3,21,2,0)
	;;=in the Recipe file (114).
	;;^DD(115.2,10,0)
	;;=EXCLUDED RECIPES^115.21P^^X;0
	;;^DD(115.2,10,21,0)
	;;=^^3^3^2910506^^
	;;^DD(115.2,10,21,1,0)
	;;=In the case of a food preference, this multiple is the list of
	;;^DD(115.2,10,21,2,0)
	;;=excluded recipes contained in the Recipe file (114) which should
	;;^DD(115.2,10,21,3,0)
	;;=NOT be served to the patient.
	;;^DD(115.2,20,0)
	;;=BREAD/BEVERAGE DEFAULT?^S^1:YES;0:NO;^0;5^Q
	;;^DD(115.2,20,21,0)
	;;=^^3^3^2940419^^^^
	;;^DD(115.2,20,21,1,0)
	;;=This field, if answered Yes, means this food preference is the standard
	;;^DD(115.2,20,21,2,0)
	;;=default bread/beverage for the patients on the tray tickets else if
	;;^DD(115.2,20,21,3,0)
	;;=answered No, means it is not.
	;;^DD(115.2,20,"DT")
	;;=2940419
	;;^DD(115.2,21,0)
	;;=MEALS^FX^^0;6^S:$P("ALL",X,1)="" X="BNE" S %=X,X="" S:%["B" X="B" S:%["N" X=X_"N" S:%["E" X=X_"E" K:$L(%)'=$L(X) X K %
	;;^DD(115.2,21,3)
	;;=Answer should be a string of meals (e.g., B or BN or BNE) or A for all meals.
	;;^DD(115.2,21,21,0)
	;;=^^2^2^2940225^
	;;^DD(115.2,21,21,1,0)
	;;=This field contains the meals (B N and E) for which this standard
	;;^DD(115.2,21,21,2,0)
	;;=default food preference is applicable.
	;;^DD(115.2,21,"DT")
	;;=2940225
	;;^DD(115.2,99,0)
	;;=INACTIVE?^S^Y:YES;N:NO;^I;1^Q
	;;^DD(115.2,99,1,0)
	;;=^.1
	;;^DD(115.2,99,1,1,0)
	;;=115.2^AC^MUMPS
	;;^DD(115.2,99,1,1,1)
	;;=K:X'="Y" ^FH(115.2,DA,"I")
	;;^DD(115.2,99,1,1,2)
	;;=K ^FH(115.2,DA,"I")
	;;^DD(115.2,99,1,1,"%D",0)
	;;=^^2^2^2940818^
	;;^DD(115.2,99,1,1,"%D",1,0)
	;;=This cross-reference is used to create an 'I' node for
	;;^DD(115.2,99,1,1,"%D",2,0)
	;;=inactive entries.
	;;^DD(115.2,99,21,0)
	;;=^^2^2^2940225^^
	;;^DD(115.2,99,21,1,0)
	;;=This field, if answered YES, will prohibit further selection
	;;^DD(115.2,99,21,2,0)
	;;=of this preference unless the FHMGR key is held.
	;;^DD(115.2,99,"DT")
	;;=2900918
	;;^DD(115.21,0)
	;;=EXCLUDED RECIPES SUB-FIELD^^.01^1
	;;^DD(115.21,0,"IX","B",115.21,.01)
	;;=
	;;^DD(115.21,0,"NM","EXCLUDED RECIPES")
	;;=
	;;^DD(115.21,0,"UP")
	;;=115.2
	;;^DD(115.21,.01,0)
	;;=EXCLUDED RECIPES^MP114'^FH(114,^0;1^Q
	;;^DD(115.21,.01,1,0)
	;;=^.1
	;;^DD(115.21,.01,1,1,0)
	;;=115.21^B
	;;^DD(115.21,.01,1,1,1)
	;;=S ^FH(115.2,DA(1),"X","B",$E(X,1,30),DA)=""
	;;^DD(115.21,.01,1,1,2)
	;;=K ^FH(115.2,DA(1),"X","B",$E(X,1,30),DA)
	;;^DD(115.21,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
