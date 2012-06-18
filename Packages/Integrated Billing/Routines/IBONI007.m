IBONI007	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",804,10,2,0)
	;;=810^MV^1^^^Move Block
	;;^UTILITY(U,$J,"PRO",804,10,2,"^")
	;;=IBDF MOVE BLOCK
	;;^UTILITY(U,$J,"PRO",804,10,3,0)
	;;=811^BS^3
	;;^UTILITY(U,$J,"PRO",804,10,3,"^")
	;;=IBDF RESIZE BLOCK (WHILE EDITING FORM)
	;;^UTILITY(U,$J,"PRO",804,10,4,0)
	;;=812^EB^7^^^Edit Block
	;;^UTILITY(U,$J,"PRO",804,10,4,"^")
	;;=IBDF DISPLAY FORM BLOCK FOR EDIT
	;;^UTILITY(U,$J,"PRO",804,10,5,0)
	;;=819^DB^8^^^Delete Block
	;;^UTILITY(U,$J,"PRO",804,10,5,"^")
	;;=IBDF DELETE A BLOCK
	;;^UTILITY(U,$J,"PRO",804,10,6,0)
	;;=824^EX^11^^^Exit
	;;^UTILITY(U,$J,"PRO",804,10,6,"^")
	;;=IBDF EXIT
	;;^UTILITY(U,$J,"PRO",804,10,7,0)
	;;=825^FH^4^^^Form Header
	;;^UTILITY(U,$J,"PRO",804,10,7,"^")
	;;=IBDF EDIT HEADER BLOCK
	;;^UTILITY(U,$J,"PRO",804,10,8,0)
	;;=828^NB^6^^^New Block
	;;^UTILITY(U,$J,"PRO",804,10,8,1)
	;;=New Block
	;;^UTILITY(U,$J,"PRO",804,10,8,"^")
	;;=IBDF CREATE EMPTY BLOCK
	;;^UTILITY(U,$J,"PRO",804,10,9,0)
	;;=833^RD^9^^^Re Display Screen
	;;^UTILITY(U,$J,"PRO",804,10,9,"^")
	;;=IBDF REDRAW FORM
	;;^UTILITY(U,$J,"PRO",804,10,11,0)
	;;=846^CB^9^^^Copy Other Form's Block
	;;^UTILITY(U,$J,"PRO",804,10,11,"^")
	;;=IBDF COPY FORM BLOCK
	;;^UTILITY(U,$J,"PRO",804,10,13,0)
	;;=852^SH^2^^^Shift Blocks
	;;^UTILITY(U,$J,"PRO",804,10,13,"^")
	;;=IBDF SHIFT BLOCKS
	;;^UTILITY(U,$J,"PRO",804,10,14,0)
	;;=1073^VD^10^^^View w/wo Data (Toggle)
	;;^UTILITY(U,$J,"PRO",804,10,14,"^")
	;;=IBDF VIEW FORM W/WO DATA
	;;^UTILITY(U,$J,"PRO",804,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",804,28)
	;;=Select Action:
	;;^UTILITY(U,$J,"PRO",804,99)
	;;=55852,56356
	;;^UTILITY(U,$J,"PRO",805,0)
	;;=IBDF SELECT TOOL KIT BLOCK^Add Tool Kit Block^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",805,1,0)
	;;=^^4^4^2930510^
	;;^UTILITY(U,$J,"PRO",805,1,1,0)
	;;= 
	;;^UTILITY(U,$J,"PRO",805,1,2,0)
	;;=Allows the user to select a block from the list of toolkit blocks. The
	;;^UTILITY(U,$J,"PRO",805,1,3,0)
	;;=block is then pasted to the form at a position given by the user. He can
	;;^UTILITY(U,$J,"PRO",805,1,4,0)
	;;=also change the header, size, and description of the block.
	;;^UTILITY(U,$J,"PRO",805,2,0)
	;;=^101.02A^2^2
	;;^UTILITY(U,$J,"PRO",805,2,1,0)
	;;=ST
	;;^UTILITY(U,$J,"PRO",805,2,2,0)
	;;=SB
	;;^UTILITY(U,$J,"PRO",805,2,"B","SB",2)
	;;=
	;;^UTILITY(U,$J,"PRO",805,2,"B","ST",1)
	;;=
	;;^UTILITY(U,$J,"PRO",805,20)
	;;=D SELECT^IBDF7
	;;^UTILITY(U,$J,"PRO",805,99)
	;;=55852,54050
	;;^UTILITY(U,$J,"PRO",806,0)
	;;=IBDF MENU FOR ADDING TOOL KIT BLOCK^Add Tool Kit Block^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",806,1,0)
	;;=^^2^2^2931015^^^
	;;^UTILITY(U,$J,"PRO",806,1,1,0)
	;;=A menu of actions available in connection with adding a block from the 
	;;^UTILITY(U,$J,"PRO",806,1,2,0)
	;;=tool kit to a form.
	;;^UTILITY(U,$J,"PRO",806,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",806,2,1,0)
	;;=AT
	;;^UTILITY(U,$J,"PRO",806,2,"B","AT",1)
	;;=
	;;^UTILITY(U,$J,"PRO",806,4)
	;;=40^4
	;;^UTILITY(U,$J,"PRO",806,10,0)
	;;=^101.01PA^3^3
	;;^UTILITY(U,$J,"PRO",806,10,1,0)
	;;=805^AT^2
	;;^UTILITY(U,$J,"PRO",806,10,1,"^")
	;;=IBDF SELECT TOOL KIT BLOCK
	;;^UTILITY(U,$J,"PRO",806,10,2,0)
	;;=807^VB^1
	;;^UTILITY(U,$J,"PRO",806,10,2,"^")
	;;=IBDF VIEW TOOL KIT BLOCK
	;;^UTILITY(U,$J,"PRO",806,10,3,0)
	;;=824^EX^3^^^Exit
	;;^UTILITY(U,$J,"PRO",806,10,3,"^")
	;;=IBDF EXIT
	;;^UTILITY(U,$J,"PRO",806,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",806,28)
	;;=Select Action:
	;;^UTILITY(U,$J,"PRO",806,99)
	;;=55852,56415
	;;^UTILITY(U,$J,"PRO",807,0)
	;;=IBDF VIEW TOOL KIT BLOCK^View Block^^A^^^^^^^^INTEGRATED BILLING
