PSGWI035 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",175,1,1,0)
 ;;=Allows the user to fill a backordered request by entering the date
 ;;^UTILITY(U,$J,"OPT",175,1,2,0)
 ;;=filled field. The user must know the item, Area of Use, and the date 
 ;;^UTILITY(U,$J,"OPT",175,1,3,0)
 ;;=of backorder.
 ;;^UTILITY(U,$J,"OPT",175,25)
 ;;=PSGWFIL
 ;;^UTILITY(U,$J,"OPT",175,30)
 ;;=
 ;;^UTILITY(U,$J,"OPT",175,31)
 ;;=
 ;;^UTILITY(U,$J,"OPT",175,50)
 ;;=
 ;;^UTILITY(U,$J,"OPT",175,51)
 ;;=
 ;;^UTILITY(U,$J,"OPT",175,"U")
 ;;=FILL REQUESTS FOR BACKORDER IT
 ;;^UTILITY(U,$J,"OPT",176,0)
 ;;=PSGW ON-DEMAND DELETE^Delete an On-Demand Request^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",176,1,0)
 ;;=^^2^2^2890118^^^^
 ;;^UTILITY(U,$J,"OPT",176,1,1,0)
 ;;= Allows the user to delete the On-Demand request. The user must enter the
 ;;^UTILITY(U,$J,"OPT",176,1,2,0)
 ;;= Area of Use, item name, and the inventory date (date of request).
 ;;^UTILITY(U,$J,"OPT",176,25)
 ;;=PSGWOND
 ;;^UTILITY(U,$J,"OPT",176,30)
 ;;=
 ;;^UTILITY(U,$J,"OPT",176,31)
 ;;=
 ;;^UTILITY(U,$J,"OPT",176,50)
 ;;=
 ;;^UTILITY(U,$J,"OPT",176,51)
 ;;=
 ;;^UTILITY(U,$J,"OPT",176,"U")
 ;;=DELETE AN ON-DEMAND REQUEST
 ;;^UTILITY(U,$J,"OPT",177,0)
 ;;=PSGW ON-DEMAND PRINT^Print an On-Demand Report by Date/AOU (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",177,1,0)
 ;;=^^4^4^2890703^^^^
 ;;^UTILITY(U,$J,"OPT",177,1,1,0)
 ;;= Prints an On-Demand report which lists the on-demand requests within a 
 ;;^UTILITY(U,$J,"OPT",177,1,2,0)
 ;;= user selected date range. The user can also select the Areas of Use
 ;;^UTILITY(U,$J,"OPT",177,1,3,0)
 ;;= to be checked. Standard stock items which have been requested on-demand
 ;;^UTILITY(U,$J,"OPT",177,1,4,0)
 ;;= are flagged.
 ;;^UTILITY(U,$J,"OPT",177,25)
 ;;=PSGWODP
 ;;^UTILITY(U,$J,"OPT",177,60)
 ;;=
 ;;^UTILITY(U,$J,"OPT",177,62)
 ;;=
 ;;^UTILITY(U,$J,"OPT",177,63)
 ;;=
 ;;^UTILITY(U,$J,"OPT",177,64)
 ;;=
 ;;^UTILITY(U,$J,"OPT",177,65)
 ;;=
 ;;^UTILITY(U,$J,"OPT",177,"U")
 ;;=PRINT AN ON-DEMAND REPORT BY D
 ;;^UTILITY(U,$J,"OPT",178,0)
 ;;=PSGW ON-DEMAND EDIT^Enter/Edit On-Demand Request (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",178,1,0)
 ;;=^^2^2^2930302^^^^
 ;;^UTILITY(U,$J,"OPT",178,1,1,0)
 ;;= Allows the user to edit an On-Demand request and change the inactive date
 ;;^UTILITY(U,$J,"OPT",178,1,2,0)
 ;;= fields, and the quantity requested.
 ;;^UTILITY(U,$J,"OPT",178,25)
 ;;=PSGWONDM
 ;;^UTILITY(U,$J,"OPT",178,99)
 ;;=55615,42045
 ;;^UTILITY(U,$J,"OPT",178,"U")
 ;;=ENTER/EDIT ON-DEMAND REQUEST (
 ;;^UTILITY(U,$J,"OPT",179,0)
 ;;=PSGW BACKORDER^Backorder Requests^^M^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",179,1,0)
 ;;=^^1^1^2890719^^^^
 ;;^UTILITY(U,$J,"OPT",179,1,1,0)
 ;;= Menu giving access to the backorder options.
 ;;^UTILITY(U,$J,"OPT",179,10,0)
 ;;=^19.01PI^6^6
 ;;^UTILITY(U,$J,"OPT",179,10,1,0)
 ;;=175^^3
 ;;^UTILITY(U,$J,"OPT",179,10,1,"^")
 ;;=PSGW BACKORDER EDIT
 ;;^UTILITY(U,$J,"OPT",179,10,2,0)
 ;;=173^^5
 ;;^UTILITY(U,$J,"OPT",179,10,2,"^")
 ;;=PSGW BACKORDER AOU PRINT
 ;;^UTILITY(U,$J,"OPT",179,10,3,0)
 ;;=172^^7
 ;;^UTILITY(U,$J,"OPT",179,10,3,"^")
 ;;=PSGW BACKORDER ITEM PRINT
 ;;^UTILITY(U,$J,"OPT",179,10,4,0)
 ;;=180^^9
 ;;^UTILITY(U,$J,"OPT",179,10,4,"^")
 ;;=PSGW BACKORDER ITEMS PRINT
 ;;^UTILITY(U,$J,"OPT",179,10,5,0)
 ;;=183^^1
 ;;^UTILITY(U,$J,"OPT",179,10,5,"^")
 ;;=PSGW BACKORDER IN
 ;;^UTILITY(U,$J,"OPT",179,10,6,0)
 ;;=743^^6
 ;;^UTILITY(U,$J,"OPT",179,10,6,"^")
 ;;=PSGW BACKORDER (ALL) PRINT
 ;;^UTILITY(U,$J,"OPT",179,99)
 ;;=55612,32970
 ;;^UTILITY(U,$J,"OPT",179,"U")
 ;;=BACKORDER REQUESTS
 ;;^UTILITY(U,$J,"OPT",180,0)
 ;;=PSGW BACKORDER ITEMS PRINT^Multiple Items Report (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",180,1,0)
 ;;=^^2^2^2890719^^^^
 ;;^UTILITY(U,$J,"OPT",180,1,1,0)
 ;;= The user may select several items.  The report will then print
 ;;^UTILITY(U,$J,"OPT",180,1,2,0)
 ;;= the backorder information for each of the items selected.
 ;;^UTILITY(U,$J,"OPT",180,25)
 ;;=MULTI^PSGWBOI
 ;;^UTILITY(U,$J,"OPT",180,"U")
 ;;=MULTIPLE ITEMS REPORT (80 COLU
 ;;^UTILITY(U,$J,"OPT",181,0)
 ;;=PSGW AREA OF USE EDIT^Create the Area of Use^^R^^^^^^^^AUTO REPLENISHMENT/WARD STOCK
