ADE60P13 ; IHS/SET/HMW - ADE6.0 PATCH 13 ;  
 ;;6.0;ADE;**13**;MAR 25, 1999
 ;
 ;This patch accumulates ADE patches 1 through 12
 ;IHS/SET/HMW 3-26-2003
 ;
ENV ;Environment check
 I '$G(IOM) D HOME^%ZIS
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"DUZ(0) DOES NOT CONTAIN AN '@'." D SORRY(2) Q
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment...",IOM)
 ;
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 ;
 I $$VCHK("ADE","6.0",2,"'=")
 ;
 NEW DA,DIC
 S X="ADE",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","ADE")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""ADE"" prefix.",IOM)
 . W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 . D SORRY(2)
 .Q
 Q
 ;End Environment check
 ;
PREINST ;Pre-install
 I '$$INSTALLD("ADE*6.0*13") D
 . I '$$INSTALLD("ADE*6.0*2") D  Q
 . . D BMES^XPDUTL("Installing ADE patches from Patch 2 forward.")
 . . D ^ADE0602,^ADE0603,^ADECDT,^ADE0608,^ADE0610,^ADE0611
 . . Q
 . I '$$INSTALLD("ADE*6.0*3") D  Q
 . . D BMES^XPDUTL("Installing ADE patches from Patch 3 forward.")
 . . D ^ADE0603,^ADECDT,^ADE0608,^ADE0610,^ADE0611
 . . Q
 . I '$$INSTALLD("ADE*6.0*7") D  Q
 . . D BMES^XPDUTL("Installing ADE patches from Patch 7 forward.")
 . . D ^ADECDT,^ADE0608,^ADE0610,^ADE0611
 . . Q
 . I '$$INSTALLD("ADE*6.0*8") D  Q
 . . D BMES^XPDUTL("Installing ADE patches from Patch 8 forward.")
 . . D ^ADE0608,^ADE0610,^ADE0611
 . . Q
 . I '$$INSTALLD("ADE*6.0*10") D  Q
 . . D BMES^XPDUTL("Installing ADE patches from Patch 10 forward.")
 . . D ^ADE0610,^ADE0611
 . . Q
 . I '$$INSTALLD("ADE*6.0*11") D  Q
 . . D BMES^XPDUTL("Installing ADE Patch 11.")
 . . D ^ADE0611
 . . Q
 . I '$$INSTALLD("ADE*6.0*12") D  Q
 . . D BMES^XPDUTL("Installing ADE Patch 12.")
 . . D ^ADECD4
 . . Q
 . Q
 Q
 ;End Pre-Install
 ;
POST ;Post-Install
 D ^ADECD44
 Q
 ;
VCHK(ADEPRE,ADEVER,ADEQUIT,ADECOMP) ; Check versions needed.
 ;  
 NEW ADEV
 S ADEV=$$VERSION^XPDUTL(ADEPRE)
 W !,$$CJ^XLFSTR("Need "_$S(ADECOMP="<":"at least ",1:"")_ADEPRE_" v "_ADEVER_"....."_ADEPRE_" v "_ADEV_" Present",IOM)
 I @($C(34)_ADEV_$C(34)_ADECOMP_$C(34)_ADEVER_$C(34)) D SORRY(ADEQUIT) Q 0
 Q 1
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",IOM)
 Q
 ;
INSTALLD(ADE) ; Determine if patch ADE was installed, where ADE is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(ADE,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(ADE,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(ADE,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
