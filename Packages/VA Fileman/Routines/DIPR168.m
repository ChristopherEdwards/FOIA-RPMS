DIPR168 ;O-OIFO/GMB-Envirocheck and Post Init ;8SEP2011
 ;;22.0;VA FileMan;**168**;Mar 30, 1999;Build 27
 ;Per VHA Directive 2004-038, this routine should not be modified.
ENV ; Environmental Check
 D BMES^XPDUTL("Perform Environment Check...")
 D CHKSTOP
 D BMES^XPDUTL("Finished Environment Check.")
 Q
CHKSTOP ;
 ; Check XPDENV 0 = Loading; 1 = Installing
 Q:'XPDENV  ; Loading Distribution - No Check
 ;
 ;
INSCHK ; Do Checks During Install Only
 W $C(7)
 D MES^XPDUTL("          Although Queuing is allowed, it is HIGHLY recommended that")
 D MES^XPDUTL("                       ALL Users be OFF the system and")
 D MES^XPDUTL("      VistA Background jobs be STOPPED before installation of this patch.")
 D MES^XPDUTL("             TaskMan should be STOPPED or placed in a WAIT state.")
 D MES^XPDUTL("       Failure to do so may result in 'source routine edited' error(s).")
 D MES^XPDUTL("     Edits may be lost and record(s) may be left in an inconsistent state.")
 D MES^XPDUTL("   For example, not all Cross-Referencing completed; which in turn may cause")
 D MES^XPDUTL("             FUTURE VistA/FileMan Hard Errors or corrupted Data.")
 ;
TMCHK ; Check to see if TaskMan is still running
 S X=$$TM^%ZTLOAD
 I X,'$D(^%ZTSCH("WAIT")) D
 . W $C(7)
 . D BMES^XPDUTL("* Warning TaskMan Has NOT Been Stopped or Placed in a WAIT State!")
 ;
LINH ; Check to see if Logons are Inhibited
 D GETENV^%ZOSV  ; $P(Y,"^",2) = Installing Volume
 Q:$G(^%ZIS(14.5,"LOGON",$P(Y,"^",2)))
 W $C(7)
 D BMES^XPDUTL("* Warning Logons are NOT Inhibited!")
 Q
