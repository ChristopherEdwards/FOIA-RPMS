APSPEC02 ;IHS/CIA/PLS - APSP ENVIRONMENT CHECK ROUTINE ;31-Jan-2005 16:39;AFX
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1002**;DEC 11, 2003
 ;
ENV ;
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0  ; Suppress the Disable options and Move routines prompts
 S XPDABORT=0
 S XPDABORT='$D(^XPD(9.7,"B","APSP*7.0*1001"))
 D:XPDABORT BMES^XPDUTL("Patch APSP*7.0*1001 must be installed prior to installing patch 1002")
 Q
