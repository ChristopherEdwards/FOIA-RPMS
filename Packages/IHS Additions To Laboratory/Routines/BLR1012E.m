BLR1012E ; IHS/HQT/MJL - LR*5.2*1012 PATCH ENVIRONMENT CHECK ROUTINE ;  [ 07/25/2001  2:15 PM ]
 ;;5.2;LR;**1012**;JUL 25, 2001
EN ;Prevents loading of the transport global.
 ;Environment check is done only during the install.
 ;
 Q:'$G(XPDENV)
 I $S('($D(DUZ)#2):1,'($D(DUZ(0))#2):1,'DUZ:1,1:0) W !!,$C(7),">>>  DUZ and DUZ(0) must be defined as an active user to initialize.",!,"     Please setup these parameters (Sign-on) before continuing.",! S XPDQUIT=1
 I +$G(^DD(60,0,"VR"))<5.2 W !!,$C(7),">>>  You must at least be running Lab 5.2 to continue.",! S XPDQUIT=1
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) W !,$$CJ^XLFSTR("Terminal Device in not defined",80),!! S XPDQUIT=1
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) W !!,$$CJ^XLFSTR("Please Log in to set local DUZ... variables",80),! S XPDQUIT=1
 I '$D(^VA(200,$G(DUZ),0))#2 W !,$$CJ^XLFSTR("You are not a valid user on this system",80),! S XPDQUIT=1
 W !!,"Checking for LR 5.2 Patch 1011..."
 F RN="BLRTN","LRORD" X "ZL @RN S LN2=$T(+2)" I LN2'["1011",LN2'["1012" D
 .  W !,$$CJ^XLFSTR(RN_"--Patch 'LR*5.2*1011' has not been installed.",80)
 .  W ! S XPDQUIT=1
 K BLRFDA,BLRIEN,BLREMSG,DIC
 I $G(XPDQUIT) W !!,$$CJ^XLFSTR("Install environment check FAILED",80)
 I '$G(XPDQUIT) W !!,$$CJ^XLFSTR("Environment Check is Ok ---",80)
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
