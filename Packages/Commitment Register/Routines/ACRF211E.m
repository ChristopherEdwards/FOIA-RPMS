ACRF211E ;IHS/OIRM/DSD/AEF - PATCH 1 ENVIRONMENT CHECK ROUTINE [ 01/16/2002  9:00 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**1**;JAN 11, 2002
 ;
EN ;EP -- MAIN ENTRY POINT
 ;
 ;      DETERMINES IF CORRECT VERSION NUMBER EXISTS
 ;      
 N X,Y
 S Y=$$VERSION^XPDUTL("ADMIN RESOURCE MGT SYSTEM")
 I Y'=$$VER^XPDUTL("ACR*2.1*1") D  Q
 . S XPDQUIT=1
 . S X="This patch is for ARMS version "_$$VER^XPDUTL("ACR*2.1*1")_" but you are running version "_Y_"."
 . D BMES^XPDUTL(X)
 . D BMES^XPDUTL("This patch cannot be installed on your system.")
 ;
 D BMES^XPDUTL("Everything looks OK, you may continue with installation.")
 Q
