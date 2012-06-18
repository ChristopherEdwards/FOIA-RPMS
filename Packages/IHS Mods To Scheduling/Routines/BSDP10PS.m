BSDP10PS ;cmi/anch/maw - PIMS Patch 1010 Post Init 2/27/2007 10:32:52 AM
 ;;5.3;PIMS;**1010**;FEB 27,2007;
 ;
 ;
 ;
 ;
EN ;EP - Post Init Entry Point
 D ADDMENU
 Q
 ;
ADDMENU ;-- add menu items
 N X
 S X=$$ADD^XPDMENU("BSD MENU SUPERVISOR","BSDSM INACTIVATE WAIT LIST","IWL","")
 I 'X W !,"Attempt to add BSDSM INACTIVATE WAIT LIST option failed.." H 3
 S X=$$ADD^XPDMENU("BDG SECURITY MENU","BDG SECURITY REPORT USER","UAR","")
 I 'X W !,"Attempt to add BDG SECURITY REPORT USER option failed.." H 3
 Q
 ;
