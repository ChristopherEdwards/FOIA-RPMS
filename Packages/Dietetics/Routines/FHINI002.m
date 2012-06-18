FHINI002	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(111)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(111,6,3)
	;;=ANSWER MUST BE 1-12 CHARACTERS IN LENGTH
	;;^DD(111,6,21,0)
	;;=^^3^3^2880709^
	;;^DD(111,6,21,1,0)
	;;=This is an abbreviated label title used on diet cards; the
	;;^DD(111,6,21,2,0)
	;;=terminology and abbreviations will normally be those used
	;;^DD(111,6,21,3,0)
	;;=by dietetic personnel.
	;;^DD(111,6,"DT")
	;;=2850202
	;;^DD(111,10,0)
	;;=ALTERNATE NAME^111.01^^AN;0
	;;^DD(111,10,21,0)
	;;=^^3^3^2880714^^
	;;^DD(111,10,21,1,0)
	;;=This field may be used for any number of alternate names for
	;;^DD(111,10,21,2,0)
	;;=the diet modification. These alternative names will normally
	;;^DD(111,10,21,3,0)
	;;=be those used by ward/medical personnel.
	;;^DD(111,99,0)
	;;=INACTIVE?^S^Y:YES;N:NO;^I;1^Q
	;;^DD(111,99,1,0)
	;;=^.1
	;;^DD(111,99,1,1,0)
	;;=111^AC^MUMPS
	;;^DD(111,99,1,1,1)
	;;=K:X'="Y" ^FH(111,DA,"I")
	;;^DD(111,99,1,1,2)
	;;=K ^FH(111,DA,"I")
	;;^DD(111,99,1,1,"%D",0)
	;;=^^2^2^2940818^
	;;^DD(111,99,1,1,"%D",1,0)
	;;=This cross-reference is used to create an 'I' node for
	;;^DD(111,99,1,1,"%D",2,0)
	;;=inactive entries.
	;;^DD(111,99,21,0)
	;;=^^2^2^2931116^^
	;;^DD(111,99,21,1,0)
	;;=This field, if answered YES, will prohibit further selection
	;;^DD(111,99,21,2,0)
	;;=of this diet modification by ward personnel.
	;;^DD(111,99,"DT")
	;;=2860813
	;;^DD(111.01,0)
	;;=ALTERNATE NAME SUB-FIELD^NL^.01^1
	;;^DD(111.01,0,"NM","ALTERNATE NAME")
	;;=
	;;^DD(111.01,0,"UP")
	;;=111
	;;^DD(111.01,.01,0)
	;;=ALTERNATE NAME^MF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<1) X
	;;^DD(111.01,.01,1,0)
	;;=^.1
	;;^DD(111.01,.01,1,1,0)
	;;=111^B^MNEMONIC
	;;^DD(111.01,.01,1,1,1)
	;;=S:'$D(^FH(111,"B",$E(X,1,30),DA(1),DA)) ^(DA)=1
	;;^DD(111.01,.01,1,1,2)
	;;=I $D(^FH(111,"B",$E(X,1,30),DA(1),DA)),^(DA) K ^(DA)
	;;^DD(111.01,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(111.01,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the ALTERNATE NAME field.
	;;^DD(111.01,.01,3)
	;;=ANSWER MUST BE 1-30 CHARACTERS IN LENGTH
	;;^DD(111.01,.01,21,0)
	;;=^^1^1^2880714^
	;;^DD(111.01,.01,21,1,0)
	;;=This field contains an alternate name for the diet.
	;;^DD(111.01,.01,"DT")
	;;=2900510
