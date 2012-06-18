NUR23ENV ;HIRMFO/NCA-Environment check for NUR*4*23 ;6/5/97 13:13
 ;;4.0;NURSING SERVICE;**23**;Apr 25, 1997
EN1 ; check if patch GMRV*4.0*7 is installed
 ;I '(+$$PATCH^XPDUTL("GMRV*4.0*7")) S XPDABORT=1 D BMES^XPDUTL("Patch GMRV*4.0*7 must be installed first.")
 Q
