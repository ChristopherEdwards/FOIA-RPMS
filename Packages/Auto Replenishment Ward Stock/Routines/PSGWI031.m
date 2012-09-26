PSGWI031 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",153,1,3,0)
 ;;=options to prepare the files to collect AMIS reporting information, run
 ;;^UTILITY(U,$J,"OPT",153,1,4,0)
 ;;=the AMIS report, and purge the system of obsolete data.
 ;;^UTILITY(U,$J,"OPT",153,1,5,0)
 ;;=Additionally, cost management reports are located on this menu.
 ;;^UTILITY(U,$J,"OPT",153,10,0)
 ;;=^19.01PI^12^4
 ;;^UTILITY(U,$J,"OPT",153,10,6,0)
 ;;=162^^1
 ;;^UTILITY(U,$J,"OPT",153,10,6,"^")
 ;;=PSGW SETUP
 ;;^UTILITY(U,$J,"OPT",153,10,9,0)
 ;;=190^^3
 ;;^UTILITY(U,$J,"OPT",153,10,9,"^")
 ;;=PSGW PREPARE AMIS DATA
 ;;^UTILITY(U,$J,"OPT",153,10,11,0)
 ;;=201^^7
 ;;^UTILITY(U,$J,"OPT",153,10,11,"^")
 ;;=PSGW PURGE
 ;;^UTILITY(U,$J,"OPT",153,10,12,0)
 ;;=213^^5
 ;;^UTILITY(U,$J,"OPT",153,10,12,"^")
 ;;=PSGW MGT REPORTS
 ;;^UTILITY(U,$J,"OPT",153,99)
 ;;=55612,32997
 ;;^UTILITY(U,$J,"OPT",153,"U")
 ;;=SUPERVISOR'S MENU
 ;;^UTILITY(U,$J,"OPT",154,0)
 ;;=PSGW INVENTORY SHEET^Inventory Sheet Print (132 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",154,1,0)
 ;;=^^2^2^2930608^^^^
 ;;^UTILITY(U,$J,"OPT",154,1,1,0)
 ;;=This option prints the AOU inventory reporting sheet.  This contains a
 ;;^UTILITY(U,$J,"OPT",154,1,2,0)
 ;;=listing, by AOU, of all the items for specific inventory types.
 ;;^UTILITY(U,$J,"OPT",154,25)
 ;;=ASKINV^PSGWL
 ;;^UTILITY(U,$J,"OPT",154,"U")
 ;;=INVENTORY SHEET PRINT (132 COL
 ;;^UTILITY(U,$J,"OPT",155,0)
 ;;=PSGW WARD STOCK^Production Menu^^M^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",155,1,0)
 ;;=^^2^2^2910425^^^^
 ;;^UTILITY(U,$J,"OPT",155,1,1,0)
 ;;=This menu provides access to the options that are used routinely in the
 ;;^UTILITY(U,$J,"OPT",155,1,2,0)
 ;;=normal Automatic Replenishment/Ward Stock operations.
 ;;^UTILITY(U,$J,"OPT",155,10,0)
 ;;=^19.01PI^12^11
 ;;^UTILITY(U,$J,"OPT",155,10,1,0)
 ;;=154^^1
 ;;^UTILITY(U,$J,"OPT",155,10,1,"^")
 ;;=PSGW INVENTORY SHEET
 ;;^UTILITY(U,$J,"OPT",155,10,2,0)
 ;;=156^^7
 ;;^UTILITY(U,$J,"OPT",155,10,2,"^")
 ;;=PSGW AOU INVENTORY INPUT
 ;;^UTILITY(U,$J,"OPT",155,10,4,0)
 ;;=167^^19
 ;;^UTILITY(U,$J,"OPT",155,10,4,"^")
 ;;=PSGW REPORTS
 ;;^UTILITY(U,$J,"OPT",155,10,5,0)
 ;;=170^^9
 ;;^UTILITY(U,$J,"OPT",155,10,5,"^")
 ;;=PSGW INVENTORY PICK LIST
 ;;^UTILITY(U,$J,"OPT",155,10,6,0)
 ;;=174^^13
 ;;^UTILITY(U,$J,"OPT",155,10,6,"^")
 ;;=PSGW ON-DEMAND
 ;;^UTILITY(U,$J,"OPT",155,10,7,0)
 ;;=171^^11
 ;;^UTILITY(U,$J,"OPT",155,10,7,"^")
 ;;=PSGW INVENTORY DISPENSE
 ;;^UTILITY(U,$J,"OPT",155,10,8,0)
 ;;=179^^15
 ;;^UTILITY(U,$J,"OPT",155,10,8,"^")
 ;;=PSGW BACKORDER
 ;;^UTILITY(U,$J,"OPT",155,10,9,0)
 ;;=184^^17
 ;;^UTILITY(U,$J,"OPT",155,10,9,"^")
 ;;=PSGW RETURN ITEMS
 ;;^UTILITY(U,$J,"OPT",155,10,10,0)
 ;;=857^^3
 ;;^UTILITY(U,$J,"OPT",155,10,10,"^")
 ;;=PSGW INVENTORY SINGLE
 ;;^UTILITY(U,$J,"OPT",155,10,11,0)
 ;;=607^^5
 ;;^UTILITY(U,$J,"OPT",155,10,11,"^")
 ;;=PSGW DELETE INVENTORY
 ;;^UTILITY(U,$J,"OPT",155,10,12,0)
 ;;=1070^^18
 ;;^UTILITY(U,$J,"OPT",155,10,12,"^")
 ;;=PSGW CRASH CART MENU
 ;;^UTILITY(U,$J,"OPT",155,15)
 ;;=
 ;;^UTILITY(U,$J,"OPT",155,20)
 ;;=
 ;;^UTILITY(U,$J,"OPT",155,99)
 ;;=55612,32997
 ;;^UTILITY(U,$J,"OPT",155,"U")
 ;;=PRODUCTION MENU
 ;;^UTILITY(U,$J,"OPT",156,0)
 ;;=PSGW AOU INVENTORY INPUT^Input AOU Inventory^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",156,1,0)
 ;;=^^3^3^2930219^^^^
 ;;^UTILITY(U,$J,"OPT",156,1,1,0)
 ;;=This option supports the entry of the inventory results as recorded on
 ;;^UTILITY(U,$J,"OPT",156,1,2,0)
 ;;=the AOU inventory sheet.  Items within an AOU are prompted in the
 ;;^UTILITY(U,$J,"OPT",156,1,3,0)
 ;;=order that they appear on the AOU inventory sheet.
 ;;^UTILITY(U,$J,"OPT",156,25)
 ;;=PSGWEDI
 ;;^UTILITY(U,$J,"OPT",156,"U")
 ;;=INPUT AOU INVENTORY
 ;;^UTILITY(U,$J,"OPT",157,0)
 ;;=PSGWMGR^Automatic Replenishment^^M^^PSGWMGR^^^^^^AR/WS PATCH NAMESPACE^^^1
 ;;^UTILITY(U,$J,"OPT",157,1,0)
 ;;=^^2^2^2930603^^^^
 ;;^UTILITY(U,$J,"OPT",157,1,1,0)
 ;;=Access to all options associated with automatic replenishment and ward
 ;;^UTILITY(U,$J,"OPT",157,1,2,0)
 ;;=stock.
 ;;^UTILITY(U,$J,"OPT",157,10,0)
 ;;=^19.01PI^2^2
 ;;^UTILITY(U,$J,"OPT",157,10,1,0)
 ;;=155^
 ;;^UTILITY(U,$J,"OPT",157,10,1,"^")
 ;;=PSGW WARD STOCK
