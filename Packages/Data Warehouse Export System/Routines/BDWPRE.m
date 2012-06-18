BDWPRE ; IHS/CMI/LAB - PRE/POST INIT ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("AVA*93.2*18") D SORRY(2)
 I '$$INSTALLD("AUPN*99.1*14") D SORRY(2)
 ;I '$$INSTALLD("APCL*3.0*16") D SORRY(2)
 ;I '$$INSTALLD("ATX*5.1*6") D SORRY(2)
 I '$$INSTALLD("XB*3.0*10") D SORRY(2)
 I '$$INSTALLD("AUM*5.1*8") D SORRY(2)
 I '$$INSTALLD("GIS*3.01*11") D SORRY(2)
 Q
 ;
PRE ;EP - pre init
 ;clean up old BDW stuff.
 ;delete 90210 and data
 D BMES^XPDUTL("Beginning Pre-install routine (PRE^BDWPRE).")
 D MES^XPDUTL("hold on....removing old data warehouse export file....be patient")
 S DIU=90213,DIU(0)="" D EN^DIU2
 S DIU=90214,DIU(0)="" D EN^DIU2
 S DIU=90210,DIU(0)="DT" D EN^DIU2
 S DIU=90211,DIU(0)="DT" D EN^DIU2
 S DIU=90219,DIU(0)="DT" D EN^DIU2
 D MES^XPDUTL("killing old ADW xref on Visit file....please be patient...")
 K ^AUPNVSIT("ADW")
 D MES^XPDUTL("Deleting dd fields....")
 NEW DIK
 ;
 ;delete ADWO if this is first time install
 I $P($G(^BDWSITE(1,0)),U,2)="" K ^AUPNVSIT("ADWO")
 D MES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP - post init to set up site file
 I $P($G(^BDWSITE(1,0)),U,2)="" D
 .S DA=1,DIK="^BDWSITE(" D ^DIK  ;delete old site file
 .S ^BDWSITE(1,0)=$P(^AUTTSITE(1,0),U),^BDWSITE("B",$P(^AUTTSITE(1,0),U),1)="",$P(^BDWSITE(0),U,3)=1,$P(^BDWSITE(0),U,4)=1,$P(^BDWSITE(1,0),U,2)=DT
 .S DA=1,DIK="^BDWSITE(" D IX1^DIK
 .K ^AUPNVSIT("ADWO")  ;only on first install
CNT .;count # of visits since 10/1/00
 .D MES^XPDUTL("Counting the number of visits for backloading.  This may take awhile.")
 .D MES^XPDUTL("Please be patient.")
 .S (C,X)=0,D=3001001 F  S D=$O(^AUPNVSIT("B",D)) Q:D'=+D!($P(D,".")>$P(^BDWSITE(1,0),U,2))  D
 ..S V=0 F  S V=$O(^AUPNVSIT("B",D,V)) Q:V'=+V  D
 ...Q:'$D(^AUPNVSIT(V,0))  ;no 0 node
 ...Q:$P(^AUPNVSIT(V,0),U,11)
 ...Q:'$P(^AUPNVSIT(V,0),U,9)
 ...;Q:$P(^AUPNVSIT(V,0),U,23)=.5  ;no MFI created visits
 ...S X=$P(^AUPNVSIT(V,0),U,6)
 ...I 'X Q
 ...S X=$P($G(^AUTTLOC(X,0)),U,10) I $E(X,1)=3,$P(^AUPNVSIT(V,0),U,23)=.5 Q
 ...S C=C+1
 ...I '(C#10000),'$D(ZTQUEUED) W ".",C
 ..Q
 .S $P(^BDWSITE(1,0),U,5)=C
LAB ;
 S BDWX="BDW PAP SMEAR LAB TESTS" D LAB1
 S BDWX="BDW PSA TESTS TAX" D LAB1
ZISH ;create entry in ZISH SEND PARAMETERS file
 D ^XBFMK K DIADD,DLAYGO,DIC,DD,D0,DO
 S BDWY=0 F  S BDWY=$O(^%ZIB(9888888.93,"B","DATA WAREHOUSE SEND",0)) Q:BDWY'=+BDWY  D
 .I BDWY S DA=BDWY,DIK="^%ZIB(9888888.93," D ^DIK K DA,DIK
 S X="DATA WAREHOUSE SEND",DIC(0)="L",DIC="^%ZIB(9888888.93," D FILE^DICN
 I Y=-1 W !!,"error creating ZISH SEND PARAMETERS entry" Q
 S DA=+Y,DIE="^%ZIB(9888888.93,",DR=".02///QUOVADX-IE.DOMAIN.NAME;.03///dwxfer;.04///regpcc;.06///-u;.07///B;.08///sendto"
 D ^DIE
 I $D(Y) W !!,"error updating ZISH SEND PARAMETERS entry" Q
 ;D ^XBFMK K DIADD,DLAYGO,DIC,DD,D0,DO
 ;S BDWY=$O(^%ZIB(9888888.93,"B","DATA WAREHOUSE SEND UNIX",0))
 ;I BDWY S DA=BDWY,DIK="^%ZIB(9888888.93," D ^DIK K DA,DIK
 ;S X="DATA WAREHOUSE SEND UNIX",DIC(0)="L",DIC="^%ZIB(9888888.93," D FILE^DICN
 ;I Y=-1 W !!,"error creating ZISH SEND PARAMETERS UNIX entry" Q
 ;S DA=+Y,DIE="^%ZIB(9888888.93,",DR=".02///QUOVADX-IE.DOMAIN.NAME;.03///dwxfer;.04///regpcc;.06///-u;.07///B;.08///sendto1"
 ;D ^DIE
 ;I $D(Y) W !!,"error updating ZISH SEND PARAMETERS entry" Q
 D ^XBFMK
 Q
LAB1 ;
 W !,"Creating ",BDWX," Taxonomy..."
 S BDWDA=$O(^ATXLAB("B",BDWX,0))
 Q:BDWDA  ;taxonomy already exisits
 S X=BDWX,DIC="^ATXLAB(",DIC(0)="L",DIADD=1,DLAYGO=9002228 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING ",BDWX," TAX" Q
 S BDWTX=+Y,$P(^ATXLAB(BDWTX,0),U,2)=BDWX,$P(^(0),U,5)=DUZ,$P(^(0),U,6)=DT,$P(^(0),U,8)="B",$P(^(0),U,9)=60,^ATXLAB(BDWTX,21,0)="^9002228.02101PA^0^0"
 S DA=BDWTX,DIK="^ATXAX(" D IX1^DIK
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
INSTALLD(AUPNSTAL) ;EP - Determine if patch AUPNSTAL was installed, where
 ; AUPNSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW AUPNY,DIC,X,Y
 S X=$P(AUPNSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(AUPNSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(AUPNSTAL,"*",3)
 D ^DIC
 S AUPNY=Y
 D IMES
 Q $S(AUPNY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_AUPNSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
 ;
