PSGWI041 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",209,1,0)
 ;;=^^3^3^2910206^^^
 ;;^UTILITY(U,$J,"OPT",209,1,1,0)
 ;;=For a user selected time frame, this report prints all items with no
 ;;^UTILITY(U,$J,"OPT",209,1,2,0)
 ;;=usage.  The report may be printed for a one AOU, several AOUs, or
 ;;^UTILITY(U,$J,"OPT",209,1,3,0)
 ;;=for ALL AOUs.
 ;;^UTILITY(U,$J,"OPT",209,25)
 ;;=PSGWNU
 ;;^UTILITY(U,$J,"OPT",209,"U")
 ;;=ZERO USAGE REPORT (80 COLUMN)
 ;;^UTILITY(U,$J,"OPT",210,0)
 ;;=PSGW RETURNS BREAKDOWN^Returns Analysis Report (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",210,1,0)
 ;;=^^4^4^2910212^^^^
 ;;^UTILITY(U,$J,"OPT",210,1,1,0)
 ;;=For a user selected date range, this report shows the break down of
 ;;^UTILITY(U,$J,"OPT",210,1,2,0)
 ;;=returns information.  The report may be printed for one AOU, several
 ;;^UTILITY(U,$J,"OPT",210,1,3,0)
 ;;=AOUs or for all AOUs.  Return date, return quantity, and return
 ;;^UTILITY(U,$J,"OPT",210,1,4,0)
 ;;=reason are shown for each drug.
 ;;^UTILITY(U,$J,"OPT",210,25)
 ;;=PSGWDR
 ;;^UTILITY(U,$J,"OPT",210,"U")
 ;;=RETURNS ANALYSIS REPORT (80 CO
 ;;^UTILITY(U,$J,"OPT",211,0)
 ;;=PSGW RN^Auto Replenishment/Ward Stock Nurses' Menu^^M^^^^^^^^AR/WS PATCH NAMESPACE^^1^1
 ;;^UTILITY(U,$J,"OPT",211,1,0)
 ;;=^^2^2^2930325^^^^
 ;;^UTILITY(U,$J,"OPT",211,1,1,0)
 ;;=This is the main menu driver for Automatic Replenishment/Ward Stock
 ;;^UTILITY(U,$J,"OPT",211,1,2,0)
 ;;=options for Nurses.
 ;;^UTILITY(U,$J,"OPT",211,10,0)
 ;;=^19.01PI^3^3
 ;;^UTILITY(U,$J,"OPT",211,10,1,0)
 ;;=188^
 ;;^UTILITY(U,$J,"OPT",211,10,1,"^")
 ;;=PSGW ON-DEMAND NURSING EDIT
 ;;^UTILITY(U,$J,"OPT",211,10,2,0)
 ;;=186^
 ;;^UTILITY(U,$J,"OPT",211,10,2,"^")
 ;;=PSGW LOOKUP ITEM
 ;;^UTILITY(U,$J,"OPT",211,10,3,0)
 ;;=160^
 ;;^UTILITY(U,$J,"OPT",211,10,3,"^")
 ;;=PSGW PRINT AOU STOCK
 ;;^UTILITY(U,$J,"OPT",211,15)
 ;;=K PSGWSITE
 ;;^UTILITY(U,$J,"OPT",211,20)
 ;;=I '$D(PSGWSITE) D ^PSGWSET
 ;;^UTILITY(U,$J,"OPT",211,99)
 ;;=55612,32991
 ;;^UTILITY(U,$J,"OPT",211,99.1)
 ;;=54871,46744
 ;;^UTILITY(U,$J,"OPT",211,"U")
 ;;=AUTO REPLENISHMENT/WARD STOCK 
 ;;^UTILITY(U,$J,"OPT",212,0)
 ;;=PSGW UPDATE AMIS STATS^Update AMIS Stats File^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",212,1,0)
 ;;=^^4^4^2930518^^^^
 ;;^UTILITY(U,$J,"OPT",212,1,1,0)
 ;;=This option is a background job scheduled to run each night.  The purpose
 ;;^UTILITY(U,$J,"OPT",212,1,2,0)
 ;;=of the option is to loop through the "temporary" inventory global and move 
 ;;^UTILITY(U,$J,"OPT",212,1,3,0)
 ;;=the data into the AMIS sub-file. The rescheduling frequency for this 
 ;;^UTILITY(U,$J,"OPT",212,1,4,0)
 ;;=option is one day.
 ;;^UTILITY(U,$J,"OPT",212,25)
 ;;=PSGWUAS
 ;;^UTILITY(U,$J,"OPT",212,200)
 ;;=2910731.22^^1D
 ;;^UTILITY(U,$J,"OPT",212,"U")
 ;;=UPDATE AMIS STATS FILE
 ;;^UTILITY(U,$J,"OPT",213,0)
 ;;=PSGW MGT REPORTS^Management Reports^^M^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",213,1,0)
 ;;=^^2^2^2930817^^^^
 ;;^UTILITY(U,$J,"OPT",213,1,1,0)
 ;;=This menu gives access to various management reports, including the
 ;;^UTILITY(U,$J,"OPT",213,1,2,0)
 ;;=printing of the AMIS report.
 ;;^UTILITY(U,$J,"OPT",213,10,0)
 ;;=^19.01PI^7^7
 ;;^UTILITY(U,$J,"OPT",213,10,1,0)
 ;;=196^^1
 ;;^UTILITY(U,$J,"OPT",213,10,1,"^")
 ;;=PSGW AMIS
 ;;^UTILITY(U,$J,"OPT",213,10,2,0)
 ;;=204^^3
 ;;^UTILITY(U,$J,"OPT",213,10,2,"^")
 ;;=PSGW COST PER AOU
 ;;^UTILITY(U,$J,"OPT",213,10,3,0)
 ;;=206^^7
 ;;^UTILITY(U,$J,"OPT",213,10,3,"^")
 ;;=PSGW HIGH COST
 ;;^UTILITY(U,$J,"OPT",213,10,4,0)
 ;;=207^^9
 ;;^UTILITY(U,$J,"OPT",213,10,4,"^")
 ;;=PSGW HIGH VOLUME
 ;;^UTILITY(U,$J,"OPT",213,10,5,0)
 ;;=216^^5
 ;;^UTILITY(U,$J,"OPT",213,10,5,"^")
 ;;=PSGW SINGLE ITEM COST
 ;;^UTILITY(U,$J,"OPT",213,10,6,0)
 ;;=1314
 ;;^UTILITY(U,$J,"OPT",213,10,6,"^")
 ;;=PSGW DUPLICATE REPORT
 ;;^UTILITY(U,$J,"OPT",213,10,7,0)
 ;;=1316
 ;;^UTILITY(U,$J,"OPT",213,10,7,"^")
 ;;=PSGW STANDARD COST REPORT
 ;;^UTILITY(U,$J,"OPT",213,99)
 ;;=55746,45030
 ;;^UTILITY(U,$J,"OPT",213,"U")
 ;;=MANAGEMENT REPORTS
 ;;^UTILITY(U,$J,"OPT",214,0)
 ;;=PSGW TRANSFER ENTRIES^Transfer AOU Stock Entries^^R^^PSGW TRAN^^^^^^
 ;;^UTILITY(U,$J,"OPT",214,1,0)
 ;;=^^8^8^2871210^^^
