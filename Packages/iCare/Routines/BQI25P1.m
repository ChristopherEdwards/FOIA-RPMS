BQI25P1 ;GDHS/HCS/ALA-Version 2.5 Patch 1 ; 13 Apr 2016  9:14 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
 ;
PRE ;EP
 NEW DA,DIK
 S DIK="^BQI(90506,",DA=0
 F  S DA=$O(^BQI(90506,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90506.3,",DA=0
 F  S DA=$O(^BQI(90506.3,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90507.8,",DA=0
 F  S DA=$O(^BQI(90507.8,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90509.9,",DA=0
 F  S DA=$O(^BQI(90509.9,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90505.2,",DA=0
 F  S DA=$O(^BQI(90505.2,DA)) Q:'DA  D ^DIK
 ;
 ; Move Accepted CVD Known patients
 K ^XTMP("BQITMP")
 D MOV
 ; Inactivate the 4 current CVD tags
 D IAC
 ;
 NEW DA,DIK
 S DIK="^BQI(90506.2,",DA=0
 F  S DA=$O(^BQI(90506.2,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90508.5,",DA=0
 F  S DA=$O(^BQI(90508.5,DA)) Q:'DA  D ^DIK
 Q
 ;
MOV ;EP Move Accepted CVD Known to ASCVD Known
 NEW OTAG,NTAG,RIEN,RSTAT,DFN
 S OTAG=6,NTAG=17
 S RIEN=""
 F  S RIEN=$O(^BQIREG("B",OTAG,RIEN)) Q:RIEN=""  D
 . S RSTAT=$P(^BQIREG(RIEN,0),U,3),DFN=$P(^BQIREG(RIEN,0),"^",2)
 . I RSTAT'="A" Q
 . M ^XTMP("BQITMP","REG",RIEN)=^BQIREG(RIEN)
 Q
 ;
IAC ;EP Inactivate CVD
 NEW BQITAG,BQIDFN,MESG
 ; Inactivate the 4 current tags
 F BQITAG=6,7,8,9 S BQIUPD(90506.2,BQITAG_",",.03)=1
 ; Inactivate the Best Practice Prompts
 S N=0 F  S N=$O(^BQI(90508.5,N)) Q:'N  S BQIUPD(90508.5,N_",",.04)=1
 D FILE^DIE("","BQIUPD","ERROR")
 ; Set to NLV (no longer valid, CVD Significant Risk, CVD Highest Risk and CVD At Risk
 F BQITAG=6,7,8,9 D
 . S THCFL=+$P(^BQI(90506.2,BQITAG,0),U,10)
 . S RIEN=""
 . F  S RIEN=$O(^BQIREG("B",BQITAG,RIEN)) Q:RIEN=""  D
 .. S RSTAT=$P(^BQIREG(RIEN,0),U,3),BQIDFN=$P(^BQIREG(RIEN,0),"^",2)
 .. ; If status is Not Accepted or No Longer Valid or Superceded, quit
 .. I RSTAT="N"!(RSTAT="V")!(RSTAT="S") Q
 .. ; if the current status is 'Proposed', move the factors before setting the
 .. ; current status to 'No Longer Valid' or 'Superseded'
 .. I RSTAT="P" D MOV^BQITDPRC(BQIDFN,BQITAG)
 .. S MESG="CVD LOGIC UPDATE"
 .. D EN^BQITDPRC(.TGDATA,BQIDFN,BQITAG,"V",,MESG,3)
 ;
 ; Delete Best Practice Prompts
 S DFN=0
 F  S DFN=$O(^BQIPAT(DFN)) Q:'DFN  K ^BQIPAT(DFN,50)
 ;
NOT ;Send notification if a panel is using one of the CVD tags
 NEW PDZ,PL,DN,DCAT,CT,BTEXT,PLNM
 S PDZ=0 F  S PDZ=$O(^BQICARE(PDZ)) Q:'PDZ  D
 . S PL=0,CT=2 K BTEXT
 . S BTEXT(1,0)="CVD Tags have changed.  You may need to update the following"
 . S BTEXT(2,0)="panels which use CVD Tag in the panel definition."_$C(10)_$C(13)
 . F  S PL=$O(^BQICARE(PDZ,1,PL)) Q:'PL  D
 .. S DN=$O(^BQICARE(PDZ,1,PL,15,"B","DXCAT","")) I DN="" Q
 .. S DCAT=$P(^BQICARE(PDZ,1,PL,15,DN,0),"^",3)
 .. I DCAT'=6,DCAT'=7,DCAT'=8,DCAT'=9 Q
 .. S PLNM=$P(^BQICARE(PDZ,1,PL,0),"^",1)
 .. S CT=CT+1,BTEXT(CT,0)="     Panel:  "_PLNM_$C(10)_$C(13)
 . I CT>2 D ADD^BQINOTF("",PDZ_$C(28),"Correct Panel Definitions",.BTEXT,1)
 Q
 ;
POS ;EP
 ;Set the version number
 NEW DA
 S DA=$O(^BQI(90508,0))
 S BQIUPD(90508,DA_",",.08)="2.5.1.5"
 S BQIUPD(90508,DA_",",.09)="2.5.1.5"
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 D ^BQIATX
 D ^BQITAXXU
 D ^BQIUSRC
 D ^BQIULAY
 ;
 ; Fix if default view is MU
 NEW DZ
 S DZ=0
 F  S DZ=$O(^BQICARE(DZ)) Q:'DZ  D
 . I $$GET1^DIQ(90505,DZ_",",.02,"E")["MU" S BQIUPD(90505,DZ_",",.02)="@"
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
GLS ;EP Update glossary
 NEW GN,GNM,GSN,BQIUPD
 S GN=0
 F  S GN=$O(^BQI(90509.9,GN)) Q:'GN  D
 . S GNM=$P(^BQI(90509.9,GN,0),U,1)
 . S GSN=$O(^BQI(90508.2,"B",GNM,"")) Q:GSN=""
 . S BQIUPD(90508.2,GSN_",",1)="@"
 . D FILE^DIE("","BQIUPD","ERROR")
 . M ^BQI(90508.2,GSN,1)=^BQI(90509.9,GN,1)
 ;
 ; Set BTPWRPC and BUSARPC into BQIRPC
 NEW IEN,DA,X,DIC,Y
 S DA(1)=$$FIND1^DIC(19,"","B","BQIRPC","","","ERROR"),DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LMNZ"
 I $G(^DIC(19,DA(1),10,0))="" S ^DIC(19,DA(1),10,0)="^19.01IP^^"
 S X="BTPWRPC"
 D ^DIC I +Y<1 K DO,DD D FILE^DICN
 NEW IEN,DA,X,DIC,Y
 S DA(1)=$$FIND1^DIC(19,"","B","BQIRPC","","","ERROR"),DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LMNZ"
 I $G(^DIC(19,DA(1),10,0))="" S ^DIC(19,DA(1),10,0)="^19.01IP^^"
 S X="BUSARPC"
 D ^DIC I +Y<1 K DO,DD D FILE^DICN
 ;
 F DA=4,7,25,26 S BQIUP(90506.5,DA_",",.18)=1
 D FILE^DIE("","BQIUP","ERROR")
 ;
 ; Inactivate the 4 current tags
 F BQITAG=6,7,8,9 S BQIUPD(90506.2,BQITAG_",",.03)=1
 F BQITAG=17,18 S BQIUPD(90506.2,BQITAG_",",.03)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 ;Update any "accepted" CVD Knowns to ASCVD Known
 NEW RIEN,NTAG
 S NTAG=17,RIEN=""
 F  S RIEN=$O(^XMP("BQITMP","REG",RIEN)) Q:RIEN=""  D
 . S BQIUPD(90509,RIEN_",",.01)=NTAG
 . S CF=0 F  S CF=$O(^BQIREG(RIEN,5,CF)) Q:'CF  D
 .. S BQIUPD(90509.5,CF_",",.03)=NTAG
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
BP ;Removed from HEALTH SUMMARY MAINT ITEM and add new BPs
 D CBP^BQITRUPD
 ;
 NEW NAME,TEXT
 S NAME="Missing ASCVD Risk" D
 . S TEXT(1)="This patient does not have an ASCVD risk assessment documented. Consider"
 . S TEXT(2)="assessing the ASCVD risk at next opportunity."
 . D NON^BQITRUPD(NAME,.TEXT)
 ;
 ;Update Tags and Best Practice Prompts
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,NOW
 S NOW=$$NOW^XLFDT(),ZTDTH=DT_".19"
 I $$FMDIFF^XLFDT(ZTDTH,NOW,2)<60 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,15)
 S ZTDESC="Update CVD Tags/Best Practice",ZTRTN="TAG^BQI25P1",ZTIO=""
 D ^%ZTLOAD
 K ZTDESC,ZTRTN,ZTIO,ZTDTH,ZTSK
 ;
 Q
 ;
TAG ;EP
 NEW TAG
 F TAG="ASCVD Known","ASCVD At Risk" D EN^BQITASK4(TAG)
 Q
