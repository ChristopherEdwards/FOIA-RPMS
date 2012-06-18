DGV53PR ;alb/mjk - DG Application Specific Init Driver for v5.3 ; 3/26/93
 ;;5.3;Registration;;Aug 13, 1993
 ;
EN ; -- main entry point
 D LINE^DGVPP,DD     ; bene travel
 D LINE^DGVPP,DELEX  ; ptf
ENQ Q
 ;
DD ; -- dd clean up
 W !!,">>> The current data dictionary for the BENEFICIARY TRAVEL DISTANCE"
 W !?4,"file (#392.1) is being removed in order to delete the Mileage"
 W !?4,"identifier before the new data dictionary is installed.",!
 S DIU="^DGBT(392.1,",DIU(0)="" D EN^DIU2 K DIU
 W !,">>> Completed."
 Q
DELEX ;-- This function will delete the PTF EXPANDED CODE file (#45.89)
 ;   and it's data.
 ;
 W !!,">>> Deleting PTF EXPANDED CODE file (#45.89)."
 W !!?5,"The PTF EXPANDED CODE file (#45.89) will be re-installed"
 W !?5,"during the init process."
 S DIU="^DIC(45.89,",DIU(0)="D" D EN^DIU2
 K DIU
 W !,">>> Completed."
 Q
 ;
