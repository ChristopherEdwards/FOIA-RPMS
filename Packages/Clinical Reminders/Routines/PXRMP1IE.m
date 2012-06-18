PXRMP1IE ; SLC/DT/PJH - Inits for PXRM*1.5*1 ;08/25/2000
 ;;1.5;CLINICAL REMINDERS;**1**;Jun 19, 2000
 ;===============================================================
ENV ;Environment check
 ;
 ;Make sure the user has programmer access
 I $G(DUZ(0))'="@" D  Q
 .D BMES^XPDUTL("Programmer access required") S XPDQUIT=2
 ;Make sure the package version is 1.5 and not earlier
 I $$VERSION^XPDUTL("PXRM")'=1.5 D  Q
 .D BMES^XPDUTL("Reminder Package not installed") S XPDQUIT=2
 Q
