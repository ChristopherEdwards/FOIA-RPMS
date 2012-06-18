APCLP6 ; IHS/CMI/LAB - post init to patch 5 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;add new report to menu
 NEW X
 S X=$$ADD^XPDMENU("APCL M MAN ALL REPORTS","APCL CNTS GENERAL/DENTAL","GCDC")
 I 'X W "Attempt to add General/Dental Report option failed." H 3
 Q
