PSGWI043 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",608,25)
 ;;=PSGWPSI
 ;;^UTILITY(U,$J,"OPT",608,"U")
 ;;=PRINT AR/WS STOCK ITEM DATA (1
 ;;^UTILITY(U,$J,"OPT",742,0)
 ;;=PSGW INPUT AOU INP SITE^Identify AOU INPATIENT SITE^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",742,1,0)
 ;;=^^3^3^2890830^^^^
 ;;^UTILITY(U,$J,"OPT",742,1,1,0)
 ;;=This option will loop through the PHARMACY AOU STOCK file (#58.1) and
 ;;^UTILITY(U,$J,"OPT",742,1,2,0)
 ;;=locate any active AOU that does not have the INPATIENT SITE field
 ;;^UTILITY(U,$J,"OPT",742,1,3,0)
 ;;=defined.
 ;;^UTILITY(U,$J,"OPT",742,25)
 ;;=PSGWEDIS
 ;;^UTILITY(U,$J,"OPT",742,"U")
 ;;=IDENTIFY AOU INPATIENT SITE
 ;;^UTILITY(U,$J,"OPT",743,0)
 ;;=PSGW BACKORDER (ALL) PRINT^Current (ALL) Backorder Report (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",743,1,0)
 ;;=^^2^2^2890907^^^
 ;;^UTILITY(U,$J,"OPT",743,1,1,0)
 ;;=This option will print a list of ALL current backorders sorted by AOU or
 ;;^UTILITY(U,$J,"OPT",743,1,2,0)
 ;;=by ITEM.
 ;;^UTILITY(U,$J,"OPT",743,25)
 ;;=PSGWBOA
 ;;^UTILITY(U,$J,"OPT",743,"U")
 ;;=CURRENT (ALL) BACKORDER REPORT
 ;;^UTILITY(U,$J,"OPT",744,0)
 ;;=PSGW ITEM INQUIRY^Item Activity Inquiry (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",744,1,0)
 ;;=^^4^4^2890926^
 ;;^UTILITY(U,$J,"OPT",744,1,1,0)
 ;;=This option will display all activity (inventories, on-demands, and
 ;;^UTILITY(U,$J,"OPT",744,1,2,0)
 ;;=returns) for a specified item in a specified AOU for a specified date
 ;;^UTILITY(U,$J,"OPT",744,1,3,0)
 ;;=range.  This option is primarily meant to be used as a tool to identify
 ;;^UTILITY(U,$J,"OPT",744,1,4,0)
 ;;=bad data input.
 ;;^UTILITY(U,$J,"OPT",744,25)
 ;;=PSGWATR
 ;;^UTILITY(U,$J,"OPT",744,"U")
 ;;=ITEM ACTIVITY INQUIRY (80 COLU
 ;;^UTILITY(U,$J,"OPT",745,0)
 ;;=PSGW EDIT INVENTORY USER^Edit 'Person Doing Inventory'^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",745,1,0)
 ;;=^^3^3^2910226^^
 ;;^UTILITY(U,$J,"OPT",745,1,1,0)
 ;;=This option will allow editing of the field PERSON DOING INVENTORY
 ;;^UTILITY(U,$J,"OPT",745,1,2,0)
 ;;=in the Pharmacy AOU Inventory file (#58.19) for a selected Date/Time for
 ;;^UTILITY(U,$J,"OPT",745,1,3,0)
 ;;=Inventory.
 ;;^UTILITY(U,$J,"OPT",745,25)
 ;;=PSGWPERE
 ;;^UTILITY(U,$J,"OPT",745,"U")
 ;;=EDIT 'PERSON DOING INVENTORY'
 ;;^UTILITY(U,$J,"OPT",816,0)
 ;;=PSGW EXP REPORT^Expiration Date Report (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",816,1,0)
 ;;=^^3^3^2901108^^
 ;;^UTILITY(U,$J,"OPT",816,1,1,0)
 ;;=This option will print an Expiration Date Report for a single, several,
 ;;^UTILITY(U,$J,"OPT",816,1,2,0)
 ;;=or ALL AOUs.  For multiple AOUs it can be sorted by DATE/DRUG/AOU or
 ;;^UTILITY(U,$J,"OPT",816,1,3,0)
 ;;=by DATE/AOU/DRUG.
 ;;^UTILITY(U,$J,"OPT",816,25)
 ;;=PSGWEXR
 ;;^UTILITY(U,$J,"OPT",816,"U")
 ;;=EXPIRATION DATE REPORT (80 COL
 ;;^UTILITY(U,$J,"OPT",817,0)
 ;;=PSGW ADD/DEL WARD^Add/Delete Ward (for Item)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",817,1,0)
 ;;=^^2^2^2930219^^^^
 ;;^UTILITY(U,$J,"OPT",817,1,1,0)
 ;;=This option will allow a user to add or delete a Ward (for Item) assignment
 ;;^UTILITY(U,$J,"OPT",817,1,2,0)
 ;;=for all stock items in one or more active AOUs.
 ;;^UTILITY(U,$J,"OPT",817,25)
 ;;=PSGWWRD
 ;;^UTILITY(U,$J,"OPT",817,"U")
 ;;=ADD/DELETE WARD (FOR ITEM)
 ;;^UTILITY(U,$J,"OPT",856,0)
 ;;=PSGW RE-INDEX AMIS^Re-index AMIS Cross-Reference^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",856,1,0)
 ;;=^^11^11^2930518^^^^
 ;;^UTILITY(U,$J,"OPT",856,1,1,0)
 ;;=This option will queue a background job that will re-index the "AMIS"
 ;;^UTILITY(U,$J,"OPT",856,1,2,0)
 ;;=cross-reference for inventories, on-demands, and returns.  This cross-
 ;;^UTILITY(U,$J,"OPT",856,1,3,0)
 ;;=reference is important because this is where the nightly job to update
 ;;^UTILITY(U,$J,"OPT",856,1,4,0)
 ;;=the AR/WS Stats File (#58.5) gets the data for the update.  If this cross-
 ;;^UTILITY(U,$J,"OPT",856,1,5,0)
 ;;=reference is somehow destroyed, it is very important to rebuild it.
 ;;^UTILITY(U,$J,"OPT",856,1,6,0)
 ;;=Though it is possible to accomplish this through VA FileMan, this option
 ;;^UTILITY(U,$J,"OPT",856,1,7,0)
 ;;=is a much quicker and easier alternative.  This option is not tied to
