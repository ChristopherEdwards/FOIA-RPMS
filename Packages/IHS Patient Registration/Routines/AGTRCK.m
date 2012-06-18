AGTRCK ; IHS/ASDS/EFG - check patient DFN for Transmission ; 
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;given DFN this will report any missing data fields for
S ;errors that will block it from Registration transmission
DFNTR ;EP - External Packages - check transmission required fields for patient DFN
 D ^AGDATCK,^AGBADATA
 K AG,AGOPT,AGQI,AGQT,AGTP
 Q
