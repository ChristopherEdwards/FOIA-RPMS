APCD20P9 ; IHS/CMI/TUCSON - DATA ENTRY PATCH 8 [ 03/11/05  9:09 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**9**;MAR 09, 1999
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("AUPN*99.1*17") D SORRY(2)
 ;
 Q
 ;
PRE ;EP
 F DA=1:1:200 S DIK="^APCDERR(" D ^DIK
 K DA,DIK
 S X=$O(^DIE("B","APCD WC (ADD)",0))
 I X S ^DIE(X,"ROU")=""
 S X=$O(^DIE("B","APCD WC (MOD)",0))
 I X S ^DIE(X,"ROU")=""
 Q
POST ;
 S X=$$ADD^XPDMENU("APCDSUPER","APCD DELETE DUPE PRIM PROV","DDPR")
 I 'X W "Attempt to add DELETE DUPE PRIM PROV option failed." H 3
 S X=$$ADD^XPDMENU("APCDSUPER","APCD OTHER REPORTS","OTH")
 I 'X W "Attempt to add OTHER REPORTS option failed." H 3
 S X=$$ADD^XPDMENU("APCD MENU UTILITIES","APCD GROWTH CHARTS","GC")
 I 'X W "Attempt to add GROWTH CHARTS OPTION option failed." H 3
WCE ;
 D ^XBFMK
 S X=$O(^DIE("B","APCD WC (ADD)",0))
 I X S ^DIE(X,"ROU")="^APCDTWC"
 S X=$O(^DIE("B","APCD WC (MOD)",0))
 I X S ^DIE(X,"ROU")="^APCDTWC"
 I '$D(^APCDTKW("B","WCE")) D
 .S X="WCE",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD WC];.06///Well Child Exam;.07///0;.08///1;.14///9000010.46;.09///9000010.46"
 .K DD,D0,DO
 .D FILE^DICN
 .I Y=-1 W !!,"Adding WCE mnemonic failed." H 4
 I '$D(^APCDTKW("B","AKBP")) D
 .S X="AKBP",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD MEASUREMENT];.05///""AKBP"";.06///Ankle BP;.07///0;.08///1;.09///9000010.01"
 .K DD,D0,DO
 .D FILE^DICN
 .I Y=-1 W !!,"Adding AKBP mnemonic failed." H 4
 I '$D(^APCDTKW("B","RHC")) D
 .S X="RHC",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".02///S;.03///9000010;.04///[APCD RHC];.06///Reproductive History;.07///0;.08///0;.14///9000017;.09///9000017"
 .K DD,D0,DO
 .D FILE^DICN
 .I Y=-1 W !!,"Adding RHC mnemonic failed." H 4
 K DIC,DD,D0,DO
 D ^APCDBUL9
 ;K ^DD(9000022,.04,12),^DD(9000022,.04,12.1)  ;get rid of true input tx
 Q
INSTALLD(APCDSTAL) ;EP - Determine if patch APCDSTAL was installed, where
 ; APCDSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW APCDY,DIC,X,Y
 S X=$P(APCDSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(APCDSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(APCDSTAL,"*",3)
 D ^DIC
 S APCDY=Y
 D IMES
 Q $S(APCDY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_APCDSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
