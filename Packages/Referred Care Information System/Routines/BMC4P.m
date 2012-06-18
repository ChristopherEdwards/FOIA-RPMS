BMC4P ;IHS/ITSC/FCJ - BMC 4.0 INSTALL RTN 1 OF 2;     
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 I '$G(IOM) D HOME^%ZIS
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 I '$G(DUZ) W !,$$CJ^XLFSTR("DUZ UNDEFINED OR 0.",IOM) D SORRY(2) Q
 I '$L($G(DUZ(0))) W !,$$CJ^XLFSTR("DUZ(0) UNDEFINED OR NULL.",IOM) D SORRY(2) Q
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,$$CJ^XLFSTR("DUZ(0) DOES NOT CONTAIN AN '@'.",IOM) D SORRY(2) Q
 ;
ENV S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_".",IOM)
 ;
 S BMCNEW=""
 D NEW I 'BMCNEW I $$VCHK("BMC","3.0",2,"<")
 I $$VCHK("XU","8.0",2,"<")
 I $$VCHK("DI","21.0",2,"<")
 I $$VCHK("ATX","5.1",2,"<")
 I $$VCHK("AUPN","99.1",2,"<")
 G:BMCNEW ENV1
 ;
 NEW DA,DIC
 S X="BMC",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","BMC")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""BMC"" prefix.",IOM)
 . W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM)
 . D SORRY(2)
 ;
MGR ;****CHECK FOR CHS MANAGER IN PARAMETER, NEEDED TO CONVERT MESSAGES
 S X=0,BMCER=0
 F  S X=$O(^BMCPARM("B",X)) Q:X'?1N.N  D  Q:BMCER
 .S BMCMGR(X)=$P(^BMCPARM(X,0),U,13)
 .I BMCMGR(X)'>0 S BMCER=1
 I BMCER W !!?5,"In the RCIS Site Parameter File CHS Supervisor is not Entered.  This is",!?5,"required for the install." S XPDQUIT=2
ENV1 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR(IORVON_"You must Fix it Before Proceeding."_IORVOFF,IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 D HELP^XBHELP("INTROE","BMC4P")
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 ;
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0 D HELP^XBHELP("INTROI","BMC4P") I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR(IORVON_"Sorry....You must fix it before you can install."_IORVOFF,IOM)
 Q
 ;
VCHK(BMCPRE,BMCVER,BMCQUIT,BMCCOMP) ; Check versions needed.
 ;  
 NEW BMCV
 S BMCV=$$VERSION^XPDUTL(BMCPRE)
 W !,$$CJ^XLFSTR("Need "_$S(BMCCOMP="<":"at least ",1:"")_BMCPRE_" v "_BMCVER_"....."_BMCPRE_" v "_BMCV_" Present",IOM)
 S BMCV=+(BMCV)
 I @(BMCV_BMCCOMP_BMCVER) D SORRY(BMCQUIT) Q 0
 Q 1
 ;
NEW ;TEST FOR NEW PACKAGE
 S X="BMC",Y="BMB"
 I '$D(^DIC(9.4,"C","BMC")),'$D(^DIC(19,"C",X)),'($E($O(^DIC(19,"B",Y)),1,4)=X),'($E($O(^DIC(19.1,"B",Y)),1,4)=X) W !!,$$CJ^XLFSTR("NEW INSTALL",IOM),! S BMCNEW=1 Q
 Q
 ;
INTROE ; Intro text during KIDS Environment check.
 ;;In this distribution:
 ;;(1) Secondary Referrals 
 ;;    a. Moved Secondary referrals to RCIS Referral file
 ;;    b. Moved Secondary Med Hx comments to RCIS Comments file
 ;;    c. Modified numerous routines to filter Sec Ref from options
 ;;    d. Sec Ref can be displayed using the Display Referral option
 ;;    e. Reports: 
 ;;        1. Added Sec Ref information to the Adm reports
 ;;        2. Sec Ref can now be selected in the General Retrieval
 ;;           Reports Option
 ;;        3. Combined Sec Ref info with in the Utilization reports
 ;;        4. Display Sec Ref info on the Case Management
 ;;           Reports
 ;;    f. Letters added option to print Prim Med HX on letter, also
 ;;       added the date, priority and ref type to print on letter
 ;;    g. Added new fields, amt date, priority, type, local category
 ;;       and status
 ;;    h. Sec Ref can be selected when entering a CHS PO or Denial
 ;;    i. CHS info can be entered for the Sec Ref
 ;;(2) Reports
 ;;     a. Added date range selection to Adm reports
 ;;     b. Added Browse function to Adm reports
 ;;     c. Changed HRN to Ref # on CHS reports
 ;;     d. Sub-totals on Inhouse referral reports
 ;;     e. Removed the CHS Denial still active report
 ;;     f. Added call-ins only and Case com dt to Gen Ret report
 ;;     g. Added Pat elig status on RRR report
 ;;(3) Default on Mod option 2 All Data changed to "Q"
 ;;(4) Review comments for MD/MCC option changed selection to ref #,
 ;;    Patient or date entered
 ;;(5) Site Parameter for CHS, if link is Yes
 ;;    a. Added option to auto close ref for denials linked to Ref
 ;;    b. Added option to allow entry of CHS PO's without a referral
 ;;(6) Print user who entered comments only Date stamp was printing
 ;;(7) View face sheet and HS default to "No" after viewing, also
 ;;    added options to Sec Ref template and Clinicians template
 ;;(8) Closing a ref, removed C2, changed all C2 entries to X and added
 ;;    Unknown and other to reasons, if Other is entered a comment can
 ;;    be entered.
 ;;(9) New option under edit menu to send Mailman message to Referring
 ;;    Provider and Primary care Provider.
 ;;(10)Miscellaneous routine modifications
 ;;  Note: for complete description of changes see RCIS User's manual
 ;;###
 ;
INTROI ; Intro text during KIDS Install.
 ;;A standard message will be produced by this update.
 ;;  
 ;;If you run interactively, results will be displayed on your screen,
 ;;as well as in the mail message and the entry in the INSTALL file.
 ;;If you queue to TaskMan, please read the mail message for results of
 ;;this update, and remember not to Q to the HOME device.
 ;;###
 ;
 ;
AUDS ;EP - From BMC4P0
 D BMES^XPDUTL("Saving current DD AUDIT settings for RCIS files")
 D MES^XPDUTL("and turning DD AUDIT to 'Y'.")
 S ^XTMP("BMC4P0",0)=$$FMADD^XLFDT(DT,10)_"^"_DT_"^"_$P($P($T(+1),";",2)," ",3,99)
 NEW BMC
 S BMC=0
 F  S BMC=$O(^XTMP("XPDI",XPDA,"FIA",BMC)) Q:'BMC  D
 . I '$D(^XTMP("BMC4P0",BMC,"DDA")) S ^XTMP("BMC4P0",BMC,"DDA")=$G(^DD(BMC,0,"DDA"))
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(BMC,12)_" - "_$$LJ^XLFSTR(^XTMP("XPDI",XPDA,"FIA",BMC),30)_"- DD audit was '"_$G(^XTMP("BMC4P0",BMC,"DDA"))_"'"),MES^XPDUTL($$RJ^XLFSTR("Set to 'Y'",69))
 . S ^DD(BMC,0,"DDA")="Y"
 .Q
 D MES^XPDUTL("DD AUDIT settings saved in ^XTMP(.")
 Q
 ; -----------------------------------------------------
DELC ;EP;DEL COM FR THE RCIS REF FILE, ie MED HX, BO and Discharge notes
 ;Moved to the RCIS Com file in v3
 Q:$$INSTALL^BMC4P0("BMC 4.0T")  ;Q IF V4.0 INSTALLED
 Q:$$INSTALL^BMC4P0("BMC 4.0")  ;Q IF V4.0 INSTALLED
 D BMES^XPDUTL("Med Hx, BO and Discharge comments were moved in v3.0.")
 D BMES^XPDUTL("BEGIN deleting duplicate Med Hx, BO and Discharge comments.")
 S BMCINST="DELC" D SETVARS^BMC4P0
 Q:$P(^XTMP("BMC4IN",BMCJOB,BMCINST),U)="C"
 F  S BMC=$O(^BMCREF(BMC)) Q:BMC'?1N.N  D
 .F I=1,2,3 I $D(^BMCREF(BMC,I)) D
 ..S DA="" F  S DA=$O(^BMCREF(BMC,I,DA)) Q:DA'?1N.N  D
 ...S DA(1)=BMC,DIK="^BMCREF("_DA(1)_","_I_"," D ^DIK
 ..K ^BMCREF(BMC,I,0)  ;DIK WILL NOT KILL 0 NODE OF WP FIELD
 .S BMCCT=BMCCT+1 I BMCCT#100=1 W "."
 .S $P(^XTMP("BMC4IN",BMCJOB,BMCINST),U,2,3)=BMC_U_BMCCT
 S $P(^XTMP("BMC4IN",BMCJOB,BMCINST),U)="C"  ;COMPLETED
 D BMES^XPDUTL("COMPLETED deletion of Med Hx, BO and Discharge comments.")
 Q
 ; -----------------------------------------------------
DELFLD ;EP
 ;;90001^RCIS REFERRAL^1^PERTINENT MED HX & FINDINGS
 ;;90001^RCIS REFERRAL^2^BUSINESS OFFICE/CHS COMMENTS
 ;;90001^RCIS REFERRAL^3^DISCHARGE NOTES
 ;;END
 Q:$$INSTALL^BMC4P0("BMC 4.0T")  ;Q IF V4.0 INSTALLED
 Q:$$INSTALL^BMC4P0("BMC 4.0")  ;Q IF V4.0 INSTALLED
 D BMES^XPDUTL("BEGIN Removing fields from RCIS data dictionary.")
 NEW DA,DIK
 F BMC=1:1:3 S X=$P($T(DELFLD+BMC),";",3) D
 . D MES^XPDUTL($J("",5)_"Deleting '"_$$LJ^XLFSTR($P(X,U,4),30,".")_"' from '"_$P(X,U,2)_"'")
 . S DA(1)=$P(X,U,1),DA=$P(X,U,3),DIK="^DD("_DA(1)_","
 . D ^DIK
 D MES^XPDUTL("END Removing deleted fields from RCIS data dictionary.")
 Q
 ; -----------------------------------------------------
RESUF ;TEST AND RESET DUPLICATE SUFFIX VALUES
 Q:$$INSTALL^BMC4P0("BMC 4.0T")  ;Q IF V4.0 INSTALLED
 Q:$$INSTALL^BMC4P0("BMC 4.0")  ;Q IF V4.0 INSTALLED
 D BMES^XPDUTL("BEGIN Resetting Duplicate Secondary Referral suffix.")
 S BMCREF=0
 F  S BMCREF=$O(^BMCPROV("S",BMCREF)) Q:BMCREF'?1N.N  S CT=0 D
 .Q:'$D(^BMCPROV("S",BMCREF,"A10"))
 .S BMCSUF="A1",BMCSUFN1=0
 .F  S BMCSUF=$O(^BMCPROV("S",BMCREF,BMCSUF)) Q:BMCSUF=""  D
 ..S BMCIEN=0
 ..F  S BMCIEN=$O(^BMCPROV("S",BMCREF,BMCSUF,BMCIEN)) Q:BMCIEN'?1N.N  S CT=CT+1 I CT>1 D
 ...S:BMCSUF="A10" ^XTMP("BMC4IN",$J,"SUF",BMCREF,BMCIEN,BMCSUF)=""
 ..S BMCSUFN=$E(BMCSUF,2,3) Q:BMCSUFN'>9
 ..S:BMCSUFN>BMCSUFN1 BMCSUFN1=BMCSUFN
 .;SUFFIX VALUES
 .S BMCIEN=0 F  S BMCIEN=$O(^XTMP("BMC4IN",$J,"SUF",BMCREF,BMCIEN)) Q:BMCIEN'?1N.N  D
 ..Q:'$D(^XTMP("BMC4IN",$J,"SUF",BMCREF,BMCIEN,"A10"))
 ..S BMCSUFN1=BMCSUFN1+1
 ..S ^XTMP("BMC4IN",$J,"SUF",BMCREF,BMCIEN,"A10")=BMCSUFN1
 ..;SET NEW SUFFIX IN BMCPROV....
 ..S DIE="^BMCPROV(",DA=BMCIEN,DR="201////A"_BMCSUFN1 D ^DIE
 ..K DIE,DA,X,DR
 K BMCREF,BMCSUF,BMCSUFN,BMCSUFN1
 D MES^XPDUTL("END Resetting Duplicate Secondary Referral suffix.")
 Q
 ; -----------------------------------------------------
