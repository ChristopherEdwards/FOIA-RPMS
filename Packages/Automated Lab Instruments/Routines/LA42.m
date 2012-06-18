LA42 ;IHS/DIR/AAB - LA*5.2*42 PATCH ENVIRONMENT CHECK ROUTINE ; 12/3/1997 [ 12/17/1998  8:44 AM ]
 ;;5.2;LA;**1003**;SEP 01, 1998
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**42**;Sep 27, 1994
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 Q:'$G(XPDENV)
 D CHECK
 D EXIT
 Q
 ;
CHECK ; Perform environment check
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("Terminal Device is not defined",80))
 . S XPDQUIT=2
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("Please log in to set local DUZ... variables",80))
 . S XPDQUIT=2
 I '$D(^VA(200,$G(DUZ),0))#2 D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("You are not a valid user on this system",80))
 . S XPDQUIT=2
 ;W !!,"Checking for 1002..."  ;IHS/DIR TUC/AAB 06/17/98
 ;F RN="LA7ADL2" X "ZL @RN S LN2=$T(+2)" I LN2'["1002" D
 ;.  W !,$$CJ^XLFSTR(RN_"--Patch 'LA*5.2*1002' has not been installed.",80)
 ;.  W ! S XPDQUIT=2
 S XPDIQ("XPZ1","B")="NO"
 Q
 ;
EXIT ;
 I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check FAILED ---",80))
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is Ok ---",80))
 Q
 ;
PRE ; KIDS Pre install for LA*5.2*42
 N LA7NOAC
 S LA7NOAC=1 ; Flag for actions
 D BMES^XPDUTL($$CJ^XLFSTR("--- Starting Pre Install ---",80))
 I LA7NOAC D BMES^XPDUTL($$CJ^XLFSTR("--- No action necessary ---",80))
 D BMES^XPDUTL($$CJ^XLFSTR("--- End Pre Install ---",80))
 Q
 ;
POST ; KIDS Post install for LA*5.2*42
 N LA7NOAC
 S LA7NOAC=1 ; Flag for actions
 D BMES^XPDUTL($$CJ^XLFSTR("--- Starting Post Install ---",80))
 I LA7NOAC D BMES^XPDUTL($$CJ^XLFSTR("--- No action necessary ---",80))
 D BMES^XPDUTL($$CJ^XLFSTR("--- End Post Install ---",80))
 Q
