LAMIVTLB ;IHS/DIR/FJE - LA*5.2*12 ENVIRNMENT CHECK ROUTINE ;1/22/96  08:30 ;
 ;;5.2;AUTOMETED LAB INSTRUMENTS;**1030**;NOV 01, 1997
 ;;5.2;AUTOMETED LAB INSTRUMENTS;**12**;Sep 27, 1994;Build 7
 ;;5.2;LA;;NOV 01, 1997;Build 6
EN ; Does not prevent loading of the transport global.
 ;Envirnment check is done only during the install.
 Q:'$G(XPDENV)
 ;-------------------------------------------------------------------
 ; check for device assigned
DEVICE ;
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D
 .  W !,$$CJ^XLFSTR("Terminal Device in not defined",80),!!
 ;-------------------------------------------------------------------
 ;  asertain wether user signed on
USER ;
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D
 .  W !!,$$CJ^XLFSTR("Please Log in to set local DUZ... variables",80),!
 .  S XPDQUIT=2
 ;-------------------------------------------------------------------
 I '$D(^VA(200,$G(DUZ),0))#2 D
 .  W !,$$CJ^XLFSTR("You are not a valid user on this system",80),!
 .  S XPDQUIT=2
 ;-------------------------------------------------------------------
 I +$P($G(^LAM("VR")),";",3)'>5.1 D
 .  W !,$$CJ^XLFSTR("You must have LAB V5.2 or greater Installed",80),!
 .  S XPDQUIT=2
 ;-------------------------------------------------------------------
 I $G(XPDQUIT) W !!,$$CJ^XLFSTR("Install environment check FAILED",80)
 I '$G(XPDQUIT) W !!,$$CJ^XLFSTR("Envirnment Check is Ok ---",80)
 Q
