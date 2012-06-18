AUPN99P6 ; IHS/CMI/LAB - AUPN 99.1 PATCH 6 [ 05/09/2003  7:58 AM ]
 ;;99.1;IHS DICTIONARIES (PATIENT);**6,9,10**;JUN 13, 2003
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
PRE ;EP
 NEW DIK
 S DIK="^DD(9000010.24,",DA=.01,DA(1)=9000010.24 D ^DIK
 S DIK="^DD(9000010.24,",DA=.04,DA(1)=9000010.24 D ^DIK
 S DIK="^DD(9000010.34,",DA=.01,DA(1)=9000010.34 D ^DIK
 Q
