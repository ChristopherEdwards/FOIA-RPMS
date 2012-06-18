GMTS1003 ;IHS/MSC/MGH - GMTS Package Update Utility ;23-Mar-2010 16:23;DU
 ;;2.7;VA Health Summary;**1003**;APR 24, 1997;Build 3
 ;=================================================================
 ;
 ;
ENV ; EP Environment checker for EHR patch 6 updates
 N PATCH,X,Y
 S X=$$NOW^XLFDT
 ;Check for patch 6 of the EHR
 S IN="EHR*1.1*6",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the EHR patch 6 before installing GMTS patch 1003" S XPDQUIT=2
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"EHR patch 6 must be completely installed before installing GMTS patch 1003" S XPDQUIT=2
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
