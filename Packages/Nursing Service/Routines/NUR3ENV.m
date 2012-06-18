NUR3ENV ;HIRMFO/MD-Environment Check for NUR*4*3  ;8/21/97
 ;;4.0;NURSING SERVICE;**3**;Apr 25, 1997
EN1 ; Check environment to see if patch should be installed.
 I +$$VERSION^XPDUTL("NUR")'>3 D BMES^XPDUTL("You must have Nursing v4.0 installed") S XPDABORT=1
 Q
