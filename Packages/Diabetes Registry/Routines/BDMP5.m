BDMP5 ; IHS/CMI/LAB - post init to patch 5 ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;add new report to menu
 NEW X
 S X=$$ADD^XPDMENU("BDM M MAN ALL REPORTS","BDM CNTS GENERAL/DENTAL","GCDC")
 I 'X W "Attempt to add General/Dental Report option failed." H 3
 Q
