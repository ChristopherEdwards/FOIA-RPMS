BMC4P0 ;IHS/ITSC/FCJ - BMC 4.0 INSTALL 2 OF 2;       
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;PRE AND POST ROUTINE FOR INSTALL
 ;
PRE ;EP - From KIDS.
 I BMCNEW Q
 ; ---Save and remove dd audit settings.
 I $$NEWCP^XPDUTL("PRE1","AUDS^BMC4P")
 ; ---Delete Med HX, BO, and discharge notes fr RCIS Referral file
 S %="DELC^BMC4P"
 I $$NEWCP^XPDUTL("PRE2-"_%,%)
 ; ---Delete Fields: Med HX,BO,Discharge Comments fr RCIS Ref file 
 S %="DELFLD^BMC4P"
 I $$NEWCP^XPDUTL("PRE3-"_%,%)
 ; ---Reset Suffix for Sec Ref
 S %="RESUF^BMC4P"
 I $$NEWCP^XPDUTL("PRE4-"_%,%)
 Q
 ;
POST ;EP - From KIDS.
 ;TEST FOR NEW INSTALL
 I BMCNEW D  G SNDM
 .S %="START^BMCPOST"
 .I $$NEWCP^XPDUTL("POS1-"_%,%)
 ;
 ; ---update RCIS Referral with Secondary Ref
 S %="V4SEC^BMC4P0"
 I $$NEWCP^XPDUTL("POS2-"_%,%)
 ;
 ; --- Update the closed status from "C2" to "X"
 S %="V4CLS^BMC4P0"
 I $$NEWCP^XPDUTL("POS3-"_%,%)
 ;
 ; --- Remove CHS Denial report menu option
 S %="V4OPT^BMC4P0"
 I $$NEWCP^XPDUTL("POS4-"_%,%)
 ;
 ; --- Restore dd audit settings.
 S %="AUDR^BMC4P0"
 I $$NEWCP^XPDUTL("POS5-"_%,%)
 ;
SNDM ; --- Send mail message of install.
 S %="MAIL^BMC4P0"
 I $$NEWCP^XPDUTL("POS6-"_%,%)
 Q
 ;
MAIL ;
 D BMES^XPDUTL("BEGIN Delivering MailMan message to select users.")
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP("BMC4P0",$J)
 D RSLT(" --- BMC v 4.0, has been installed into this uci ---")
 F %=1:1 D RSLT($P($T(GREET+%),";",3)) Q:$P($T(GREET+%+1),";",3)="###"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D RSLT(^(%,0))
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""BMC4P0"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="BMCZMENU","XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("BMC4P0",$J)
 D MES^XPDUTL("END Delivering MailMan message to select users.")
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("BMC4P0",$J,0))+1,^(^(0))=%
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
GREET ;;To add to mail message.
 ;;  
 ;;Greetings.
 ;;  
 ;;Standard data dictionaries on your RPMS system have been updated.
 ;;  
 ;;You are receiving this message because of the particular RPMS
 ;;security keys that you hold.  This is for your information, only.
 ;;You need do nothing in response to this message.
 ;;  
 ;;Questions about this version, which is a product of the RPMS DBA
 ;;,
 ;;can be directed to the Help Desk,
 ;;.
 ;;Please refer to "bmc 4.0.
 ;;  
 ;;###;NOTE: This line indicates the end of text in this message.
 ;
 ; -----------------------------------------------------
 ; The global location for dictionary audit is:
 ;           ^DD(FILE,0,"DDA")
 ; If the valuey is "Y", dd audit is on.  Any other value, or the
 ; absence of the node, means dd audit is off.
 ; -----------------------------------------------------
AUDR ; Restore the file data audit values to their original values.
 D BMES^XPDUTL("Restoring DD AUDIT settings for RCIS files.")
 NEW BMC
 S BMC=0
 F  S BMC=$O(^XTMP("BMC4P0",BMC)) Q:'BMC  D
 . S ^DD(BMC,0,"DDA")=^XTMP("BMC4P0",BMC,"DDA")
 . D MES^XPDUTL(" File "_$$RJ^XLFSTR(BMC,12)_" - "_$$LJ^XLFSTR($$GET1^DID(BMC,"","","NAME"),30)_"- DD AUDIT Set to '"_^DD(BMC,0,"DDA")_"'")
 .Q
 KILL ^XTMP("BMC4P0")
 D MES^XPDUTL("DD AUDIT settings restored.")
 Q
 ; -----------------------------------------------------
 ;
INSTALL(BMC) ;EP; Determine if VERSION OF BMC was installed, where BMC is
 ; the name of the INSTALL.  E.g "BMC 4.00".
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(BMC," ",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(BMC," ",2)
 D ^DIC
 I Y<1 Q 0
 Q $S(Y<1:0,1:1)
 ; -----------------------------------------------------
INSTALLD(BMC) ; Determine if patch BMC was installed, where BMC is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(BMC,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(BMC,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(BMC,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ; -----------------------------------------------------
V4SEC ;Move Sec Ref to RCIS Ref file
 Q:$$INSTALL^BMC4P0("BMC 4.0T")  ;Q IF V4.0 INSTALLED
 Q:$$INSTALL^BMC4P0("BMC 4.0")  ;Q IF V4.0 INSTALLED
 D SETMGR Q:XPDQUIT=2
 D BMES^XPDUTL("Moving Secondary Referrals to RCIS Referral file.")
 ;BMCNEW=NEW SR ENTRY IN RCIS REF FILE
 ;BMCIEN=PRIM REF LINK TO SEC REF ;BMCSRIEN=SEC REF IN OLD FILE
 S BMCINST="SETSEC" D SETVARS
 Q:$P(^XTMP("BMC4IN",BMCJOB,BMCINST),U)="C"
 Q:'$D(^BMCPROV("AD"))
 S BMCIEN=BMC F  S BMCIEN=$O(^BMCPROV("AD",BMCIEN)) Q:BMCIEN'?1N.N  D
 .S BMCSRIEN="" I BMCIEN=BMC S BMCSRIEN=$P(^XTMP("BMC4IN",BMCJOB,BMCINST),U,4)
 .F  S BMCSRIEN=$O(^BMCPROV("AD",BMCIEN,BMCSRIEN)) Q:BMCSRIEN'?1N.N  D
 ..S BMCCT=BMCCT+1 I BMCCT#100=1 W "."
 ..D V4SADD I $D(^BMCPROV(BMCSRIEN,1)) D V4COM
 ..Q:$D(^XTMP("BMC4IN",BMCJOB,"SEC",BMCSRIEN))
 ..S $P(^XTMP("BMC4IN",BMCJOB,BMCINST),U,3,4)=BMCCT_U_BMCSRIEN
 .S $P(^XTMP("BMC4IN",BMCJOB,BMCINST),U,2)=BMCIEN
 D BMES^XPDUTL("COMPLETED Moving Secondary Referrals.")
 Q
V4SADD ;ADD SEC REF TO RCIS REF FILE
 S X=$P(^BMCPROV(BMCSRIEN,0),U)
 S DLAYGO=90001,DIADD=1,DIC(0)="L",DIC="^BMCREF(" D ^DIC
 I Y=-1 S ^XTMP("BMC4IN",BMCJOB,"SEC",BMCSRIEN)="" Q
 S DIE=DIC,(DA,BMCNEW)=+Y
 F X=1:1:8 S BMC(X)=$P(^BMCPROV(BMCSRIEN,0),U,X)
 F X=1:1:8 S BMC(2_X)=$P(^BMCPROV(BMCSRIEN,2),U,X)
 S BMC(7)=$TR(BMC(7),";",",")
 S BMC(9)=$P(^BMCREF(BMCIEN,0),U,2)
 S BMC(10)=$P(^BMCREF(BMCIEN,0),U,5)
 S DR=".03////"_BMC(2)_";.04////"_BMC(22)_";.06////"_BMC(24)_";.07////"_BMC(5)
 S DR=DR_";.08////"_BMC(8)_";.09////"_BMC(25)_";.11////"_BMC(26)_";.12////"_BMC(27)_";.13////"_BMC(28)
 D ^DIE K DR
 S DR=".14////O;.15////A;.25////"_BMC(4)_";.26////"_BMC(1)
 S DR=DR_";1105////"_BMC(6)_";1111////"_BMC(23)_";1201////"_BMC(7)
 S DR=DR_";.02////"_BMC(9)_";.05////"_BMC(10)_";101////"_BMC(21)_";102////"_BMCIEN
 D ^DIE
 K DIC,DIE,DA,DR,D
 Q
V4COM ;UPDATE COMMENTS FILE WITH SEC REF COMMENTS
 ;Mv Medical HX to the RCIS Comments file, user stamped w/CHS Supervisor
 ;and dt stamped w/install dt ;lv com in Sec Ref and Del later
 ;
 S BMCFAC=$P(^BMCREF(BMCNEW,0),U,5)
 Q:BMCFAC=""
 Q:'$G(BMCMGR(BMCFAC))
 S BMCPAT=$P(^BMCREF(BMCNEW,0),U,3)
 S BMCMGRX=BMCMGR(BMCFAC)
 I $D(^BMCPROV(BMCSRIEN,1)) S BMC2=0 D
 .S BMCTYP="M"
 .S BMCCDT=$P(^BMCPROV(BMCSRIEN,1,0),U,5)
 .I BMCCDT="" S BMCCDT=DT
 .D ADD
 .F  S BMC2=$O(^BMCPROV(BMCSRIEN,1,BMC2)) Q:BMC2'?1N.N  D
 ..S X=^BMCPROV(BMCSRIEN,1,BMC2,0)
 ..S ^BMCCOM(BMCCIEN,1,BMC2,0)=X
 Q
ADD ;ADD ENTRY
 S X=BMCCDT,DLAYGO=90001.03,DIADD=1,DIC(0)="L",DIC="^BMCCOM(" D ^DIC
 S DIE=DIC
 S DR=".02////"_BMCPAT_";.03////"_BMCNEW_";.04////"_BMCMGRX_";.05////"_BMCTYP
 D ^DIE
 S BMCCIEN=DA S ^BMCCOM(BMCCIEN,1,0)=^BMCPROV(BMCSRIEN,1,0)
 S $P(^BMCCOM(BMCCIEN,1,0),U,2)="90001.031"
 K DIC,DIE,DA,DR,D
 Q
V4CLS ;CHANGE "C2" TO "X" CLOSE STATUS   
 Q:$$INSTALL^BMC4P0("BMC 4.0T")  ;Q IF V4.0 INSTALLED
 Q:$$INSTALL^BMC4P0("BMC 4.0")  ;Q IF V4.0 INSTALLED
 D BMES^XPDUTL("Change the close status of referral from 'C2' to 'X'.")
 S BMCINST="SETCLS",BMCCT1=0 D SETVARS
 Q:$P(^XTMP("BMC4IN",BMCJOB,BMCINST),U)="C"
 F  S BMC=$O(^BMCREF(BMC)) Q:BMC'?1N.N  D
 .S BMCCT1=BMCCT1+1 I BMCCT1#1000=1 W "."
 .S $P(^XTMP("BMC4IN",BMCJOB,BMCINST),U,2)=BMC
 .Q:$P(^BMCREF(BMC,0),U,15)'="C2"
 .S DA=BMC,DIE="^BMCREF(",DR=".15////X" D ^DIE
 .S BMCCT=BMCCT+1,$P(^XTMP("BMC4IN",BMCJOB,BMCINST),U,3)=BMCCT
 S $P(^XTMP("BMC4IN",BMCJOB,BMCINST),U)="C"  ;COMPLETED
 D BMES^XPDUTL("Completed changing the close status of referral.")
 Q
 ; -----------------------------------------------------
V4OPT ;REMOVE CHS DENIAL REPORT OPT
 Q:$$INSTALL^BMC4P0("BMC 4.0T")  ;Q IF V4.0 INSTALLED
 Q:$$INSTALL^BMC4P0("BMC 4.0")  ;Q IF V4.0 INSTALLED
 D BMES^XPDUTL("BEGIN Removing CHS Denial report option.")
 ;DOES NOT NEED TO BE REMOVED FROM PARENT OPTION, BECAUSE IT IS NOT SENT
 ;WITH THE BUILD
 S DA=$O(^DIC(19,"B","BMC RPT-CHS DENIED/ACTIVE",0)) I DA S DIK="^DIC(19," D ^DIK
 D MES^XPDUTL("END Removing CHS Denial Report Referral option.")
 Q
 ; -----------------------------------------------------
SETVARS ;EP;SET VARS AND TST IF INSTALL ALREADY STARTED, BUT DID NOT COMPLETE
 I $D(^XTMP("BMC4IN")) S BMCJOB=0,BMCJOB=$O(^XTMP("BMC4IN",BMCJOB))
 I $D(BMCJOB),$D(^XTMP("BMC4IN",BMCJOB,BMCINST)) D
 .S BMC=$P(^XTMP("BMC4IN",BMCJOB,BMCINST),U,2),BMCCT=$P(^(BMCINST),U,3)
 E  S BMCJOB=$J,^XTMP("BMC4IN",BMCJOB,BMCINST)="N^0",(BMC,BMCCT)=0
 Q
 ; -----------------------------------------------------
SETMGR ;SET DEFAULT MANAGER
 S X=0,BMCER=0,XPDQUIT=""
 F  S X=$O(^BMCPARM("B",X)) Q:X'?1N.N  D
 .S BMCMGR(X)=$P(^BMCPARM(X,0),U,13)
 .I BMCMGR(X)'>0 S BMCER=1
 I BMCER=1 W !,"CHS SUPERVISOR is not entered in RCIS SITE PARAMETER FILE, INSTALL ABORTED" S XPDQUIT=2 Q
 Q
 ; -----------------------------------------------------
