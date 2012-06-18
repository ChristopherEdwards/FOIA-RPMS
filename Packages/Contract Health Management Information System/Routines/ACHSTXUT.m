ACHSTXUT ; IHS/ITSC/PMF - DATA TRANMISSION SUBROUTINES ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 W !!,*7,"NOT AN ENTRY POINT"
 Q
 ;
TXLOGADD ;EP - Add entry to transmission log.
 ;;ACHSEXFS=FILE NAME TO BE ADDED TO TX LOG FILE
 S DIC(0)="ZML"
 K DA,X,Y
 I '$D(ACHSEXFS) G ABEND
 I '$D(DUZ(2)) G ABEND
 I '$D(^AFSTXLOG) G ABEND
 I '$D(^AFSTXLOG(DUZ(2))) S X=$$LOC^ACHS,DIC="^AFSTXLOG(" D ^DIC
L2 ;
 I $D(^AFSTXLOG(DUZ(2),1,0)) G L3
 LOCK +^AFSTXLOG(DUZ(2),1,0):3
 E  W *7,!!,"FILE IN USE BY ANOTHER USER",! G ABEND:'$$DIR^XBDIR("E"),L2
 S ^AFSTXLOG(DUZ(2),1,0)=$$ZEROTH^ACHS(9002320.5,1)
L3 ;
 S DIC="^AFSTXLOG("_DUZ(2)_",1,",X=ACHSEXFS,DA(1)=DUZ(2)
 D ^DIC
 S ACHSY=+Y
 LOCK -^AFSTXLOG(DUZ(2),1,0):3
 Q
 ;
ABEND ;
 S (Y,ACHSY)=-1
 Q
 ;
PT ;EP - From Option.  Mark Patient for re-export.
 N DFN
 D PTLK^ACHS
 Q:'$G(DFN)
 W !!,$P(^DPT(DFN,0),U),!
 I '$D(^ACHSF(DUZ(2),"PB",DFN)) W "This patient has no CHS documents on file." Q
 I '$P(^AUPNPAT(DFN,0),U,15) W "has already been marked for export with the next P.O. for them." Q
 W "was last exported on ",$$FMTE^XLFDT($P(^AUPNPAT(DFN,0),U,15)),"."
 Q:'$$DIR^XBDIR("Y","R U Sure you want to mark '"_$P(^DPT(DFN,0),U)_"' for export","N")
 N DIE,DA,DR
 S DIE="^AUPNPAT(",DA=DFN,DR=".15///@"
 D ^DIE
 Q
 ;
VEN ;EP - From Option.  Mark Vendor for re-export.
 N DIC,DA
 S DIC="^AUTTVNDR(",DIC(0)="AEZQM",DIC("A")="Enter Provider/Vendor: "
 D ^DIC
 Q:Y<1
 S DA=+Y
 W !!,$P(^AUTTVNDR(DA,0),U),!
 I '$D(^ACHSF(DUZ(2),"VB",DA)) W "This vendor has no CHS documents on file.",! Q
 I '$P(^AUTTVNDR(DA,11),U,12) W "has already been marked for export with the next P.O. for them." Q
 W "was last exported on ",$$FMTE^XLFDT($P(^AUTTVNDR(DA,11),U,12)),"."
 Q:'$$DIR^XBDIR("Y","R U Sure you want to mark '"_$P(^AUTTVNDR(DA,0),U)_"' for export","N")
 N DIE,DR
 S DIE="^AUTTVNDR(",DR="1112///@"
 D ^DIE
 Q
 ;
