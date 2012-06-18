IBINI07N	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(357.2,0,"GL")
	;;=^IBE(357.2,
	;;^DIC("B","SELECTION LIST",357.2)
	;;=
	;;^DIC(357.2,"%D",0)
	;;=^^10^10^2940217^
	;;^DIC(357.2,"%D",1,0)
	;;= 
	;;^DIC(357.2,"%D",2,0)
	;;= 
	;;^DIC(357.2,"%D",3,0)
	;;= 
	;;^DIC(357.2,"%D",4,0)
	;;= 
	;;^DIC(357.2,"%D",5,0)
	;;= 
	;;^DIC(357.2,"%D",6,0)
	;;=This file contains descriptions of 'selection lists'.  A selection list is
	;;^DIC(357.2,"%D",7,0)
	;;=a rectangular area in a block that contains a list. The list has 'columns'
	;;^DIC(357.2,"%D",8,0)
	;;=of 'selections'. The columns have 'subcolumns', which can either contain
	;;^DIC(357.2,"%D",9,0)
	;;=text or  a 'marking area'.  A marking area is an area on the form designed
	;;^DIC(357.2,"%D",10,0)
	;;=to be checked to indicate that a choice is being made from the list.
	;;^DD(357.2,0)
	;;=FIELD^^2^12
	;;^DD(357.2,0,"DDA")
	;;=N
	;;^DD(357.2,0,"DIK")
	;;=IBXF2
	;;^DD(357.2,0,"DT")
	;;=2930427
	;;^DD(357.2,0,"ID",.02)
	;;=W ""
	;;^DD(357.2,0,"ID",.11)
	;;=W ""
	;;^DD(357.2,0,"IX","B",357.2,.01)
	;;=
	;;^DD(357.2,0,"IX","C",357.2,.02)
	;;=
	;;^DD(357.2,0,"NM","SELECTION LIST")
	;;=
	;;^DD(357.2,0,"PT",357.3,.03)
	;;=
	;;^DD(357.2,0,"PT",357.4,.03)
	;;=
	;;^DD(357.2,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!($L(X)<3)!'(X'?1P.E) X
	;;^DD(357.2,.01,1,0)
	;;=^.1
	;;^DD(357.2,.01,1,1,0)
	;;=357.2^B
	;;^DD(357.2,.01,1,1,1)
	;;=S ^IBE(357.2,"B",$E(X,1,30),DA)=""
	;;^DD(357.2,.01,1,1,2)
	;;=K ^IBE(357.2,"B",$E(X,1,30),DA)
	;;^DD(357.2,.01,3)
	;;=Answer must be 3-30 characters in length.
	;;^DD(357.2,.01,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.2,.01,21,1,0)
	;;= 
	;;^DD(357.2,.01,21,2,0)
	;;=The name of the list.
	;;^DD(357.2,.01,"DEL",1,0)
	;;=I '$G(IBLISTPR) W "...Selection Lists can only be deleted through the Encounter Form Utilities!"
	;;^DD(357.2,.01,"DT")
	;;=2921119
	;;^DD(357.2,.02,0)
	;;=BLOCK^RP357.1'^IBE(357.1,^0;2^Q
	;;^DD(357.2,.02,1,0)
	;;=^.1
	;;^DD(357.2,.02,1,1,0)
	;;=357.2^C
	;;^DD(357.2,.02,1,1,1)
	;;=S ^IBE(357.2,"C",$E(X,1,30),DA)=""
	;;^DD(357.2,.02,1,1,2)
	;;=K ^IBE(357.2,"C",$E(X,1,30),DA)
	;;^DD(357.2,.02,1,1,"DT")
	;;=2921207
	;;^DD(357.2,.02,3)
	;;=Enter the block that the selection list should appear in.
	;;^DD(357.2,.02,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.2,.02,21,1,0)
	;;=The block that the list appears on. The position of the selection list is
	;;^DD(357.2,.02,21,2,0)
	;;=relative to the block.
	;;^DD(357.2,.02,"DT")
	;;=2921207
	;;^DD(357.2,.05,0)
	;;=COLUMN HEADER^F^^0;5^K:$L(X)>70!($L(X)<1) X
	;;^DD(357.2,.05,.1)
	;;=WHAT TEXT SHOULD APPEAR AT THE TOP OF EACH COLUMN? (OPTIONAL)
	;;^DD(357.2,.05,3)
	;;=This header will appear at the top of the column that contains the list. If there is more than one column it will appear at the top of each.
	;;^DD(357.2,.05,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.2,.05,21,1,0)
	;;= 
	;;^DD(357.2,.05,21,2,0)
	;;=The text that appears at the top of each column (NOT subcolumn).
	;;^DD(357.2,.05,"DT")
	;;=2930415
	;;^DD(357.2,.06,0)
	;;=COLUMN HEADER APPEARANCE^FX^^0;6^S X=$$UPPER^VALM1(X) K:$L(X)>3!("UBC"'[$E(X,1))!("UBC"'[$E(X,2))!("UBC"'[$E(X,3)) X
	;;^DD(357.2,.06,.1)
	;;=HOW SHOULD THE COLUMN HEADER APPEAR? CHOOSE FROM {U,B,C}
	;;^DD(357.2,.06,3)
	;;=B=bold,U=underline,C=center. You can enter any combination of {B,U,C}.
	;;^DD(357.2,.06,21,0)
	;;=^^2^2^2930527^
	;;^DD(357.2,.06,21,1,0)
	;;= 
	;;^DD(357.2,.06,21,2,0)
	;;=The column header can be give characteristics, such as centered and bold.
	;;^DD(357.2,.06,"DT")
	;;=2930616
	;;^DD(357.2,.07,0)
	;;=SUBCOLUMNS SEPARATED WITH?^RS^1:ONE SPACE;2:TWO SPACES;3:LINE;4:SPACE/LINE/SPACE;^0;7^Q
	;;^DD(357.2,.07,.1)
	;;=HOW SHOULD THE SUBCOLUMNS BE SEPARATED?
