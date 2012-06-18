FHINI0O8	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"OPT",1826,1,1,0)
	;;=This option allows the user to list one selected Diet Pattern or
	;;^UTILITY(U,$J,"OPT",1826,1,2,0)
	;;=all the Diet Patterns entered through Enter/Edit Diet Patterns.
	;;^UTILITY(U,$J,"OPT",1826,25)
	;;=FHMTK2
	;;^UTILITY(U,$J,"OPT",1826,"U")
	;;=LIST DIET PATTERNS
	;;^UTILITY(U,$J,"OPT",1827,0)
	;;=FHMTKMM^Tray Tickets/Diet Cards Management^^M^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1827,1,0)
	;;=^^4^4^2950302^^^^
	;;^UTILITY(U,$J,"OPT",1827,1,1,0)
	;;=This menu consists of the options associated with Tray
	;;^UTILITY(U,$J,"OPT",1827,1,2,0)
	;;=Tickets and Diet Cards, including enter/edit the Diet Patterns,
	;;^UTILITY(U,$J,"OPT",1827,1,3,0)
	;;=Recipe categories, and meals and the printing of the Tray Tickets
	;;^UTILITY(U,$J,"OPT",1827,1,4,0)
	;;=and Diet Cards.
	;;^UTILITY(U,$J,"OPT",1827,10,0)
	;;=^19.01PI^8^8
	;;^UTILITY(U,$J,"OPT",1827,10,1,0)
	;;=1539^CE
	;;^UTILITY(U,$J,"OPT",1827,10,1,"^")
	;;=FHREC4
	;;^UTILITY(U,$J,"OPT",1827,10,2,0)
	;;=1825^DP
	;;^UTILITY(U,$J,"OPT",1827,10,2,"^")
	;;=FHMTKS
	;;^UTILITY(U,$J,"OPT",1827,10,3,0)
	;;=1826^LP
	;;^UTILITY(U,$J,"OPT",1827,10,3,"^")
	;;=FHMTKT
	;;^UTILITY(U,$J,"OPT",1827,10,4,0)
	;;=1524^ME
	;;^UTILITY(U,$J,"OPT",1827,10,4,"^")
	;;=FHPRC4
	;;^UTILITY(U,$J,"OPT",1827,10,5,0)
	;;=1526^ML
	;;^UTILITY(U,$J,"OPT",1827,10,5,"^")
	;;=FHPRC6
	;;^UTILITY(U,$J,"OPT",1827,10,6,0)
	;;=1821^PD
	;;^UTILITY(U,$J,"OPT",1827,10,6,"^")
	;;=FHDCRP
	;;^UTILITY(U,$J,"OPT",1827,10,7,0)
	;;=1818^PT
	;;^UTILITY(U,$J,"OPT",1827,10,7,"^")
	;;=FHMTKP
	;;^UTILITY(U,$J,"OPT",1827,10,8,0)
	;;=1540^CL
	;;^UTILITY(U,$J,"OPT",1827,10,8,"^")
	;;=FHREC5
	;;^UTILITY(U,$J,"OPT",1827,99)
	;;=56496,40774
	;;^UTILITY(U,$J,"OPT",1827,"U")
	;;=TRAY TICKETS/DIET CARDS MANAGE
	;;^UTILITY(U,$J,"OPT",1828,0)
	;;=FHMTKN^List Inpats With No/prev Patterns^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1828,1,0)
	;;=^^6^6^2950719^^^^
	;;^UTILITY(U,$J,"OPT",1828,1,1,0)
	;;=This option allows the user to run two listings.  One list
	;;^UTILITY(U,$J,"OPT",1828,1,2,0)
	;;=consists of all the inpatients that do not have any Diet
	;;^UTILITY(U,$J,"OPT",1828,1,3,0)
	;;=Pattern that match with their current-diet.  The second list
	;;^UTILITY(U,$J,"OPT",1828,1,4,0)
	;;=consists of a listing of inpatients that do not have a current
	;;^UTILITY(U,$J,"OPT",1828,1,5,0)
	;;=individual pattern but have had a individual pattern for a 
	;;^UTILITY(U,$J,"OPT",1828,1,6,0)
	;;=previous Diet order.
	;;^UTILITY(U,$J,"OPT",1828,25)
	;;=FHMTK5
	;;^UTILITY(U,$J,"OPT",1828,"U")
	;;=LIST INPATS WITH NO/PREV PATTE
	;;^UTILITY(U,$J,"OPT",1829,0)
	;;=FHMTKH^History of Diet Patterns^^R^^^^^^^^DIETETICS
	;;^UTILITY(U,$J,"OPT",1829,1,0)
	;;=^^3^3^2950719^^^^
	;;^UTILITY(U,$J,"OPT",1829,1,1,0)
	;;=This option will display all Diet Patterns entered for
	;;^UTILITY(U,$J,"OPT",1829,1,2,0)
	;;=the patient's admission and allow user to add a previous
	;;^UTILITY(U,$J,"OPT",1829,1,3,0)
	;;=Diet Pattern to a patient's current-diet.
	;;^UTILITY(U,$J,"OPT",1829,25)
	;;=FHMTK6
	;;^UTILITY(U,$J,"OPT",1829,"U")
	;;=HISTORY OF DIET PATTERNS
	;;^UTILITY(U,$J,"OR",22,0)
	;;=22^^1^DIETETICS^1
	;;^UTILITY(U,$J,"PKG",22,0)
	;;=DIETETICS^FH^Dietetics System
	;;^UTILITY(U,$J,"PKG",22,2,0)
	;;=^9.42PLA^^0
	;;^UTILITY(U,$J,"PKG",22,4,0)
	;;=^9.44PA^47^46
	;;^UTILITY(U,$J,"PKG",22,4,1,0)
	;;=111
	;;^UTILITY(U,$J,"PKG",22,4,1,222)
	;;=y^y^^n^^^y^m^y
	;;^UTILITY(U,$J,"PKG",22,4,1,222.7)
	;;=N
	;;^UTILITY(U,$J,"PKG",22,4,2,0)
	;;=112
	;;^UTILITY(U,$J,"PKG",22,4,2,222)
	;;=y^y^^n^^^y^o^n
	;;^UTILITY(U,$J,"PKG",22,4,2,222.7)
	;;=Y
	;;^UTILITY(U,$J,"PKG",22,4,2,222.9)
	;;=Y
	;;^UTILITY(U,$J,"PKG",22,4,3,0)
	;;=112.2
	;;^UTILITY(U,$J,"PKG",22,4,3,222)
	;;=y^y^^n^^^y^o^n
	;;^UTILITY(U,$J,"PKG",22,4,3,222.7)
	;;=Y
	;;^UTILITY(U,$J,"PKG",22,4,4,0)
	;;=112.6
	;;^UTILITY(U,$J,"PKG",22,4,4,222)
	;;=y^y^^n^^^n
	;;^UTILITY(U,$J,"PKG",22,4,4,222.7)
	;;=N
	;;^UTILITY(U,$J,"PKG",22,4,5,0)
	;;=115
	;;^UTILITY(U,$J,"PKG",22,4,5,222)
	;;=y^y^^n^^^n
	;;^UTILITY(U,$J,"PKG",22,4,5,222.7)
	;;=N
	;;^UTILITY(U,$J,"PKG",22,4,6,0)
	;;=118
	;;^UTILITY(U,$J,"PKG",22,4,6,222)
	;;=y^y^^n^^^y^m^y
	;;^UTILITY(U,$J,"PKG",22,4,6,222.7)
	;;=N
	;;^UTILITY(U,$J,"PKG",22,4,7,0)
	;;=118.1
	;;^UTILITY(U,$J,"PKG",22,4,7,222)
	;;=y^y^^n^^^y^m^y
	;;^UTILITY(U,$J,"PKG",22,4,7,222.7)
	;;=N
	;;^UTILITY(U,$J,"PKG",22,4,8,0)
	;;=119.9
	;;^UTILITY(U,$J,"PKG",22,4,8,222)
	;;=y^y^^n^^^y^m^y
	;;^UTILITY(U,$J,"PKG",22,4,8,222.7)
	;;=N
	;;^UTILITY(U,$J,"PKG",22,4,9,0)
	;;=119.1
	;;^UTILITY(U,$J,"PKG",22,4,9,222)
	;;=y^y^^n^^^y^m^y
	;;^UTILITY(U,$J,"PKG",22,4,9,222.7)
	;;=N
	;;^UTILITY(U,$J,"PKG",22,4,10,0)
	;;=119.5
