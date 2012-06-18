SD252EN ;BAY/JKT - ENVIRONMENT CHECK ; 9/24/01 10:35am
 ;;5.3;Scheduling;**252**;Aug 13, 1993
 ;;
EN ;
 S XPDABORT=""
 D PROGCHK(.XPDABORT)
 I XPDABORT="" K XPDABORT
 ;
 Q
 ;
PROGCHK(XPDABORT) ;
 I '$G(DUZ)!($G(DUZ(0))'="@")!('$G(DT))!($G(U)'="^") DO
 .D BMES^XPDUTL("*****")
 .D MES^XPDUTL("Your programming variables are not set up properly.")
 .D MES^XPDUTL("Installation aborted.")
 .D MES^XPDUTL("*****")
 .S XPDABORT=2
 .Q
 Q
 ;
