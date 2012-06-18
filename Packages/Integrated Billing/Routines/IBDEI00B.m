IBDEI00B	; ; 18-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(358.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(358.2,0,"GL")
	;;=^IBE(358.2,
	;;^DIC("B","IMP/EXP SELECTION LIST",358.2)
	;;=
	;;^DIC(358.2,"%D",0)
	;;=^^10^10^2940217^
	;;^DIC(358.2,"%D",1,0)
	;;= 
	;;^DIC(358.2,"%D",2,0)
	;;= 
	;;^DIC(358.2,"%D",3,0)
	;;= 
	;;^DIC(358.2,"%D",4,0)
	;;= 
	;;^DIC(358.2,"%D",5,0)
	;;= 
	;;^DIC(358.2,"%D",6,0)
	;;= 
	;;^DIC(358.2,"%D",7,0)
	;;= 
	;;^DIC(358.2,"%D",8,0)
	;;=This file is nearly identical to file #357.2 . It is used by the
	;;^DIC(358.2,"%D",9,0)
	;;=Import/Export Utility as a temporary staging area for data from that file
	;;^DIC(358.2,"%D",10,0)
	;;=that is being imported or exported.
	;;^DD(358.2,0)
	;;=FIELD^^2^12
	;;^DD(358.2,0,"ID",.02)
	;;=W ""
	;;^DD(358.2,0,"ID",.11)
	;;=W ""
	;;^DD(358.2,0,"IX","B",358.2,.01)
	;;=
	;;^DD(358.2,0,"IX","C",358.2,.02)
	;;=
	;;^DD(358.2,0,"NM","IMP/EXP SELECTION LIST")
	;;=
	;;^DD(358.2,0,"PT",358.3,.03)
	;;=
	;;^DD(358.2,0,"PT",358.4,.03)
	;;=
	;;^DD(358.2,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(358.2,.01,1,0)
	;;=^.1
	;;^DD(358.2,.01,1,1,0)
	;;=358.2^B
	;;^DD(358.2,.01,1,1,1)
	;;=S ^IBE(358.2,"B",$E(X,1,30),DA)=""
	;;^DD(358.2,.01,1,1,2)
	;;=K ^IBE(358.2,"B",$E(X,1,30),DA)
	;;^DD(358.2,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(358.2,.01,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.2,.01,21,1,0)
	;;= 
	;;^DD(358.2,.01,21,2,0)
	;;=The name of the list.
	;;^DD(358.2,.01,"DEL",1,0)
	;;=I '$G(IBLISTPR) W "...Selection Lists can only be deleted through the Encounter Form Utilities!"
	;;^DD(358.2,.01,"DT")
	;;=2921119
	;;^DD(358.2,.02,0)
	;;=BLOCK^RP358.1'^IBE(358.1,^0;2^Q
	;;^DD(358.2,.02,1,0)
	;;=^.1
	;;^DD(358.2,.02,1,1,0)
	;;=358.2^C
	;;^DD(358.2,.02,1,1,1)
	;;=S ^IBE(358.2,"C",$E(X,1,30),DA)=""
	;;^DD(358.2,.02,1,1,2)
	;;=K ^IBE(358.2,"C",$E(X,1,30),DA)
	;;^DD(358.2,.02,1,1,"DT")
	;;=2921207
	;;^DD(358.2,.02,3)
	;;=Enter the block that the selection list should appear in.
	;;^DD(358.2,.02,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.2,.02,21,1,0)
	;;=The block that the list appears on. The position of the selection list is
	;;^DD(358.2,.02,21,2,0)
	;;=relative to the block.
	;;^DD(358.2,.02,"DT")
	;;=2921207
	;;^DD(358.2,.05,0)
	;;=COLUMN HEADER^F^^0;5^K:$L(X)>70!($L(X)<1) X
	;;^DD(358.2,.05,.1)
	;;=WHAT TEXT SHOULD APPEAR AT THE TOP OF EACH COLUMN? (OPTIONAL)
	;;^DD(358.2,.05,3)
	;;=This header will appear at the top of the column that contains the list. If there is more than one column it will appear at the top of each.
	;;^DD(358.2,.05,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.2,.05,21,1,0)
	;;= 
	;;^DD(358.2,.05,21,2,0)
	;;=The text that appears at the top of each column (NOT subcolumn).
	;;^DD(358.2,.05,"DT")
	;;=2930415
	;;^DD(358.2,.06,0)
	;;=COLUMN HEADER APPEARANCE^FX^^0;6^S X=$$UPPER^VALM1(X) K:$L(X)>3!("UBC"'[$E(X,1))!("UBC"'[$E(X,2))!("UBC"'[$E(X,3)) X
	;;^DD(358.2,.06,.1)
	;;=HOW SHOULD THE COLUMN HEADER APPEAR? CHOOSE FROM {U,B,C}
	;;^DD(358.2,.06,3)
	;;=B=bold,U=underline,C=center. You can enter any combination of {B,U,C}.
	;;^DD(358.2,.06,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.2,.06,21,1,0)
	;;= 
	;;^DD(358.2,.06,21,2,0)
	;;=The column header can be give characteristics, such as centered and bold.
	;;^DD(358.2,.06,"DT")
	;;=2930616
	;;^DD(358.2,.07,0)
	;;=SUBCOLUMNS SEPARATED WITH?^RS^1:ONE SPACE;2:TWO SPACES;3:LINE;4:SPACE/LINE/SPACE;^0;7^Q
	;;^DD(358.2,.07,.1)
	;;=HOW SHOULD THE SUBCOLUMNS BE SEPARATED?
	;;^DD(358.2,.07,3)
	;;=How should the subcolumns be separated?
	;;^DD(358.2,.07,21,0)
	;;=^^2^2^2930527^
	;;^DD(358.2,.07,21,1,0)
	;;= 
	;;^DD(358.2,.07,21,2,0)
	;;=What characters are used to separate the subcolumns.
	;;^DD(358.2,.07,"DT")
	;;=2930415
