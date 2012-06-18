ACRF13PS ;IHS/OIRM/DSD/AEF - VERSION 2.1 PATCH 13 POST INSTALL ROUTINE [ 10/28/2004  11:37 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**13**;NOV 05, 2001
 ;
EN ;EP -- MAIN ENTRY POINT
 ;
 D ^XBKVAR
 D COMP
 Q:$D(ACROUT)
 Q
COMP ;----- COMPILE PRINT TEMPLATES
 ;
 ;      This subroutine recompiles all the compiled ARMS, Finance
 ;      and Contract and Grants print templates
 ;
 N ACRIEN,ACRTEMP,DMAX,X,Y
 D BMES^XPDUTL("Recompiling print templates...")
 S ACRTEMP=""
 F  S ACRTEMP=$O(^DIPT("B",ACRTEMP)) Q:ACRTEMP']""  D
 . I "ACR^ACG^AFS"'[$E(ACRTEMP,1,3) Q
 . S ACRIEN=0
 . F  S ACRIEN=$O(^DIPT("B",ACRTEMP,ACRIEN)) Q:'ACRIEN  D
 . . S X=$P($G(^DIPT(ACRIEN,"ROU")),U,2)
 . . Q:X']""
 . . S Y=ACRIEN
 . . S DMAX=$$ROUSIZE^DILF
 . . D EN^DIPZ
 D BMES^XPDUTL("Templates are re-compiled")
 Q
