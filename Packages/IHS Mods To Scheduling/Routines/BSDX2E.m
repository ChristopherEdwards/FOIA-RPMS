BSDX2E ;IHS/OIT/MJL - ENVIRONMENT CHECK FOR WINDOWS SCHEDULING [ 08/22/2007  12:17 PM ]
 ;;2.0;IHS WINDOWS SCHEDULING;;NOV 01, 2007
 ;
 S LINE="",$P(LINE,"*",81)=""
 S XPDNOQUE="NO QUE"  ;NO QUEUING ALLOWED
 S XPDABORT=0
 I '$G(DUZ) D SORRY("DUZ UNDEFINED OR 0") Q
 ;
 I '$L($G(DUZ(0))) D SORRY("DUZ(0) UNDEFINED OR NULL") Q
 ;
 D HOME^%ZIS,DT^DICRW
 S X=$P($G(^VA(200,DUZ,0)),U)
 I $G(X)="" W !,$$C^XBFUNC("Who are you????") D SORRY("Unknown User") Q
 ;
VERSION ;
 W !,$$C^XBFUNC("Hello, "_$P(X,",",2)_" "_$P(X,","))
 W !!,$$C^XBFUNC("Checking Environment for Install of Version "_$P($T(+2),";",3)_" of "_$P($T(+2),";",4)_".")
 ;
 Q:'$$VERCHK("VA FILEMAN",22)
 Q:'$$VERCHK("KERNEL",8)
 ;Is the PIMS requirement present?
 Q:'$$VERCHK("PIMS",5.3)
 Q:'$$PATCHCK("PIMS*5.3*1003") D
 Q:'$$VERCHK("BMX",2.0)
 ;
OTHER ;
 ;Other checks
 ;
ENVOK ; If this is just an environ check, end here.
 W !!,$$C^XBFUNC("ENVIRONMENT OK.")
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;
 ;VERIFY BACKUPS HAVE BEEN DONE
 ;W !!
 ;S DIR(0)="Y"
 ;S DIR("B")="NO"
 ;S DIR("A")="Has a SUCCESSFUL system backup been performed??"
 ;D ^DIR
 ;I $D(DIRUT)!($G(Y)=0) S XPDABORT=1 S XPX="BACKUP" D SORRY Q
 ;S ^TMP("BPCPRE",$J,"BACKUPS CONFIRMED BY "_DUZ)=$H
 ;
 Q
 ;
VERCHK(XPXPKG,XVRMIN) ;
 S X=$$VERSION^XPDUTL(XPXPKG)
 W !!,$$C^XBFUNC("Need at least "_XPXPKG_" "_XVRMIN_"....."_XPXPKG_" "_$S(X'="":X,1:"Is Not")_" Present")
 I X<XVRMIN  D SORRY(XPXPKG_" "_XVRMIN_" Is Not Installed") Q 0
 Q 1
 ;
PATCHCK(XPXPCH) ;
 S X=$$PATCH^XPDUTL(XPXPCH)
 W !!,$$C^XBFUNC("Need "_XPXPCH_"....."_XPXPCH_" "_$S(X:"Is",1:"Is Not")_" Present")
 Q X
 ;
V0200 ;EP Version 2.0 PostInit
 ;Add Protocol items to BSDAM APPOINTMENT EVENTS protocol
 ;
 N BSDXDA,BSDXFDA,BSDXDA1,BSDXSEQ,BSDXDAT,BSDXNOD,BSDXIEN,BSDXMSG
 S BSDXDA=$O(^ORD(101,"B","BSDAM APPOINTMENT EVENTS",0))
 Q:'+BSDXDA
 S BSDXDAT="BSDX ADD APPOINTMENT;10.2^BSDX CANCEL APPOINTMENT;10.4^BSDX CHECKIN APPOINTMENT;10.6^BSDX NOSHOW APPOINTMENT;10.8"
 F J=1:1:$L(BSDXDAT,U) D
 . K BSDXIEN,BSDXMSG,BSDXFDA
 . S BSDXNOD=$P(BSDXDAT,U,J)
 . S BSDXDA1=$P(BSDXNOD,";")
 . S BSDXSEQ=$P(BSDXNOD,";",2)
 . S BSDXDA1=$O(^ORD(101,"B",BSDXDA1,0))
 . Q:'+BSDXDA1
 . Q:$D(^ORD(101,BSDXDA,10,"B",BSDXDA1))
 . S BSDXFDA(101.01,"+1,"_BSDXDA_",",".01")=BSDXDA1
 . S BSDXFDA(101.01,"+1,"_BSDXDA_",","3")=BSDXSEQ
 . D UPDATE^DIE("","BSDXFDA","BSDXIEN","BSDXMSG")
 . Q
 Q
 ;
SORRY(XPX) ;
 K DIFQ
 S XPDABORT=1,XPDBLD=$O(^XTMP("XPDI",XPDA,"BLD",0))
 W !,$$C^XBFUNC($P(^XTMP("XPDI",XPDST,"BLD",XPDBLD,0),U,1)_" "_$P(^XTMP("XPDI",XPDST,"BLD",XPDBLD,0),U,2)_" Cannot Be Installed!")
 W !,$$C^XBFUNC("Reason: "_XPX_".")
 W *7,!!!,$$C^XBFUNC("Sorry....something is wrong with your environment")
 W !,$$C^XBFUNC("Aborting "_XPDNM_" install!")
 W !,$$C^XBFUNC("Correct error and reinstall otherwise")
 W !,$$C^XBFUNC("please print/capture this screen and notify")
 W !,$$C^XBFUNC("the Help Desk")
 W !!,LINE
 D BMES^XPDUTL("Sorry....something is wrong with your environment")
 D BMES^XPDUTL("Enviroment ERROR "_$G(XPX))
 D BMES^XPDUTL("Aborting "_XPDNM_" install!")
 D BMES^XPDUTL("Correct error and reinstall otherwise")
 D BMES^XPDUTL("please print/capture this screen and notify")
 D BMES^XPDUTL("the Help Desk")
 Q
 ;
