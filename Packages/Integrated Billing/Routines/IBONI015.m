IBONI015	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",858,10,5,"^")
	;;=IBDE EDIT FORM'S IMP/EXP NOTES
	;;^UTILITY(U,$J,"PRO",858,10,6,0)
	;;=863^VI^7^^^View Imp/Exp Notes
	;;^UTILITY(U,$J,"PRO",858,10,6,"^")
	;;=IBDE VIEW FORM'S IMP/EXP NOTES
	;;^UTILITY(U,$J,"PRO",858,10,7,0)
	;;=864^IE^3^^^Import Entry
	;;^UTILITY(U,$J,"PRO",858,10,7,"^")
	;;=IBDE IMPORT FORM
	;;^UTILITY(U,$J,"PRO",858,10,8,0)
	;;=865^HE^1^^^Help
	;;^UTILITY(U,$J,"PRO",858,10,8,"^")
	;;=IBDE IMP/EXP HELP
	;;^UTILITY(U,$J,"PRO",858,10,9,0)
	;;=866^DI^9^^^DIFROM
	;;^UTILITY(U,$J,"PRO",858,10,9,"^")
	;;=IBDE EXECUTE DIFROM
	;;^UTILITY(U,$J,"PRO",858,10,10,0)
	;;=867^RI^10^^^Run Inits
	;;^UTILITY(U,$J,"PRO",858,10,10,"^")
	;;=IBDE EXECUTE INITS
	;;^UTILITY(U,$J,"PRO",858,10,11,0)
	;;=869^LB^2^^^List TK Blocks
	;;^UTILITY(U,$J,"PRO",858,10,11,"^")
	;;=IBDE DISPLAY TK BLOCKS
	;;^UTILITY(U,$J,"PRO",858,20)
	;;=
	;;^UTILITY(U,$J,"PRO",858,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",858,28)
	;;=Select Action:
	;;^UTILITY(U,$J,"PRO",858,99)
	;;=55852,56604
	;;^UTILITY(U,$J,"PRO",859,0)
	;;=IBDE ADD FORM TO IMP/EXP WS^Add Entry^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",859,.1)
	;;=
	;;^UTILITY(U,$J,"PRO",859,1,0)
	;;=^^1^1^2930813^^
	;;^UTILITY(U,$J,"PRO",859,1,1,0)
	;;=Allows the user to add a form to the IMP/EXP files.
	;;^UTILITY(U,$J,"PRO",859,2,0)
	;;=^101.02A^3^3
	;;^UTILITY(U,$J,"PRO",859,2,1,0)
	;;=TEST
	;;^UTILITY(U,$J,"PRO",859,2,2,0)
	;;=ADD
	;;^UTILITY(U,$J,"PRO",859,2,3,0)
	;;=AW
	;;^UTILITY(U,$J,"PRO",859,2,"B","ADD",2)
	;;=
	;;^UTILITY(U,$J,"PRO",859,2,"B","AW",3)
	;;=
	;;^UTILITY(U,$J,"PRO",859,2,"B","TEST",1)
	;;=
	;;^UTILITY(U,$J,"PRO",859,20)
	;;=D ADD^IBDE1
	;;^UTILITY(U,$J,"PRO",859,99)
	;;=55789,49845
	;;^UTILITY(U,$J,"PRO",860,0)
	;;=IBDE DELETE FORM FROM IMP/EXP FILES^Delete Entry^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",860,1,0)
	;;=^^1^1^2930813^
	;;^UTILITY(U,$J,"PRO",860,1,1,0)
	;;=Allows the user to select a form in the imp/exp files and deletes it.
	;;^UTILITY(U,$J,"PRO",860,2,0)
	;;=^101.02A^2^2
	;;^UTILITY(U,$J,"PRO",860,2,1,0)
	;;=DEL
	;;^UTILITY(U,$J,"PRO",860,2,2,0)
	;;=DW
	;;^UTILITY(U,$J,"PRO",860,2,"B","DEL",1)
	;;=
	;;^UTILITY(U,$J,"PRO",860,2,"B","DW",2)
	;;=
	;;^UTILITY(U,$J,"PRO",860,20)
	;;=D DELETE^IBDE1
	;;^UTILITY(U,$J,"PRO",860,99)
	;;=55789,49858
	;;^UTILITY(U,$J,"PRO",861,0)
	;;=IBDE DELETE IMP/EXP FILES^Clear Work Space^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",861,1,0)
	;;=^^1^1^2930813^^
	;;^UTILITY(U,$J,"PRO",861,1,1,0)
	;;=Deletes all of the imp/exp files (358 range).
	;;^UTILITY(U,$J,"PRO",861,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",861,2,1,0)
	;;=CW
	;;^UTILITY(U,$J,"PRO",861,2,"B","CW",1)
	;;=
	;;^UTILITY(U,$J,"PRO",861,20)
	;;=D DLTALL^IBDE2
	;;^UTILITY(U,$J,"PRO",861,99)
	;;=55742,27560
	;;^UTILITY(U,$J,"PRO",862,0)
	;;=IBDE EDIT FORM'S IMP/EXP NOTES^Edit Imp/Exp Notes^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",862,1,0)
	;;=^^2^2^2930813^^
	;;^UTILITY(U,$J,"PRO",862,1,1,0)
	;;=Allows the user to select a form form from the imp/exp files, then allows
	;;^UTILITY(U,$J,"PRO",862,1,2,0)
	;;=the user to edit the imp/exp notes.
	;;^UTILITY(U,$J,"PRO",862,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",862,2,1,0)
	;;=EE
	;;^UTILITY(U,$J,"PRO",862,2,"B","EE",1)
	;;=
	;;^UTILITY(U,$J,"PRO",862,20)
	;;=D EDIT^IBDE1
	;;^UTILITY(U,$J,"PRO",862,99)
	;;=55789,49908
	;;^UTILITY(U,$J,"PRO",863,0)
	;;=IBDE VIEW FORM'S IMP/EXP NOTES^View Imp/Exp Notes^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",863,1,0)
	;;=^^2^2^2930813^
	;;^UTILITY(U,$J,"PRO",863,1,1,0)
	;;=Allows the user to select a form from the IMP/EXP files, then displays
