AG6P17A ;IHS/ASDST/GTH - Patient Registration 6.0 Patch 17 CONT. ;   [ 04/08/2003  8:49 AM ]
 ;;7.0;IHS PATIENT REGISTRATION;;MAR 28, 2003
 ;
 ; IHS/SET/GTH AG*6*17 10/11/2002
 ;
PRE ;EP - From KIDS.
 Q
 ;
POST ;EP - From KIDS.
 ;
 D BMES^XPDUTL("Beginning post-install routine (POST^AG6P17)."),TS
 ;
 I '$$INSTALLD^AG6P17("AG*6.0*14") D TS,IP14
 ;
 I '$$INSTALLD^AG6P17("AG*6.0*15") D TS,IP15
 ;
 I $$INSTALLD^AG6P17("AG*6.0*17")  D
 . D ^AGSETPRT
 . D TS,BMES^XPDUTL("Delivering AG*7.0 install message to select users...")
 . D MAIL
 . D BMES^XPDUTL("Post-install routine is complete."),TS
 ;
 Q:$$INSTALLD^AG6P17("AG*6.0*17")
 ;
 D TS,OPTRES("AGMENU")
 ;
 D TS,UPLG
 ;
 D TS,CMS
 ;
 D TS,P17^AG6P17B
 ;
 D TS,INDXC^AG6P17B
 ;
 D TS,COVIT^AG6P17B
 ;
 D TS,AGTX^AG6P17B
 ;
 D TS,DELR^AG6P17B
 ;
 D TS,EV^AG6P17B
 ;
 D TS,BMES^XPDUTL("Delivering AG*7.0 install message to select users...")
 D MAIL
 ;
 D DELOPT
 ;
 D ^AGSETPRT
 ;
 D BMES^XPDUTL("Post-install routine is complete."),TS
 Q
 ;
MAIL ; Send install mail message.
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AG6P17MS",$J)
 S ^TMP("AG6P17MS",$J,1)=" --- AG v 7.0, has been installed into this uci ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("AG6P17MS",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""AG6P17MS"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="AGZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("AG6P17MS",$J)
 Q
 ;
DELOPT ; Delete OPTION "AG DDPS HRN DEL"
 S RECNO=0
 F  S RECNO=$O(^DIC(19,"B","AG DDPS HRN DEL",RECNO)) Q:'RECNO  D
 . S DIK="^DIC(19,",DA=RECNO D ^DIK
 Q
 ;
SINGLE(K) ;EP - Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
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
 . D BMES^XPDUTL("INSTALL AUPN 99.1 PATCH 6 AND RUN INDEXAI^AG6P17.")
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
OPTRES(AGM) ;
 D BMES^XPDUTL("Restoring '"_AGM_"' option to PRE-install configuration...")
 NEW AG,AGI
 I '$D(^XTMP("AG6P17",6.17,"OPTSAV",AGM)) D BMES^XPDUTL("FAILED.  Option '"_AGM_"' was not previously saved.") Q
 S AG=0
 F  S AG=$O(^XTMP("AG6P17",6.17,"OPTSAV",AGM,AG)) Q:'AG  S AGI=^(AG) I '$$ADD^XPDMENU(AGM,$P(AGI,U,1),$P(AGI,U,2),$P(AGI,U,3)) D BMES^XPDUTL("....FAILED to re-atch "_$P(AGI,U,1)_" to "_AGM_".")
 Q
 ;
IP14 ; Items from patch 14.
 D BMES^XPDUTL("Patch 14 was not installed.  Performing P14 items...")
 ;
 D INDEXAI
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
 Q
 ;
IP15 ;
 D BMES^XPDUTL("Patch 15 was not installed.  Performing P15 items...")
 ;
 D BMES^XPDUTL("Attaching ""AG TM ELIGIBILITY"" option to the table maintenance menu ""TM"".")
 I $$ADD^XPDMENU("AG TM MENU","AG TM ELIGIBILITY","ELUP",10) D BMES^XPDUTL("....successfully atch'd.") I 1
 E  D BMES^XPDUTL("....Attachment *FAILED*.")
 ;
 D BMES^XPDUTL("Attaching ""AG3PSUM"" option to the the Third Party Billing Reports ""THR"".")
 I $$ADD^XPDMENU("AGBILL","AG3PSUM","AGSM",4) D BMES^XPDUTL("....successfully atch'd.") I 1
 E  D BMES^XPDUTL("....Attachment *FAILED*.")
 ;
 I $$VAL^XBDIQ1(9999999.39,1,.15)'="YES" D
 . NEW AG
 . S AG=0
 . F  S AG=$O(^ABMDCLM(AG)) Q:'AG  I $$FMDIFF^XLFDT(DT,$O(^ABMDCLM(AG,"AC",9999999),-1),1)<180 D  Q
 .. NEW DA,DIE,DR
 .. S DIE=9999999.39,DA=1,DR=".15///Y"
 .. D ^DIE
 .. I '$D(Y) D  Q
 ... D BMES^XPDUTL("The 'THIRD-PARTY BILLING PRESENT' field in RPMS SITE had been changed to 'YES',")
 ... D MES^XPDUTL("based on 3PB editing activity in the last 6 months."),MES^XPDUTL("'YES' ensures setting of the 'ABILL' x-ref in the VISIT file.")
 ...Q
 .. D BMES^XPDUTL("** ERROR:  EDIT OF .15 IN RPMS SITE FILE FAILED.")
 .. Q
 .Q
 Q
 ;
UPLG ; Fix bug in ^AGELUPLG.
 D BMES^XPDUTL("Fixing bad info in ELIGIBILITY UPLOAD LOG caused by bug...")
 NEW AGDA,AGRUN,AGSUB,DA,DFN,DIK
 S AGRUN=0
 F  S AGRUN=$O(^AGELUPLG(AGRUN)) Q:'AGRUN  D
 . F AGSUB=1,2 S AGDA=0 F  S AGDA=$O(^AGELUPLG(AGRUN,AGSUB,AGDA)) W:'$D(ZTQUEUED) "." Q:'AGDA  S DFN=$P(^(AGDA,0),U) I AGDA'=DFN D
 .. S DIK="^AGELUPLG("_AGRUN_","_AGSUB_",",DA(1)=AGRUN,DA=AGDA
 .. D ^DIK
 .. D PTACT^AGELUP2(AGSUB,DFN)
 .Q
 D MES^XPDUTL("Fix complete.")
 Q
 ;
CMS ; Deactive the CMS Railroad template and re-name both from "HCFA" to "CMS".
 D BMES^XPDUTL("Deactivating HCFA Railroad template, renaming both templates....")
 NEW AGY,DIC,X
 S DIC=9009062.01,DIC(0)="",X="HCFA RAILROAD RETIREMENT"
 D ^DIC
 I +Y<1 D MES^XPDUTL("'HCFA RAILROAD RETIREMENT' template not found (that's OK).") I 1
 E  D
 . NEW DA,DIE,DR
 . S AGY=$P(Y,U,2),DA=+Y,DIE=DIC,DR=".01///CMS RAILROAD RETIREMENT;.07///"_DT
 . D ^DIE
 . D MES^XPDUTL("'"_AGY_"' template renamed 'CMS RAILROAD RETIREMENT'.")
 .Q
 S DIC=9009062.01,DIC(0)="",X="HCFA MEDICARE"
 D ^DIC
 I +Y<1 D MES^XPDUTL("'HCFA MEDICARE' template not found (that's OK).") I 1
 E  D
 . NEW DA,DIE,DR
 . S AGY=$P(Y,U,2),DA=+Y,DIE=DIC,DR=".01///CMS MEDICARE"
 . D ^DIE
 . D MES^XPDUTL("'"_AGY_"' template renamed 'CMS MEDICARE'.")
 .Q
 D MES^XPDUTL("CMS complete.")
 Q
 ;
TS D MES^XPDUTL($$HTE^XLFDT($H)) Q
 ;
