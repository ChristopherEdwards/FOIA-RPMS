PSGWI040 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",204,1,3,0)
 ;;=(It will print only Bottom Totals if desired.)
 ;;^UTILITY(U,$J,"OPT",204,1,4,0)
 ;;=The report gives a total of all quantities dispensed and all drug costs
 ;;^UTILITY(U,$J,"OPT",204,1,5,0)
 ;;=for that AOU.  Also, if wards/locations and services have been defined
 ;;^UTILITY(U,$J,"OPT",204,1,6,0)
 ;;=for the AOU, a breakdown report will print.  It shows the defined 
 ;;^UTILITY(U,$J,"OPT",204,1,7,0)
 ;;=wards/locations percentage of total, and cost per ward/location.
 ;;^UTILITY(U,$J,"OPT",204,1,8,0)
 ;;=If services are defined, it shows the defined services, percentage of
 ;;^UTILITY(U,$J,"OPT",204,1,9,0)
 ;;=ward/location and cost per service.  The report may be queued to print 
 ;;^UTILITY(U,$J,"OPT",204,1,10,0)
 ;;=at a later time.
 ;;^UTILITY(U,$J,"OPT",204,25)
 ;;=PSGWCPA
 ;;^UTILITY(U,$J,"OPT",204,"U")
 ;;=COST REPORT PER AOU (80 COLUMN
 ;;^UTILITY(U,$J,"OPT",205,0)
 ;;=PSGW SHOW AREA OF USE^Show AOU/Ward/Service (132 column)^^P^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",205,1,0)
 ;;=^^2^2^2890906^^^^
 ;;^UTILITY(U,$J,"OPT",205,1,1,0)
 ;;=This option allows the user to see the AOUs/wards/services created in the
 ;;^UTILITY(U,$J,"OPT",205,1,2,0)
 ;;="Create the Area of Use" option.
 ;;^UTILITY(U,$J,"OPT",205,60)
 ;;=PSI(58.1,
 ;;^UTILITY(U,$J,"OPT",205,62)
 ;;=0
 ;;^UTILITY(U,$J,"OPT",205,63)
 ;;=[PSGW SHOW AREA OF USE]
 ;;^UTILITY(U,$J,"OPT",205,64)
 ;;=[PSGW SHOW AREA OF USE]
 ;;^UTILITY(U,$J,"OPT",205,65)
 ;;=FIRST
 ;;^UTILITY(U,$J,"OPT",205,66)
 ;;=LAST
 ;;^UTILITY(U,$J,"OPT",205,"U")
 ;;=SHOW AOU/WARD/SERVICE (132 COL
 ;;^UTILITY(U,$J,"OPT",206,0)
 ;;=PSGW HIGH COST^High Cost Report (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",206,1,0)
 ;;=^^5^5^2910212^^^^
 ;;^UTILITY(U,$J,"OPT",206,1,1,0)
 ;;=This option allows the user to see drugs/items dispensed in AR/WS
 ;;^UTILITY(U,$J,"OPT",206,1,2,0)
 ;;=in alphabetical or cost order.  The user selects a date range, and
 ;;^UTILITY(U,$J,"OPT",206,1,3,0)
 ;;=a "cut off" amount for the report.  The report may be calculated for
 ;;^UTILITY(U,$J,"OPT",206,1,4,0)
 ;;=a single AOU, or cumulatively for all AOUs.  Report may be queued to
 ;;^UTILITY(U,$J,"OPT",206,1,5,0)
 ;;=print at a later time.
 ;;^UTILITY(U,$J,"OPT",206,25)
 ;;=PSGWHC
 ;;^UTILITY(U,$J,"OPT",206,"U")
 ;;=HIGH COST REPORT (80 COLUMN)
 ;;^UTILITY(U,$J,"OPT",207,0)
 ;;=PSGW HIGH VOLUME^High Volume Report (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",207,1,0)
 ;;=^^3^3^2870902^^
 ;;^UTILITY(U,$J,"OPT",207,1,1,0)
 ;;=For a selected date range, the user may print a report showing
 ;;^UTILITY(U,$J,"OPT",207,1,2,0)
 ;;=drug usage in decreasing order for either a selected AOU or
 ;;^UTILITY(U,$J,"OPT",207,1,3,0)
 ;;=for all AOUs combined.
 ;;^UTILITY(U,$J,"OPT",207,10,0)
 ;;=^19.01IP^0^0
 ;;^UTILITY(U,$J,"OPT",207,25)
 ;;=PSGWHV
 ;;^UTILITY(U,$J,"OPT",207,"U")
 ;;=HIGH VOLUME REPORT (80 COLUMN)
 ;;^UTILITY(U,$J,"OPT",208,0)
 ;;=PSGW PRINT SETUP LISTS^Print Set Up Lists^^M^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",208,1,0)
 ;;=^^2^2^2870902^^
 ;;^UTILITY(U,$J,"OPT",208,1,1,0)
 ;;=This option contains all "reports" or lists associated with setting
 ;;^UTILITY(U,$J,"OPT",208,1,2,0)
 ;;=up the files for AR/WS.
 ;;^UTILITY(U,$J,"OPT",208,10,0)
 ;;=^19.01PI^6^6
 ;;^UTILITY(U,$J,"OPT",208,10,1,0)
 ;;=166^^1
 ;;^UTILITY(U,$J,"OPT",208,10,1,"^")
 ;;=PSGW INV TYPE
 ;;^UTILITY(U,$J,"OPT",208,10,2,0)
 ;;=164^^3
 ;;^UTILITY(U,$J,"OPT",208,10,2,"^")
 ;;=PSGW ITEM LOC PRINT
 ;;^UTILITY(U,$J,"OPT",208,10,3,0)
 ;;=205^^5
 ;;^UTILITY(U,$J,"OPT",208,10,3,"^")
 ;;=PSGW SHOW AREA OF USE
 ;;^UTILITY(U,$J,"OPT",208,10,4,0)
 ;;=160^^7
 ;;^UTILITY(U,$J,"OPT",208,10,4,"^")
 ;;=PSGW PRINT AOU STOCK
 ;;^UTILITY(U,$J,"OPT",208,10,5,0)
 ;;=159^^9
 ;;^UTILITY(U,$J,"OPT",208,10,5,"^")
 ;;=PSGW AOU INV GROUP PRINT
 ;;^UTILITY(U,$J,"OPT",208,10,6,0)
 ;;=608^^6
 ;;^UTILITY(U,$J,"OPT",208,10,6,"^")
 ;;=PSGW STOCK ITEM DATA
 ;;^UTILITY(U,$J,"OPT",208,99)
 ;;=55612,32994
 ;;^UTILITY(U,$J,"OPT",208,"U")
 ;;=PRINT SET UP LISTS
 ;;^UTILITY(U,$J,"OPT",209,0)
 ;;=PSGW ZERO USAGE^Zero Usage Report (80 column)^^R^^^^^^^^
