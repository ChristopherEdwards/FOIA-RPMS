LR258 ;DALOI/RSH - LR*5.2*258 PATCH ENVIRONMENT CHECK ROUTINE
 ;;5.2;LAB SERVICE;**258**;Sep 27,1994
EN ; Does not prevent loading of the transport global.
 ;Environment check is done only during the install.
 ;$$CJ^XLFSTR supported by DBIA #10104
 ;$$VERSION^XPDUTL supported by DBIA #10141
 ;BMES^XPDUTL supported by DBIA 10141
 ;$$ACTIVE^XUSER supported by DBIA #2343
 Q:'$G(XPDENV)
 D BMES^XPDUTL($$CJ^XLFSTR("*** Environment check started ***",80))
 D CHECK
 D EXIT Q:$G(XPDQUIT)
 N DIR,DIC
 D BMES^XPDUTL($$CJ^XLFSTR("This patch installs National Laboratory Test codes.",IOM))
 D BMES^XPDUTL($$CJ^XLFSTR("LAB NLT/CPT CODES (#64.81)",IOM))
 D BMES^XPDUTL($$CJ^XLFSTR("Will be purged to ensure data integrity.",IOM))
 D BMES^XPDUTL($$CJ^XLFSTR("File #64.81 will be replaced completely by this patch installation.",IOM))
 W ! S DIR(0)="Y",DIR("A")="Do you want to continue"
 S DIR("B")="YES"
 D ^DIR K DIR
 I $D(DIRUT)!('Y) D  Q
 .D BMES^XPDUTL($$CJ^XLFSTR("Environment check aborted.",IOM))
 .S XPDQUIT=2
 .Q
 Q
CHECK I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) W !,$$CJ^XLFSTR("Terminal Device is not defined",IOM),!! S XPDQUIT=2
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) W !!,$$CJ^XLFSTR("Please Log in to set local DUZ... variables",IOM),! S XPDQUIT=2
 I '$P($$ACTIVE^XUSER(DUZ),U) W !,$$CJ^XLFSTR("You are not a valid user on this system",IOM),! S XPDQUIT=2
 S VER=""
 I $O(^LAM(0)) S VER=$$VERSION^XPDUTL("LR")
 I VER,VER'>5.1 W !,$$CJ^XLFSTR("You must have LAB V5.2 Installed",IOM),! S XPDQUIT=2
LMI N DIC,X,Y
 S DIC=3.8,DIC(0)="NMXO",X="LMI" D ^DIC
 I Y<1 D
 . W !,$$CJ^XLFSTR("You must have Mail Group [ LMI ] defined.",IOM)
 . S XPDQUIT=2
 Q:$G(XPDQUIT)<1
 S XPDIQ("XPZ1","B")="NO"
 Q
EXIT I $G(XPDQUIT) W !!,$$CJ^XLFSTR("Install Environment Check FAILED",IOM)
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("Environment Check is Ok ---",IOM))
 K VER,RN,LN2
 Q
