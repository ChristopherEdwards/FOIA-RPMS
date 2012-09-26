BQIIPUPD ;VNGT/HS/ALA-IPC Update ; 26 May 2011  7:39 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
NCRS ;New CRS
 ; Change BQIGPUPD to change IPC Versions when new version of CRS is released
 ; take current IPC value and add one
 NEW CRIPC,NUM,NWIPC,DA,DIC,Y
 S CRIPC=$P($G(^BQI(90508,1,11)),U,1)
 F I=$L(CRIPC):-1:1 Q:$E(CRIPC,I,I)'?.N
 S NUM=$E(CRIPC,I+1,$L(CRIPC)),NUM=NUM+1
 S NWIPC="IPC"_NUM
 S DA(1)=1,X=NWIPC,DIC="^BQI(90508,"_DA(1)_",22,",DIC(0)="LMNZ",DLAYGO=90508.022
 I $G(^BQI(90508,1,22,0))="" S ^BQI(90508,1,22,0)="^90508.022^^"
 D ^DIC
 S $P(^BQI(90508,1,11),U,1)=NWIPC
 Q
 ;
CCRS ;Current CRS
 NEW CRIPC,CRN
 S CRIPC=$P($G(^BQI(90508,1,11)),U,1)
 S CRN=$O(^BQI(90508,1,22,"B",CRIPC,"")) I CRN="" Q
 I $G(^BQI(90508,1,22,CRN,1,0))="" S ^BQI(90508,1,22,CRN,1,0)="^90508.221^^"
 ; Add new entries
 NEW BI,BJ,BK,BN,BQIUPD,ERROR,IENS,ND,NDATA,TEXT,VAL
 F BI=1:1 S TEXT=$P($T(NONC+BI),";;",2) Q:TEXT=""  D
 . F BJ=1:1:$L(TEXT,"~") D
 .. S NDATA=$P(TEXT,"~",BJ)
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. I ND=0 D
 ... NEW DIC,X,Y,DA
 ... S DA(2)=1,DA(1)=CRN
 ... S DIC(0)="LQZ",DIC="^BQI(90508,"_DA(2)_",22,"_DA(1)_",1,",X=$P(VAL,U,1)
 ... D ^DIC
 ... S DA=+Y
 ... I DA=-1 K DO,DD D FILE^DICN S DA=+Y
 ... S IENS=$$IENS^DILF(.DA)
 .. I ND=1 S BQIUPD(90508.221,IENS,1)=VAL Q
 .. F BK=1:1:$L(VAL,"^") D
 ... S BN=$O(^DD(90508.221,"GL",ND,BK,"")) I BN="" Q
 ... I $P(VAL,"^",BK)'="" S BQIUPD(90508.221,IENS,BN)=$P(VAL,"^",BK) Q
 ... I $P(VAL,"^",BK)="" S BQIUPD(90508.221,IENS,BN)="@"
 . D FILE^DIE("","BQIUPD","ERROR")
 ;
GP ; Get fields from CRS
 NEW BQIH,BQIYR,BQIYDA,BQIMEASF,IDIN,MDATA,VAL
 S BQIH=$$SPM^BQIGPUTL()
 S BQIYR=$$GET1^DIQ(90508,BQIH_",",2,"E")
 S BQIYDA=$$LKP^BQIGPUTL(BQIYR)
 D GFN^BQIGPUTL(BQIH,BQIYDA)
 S BQIINDG=$$ROOT^DILFD(BQIMEASF,"",1)
 S IDIN=0
 F  S IDIN=$O(@BQIINDG@(IDIN)) Q:'IDIN  D
 . S MDATA=$G(@BQIINDG@(IDIN,17)) I MDATA="" Q
 . I +MDATA=0 Q
 . I $P(MDATA,U,7)'=1 Q
 . S VAL=BQIYR_"_"_IDIN
 . D NE(VAL)
 . S BQIUPD(90508.221,IENS,.02)="G",BQIUPD(90508.221,IENS,.04)=$P(MDATA,U,3)
 . D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
NE(VALUE) ; New Entry
 NEW DIC,X,Y,DA
 S DA(2)=1,DA(1)=CRN
 S DIC(0)="LQZ",DIC="^BQI(90508,"_DA(2)_",22,"_DA(1)_",1,",X=$P(VALUE,U,1)
 D ^DIC
 S DA=+Y
 I DA=-1 K DO,DD D FILE^DICN S DA=+Y
 S IENS=$$IENS^DILF(.DA)
 Q
 ;
NONC ; Non CRS definitions
 ;;0|IPC_REVG^R^S^Revenue Generated Per Visit~1|D EN^BQIIPRVG
 ;;0|IPC_CCPR^R^S^Continuity of Care Primary Provider~1|D EN^BQIIPCCP
 ;;0|IPC_PEMP^R^S^Empanelled Primary Care Provider~1|D EN^BQIIPEMP
 ;;0|IPC_CANC^R^C^Cancer Screening Bundle~1|
 ;;0|IPC_HRISK^R^H^Health Risk Screening Bundle~1|
 ;;0|IPC_OUTC^R^O^Outcome Measures Bundle~1|
