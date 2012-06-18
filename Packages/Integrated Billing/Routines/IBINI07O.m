IBINI07O	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(357.2,.07,3)
	;;=How should the subcolumns be separated?
	;;^DD(357.2,.07,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.2,.07,21,1,0)
	;;= 
	;;^DD(357.2,.07,21,2,0)
	;;=What characters are used to separate the subcolumns.
	;;^DD(357.2,.07,"DT")
	;;=2930415
	;;^DD(357.2,.08,0)
	;;=EXTRA LINES FOR SELECTIONS^NJ1,0^^0;8^K:+X'=X!(X>9)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(357.2,.08,.1)
	;;=NUMBER OF ADDITIONAL LINES FOR EACH ENTRY ON LIST?
	;;^DD(357.2,.08,3)
	;;=How many extra lines should be allocated for each selection, in addition to the 1 the selection will print on?
	;;^DD(357.2,.08,21,0)
	;;=^^4^4^2930527^
	;;^DD(357.2,.08,21,1,0)
	;;= 
	;;^DD(357.2,.08,21,2,0)
	;;=Each entry on the list prints on only one line. However, if you want
	;;^DD(357.2,.08,21,3,0)
	;;=extra space to appear below each entry on the list then this field should
	;;^DD(357.2,.08,21,4,0)
	;;=be set to the number of blank lines desired.
	;;^DD(357.2,.08,"DT")
	;;=2930427
	;;^DD(357.2,.09,0)
	;;=GROUP HEADER APPEARANCE^FX^^0;9^S X=$$UPPER^VALM1(X) K:$L(X)>3!("UBC"'[$E(X,1))!("UBC"'[$E(X,2))!("UBC"'[$E(X,3)) X
	;;^DD(357.2,.09,.1)
	;;=HOW SHOULD THE HEADER FOR EACH GROUP OF ENTRIES APPEAR? CHOOSE FROM {U,B,C}
	;;^DD(357.2,.09,3)
	;;=B=bold, C=center,U=underline. You can enter any combination of {B,C,U}
	;;^DD(357.2,.09,21,0)
	;;=^^1^1^2930401^^^
	;;^DD(357.2,.09,21,1,0)
	;;=This field determines the appearance of the group headers.
	;;^DD(357.2,.09,"DT")
	;;=2930616
	;;^DD(357.2,.11,0)
	;;=SELECTION ROUTINE^R*P357.6'^IBE(357.6,^0;11^S DIC("S")="I $P(^(0),U,6)=3,$P(^(0),U,9)=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(357.2,.11,3)
	;;=Enter the package interface used to obtain this list.
	;;^DD(357.2,.11,12)
	;;=Allows only available selection routines.
	;;^DD(357.2,.11,12.1)
	;;=S DIC("S")="I $P(^(0),U,6)=3,$P(^(0),U,9)=1"
	;;^DD(357.2,.11,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.2,.11,21,1,0)
	;;= 
	;;^DD(357.2,.11,21,2,0)
	;;=This identifies the Package Interface that is used to fill the list.
	;;^DD(357.2,.11,"DT")
	;;=2930115
	;;^DD(357.2,.12,0)
	;;=UNDERLINE SELECTIONS?^RS^0:NO;1:YES;^0;12^Q
	;;^DD(357.2,.12,.1)
	;;=SHOULD EACH ENTRY ON THE LIST BE UNDERLINED? (YES/NO)
	;;^DD(357.2,.12,3)
	;;=Should the items on the list be underlined?
	;;^DD(357.2,.12,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.2,.12,21,1,0)
	;;= 
	;;^DD(357.2,.12,21,2,0)
	;;=Answer yes if each entry on the list should be underlined.
	;;^DD(357.2,.12,"DT")
	;;=2930414
	;;^DD(357.2,.13,0)
	;;=NUMBER OF COLUMNS^NJ2,0^^0;13^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(357.2,.13,.1)
	;;=HOW MANY COLUMNS OF LIST ENTRIES SHOULD THE LIST HAVE? (OPTIONAL)
	;;^DD(357.2,.13,3)
	;;=
	;;^DD(357.2,.13,4)
	;;=D HELP5^IBDFU5
	;;^DD(357.2,.13,21,0)
	;;=^^6^6^2930527^
	;;^DD(357.2,.13,21,1,0)
	;;= 
	;;^DD(357.2,.13,21,2,0)
	;;=A selection list may be displayed in an area several columns wide. The
	;;^DD(357.2,.13,21,3,0)
	;;=starting position and height of each column may be specified. However, it
	;;^DD(357.2,.13,21,4,0)
	;;=is not necessary because defaults values will be used. The defaults used
	;;^DD(357.2,.13,21,5,0)
	;;=assume that nothing else is going in the block except the selection list
	;;^DD(357.2,.13,21,6,0)
	;;=and that the entire block should be filled.
	;;^DD(357.2,.13,"DT")
	;;=2930802
	;;^DD(357.2,1,0)
	;;=LIST COLUMN^357.21I^^1;0
	;;^DD(357.2,1,21,0)
	;;=^^2^2^2940216^^^^
	;;^DD(357.2,1,21,1,0)
	;;=A column is a rectangular area that has the necessary width to display a
	;;^DD(357.2,1,21,2,0)
	;;=single item on the list.
	;;^DD(357.2,1,"DT")
	;;=2930802
