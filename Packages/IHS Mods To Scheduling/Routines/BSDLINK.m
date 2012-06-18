BSDLINK ; IHS/ANMC/LJF - UPDATE SCHEDULING UPON VISIT MERGE;
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;This routine is called by the PCC Visit Merge Utility.
 ;The input variables are:  APCDVMF - Merge from visit ifn
 ;                          APCDVMT - Merge to visit ifn
 ;
 ;This routine finds the patient involved, scans for this merged visit
 ;among the entries in the Outpatient Encounter file and updates it.
 ;
MRG ;PEP >> PRIVATE ENTRY POINT between PIMS and PCC
 NEW DIE,DA,DR,BSDN,X,Y
 Q:'$D(APCDVMF)  Q:'$D(APCDVMT)
 S BSDN=0,DIE="^SCE("
 F  S BSDN=$O(^SCE("AVSIT",APCDVMF,BSDN)) Q:BSDN=""  D
 . I $P(^SCE(BSDN,0),U,2)'=$P(^AUPNVSIT(APCDVMT,0),U,5) Q  ;wrong pat
 . ; uses 4 slashes to bypass Visit file screen
 . S DR=".05////"_APCDVMT,DA=BSDN D ^DIE
 ;
 Q
 ;
POST ;EP; -- add PIMS to PCC Visit Merge Utility
 D BMES^XPDUTL("Adding an entry for PIMS into the MODULE PCC LINK CONTROL file...")
 Q:$D(^APCDLINK("B","PIMS"))  ;already exists
 K DD,DO S DIC="^APCDLINK(",DIC(0)="LE",DLAYGO=9001002
 S DIC("DR")="1///S:$D(X) BSDX=X S X=""BSDLINK"" X ^%ZOSF(""TEST"") S:$D(BSDX) X=BSDX K BSDX I $T D MRG^BSDLINK"
 S X="PIMS" D FILE^DICN
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
