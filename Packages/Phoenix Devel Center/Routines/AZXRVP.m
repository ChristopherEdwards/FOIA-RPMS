AZXRVP ;PAO/IHS/JHL;VISITS BY PROVIDERS[ 08/30/93  12:33 PM ]
 ;Version 1;VISITS BY PROVIDERS;;****;DATE OF RELEASE HERE
 ;JOHN H. LYNCH
 ;
 
 ;THE ROUTINES THAT AZXRVP CALLS:
 ;AZXRVP1A, Report Input
 ;AZXRVP4, Report re-print
 
 ;THE ROUTINES THAT CALL AZXRVP:
 ;NONE 
 
 ;Variable List
 ;AZXROPT=       Users input on which option they chose.
 
MAIN ;AZXRVP PROGRAM CONTROL    
 ;SET LOCAL VARIABLES
 ;D ^XBKSET  ;THIS LINE SHOULD BE UNCOMMENTED IF RUNNING
             ;IN PROGRAMMERS' MODE ONLY!
 
 D MAINMENU
 K AZXROPT 
 Q
 
MAINMENU ;MAIN MENU OF OPTIONS
 ;CLEAR SCREEN
 W @IOF
 
 W !!!!!!,?28,"Visits by Providers"
 W !,?21,"Phoenix Area Indian Health Service"
 W !,?32,"REPORT MENU"
 W !!!,?21,"Visits by Providers report.....[1]"
 W !,?21,"Visits by Providers re-print...[2]"
 W !,?21,"Quit...........................[0]"
 W !!,?33,"Option: " R AZXROPT
        
 I AZXROPT=1 D ^AZXRVP1A G MAINMENU
 I AZXROPT=2 D ^AZXRVP4 G MAINMENU
 I (AZXROPT=0)!(AZXROPT="")!(AZXROPT="^") Q
 G MAINMENU
 Q
