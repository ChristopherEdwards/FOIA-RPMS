BJPC2P3 ; IHS/CMI/LAB - PCC Suite v1.0 patch 3 environment check ;   
 ;;2.0;IHS PCC SUITE;**4**;MAY 14, 2009
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("APCL*3.0*25") D SORRY(2)
 I '$$INSTALLD("BJPC*2.0*2") D SORRY(2)
 ;
 Q
 ;
PRE ;
 S BJPCDA=0 F  S BJPCDA=$O(^APCLVSTS(BJPCDA)) Q:BJPCDA'=+BJPCDA  S DA=BJPCDA,DIK="^APCLVSTS(" D ^DIK
 K DIK,DA
 S DA=$O(^APCHSCMP("B","MEASUREMENT PANELS",0))
 I DA S DIE="^APCHSCMP(",DR=".01///MEASUREMENT PANELS (OUTPATIENT)" D ^DIE
 S DA=$O(^APCHSCMP("B","MEASUREMENTS",0))
 I DA S DIE="^APCHSCMP(",DR=".01///MEASUREMENTS (OUTPATIENT)" D ^DIE
 K DA,DIE,DR
 ;DELETE V MEAS DD SO XREFS GO AWAY
 S DIU(0)="",DIU=9000010.01
 D EN^DIU2
 Q
POST ;
 ;file qualifiers into multiple 1 in GMRV VITAL QUALIFIERS
 D MES^XPDUTL("Adding Measurement Type to Vital Qualifiers file...")
 ;wipe out existing data
 S X=0 F  S X=$O(^GMRD(120.52,X)) Q:X'=+X  K ^GMRD(120.52,X,1)
 K ^GMRD(120.52,"AA"),^GMRD(120.52,"BB"),^GMRD(120.52,"D"),^GMRD(120.52,"C")
 NEW BJPCVIEN,BJPCMT,BJPCCAT,BJPCMIEN,BJPCFDA,BJPCIENS,BJPCERRR,BJPCAIEN
 S BJPCVIEN=0
 F  S BJPCVIEN=$O(@XPDGREF@("VITALQUALMT",BJPCVIEN)) Q:BJPCVIEN<1  D
 .S BJPCMIEN=0 F  S BJPCMIEN=$O(@XPDGREF@("VITALQUALMT",BJPCVIEN,BJPCMIEN)) Q:BJPCMIEN'=+BJPCMIEN  D
 ..S MT=$P(@XPDGREF@("VITALQUALMT",BJPCVIEN,BJPCMIEN),U,1)
 ..S CAT=$P(@XPDGREF@("VITALQUALMT",BJPCVIEN,BJPCMIEN),U,2)
 ..;file entry into multiple using the external values
 ..K BJPCFDA,BJPCIENS,BJPCERRR,BJPCAIEN
 ..S BJPCIENS="+2,"_BJPCVIEN_","
 ..S BJPCFDA(120.521,BJPCIENS,.01)=MT
 ..S BJPCFDA(120.521,BJPCIENS,.02)=CAT
 ..D UPDATE^DIE("E","BJPCFDA","BJPCIENS","BJPCERRR(1)")
 ..I $D(BJPCERRR) D MES^XPDUTL("Error updating qualifier "_$P(^GMRD(120.52,BJPCVIEN,0),U)_" / measurement type "_MT)
VMEAS ;
 D MES^XPDUTL("hold on...fixing V Measurement entries, this may take a while...")
 ;take 1201 field value and if entered by data entry move to .07 and then wipe out 1201 field
 S BJPCDA=0,BJPCCNT=0 F  S BJPCDA=$O(^AUPNVMSR(BJPCDA)) Q:BJPCDA'=+BJPCDA  D
 .S BJPCCNT=BJPCCNT+1
 .I '(BJPCCNT#10000) W "."
 .Q:'$D(^AUPNVMSR(BJPCDA,12))
 .Q:'$P(^AUPNVMSR(BJPCDA,12),U,1)  ;no date
 .Q:$P(^AUPNVMSR(BJPCDA,12),U,2)  ;EHR Entered
 .Q:$P(^AUPNVMSR(BJPCDA,12),U,4)  ;EHR ENTERED
 .S BJPCSAVE=$P(^AUPNVMSR(BJPCDA,0),U,7)
 .S DA=BJPCDA,DR=".07///"_$P(^AUPNVMSR(BJPCDA,12),U,1)_";1201///@",DIE="^AUPNVMSR(" D ^DIE K DA,DIE,DR
 .I BJPCSAVE]"" S DA=BJPCDA,DR="1201///"_BJPCSAVE,DIE="^AUPNVMSR(" D ^DIE K DA,DR,DIE  ;if they had entered a .07 move it to 1201 although I doubt d/e entered it as they don't know it
 ;reindex AB and AE if they are moved to 1201
 D MES^XPDUTL("reindexing AB and AE xrefs...")
 K ^AUPNVMSR("AB"),^AUPNVMSR("AE")  ;kill existing xrefs
 S DIK="^AUPNVMSR(",DIK(1)="1201^AB^AE"
 D ENALL^DIK
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
 ; Pre-Transport global for Vital Qualifier measurement type mapping (multiple)
PRETRAN ;
 N IEN,VAL,TXT,MIEN,MT,CAT,BJPCAR,J,BJPCC
 S IEN=0,BJPCC=0
 F  S IEN=$O(^GMRD(120.52,IEN)) Q:IEN<1  D
 .K BJPCAR
 .D GETS^DIQ(120.52,IEN_",",1_"*","","BJPCAR")
 .S J="" F  S J=$O(BJPCAR(120.521,J)) Q:J=""  D
 ..S MT=$G(BJPCAR(120.521,J,.01))
 ..S CAT=$G(BJPCAR(120.521,J,.02))
 ..S BJPCC=BJPCC+1
 ..S @XPDGREF@("VITALQUALMT",IEN,BJPCC)=MT_"^"_CAT
 Q
