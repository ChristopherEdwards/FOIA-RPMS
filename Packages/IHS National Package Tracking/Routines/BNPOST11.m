BNPOST11 ;IHS/OIT/ENM - ADD BNP ENVIRONMENT CHECK ROUTINE
 ;;1.0;NATIONAL SITE TRACKING SYSTEM;**1**;07/31/2009
 ;;1.0*1 11/1/2011;IHS/OIT/GAB ADDED CHECK FOR VERSION 1 INSTALLATION AND DUZ
 I '$G(IOM) D HOME^%ZIS
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;CHECK FOR VERSION 1.0
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,"Checking Environment for Version 1.0"
 D VCHK
 ;
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 Q
VCHK ; Check required version
 NEW BNPV
 S BNPRE="BNP"
 S BNPV=$$VERSION^XPDUTL(BNPRE)
 I BNPV'="1.0" W !,"You need at least version 1.0 before proceeding..." D SORRY(2) Q
 I BNPV W !,"You have version 1.0 ... "
 W !,"Continuing with installation ..."
 D EX
 Q
SORRY(X) ; Error display
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
EX K DA,X,Y,BNPV,BNPRE Q
