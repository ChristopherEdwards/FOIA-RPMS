AZXRBUG ;BUGDRUG2 DATABASE PROGRAM [ 02/24/94  10:47 AM ]
 ;Version 1
 ;08/04/92    JOHN H. LYNCH
 ;
 ;BUGDRUG2 was created for facilities wanting to
 ;collect and analyze data for reporting capabilities
 ;on drug sensitivities.  Three reports are provided
 ;with BUGDRUG2:  A data input "Verification",
 ;"Cultured Organisms by Source" and "Antibiotic
 ;Sensitivity."
 
 ;THE ROUTINES THAT AZXRBUG CALLS:
 ;AZXRBUG1, Entry/Edit
 ;AZXRBUG2, Purge
 ;AZXRBUG3, Reports
 
 ;THE ROUTINES THAT AZXRBUG3 (Reports) CALLS:
 ;AZXRBUG4, Verification
 ;AZXRBUG5, Antibiotic Sensitivities
 ;AZXRBUG6, Cultured Organisms by Source
 
 ;AZXRBUG5 AND AZXRBUG6 CALL:
 ;AZXRBUG7, Reports Input
 
 ;Variable List
 ;OPTION=                   Users input on which option they chose.
 
MAIN ;AZXRBUG PROGRAM CONTROL    
 ;SET LOCAL VARIABLES
 ;D ^XBKSET  ;THIS LINE SHOULD BE UNCOMMENTED IF RUNNING
             ;IN PROGRAMMERS' MODE ONLY!
 
 D MAINMENU
 K OPTION
 Q
 
MAINMENU ;MAIN MENU OF OPTIONS
 ;CLEAR SCREEN
 W @IOF
 
 W !!!!!!,?29,"BugDrug2 Database"
 W !,?21,"Phoenix Area Indian Health Service"
 W !,?32,"MAIN MENU"
 W !!!,?21,"Entry/Edit.....................[1]"
 W !,?21,"Purge..........................[2]"
 W !,?21,"Reports........................[3]"
 W !,?21,"Quit...........................[4]"
 W !!,?33,"Option: " R OPTION
        
 I OPTION=1 D ^AZXRBUG1 G MAINMENU
 I OPTION=2 D ^AZXRBUG2 G MAINMENU
 I OPTION=3 D ^AZXRBUG3 G MAINMENU
 I (OPTION=4)!(OPTION="")!(OPTION="^") Q
 G MAINMENU
 Q
