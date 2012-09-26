PSGWI042 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",214,1,1,0)
 ;;=This option will "copy" the active stock entries from a selected
 ;;^UTILITY(U,$J,"OPT",214,1,2,0)
 ;;=Area of Use into one or more selected Areas.  As many as 10 Areas
 ;;^UTILITY(U,$J,"OPT",214,1,3,0)
 ;;=may be chosen for transfer at one time.  You may transfer either
 ;;^UTILITY(U,$J,"OPT",214,1,4,0)
 ;;=the drug name only, or the drug name, stock level, and location
 ;;^UTILITY(U,$J,"OPT",214,1,5,0)
 ;;=code.  The "copy" process will not copy inactive drugs or duplicate 
 ;;^UTILITY(U,$J,"OPT",214,1,6,0)
 ;;=entries.  The actual transfer takes place in a background job which
 ;;^UTILITY(U,$J,"OPT",214,1,7,0)
 ;;=is automatically queued.  When the transfer is complete, you will
 ;;^UTILITY(U,$J,"OPT",214,1,8,0)
 ;;=be notified by a MailMan message.
 ;;^UTILITY(U,$J,"OPT",214,25)
 ;;=PSGWTR
 ;;^UTILITY(U,$J,"OPT",214,"U")
 ;;=TRANSFER AOU STOCK ENTRIES
 ;;^UTILITY(U,$J,"OPT",216,0)
 ;;=PSGW SINGLE ITEM COST^Single Item Cost Report (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",216,1,0)
 ;;=^^2^2^2930611^^^
 ;;^UTILITY(U,$J,"OPT",216,1,1,0)
 ;;=For a selected date range, this option gives total cost for a single
 ;;^UTILITY(U,$J,"OPT",216,1,2,0)
 ;;=item from one AOU, several AOUs, or ALL AOUs.
 ;;^UTILITY(U,$J,"OPT",216,25)
 ;;=PSGWSC
 ;;^UTILITY(U,$J,"OPT",216,"U")
 ;;=SINGLE ITEM COST REPORT (80 CO
 ;;^UTILITY(U,$J,"OPT",597,0)
 ;;=PSGW EXPIRATION ENTER/EDIT^Expiration Date - Enter/Edit^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",597,1,0)
 ;;=^^2^2^2890830^^^
 ;;^UTILITY(U,$J,"OPT",597,1,1,0)
 ;;=This option will allow the entry of expiration dates for the items
 ;;^UTILITY(U,$J,"OPT",597,1,2,0)
 ;;=in an AOU.
 ;;^UTILITY(U,$J,"OPT",597,25)
 ;;=PSGWEXP
 ;;^UTILITY(U,$J,"OPT",597,"U")
 ;;=EXPIRATION DATE - ENTER/EDIT
 ;;^UTILITY(U,$J,"OPT",605,0)
 ;;=PSGW AOU INACTIVATION^Inactivate AOU^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",605,1,0)
 ;;=^^2^2^2890130^^^
 ;;^UTILITY(U,$J,"OPT",605,1,1,0)
 ;;=This option will allow the user to inactivate an AOU.  An Inactive
 ;;^UTILITY(U,$J,"OPT",605,1,2,0)
 ;;=Date may be in the future.
 ;;^UTILITY(U,$J,"OPT",605,25)
 ;;=PSGWAOUI
 ;;^UTILITY(U,$J,"OPT",605,"U")
 ;;=INACTIVATE AOU
 ;;^UTILITY(U,$J,"OPT",606,0)
 ;;=PSGW WARD CONVERSION^Ward (For Item) Conversion^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",606,1,0)
 ;;=^^6^6^2890809^^^^
 ;;^UTILITY(U,$J,"OPT",606,1,1,0)
 ;;=This option will enable a user to change the WARD (FOR ITEM) designation
 ;;^UTILITY(U,$J,"OPT",606,1,2,0)
 ;;=from the old ward to a new ward for all Items in all AOUs or a single AOU.
 ;;^UTILITY(U,$J,"OPT",606,1,3,0)
 ;;=This can be used, for example, when a ward is closed down for construction.
 ;;^UTILITY(U,$J,"OPT",606,1,4,0)
 ;;=A background job can be queued for a later time to do the conversion and
 ;;^UTILITY(U,$J,"OPT",606,1,5,0)
 ;;=a MailMan message will be sent to the person who queued the job when it
 ;;^UTILITY(U,$J,"OPT",606,1,6,0)
 ;;=has run to completion.
 ;;^UTILITY(U,$J,"OPT",606,25)
 ;;=PSGWCHG
 ;;^UTILITY(U,$J,"OPT",606,"U")
 ;;=WARD (FOR ITEM) CONVERSION
 ;;^UTILITY(U,$J,"OPT",607,0)
 ;;=PSGW DELETE INVENTORY^Delete Inventory Date/Time^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",607,1,0)
 ;;=^^3^3^2890214^^^^
 ;;^UTILITY(U,$J,"OPT",607,1,1,0)
 ;;=This option will allow a user to delete an Inventory Sheet that has no
 ;;^UTILITY(U,$J,"OPT",607,1,2,0)
 ;;=entries in the Pharmacy AOU Stock file (#58.1), or in the Pharmacy
 ;;^UTILITY(U,$J,"OPT",607,1,3,0)
 ;;=Backorder file (#58.3).
 ;;^UTILITY(U,$J,"OPT",607,25)
 ;;=PSGWDEL
 ;;^UTILITY(U,$J,"OPT",607,"U")
 ;;=DELETE INVENTORY DATE/TIME
 ;;^UTILITY(U,$J,"OPT",608,0)
 ;;=PSGW STOCK ITEM DATA^Print AR/WS Stock Item Data (132 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",608,1,0)
 ;;=^^4^4^2891019^^^^
 ;;^UTILITY(U,$J,"OPT",608,1,1,0)
 ;;=This option will print a listing of all ACTIVE items defined in 
 ;;^UTILITY(U,$J,"OPT",608,1,2,0)
 ;;=the Pharmacy AOU Stock file (#58.1) in alphabetical order.  The 
 ;;^UTILITY(U,$J,"OPT",608,1,3,0)
 ;;=report will show all AOUs that stock the item, stock levels,
 ;;^UTILITY(U,$J,"OPT",608,1,4,0)
 ;;=all Wards (For Item), all Types, and location.
