APCH2P10 ; IHS/TUCSON/LAB - PCC HEALTH SUMMARY POST INIT PATCH 10 ;  [ 02/19/03  11:55 AM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**10**;JUN 24, 1997
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 Q
PRE ;EP - pre init
 S DA=$O(^APCHSURV("B","ASTHMA - SEVERITY CLASSIFICATI",0))
 I DA K ^APCHSURV(DA,11)
 Q
POST ;EP
BUL ;
 D ^APCHBU10
 Q
 ;
ADA ;
 ;;0120
 ;;0150
 ;;0114
 ;;9320
 ;;9321
 ;;
