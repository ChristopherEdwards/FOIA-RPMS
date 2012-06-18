IBINI07G	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(357)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(357,0,"GL")
	;;=^IBE(357,
	;;^DIC("B","ENCOUNTER FORM",357)
	;;=
	;;^DIC(357,"%D",0)
	;;=^^3^3^2940121^
	;;^DIC(357,"%D",1,0)
	;;= 
	;;^DIC(357,"%D",2,0)
	;;=Contains encounter form descriptions, used by the Encounter Form utilities
	;;^DIC(357,"%D",3,0)
	;;=to print encounter forms.
	;;^DD(357,0)
	;;=FIELD^^.11^8
	;;^DD(357,0,"DDA")
	;;=N
	;;^DD(357,0,"DIK")
	;;=IBXF0
	;;^DD(357,0,"DT")
	;;=2931124
	;;^DD(357,0,"ID",.03)
	;;=W "   ",$P(^(0),U,3)
	;;^DD(357,0,"IX","AC",357,.01)
	;;=
	;;^DD(357,0,"IX","AG",357,.01)
	;;=
	;;^DD(357,0,"IX","AT",357,.01)
	;;=
	;;^DD(357,0,"IX","AU",357,.01)
	;;=
	;;^DD(357,0,"IX","B",357,.01)
	;;=
	;;^DD(357,0,"IX","C",357,.07)
	;;=
	;;^DD(357,0,"IX","D",357,.04)
	;;=
	;;^DD(357,0,"NM","ENCOUNTER FORM")
	;;=
	;;^DD(357,0,"PT",357.1,.02)
	;;=
	;;^DD(357,0,"PT",409.95,.02)
	;;=
	;;^DD(357,0,"PT",409.95,.03)
	;;=
	;;^DD(357,0,"PT",409.95,.04)
	;;=
	;;^DD(357,0,"PT",409.95,.05)
	;;=
	;;^DD(357,0,"PT",409.95,.06)
	;;=
	;;^DD(357,0,"PT",409.95,.07)
	;;=
	;;^DD(357,.01,0)
	;;=NAME^RFX^^0;1^K:X[""""!($A(X)=45) X I $D(X) S X=$$UP^XLFSTR(X) K:$L(X)>30!($L(X)<3) X
	;;^DD(357,.01,1,0)
	;;=^.1
	;;^DD(357,.01,1,1,0)
	;;=357^B
	;;^DD(357,.01,1,1,1)
	;;=S ^IBE(357,"B",$E(X,1,30),DA)=""
	;;^DD(357,.01,1,1,2)
	;;=K ^IBE(357,"B",$E(X,1,30),DA)
	;;^DD(357,.01,1,2,0)
	;;=357^AT^MUMPS
	;;^DD(357,.01,1,2,1)
	;;=Q
	;;^DD(357,.01,1,2,2)
	;;=Q
	;;^DD(357,.01,1,2,"%D",0)
	;;=^^4^4^2931124^
	;;^DD(357,.01,1,2,"%D",1,0)
	;;=This cross-reference will be used to store the text of the compiled form.
	;;^DD(357,.01,1,2,"%D",2,0)
	;;=The format will be ..."AT",form ien,row #)=text line. The index will be
	;;^DD(357,.01,1,2,"%D",3,0)
	;;=created by the 'compile' action of the encounter form utilities - it is
	;;^DD(357,.01,1,2,"%D",4,0)
	;;=optional.
	;;^DD(357,.01,1,2,"DT")
	;;=2931124
	;;^DD(357,.01,1,3,0)
	;;=357^AC^MUMPS
	;;^DD(357,.01,1,3,1)
	;;=Q
	;;^DD(357,.01,1,3,2)
	;;=Q
	;;^DD(357,.01,1,3,"%D",0)
	;;=^^4^4^2940216^
	;;^DD(357,.01,1,3,"%D",1,0)
	;;=This cross-reference will be used to store the special controls needed
	;;^DD(357,.01,1,3,"%D",2,0)
	;;=(bold on, bold off, etc.) to print the compiled form. The format will be
	;;^DD(357,.01,1,3,"%D",3,0)
	;;=..."AC",form ien,row #,column # )=controls. The index will be created by
	;;^DD(357,.01,1,3,"%D",4,0)
	;;=the 'compile' action of the encounter form utilities - it is optional.
	;;^DD(357,.01,1,3,"DT")
	;;=2931124
	;;^DD(357,.01,1,4,0)
	;;=357^AU^MUMPS
	;;^DD(357,.01,1,4,1)
	;;=Q
	;;^DD(357,.01,1,4,2)
	;;=Q
	;;^DD(357,.01,1,4,"%D",0)
	;;=^^4^4^2931124^
	;;^DD(357,.01,1,4,"%D",1,0)
	;;=This cross-reference will be used to store the underlining of the compiled
	;;^DD(357,.01,1,4,"%D",2,0)
	;;=form. The format will be ...,"AU",form ien,row #)=underlining . The index
	;;^DD(357,.01,1,4,"%D",3,0)
	;;=will be created by the 'compile' action of the encounter form utilities -
	;;^DD(357,.01,1,4,"%D",4,0)
	;;=it is optional.
	;;^DD(357,.01,1,4,"DT")
	;;=2931124
	;;^DD(357,.01,1,5,0)
	;;=357^AG^MUMPS
	;;^DD(357,.01,1,5,1)
	;;=Q
	;;^DD(357,.01,1,5,2)
	;;=Q
	;;^DD(357,.01,1,5,"%D",0)
	;;=^^5^5^2931124^
	;;^DD(357,.01,1,5,"%D",1,0)
	;;=This cross-reference will be used to store strings of graphics characters
	;;^DD(357,.01,1,5,"%D",2,0)
	;;=(TLC,TRC, etc.) needed for the compiled form. The format will be
	;;^DD(357,.01,1,5,"%D",3,0)
	;;=..."AG",form ien,row #,column # )=graphics string . The index will be
	;;^DD(357,.01,1,5,"%D",4,0)
	;;=created by the 'compile' action of the encounter form utilities - it is
	;;^DD(357,.01,1,5,"%D",5,0)
	;;=optional.
	;;^DD(357,.01,1,5,"DT")
	;;=2931124
