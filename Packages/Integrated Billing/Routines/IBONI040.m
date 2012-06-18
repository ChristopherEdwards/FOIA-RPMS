IBONI040	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^UTILITY(U,$J,"PRO",1070,0)
	;;=IBDF ADD BLANK GROUP^Add Blank^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1070,1,0)
	;;=^^2^2^2931020^
	;;^UTILITY(U,$J,"PRO",1070,1,1,0)
	;;=Allows the user to add a group that has no displayable text - i.e., it is 
	;;^UTILITY(U,$J,"PRO",1070,1,2,0)
	;;=blank - serves to add space to the list.
	;;^UTILITY(U,$J,"PRO",1070,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",1070,2,1,0)
	;;=AB
	;;^UTILITY(U,$J,"PRO",1070,2,"B","AB",1)
	;;=
	;;^UTILITY(U,$J,"PRO",1070,20)
	;;=D ADDEMPTY^IBDF3
	;;^UTILITY(U,$J,"PRO",1070,99)
	;;=55852,54041
	;;^UTILITY(U,$J,"PRO",1071,0)
	;;=IBDF FORMAT ALL SELECTIONS^Format All^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1071,1,0)
	;;=^^1^1^2931020^
	;;^UTILITY(U,$J,"PRO",1071,1,1,0)
	;;=Allows the user to format all the selections on the selection list all at once.
	;;^UTILITY(U,$J,"PRO",1071,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",1071,2,1,0)
	;;=FA
	;;^UTILITY(U,$J,"PRO",1071,2,"B","FA",1)
	;;=
	;;^UTILITY(U,$J,"PRO",1071,20)
	;;=D FORMAT^IBDF9A1
	;;^UTILITY(U,$J,"PRO",1071,99)
	;;=55852,54047
	;;^UTILITY(U,$J,"PRO",1072,0)
	;;=IBDF FORMAT GROUP'S SELECTIONS^Format All^^A^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1072,1,0)
	;;=^^1^1^2931021^
	;;^UTILITY(U,$J,"PRO",1072,1,1,0)
	;;=Allows the user to format in mass all the selections in the group.
	;;^UTILITY(U,$J,"PRO",1072,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",1072,2,1,0)
	;;=FA
	;;^UTILITY(U,$J,"PRO",1072,2,"B","FA",1)
	;;=
	;;^UTILITY(U,$J,"PRO",1072,20)
	;;=D FORMAT2^IBDF9A1
	;;^UTILITY(U,$J,"PRO",1072,99)
	;;=55852,54047
	;;^UTILITY(U,$J,"PRO",1073,0)
	;;=IBDF VIEW FORM W/WO DATA^View w/wo Data (Toggle)^^A^^^^^^^^IB ENCOUNTER FORM
	;;^UTILITY(U,$J,"PRO",1073,1,0)
	;;=^^2^2^2931022^
	;;^UTILITY(U,$J,"PRO",1073,1,1,0)
	;;=Allows the user to either view the form with or without data. When viewing
	;;^UTILITY(U,$J,"PRO",1073,1,2,0)
	;;=with data the user must select a test patient.
	;;^UTILITY(U,$J,"PRO",1073,2,0)
	;;=^101.02A^1^1
	;;^UTILITY(U,$J,"PRO",1073,2,1,0)
	;;=VD
	;;^UTILITY(U,$J,"PRO",1073,2,"B","VD",1)
	;;=
	;;^UTILITY(U,$J,"PRO",1073,20)
	;;=D VIEW^IBDF5C
	;;^UTILITY(U,$J,"PRO",1073,99)
	;;=55852,54051
	;;^UTILITY(U,$J,"PRO",1074,0)
	;;=IBTRE  BI MENU^Claims Tracking for Billers Menu^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1074,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",1074,10,0)
	;;=^101.01PA^6^16
	;;^UTILITY(U,$J,"PRO",1074,10,1,0)
	;;=959^CP^32
	;;^UTILITY(U,$J,"PRO",1074,10,1,"^")
	;;=IBTRE CHANGE PATIENT
	;;^UTILITY(U,$J,"PRO",1074,10,5,0)
	;;=965^VE^20
	;;^UTILITY(U,$J,"PRO",1074,10,5,"^")
	;;=IBTRE VIEW/EDIT TRACKING
	;;^UTILITY(U,$J,"PRO",1074,10,9,0)
	;;=967^CD^34
	;;^UTILITY(U,$J,"PRO",1074,10,9,"^")
	;;=IBTRE CHANGE DATE
	;;^UTILITY(U,$J,"PRO",1074,10,11,0)
	;;=1036^SC^25
	;;^UTILITY(U,$J,"PRO",1074,10,11,"^")
	;;=IBTRE SHOW SC CONDITIONS
	;;^UTILITY(U,$J,"PRO",1074,10,13,0)
	;;=927^EX^41
	;;^UTILITY(U,$J,"PRO",1074,10,13,"^")
	;;=IBCNS EXIT
	;;^UTILITY(U,$J,"PRO",1074,10,16,0)
	;;=1067^BI^18
	;;^UTILITY(U,$J,"PRO",1074,10,16,"^")
	;;=IBTRE BILLING INFO
	;;^UTILITY(U,$J,"PRO",1074,15)
	;;=I $G(IBFASTXT)=1 S VALMBCK="Q"
	;;^UTILITY(U,$J,"PRO",1074,26)
	;;=D SHOW^VALM
	;;^UTILITY(U,$J,"PRO",1074,28)
	;;=Select Action: 
	;;^UTILITY(U,$J,"PRO",1074,99)
	;;=55817,42430
	;;^UTILITY(U,$J,"PRO",1075,0)
	;;=IBTRED  IR MENU^Expanded Claims tracking menu (IR)^^M^^^^^^^^INTEGRATED BILLING
	;;^UTILITY(U,$J,"PRO",1075,4)
	;;=26^4
	;;^UTILITY(U,$J,"PRO",1075,10,0)
	;;=^101.01PA^8^10
	;;^UTILITY(U,$J,"PRO",1075,10,1,0)
	;;=969^BI^11
	;;^UTILITY(U,$J,"PRO",1075,10,1,"^")
	;;=IBTRED BILLING INFO
