BHSP1 ; IHS/MSC/MGH - PRE-INSTALL ROUTINE FOR BHS PATCH 1 ;05-Jun-2007 08:45;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1**;Jan 06, 2006
 ;
ENV ;EP; environment check
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for released version added
 NEW IEN,PKG S PKG="HEALTH SUMMARY COMPONENTS 1.0",IEN=$O(^XPD(9.6,"B",PKG,0))
 I 'IEN W !,"You must first install "_PKG_"." S XPDQUIT=2 Q
 ;
 NEW IEN,PKG S PKG="VUECENTRIC EHR COMPONENTS 1.1",IEN=$O(^XPD(9.6,"B",PKG,0))
 I 'IEN W !,"You must first install the EHR to use this application."  S XPDQUIT=2 Q
 ;
 Q
 ;
