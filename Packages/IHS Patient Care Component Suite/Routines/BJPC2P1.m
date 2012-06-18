BJPC2P1 ; IHS/CMI/LAB - PCC Suite v1.0 patch 1 environment check ;   
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("APCL*3.0*24") D SORRY(2)
 I $$VERSION^XPDUTL("BJPC")'="2.0" D SORRY(2)
 ;
 Q
 ;
PRE ;
 S BJPCDA=0 F  S BJPCDA=$O(^APCLVSTS(BJPCDA)) Q:BJPCDA'=+BJPCDA  S DA=BJPCDA,DIK="^APCLVSTS(" D ^DIK
 S BJPCDA=0 F  S BJPCDA=$O(^APCDTHFD(BJPCDA)) Q:BJPCDA'=+BJPCDA  S DA=BJPCDA,DIK="^APCDTHFD(" D ^DIK
 ;delete v telehealth and v nutr screening
 S DIU(0)="",DIU=9000010.48 D EN^DIU2
 S DIU(0)="",DIU=9000010.49 D EN^DIU2
 K DIU
 K ^APCHTMP("HMR STATUS")
 S X=0 F  S X=$O(^APCHSURV(X)) Q:X'=+X  S ^APCHTMP("HMR STATUS",X)=$P(^APCHSURV(X,0),U)_U_$P(^APCHSURV(X,0),U,3)
 ;change name of medications pwh component
 S DA=$O(^APCHPWHC("B","MEDICATIONS",0))
 I DA S DIE="^APCHPWHC(",DR=".01///MEDICATIONS (ACTIVE AND RECENTLY EXPIRED)" D ^DIE K DA,DIE,DR
 D PRE^AMQQPOST
 Q
POST ;
OPTIONS ;
HMRSTAT ;
 ;rename optiom
 S DA=$O(^DIC(19,"B","APCL P PATLIST DP-W/ V COUNTS",0))
 I DA S DIE="^DIC(19,",DR="1///Pts by Designated Primary Care Prov w/Visit Counts" D ^DIE K DA,DIE,DR
 ;PUT STATUS BACK IN
 S DA=$O(^DIC(19,"B","APCL P PATLIST DESIG PROV",0))
 I DA S DIE="^DIC(19,",DR="1///Patient Listing by Designated Primary Care Prov" D ^DIE K DA,DIE,DR
 S APCHX=0 F  S APCHX=$O(^APCHTMP("HMR STATUS",APCHX)) Q:APCHX'=+APCHX  D
 .S X=$P(^APCHTMP("HMR STATUS",APCHX),U),APCHS=$P(^APCHTMP("HMR STATUS",APCHX),U,2)  ;,DIC="^APCHSURV(",DIC(0)="M" D ^DIC
 .;I Y=-1 W !!,"could not update status on ",X," hmr" Q
 .Q:'$D(^APCHSURV(APCHX,0))
 .I $P(^APCHSURV(APCHX,0),U,3)'="D" S $P(^APCHSURV(APCHX,0),U,3)=APCHS
 K ^APCHTMP("HMR STATUS")
 S X=$$ADD^XPDMENU("APCD MENU ENTER DATA","APCD RESEQUENCE POVS","RSPV")
 I 'X W "Attempt to add APCD RESEQUENCE POVS option failed.." H 3
 S X=$$ADD^XPDMENU("APCD UPD PAT RELATED DATA","APCD TREATMENT PLAN","TP")
 I 'X W "Attempt to add APCD TREATMENT PLAN option failed.." H 3
 S X=$$ADD^XPDMENU("APCH MENU HEALTH MAINTENANCE","APCH LIST HMRS","LHMR")
 I 'X W "Attempt to add APCH LIST HMRS option failed.." H 3
 S X=$$ADD^XPDMENU("APCDCAF EHR CODING AUDIT MENU","APCDCAF AUTO COMPLETE/CLINIC","ACCL")
 I 'X W "Attempt to add AUTO COMPLETE BY CLINIC option failed.." H 3
 S X=$$ADD^XPDMENU("APCDCAF EHR CODING AUDIT MENU","APCDCAF NOT REVIEWED IN N DAYS","VNR")
 I 'X W "Attempt to add APCDCAF NOT REVIEWED IN N DAYS option failed.." H 3
 S X=$$ADD^XPDMENU("APCD PRINT MENU","APCD PROVIDER LISTING","PRVL",1)
 I 'X W "Attempt to add APCD PROVIDER LISTING option failed.." H 3
 S X=$$ADD^XPDMENU("APCL M MAN QUALITY ASSURANCE","APCL ANTICOAG REPORT","AC",1)
 I 'X W "Attempt to add ANTI COAG REPORT option failed.." H 3
 ;
ASMSMP ;
 D MES^XPDUTL($$CJ^XLFSTR("Copying Asthma Management Plan to V Patient Education.",IOM))
 S X=0,BJPCIEN="" F  S X=$O(^AUTTEDT("C","ASM-SMP",X)) Q:X'=+X!(BJPCIEN)  D
 .Q:'$D(^AUTTEDT(X,0))
 .Q:$P(^AUTTEDT(X,0),U,3)
 .S BJPCIEN=X
 I 'BJPCIEN D MES^XPDUTL($$CJ^XLFSTR("ASM-SMP education topic missing from file, cannot move data.",IOM)) G HF
 S BJPCX=0 F  S BJPCX=$O(^AUPNVAST(BJPCX)) Q:BJPCX'=+BJPCX  D
 .Q:$P($G(^AUPNVAST(BJPCX,0)),U,12)=""  ;no asthma management plan to copy
 .Q:$P($G(^AUPNVAST(BJPCX,0)),U,12)'=1
 .Q:$$HASASAMP($P(^AUPNVAST(BJPCX,0),U,3),BJPCIEN)
 .K APCDALVR
 .S APCDALVR("APCDVSIT")=$P(^AUPNVAST(BJPCX,0),U,3)
 .S APCDALVR("APCDATMP")="[APCDALVR 9000010.16 (ADD)]"
 .S APCDALVR("APCDTTOP")="`"_BJPCIEN
 .S APCDALVR("APCDPAT")=$P(^AUPNVAST(BJPCX,0),U,2)
 .D ^APCDALVR
 .I $D(APCDALVR("APCDAFLG")) D MES^XPDUTL($$CJ^XLFSTR("Patient ed ASM-SMP failed for Visit "_$P(^AUPNVAST(BJPCX,0),U,3),IOM))
 .K APCDALVR
HF ;
 ;inactivate NON-TOBACCO USER
 S DA=$O(^AUTTHF("B","NON-TOBACCO USER",0)) I DA S DIE="^AUTTHF(",DR=".13////1;.15////"_DT D ^DIE K DA,DIE,DR
 S DA=$O(^AUTTHF("B","READINESS TO LEARN",0)) I DA S DIE="^AUTTHF(",DR=".13////1;.15////"_DT D ^DIE K DA,DIE,DR
 S DA=$O(^AUTTHF("B","STAGED DIABETES MANAGEMENT",0)) I DA S DIE="^AUTTHF(",DR=".13////1;.15////"_DT D ^DIE K DA,DIE,DR
 D ^BJPC2EVH
 ;add new ones
 D ^BJPC2EV2  ;update problem list classification from latest v asthma stage
 D ^BJPCPT
 D LABTAX
 D POST^AMQQPOST
 ;reindex AA, AAC on V Asthma
 S DIK="^AUPNVAST(",DIK(1)=".14^AAC" D ENALL^DIK
 S DIK="^AUPNVAST(",DIK(1)=".03^AA" D ENALL^DIK
 K DIK
 ;change DP and PCP in mnemonics
 S DA=$O(^APCDTKW("B","DP",0))
 I DA S DIE="^APCDTKW(",DR=".06///Designated Primary Care Prov"_";.12///Designated PCP" D ^DIE K DA,DIE,DR
 S DA=$O(^APCDTKW("B","PCP",0))
 I DA S DIE="^APCDTKW(",DR=".06///Designated Primary Care Prov"_";.12///Designated PCP" D ^DIE K DA,DIE,DR
 ;
 Q
WRITEMSG ;
 S X=$O(^APCLPDES("B","BJPCV2P1",0))
 Q:'X
 S Y=0 F  S Y=$O(^APCLPDES(X,11,Y)) Q:Y'=+Y  S ^TMP($J,"BJPCBUL",Y)=^APCLPDES(X,11,Y,0)
 Q
 ;
GETRECIP ;
 ;
 S CTR=0
 F BJPCKEY="APCLZMENU","APCDZMENU","APCHZMENU","BDPZMENU","AMQQZMENU"
 F  S CTR=$O(^XUSEC(BJPCKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
INSTALLD(BJPCSTAL) ;EP - Determine if patch BJPCSTAL was installed, where
 ; APCLSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BJPCY,DIC,X,Y
 S X=$P(BJPCSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BJPCSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BJPCSTAL,"*",3)
 D ^DIC
 S BJPCY=Y
 D IMES
 Q $S(BJPCY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BJPCSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
HASASAMP(V,I) ;is there a v patient ed of ASM-SMP?
 NEW X,Y,Z
 S (X,Z)=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  D
 .I $P($G(^AUPNVPED(X,0)),U)=I S Z=1
 .Q
 Q Z
LABTAX ;
 S BJPCX="BJPC INR LAB TESTS",BJPCPG="APCH;BJPC;APCL",BJPCAP=0 D LAB1
 Q
 ;
LAB1 ;
 S BJPCDA=$O(^ATXLAB("B",BJPCX,0))
 I BJPCDA G UP41   ;taxonomy already exists
 W !,"Creating ",BJPCX," Taxonomy..."
 S X=BJPCX,DIC="^ATXLAB(",DIC(0)="L",DIADD=1,DLAYGO=9002228 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING ",BJPCX," TAX" Q
 S BJPCDA=+Y,$P(^ATXLAB(BJPCDA,0),U,2)=BJPCX,$P(^(0),U,5)=DUZ,$P(^(0),U,6)=DT,$P(^(0),U,8)="B",$P(^(0),U,9)=60,$P(^(0),U,22)=0,$P(^(0),U,4)="n",$P(^(0),U,11)=BJPCAP
 S ^ATXLAB(BJPCDA,21,0)="^9002228.02101PA^0^0"
 S DA=BJPCDA,DIK="^ATXAX(" D IX1^DIK
UP41 ;
 F BJPCI=1:1 S BJPCPI=$P(BJPCPG,",",BJPCI) Q:BJPCPI=""  D
 .S BJPCPI=$O(^DIC(9.4,"C","BJPC",0))
 .Q:BJPCPI=""  ;NO PACKAGE
 .Q:$D(^ATXLAB(BJPCDA,41,"B",BJPCPI))
 .S X="`"_BJPCPI,DIC="^ATXLAB("_BJPCDA_",41,",DIC(0)="L",DIC("P")=$P(^DD(9002228,4101,0),U,2),DA(1)=BJPCDA
 .D ^DIC
 .I Y=-1 W !,"updating package multiple for ",BJPCPI," entry ",$P(^ATXAX(BJPCDA,0),U)," failed"
 .K DIC,DA,Y,X
 Q
