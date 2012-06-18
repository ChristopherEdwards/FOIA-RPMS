AMH30P7 ; IHS/CMI/LAB - POST INIT BH ;   [ 01/02/05  3:20 PM ]
 ;;3.0;IHS BEHAVIORAL HEALTH;**5,6**;JAN 27, 2003
 ;
ENV ;EP 
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("AMH*3.0*6") D SORRY(2)
 I '$$INSTALLD("AICD*3.51*7") D SORRY(2)
 Q
 ;
PRE ;
 F DA=1:1:250 S DIK="^AMHSORT(" D ^DIK
 F DA=1:1:50 S DIK="^AMHDTER(" D ^DIK
 F DA=1:1:10 S DIK="^AMHRECD(" D ^DIK
 D ^XBFMK
 Q
POST ;EP
 S X=$$ADD^XPDMENU("AMH M MANAGER UTILITIES","AMH M EHRBH PARAMETER EDIT","EHRP")
 I 'X W "Attempt to add EHR PARAMETER EDIT option failed.." H 3
 ;add generic bh hosp 44 entries for each division in MHSS SITE PARAMERTERS file
 S AMHX=0 F  S AMHX=$O(^AMHSITE(AMHX)) Q:AMHX'=+AMHX  D
 .S AMHN="BEHAVIORAL HEALTH (TIU) "_$P(^AUTTLOC(AMHX,0),U,7)
 .Q:$D(^SC("B",AMHN))  ;ALREADY HAVE THIS LOCATION
 .D ^XBFMK
 .K DD,DO,D0
 .S X=AMHN,DIC="^SC(",DIC(0)="L",DIADD=1,DLAYGO=44
 .S DIC("DR")="1////BHTIU;2////Z;2.1///OTHER LOCATION;3////"_AMHX_";3.5////"_AMHX
 .D FILE^DICN
 .I Y=-1 W !,"adding default hospital location entry failed for ",AMHN
 .D ^XBFMK K DIADD,DLAYGO
 .Q
 ;D ^AMH30P7B
 Q
INSTALLD(AMHSTAL) ;EP - Determine if patch AMHSTAL was installed, where
 ; AMHSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
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
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_AMHSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
BULLETIN ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"AMHBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Cimarron Medical Informatics"
 S XMTEXT="^TMP($J,""AMHBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_AMHKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"AMHBUL"),AMHKEY
 Q
 ;
WRITEMSG ;
 S AMHIEN=$O(^AMHPATCH("AA",3,7,0))
 I AMHIEN="" Q
 S AMHX=0,AMHC=0 F  S AMHX=$O(^AMHPATCH(AMHIEN,11,AMHX)) Q:AMHX'=+AMHX  S AMHC=AMHC+1,^TMP($J,"AMHBUL",AMHC)=^AMHPATCH(AMHIEN,11,AMHX,0)
 Q
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,AMHKEY="AMHZMENU"
 F  S CTR=$O(^XUSEC(AMHKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
