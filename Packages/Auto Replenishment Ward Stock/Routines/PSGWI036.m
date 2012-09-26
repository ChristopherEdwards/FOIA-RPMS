PSGWI036 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",181,1,0)
 ;;=^^2^2^2930827^^^^
 ;;^UTILITY(U,$J,"OPT",181,1,1,0)
 ;;= Allows the user to initially define the Areas of Use, and the wards
 ;;^UTILITY(U,$J,"OPT",181,1,2,0)
 ;;= and services within the area.
 ;;^UTILITY(U,$J,"OPT",181,25)
 ;;=AOU^PSGWEE
 ;;^UTILITY(U,$J,"OPT",181,"U")
 ;;=CREATE THE AREA OF USE
 ;;^UTILITY(U,$J,"OPT",182,0)
 ;;=PSGW PURGE INVENTORY^Purge Old Inventories from PSI(58.19,AINV)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",182,1,0)
 ;;=3^^3^3^2930518^^
 ;;^UTILITY(U,$J,"OPT",182,1,1,0)
 ;;=This option purges the ^PSI(58.19,"AINV") global. Inventory information 
 ;;^UTILITY(U,$J,"OPT",182,1,2,0)
 ;;=that is over 100 days old is removed.  The program is automatically
 ;;^UTILITY(U,$J,"OPT",182,1,3,0)
 ;;=queued and is transparent to the users of the system.
 ;;^UTILITY(U,$J,"OPT",182,25)
 ;;=PSGWKINV
 ;;^UTILITY(U,$J,"OPT",182,200)
 ;;=2911012.23^^1D
 ;;^UTILITY(U,$J,"OPT",182,"U")
 ;;=PURGE OLD INVENTORIES FROM PSI
 ;;^UTILITY(U,$J,"OPT",183,0)
 ;;=PSGW BACKORDER IN^Enter Backorders^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",183,1,0)
 ;;=^^3^3^2890627^^^^
 ;;^UTILITY(U,$J,"OPT",183,1,1,0)
 ;;=Used to create backorders for items stocked in an AOU. User must 
 ;;^UTILITY(U,$J,"OPT",183,1,2,0)
 ;;=enter item, AOU, inventory date, and current backorder (amount
 ;;^UTILITY(U,$J,"OPT",183,1,3,0)
 ;;=to back order).
 ;;^UTILITY(U,$J,"OPT",183,25)
 ;;=PSGWBOE
 ;;^UTILITY(U,$J,"OPT",183,30)
 ;;=
 ;;^UTILITY(U,$J,"OPT",183,31)
 ;;=
 ;;^UTILITY(U,$J,"OPT",183,50)
 ;;=
 ;;^UTILITY(U,$J,"OPT",183,51)
 ;;=
 ;;^UTILITY(U,$J,"OPT",183,"U")
 ;;=ENTER BACKORDERS
 ;;^UTILITY(U,$J,"OPT",184,0)
 ;;=PSGW RETURN ITEMS^Return Items for AOU^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",184,1,0)
 ;;=^^1^1^2930412^^^^
 ;;^UTILITY(U,$J,"OPT",184,1,1,0)
 ;;=Used to record items returned from an AOU.
 ;;^UTILITY(U,$J,"OPT",184,25)
 ;;=PSGWRI
 ;;^UTILITY(U,$J,"OPT",184,"U")
 ;;=RETURN ITEMS FOR AOU
 ;;^UTILITY(U,$J,"OPT",185,0)
 ;;=PSGW SITE^Site Parameters^^R^^PSGW PARAM^^^^^^
 ;;^UTILITY(U,$J,"OPT",185,1,0)
 ;;=^^4^4^2930602^^^^
 ;;^UTILITY(U,$J,"OPT",185,1,1,0)
 ;;=Allows user to set site parameters for Automatic Replenishment package.
 ;;^UTILITY(U,$J,"OPT",185,1,2,0)
 ;;=A site parameter called AR/WS AMIS FLAG controls WHEN the collection of
 ;;^UTILITY(U,$J,"OPT",185,1,3,0)
 ;;=AMIS data begins.  Read all available documentation before setting this
 ;;^UTILITY(U,$J,"OPT",185,1,4,0)
 ;;=parameter!
 ;;^UTILITY(U,$J,"OPT",185,25)
 ;;=SITE^PSGWEE
 ;;^UTILITY(U,$J,"OPT",185,30)
 ;;=
 ;;^UTILITY(U,$J,"OPT",185,31)
 ;;=
 ;;^UTILITY(U,$J,"OPT",185,50)
 ;;=
 ;;^UTILITY(U,$J,"OPT",185,51)
 ;;=
 ;;^UTILITY(U,$J,"OPT",185,"U")
 ;;=SITE PARAMETERS
 ;;^UTILITY(U,$J,"OPT",186,0)
 ;;=PSGW LOOKUP ITEM^Ward/AOU List for an Item (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",186,1,0)
 ;;=^^3^3^2880328^^^
 ;;^UTILITY(U,$J,"OPT",186,1,1,0)
 ;;=This option prints a list of all the wards and their 
 ;;^UTILITY(U,$J,"OPT",186,1,2,0)
 ;;=associated AOUs that stock a particular item. The
 ;;^UTILITY(U,$J,"OPT",186,1,3,0)
 ;;=user must specify the item to be looked up.
 ;;^UTILITY(U,$J,"OPT",186,25)
 ;;=PSGWVW
 ;;^UTILITY(U,$J,"OPT",186,"U")
 ;;=WARD/AOU LIST FOR AN ITEM (80 
 ;;^UTILITY(U,$J,"OPT",187,0)
 ;;=PSGW USAGE REPORT^Usage Report for an Item (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",187,1,0)
 ;;=^^7^7^2900323^^^^
 ;;^UTILITY(U,$J,"OPT",187,1,1,0)
 ;;=This option prints a usage report for (1) a specific item
 ;;^UTILITY(U,$J,"OPT",187,1,2,0)
 ;;=in an AOU, (2) a specific item for all AOUs, (3) all items for an AOU, 
 ;;^UTILITY(U,$J,"OPT",187,1,3,0)
 ;;=or (4) all items for all AOUs.   The user must specify AOU, item name 
 ;;^UTILITY(U,$J,"OPT",187,1,4,0)
 ;;=and the start and stop dates for the report.  The report prints
 ;;^UTILITY(U,$J,"OPT",187,1,5,0)
 ;;=AOU, item, the date of inventory, total quantity dispensed,
 ;;^UTILITY(U,$J,"OPT",187,1,6,0)
 ;;=quantity dispensed by auto-replenishment, quantity dispensed
 ;;^UTILITY(U,$J,"OPT",187,1,7,0)
 ;;=by on-demand requests, and quantity returned.
 ;;^UTILITY(U,$J,"OPT",187,25)
 ;;=PSGWTOT
