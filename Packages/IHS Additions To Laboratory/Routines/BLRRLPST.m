BLRRLPST ;cmi/anch/maw - BLR Reference Lab Post Init 2/27/2007 10:32:52 AM;JUL 06, 2010 3:14 PM
 ;;5.2;IHS LABORATORY;**1027**;NOV 01, 1997
 ;;5.2;;;FEB 27,2008;
 ;
 ;
 ;
 ;
EN ;EP - Post Init Entry Point
 D ADDMENU
 D MOVEFLD
 Q
 ;
ADDMENU ;-- add menu items
 N X
 S X=$$ADD^XPDMENU("BLRREFLABMENU","BLR REFLAB PURGE SHIP MANIFEST","PSM",)
 I 'X W !,"Attempt to add BLR REFLAB PURGE SHIP MANIFEST option failed.." H 3
 S X=$$ADD^XPDMENU("BLRREFLABMENU","BLR REFLAB EDIT MC PARAMETERS","SIT")
 I 'X W !,"Attempt to add BLR REFLAB EDIT MC PARAMETERS option failed.." H 3
 Q
 ;
MOVEFLD ;-- move data from fields in BLR REFERENCE LAB to same fields in BLR MASTER CONTROL file
 Q
 ;
