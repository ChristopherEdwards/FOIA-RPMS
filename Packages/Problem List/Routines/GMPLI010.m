GMPLI010	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLDISP",3)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLEDIT",5)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLEDT1",6)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLEDT2",7)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLEDT3",18)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLEDT4",25)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLENFM",15)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLHIST",19)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLHS",20)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLHSPL",21)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLMENU",30)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLMGR",9)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLMGR1",10)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLMGR2",36)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLPREF",24)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLPRF0",39)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLPRF1",28)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLPRNT",13)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLRPTR",38)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLRPTS",26)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLSAVE",11)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLUTL",22)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLUTL1",40)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLX",12)
	;;=
	;;^UTILITY(U,$J,"PKG",219,2,"B","GMPLX1",27)
	;;=
	;;^UTILITY(U,$J,"PKG",219,3,0)
	;;=^9.43^3^2
	;;^UTILITY(U,$J,"PKG",219,3,1,0)
	;;=AUPNPROB
	;;^UTILITY(U,$J,"PKG",219,3,1,4,0)
	;;=^^4^4^2940527^^^^
	;;^UTILITY(U,$J,"PKG",219,3,1,4,1,0)
	;;=Originally exported by the Indian Health Service (IHS) as part of the
	;;^UTILITY(U,$J,"PKG",219,3,1,4,2,0)
	;;=Patient Care Component (PCC), this global contains the Problem File
	;;^UTILITY(U,$J,"PKG",219,3,1,4,3,0)
	;;=#9000011; all of the patient problem data making up the problem list
	;;^UTILITY(U,$J,"PKG",219,3,1,4,4,0)
	;;=is stored here.
	;;^UTILITY(U,$J,"PKG",219,3,1,5)
	;;=
	;;^UTILITY(U,$J,"PKG",219,3,3,0)
	;;=GMPL
	;;^UTILITY(U,$J,"PKG",219,3,3,4,0)
	;;=^^2^2^2940825^^^^
	;;^UTILITY(U,$J,"PKG",219,3,3,4,1,0)
	;;=This global contains files in the 125 numberspace that support the
	;;^UTILITY(U,$J,"PKG",219,3,3,4,2,0)
	;;=Problem List application.
	;;^UTILITY(U,$J,"PKG",219,3,"B","AUPNPROB",1)
	;;=
	;;^UTILITY(U,$J,"PKG",219,3,"B","GMPL",3)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,0)
	;;=^9.44PA^16^9
	;;^UTILITY(U,$J,"PKG",219,4,3,0)
	;;=125.8
	;;^UTILITY(U,$J,"PKG",219,4,3,222)
	;;=y^y^^y^^^n
	;;^UTILITY(U,$J,"PKG",219,4,4,0)
	;;=9000011
	;;^UTILITY(U,$J,"PKG",219,4,4,222)
	;;=y^y^^y^^^n
	;;^UTILITY(U,$J,"PKG",219,4,6,0)
	;;=125.99
	;;^UTILITY(U,$J,"PKG",219,4,6,222)
	;;=y^y^^y^^^y^m^y
	;;^UTILITY(U,$J,"PKG",219,4,7,0)
	;;=49
	;;^UTILITY(U,$J,"PKG",219,4,7,1,0)
	;;=^9.45A^2^2
	;;^UTILITY(U,$J,"PKG",219,4,7,1,1,0)
	;;=PARENT SERVICE
	;;^UTILITY(U,$J,"PKG",219,4,7,1,2,0)
	;;=TYPE OF SERVICE
	;;^UTILITY(U,$J,"PKG",219,4,7,1,"B","PARENT SERVICE",1)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,7,1,"B","TYPE OF SERVICE",2)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,7,222)
	;;=y^^^y^^^n
	;;^UTILITY(U,$J,"PKG",219,4,8,0)
	;;=200
	;;^UTILITY(U,$J,"PKG",219,4,8,1,0)
	;;=^9.45A^5^2
	;;^UTILITY(U,$J,"PKG",219,4,8,1,1,0)
	;;=PROBLEM LIST PRIMARY VIEW
	;;^UTILITY(U,$J,"PKG",219,4,8,1,5,0)
	;;=PROBLEM SELECTION LIST
	;;^UTILITY(U,$J,"PKG",219,4,8,1,"B","PROBLEM LIST PRIMARY VIEW",1)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,8,1,"B","PROBLEM SELECTION LIST",5)
	;;=
	;;^UTILITY(U,$J,"PKG",219,4,8,222)
	;;=y^^^y^^^n
	;;^UTILITY(U,$J,"PKG",219,4,13,0)
	;;=125
	;;^UTILITY(U,$J,"PKG",219,4,13,222)
	;;=y^y^^y^^^n
	;;^UTILITY(U,$J,"PKG",219,4,14,0)
	;;=125.1
	;;^UTILITY(U,$J,"PKG",219,4,14,222)
	;;=y^y^^y^^^n
