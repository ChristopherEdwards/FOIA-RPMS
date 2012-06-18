ATXPOST ; IHS/OHPRD/TMJ - POST INIT VS 5.1 ; 
 ;;5.1;TAXONOMY;;FEB 04, 1997
 ;
 ;Post Init for Version 5.1
 ;
 ;Check to see if Taxonomy file exists
 I '$D(^ATXAX(0)) W !!,"You do not have the Taxonomy System Installed",!,"I will NOT run the Post Init!" H 5 Q
 ;
 ;Fix 21st Node of Taxonomy Global to be consistent
 ;
 D ^ATX21FX
 ;
 ;Install Surveillance Pneumococcal Risk Taxonomy
 ;
 D ^ATXTX
 Q
