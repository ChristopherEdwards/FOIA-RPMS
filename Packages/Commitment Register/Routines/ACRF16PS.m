ACRF16PS ; IHS/OIEM/DSD/AEF/LSL - VERSION 2.1 PATCH 16 POST INSTALL ROUTINE  [ 02/24/2005  2:23 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**16**;NOV 05, 2001
 ;
 Q
 ;
EN ; EP - Driver
 D ^XBKVAR
 D XREF
 Q
 ; ********************************************************************
 ;
XREF ;
 ; Rebuild AC x-ref on ARMS VENDOR DISCOUNT TERMS File.
 ; X-ref was moved from .01 field to 1 field (DAYS).
 D BMES^XPDUTL("Rebuilding AC cross-reference of ARMS VENDOR DISCOUNT TERMS File...")
 K ^ACRDT("AC")
 S DIK="^ACRDT("
 S DIK(1)="1^AC"
 D ENALL^DIK
 D BMES^XPDUTL("DONE rebuilding AC cross-reference.")
 Q
