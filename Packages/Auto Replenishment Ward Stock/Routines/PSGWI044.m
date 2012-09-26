PSGWI044 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",856,1,8,0)
 ;;=any menu, but may be hooked into a menu at the site's discretion.
 ;;^UTILITY(U,$J,"OPT",856,1,9,0)
 ;;=*** NOTE *** This option is CPU intensive and should be queued only in
 ;;^UTILITY(U,$J,"OPT",856,1,10,0)
 ;;=the "off" hours.  Also, it should ONLY be run if there is strong evidence
 ;;^UTILITY(U,$J,"OPT",856,1,11,0)
 ;;=the "AMIS" cross-reference has been destroyed or corrupted.
 ;;^UTILITY(U,$J,"OPT",856,25)
 ;;=PSGWXREF
 ;;^UTILITY(U,$J,"OPT",856,"U")
 ;;=RE-INDEX AMIS CROSS-REFERENCE
 ;;^UTILITY(U,$J,"OPT",857,0)
 ;;=PSGW INVENTORY SINGLE^Single AOU Inventory Print (132 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",857,1,0)
 ;;=^^4^4^2930518^
 ;;^UTILITY(U,$J,"OPT",857,1,1,0)
 ;;=This option will print an inventory sheet for a single AOU that is
 ;;^UTILITY(U,$J,"OPT",857,1,2,0)
 ;;=included in the inventory date/time.  This option is meant primarily
 ;;^UTILITY(U,$J,"OPT",857,1,3,0)
 ;;=to be used as a means of avoiding a reprint of a lengthy inventory
 ;;^UTILITY(U,$J,"OPT",857,1,4,0)
 ;;=sheet when there has been problem such as a printer jam.
 ;;^UTILITY(U,$J,"OPT",857,25)
 ;;=EN^PSGWPIS
 ;;^UTILITY(U,$J,"OPT",857,"U")
 ;;=SINGLE AOU INVENTORY PRINT (13
 ;;^UTILITY(U,$J,"OPT",1070,0)
 ;;=PSGW CRASH CART MENU^Crash Cart Menu^^M^^^^^^^^AUTO REPLENISHMENT/WARD STOCK
 ;;^UTILITY(U,$J,"OPT",1070,1,0)
 ;;=^^1^1^2910528^
 ;;^UTILITY(U,$J,"OPT",1070,1,1,0)
 ;;=This menu contains the crash cart options for production.
 ;;^UTILITY(U,$J,"OPT",1070,10,0)
 ;;=^19.01PI^2^2
 ;;^UTILITY(U,$J,"OPT",1070,10,1,0)
 ;;=1071^^1
 ;;^UTILITY(U,$J,"OPT",1070,10,1,"^")
 ;;=PSGW CRASH CART LOCATION EDIT
 ;;^UTILITY(U,$J,"OPT",1070,10,2,0)
 ;;=1072^^5
 ;;^UTILITY(U,$J,"OPT",1070,10,2,"^")
 ;;=PSGW CRASH CART LOCATION PRINT
 ;;^UTILITY(U,$J,"OPT",1070,99)
 ;;=55612,32973
 ;;^UTILITY(U,$J,"OPT",1070,"U")
 ;;=CRASH CART MENU
 ;;^UTILITY(U,$J,"OPT",1071,0)
 ;;=PSGW CRASH CART LOCATION EDIT^Enter/Edit Crash Cart Locations^^R^^^^^^^^AUTO REPLENISHMENT/WARD STOCK
 ;;^UTILITY(U,$J,"OPT",1071,1,0)
 ;;=^^2^2^2930514^
 ;;^UTILITY(U,$J,"OPT",1071,1,1,0)
 ;;=This option will allow users to edit the LOCATION field for AOUs that
 ;;^UTILITY(U,$J,"OPT",1071,1,2,0)
 ;;=are flagged as Crash Carts.
 ;;^UTILITY(U,$J,"OPT",1071,25)
 ;;=PSGWCCE
 ;;^UTILITY(U,$J,"OPT",1071,"U")
 ;;=ENTER/EDIT CRASH CART LOCATION
 ;;^UTILITY(U,$J,"OPT",1072,0)
 ;;=PSGW CRASH CART LOCATION PRINT^Print Crash Cart Locations^^R^^^^^^^^AUTO REPLENISHMENT/WARD STOCK
 ;;^UTILITY(U,$J,"OPT",1072,1,0)
 ;;=^^2^2^2930514^
 ;;^UTILITY(U,$J,"OPT",1072,1,1,0)
 ;;=This option will print an 80 column report listing all AOUs that are
 ;;^UTILITY(U,$J,"OPT",1072,1,2,0)
 ;;=flagged as Crash Carts with their locations.
 ;;^UTILITY(U,$J,"OPT",1072,25)
 ;;=PSGWCCP
 ;;^UTILITY(U,$J,"OPT",1072,"U")
 ;;=PRINT CRASH CART LOCATIONS
 ;;^UTILITY(U,$J,"OPT",1314,0)
 ;;=PSGW DUPLICATE REPORT^Duplicate Entry Report (132 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",1314,1,0)
 ;;=^^5^5^2930618^
 ;;^UTILITY(U,$J,"OPT",1314,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",1314,1,2,0)
 ;;=This 132 column report will display one or all drugs with duplicate
 ;;^UTILITY(U,$J,"OPT",1314,1,3,0)
 ;;=entries in the ITEM subfile (#58.11) of the PHARMACY AOU STOCK FILE
 ;;^UTILITY(U,$J,"OPT",1314,1,4,0)
 ;;=(#58.1).  For each drug the report will show all inventory, return,
 ;;^UTILITY(U,$J,"OPT",1314,1,5,0)
 ;;=and on-demand data.
 ;;^UTILITY(U,$J,"OPT",1314,25)
 ;;=PSGWDUP
 ;;^UTILITY(U,$J,"OPT",1314,"U")
 ;;=DUPLICATE ENTRY REPORT (132 CO
 ;;^UTILITY(U,$J,"OPT",1315,0)
 ;;=PSGW ITEM LOC EDIT^Item Location Codes - Enter/Edit^^R^^^^^^^^AUTO REPLENISHMENT/WARD STOCK
 ;;^UTILITY(U,$J,"OPT",1315,1,0)
 ;;=^^3^3^2930607^^^^
 ;;^UTILITY(U,$J,"OPT",1315,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",1315,1,2,0)
 ;;=Supports editing of codes used to define the location of items in Areas of
 ;;^UTILITY(U,$J,"OPT",1315,1,3,0)
 ;;=Use or in the pharmacy.
 ;;^UTILITY(U,$J,"OPT",1315,25)
 ;;=ITEMLOC^PSGWEE
 ;;^UTILITY(U,$J,"OPT",1315,"U")
 ;;=ITEM LOCATION CODES - ENTER/ED
 ;;^UTILITY(U,$J,"OPT",1316,0)
 ;;=PSGW STANDARD COST REPORT^Standard Cost Report (132 column)^^R^^^^^^^^
