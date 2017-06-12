BJPC2PMU ; IHS/CMI/LAB - PCC Suite v2.0 patch 10 environment check ;   
 ;;2.0;IHS PCC SUITE;**10**;MAY 14, 2009;Build 88
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;KERNEL
 I +$$VERSION^XPDUTL("XU")<8 D MES^XPDUTL($$CJ^XLFSTR("Version 8.0 of KERNEL is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Kernel Version 8.0....Present.",80))
 ;FILEMAN
 I +$$VERSION^XPDUTL("DI")<22 D MES^XPDUTL($$CJ^XLFSTR("Version 22.0 of FILEMAN is required.  Not installed.",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires Fileman v22....Present.",80))
 ;BJPC
 I $$VERSION^XPDUTL("BJPC")'="2.0" D MES^XPDUTL($$CJ^XLFSTR("Version 2.0 of the IHS PCC SUITE (BJPC) is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires IHS PCC Suite (BJPC) Version 2.0....Present.",80))
 I '$$INSTALLD("BJPC*2.0*8") D SORRY(2)
 I '$$INSTALLD("BJPC*2.0*9") D SORRY(2)
 I '$$INSTALLD("AVA*93.2*22") D SORRY(2)
 I '$$INSTALLD("AUT*98.1*26") D SORRY(2)
 I '$$INSTALLD("AUPN*99.1*23") D SORRY(2)
 I '$$INSTALLD("AUM*13.0*2") D SORRY(2)
 I '$$INSTALLD("AUM*13.0*3") D SORRY(2)
 I +$$VERSION^XPDUTL("BCQM")<1 D MES^XPDUTL($$CJ^XLFSTR("Version 1.0 of BCQM - IHS CODE MAPPING is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires BCQM V1.0....Present.",80))
 I +$$VERSION^XPDUTL("BSTS")<1 D MES^XPDUTL($$CJ^XLFSTR("Version 1.0 of BSTS - IHS TERMINOLOGY is required.  Not installed",80)) D SORRY(2) I 1
 E  D MES^XPDUTL($$CJ^XLFSTR("Requires BSTS V1.0....Present.",80))
 I '$$INSTALLD("AG*7.1*11") D SORRY(2)
 Q
PRE ;
 ;get rid of v care planning
 S DIU=9000010.57,DIU(0)="DET" D EN^DIU2 K DIU
 S DIU=9000010.59,DIU(0)="E" D EN^DIU2 K DIU
 S DIU=9000010.61,DIU(0)="E" D EN^DIU2 K DIU
 S DIU=9000010.63,DIU(0)="E" D EN^DIU2 K DIU
 S DA=$O(^AUTTREFR("B","410561003",0))
 I DA S DIE="^AUTTREFR(",DR=".01///410534003" D ^DIE K DA,DR,DIE
 S BJPCOS=$O(^APCHSURV("B","OSTEOPOROSIS SCREENING",0))
 I BJPCOS S BJPCOS=$P(^APCHSURV(BJPCOS,0),U,3)
 ;FIX 2101 MULTIPLE IN REPRODUCTIVE FACTORS
 S DA=0 F  S DA=$O(^AUPNREP(DA)) Q:DA'=+DA  D
 .Q:'$D(^AUPNREP(DA,2101,0))
 .I $P(^AUPNREP(DA,2101,0),U,2)="S" S $P(^AUPNREP(DA,2101,0),U,2)="9000017.0201PA"
 Q
 ;
POST ;
 ;add refusal type SNOMED to refusal type file
 I '$D(^AUTTREFT("B","SNOMED")) D
 .K DIC,DR,D0,DO
 .S X="SNOMED",DIC="^AUTTREFT(",DIC("DR")=".02////9002318.4;.03////1",DIC(0)="L",DIADD=1,DLAYGO=9999999.73 D FILE^DICN K DIC,DIADD,DLAYGO
 ;add message agent if it isn't there
 I '$D(^BDPTCAT("B","MESSAGE AGENT")) D
 .S X="MESSAGE AGENT",DIC="^BDPTCAT(",DIC(0)="L",DIADD=1,DLAYGO=90360.3,DIC("DR")=".02///MA;.07///1;.06///0;.08///Y" D FILE^DICN K DIC,DIADD,DLAYGO
 .Q
 ;
 ;ADD OPTIONS TO BDP
 S X=$$ADD^XPDMENU("BDP MENU MANAGER","BDP ADD/EDIT MESSAGE AGENT","MA",5)
 S X=$$ADD^XPDMENU("BDP MENU MANAGER","BDP INACT/REACT MESSAGE AGENT","IMA",10)
 S X=$$ADD^XPDMENU("BDP MENU DE","BDP ASSIGN MESSAGE AGENT","AMA")
 D FHAGE
 D ^BJPC2M
 S ^AMQQ(1,2,4,1,1)="S X=$S(X=""M"":""MALE"",X=""F"":""FEMALE"",X=""U"":""UNKNOWN"",1:"""")"  ;change sex output transform
 D PNEU
 D MES^XPDUTL($$CJ^XLFSTR("Hold on..I have to do some back-filling of SNOMED codes...",80))
SNO D TOBSMIM  ;HEALTH FACTORS FOREVER/IMM ;to background
 D URMEAS ;UPDATE/REVIEWED AND MEAS BACK 1 YR ;to background
 D NBHEAR ;FOREGROUND
 D INFANT ;FOREGROUND  ;v infant feeding and exams
T ;BACKFILL 1.01 IN PATIENT REFUSALS
 I '$P($G(^APCCCTRL(DUZ(2),99999)),U,1) S DIK="^AUPNPREF(",DIK(1)=".07^ASNMMAP" D ENALL^DIK S $P(^APCCCTRL(DUZ(2),99999),U,1)=1
 S X=$O(^APCHSURV("B","OSTEOPOROSIS SCREENING",0))
 I X S $P(^APCHSURV(X,0),U,3)=BJPCOS
 Q
PNEU ;
 ;mark Influenza and Pneumovax reminders as Deleted.
 S DA=$O(^APCHSURV("B","INFLUENZA",0))
 I DA S DIE="^APCHSURV(",DR=".03////D" D ^DIE K DIE,DA,DR
 S DA=$O(^APCHSURV("B","PNEUMOVAX",0))
 I DA S DIE="^APCHSURV(",DR=".03////D" D ^DIE K DIE,DA,DR
 S BJPCX=0 F  S BJPCX=$O(^APCHSURV(BJPCX)) Q:BJPCX'=+BJPCX  D
 .I $P($G(^APCHSURV(BJPCX,0)),U,1)="ANTICOAGULATION: SAFETY MEASURE: URINALYSIS" D
 ..S DA=BJPCX S DIE="^APCHSURV(",DR=".03////D" D ^DIE K DIE,DA,DR
 .I $P($G(^APCHSURV(BJPCX,0)),U,1)="ANTICOAGULATION: SAFETY MEASURE: CBC" D
 ..S DA=BJPCX S DIE="^APCHSURV(",DR=".03////D" D ^DIE K DIE,DA,DR
 .I $P($G(^APCHSURV(BJPCX,0)),U,1)="ANTICOAGULATION: SAFETY MEASURE: FOBT" D
 ..S DA=BJPCX S DIE="^APCHSURV(",DR=".03////D" D ^DIE K DIE,DA,DR
 Q
TOBSMIM ;
 ;backfill snomed for tobacco categories health factors and v imm
 S ZTIO=""
 S ZTRTN="TOBSM1^BJPC2PMU",ZTDTH=$$NOW^XLFDT,ZTDESC="BACKFILL V HEALTH FACTORS WITH SNOMED" D ^%ZTLOAD
 Q
TOBSM1 ;
 S BJPCX=0
 F  S BJPCX=$O(^AUPNVHF(BJPCX)) Q:BJPCX'=+BJPCX  D
 .S DA=BJPCX
 .D HF^AUPNMAP
 .Q
 D IMM1
 Q
IMM1 ;
 S BJPCX=0
 F  S BJPCX=$O(^AUPNVIMM(BJPCX)) Q:BJPCX'=+BJPCX  D
 .S DA=BJPCX
 .D IMM^AUPNMAP
 .Q
 Q
NBHEAR ;
 S BJPCD=$O(^AUTTEXAM("C",38,0))
 S BJPCX=0
 F  S BJPCX=$O(^AUPNVXAM("B",BJPCD,BJPCX)) Q:BJPCX'=+BJPCX  D
 .Q:'$D(^AUPNVXAM(BJPCX,0))
 .S DA=BJPCX
 .D EXAM^AUPNMAP
 .Q
 S BJPCD=$O(^AUTTEXAM("C",39,0))
 S BJPCX=0
 F  S BJPCX=$O(^AUPNVXAM("B",BJPCD,BJPCX)) Q:BJPCX'=+BJPCX  D
 .Q:'$D(^AUPNVXAM(BJPCX,0))
 .S DA=BJPCX
 .D EXAM^AUPNMAP
 .Q
 Q
INFANT ;
 S BJPCD=$$FMADD^XLFDT(DT,(5*366)) ;go back about 5 years
 F  S BJPCD=$O(^AUPNVSIT("B",BJPCD)) Q:BJPCD=""  D
 .S BJPCV=0 F  S BJPCV=$O(^AUPNVSIT("B",BJPCD,BJPCV)) Q:BJPCV'=+BJPCV  D
 ..S BJPCX=0
 ..F  S BJPCX=$O(^AUPNVIF("AD",BJPCV,BJPCX)) Q:BJPCX'=+BJPCX  D
 ...Q:'$D(^AUPNVIF(BJPCX,0))
 ...S DA=BJPCX
 ...D IF^AUPNMAP
 ...Q
 Q
URMEAS ;
 ;backfill snomed for updated/reviewed/exam and meas for 1 year
 S ZTIO=""
 S ZTRTN="URMEAS1^BJPC2PMU",ZTDTH=$$NOW^XLFDT,ZTDESC="BACKFILL V UPDATED/MEAS WITH SNOMED" D ^%ZTLOAD
 Q
URMEAS1 ;
 S BJPCD=$$FMADD^XLFDT(DT,-367) ;go back about a year
 F  S BJPCD=$O(^AUPNVSIT("B",BJPCD)) Q:BJPCD=""  D
 .S BJPCV=0 F  S BJPCV=$O(^AUPNVSIT("B",BJPCD,BJPCV)) Q:BJPCV'=+BJPCV  D
 ..S BJPCX=0
 ..F  S BJPCX=$O(^AUPNVRUP("AD",BJPCV,BJPCX)) Q:BJPCX'=+BJPCX  D
 ...Q:'$D(^AUPNVRUP(BJPCX,0))
 ...S DA=BJPCX
 ...D UPDREV^AUPNMAP
 ...Q
 ..S BJPCX=0
 ..F  S BJPCX=$O(^AUPNVMSR("AD",BJPCV,BJPCX)) Q:BJPCX'=+BJPCX  D
 ...Q:'$D(^AUPNVMSR(BJPCX,0))
 ...S DA=BJPCX
 ...D MEAS^AUPNMAP
 ..S BJPCX=0
 ..F  S BJPCX=$O(^AUPNVXAM("AD",BJPCV,BJPCX)) Q:BJPCX'=+BJPCX  D
 ...Q:'$D(^AUPNVXAM(BJPCX,0))
 ...S DA=BJPCX
 ...D EXAM^AUPNMAP
 Q
FHAGE ;
 ;move age range to age
 D MES^XPDUTL($$CJ^XLFSTR("Moving Family History Age Range to Age field..",IOM))
 NEW BJPCX,BJPCA,BJPCV
 S BJPCX=0 F  S BJPCX=$O(^AUPNFH(BJPCX)) Q:BJPCX'=+BJPCX  D
 .Q:$P(^AUPNFH(BJPCX,0),U,16)  ;already dealt with this entry
 .I $P(^AUPNFH(BJPCX,0),U,5)]"" D  Q
 ..S DA=BJPCX,DIE="^AUPNFH(",DR=".11///@;.16///1" D ^DIE K DA,DIE,DR
 .Q:$P(^AUPNFH(BJPCX,0),U,11)=""  ;no age range
 .S BJPCA=$P(^AUPNFH(BJPCX,0),U,11)
 .I BJPCA="U" D  Q
 ..S DA=BJPCX,DIE="^AUPNFH(",DR=".11///@;.16///1" D ^DIE K DA,DIE,DR
 .S BJPCV=$S(BJPCA=2:20,BJPCA=3:30,BJPCA=4:40,BJPCA=5:50,BJPCA=6:60,BJPCA=1:10,BJPCA="I":1)
 .S DA=BJPCX,DIE="^AUPNFH(",DR=".15///1;.16///1;.05///"_BJPCV D ^DIE K DA,DIE,DR
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