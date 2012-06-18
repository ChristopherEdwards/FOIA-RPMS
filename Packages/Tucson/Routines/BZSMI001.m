BZSMI001 ; ; 06-APR-2003
 ;;1.0;TAO A/R WRITE-OFF;;APR 06, 2003
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"KEY",480,0)
 ;;=BZSMZ MAIN MENU^TAO WRITE-OFF MAIN MENU
 ;;^UTILITY(U,$J,"KEY",480,1,0)
 ;;=^^1^1^3030319^
 ;;^UTILITY(U,$J,"KEY",480,1,1,0)
 ;;=This key unlocks the TAO old bill write-off main menu.
 ;;^UTILITY(U,$J,"OPT",7105,0)
 ;;=BZSM MENU-MAIN^TAO A/R Write-off Main Menu^^M^^BZSMZ MAIN MENU^^^^^^TAO A/R WRITE-OFF^^^^^1
 ;;^UTILITY(U,$J,"OPT",7105,1,0)
 ;;=^19.06^2^2^3030321^^^^
 ;;^UTILITY(U,$J,"OPT",7105,1,1,0)
 ;;=This option is the main menu for the Tucson Area Office old bill
 ;;^UTILITY(U,$J,"OPT",7105,1,2,0)
 ;;=write-off process.
 ;;^UTILITY(U,$J,"OPT",7105,10,0)
 ;;=^19.01IP^3^3
 ;;^UTILITY(U,$J,"OPT",7105,10,1,0)
 ;;=7106^WO^10
 ;;^UTILITY(U,$J,"OPT",7105,10,1,"^")
 ;;=BZSM WRITE OFF BILLS BY AC
 ;;^UTILITY(U,$J,"OPT",7105,10,2,0)
 ;;=7107^WOR^20
 ;;^UTILITY(U,$J,"OPT",7105,10,2,"^")
 ;;=BZSM WRITE OFF REVERSAL
 ;;^UTILITY(U,$J,"OPT",7105,10,3,0)
 ;;=7108^WOSA^10
 ;;^UTILITY(U,$J,"OPT",7105,10,3,"^")
 ;;=BZSM WRITE OFF BILLS BY SA
 ;;^UTILITY(U,$J,"OPT",7105,26)
 ;;=D HDR^BZSMBAN
 ;;^UTILITY(U,$J,"OPT",7105,99)
 ;;=59255,56597
 ;;^UTILITY(U,$J,"OPT",7105,"U")
 ;;=TAO A/R WRITE-OFF MAIN MENU
 ;;^UTILITY(U,$J,"OPT",7106,0)
 ;;=BZSM WRITE OFF BILLS BY AC^Write Off Old Bills by Allowance Category^^R^^^^^^^^TAO A/R WRITE-OFF^^^1^^1
 ;;^UTILITY(U,$J,"OPT",7106,1,0)
 ;;=^19.06^1^1^3030321^^
 ;;^UTILITY(U,$J,"OPT",7106,1,1,0)
 ;;=This option writes off old bills as by allowance category.
 ;;^UTILITY(U,$J,"OPT",7106,15)
 ;;=D BOHDR^BZSMBAN
 ;;^UTILITY(U,$J,"OPT",7106,25)
 ;;=BZSMAWO
 ;;^UTILITY(U,$J,"OPT",7106,26)
 ;;=D HDR^BZSMBAN
 ;;^UTILITY(U,$J,"OPT",7106,"U")
 ;;=WRITE OFF OLD BILLS BY ALLOWAN
 ;;^UTILITY(U,$J,"OPT",7107,0)
 ;;=BZSM WRITE OFF REVERSAL^Write Off Old Bills Reversal^^R^^^^^^^^TAO A/R WRITE-OFF^^^1^^1
 ;;^UTILITY(U,$J,"OPT",7107,1,0)
 ;;=^19.06^1^1^3030327^^^
 ;;^UTILITY(U,$J,"OPT",7107,1,1,0)
 ;;=This option reverses the actions taken by the write off old bills option.
 ;;^UTILITY(U,$J,"OPT",7107,15)
 ;;=D BOHDR^BZSMBAN
 ;;^UTILITY(U,$J,"OPT",7107,25)
 ;;=BZSMAWO3
 ;;^UTILITY(U,$J,"OPT",7107,26)
 ;;=D HDR^BZSMBAN
 ;;^UTILITY(U,$J,"OPT",7107,"U")
 ;;=WRITE OFF OLD BILLS REVERSAL
 ;;^UTILITY(U,$J,"OPT",7108,0)
 ;;=BZSM WRITE OFF BILLS BY SA^Write Off Old Bills by Selected Accounts^^R^^^^^^^^TAO A/R WRITE-OFF^^^1^^1
 ;;^UTILITY(U,$J,"OPT",7108,1,0)
 ;;=^^1^1^3030321^
 ;;^UTILITY(U,$J,"OPT",7108,1,1,0)
 ;;=This option write off old bills by user selected accounts.
 ;;^UTILITY(U,$J,"OPT",7108,15)
 ;;=D BOHDR^BZSMBAN
 ;;^UTILITY(U,$J,"OPT",7108,25)
 ;;=SACCT^BZSMAWO
 ;;^UTILITY(U,$J,"OPT",7108,26)
 ;;=D HDR^BZSMBAN
 ;;^UTILITY(U,$J,"OPT",7108,"U")
 ;;=WRITE OFF OLD BILLS BY SELECTE
 ;;^UTILITY(U,$J,"PKG",355,0)
 ;;=TAO A/R WRITE-OFF^BZSM^TAO write off old bills
 ;;^UTILITY(U,$J,"PKG",355,1,0)
 ;;=^^2^2^3030319^
 ;;^UTILITY(U,$J,"PKG",355,1,1,0)
 ;;=This option allows the Area Finance office to write-off old
 ;;^UTILITY(U,$J,"PKG",355,1,2,0)
 ;;=bills.
 ;;^UTILITY(U,$J,"PKG",355,22,0)
 ;;=^9.49I^1^1
 ;;^UTILITY(U,$J,"PKG",355,22,1,0)
 ;;=1.0^3030406
 ;;^UTILITY(U,$J,"PKG",355,22,"B","1.0",1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",355,"DEV")
 ;;=ENOS,DON/TUCSON AREA OFFICE
