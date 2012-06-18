IBONI009	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",813,10,1,0)
	;;=814^SE^3^^^Selection List
	;;^UTILITY(U,$J,"PRO",813,10,1,"^")
	;;=IBDF SELECTION LIST
	;;^UTILITY(U,$J,"PRO",813,10,2,0)
	;;=820^BS^2
	;;^UTILITY(U,$J,"PRO",813,10,2,"^")
	;;=IBDF RESIZE BLOCK (WHILE EDITING BLOCK)
	;;^UTILITY(U,$J,"PRO",813,10,3,0)
	;;=821^EH^1^^^Header/Descr/Outline
	;;^UTILITY(U,$J,"PRO",813,10,3,"^")
	;;=IBDF EDIT NAME,HEADER,OUTLINE
	;;^UTILITY(U,$J,"PRO",813,10,4,0)
	;;=822^DF^4^^^Data Field
	;;^UTILITY(U,$J,"PRO",813,10,4,"^")
	;;=IBDF DATA FIELD
	;;^UTILITY(U,$J,"PRO",813,10,5,0)
	;;=823^LN^5^^^Straight Line
	;;^UTILITY(U,$J,"PRO",813,10,5,"^")
	;;=IBDF STRAIGHT LINE
	;;^UTILITY(U,$J,"PRO",813,10,6,0)
	;;=824^EX^9^^^Exit
	;;^UTILITY(U,$J,"PRO",813,10,6,"^")
	;;=IBDF EXIT
	;;^UTILITY(U,$J,"PRO",813,10,7,0)
	;;=829^TA^6^^^Text Area
	;;^UTILITY(U,$J,"PRO",813,10,7,"^")
	;;=IBDF TEXT AREA
	;;^UTILITY(U,$J,"PRO",813,10,8,0)
	;;=832^SH^7^^^Shift Contents
	;;^UTILITY(U,$J,"PRO",813,10,8,"^")
	;;=IBDF SHIFT BLOCK CONTENTS
	;;^UTILITY(U,$J,"PRO",813,10,9,0)
	;;=853^SD^8^^^Save/Discard Changes
	;;^UTILITY(U,$J,"PRO",813,10,9,"^")
	;;=IBDF SAVE/DISCARD BLOCK CHANGES
	;;^UTILITY(U,$J,"PRO",813,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",813,28)
	;;=Select Action:
	;;^UTILITY(U,$J,"PRO",813,99)
	;;=55857,55609
	;;^UTILITY(U,$J,"PRO",814,0)
	;;=IBDF SELECTION LIST^Selection List^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",814,1,0)
	;;=^^2^2^2930322^
	;;^UTILITY(U,$J,"PRO",814,1,1,0)
	;;=Allows the user to create a new selection list, delete or edit an already
	;;^UTILITY(U,$J,"PRO",814,1,2,0)
	;;=existing one, or change the contents of a list.
	;;^UTILITY(U,$J,"PRO",814,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",814,2,1,0)
	;;=SE
	;;^UTILITY(U,$J,"PRO",814,2,"B","SE",1)
	;;=
	;;^UTILITY(U,$J,"PRO",814,15)
	;;=I $G(IBFASTXT) S VALMBCK="Q"
	;;^UTILITY(U,$J,"PRO",814,20)
	;;=D LIST^IBDF9A
	;;^UTILITY(U,$J,"PRO",814,28)
	;;=
	;;^UTILITY(U,$J,"PRO",814,99)
	;;=55852,54050
	;;^UTILITY(U,$J,"PRO",815,0)
	;;=IBDF CREATE BLANK FORM^Create Blank Form^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",815,1,0)
	;;=^^1^1^2930607^^^
	;;^UTILITY(U,$J,"PRO",815,1,1,0)
	;;=Creates a new blank form and allows the user to add it to the clinic setup.
	;;^UTILITY(U,$J,"PRO",815,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",815,2,1,0)
	;;=CR
	;;^UTILITY(U,$J,"PRO",815,2,"B","CR",1)
	;;=
	;;^UTILITY(U,$J,"PRO",815,20)
	;;=D NEWFORM^IBDF6A
	;;^UTILITY(U,$J,"PRO",815,28)
	;;=Create Blank Form:
	;;^UTILITY(U,$J,"PRO",815,99)
	;;=55852,54043
	;;^UTILITY(U,$J,"PRO",816,0)
	;;=IBDF COPY FORM^Copy Form^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",816,1,0)
	;;=^^2^2^2930127^
	;;^UTILITY(U,$J,"PRO",816,1,1,0)
	;;=Allows the user to choose any form and and copy it, giving it a new name. 
	;;^UTILITY(U,$J,"PRO",816,1,2,0)
	;;=He can then add it to the clinic setup.
	;;^UTILITY(U,$J,"PRO",816,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",816,2,1,0)
	;;=CP
	;;^UTILITY(U,$J,"PRO",816,2,"B","CP",1)
	;;=
	;;^UTILITY(U,$J,"PRO",816,20)
	;;=D COPYFORM^IBDF6A
	;;^UTILITY(U,$J,"PRO",816,28)
	;;=Copy Form
	;;^UTILITY(U,$J,"PRO",816,99)
	;;=55852,54043
	;;^UTILITY(U,$J,"PRO",817,0)
	;;=IBDF ADD TO CLINIC SETUP^Add Form to Setup^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",817,1,0)
	;;=^^1^1^2930127^
	;;^UTILITY(U,$J,"PRO",817,1,1,0)
	;;=Allows the user to add a form to the clinic setup.
	;;^UTILITY(U,$J,"PRO",817,2,0)
	;;=^101.02A^2^2
	;;^UTILITY(U,$J,"PRO",817,2,1,0)
	;;=CS
	;;^UTILITY(U,$J,"PRO",817,2,2,0)
	;;=AC
	;;^UTILITY(U,$J,"PRO",817,2,"B","AC",2)
	;;=
	;;^UTILITY(U,$J,"PRO",817,2,"B","CS",1)
	;;=
