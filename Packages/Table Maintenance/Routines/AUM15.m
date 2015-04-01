AUM15 ;IHS/OIT/NKD - ENVIRONMENT CHECK/PRE/POST-INSTALL FOR ICD 9 CODES FY2015 09/09/14 ; 
 ;;15.0;TABLE MAINTENANCE;;SEP 09,2014;Build 1
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_$S($L($P($T(+2),";",5))>4:" Patch "_$P($T(+2),";",5),1:"")_".",IOM),!
 ;
 S:'$$VCHK("XU","8.0","1017") XPDQUIT=2
 S:'$$VCHK("XT","7.3","1017") XPDQUIT=2
 S:'$$VCHK("DI","22.0","1017") XPDQUIT=2
 N AUMAICD S AUMAICD=$$VERSION^XPDUTL("AICD"),XPDQUIT=$S(AUMAICD>3.51:2,1:$G(XPDQUIT))
 W !,$$CJ^XLFSTR("Need AICD v3.51.....AICD v"_AUMAICD_" Present"_$S(AUMAICD>3.51:" ***FIX IT***",1:""),IOM)
 S:'$$VCHK("AUM","14.0") XPDQUIT=2
 S:'$$VCHK("BCSV","1.0","3") XPDQUIT=2
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
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
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
PRE ; EP - PRE-INSTALL
 N AUMI
 ; RE-XREF ^ICD9
 D RSLT("ICD Diagnosis file cleanup"),^XBFMK W !
 F AUMI=$NA(^ICD9("AB")),$NA(^ICD9("BA")) K @AUMI
 S DIK="^ICD9(",DIK(1)=".01"
 D ENALL^DIK
 ; RE-XREF ^ICD0
 D RSLT("ICD Operation/Procedure file cleanup"),^XBFMK W !
 F AUMI=$NA(^ICD0("AB")),$NA(^ICD0("BA")) K @AUMI
 S DIK="^ICD0(",DIK(1)=".01"
 D ENALL^DIK
 ; REMOVE PREVIOUS ^AUMDATA
 S AUMI=0 F  S AUMI=$O(^AUMDATA(AUMI)) Q:'AUMI  K ^AUMDATA(AUMI)
 F AUMI=3,4 S $P(^AUMDATA(0),"^",AUMI)=0
 ;
 Q
POST ; EP - POST-INSTALL
 N AUMDUP
 D RSLT($J("",24)_"Resolving duplicate ICD entries",1),RSLT($J("",24)_$$REPEAT^XLFSTR("-",31))
 D RSLT("Scan #1"),MAIN^AUM15DU
 ;
 S AUMDUP=+$O(^XTMP("AUM",""),-1),AUMDUP=+$G(^XTMP("AUM",AUMDUP,"COUNT"))
 I AUMDUP D RSLT("Scan #2"),MAIN^AUM15DU
 ;
 S AUMDUP=+$O(^XTMP("AUM",""),-1),AUMDUP=+$G(^XTMP("AUM",AUMDUP,"COUNT"))
 I AUMDUP D SEARCH^AUM15DU($NA(^TMP("AUM",$J,"SCAN"))) I +$G(^TMP("AUM",$J,"SCAN","COUNT")) D
 . D RSLT($$REPEAT^XLFSTR("*",80),1)
 . D RSLT($G(^TMP("AUM",$J,"SCAN","COUNT"))_" duplicate ICD entries remain!")
 . D RSLT("Contact the OIT Help Desk for assistance")
 . D RSLT($$REPEAT^XLFSTR("*",80))
 ;
 D RSLT($J("",24)_"Performing ICD full table update",1),RSLT($J("",24)_$$REPEAT^XLFSTR("-",32))
 D MAIN^AUM15U
 Q
RSLT(%,LINE) ; EP - INSTALL MESSAGES
 I $D(LINE) D BMES^XPDUTL(%)
 I '$D(LINE) D MES^XPDUTL(%)
 Q
 ;