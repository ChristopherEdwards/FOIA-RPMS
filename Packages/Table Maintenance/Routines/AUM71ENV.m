AUM71ENV ;IHS/ASDST/DMJ,SDR,GTH - ICD 9 CODES FOR FY 2007 ; [ 09/17/2002  12:40 PM ]
 ;;07.1;TABLE MAINTENANCE;;SEP 28,2001
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_".",IOM)
 ;
 I $$VCHK("XU","8.0",2)
 I $$VCHK("DI","22.0",2)
 I $$VCHK("AUM","6.1",2)
 ;
 NEW DA,DIC
 S X="AUM",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUM")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AUM"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . D SORRY(2)
 .Q
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","AZHBENV")
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . D HELP^XBHELP("INTROI","AZHBENV")
 .Q
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(AUMPRE,AUMVER,AUMQUIT) ; Check versions needed.
 ;  
 NEW AUMV
 S AUMV=$$VERSION^XPDUTL(AUMPRE)
 W !,$$CJ^XLFSTR("Need at least "_AUMPRE_" v "_AUMVER_"....."_AUMPRE_" v "_AUMV_" Present",IOM)
 I AUMV<AUMVER KILL DIFQ S XPDQUIT=AUMQUIT D SORRY(AUMQUIT) Q 0
 Q 1
 ;
INTROE ; Intro text during KIDS Environment check.
 ;;This is the annual update to the ICD files.  There are modifications,
 ;;inactivations, and new entries to both files.
 ;;###
 ;
INTROI ; Intro text during KIDS Install.
 ;;If you run interactively, results will be displayed on your screen,
 ;;and recorded in the entry in the INSTALL file.
 ;;If you queue to TaskMan, remember not to Q to the HOME device.
 ;;###
 ;
