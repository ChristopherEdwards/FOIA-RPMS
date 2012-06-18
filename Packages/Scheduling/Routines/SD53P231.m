SD53P231 ;ALB/RBS - Patch SD*5.3*231 Install Utility Routine ; 5/15/01 11:11am
 ;;5.3;Scheduling;**231**;AUG 13, 1993
 ;
 ;
ENV ;Main entry point for Environment check point.
 ;
 S XPDABORT=""
 D PROGCHK(.XPDABORT) ;checks programmer variables
 D PARMCHK(.XPDABORT) ;checks param file ien exists
 I XPDABORT="" K XPDABORT
 Q
 ;
PRE ;Main entry point for Pre-init items.
 ;
 Q
 ;
POST ;Main entry point for Post-init items.
 ;
 D POST1 ;Update Client/Server files
 Q
 ;
PROGCHK(XPDABORT) ;checks for necessary programmer variables
 ;
 I '$G(DUZ)!($G(DUZ(0))'="@")!('$G(DT))!($G(U)'="^") D
 .D BMES^XPDUTL("*****")
 .D MES^XPDUTL("Your programming variables are not set up properly.")
 .D MES^XPDUTL("Installation aborted.")
 .D MES^XPDUTL("*****")
 .S XPDABORT=2
 Q
 ;
PARMCHK(XPDABORT) ;checks for proper param file ien
 ;
 I '$D(^SCTM(404.44,1)) D
 .D BMES^XPDUTL("*****")
 .D MES^XPDUTL("Parameter file (#404.44) does not have proper IEN (1).")
 .D MES^XPDUTL("Installation aborted.")
 .D MES^XPDUTL("*****")
 .S XPDABORT=2
 Q
 ;
POST1 ;Update client/server files.
 ;
 I $$UPCLNLST^SCMCUT("SD*5.3*231^NullClient^1^0^0") D  Q
 .D MES^XPDUTL("Client/Server files updated.")
 ;
 D MES^XPDUTL("Client/Server files NOT updated.")
 Q
