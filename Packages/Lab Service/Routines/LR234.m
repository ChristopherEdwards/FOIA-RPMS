LR234 ;DALISC/WTY - LAB PATCH ENVIRONMENT CHECK ROUTINE  ;03/15/99  07:30 ;
 ;;5.2T9;LR;**1018**;Nov 17, 2004
 ;;5.2;LAB SERVICE;**234**;Sep 27, 1994
EN ;--> Does not prevent loading of the transport global.
 ;--> Environment check is done only during the install.
 Q:'$G(XPDENV)
 ;
 D CHECK
 ;
EXIT I $G(XPDQUIT) W !!,$$CJ^XLFSTR("Install Environment Check FAILED",80)
 I '$G(XPDQUIT) W !!,$$CJ^XLFSTR("Environment Check is Ok ---",80)
 K VER,RN,LN2
 Q
CHECK I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D  Q
 .W !,$$CJ^XLFSTR("Terminal Device is not defined",80),!!
 .S XPDQUIT=2
 ;
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D  Q
 .W !!,$$CJ^XLFSTR("Please Log in to set local DUZ... variables",80),!
 .S XPDQUIT=2
 ;
 I '$D(^VA(200,$G(DUZ),0))#2 D  Q
 .W !,$$CJ^XLFSTR("You are not a valid user on this system",80),!
 .S XPDQUIT=2
 ;
 S VER=$$VERSION^XPDUTL("LR")
 I VER'>5.1 D  Q
 .W !,$$CJ^XLFSTR("You must have LAB V5.2 Installed",80),!
 .S XPDQUIT=2
 Q
