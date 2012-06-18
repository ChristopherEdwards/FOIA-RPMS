LR1001 ;IHS/OIRM TUC/AAB - LR*5.2*1001 PATCH ENVIRNMENT CHECK ROUTINE [ 05/06/98  10:14 AM ]
 ;;5.2;LR;**1001**;FEB 1, 1998
EN ; Does not prevent loading of the transport global.
 ;Environment check is done only during the install.
 Q:'$G(XPDENV)
 D CHECK
EXIT I $G(XPDQUIT) W !!,$$CJ^XLFSTR("Install Environment Check FAILED",80)
 I '$G(XPDQUIT) W !!,$$CJ^XLFSTR("Environment Check is Ok ---",80)
 K VER,RN,LN2
 Q
CHECK I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) W !,$$CJ^XLFSTR("Terminal Device is not defined",80),!! S XPDQUIT=2 Q
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) W !!,$$CJ^XLFSTR("Please Log in to set local DUZ... variables",80),! S XPDQUIT=2 Q
 I '$D(^VA(200,$G(DUZ),0))#2 W !,$$CJ^XLFSTR("You are not a valid user on this system",80),! S XPDQUIT=2 Q
 S VER=$$VERSION^XPDUTL("LR")
 I VER'>5.1 W !,$$CJ^XLFSTR("You must have LAB V5.2 Installed",80),! S XPDQUIT=2 Q
 Q
POST ; KIDS Post install for LR*5.2*1001
 N X
 S X=$$ADD^XPDMENU("LR OUT","BLR LRRD BY MD")
 D BMES^XPDUTL("Option [BLR LRRD BY MD] was "_$S(X:"added",1:"NOT ADDED")_" to [LR OUT] MENU")
 D ^BLRQINST
 D BMES^XPDUTL($$CJ^XLFSTR("Post install completed",80))
 Q
