PSGWI034 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",167,"U")
 ;;=AUTO REPLENISHMENT REPORTS
 ;;^UTILITY(U,$J,"OPT",168,0)
 ;;=PSGW STOCK PERCENTAGE^Percentage Stock On Hand (132 column)^^R^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",168,1,0)
 ;;=^^3^3^2931229^^^^
 ;;^UTILITY(U,$J,"OPT",168,1,1,0)
 ;;=Report which extracts inventory data by percentage of stock on hand
 ;;^UTILITY(U,$J,"OPT",168,1,2,0)
 ;;=for a given inventory date range.  Percentage and date range can
 ;;^UTILITY(U,$J,"OPT",168,1,3,0)
 ;;=be specified.
 ;;^UTILITY(U,$J,"OPT",168,20)
 ;;=
 ;;^UTILITY(U,$J,"OPT",168,25)
 ;;=PSGWPERC
 ;;^UTILITY(U,$J,"OPT",168,"U")
 ;;=PERCENTAGE STOCK ON HAND (132 
 ;;^UTILITY(U,$J,"OPT",169,0)
 ;;=PSGW AOU INV GROUP SORT^Sort AOUs in Group^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",169,1,0)
 ;;=^^3^3^2880114^^^^
 ;;^UTILITY(U,$J,"OPT",169,1,1,0)
 ;;=This option allows the user to change the order in which the AOUs within an 
 ;;^UTILITY(U,$J,"OPT",169,1,2,0)
 ;;=inventory group will sort.  AOUs should sort in the order that they will 
 ;;^UTILITY(U,$J,"OPT",169,1,3,0)
 ;;=be visited.
 ;;^UTILITY(U,$J,"OPT",169,25)
 ;;=PSGWSIG
 ;;^UTILITY(U,$J,"OPT",169,"U")
 ;;=SORT AOUS IN GROUP
 ;;^UTILITY(U,$J,"OPT",170,0)
 ;;=PSGW INVENTORY PICK LIST^Pick List  (132 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",170,1,0)
 ;;=^^2^2^2890427^^^^
 ;;^UTILITY(U,$J,"OPT",170,1,1,0)
 ;;= Prints the Inventory Pick list for the inventory specified by the user.
 ;;^UTILITY(U,$J,"OPT",170,1,2,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",170,25)
 ;;=PSGWPL
 ;;^UTILITY(U,$J,"OPT",170,"U")
 ;;=PICK LIST  (132 COLUMN)
 ;;^UTILITY(U,$J,"OPT",171,0)
 ;;=PSGW INVENTORY DISPENSE^Enter/Edit Quantity Dispensed^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",171,1,0)
 ;;=^^5^5^2930609^^^^
 ;;^UTILITY(U,$J,"OPT",171,1,1,0)
 ;;= Allows the user to enter the actual quantity dispensed from the
 ;;^UTILITY(U,$J,"OPT",171,1,2,0)
 ;;= inventory pick list or from the inventory sheet depending on how
 ;;^UTILITY(U,$J,"OPT",171,1,3,0)
 ;;= the site parameters are set up. If the MERGE INV. SHEET AND PICK LIST
 ;;^UTILITY(U,$J,"OPT",171,1,4,0)
 ;;= site parameter is set to no, the quantity  dispensed figure is then used
 ;;^UTILITY(U,$J,"OPT",171,1,5,0)
 ;;= to automatically compute the amount on backorder.
 ;;^UTILITY(U,$J,"OPT",171,25)
 ;;=PSGWBO
 ;;^UTILITY(U,$J,"OPT",171,"U")
 ;;=ENTER/EDIT QUANTITY DISPENSED
 ;;^UTILITY(U,$J,"OPT",172,0)
 ;;=PSGW BACKORDER ITEM PRINT^Single Item Report (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",172,1,0)
 ;;=^^1^1^2890719^^^^
 ;;^UTILITY(U,$J,"OPT",172,1,1,0)
 ;;= Prints a list of all backorders for a specific item.
 ;;^UTILITY(U,$J,"OPT",172,25)
 ;;=SINGLE^PSGWBOI
 ;;^UTILITY(U,$J,"OPT",172,"U")
 ;;=SINGLE ITEM REPORT (80 COLUMN)
 ;;^UTILITY(U,$J,"OPT",173,0)
 ;;=PSGW BACKORDER AOU PRINT^AOU Backorder Report (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",173,1,0)
 ;;=^^1^1^2910206^^^^
 ;;^UTILITY(U,$J,"OPT",173,1,1,0)
 ;;= Prints all items backordered for selected Areas of Use.
 ;;^UTILITY(U,$J,"OPT",173,25)
 ;;=PSGWBOS
 ;;^UTILITY(U,$J,"OPT",173,60)
 ;;=
 ;;^UTILITY(U,$J,"OPT",173,62)
 ;;=
 ;;^UTILITY(U,$J,"OPT",173,63)
 ;;=
 ;;^UTILITY(U,$J,"OPT",173,64)
 ;;=
 ;;^UTILITY(U,$J,"OPT",173,65)
 ;;=
 ;;^UTILITY(U,$J,"OPT",173,66)
 ;;=
 ;;^UTILITY(U,$J,"OPT",173,"U")
 ;;=AOU BACKORDER REPORT (80 COLUM
 ;;^UTILITY(U,$J,"OPT",174,0)
 ;;=PSGW ON-DEMAND^On-Demand Requests^^M^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",174,1,0)
 ;;=^^1^1^2870902^^^^
 ;;^UTILITY(U,$J,"OPT",174,1,1,0)
 ;;=  Menu giving access to the On-Demand options.
 ;;^UTILITY(U,$J,"OPT",174,10,0)
 ;;=^19.01PI^4^3
 ;;^UTILITY(U,$J,"OPT",174,10,2,0)
 ;;=178^^1
 ;;^UTILITY(U,$J,"OPT",174,10,2,"^")
 ;;=PSGW ON-DEMAND EDIT
 ;;^UTILITY(U,$J,"OPT",174,10,3,0)
 ;;=176^^5
 ;;^UTILITY(U,$J,"OPT",174,10,3,"^")
 ;;=PSGW ON-DEMAND DELETE
 ;;^UTILITY(U,$J,"OPT",174,10,4,0)
 ;;=177^^7
 ;;^UTILITY(U,$J,"OPT",174,10,4,"^")
 ;;=PSGW ON-DEMAND PRINT
 ;;^UTILITY(U,$J,"OPT",174,99)
 ;;=55612,32983
 ;;^UTILITY(U,$J,"OPT",174,"U")
 ;;=ON-DEMAND REQUESTS
 ;;^UTILITY(U,$J,"OPT",175,0)
 ;;=PSGW BACKORDER EDIT^Fill Requests for Backorder Items^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",175,1,0)
 ;;=^^3^3^2890630^^^^
