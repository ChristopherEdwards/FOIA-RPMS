BLRREFLP ;IHS/OIT/MKK - BLR REFERENCE LAB Post Install Routine ;JUL 20, 2010 10:55 AM
 ;;5.2;IHS LABORATORY;**1027**;NOV 01, 1997
 ;
EP ; EP
 D ADDTMENU("BLRREFLABMENU","BLR REFLAB PURGE SHIP MANIFEST","PSM")
 Q
 ;
ADDTMENU(MENU,OPTION,SYN)    ; EP
 NEW ADDOPT,CHKIT,HEREYAGO,STR1,STR2,STR3
 ;
 ; Determine if MENU is in File 19
 D FIND^DIC(19,,,,MENU,,,,,"HEREYAGO")
 I +$G(HEREYAGO("DILIST",2,1))<1 D  Q
 . D MES^XPDUTL($J("",5)_MENU_" Menu not in File 19.  No Option Added.")
 ;
 K HEREYAGO
 ; Determine if OPTION is in File 19
 D FIND^DIC(19,,,,OPTION,,,,,"HEREYAGO")
 I +$G(HEREYAGO("DILIST",2,1))<1 D  Q
 . D MES^XPDUTL($J("",5)_OPTION_" option not in File 19.  Option "_OPTION_" NOT Added to "_MENU_" menu.")
 ;
 D BMES^XPDUTL("Adding "_OPTION_" to "_MENU_".")
 ;
 S CHKIT=$$ADD^XPDMENU(MENU,OPTION,SYN)
 ;
 I CHKIT=1 D  Q
 . D MES^XPDUTL($J("",5)_OPTION_" added to "_MENU_"."_" OK.")
 . D MES^XPDUTL(" ")
 ;
 S STR1="Error in adding "_OPTION_" to "_MENU_"."
 D SORRY^BLRPRE27(STR1,"NONFATAL")
 ;
 Q
