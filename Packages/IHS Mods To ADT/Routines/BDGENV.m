BDGENV ; IHS/ANMC/LJF - PIMS ENVIRONMENT CHECK RTN ;  [ 05/28/2004  3:18 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
ENV ;EP; environment check code
 ;Prevents "Disable Options..." and "Move Routines..." questions
 S XPDDIQ("XPZ1")=0,XPPDIQ("XPZ2")=0
 ;
 ;IHS/ITSC/WAR 5/28/2004 Added ck's for minimum RPMS patches
 W !,"** CHECKING ENVIRONMENT **",!!
 ;
 ; *** KERNEL
 ;I +$$PATCH^XPDUTL("XU*8.0*1007")'>0 D  Q
 ;. S XPDQUIT=2
 ;. W !,"You must first install patch XU*8*1007.",!
 ;
 ; *** UTILITY TABLES (standard tables)
 I +$$PATCH^XPDUTL("AUT*98.1*13")'>0 D  Q
 . S XPDQUIT=2
 . W !,"You must first install patch AUT*98.1*13.",!
 ;
 ; *** IHS PATIENT DICTIONARIES
 I +$$PATCH^XPDUTL("AUPN*99.1*13")'>0 D  Q
 . S XPDQUIT=2
 . W !,"You must first install patch AUPN*99.1*13.",!
 ;
 ; *** IHS/VA UTILITIES
 I +$$PATCH^XPDUTL("XB*3.0*9")'>0 D  Q
 . S XPDQUIT=2
 . W !,"You must first install patch XB*3.0*9.",!
 ;
 ; *** PATIENT REGISTRATION
 I +$$PATCH^XPDUTL("AG*7.0*1")'>0 D  Q
 . S XPDQUIT=2
 . W !,"You must first install patch AG*7.0*1.",!
 ;
 ; *** IHS VA SUPPORT FILES
 I +$$PATCH^XPDUTL("AVA*93.2*18")'>0 D  Q
 . S XPDQUIT=2
 . W !,"You must first install patch AVA*93.2*18.",!
 ;
 W !,"Everything looks fine!",!
 Q 
