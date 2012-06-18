PSGWI033 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",162,10,8,"^")
 ;;=PSGW AOU INV GROUP EDIT
 ;;^UTILITY(U,$J,"OPT",162,10,9,0)
 ;;=169^^17
 ;;^UTILITY(U,$J,"OPT",162,10,9,"^")
 ;;=PSGW AOU INV GROUP SORT
 ;;^UTILITY(U,$J,"OPT",162,10,10,0)
 ;;=185^^19
 ;;^UTILITY(U,$J,"OPT",162,10,10,"^")
 ;;=PSGW SITE
 ;;^UTILITY(U,$J,"OPT",162,10,11,0)
 ;;=208^^15
 ;;^UTILITY(U,$J,"OPT",162,10,11,"^")
 ;;=PSGW PRINT SETUP LISTS
 ;;^UTILITY(U,$J,"OPT",162,10,12,0)
 ;;=214^^11
 ;;^UTILITY(U,$J,"OPT",162,10,12,"^")
 ;;=PSGW TRANSFER ENTRIES
 ;;^UTILITY(U,$J,"OPT",162,10,13,0)
 ;;=597^^7
 ;;^UTILITY(U,$J,"OPT",162,10,13,"^")
 ;;=PSGW EXPIRATION ENTER/EDIT
 ;;^UTILITY(U,$J,"OPT",162,10,14,0)
 ;;=605^^12
 ;;^UTILITY(U,$J,"OPT",162,10,14,"^")
 ;;=PSGW AOU INACTIVATION
 ;;^UTILITY(U,$J,"OPT",162,10,15,0)
 ;;=606^^9
 ;;^UTILITY(U,$J,"OPT",162,10,15,"^")
 ;;=PSGW WARD CONVERSION
 ;;^UTILITY(U,$J,"OPT",162,10,16,0)
 ;;=745^^16
 ;;^UTILITY(U,$J,"OPT",162,10,16,"^")
 ;;=PSGW EDIT INVENTORY USER
 ;;^UTILITY(U,$J,"OPT",162,10,17,0)
 ;;=817^^10
 ;;^UTILITY(U,$J,"OPT",162,10,17,"^")
 ;;=PSGW ADD/DEL WARD
 ;;^UTILITY(U,$J,"OPT",162,10,18,0)
 ;;=1315^^2
 ;;^UTILITY(U,$J,"OPT",162,10,18,"^")
 ;;=PSGW ITEM LOC EDIT
 ;;^UTILITY(U,$J,"OPT",162,99)
 ;;=55756,29185
 ;;^UTILITY(U,$J,"OPT",162,"U")
 ;;=SET UP AR/WS (BUILD FILES)
 ;;^UTILITY(U,$J,"OPT",164,0)
 ;;=PSGW ITEM LOC PRINT^List Location Codes (80 column)^^P^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",164,1,0)
 ;;=^^2^2^2930601^^^^
 ;;^UTILITY(U,$J,"OPT",164,1,1,0)
 ;;=Produces report of codes used to define the location of items in
 ;;^UTILITY(U,$J,"OPT",164,1,2,0)
 ;;=Areas of Use or in the pharmacy.
 ;;^UTILITY(U,$J,"OPT",164,60)
 ;;=PSI(58.17,
 ;;^UTILITY(U,$J,"OPT",164,62)
 ;;=0
 ;;^UTILITY(U,$J,"OPT",164,63)
 ;;=[PSGW ITEM LOC]
 ;;^UTILITY(U,$J,"OPT",164,64)
 ;;=[PSGW ITEM LOC]
 ;;^UTILITY(U,$J,"OPT",164,"U")
 ;;=LIST LOCATION CODES (80 COLUMN
 ;;^UTILITY(U,$J,"OPT",165,0)
 ;;=PSGW INV TYPE EDIT^Enter/Edit Inventory Types^^R^^^^^^^^AUTO REPLENISHMENT/WARD STOCK
 ;;^UTILITY(U,$J,"OPT",165,1,0)
 ;;=^^1^1^2930602^^^^
 ;;^UTILITY(U,$J,"OPT",165,1,1,0)
 ;;=Edit the file of Inventory Types used to classify Area of Use items.
 ;;^UTILITY(U,$J,"OPT",165,25)
 ;;=INVENT^PSGWEE
 ;;^UTILITY(U,$J,"OPT",165,"U")
 ;;=ENTER/EDIT INVENTORY TYPES
 ;;^UTILITY(U,$J,"OPT",166,0)
 ;;=PSGW INV TYPE^Print Inventory Types (80 column)^^P^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",166,1,0)
 ;;=^^1^1^2870902^^
 ;;^UTILITY(U,$J,"OPT",166,1,1,0)
 ;;=Print the file of Inventory Types used to classify Area of Use items.
 ;;^UTILITY(U,$J,"OPT",166,60)
 ;;=PSI(58.16,
 ;;^UTILITY(U,$J,"OPT",166,62)
 ;;=0
 ;;^UTILITY(U,$J,"OPT",166,63)
 ;;=[PSGW INV TYPE]
 ;;^UTILITY(U,$J,"OPT",166,64)
 ;;=[PSGW INV TYPE]
 ;;^UTILITY(U,$J,"OPT",166,"U")
 ;;=PRINT INVENTORY TYPES (80 COLU
 ;;^UTILITY(U,$J,"OPT",167,0)
 ;;=PSGW REPORTS^Auto Replenishment Reports^^M^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",167,1,0)
 ;;=^^2^2^2890926^^^^
 ;;^UTILITY(U,$J,"OPT",167,1,1,0)
 ;;=Menu giving access to various report options for Automatic Replenishment
 ;;^UTILITY(U,$J,"OPT",167,1,2,0)
 ;;=data.
 ;;^UTILITY(U,$J,"OPT",167,10,0)
 ;;=^19.01PI^12^9
 ;;^UTILITY(U,$J,"OPT",167,10,1,0)
 ;;=168^^11
 ;;^UTILITY(U,$J,"OPT",167,10,1,"^")
 ;;=PSGW STOCK PERCENTAGE
 ;;^UTILITY(U,$J,"OPT",167,10,2,0)
 ;;=161^^5
 ;;^UTILITY(U,$J,"OPT",167,10,2,"^")
 ;;=PSGW WARD INV PRINT
 ;;^UTILITY(U,$J,"OPT",167,10,3,0)
 ;;=186^^7
 ;;^UTILITY(U,$J,"OPT",167,10,3,"^")
 ;;=PSGW LOOKUP ITEM
 ;;^UTILITY(U,$J,"OPT",167,10,4,0)
 ;;=187^^15
 ;;^UTILITY(U,$J,"OPT",167,10,4,"^")
 ;;=PSGW USAGE REPORT
 ;;^UTILITY(U,$J,"OPT",167,10,8,0)
 ;;=209^^17
 ;;^UTILITY(U,$J,"OPT",167,10,8,"^")
 ;;=PSGW ZERO USAGE
 ;;^UTILITY(U,$J,"OPT",167,10,9,0)
 ;;=210^^13
 ;;^UTILITY(U,$J,"OPT",167,10,9,"^")
 ;;=PSGW RETURNS BREAKDOWN
 ;;^UTILITY(U,$J,"OPT",167,10,10,0)
 ;;=160^^1
 ;;^UTILITY(U,$J,"OPT",167,10,10,"^")
 ;;=PSGW PRINT AOU STOCK
 ;;^UTILITY(U,$J,"OPT",167,10,11,0)
 ;;=744^^9
 ;;^UTILITY(U,$J,"OPT",167,10,11,"^")
 ;;=PSGW ITEM INQUIRY
 ;;^UTILITY(U,$J,"OPT",167,10,12,0)
 ;;=816^^3
 ;;^UTILITY(U,$J,"OPT",167,10,12,"^")
 ;;=PSGW EXP REPORT
 ;;^UTILITY(U,$J,"OPT",167,99)
 ;;=55880,35236
