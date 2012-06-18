ADE60P15 ; IHS/SET/HMW - ADE6.0 PATCH 15 ;  
 ;;6.0;ADE;**15**;JAN 01, 2004
 ;
 ; This patch accumulates ADE patches 1 through 15
 ; I copied this from ADE60P14 and only change POST line tag
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
 ;
 ;is the AUT requirement present?
 I '$$ISAUT14 D
 .D BMES^XPDUTL("Patch 15 of version 6.0 of the IHS DENTAL Package")
 . D BMES^XPDUTL("Cannot Be Installed Unless")
 . D BMES^XPDUTL("Patch 14 of version 98.1 of the AUT  IHS DICTIONARIES (POINTERS) package has been installed.")
 . D SORRY(2)
 Q
 ;End Environment check
 ;
PREINST ;EP Pre-install -- Do previous patches as needed
 ;
 I '$$INSTALLD("ADE*6.0*15") D
 .I '$$INSTALLD("ADE*6.0*14") D
 . . I '$$INSTALLD("ADE*6.0*13") D
 . . . I '$$INSTALLD("ADE*6.0*12") D
 . . . . ;Install 12
 . . . . D BMES^XPDUTL("Installing ADE Patch 12.")
 . . . . D PREINST^ADE60P12
 . . . . D ^ADECD4
 . . . . Q
 . . . ;Install 13
 . . . D BMES^XPDUTL("Installing ADE Patch 13.")
 . . . D ^ADECD44
 . . . Q
 . . ;DO I NEED A CALL HERE TO A PATCH 14 ROUTINE
 . . ;Install 14
 . .  D BMES^XPDUTL("Installing ADE Patch 14.")
 . .  D POST^ADE60P14
 . .  Q
 Q
 ;End Pre-Install
 ;
POST ;EP Post-Install
 ; only post for patch 15 - LSL 12/12/03
 ; Create 2 new entries in DENTAL PROGRAM OBJECTIVE File
 N ADED,ADECNT,ADEVALUE
 D BMES^XPDUTL("Creating RVU entries in DENTAL PROGRAM OBJECTIVE File...")
 S ADED=";;"
 S ADECNT=0
 F  D ADDRVU Q:ADEVALUE="END"
 D BMES^XPDUTL(" ...DONE")
 ;
 D BMES^XPDUTL("Populating new RVU field in the ADA Code File and updating Level of Service...")
 D ^ADEADRVU
 D BMES^XPDUTL("...DONE")
 Q
 ; ********************************************************************
ADDRVU ;
 S ADECNT=ADECNT+1
 S ADEVALUE=$P($T(@1+ADECNT),ADED,2,7)
 Q:ADEVALUE="END"
 K DIC,DA,X,Y
 S DIC="^ADEKOB("
 S DIC(0)="LZE"
 S DINUM=$P(ADEVALUE,ADED)
 S X=$P(ADEVALUE,ADED,2)
 S DIC("DR")=".02///^S X=$P(ADEVALUE,ADED,3)"
 S DIC("DR")=DIC("DR")_";.03///^S X=$P(ADEVALUE,ADED,4)"
 S DIC("DR")=DIC("DR")_";.11///^S X=$P(ADEVALUE,ADED,5)"
 S DIC("DR")=DIC("DR")_";.22///^S X=$P(ADEVALUE,ADED,6)"
 K DD,DO
 D FILE^DICN
 Q
 ; End - LSL 12/12/03
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
 ;Determine if AUT*98.1*14 is present. This patch adds the RVU (Relative Value Unit) field to the ADA Code
ISAUT14() ;
 S KFINISH=$O(^XPD(9.7,"B","AUT*98.1*14",""))
 I $G(KFINISH)="" Q 0
 S KSTATUS=$P($G(^XPD(9.7,KFINISH,0)),U,9)  ;'0' Loaded from Distribution
 ;                                           '1' Queued for Install 
 ;                                           '2' Start of Install 
 ;                                           '3' Install Completed 
 ;                                           '4' FOR De-Installed; 
 ;
 I KSTATUS'=3 Q 0
 Q 1
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
 ; *********************************************************************
 ; IEN;;OBJECTIVE;;MONITORING AGES;;COUNT AGES;;LOGIC;;LEVEL
 ; *********************************************************************
1 ;;
 ;;33;;RVU (INDIAN);;5:19;20:34;35:44;;0:4;5:9;10:14;15:19;20:34;35:44;45:54;55:64;65:125;;D SVC;ADEKNT2(1,2);;PATIENT
 ;;34;;RVU (NON-INDIAN);;5:19;20:34;35:44;;0:4;5:9;10:14;15:19;20:34;35:44;45:54;55:64;65:125;;D SVC;ADEKNT2(2,2);;PATIENT
 ;;END
