BVPENV ; IHS/ITSC/LJF - ENVIRONMENT CHECK FOR VPR ;
 ;;1.0;VIEW PATIENT RECORD;;NOV 17, 2004
 ;
 I XPDENV=1 S XPDDIQ("XPZ1")=0,XPDDIQ("XPZ2")=0
 I '$L($T(EN^APCHS79)) D
 . NEW MSG
 . S MSG(1)="PCC Health Summary patch #8 has not been installed"
 . S MSG(2)="Cannot install View Patient Record until it is."
 . D MES^XPDUTL(.MSG)
 . S XPDQUIT=2
 Q
