PSGWI039 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",197,1,4,0)
 ;;=and thus could not be added to the cumulative AMIS statistics.
 ;;^UTILITY(U,$J,"OPT",197,1,5,0)
 ;;=For the selected date range, the drug will be shown, and the user
 ;;^UTILITY(U,$J,"OPT",197,1,6,0)
 ;;=will be asked to supply the missing data.  At that time, the routine
 ;;^UTILITY(U,$J,"OPT",197,1,7,0)
 ;;=will update the AMIS statistics, and delete the "AEX" cross-reference.
 ;;^UTILITY(U,$J,"OPT",197,25)
 ;;=PSGWCL
 ;;^UTILITY(U,$J,"OPT",197,"U")
 ;;=INCOMPLETE AMIS DATA
 ;;^UTILITY(U,$J,"OPT",198,0)
 ;;=PSGW RECALCULATE AMIS^Recalculate AMIS^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",198,1,0)
 ;;=^^5^5^2870902^^
 ;;^UTILITY(U,$J,"OPT",198,1,1,0)
 ;;=This option should be used ONLY after the AMIS report has been run,
 ;;^UTILITY(U,$J,"OPT",198,1,2,0)
 ;;=results have been found to be in error, and data in the Drug file
 ;;^UTILITY(U,$J,"OPT",198,1,3,0)
 ;;=has been changed to reflect the correct information.  The purpose
 ;;^UTILITY(U,$J,"OPT",198,1,4,0)
 ;;=of this option is to correct the AMIS when data entry errors have
 ;;^UTILITY(U,$J,"OPT",198,1,5,0)
 ;;=caused the results to be inaccurate.
 ;;^UTILITY(U,$J,"OPT",198,25)
 ;;=PSGWRA
 ;;^UTILITY(U,$J,"OPT",198,"U")
 ;;=RECALCULATE AMIS
 ;;^UTILITY(U,$J,"OPT",199,0)
 ;;=PSGW PRINT AMIS REPORT^Print AMIS Report (132 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",199,1,0)
 ;;=^^2^2^2890126^^^^
 ;;^UTILITY(U,$J,"OPT",199,1,1,0)
 ;;=This option prints the AMIS report.  Right margin should be at 132.
 ;;^UTILITY(U,$J,"OPT",199,1,2,0)
 ;;=The report may be queued to print at a later time.
 ;;^UTILITY(U,$J,"OPT",199,25)
 ;;=PSGWAR
 ;;^UTILITY(U,$J,"OPT",199,99)
 ;;=53515,48652
 ;;^UTILITY(U,$J,"OPT",199,"U")
 ;;=PRINT AMIS REPORT (132 COLUMN)
 ;;^UTILITY(U,$J,"OPT",201,0)
 ;;=PSGW PURGE^Obsolete Data Purge^^M^^PSGW PURGE^^^^^^
 ;;^UTILITY(U,$J,"OPT",201,1,0)
 ;;=^^1^1^2880114^^^^
 ;;^UTILITY(U,$J,"OPT",201,1,1,0)
 ;;=This option is the main menu driver for purging AR/WS files.
 ;;^UTILITY(U,$J,"OPT",201,10,0)
 ;;=^19.01PI^2^2
 ;;^UTILITY(U,$J,"OPT",201,10,1,0)
 ;;=202^
 ;;^UTILITY(U,$J,"OPT",201,10,1,"^")
 ;;=PSGW PURGE AMIS
 ;;^UTILITY(U,$J,"OPT",201,10,2,0)
 ;;=203^
 ;;^UTILITY(U,$J,"OPT",201,10,2,"^")
 ;;=PSGW PURGE FILES
 ;;^UTILITY(U,$J,"OPT",201,99)
 ;;=55612,32988
 ;;^UTILITY(U,$J,"OPT",201,"U")
 ;;=OBSOLETE DATA PURGE
 ;;^UTILITY(U,$J,"OPT",202,0)
 ;;=PSGW PURGE AMIS^AMIS Data Purge^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",202,1,0)
 ;;=^^4^4^2910212^^^^
 ;;^UTILITY(U,$J,"OPT",202,1,1,0)
 ;;=This option allows the user to delete data from File 58.5 - the
 ;;^UTILITY(U,$J,"OPT",202,1,2,0)
 ;;=AR/WS Stats File.  Data should be kept in this file for at least
 ;;^UTILITY(U,$J,"OPT",202,1,3,0)
 ;;=one quarter.  The routine will not allow users to delete data
 ;;^UTILITY(U,$J,"OPT",202,1,4,0)
 ;;=that is less than 100 days old.  The option is automatically queued.
 ;;^UTILITY(U,$J,"OPT",202,25)
 ;;=PSGWAP
 ;;^UTILITY(U,$J,"OPT",202,"U")
 ;;=AMIS DATA PURGE
 ;;^UTILITY(U,$J,"OPT",203,0)
 ;;=PSGW PURGE FILES^Purge Dispensing Data^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",203,1,0)
 ;;=^^5^5^2930624^^^^
 ;;^UTILITY(U,$J,"OPT",203,1,1,0)
 ;;=This option allows the user to delete data from Files 58.1, 58.3,
 ;;^UTILITY(U,$J,"OPT",203,1,2,0)
 ;;=and 58.19.  Data should be kept in these files for at least one
 ;;^UTILITY(U,$J,"OPT",203,1,3,0)
 ;;=quarter.  The routine will not allow users to delete data that is
 ;;^UTILITY(U,$J,"OPT",203,1,4,0)
 ;;=less than 100 days old.  Since the option is CPU intensive, it should
 ;;^UTILITY(U,$J,"OPT",203,1,5,0)
 ;;=be queued to run during the "off" hours.  
 ;;^UTILITY(U,$J,"OPT",203,25)
 ;;=PSGWOLD
 ;;^UTILITY(U,$J,"OPT",203,"U")
 ;;=PURGE DISPENSING DATA
 ;;^UTILITY(U,$J,"OPT",204,0)
 ;;=PSGW COST PER AOU^Cost Report Per AOU (80 column)^^R^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",204,1,0)
 ;;=^^10^10^2910221^^^^
 ;;^UTILITY(U,$J,"OPT",204,1,1,0)
 ;;=For a user selected date range, this report will show all active drugs for
 ;;^UTILITY(U,$J,"OPT",204,1,2,0)
 ;;=one AOU, several AOUs, or ALL AOUs, with total quantity dispensed and cost.
