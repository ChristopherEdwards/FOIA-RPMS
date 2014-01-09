DGYJPT ;ALB/REW - DG*5.3*32 (DGYJ PATIENT LOOK-UP) POST-INIT ; 03 MAY 94
 ;;5.3;Registration;**32,1015**;Aug 13, 1993;Build 21
 ;
 ; This removes the SERVICE CONNECTED? Field (#.301) of the PATIENT File
 ; as an identifier.
EN ;
 W !,">>> Removing the 'SERVICE CONNECTED?' Field as an identifier of the PATIENT File"
 K ^DD(2,0,"ID",.301)
 W !!," ...Done."
 Q
