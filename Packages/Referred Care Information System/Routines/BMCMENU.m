BMCMENU ; IHS/PHXAO/TMJ - Adds Menu to RCIS ;  
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 W !,"I Will now update BMC5 Menu Options to Top Level",!
 D ADD1,ADD2,ADD3
ADD1 ;Add 1st Menu
 ;BMC5 RPT-WEEKLY RRR FACILITY
 NEW X
 S X=$$ADD^XPDMENU("BMC MENU-RPTS ADMINISTRATIVE","BMC5 RPT-WEEKLY RRR FACILITY","RRRF")
 I 'X W "Attempt to add RRR Report By Facility option failed." H 3
 Q
 ;
ADD2 ;Add 2nd Menu
 ;BMC5 RPT CASE REVIEW
 NEW X
 S X=$$ADD^XPDMENU("BMC MENU-RPTS ADMINISTRATIVE","BMC5 RPT CASE REVIEW","CRD")
 I 'X W "Attempt to add Case Review Comments (By Date/Facility) option failed." H 3
 Q
 ;
ADD3 ;Add 3rd Menu
 ;BMC5 SCHEDULE STATUS
 NEW X
 S X=$$ADD^XPDMENU("BMC MENU-DATA ENTRY","BMC5 SCHEDULE STATUS","SAS")
 I 'X W "Attempt to add Case Review Comments (By Date/Facility) option failed." H 3
 Q
 ;
DEL1 ;Delete Menu Option 
 ;BMC CASE REVIEW DATE
 NEW X
 S X=$$DELETE^XPDMENU("BMC MENU-RPTS ADMINISTRATIVE","BMC RPT CASE REVIEW")
 I 'X W "Attempt to delete old Menu Option failed." H 3
 Q
