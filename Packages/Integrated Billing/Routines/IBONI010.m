IBONI010	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",817,20)
	;;=D SETUP^IBDF6A
	;;^UTILITY(U,$J,"PRO",817,28)
	;;=Add To Setup
	;;^UTILITY(U,$J,"PRO",817,99)
	;;=55852,54041
	;;^UTILITY(U,$J,"PRO",818,0)
	;;=IBDF DELETE FROM CLINIC SETUP^Delete from Setup^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",818,1,0)
	;;=^^1^1^2930127^
	;;^UTILITY(U,$J,"PRO",818,1,1,0)
	;;=Allows the user to select a form and deletes it from the clinic setup.
	;;^UTILITY(U,$J,"PRO",818,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",818,2,1,0)
	;;=DC
	;;^UTILITY(U,$J,"PRO",818,2,"B","DC",1)
	;;=
	;;^UTILITY(U,$J,"PRO",818,20)
	;;=D DSETUP^IBDF6C
	;;^UTILITY(U,$J,"PRO",818,28)
	;;=Delete From Clinic Setup:
	;;^UTILITY(U,$J,"PRO",818,99)
	;;=55852,54043
	;;^UTILITY(U,$J,"PRO",819,0)
	;;=IBDF DELETE A BLOCK^Delete Block^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",819,1,0)
	;;=^^1^1^2930127^^
	;;^UTILITY(U,$J,"PRO",819,1,1,0)
	;;=Allows the user to select a block from the form and delete it.
	;;^UTILITY(U,$J,"PRO",819,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",819,2,1,0)
	;;=DB
	;;^UTILITY(U,$J,"PRO",819,2,"B","DB",1)
	;;=
	;;^UTILITY(U,$J,"PRO",819,20)
	;;=D DELETE^IBDF5
	;;^UTILITY(U,$J,"PRO",819,28)
	;;=Delete a Block:
	;;^UTILITY(U,$J,"PRO",819,99)
	;;=55852,54043
	;;^UTILITY(U,$J,"PRO",820,0)
	;;=IBDF RESIZE BLOCK (WHILE EDITING BLOCK)^Block Size^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",820,1,0)
	;;=^^2^2^2930510^
	;;^UTILITY(U,$J,"PRO",820,1,1,0)
	;;=This allows the user to change the height and width of the block while he
	;;^UTILITY(U,$J,"PRO",820,1,2,0)
	;;=is editing the block.
	;;^UTILITY(U,$J,"PRO",820,2,0)
	;;=^101.02A^2^2
	;;^UTILITY(U,$J,"PRO",820,2,1,0)
	;;=RS
	;;^UTILITY(U,$J,"PRO",820,2,2,0)
	;;=BS
	;;^UTILITY(U,$J,"PRO",820,2,"B","BS",2)
	;;=
	;;^UTILITY(U,$J,"PRO",820,2,"B","RS",1)
	;;=
	;;^UTILITY(U,$J,"PRO",820,20)
	;;=D RESIZE^IBDF9
	;;^UTILITY(U,$J,"PRO",820,99)
	;;=55852,54049
	;;^UTILITY(U,$J,"PRO",821,0)
	;;=IBDF EDIT NAME,HEADER,OUTLINE^Header/Descr/Outline^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",821,1,0)
	;;=^^1^1^2930201^
	;;^UTILITY(U,$J,"PRO",821,1,1,0)
	;;=Allows editing of the block header and outline type.
	;;^UTILITY(U,$J,"PRO",821,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",821,2,1,0)
	;;=EH
	;;^UTILITY(U,$J,"PRO",821,2,"B","EH",1)
	;;=
	;;^UTILITY(U,$J,"PRO",821,20)
	;;=D EDITBLK^IBDF9
	;;^UTILITY(U,$J,"PRO",821,99)
	;;=55852,54045
	;;^UTILITY(U,$J,"PRO",822,0)
	;;=IBDF DATA FIELD^Data Field^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",822,1,0)
	;;=^^2^2^2930322^
	;;^UTILITY(U,$J,"PRO",822,1,1,0)
	;;=Allows the user to create a new data field or edit or delete an already
	;;^UTILITY(U,$J,"PRO",822,1,2,0)
	;;=existing one.
	;;^UTILITY(U,$J,"PRO",822,2,0)
	;;=^101.02A^2^1
	;;^UTILITY(U,$J,"PRO",822,2,2,0)
	;;=DF
	;;^UTILITY(U,$J,"PRO",822,2,"B","DF",2)
	;;=
	;;^UTILITY(U,$J,"PRO",822,20)
	;;=D FIELD^IBDF9B
	;;^UTILITY(U,$J,"PRO",822,99)
	;;=55852,54043
	;;^UTILITY(U,$J,"PRO",823,0)
	;;=IBDF STRAIGHT LINE^Straight Line^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",823,1,0)
	;;=^^2^2^2930324^^
	;;^UTILITY(U,$J,"PRO",823,1,1,0)
	;;=Allows a straight line, either horizontal or vertical, to be created,
	;;^UTILITY(U,$J,"PRO",823,1,2,0)
	;;=deleted or edited.
	;;^UTILITY(U,$J,"PRO",823,2,0)
	;;=^101.02A^2^1
	;;^UTILITY(U,$J,"PRO",823,2,2,0)
	;;=LN
	;;^UTILITY(U,$J,"PRO",823,2,"B","LN",2)
	;;=
	;;^UTILITY(U,$J,"PRO",823,20)
	;;=D LINE^IBDF9D
	;;^UTILITY(U,$J,"PRO",823,99)
	;;=55852,54050
	;;^UTILITY(U,$J,"PRO",824,0)
	;;=IBDF EXIT^Exit^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",824,1,0)
	;;=^^2^2^2930817^^^^
