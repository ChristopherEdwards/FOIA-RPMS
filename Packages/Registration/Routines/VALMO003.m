VALMO003 ; ; 13-AUG-1993
 ;;1;List Manager;;Aug 13, 1993
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PRO",662,10,8,"^")
 ;;=VALM RIGHT
 ;;^UTILITY(U,$J,"PRO",662,10,9,0)
 ;;=660^<^16
 ;;^UTILITY(U,$J,"PRO",662,10,9,"^")
 ;;=VALM LEFT
 ;;^UTILITY(U,$J,"PRO",662,10,10,0)
 ;;=646^ADPL^32
 ;;^UTILITY(U,$J,"PRO",662,10,10,"^")
 ;;=VALM TURN ON/OFF MENUS
 ;;^UTILITY(U,$J,"PRO",662,10,11,0)
 ;;=648^SL^31
 ;;^UTILITY(U,$J,"PRO",662,10,11,"^")
 ;;=VALM SEARCH LIST
 ;;^UTILITY(U,$J,"PRO",662,10,12,0)
 ;;=642^QU^33
 ;;^UTILITY(U,$J,"PRO",662,10,12,"^")
 ;;=VALM QUIT
 ;;^UTILITY(U,$J,"PRO",662,10,13,0)
 ;;=637^LS^22
 ;;^UTILITY(U,$J,"PRO",662,10,13,"^")
 ;;=VALM LAST SCREEN
 ;;^UTILITY(U,$J,"PRO",662,10,14,0)
 ;;=638^FS^21
 ;;^UTILITY(U,$J,"PRO",662,10,14,"^")
 ;;=VALM FIRST SCREEN
 ;;^UTILITY(U,$J,"PRO",662,10,15,0)
 ;;=663^GO^23
 ;;^UTILITY(U,$J,"PRO",662,10,15,"^")
 ;;=VALM GOTO PAGE
 ;;^UTILITY(U,$J,"PRO",662,10,17,0)
 ;;=649^^34
 ;;^UTILITY(U,$J,"PRO",662,10,17,"^")
 ;;=VALM BLANK 2
 ;;^UTILITY(U,$J,"PRO",662,10,18,0)
 ;;=650^^35
 ;;^UTILITY(U,$J,"PRO",662,10,18,"^")
 ;;=VALM BLANK 3
 ;;^UTILITY(U,$J,"PRO",662,10,19,0)
 ;;=651^^36
 ;;^UTILITY(U,$J,"PRO",662,10,19,"^")
 ;;=VALM BLANK 4
 ;;^UTILITY(U,$J,"PRO",662,99)
 ;;=55671,80118
 ;;^UTILITY(U,$J,"PRO",663,0)
 ;;=VALM GOTO PAGE^Go to Page^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",663,1,0)
 ;;=^^1^1^2930113^
 ;;^UTILITY(U,$J,"PRO",663,1,1,0)
 ;;=
 ;;^UTILITY(U,$J,"PRO",663,20)
 ;;=D GOTO^VALM40
 ;;^UTILITY(U,$J,"PRO",663,99)
 ;;=55598,37468
 ;;^UTILITY(U,$J,"PRO",664,0)
 ;;=VALM WORKBENCH^Workbench Tool^^M^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",664,4)
 ;;=26^4
 ;;^UTILITY(U,$J,"PRO",664,10,0)
 ;;=^101.01PA^12^12
 ;;^UTILITY(U,$J,"PRO",664,10,1,0)
 ;;=665^DE^1
 ;;^UTILITY(U,$J,"PRO",664,10,1,"^")
 ;;=VALM DEMOGRAPHICS
 ;;^UTILITY(U,$J,"PRO",664,10,2,0)
 ;;=669^PI^2
 ;;^UTILITY(U,$J,"PRO",664,10,2,"^")
 ;;=VALM PROTOCOL INFORMATION
 ;;^UTILITY(U,$J,"PRO",664,10,3,0)
 ;;=670^LR^3
 ;;^UTILITY(U,$J,"PRO",664,10,3,"^")
 ;;=VALM LIST REGION EDIT
 ;;^UTILITY(U,$J,"PRO",664,10,4,0)
 ;;=668^OF^4
 ;;^UTILITY(U,$J,"PRO",664,10,4,"^")
 ;;=VALM OTHER FIELDS
 ;;^UTILITY(U,$J,"PRO",664,10,5,0)
 ;;=667^MC^5
 ;;^UTILITY(U,$J,"PRO",664,10,5,"^")
 ;;=VALM MUMPS CODE EDIT
 ;;^UTILITY(U,$J,"PRO",664,10,6,0)
 ;;=666^CE^6
 ;;^UTILITY(U,$J,"PRO",664,10,6,"^")
 ;;=VALM CAPTION EDIT
 ;;^UTILITY(U,$J,"PRO",664,10,7,0)
 ;;=671^CL^7
 ;;^UTILITY(U,$J,"PRO",664,10,7,"^")
 ;;=VALM CHANGE LIST
 ;;^UTILITY(U,$J,"PRO",664,10,8,0)
 ;;=672^EA^8
 ;;^UTILITY(U,$J,"PRO",664,10,8,"^")
 ;;=VALM EDIT ALL
 ;;^UTILITY(U,$J,"PRO",664,10,9,0)
 ;;=673^PE^9
 ;;^UTILITY(U,$J,"PRO",664,10,9,"^")
 ;;=VALM PROTOCOL EDIT
 ;;^UTILITY(U,$J,"PRO",664,10,10,0)
 ;;=674^RN^10
 ;;^UTILITY(U,$J,"PRO",664,10,10,"^")
 ;;=VALM RUN LIST
 ;;^UTILITY(U,$J,"PRO",664,10,11,0)
 ;;=675^IT^12
 ;;^UTILITY(U,$J,"PRO",664,10,11,"^")
 ;;=VALM INPUT TEMPLATE EDIT
 ;;^UTILITY(U,$J,"PRO",664,10,12,0)
 ;;=633^RO
 ;;^UTILITY(U,$J,"PRO",664,10,12,"^")
 ;;=VALM EDITOR
 ;;^UTILITY(U,$J,"PRO",664,26)
 ;;=D SHOW^VALM
 ;;^UTILITY(U,$J,"PRO",664,28)
 ;;=Select Tool:
 ;;^UTILITY(U,$J,"PRO",664,99)
 ;;=55599,55033
 ;;^UTILITY(U,$J,"PRO",665,0)
 ;;=VALM DEMOGRAPHICS^Demographic Edit^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",665,20)
 ;;=D EDIT^VALMW2("DEMOGRAPHICS EDIT"),HDR^VALMWB
 ;;^UTILITY(U,$J,"PRO",665,99)
 ;;=55598,37443
 ;;^UTILITY(U,$J,"PRO",666,0)
 ;;=VALM CAPTION EDIT^Caption Edit^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",666,20)
 ;;=D EDIT^VALMW2("CAPTION EDIT")
 ;;^UTILITY(U,$J,"PRO",666,99)
 ;;=55598,37419
 ;;^UTILITY(U,$J,"PRO",667,0)
 ;;=VALM MUMPS CODE EDIT^MUMPS Code Edit^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",667,20)
 ;;=D EDIT^VALMW2("MUMPS CODE EDIT")
 ;;^UTILITY(U,$J,"PRO",667,99)
 ;;=55598,37531
 ;;^UTILITY(U,$J,"PRO",668,0)
 ;;=VALM OTHER FIELDS^Other Fields^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",668,20)
 ;;=D EDIT^VALMW2("OTHER FIELDS")
 ;;^UTILITY(U,$J,"PRO",668,99)
 ;;=55598,37534
 ;;^UTILITY(U,$J,"PRO",669,0)
 ;;=VALM PROTOCOL INFORMATION^Protocol Information^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",669,20)
 ;;=D EDIT^VALMW2("PROTOCOL INFORMATION")
 ;;^UTILITY(U,$J,"PRO",669,99)
 ;;=55598,37540
 ;;^UTILITY(U,$J,"PRO",670,0)
 ;;=VALM LIST REGION EDIT^List Region Edit^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",670,20)
 ;;=D EDIT^VALMW2("LIST REGION EDIT")
 ;;^UTILITY(U,$J,"PRO",670,99)
 ;;=55598,37530
 ;;^UTILITY(U,$J,"PRO",671,0)
 ;;=VALM CHANGE LIST^Change List Template^^A^^^^^^^^LIST MANAGER
 ;;^UTILITY(U,$J,"PRO",671,10,0)
 ;;=^101.01PA^0^0
 ;;^UTILITY(U,$J,"PRO",671,20)
 ;;=D INIT^VALMWB S VALMBCK=$S($D(VALMQUIT):"",1:"R")
 ;;^UTILITY(U,$J,"PRO",671,99)
 ;;=55598,37420
 ;;^UTILITY(U,$J,"PRO",672,0)
 ;;=VALM EDIT ALL^Edit All^^X^^^^^^^^LIST MANAGER