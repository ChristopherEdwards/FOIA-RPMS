IBONI034	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",1016,99)
	;;=55760,74741
	;;^UTILITY(U,$J,"PRO",1017,0)
	;;=IBTRPR CLAIMS TRACKING^Claims Tracking Edit^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1017,20)
	;;=D NX^IBTRPR1("IBT EXPAND/EDIT TRACKING")
	;;^UTILITY(U,$J,"PRO",1017,99)
	;;=55760,74741
	;;^UTILITY(U,$J,"PRO",1018,0)
	;;=IBTRPR REMOVE FROM LIST^Remove from List^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1018,20)
	;;=D RL^IBTRPR1
	;;^UTILITY(U,$J,"PRO",1018,99)
	;;=55760,74741
	;;^UTILITY(U,$J,"PRO",1019,0)
	;;=IBTRD  MENU^Appeal/Denial Menu^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1019,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",1019,10,0)
	;;=^101.01PA^8^8
	;;^UTILITY(U,$J,"PRO",1019,10,1,0)
	;;=1020^VE^11
	;;^UTILITY(U,$J,"PRO",1019,10,1,"^")
	;;=IBTRD VIEW EDIT DENIAL
	;;^UTILITY(U,$J,"PRO",1019,10,2,0)
	;;=1022^QE^12
	;;^UTILITY(U,$J,"PRO",1019,10,2,"^")
	;;=IBTRD QUICK EDIT
	;;^UTILITY(U,$J,"PRO",1019,10,3,0)
	;;=1021^AA^21
	;;^UTILITY(U,$J,"PRO",1019,10,3,"^")
	;;=IBTRD ADD APPEAL
	;;^UTILITY(U,$J,"PRO",1019,10,4,0)
	;;=1023^DA^22
	;;^UTILITY(U,$J,"PRO",1019,10,4,"^")
	;;=IBTRD DELETE APPEAL/DENIAL
	;;^UTILITY(U,$J,"PRO",1019,10,5,0)
	;;=1025^PI^31
	;;^UTILITY(U,$J,"PRO",1019,10,5,"^")
	;;=IBTRD PATIENT INS. EDIT
	;;^UTILITY(U,$J,"PRO",1019,10,6,0)
	;;=1024^IC^32
	;;^UTILITY(U,$J,"PRO",1019,10,6,"^")
	;;=IBTRD VIEW INS. CO
	;;^UTILITY(U,$J,"PRO",1019,10,7,0)
	;;=1037^SC^25
	;;^UTILITY(U,$J,"PRO",1019,10,7,"^")
	;;=IBTRD SHOW SC CONDITIONS
	;;^UTILITY(U,$J,"PRO",1019,10,8,0)
	;;=927^EX^41
	;;^UTILITY(U,$J,"PRO",1019,10,8,"^")
	;;=IBCNS EXIT
	;;^UTILITY(U,$J,"PRO",1019,15)
	;;=I $G(IBFASTXT)=1 S VALMBCK="Q"
	;;^UTILITY(U,$J,"PRO",1019,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",1019,28)
	;;=Select Action: 
	;;^UTILITY(U,$J,"PRO",1019,99)
	;;=55775,36782
	;;^UTILITY(U,$J,"PRO",1020,0)
	;;=IBTRD VIEW EDIT DENIAL^View Edit Entry^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1020,20)
	;;=D NX^IBTRD1("IBT EXPAND/EDIT DENIALS")
	;;^UTILITY(U,$J,"PRO",1020,99)
	;;=55760,74729
	;;^UTILITY(U,$J,"PRO",1021,0)
	;;=IBTRD ADD APPEAL^Add Appeal^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1021,20)
	;;=D AA^IBTRD1
	;;^UTILITY(U,$J,"PRO",1021,99)
	;;=55760,74729
	;;^UTILITY(U,$J,"PRO",1022,0)
	;;=IBTRD QUICK EDIT^Quick Edit^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1022,20)
	;;=D QE^IBTRD1
	;;^UTILITY(U,$J,"PRO",1022,99)
	;;=55760,74729
	;;^UTILITY(U,$J,"PRO",1023,0)
	;;=IBTRD DELETE APPEAL/DENIAL^Delete Appeal/Denial^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1023,20)
	;;=D DT^IBTRD1
	;;^UTILITY(U,$J,"PRO",1023,99)
	;;=55760,74729
	;;^UTILITY(U,$J,"PRO",1024,0)
	;;=IBTRD VIEW INS. CO^Ins. Co. Edit^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1024,20)
	;;=D NX^IBTRD1("IBCNS INSURANCE COMPANY")
	;;^UTILITY(U,$J,"PRO",1024,99)
	;;=55760,74729
	;;^UTILITY(U,$J,"PRO",1025,0)
	;;=IBTRD PATIENT INS. EDIT^Patient Ins. Edit.^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1025,20)
	;;=D NX^IBTRD1("IBCNS PATIENT INSURANCE")
	;;^UTILITY(U,$J,"PRO",1025,99)
	;;=55760,74729
	;;^UTILITY(U,$J,"PRO",1026,0)
	;;=IBTRDD  MENU^Expanded Appeals/Denials Main Menu^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1026,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",1026,10,0)
	;;=^101.01PA^7^7
	;;^UTILITY(U,$J,"PRO",1026,10,1,0)
	;;=1027^AI^22
	;;^UTILITY(U,$J,"PRO",1026,10,1,"^")
	;;=IBTRDD ACTION INFO
	;;^UTILITY(U,$J,"PRO",1026,10,2,0)
	;;=1028^AA^11
	;;^UTILITY(U,$J,"PRO",1026,10,2,"^")
	;;=IBTRDD APPEAL INFO
	;;^UTILITY(U,$J,"PRO",1026,10,3,0)
	;;=1029^AC^31
	;;^UTILITY(U,$J,"PRO",1026,10,3,"^")
	;;=IBTRDD COMMENT INFO