AG6P14 ;IHS/ASDST/GTH - AG 6 PATCH 14 ; 
 ;;7.0;IHS PATIENT REGISTRATION;;MAR 28, 2003
 ;
 ; IHS/ASDST/GTH AG*6*14 09/27/2001
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(1) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(1) Q
 ;
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"DUZ(0) DOES NOT CONTAIN AN '@'." D SORRY(1) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$C^XBFUNC("Hello, "_$P(X,",",2)_" "_$P(X,","))
 W !!,$$C^XBFUNC("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".")
 ;
 S X=$$VERSION^XPDUTL("AG")
 W !!,$$C^XBFUNC("Need AG v 6.0.....AG v "_X_" Present")
 I X<6 D SORRY(1) Q
 ;
 S X=$$VERSION^XPDUTL("DI")
 W !,$$C^XBFUNC("Need at least FileMan 21.....FileMan "_X_" Present")
 I X<21 D SORRY(1) Q
 ;
 S X=$$VERSION^XPDUTL("XU")
 W !,$$C^XBFUNC("Need at least Kernel 8.....Kernel "_X_" Present")
 I X<8 D SORRY(1) Q
 ;
 S X=$$VERSION^XPDUTL("AUT")
 W !,$$C^XBFUNC("Need at least AUT 98.1.....AUT "_X_" Present")
 I X<98.1,+X'=1.1 D SORRY(1) Q
 ;
 S X=$$VERSION^XPDUTL("AUPN")
 W !,$$C^XBFUNC("Need at least AUPN 99.1.....AUPN "_X_" Present")
 I X<99.1 D SORRY(1) Q
 ;
 NEW DA,DIC
 S X="AG",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AG")) D  Q
 . W !!,*7,*7,$$C^XBFUNC("You Have More Than One Entry In The"),!,$$C^XBFUNC("PACKAGE File with an ""AG"" prefix.")
 . W !,$$C^XBFUNC("One entry needs to be deleted.")
 . W !,$$C^XBFUNC("FIX IT! Before Proceeding."),!!,*7,*7,*7
 . D SORRY(1)
 . I $$DIR^XBDIR("E")
 .Q
 W !,$$C^XBFUNC("No 'AG' dups in PACKAGE file")
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . D BMES^XPDUTL("Saving 7 AGTX* routines, just in case....")
 . D BEFSAV
 . D BMES^XPDUTL("Saving the configuration of option AGMENU...")
 . D OPTSAV("AGMENU")
 .Q
 ;
 W !!,$$C^XBFUNC("ENVIRONMENT OK.")
 ;
 NEW B
 I $G(XPDA) S B=$O(^XTMP("XPDI",XPDA,"BLD",0))
 I $G(B),$$DIR^XBDIR("Y","Do you want to see the notes","NO","Do you want to see the notes file for this patch","","",1) D
 . S %=0
 . F  S %=$O(^XTMP("XPDI",XPDA,"BLD",B,1,%)) Q:'%   W !,^(%,0) I '(%#20),'$$DIR^XBDIR("E","","","","","",1) Q
 .Q
 KILL B
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(1) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X,XPDQUIT("AG*6*14")=1
 W:'$D(ZTQUEUED) *7,!,$$C^XBFUNC("Sorry...."),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
PRE ;EP - From KIDS.
 Q
 D BMES^XPDUTL("Beginning pre-install routine (PRE^AG6P14).")
 D BMES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP - From KIDS.
 D BMES^XPDUTL("Beginning post-install routine (POST^AG6P14).")
 D INDEXAI
 ;
 D BMES^XPDUTL("Saving 7 AGTX* post-P14 routines, just in case....")
 D AFTSAV^AGTXCONF
 ;
 D BMES^XPDUTL("Q'ing Name check report...")
 S ZTRTN="START^AGEDNAME",ZTIO="",ZTDESC=$P($P($T(+1^AGEDNAME),";",2)," ",3,99),ZTDTH=$H
 D ^%ZTLOAD
 I $D(ZTSK) D MES^XPDUTL("Que'd to task "_ZTSK_".") I 1
 E  D BMES^XPDUTL("Que of Name check report *FAILED*.")
 ;
 D BMES^XPDUTL("Attaching ""AG REP NAME CHECK"" option to menu ""REGISTRATION REPORTS"".")
 I $$ADD^XPDMENU("AGREPORTS","AG REP NAME CHECK","STD",25) D BMES^XPDUTL("....successfully atch'd....allocating Security Keys...") D  I 1
 . NEW AG,DA,DIC,DINUM
 . S AG=0,AG("RPT")=$O(^DIC(19.1,"B","AGZREPORTS",0)),AG("STD")=$O(^DIC(19.1,"B","AGZNAMECHECK",0))
 . Q:'AG("RPT")!'AG("STD")
 . S DIC(0)="NMQ",DIC("P")="200.051PA"
 . F  S AG=$O(^XUSEC("AGZREPORTS",AG)) Q:'AG  D
 .. Q:$D(^VA(200,AG,51,AG("STD")))
 .. S DIC="^VA(200,AG,51,",DA(1)=AG,(DINUM,X)=AG("STD")
 .. D FILE^DICN
 ..Q
 .Q
 E  D BMES^XPDUTL("....Attachment *FAILED*.")
 ;
 D BMES^XPDUTL("Attaching ""AGTXALL"" option to the export menu ""AGTX"".")
 I $$ADD^XPDMENU("AGTX","AGTXALL","ALL",10) D BMES^XPDUTL("....successfully atch'd."),BMES^XPDUTL("NOTE: Security key will *NOT* be allocated.") I 1
 E  D BMES^XPDUTL("....Attachment *FAILED*.")
 ;
 D BMES^XPDUTL("Attaching ""AG TX CONFIG"" option to the export menu ""AGTX"".")
 I $$ADD^XPDMENU("AGTX","AG TX CONFIG","CON",11) D BMES^XPDUTL("....successfully atch'd."),BMES^XPDUTL("NOTE: Security key will *NOT* be allocated.") I 1
 E  D BMES^XPDUTL("....Attachment *FAILED*.")
 ;
 D BMES^XPDUTL("Restoring ""AGMENU"" option to PRE-install configuration...")
 D OPTRES("AGMENU")
 ;
 D BMES^XPDUTL("Delivering AG*6*14 install message to select users...")
 D SAVE
 NEW DIFROM
 D MAIL^XBMAIL("AGZMENU,XUMGR-XUPROGMODE","MSG^AG6P14MS")
 S X="AG6P14MS"
 X ^%ZOSF("DEL")
 ;
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
 ;
SAVE ; Save first few lines of install message into tmp global.
 KILL ^TMP("AG6P14MS",$J)
 S ^TMP("AG6P14MS",$J,1,0)="AG6P14MS ;IHS/ASDST/GTH - AG6P14 INSTALL MESSAGE ;"
 S ^TMP("AG6P14MS",$J,2,0)=$T(+2)
 S ^TMP("AG6P14MS",$J,3,0)="MSG ;;"
 S ^TMP("AG6P14MS",$J,4,0)=" ;;AG V "_$P($T(+2),";",3)_" "_$P($T(+2),";",4)_", Patch "_$P($P($T(+2),";",5),"**",2)
 S ^TMP("AG6P14MS",$J,5,0)=" ;; --- AG v 6, Patch 14, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("AG6P14MS",$J,(%+5),0)=" ;;"_^(%,0)
 NEW XCM,DIE,XCN
 S X="AG6P14MS",DIE="^TMP(""AG6P14MS"",$J,",XCN=0
 X ^%ZOSF("SAVE")
 KILL ^TMP("AG6P14MS",$J)
 Q
 ;
INDEXAI ; REINDEX AI XREF PREVIOUS COMMUNITY 
 ;
 ; Thanks to Toni Jarland for the original routine.  Aug 17 2001.
 ;
 ;This runs the AI X-Ref Re-Index of the Previous Communty Multiple
 ;$Order through each AUPNPAT Global Entry & Re-Index AI X-Ref
 ;The AI X-Ref calls Routine AUPNPCTR which $O thru the Previous
 ;Community Multiple & resets the Last Previous Community Entry
 ;to fields #1117 Current Community Mulitple & #1118 Current Community
 ;Text Value.  This will clean up missing Community Pointers used
 ;in the Patient Registration Re-export
 ;
 I $P($T(+2^AUPNPCTR),";",5)'="**6**" D  Q
 . D BMES^XPDUTL("AUPN PATCH 6 IS NOT INSTALLED.")
 . D BMES^XPDUTL("THE AI X-REF RE-FIRE WILL BE IN VAIN.")
 . D BMES^XPDUTL("INSTALL AUPN 99.1 PATCH 6 AND RUN INDEXAI^AG6P14.")
 .Q
 NEW AGB,AGE
 S AGB=$$NOW^XLFDT
 D BMES^XPDUTL("Begin Re-Indexing AI Cross Reference of PATIENT File, "_$$FMTE^XLFDT(AGB))
 W:'$D(ZTQUEUED) !,"Estimated % complete:",!
 NEW AGP3,DA,DIK
 S DA(1)=0,DIK(1)=".03^AI",AGP3=$P(^AUPNPAT(0),U,3)
 F  S DA(1)=$O(^AUPNPAT(DA(1))) Q:'DA(1)  D
 . S DIK="^AUPNPAT("_DA(1)_",51,"
 . D ENALL^DIK
 . I '(DA(1)#100),'$D(ZTQUEUED) W " | ",$J(DA(1)/AGP3*100,0,0),"%"
 .Q
 ;
 S AGE=$$NOW^XLFDT
 D BMES^XPDUTL("End of Re-Indexing AI Cross Reference of PATIENT File, "_$$FMTE^XLFDT(AGE))
 D BMES^XPDUTL($$FMDIFF^XLFDT(AGE,AGB,2)_" seconds")
 Q
 ;
BEFSAV ;this is the same s/r as in AGTXCONF.
 NEW AG,AGM,XCN,XCNP,DIE,DIF
 F AG=1:1:7 D
 . D KT
 . S X=$P($T(BEF+AG),";",3),(XCN,XCNP)=0,(DIE,DIF)="^TMP(""AGTXCONF"",$J,"
 . S AGM="Loading '"_X_"'..."
 . X ^%ZOSF("LOAD")
 . S X=$P($T(BEF+AG),";",4)
 . X ^%ZOSF("TEST")
 . I  D MES^XPDUTL(AGM_"NOT SAVED AS '"_X_"'.  '"_X_"' ALREADY EXISTS.") Q
 . X ^%ZOSF("SAVE")
 . D MES^XPDUTL(AGM_"Saved as '"_X_"'.")
 .Q
 D KT
 Q
 ;
KT KILL ^TMP("AGTXCONF",$J)
 Q
 ;
BEF ; These are the "before p14" routines.
 ;;AGTX1;AGTXX1
 ;;AGTX2;AGTXX2
 ;;AGTX3;AGTXX3
 ;;AGTX4;AGTXX4
 ;;AGTX5;AGTXX5
 ;;AGTXST;AGTXX6
 ;;AGTXTAPE;AGTXX7
 ;
OPTSAV(AGM) ;
 I $D(^XTMP("AG6P14",6.14,"OPTSAV",AGM)) D BMES^XPDUTL("NOT SAVED.  Option '"_AGM_"' has previously been saved.") Q
 I '$D(^XTMP("AG6P14")) S ^XTMP("AG6P14",0)=$$FMADD^XLFDT(DT,30)_U_DT_U_"AG6P14 - SAVE OPTION CONFIGURATIONS."
 NEW I,A
 S I=$O(^DIC(19,"B",AGM,0))
 I 'I D BMES^XPDUTL("NOT SAVED.  Option '"_AGM_"' not found in OPTION file.") Q
 S A=0
 F  S A=$O(^DIC(19,I,10,A)) Q:'A  S ^XTMP("AG6P14",6.14,"OPTSAV",AGM,A)=$P(^DIC(19,+^DIC(19,I,10,A,0),0),U,1)_U_$P(^DIC(19,I,10,A,0),U,2,3)
 Q
 ;
OPTRES(AGM) ;
 NEW AG,AGI
 I '$D(^XTMP("AG6P14",6.14,"OPTSAV",AGM)) D BMES^XPDUTL("FAILED.  Option '"_AGM_"' was not previously saved.") Q
 S AG=0
 F  S AG=$O(^XTMP("AG6P14",6.14,"OPTSAV",AGM,AG)) Q:'AG  S AGI=^(AG) I '$$ADD^XPDMENU(AGM,$P(AGI,U,1),$P(AGI,U,2),$P(AGI,U,3)) D BMES^XPDUTL("....FAILED to re-atch "_$P(AGI,U,1)_" to "_AGM_".")
 Q
 ;
