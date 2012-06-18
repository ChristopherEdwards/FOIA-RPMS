BPXP1001 ;IHS/ITSC/LJF - Environment check for patch 1001
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**1001**;Aug 12, 1996
 ;
ENV ;EP
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for released version added IHS/ITSC/LJF 12/10/2004
 NEW IEN,PKG S PKG="PCE PATIENT CARE ENCOUNTER - IHS 1.0",IEN=$O(^XPD(9.6,"B",PKG,0))
 I 'IEN W !,"You must first install "_PKG_"; part of the Visit Tracking Suite v2.0." S XPDQUIT=2 Q
 I $$GET1^DIQ(9.6,IEN,.02,"I")'=3040709 D  Q
 . W !,"You have a test version of "_PKG_" installed."
 . W !?5,"Please install the released Visit Tracking Suite v2.0 first."
 . S XPDQUIT=2
 ;
 Q
