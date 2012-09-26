PSGWI032 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",157,10,2,0)
 ;;=153^
 ;;^UTILITY(U,$J,"OPT",157,10,2,"^")
 ;;=PSGW WARD STOCK MAINT
 ;;^UTILITY(U,$J,"OPT",157,15)
 ;;=K PSGWSITE
 ;;^UTILITY(U,$J,"OPT",157,20)
 ;;=
 ;;^UTILITY(U,$J,"OPT",157,99)
 ;;=55671,46170
 ;;^UTILITY(U,$J,"OPT",157,99.1)
 ;;=54228,39506
 ;;^UTILITY(U,$J,"OPT",157,"U")
 ;;=AUTOMATIC REPLENISHMENT
 ;;^UTILITY(U,$J,"OPT",158,0)
 ;;=PSGW AOU INV GROUP EDIT^AOU Inventory Group - Enter/Edit^^R^^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",158,1,0)
 ;;=^^4^4^2931214^^^^
 ;;^UTILITY(U,$J,"OPT",158,1,1,0)
 ;;=This option supports entering and editing inventory groups.
 ;;^UTILITY(U,$J,"OPT",158,1,2,0)
 ;;=These groups define a cluster of AOUs and for each AOU, an inventory
 ;;^UTILITY(U,$J,"OPT",158,1,3,0)
 ;;=type which may be multiple.  This lets a pharmacy define a list of standard
 ;;^UTILITY(U,$J,"OPT",158,1,4,0)
 ;;=AOUs and inventory types that can be selected easily when doing inventory.
 ;;^UTILITY(U,$J,"OPT",158,15)
 ;;=
 ;;^UTILITY(U,$J,"OPT",158,25)
 ;;=GROUP^PSGWEE
 ;;^UTILITY(U,$J,"OPT",158,30)
 ;;=
 ;;^UTILITY(U,$J,"OPT",158,31)
 ;;=
 ;;^UTILITY(U,$J,"OPT",158,50)
 ;;=
 ;;^UTILITY(U,$J,"OPT",158,51)
 ;;=
 ;;^UTILITY(U,$J,"OPT",158,"U")
 ;;=AOU INVENTORY GROUP - ENTER/ED
 ;;^UTILITY(U,$J,"OPT",159,0)
 ;;=PSGW AOU INV GROUP PRINT^Inventory Group List (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",159,1,0)
 ;;=^^2^2^2890703^^^^
 ;;^UTILITY(U,$J,"OPT",159,1,1,0)
 ;;=This option prints a list of the currently defined AOU inventory groups
 ;;^UTILITY(U,$J,"OPT",159,1,2,0)
 ;;=with their associated wards and inventory types.
 ;;^UTILITY(U,$J,"OPT",159,25)
 ;;=PSGWPIG
 ;;^UTILITY(U,$J,"OPT",159,60)
 ;;=
 ;;^UTILITY(U,$J,"OPT",159,62)
 ;;=
 ;;^UTILITY(U,$J,"OPT",159,63)
 ;;=
 ;;^UTILITY(U,$J,"OPT",159,64)
 ;;=
 ;;^UTILITY(U,$J,"OPT",159,"U")
 ;;=INVENTORY GROUP LIST (80 COLUM
 ;;^UTILITY(U,$J,"OPT",160,0)
 ;;=PSGW PRINT AOU STOCK^List Stock Items (132 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",160,1,0)
 ;;=^^4^4^2910206^^^^
 ;;^UTILITY(U,$J,"OPT",160,1,1,0)
 ;;=This option prints all items currently available for inventory, by AOU.
 ;;^UTILITY(U,$J,"OPT",160,1,2,0)
 ;;=You may print the report for one AOU, several AOUs, or enter "^ALL"
 ;;^UTILITY(U,$J,"OPT",160,1,3,0)
 ;;=to print the report for all Areas of Use.  The report may be printed (1)
 ;;^UTILITY(U,$J,"OPT",160,1,4,0)
 ;;=in order by AOU/TYPE/LOCATION, or (2) in alphabetical order by item.
 ;;^UTILITY(U,$J,"OPT",160,25)
 ;;=PSGWLSI
 ;;^UTILITY(U,$J,"OPT",160,60)
 ;;=
 ;;^UTILITY(U,$J,"OPT",160,62)
 ;;=
 ;;^UTILITY(U,$J,"OPT",160,63)
 ;;=
 ;;^UTILITY(U,$J,"OPT",160,64)
 ;;=
 ;;^UTILITY(U,$J,"OPT",160,"U")
 ;;=LIST STOCK ITEMS (132 COLUMN)
 ;;^UTILITY(U,$J,"OPT",161,0)
 ;;=PSGW WARD INV PRINT^Inventory Outline (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",161,1,0)
 ;;=^^2^2^2890630^^^^
 ;;^UTILITY(U,$J,"OPT",161,1,1,0)
 ;;=This option lists the principal information for a date range of
 ;;^UTILITY(U,$J,"OPT",161,1,2,0)
 ;;=inventories.
 ;;^UTILITY(U,$J,"OPT",161,25)
 ;;=PSGWAIO
 ;;^UTILITY(U,$J,"OPT",161,60)
 ;;=
 ;;^UTILITY(U,$J,"OPT",161,62)
 ;;=
 ;;^UTILITY(U,$J,"OPT",161,63)
 ;;=
 ;;^UTILITY(U,$J,"OPT",161,64)
 ;;=
 ;;^UTILITY(U,$J,"OPT",161,"U")
 ;;=INVENTORY OUTLINE (80 COLUMN)
 ;;^UTILITY(U,$J,"OPT",162,0)
 ;;=PSGW SETUP^Set Up AR/WS (Build Files)^^M^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",162,1,0)
 ;;=^^2^2^2930607^^^^
 ;;^UTILITY(U,$J,"OPT",162,1,1,0)
 ;;=Options that support management of files typically created and
 ;;^UTILITY(U,$J,"OPT",162,1,2,0)
 ;;=edited during initial set up of Automatic Replenishment/Ward Stock.
 ;;^UTILITY(U,$J,"OPT",162,10,0)
 ;;=^19.01PI^18^15
 ;;^UTILITY(U,$J,"OPT",162,10,3,0)
 ;;=165^^1
 ;;^UTILITY(U,$J,"OPT",162,10,3,"^")
 ;;=PSGW INV TYPE EDIT
 ;;^UTILITY(U,$J,"OPT",162,10,5,0)
 ;;=181^^5
 ;;^UTILITY(U,$J,"OPT",162,10,5,"^")
 ;;=PSGW AREA OF USE EDIT
 ;;^UTILITY(U,$J,"OPT",162,10,6,0)
 ;;=151^^6
 ;;^UTILITY(U,$J,"OPT",162,10,6,"^")
 ;;=PSGW EDIT AOU STOCK
 ;;^UTILITY(U,$J,"OPT",162,10,7,0)
 ;;=152^^13
 ;;^UTILITY(U,$J,"OPT",162,10,7,"^")
 ;;=PSGW INACTIVATE AOU STOCK ITEM
 ;;^UTILITY(U,$J,"OPT",162,10,8,0)
 ;;=158^^14
