AMH40P2 ; IHS/CMI/LAB - POST INIT BH 16 Apr 2009 7:37 AM 01 Aug 2009 5:37 AM ; 13 Apr 2010  3:54 PM
 ;;4.0;IHS BEHAVIORAL HEALTH;**2**;JUN 18, 2010;Build 23
 ;
ENV ;EP 
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I +$$VERSION^XPDUTL("XU")<8 D MES^XPDUTL($$CJ^XLFSTR("Version 8.0 of KERNEL is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Kernel Version 8.0....Present.",80))
 I +$$VERSION^XPDUTL("DI")<22 D MES^XPDUTL($$CJ^XLFSTR("Version 22.0 of FILEMAN is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Fileman v22....Present.",80))
 I $E($$VERSION^XPDUTL("AMH"),1,3)'="4.0" D MES^XPDUTL($$CJ^XLFSTR("Version 4.0 of AMH is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires AMH v4.0....Present.",80))
 I '$$INSTALLD("AMH*4.0*1") D SORRY(2)
 Q
 ;
PRE ;
 S DA=0 F  S DA=$O(^AMHSORT(DA)) Q:DA'=+DA  S DIK="^AMHSORT(" D ^DIK
 S DA=0 F  S DA=$O(^AMHTPCAD(DA)) Q:DA'=+DA  S DIK="^AMHTPCAD(" D ^DIK
 K DA,DIK
 Q
 ;
POST ;EP
 ;add three new codes
 D NEW
 D EDITDSM
 D ICDUP
 D BMXPO
 Q
BMXPO ;-- update the RPC file
 N AMHRPC
 S AMHRPC=$O(^DIC(19,"B","AMHGRPC",0))
 Q:'AMHRPC
 D CLEAN(AMHRPC)
 D GUIEP^BMXPO(.RETVAL,AMHRPC_"|AMH")
 Q
ICDUP ;
 ;INACTIVATE 2 CODES
 S DA=$O(^AMHPROB("B","310.8",0))
 I DA S DIE="^AMHPROB(",DR=".13///1;.14////3111001" D ^DIE K DIE,DA,DR
 S DA=$O(^AMHPROB("B","V40.3",0))
 I DA S DIE="^AMHPROB(",DR=".13///1;.14////3111001" D ^DIE K DIE,DA,DR
 S AMHX=0 F  S AMHX=$O(^AMHPROB("B","290.0",AMHX)) Q:AMHX'=+AMHX  D
 .I $P(^AMHPROB(AMHX,0),U,2)'="DEMENTIA OF THE ALZHEIMER'S TYPE W/LATE ONSET, UNCOMPLICATED" Q
 .Q:$P(^AMHPROB(AMHX,0),U,14)]""
 .S DA=AMHX,DIE="^AMHPROB(",DR=".13////1;.14////3111001" D ^DIE K DA,DIE,DR
 S AMHX=0 F  S AMHX=$O(^AMHPROB("B","294.1",AMHX)) Q:AMHX'=+AMHX  D
 .I $P(^AMHPROB(AMHX,0),U,2)'="DEMENTIA DUE TO..(INDICATE MEDICAL CONDITION)" Q
 .Q:$P(^AMHPROB(AMHX,0),U,14)]""
 .S DA=AMHX,DIE="^AMHPROB(",DR=".13////1;.14////3111001" D ^DIE K DA,DIE,DR
 S AMHX=0 F  S AMHX=$O(^AMHPROB("B","780.93",AMHX)) Q:AMHX'=+AMHX  D
 .I $P(^AMHPROB(AMHX,0),U,2)'="AGE-RELATED COGNITIVE DECLINE" Q
 .Q:$P(^AMHPROB(AMHX,0),U,14)]""
 .S DA=AMHX,DIE="^AMHPROB(",DR=".13////1;.14////3111001" D ^DIE K DA,DIE,DR
 S AMHX=0 F  S AMHX=$O(^AMHPROB("B","V18.4",AMHX)) Q:AMHX'=+AMHX  D
 .I $P(^AMHPROB(AMHX,0),U,2)'="FAMILY HISTORY OF MENTAL RETARDATION" Q
 .Q:$P(^AMHPROB(AMHX,0),U,14)]""
 .S DA=AMHX,DIE="^AMHPROB(",DR=".13////1;.14////3111001" D ^DIE K DA,DIE,DR
 S AMHX=0 F  S AMHX=$O(^AMHPROB("B","V79.2",AMHX)) Q:AMHX'=+AMHX  D
 .I $P(^AMHPROB(AMHX,0),U,2)'="SPECIAL SCREENING FOR MENTAL RETARDATION" Q
 .Q:$P(^AMHPROB(AMHX,0),U,14)]""
 .S DA=AMHX,DIE="^AMHPROB(",DR=".13////1;.14////3111001" D ^DIE K DA,DIE,DR
 ;
 ;ADD NEW CODES
 D NEWICD
 Q
 ;
EDITDSM ;
 S DA=$O(^AMHPROB("B","V71.09",0))
 I DA S DIE="^AMHPROB(",DR=".02///NO DIAGNOSIS ON AXIS I OR NO DIAGNOSIS ON AXIS II" D ^DIE K DIE,DA,DR
 S G=0,DA="" F  S G=$O(^AMHPROB("B","304.10",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,2)="SEDATIVE, HYPNOTIC, OR ANXIOLYTIC DEPENDENCE, UNSPECIFIED" D
 ..S DA=G,DIE="^AMHPROB(",DR=".02///SEDATIVE, HYPNOTIC OR ANXIOLYTIC DEPENDENCE, UNSPECIFIED" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","304.11",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,2)="SEDATIVE, HYPNOTIC, OR ANXIOLYTIC DEPENDENCE, CONTINUOUS" D
 ..S DA=G,DIE="^AMHPROB(",DR=".02///SEDATIVE, HYPNOTIC OR ANXIOLYTIC DEPENDENCE, CONTINUOUS" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","304.12",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,2)="SEDATIVE, HYPNOTIC, OR ANXIOLYTIC DEPENDENCE, EPISODIC" D
 ..S DA=G,DIE="^AMHPROB(",DR=".02///SEDATIVE, HYPNOTIC OR ANXIOLYTIC DEPENDENCE, EPISODIC" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","304.13",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,2)="SEDATIVE, HYPNOTIC, OR ANXIOLYTIC DEPENDENCE, IN REMISSION" D
 ..S DA=G,DIE="^AMHPROB(",DR=".02///SEDATIVE, HYPNOTIC OR ANXIOLYTIC DEPENDENCE, IN REMISSION" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","304.50",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,2)="HALLUCINOGEN DEPENDENCE. UNSPECIFIED" D
 ..S DA=G,DIE="^AMHPROB(",DR=".02///HALLUCINOGEN DEPENDENCE, UNSPECIFIED" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","304.61",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,15)=1 D
 ..S DA=G,DIE="^AMHPROB(",DR=".15///@" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","304.62",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,15)=1 D
 ..S DA=G,DIE="^AMHPROB(",DR=".15///@" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","304.63",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,15)=1 D
 ..S DA=G,DIE="^AMHPROB(",DR=".15///@" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","304.80",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,2)="POLYSUBSTANCE DEPENDENCE, UNSPECIFIED" D
 ..S DA=G,DIE="^AMHPROB(",DR=".13///1;.14///"_DT_";.15///@" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","291.5",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,2)="ALCOHOL-INDUCED PSYCHOTIC DISORDER, W/DELUSIONS" D
 ..S DA=G,DIE="^AMHPROB(",DR=".02///ALCOHOL-INDUCED PSYCHOTIC DISORDER, WITH DELUSIONS" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","291.3",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,2)="ALCOHOL-INDUCED PSYCHOTIC DISORDER, W/HALLUCINATIONS" D
 ..S DA=G,DIE="^AMHPROB(",DR=".02///ALCOHOL-INDUCED PSYCHOTIC DISORDER, WITH HALLUCINATIONS" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","305.02",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,2)="ALCOHOL ABUSE, EPISODIC," D
 ..S DA=G,DIE="^AMHPROB(",DR=".02///ALCOHOL ABUSE, EPISODIC" D ^DIE
 S G=0,DA="" F  S G=$O(^AMHPROB("B","304.60",G)) Q:G'=+G  D
 .I $P(^AMHPROB(G,0),U,15)=1 D
 ..S DA=G,DIE="^AMHPROB(",DR=".15///@" D ^DIE
 K DA,DIE,DR
 S AMHX=0 F  S AMHX=$O(^AMHTPCAD(AMHX)) Q:AMHX'=+AMHX  D
 .S AMH0=^AMHTPCAD(AMHX,0)
 .S AMHCODE=$P(AMH0,U,1)
 .S AMHNARR=$P(AMH0,U,2)
 .S AMHPCODE=$P(AMH0,U,3) S AMHPCODE=$O(^AMHPROBC("B",AMHPCODE,0))
 .S AMHICD=$P(AMH0,U,5)
 .S AMHAXIS=$P(AMH0,U,6)
 .S AMHINA=$P(AMH0,U,13)
 .S AMHEHR=$P(AMH0,U,15)
 .;lookup up code, if exist do edit, if not, do add
 .S G=0,AMHDSM="" F  S G=$O(^AMHPROB("B",AMHCODE,G)) Q:G'=+G!(AMHDSM)  D
 ..I $P(^AMHPROB(G,0),U,2)=AMHNARR S AMHDSM=G
 .I AMHDSM D EDIT Q
 .;add code and edit
 .K D0,DO
 .S DIC="^AMHPROB(",DIADD=1,DLAYGO=9002012.2,DIC(0)="L",X=AMHCODE D FILE^DICN
 .I Y=-1 D MES^XPDUTL("Failure to add code "_AMHCODE_" "_AMHNARR) Q
 .K DIADD,DLAYGO,DIC
 .S AMHDSM=+Y
 .D EDIT
 Q
EDIT ;
 S DA=AMHDSM,DIE="^AMHPROB("
 S DR=".02///"_AMHNARR_";.03////"_AMHPCODE_";.05///"_AMHICD_";.06///I;.15///"_AMHEHR
 D ^DIE
 I $D(Y) D MES^XPDUTL("Failure to update code "_AMHCODE_" "_AMHNARR)
 K DA,DIE,DR
 Q
INSTALLD(AMHSTAL) ;EP - Determine if patch AMHSTAL was installed, where
 ; APCLSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW AMHY,DIC,X,Y
 S X=$P(AMHSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(AMHSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(AMHSTAL,"*",3)
 D ^DIC
 S AMHY=Y
 D IMES
 Q $S(AMHY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_AMHSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" Present.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
MM3 ;BULLETIN;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"AMHBUL")
 D WRITEMS3,GETREC3
 ;Change following lines as desired
SUBJECT3 S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER3 S XMDUZ="IHS Behavioral Health"
 S XMTEXT="^TMP($J,""AMHBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_AMHKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"AMHBUL"),AMHKEY
 Q
 ;
WRITEMS3 ;
 S AMHIEN=$O(^AMHPATCH("AA",4,99,0))
 I AMHIEN="" Q
 S AMHX=0,AMHC=0 F  S AMHX=$O(^AMHPATCH(AMHIEN,11,AMHX)) Q:AMHX'=+AMHX  S AMHC=AMHC+1,^TMP($J,"AMHBUL",AMHC)=^AMHPATCH(AMHIEN,11,AMHX,0)
 S AMHC=AMHC+1,^TMP($J,"AMHBUL",AMHC)=" "
 S AMHC=AMHC+1,^TMP($J,"AMHBUL",AMHC)="The following users had their PCC link type changed"
 S AMHC=AMHC+1,^TMP($J,"AMHBUL",AMHC)="from Link type 3 to Link type 5.  This is under the"
 S AMHC=AMHC+1,^TMP($J,"AMHBUL",AMHC)="list of users who have a PCC Link exception entered"
 S AMHC=AMHC+1,^TMP($J,"AMHBUL",AMHC)="in the Site Parameter file."
 S AMHC=AMHC+1,^TMP($J,"AMHBUL",AMHC)=AMHNMM
 Q
GETREC3 ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,AMHKEY="AMHZMGR"
 F  S CTR=$O(^XUSEC(AMHKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
 ;
CLEAN(APP) ;-- clean out the RPC multiple first
 S DA(1)=APP
 S DIK="^DIC(19,"_DA(1)_","_"""RPC"""_","
 N AMHDA
 S AMHDA=0 F  S AMHDA=$O(^DIC(19,APP,"RPC",AMHDA)) Q:'AMHDA  D
 . S DA=AMHDA
 . D ^DIK
 K ^DIC(19,APP,"RPC","B")
 Q
 ;
NEW ;add new codes
 ;
 ;add new codes if they don't exist
 S AMH1II="",AMH1I=""
 S AMH1X=0 F  S AMH1X=$O(^AMHPROB("B","V71.09",AMH1X)) Q:AMH1X'=+AMH1X  D
 .I $P(^AMHPROB(AMH1X,0),U,2)="NO DIAGNOSIS ON AXIS II" S AMH1II=1
 .I $P(^AMHPROB(AMH1X,0),U,2)="NO DIAGNOSIS ON AXIS I" S AMH1I=1
 I 'AMH1II D
 .S X="V71.09",DIC("DR")=".02///NO DIAGNOSIS ON AXIS II;.03///38;.05///V71.09"
 .S DIC="^AMHPROB(",DLAYGO=9001012.2,DIADD=1
 .S DIC(0)="L"
 .K DD,D0,DO D FILE^DICN K DIADD,DLAYGO,DD,DIC,D0,DO
 .I Y=-1 D MES^XPDUTL("Code "_AMHCODE_" could not be added.") Q
 .Q
 I 'AMH1I D
 .S X="V71.09",DIC("DR")=".02///NO DIAGNOSIS ON AXIS I;.03///38;.05///V71.09"
 .S DIC="^AMHPROB(",DLAYGO=9001012.2,DIADD=1
 .S DIC(0)="L"
 .K DD,D0,DO D FILE^DICN K DIADD,DLAYGO,DD,DIC,D0,DO
 .I Y=-1 D MES^XPDUTL("Code "_AMHCODE_" could not be added.") Q
 .Q
 S AMH1X=0 F  S AMH1X=$O(^AMHPROB("B","V71.09",AMH1X)) Q:AMH1X'=+AMH1X  D
 .Q:$P(^AMHPROB(AMH1X,0),U,2)'="OBSERVATION OF OTHER SUSPECTED MENTAL CONDITION"
 .S DA=AMH1X,DIE="^AMHPROB(",DR=".15///1" D ^DIE K DA,DR,DIE
 Q
NEWICD ;add new codes
 ;
 ;add new codes if they don't exist
 S AMHTEXT="ICDNEW" F AMHY=1:1 S AMHTX=$P($T(@AMHTEXT+AMHY),";;",2,4) Q:AMHTX=""  D
 .S (X,AMHCODE)=$P(AMHTX,";;",1),C=$P(AMHTX,";;",2)
 .S AMHPC=$O(^AMHPROBC("B",C,0))
 .I AMHPC="" D MES^XPDUTL("Problem code: "_$P(AMHTX,";;",2)_" does not exist")
 .S AMHINA=$P(AMHTX,";;",3)
 .S (G,AMHX)=0 F  S AMHX=$O(^AMHPROB("B",AMHCODE,AMHX)) Q:AMHX'=+AMHX  D
 ..;CHECK NARRATIVE
 ..I $P(^AMHPROB(AMHX,0),U,2)=AMHINA S G=1
 ..Q
 .Q:G  ;already have this code
 .S DIC="^AMHPROB(",DLAYGO=9001012.2,DIADD=1,DIC="^AMHPROB("
 .S DIC(0)="L"
 .K DD,D0,DO D FILE^DICN K DIADD,DLAYGO,DD,DIC,D0,DO
 .I Y=-1 D MES^XPDUTL("Code "_AMHCODE_" could not be added.") Q
 .S DA=+Y
NEWE .;
 .S DIE="^AMHPROB("
 .S DR=".02////"_AMHINA_";.03////"_AMHPC_";.05////"_AMHCODE_";.16////3111001"
 .D ^DIE K DIE,DA,DR
 .I $D(Y) D MES^XPDUTL("Error updating code "_AMHCODE_".") Q
 Q
ICDNEW ;;
 ;;290.0;;9.2;;SENILE DEMENTIA UNCOMP;;290.0
 ;;294.20;;12;;DEMEN NOS W/O BEHV DSTRB;;294.20
 ;;294.21;;12;;DEMEN NOS W BEHAV DISTRB;;294.21
 ;;310.2;;12;;POSTCONCUSSION SYNDROME;;310.2
 ;;310.81;;12;;PSEUDOBULBAR AFFECT;;310.81
 ;;310.89;;12;;NONPSYCH MNTL DISORD NEC;;310.89
 ;;780.93;;9;;MEMORY LOSS;;780.93
 ;;V18.4;;35;;FM FX-INTELLECT DISBLTY;;V18.4
 ;;V40.39;;38;;OTH SPC BEHAVIOR PROBLEM;;V40.39
 ;;V79.2;;35;;SCRN INTELLECT DISABILTY;;V79.2
 ;;
 ;;
