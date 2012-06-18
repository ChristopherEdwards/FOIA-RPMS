LR201 ;IHS/DIR/AAB - LAB Y2K PATCH ENVIRNMENT CHECK ROUTINE  ;2/18/98  09:30 ; [ 12/17/1998  8:27 AM ]
 ;;5.2;LR;**1006**;SEP 01, 1998
 ;;5.2;LAB SERVICE;**201**;Sep 27, 1994
EN ;--> Does not prevent loading of the transport global.
 ;--> Environment check is done only during the install.
 Q:'$G(XPDENV)
 D CHECK
EXIT I $G(XPDQUIT) W !!,$$CJ^XLFSTR("Install Environment Check FAILED",80)
 I '$G(XPDQUIT) W !!,$$CJ^XLFSTR("Environment Check is Ok ---",80)
 K VER,RN,LN2
 Q
CHECK ;
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) W !,$$CJ^XLFSTR("Terminal Device is not defined",80),!! S XPDQUIT=2
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) W !!,$$CJ^XLFSTR("Please Log in to set local DUZ... variables",80),! S XPDQUIT=2
 I '$D(^VA(200,+$G(DUZ),0))#2 W !,$$CJ^XLFSTR("You are not a valid user on this system",80),! S XPDQUIT=2
 S VER=$$VERSION^XPDUTL("LR") ;---->Serves for all 5.2 lab
 I VER'>5.1 W !,$$CJ^XLFSTR("You must have LAB SERVICE V5.2 Installed",80),! S XPDQUIT=2
 ;W !!,"Checking for 1004..."  ;IHS/DIR TUC/AAB 06/17/98
 ;F RN="LRX" X "ZL @RN S LN2=$T(+2)" I LN2'["1004" D
 ;.  W !,$$CJ^XLFSTR(RN_"--Patch 'LR*5.2*1004' has not been installed.",80)
 ;.  W ! S XPDQUIT=2
 Q
POST ;
 I $D(^LAM(0))#2 S $P(^(0),U,3)=99999
 Q
