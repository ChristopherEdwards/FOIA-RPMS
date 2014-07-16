AUMSCB ;IHS/OIT/NKD - SCB UPDATE ENVIRONMENT CHECK/PRE/POST INSTALL 3/08/2013 ;
 ;;14.0;TABLE MAINTENANCE;**2**;AUG 20,2013;Build 1
 ; 03/08/13 - ICD and Language file cleanup
 ; 08/13/13 - Enhanced version/patch checking utility
 ; 12/10/13 - Added table entry count
 ; 03/12/14 - Removed use of AUMPRE for pre-install, changed to just remove AUMDATA entries
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_$S($L($P($T(+2),";",5))>4:" Patch "_$P($T(+2),";",5),1:"")_".",IOM),!
 ;
 S:'$$VCHK("XU","8.0") XPDQUIT=2
 S:'$$VCHK("DI","22.0") XPDQUIT=2
 S:'$$VCHK("AUM","14.0","1") XPDQUIT=2
 S:'$$VCHK("AUT","98.1","26") XPDQUIT=2
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
VCHK(AUMPRE,AUMVER,AUMPAT) ; Check patch level
 N AUMV,AUMP
 S AUMV=$$VERSION^XPDUTL(AUMPRE)
 I (AUMV<AUMVER) K DIFQ D DISP(AUMPRE,AUMVER,$G(AUMPAT),AUMV,$G(AUMP),0) Q 0
 I '$D(AUMPAT) D DISP(AUMPRE,AUMVER,$G(AUMPAT),AUMV,$G(AUMP),1) Q 1
 S AUMP=+$$LAST(AUMPRE,AUMVER)
 I (AUMP<AUMPAT) K DIFQ D DISP(AUMPRE,AUMVER,$G(AUMPAT),AUMVER,$G(AUMP),0) Q 0
 D DISP(AUMPRE,AUMVER,$G(AUMPAT),AUMVER,$G(AUMP),1)
 Q 1
DISP(AUMPRE,AUMVER,AUMPAT,AUMV,AUMP,AUMR) ; Display requirement checking results
 ;
 N AUMS
 S AUMS="Need at least "_$G(AUMPRE)_" v"_$G(AUMVER)_$S($G(AUMPAT)]"":" p"_$G(AUMPAT),1:"")_"....."
 S AUMS=AUMS_$G(AUMPRE)_" v"_$G(AUMV)_$S($G(AUMP)]"":" p"_$G(AUMP),1:"")_" Present"
 S AUMS=AUMS_$S('AUMR:" ***FIX IT***",1:"")
 W !,$$CJ^XLFSTR(AUMS,IOM)
 Q
LAST(PKG,VER) ; EP - returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"C",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)=LATEST,$P(^(0),U)>PATCH S PATCH=$P(^(0),U)
 Q PATCH_U_LATEST
 ;
PRE ; EP FR KIDS
 ; IHS/OIT/NKD AUM*14.0*2 REMOVE DATA FROM AUMDATA W/O CLEANING UP CONTROL CHARS - START OLD CODE
 ;CLEAN UP CONTROL CHAR AND REMOVE DATA FROM AUMDATA
 ;D START^AUMPRE  ; IHS/OIT/NKD AUM*14.0*2 END OLD CODE - START NEW CODE
 N AUMI
 S AUMI=0 F  S AUMI=$O(^AUMDATA(AUMI)) Q:'AUMI  K ^AUMDATA(AUMI)
 F AUMI=3,4 S $P(^AUMDATA(0),"^",AUMI)=0
 ; IHS/OIT/NKD AUM*14.0*2 END NEW CODE
 Q
 ;
POST ; EP FR KIDS
 K ^TMP("AUM",$J)  ; IHS/OIT/NKD AUM*14.0*1
 D COUNT  ; IHS/OIT/NKD AUM*14.0*1 - ADDED TOTAL COUNT TO OUTPUT
 D POST^AUMSCBD
 K ^TMP("AUM",$J)  ; IHS/OIT/NKD AUM*14.0*1
 Q
 ;
COUNT ; COUNT THE NUMBER OF ENTRIES FOR EACH TABLE
 N AUMI,AUMT,AUMA,AUMC
 S AUMI=0 F  S AUMI=$O(^AUMDATA(AUMI)) Q:'AUMI  D
 . S (AUMT,AUMA)=""
 . S AUMT=$P(^AUMDATA(AUMI,0),U,2)
 . F AUMC="ADD","INA","DEL","ALL" Q:$L(AUMA)>0  S:$E(AUMT,$L(AUMT)-2,$L(AUMT))=AUMC AUMA=$E(AUMT,$L(AUMT)-2,$L(AUMT)),AUMT=$E(AUMT,1,$L(AUMT)-3)
 . S ^TMP("AUM",$J,"COUNT",AUMT)=$G(^TMP("AUM",$J,"COUNT",AUMT))+1
 Q
 ;
INTROE ; Intro text during KIDS Environment check.
 ;;This is the update to the standard code book tables.  There are modifications
 ;;and additions to the following files:  Community, Location, Tribe,
 ;;Reservation and Service Unit.
 ;;
 ;;The install message will report updates and failed updates to those files. 
 ;;
 ;;###
 ;
INTROI ; Intro text during KIDS Install.
 ;;If you run interactively, results will be displayed on your screen,
 ;;and recorded in the entry in the INSTALL file.
 ;;If you queue to TaskMan, remember not to Q to the HOME device.
 ;;###
 ;
