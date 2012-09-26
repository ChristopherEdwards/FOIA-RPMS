PSGWI037 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",187,"U")
 ;;=USAGE REPORT FOR AN ITEM (80 C
 ;;^UTILITY(U,$J,"OPT",188,0)
 ;;=PSGW ON-DEMAND NURSING EDIT^Enter/Edit Nurses' On-Demand Request (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",188,1,0)
 ;;=^^10^10^2890726^^^^
 ;;^UTILITY(U,$J,"OPT",188,1,1,0)
 ;;=This option is used to enter an on-demand request by the Nursing
 ;;^UTILITY(U,$J,"OPT",188,1,2,0)
 ;;=Staff.  An on-demand request is the non-scheduled distribution
 ;;^UTILITY(U,$J,"OPT",188,1,3,0)
 ;;=of an item to an AOU.  If there is a backorder on the requested
 ;;^UTILITY(U,$J,"OPT",188,1,4,0)
 ;;=item, the backorder total is displayed, but the user is not
 ;;^UTILITY(U,$J,"OPT",188,1,5,0)
 ;;=allowed to enter quantity to be dispensed.
 ;;^UTILITY(U,$J,"OPT",188,1,6,0)
 ;;=If the item requested is currently not stocked in that AOU, the
 ;;^UTILITY(U,$J,"OPT",188,1,7,0)
 ;;=user is NOT allowed to add it with this option.  Requests for
 ;;^UTILITY(U,$J,"OPT",188,1,8,0)
 ;;=non-standard items must be made through the pharmacy by phone or
 ;;^UTILITY(U,$J,"OPT",188,1,9,0)
 ;;=form.  After entering the request, the user may print a report
 ;;^UTILITY(U,$J,"OPT",188,1,10,0)
 ;;=of the request.
 ;;^UTILITY(U,$J,"OPT",188,25)
 ;;=PSGWODRN
 ;;^UTILITY(U,$J,"OPT",188,"U")
 ;;=ENTER/EDIT NURSES' ON-DEMAND R
 ;;^UTILITY(U,$J,"OPT",189,0)
 ;;=PSGW ENTER/EDIT AMIS DATA^AMIS Data Enter/Edit (Single Drug)^^E^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",189,1,0)
 ;;=^^5^5^2910226^^^^
 ;;^UTILITY(U,$J,"OPT",189,1,1,0)
 ;;=This option allows the entry of AMIS category and conversion number
 ;;^UTILITY(U,$J,"OPT",189,1,2,0)
 ;;=for those drugs used in the Automatic Replenishment/Ward Stock
 ;;^UTILITY(U,$J,"OPT",189,1,3,0)
 ;;=package.  The user must select the drug for which data is to be entered.
 ;;^UTILITY(U,$J,"OPT",189,1,4,0)
 ;;=This option is most likely to be used to edit data entered in the
 ;;^UTILITY(U,$J,"OPT",189,1,5,0)
 ;;="Enter AMIS Data for All Drugs/All AOUs" option.
 ;;^UTILITY(U,$J,"OPT",189,30)
 ;;=PSDRUG(
 ;;^UTILITY(U,$J,"OPT",189,31)
 ;;=AEMQ
 ;;^UTILITY(U,$J,"OPT",189,50)
 ;;=PSDRUG(
 ;;^UTILITY(U,$J,"OPT",189,51)
 ;;=[PSGW ENTER/EDIT AMIS DATA]
 ;;^UTILITY(U,$J,"OPT",189,"U")
 ;;=AMIS DATA ENTER/EDIT (SINGLE D
 ;;^UTILITY(U,$J,"OPT",190,0)
 ;;=PSGW PREPARE AMIS DATA^Prepare AMIS Data^^M^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",190,1,0)
 ;;=^^1^1^2910326^^^^
 ;;^UTILITY(U,$J,"OPT",190,1,1,0)
 ;;=Main option for preparing data base with AR/WS AMIS data.
 ;;^UTILITY(U,$J,"OPT",190,10,0)
 ;;=^19.01PI^7^7
 ;;^UTILITY(U,$J,"OPT",190,10,1,0)
 ;;=189^^7
 ;;^UTILITY(U,$J,"OPT",190,10,1,"^")
 ;;=PSGW ENTER/EDIT AMIS DATA
 ;;^UTILITY(U,$J,"OPT",190,10,2,0)
 ;;=191^^3
 ;;^UTILITY(U,$J,"OPT",190,10,2,"^")
 ;;=PSGW ENTER AMIS DATA/ALL DRUGS
 ;;^UTILITY(U,$J,"OPT",190,10,3,0)
 ;;=192^^1
 ;;^UTILITY(U,$J,"OPT",190,10,3,"^")
 ;;=PSGW PRINT AMIS WORKSHEET
 ;;^UTILITY(U,$J,"OPT",190,10,4,0)
 ;;=193^^5
 ;;^UTILITY(U,$J,"OPT",190,10,4,"^")
 ;;=PSGW PRINT DATA FOR AMIS STATS
 ;;^UTILITY(U,$J,"OPT",190,10,5,0)
 ;;=194^^9
 ;;^UTILITY(U,$J,"OPT",190,10,5,"^")
 ;;=PSGW AOU RETURNS & AMIS COUNT
 ;;^UTILITY(U,$J,"OPT",190,10,6,0)
 ;;=195^^13
 ;;^UTILITY(U,$J,"OPT",190,10,6,"^")
 ;;=PSGW AOU RET/AMIS CT PRINT
 ;;^UTILITY(U,$J,"OPT",190,10,7,0)
 ;;=742^^11
 ;;^UTILITY(U,$J,"OPT",190,10,7,"^")
 ;;=PSGW INPUT AOU INP SITE
 ;;^UTILITY(U,$J,"OPT",190,99)
 ;;=55612,32986
 ;;^UTILITY(U,$J,"OPT",190,"U")
 ;;=PREPARE AMIS DATA
 ;;^UTILITY(U,$J,"OPT",191,0)
 ;;=PSGW ENTER AMIS DATA/ALL DRUGS^Enter AMIS Data for All Drugs/All AOUs^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",191,1,0)
 ;;=^^5^5^2870902^^
 ;;^UTILITY(U,$J,"OPT",191,1,1,0)
 ;;=This routine will display for the user, all drugs in all AOUs,
 ;;^UTILITY(U,$J,"OPT",191,1,2,0)
 ;;=allowing the entry of data needed for AMIS calculations.
 ;;^UTILITY(U,$J,"OPT",191,1,3,0)
 ;;=The drugs will be displayed alphabetically by "type".
 ;;^UTILITY(U,$J,"OPT",191,1,4,0)
 ;;=For each drug, the user will be asked for AMIS category and
 ;;^UTILITY(U,$J,"OPT",191,1,5,0)
 ;;=AMIS conversion number.
 ;;^UTILITY(U,$J,"OPT",191,25)
 ;;=PSGWADE
