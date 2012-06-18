AMH40P1 ; IHS/CMI/LAB - POST INIT BH 16 Apr 2009 7:37 AM 01 Aug 2009 5:37 AM ; 13 Apr 2010  3:54 PM
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
ENV ;EP 
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I +$$VERSION^XPDUTL("XU")<8 D MES^XPDUTL($$CJ^XLFSTR("Version 8.0 of KERNEL is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Kernel Version 8.0....Present.",80))
 I +$$VERSION^XPDUTL("DI")<22 D MES^XPDUTL($$CJ^XLFSTR("Version 22.0 of FILEMAN is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Fileman v22....Present.",80))
 I $E($$VERSION^XPDUTL("AMH"),1,3)'="4.0" D MES^XPDUTL($$CJ^XLFSTR("Version 4.0 of AMH is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires AMH v4.0....Present.",80))
 Q
 ;
PRE ;
 S DA=0 F  S DA=$O(^AMHSORT(DA)) Q:DA'=+DA  S DIK="^AMHSORT(" D ^DIK
 S DA=0 F  S DA=$O(^AMHBHPC(DA)) Q:DA'=+DA  S DIK="^AMHBHPC(" D ^DIK
 K DIK,DA
 S DA=$O(^AMHTSET("B","TELE-MENTAL HEALTH",0))
 I DA S DIE="^AMHTSET(",DR=".01///TELE-BEHAVIORAL HEALTH;.04///TBH" D ^DIE K DIE,DA,DR
 Q
 ;
POST ;EP
 ;add three new codes
 D NEW
 S DIK="^AMHPSUIC(",DIK(1)=".06^AB" D ENALL^DIK
 K DIK
 S AMHX=0,AMHNMM="" F  S AMHX=$O(^AMHSITE(AMHX)) Q:AMHX'=+AMHX  D
 .S AMHY=0 F  S AMHY=$O(^AMHSITE(AMHX,11,AMHY)) Q:AMHY'=+AMHY  D
 ..Q:$P(^AMHSITE(AMHX,11,AMHY,0),U,2)'=3
 ..S $P(^AMHSITE(AMHX,11,AMHY,0),U,2)=5,AMHNMM=AMHNMM_$S(AMHNMM]"":"; ",1:"")_$P($G(^DIC(4,AMHX,0)),U)
 I AMHNMM]"" D MM3
 D BMXPO
 Q
BMXPO ;-- update the RPC file
 D GUIEP^BMXPO(.RETVAL,"AMHGRPC|AMH")
 Q
 ;
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
NEW ;add new codes
 ;
 ;add new codes if they don't exist
 S AMHTEXT="ICDNEW" F AMHX=1:1 S AMHTX=$P($T(@AMHTEXT+AMHX),";;",2,4) Q:AMHTX=""  D
 .S (X,AMHCODE)=$P(AMHTX,";;",1),C=$P(AMHTX,";;",2)
 .S AMHPC=$O(^AMHPROBC("B",C,0))
 .I AMHPC="" D MES^XPDUTL("Problem code: "_$P(AMHTX,";;",2)_" does not exist")
 .S AMHINA=$P(AMHTX,";;",3)
 .S DA=$O(^AMHPROB("B",X,0)) I DA Q
 .S DIC="^AMHPROB(",DLAYGO=9001012.2,DIADD=1,DIC="^AMHPROB("
 .S DIC(0)="L"
 .K DD,D0,DO D FILE^DICN K DIADD,DLAYGO,DD,DIC,D0,DO
 .I Y=-1 D MES^XPDUTL("Code "_AMHCODE_" could not be added.") Q
 .S DA=+Y
NEWE .;
 .S DIE="^AMHPROB("
 .S DR=".02////"_AMHINA_";.03////"_AMHPC_";.05////"_AMHCODE
 .D ^DIE K DIE,DA,DR
 .I $D(Y) D MES^XPDUTL("Error updating code "_AMHCODE_".") Q
 Q
ICDNEW ;;
 ;;315.35;;31;;CHILDHOOD ONSET FLUENCY DISORDER
 ;;V11.4;;38;;PERSONAL HISTORY OF COMBAT AND OPERATIONAL STRESS REACTION
 ;;V62.85;;38;;HOMICIDAL IDEATION
 ;;
