AUPN99P5 ; IHS/CMI/LAB - AUPN 99.1 PATCH 5 [ 05/09/2003  7:57 AM ]
 ;;99.1;IHS DICTIONARIES (PATIENT);**5,9,10**;JUN 13, 2003
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
POST ;EP
 ;re-index new AE xref on Medicaid Eligible
 NEW DIK
 S DIK="^AUPNMCD(",DIK(1)=".03^AE" D ENALL^DIK
 K DIK
 Q
