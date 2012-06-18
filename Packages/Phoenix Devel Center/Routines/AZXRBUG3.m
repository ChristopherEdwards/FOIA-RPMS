AZXRBUG3 ;BUGDRUG2 Reports PROGRAM [ 06/08/93  7:53 AM ]
 ;Version 1
 ;08/04/92   JOHN H. LYNCH
 ;
 ;ALLOWS THE DATA ENTRY PERSON TO CHOOSE WHICH
 ;REPORT TO PRINT FROM THE BUGDRUG2 DATABASE.
 
 ;THE ROUTINE THAT CALLS AZXRBUG3:
 ;AZXRBUG, Main
 
 ;THE ROUTINES THAT AZXRBUG3 CALLS:
 ;AZXRBUG4, Verification
 ;AZXRBUG5, Antibiotic Sensitivities
 ;AZXRBUG6, Cultured Organisms by Source
 ;AZXRBUG8, Code Print Report (Specimen or Organism)
 
 ;Variable List
 ;OPTION=           Users input on which report to run.
 
MAIN ;AZXRBUG3 PROGRAM CONTROL    
 ;SET LOCAL VARIABLES
 
 D MAINMENU
 K OPTION
 Q
 
MAINMENU ;MAIN MENU OF OPTIONS
 ;CLEAR SCREEN
 W @IOF
 
 W !!!!!!,?29,"BugDrug2 Database"
 W !,?21,"Phoenix Area Indian Health Service"
 W !,?34,"REPORTS"
 W !!,?21,"Verification...................[1]"
 W !,?21,"Antibiotic Sensitivity.........[2]"
 W !,?21,"Cultured Organisms by Source...[3]"
 W !,?21,"Organism/Specimen Code Print...[4]"
 W !,?21,"Quit...........................[5]"
 W !!,?33,"Option: " R OPTION
 
 I OPTION=1 D ^AZXRBUG4 G MAINMENU
 I OPTION=2 D ^AZXRBUG5 G MAINMENU
 I OPTION=3 D ^AZXRBUG6 G MAINMENU
 I OPTION=4 D ^AZXRBUG8 G MAINMENU
 I (OPTION=5)!(OPTION="")!(OPTION="^") Q
 G MAINMENU
 Q
