APCHCOMM ; IHS/TUCSON/LAB - ROUTINE AFTER USER COMMITS ;  [ 06/24/97  2:42 PM ]
 ;;2.0;IHS RPMS/PCC Health Summary;;JUN 24, 1997
 ;
 ;This routine changes the security key named APCHS CONFIDENTIAL to
 ;APCHZ CONFIDENTIAL to meet the Standards.
 ;
START ;  start of routine
 ; following line - quit if data exists
 Q:$D(^DIC(19.1,"B","APCHZ CONFIDENTIAL"))
 D LOOKUP ;                                  look-up security key
 Q:APCHQ
 L +^DIC(19.1,APCHDA):5 I '$T W !,"Sorry, this key is currently being edited.  Try later." G END
 D RCR1 ;                                copy node 1 of key (w/p field)
 D %XY^%RCR
 D CHGNAR ;                              change key name in description
 D DELETE ;                              delete old key
 D ADDKEY ;                              add key with new name
 D RCR2 ;                                copy node 1 of key (w/p field)
 D %XY^%RCR
 L -^DIC(19.1,APCHDA)
END ;  end of routine
 K ^APCHTMP(APCHDA)
 K APCHQ,APCHDA,APCHGBL
 Q
 ;
 ;-----------------------------
LOOKUP ;
 S APCHQ=1
 S APCHDA=$O(^DIC(19.1,"B","APCHS CONFIDENTIAL",0))
 Q:'APCHDA
 S APCHGBL="^DIC(19.1,"
 S APCHQ=0
 Q
 ;
RCR1 ;set vars to copy node 1 word-processing field to temporary global
 S %X=APCHGBL_APCHDA_",1,"
 S %Y="^APCHTMP("_APCHDA_",1,"
 Q
RCR2 ;set vars to copy node 1 word-processing field to ^DIC(19.1, global
 S %X="^APCHTMP("_APCHDA_",1,"
 S %Y=APCHGBL_APCHDA_",1,"
 Q
 ;
DELETE ;delete security key
 S DIK=APCHGBL,DA=APCHDA
 W !!,"......deleting SECURITY KEY:  APCHS CONFIDENTIAL",!!
 D ^DIK K DIK
 K D,D0,D1,DA,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM
 Q
 ;
ADDKEY ; add APCHZ CONFIDENTIAL security key
 K DD,D0
 S DIC=APCHGBL,DIC(0)="OZ",X="APCHZ CONFIDENTIAL"
 S (DA,DINUM)=APCHDA
 W !!,"......renaming SECURITY KEY to APCHZ CONFIDENTIAL",!!
 D FILE^DICN
 K D,D0,D1,DA,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM
 Q
 ;
CHGNAR ; change security key name in description
 S ^APCHTMP(APCHDA,1,2,0)="APCHZ CONFIDENTIAL will not appear on the health summary.  Note"
 Q
