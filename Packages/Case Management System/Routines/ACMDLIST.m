ACMDLIST ; IHS/TUCSON/TMJ - SORT/PRINT CONTROLLER FOR DISPLAY SUPPORT LIST ;
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
 ;
ENTRY ;Entry Point to establish Register Name/Variables
 S ACMENTRY=$T(@ACMENTRY^ACMCTRL1)
 ;
 ;Screen to determine PRINT or PRINT2 (One or ALL Registers)
 I $E(ACMENTRY,1,4)="REGL" G PRINT2
 ;
 ;
PRINT ;Establish Sort & Print Variables for Register selected at Entry Point
 S DIOEND="W:IOST[""C-"" !!,""End of report. Strike <CR> to continue."" R:IOST[""C-"" ACMX:300 W:$D(IOF) @IOF"
 D ^ACMSRT2 ;Gets Print Template Name from CMS Sort File
 S BY="REGISTER,REGISTER",FR=ACMRGNA,TO=ACMRGNA,L=0,DIC=ACMDIC
 D EN1^DIP
 Q
 ;
PRINT2 ;Sorts by all Registers - Not the Register selected at Entry Point
 S DIOEND="W:IOST[""C-"" !!,""End of report. Strike <CR> to continue."" R:IOST[""C-"" ACMX:300 W:$D(IOF) @IOF"
 D ^ACMSRT2
 S BY="REGISTER TYPE",FR="",TO="",L=0,DIC=ACMDIC
 D EN1^DIP
 Q
 ;
