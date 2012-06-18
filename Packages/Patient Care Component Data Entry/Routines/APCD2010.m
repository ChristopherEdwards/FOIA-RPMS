APCD2010 ; IHS/CMI/TUCSON - DATA ENTRY PATCH 10 [ 03/11/05  9:09 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**10**;MAR 09, 1999
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("AUPN*99.1*18") D SORRY(2)
 I '$$INSTALLD("APCD*2.0*9") D SORRY(2)
 I '$$INSTALLD("AICD*3.51*7") D SORRY(2)
 I '$D(^DIC(9.4,"C","LEX")) D MES^XPDUTL($$CJ^XLFSTR("Lexicon is *NOT* installed.",IOM)) D SORRY(2)
 ;
 Q
 ;
PRE ;EP
 F DA=1:1:200 S DIK="^APCDERR(" D ^DIK
 K DA,DIK
 F DA=1:1:200 S DIK="^APCDINPT(" D ^DIK
 K DA,DIK
 S X=$O(^DIE("B","APCD WC (ADD)",0))
 I X S ^DIE(X,"ROU")=""
 S X=$O(^DIE("B","APCD WC (MOD)",0))
 I X S ^DIE(X,"ROU")=""
EDUC ;
 ;EDUCATION TOPICS CHANGES PER CHRIS SADDLER
 S DA=$O(^APCDEDCV("C","L",0)) I DA S DIE="^APCDEDCV(",DR=".01///LITERATURE" D ^DIE
 K DA,DIE,DR
 S DA=$O(^APCDEDCV("C","TE",0)) I DA S DIE="^APCDEDCV(",DR=".01///TESTS" D ^DIE
 K DA,DR,DIE
 Q
POST ;
 ;
WCE ;
 D ^XBFMK
 I '$D(^APCDTKW("B","CRFT")) D
 .S X="CRFT",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD MEASUREMENT];.05///""CRFT"";.06///CRAFFT;.07///0;.08///1;.09///9000010.01"
 .K DD,D0,DO
 .D FILE^DICN
 .I Y=-1 W !!,"Adding CRFT mnemonic failed." H 4
 I '$D(^APCDTKW("B","AUDT")) D
 .S X="AUDT",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD MEASUREMENT];.05///""AUDT"";.06///AUDIT;.07///0;.08///1;.09///9000010.01"
 .K DD,D0,DO
 .D FILE^DICN
 .I Y=-1 W !!,"Adding AUDT mnemonic failed." H 4
  I '$D(^APCDTKW("B","PHQ2")) D
 .S X="PHQ2",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD MEASUREMENT];.05///""PHQ2"";.06///PHQ2;.07///0;.08///1;.09///9000010.01"
 .K DD,D0,DO
 .D FILE^DICN
 .I Y=-1 W !!,"Adding PHQ2 mnemonic failed." H 4
  I '$D(^APCDTKW("B","PHQ9")) D
 .S X="PHQ9",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD MEASUREMENT];.05///""PHQ9"";.06///PHQ9;.07///0;.08///1;.09///9000010.01"
 .K DD,D0,DO
 .D FILE^DICN
 .I Y=-1 W !!,"Adding PHQ2 mnemonic failed." H 4
 I '$D(^APCDTKW("B","HCPT")) D
 .S X="HCPT",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD HCPT];.06///Historical CPT;.07///0;.08///0;.09///9000010.18;.15///71;.16///71"
 .K DD,D0,DO
 .D FILE^DICN
 .I Y=-1 W !!,"Adding HCPT mnemonic failed." H 4
 K DIC,DD,D0,DO
 S X=$O(^DIE("B","APCD WC (ADD)",0))
 I X S ^DIE(X,"ROU")="^APCDTWC"
 S X=$O(^DIE("B","APCD WC (MOD)",0))
 I X S ^DIE(X,"ROU")="^APCDTWC"
 ;
 D ^APCDBUL0
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
