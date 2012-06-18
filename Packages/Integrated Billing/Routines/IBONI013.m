IBONI013	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",839,10,9,0)
	;;=831^NM^2^^^Form Name/Descr/Size
	;;^UTILITY(U,$J,"PRO",839,10,9,"^")
	;;=IBDF EDIT FORM NAME/DESCR/SIZE
	;;^UTILITY(U,$J,"PRO",839,10,10,0)
	;;=840^DF^3^^^Delete Form
	;;^UTILITY(U,$J,"PRO",839,10,10,"^")
	;;=IBDF DELETE TOOL KIT FORM
	;;^UTILITY(U,$J,"PRO",839,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",839,28)
	;;=Select Action:
	;;^UTILITY(U,$J,"PRO",839,99)
	;;=55852,54051
	;;^UTILITY(U,$J,"PRO",840,0)
	;;=IBDF DELETE TOOL KIT FORM^Delete Form^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",840,1,0)
	;;=^^1^1^2930624^
	;;^UTILITY(U,$J,"PRO",840,1,1,0)
	;;=Allows the user to delete a form from the tool kit.
	;;^UTILITY(U,$J,"PRO",840,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",840,2,1,0)
	;;=DT
	;;^UTILITY(U,$J,"PRO",840,2,"B","DT",1)
	;;=
	;;^UTILITY(U,$J,"PRO",840,20)
	;;=D DELFORM^IBDF12
	;;^UTILITY(U,$J,"PRO",840,99)
	;;=55852,54043
	;;^UTILITY(U,$J,"PRO",841,0)
	;;=IBDF EDIT TOOL KIT BLOCKS MENU^EDIT TOOL KIT BLOCKS MENU^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",841,1,0)
	;;=^^1^1^2930624^^^^
	;;^UTILITY(U,$J,"PRO",841,1,1,0)
	;;=Allows the user to edit tool kit blocks.
	;;^UTILITY(U,$J,"PRO",841,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",841,2,1,0)
	;;=EB
	;;^UTILITY(U,$J,"PRO",841,2,"B","EB",1)
	;;=
	;;^UTILITY(U,$J,"PRO",841,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",841,10,0)
	;;=^101.01PA^5^9
	;;^UTILITY(U,$J,"PRO",841,10,10,0)
	;;=842^EB^^^^Edit Block
	;;^UTILITY(U,$J,"PRO",841,10,10,"^")
	;;=IBDF EDIT TOOL KIT BLOCK
	;;^UTILITY(U,$J,"PRO",841,10,11,0)
	;;=843^NB^^^^New Block
	;;^UTILITY(U,$J,"PRO",841,10,11,"^")
	;;=IBDF NEW TOOL KIT BLOCK
	;;^UTILITY(U,$J,"PRO",841,10,12,0)
	;;=844^DB^^^^Delete Block
	;;^UTILITY(U,$J,"PRO",841,10,12,"^")
	;;=IBDF DELETE TOOL KIT BLOCK
	;;^UTILITY(U,$J,"PRO",841,10,13,0)
	;;=845^CB^^^^Copy Block
	;;^UTILITY(U,$J,"PRO",841,10,13,"^")
	;;=IBDF COPY BLOCK INTO TOOL KIT
	;;^UTILITY(U,$J,"PRO",841,10,14,0)
	;;=875^CH^^^^Change TK Order
	;;^UTILITY(U,$J,"PRO",841,10,14,"^")
	;;=IBDF CHANGE BLOCK TK ORDER
	;;^UTILITY(U,$J,"PRO",841,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",841,28)
	;;=Select Action:
	;;^UTILITY(U,$J,"PRO",841,99)
	;;=55950,49063
	;;^UTILITY(U,$J,"PRO",842,0)
	;;=IBDF EDIT TOOL KIT BLOCK^Edit Block^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",842,1,0)
	;;=^^1^1^2930727^^^
	;;^UTILITY(U,$J,"PRO",842,1,1,0)
	;;=Allows the user to edit a tool kit block.
	;;^UTILITY(U,$J,"PRO",842,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",842,2,1,0)
	;;=EB
	;;^UTILITY(U,$J,"PRO",842,2,"B","EB",1)
	;;=
	;;^UTILITY(U,$J,"PRO",842,15)
	;;=I $G(IBFASTXT) S VALMBCK="Q"
	;;^UTILITY(U,$J,"PRO",842,20)
	;;=D EDITBLK^IBDF13
	;;^UTILITY(U,$J,"PRO",842,99)
	;;=55852,54046
	;;^UTILITY(U,$J,"PRO",843,0)
	;;=IBDF NEW TOOL KIT BLOCK^New Block^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",843,1,0)
	;;=^^1^1^2930624^
	;;^UTILITY(U,$J,"PRO",843,1,1,0)
	;;=Allows the user to create a new tool kit block.
	;;^UTILITY(U,$J,"PRO",843,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",843,2,1,0)
	;;=NB
	;;^UTILITY(U,$J,"PRO",843,2,"B","NB",1)
	;;=
	;;^UTILITY(U,$J,"PRO",843,20)
	;;=D NEWBLK^IBDF13
	;;^UTILITY(U,$J,"PRO",843,99)
	;;=55852,54049
	;;^UTILITY(U,$J,"PRO",844,0)
	;;=IBDF DELETE TOOL KIT BLOCK^Delete Block^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",844,1,0)
	;;=^^1^1^2930625^
	;;^UTILITY(U,$J,"PRO",844,1,1,0)
	;;=Allows the user to delete a block from the tool kit.
	;;^UTILITY(U,$J,"PRO",844,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",844,2,1,0)
	;;=DB
	;;^UTILITY(U,$J,"PRO",844,2,"B","DB",1)
	;;=
	;;^UTILITY(U,$J,"PRO",844,20)
	;;=D DLTBLOCK^IBDF13
