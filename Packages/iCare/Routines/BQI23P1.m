BQI23P1 ;VNGT/HS/ALA-Install Program v 2.3 Patch 1 ; 25 May 2011  7:31 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**1**;Apr 18, 2012;Build 43
 ;
PRE ; Pre-install
 NEW DA,DIK
 S DIK="^BQI(90506,",DA=0
 F  S DA=$O(^BQI(90506,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90507.8,",DA=0
 F  S DA=$O(^BQI(90507.8,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90506.5,",DA=0
 F  S DA=$O(^BQI(90506.5,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90508.6,",DA=0
 F  S DA=$O(^BQI(90508.6,DA)) Q:'DA  D ^DIK
 S DIK="^BQI(90506.8,",DA=0
 F  S DA=$O(^BQI(90506.8,DA)) Q:'DA  D ^DIK
 S DA=0,DIK="^BQI(90509.9,"
 F  S DA=$O(^BQI(90509.9,DA)) Q:'DA  D ^DIK
 ;
 K ^BQI(90506.2,3,6)
 Q
 ;
POS ; Post-Install
 ;
 S $P(^BQI(90508,1,0),U,24)="36M"
 ; Clean up new style cross-reference
 NEW DIK
 K ^BQI(90507.7,"AC")
 S DIK="^BQI(90507.7," D IXALL^DIK
 ;
 ; Update flags
 NEW N,CT
 S N=0
 F  S N=$O(^BQIPAT(N)) Q:'N  K ^BQIPAT(N,10) S CT=$G(CT)+1 W:CT#500 "."
 ;
 ; Update Provider Edit V Form
 NEW VN,CN
 S VN=$O(^BQI(90506.3,"B","Designated Provider",""))
 I VN'="" D
 . S CN=$O(^BQI(90506.3,VN,10,"B","Last Modified By",""))
 . I CN'="" D
 .. S ^BQI(90506.3,VN,10,CN,1)="D^^^^D"
 . S CN=$O(^BQI(90506.3,VN,10,"B","Last Modified Date",""))
 . I CN'="" D
 .. S ^BQI(90506.3,VN,10,CN,1)="T^^^^D"
 ;
 ; Update Medication PCC V Form to remove from list
 S VN=$O(^BQI(90506.3,"B","Medication",""))
 I VN'="" S $P(^BQI(90506.3,VN,0),"^",5)=1
 ;
 NEW BDZ,AIEN
 S BDZ=0
 F  S BDZ=$O(^BQICARE(BDZ)) Q:'BDZ  D
 . F BQCN=55,75 D
 .. S AIEN=$O(^BQICARE(BDZ,11,"B",BQCN,"")) I AIEN="" Q
 .. NEW DA,DIK
 .. S DA(1)=BDZ,DA=AIEN,DIK="^BQICARE("_DA(1)_",11," D ^DIK
 . ;
 . NEW NFN,DA,IENS
 . S NFN=$O(^BQICARE(BDZ,10,"B",17,"")) I NFN="" Q
 . S DA(1)=BDZ,DA=NFN,IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90505.09,IENS,.01)=12
 . D FILE^DIE("","BQIUPD","ERROR")
 ;
 D DX
 ;
 ; Update CMET
 S ^BTPW(90621.1,13,0)="V SKIN TEST^9000010.12^.01^^^O^6^9999999.28"
 S ^BTPW(90621.2,6,0)="STI^ST",^BTPW(90621.2,"B","STI",6)=""
 NEW IEN,EVT,BQIUPD
 F IEN=2,14,16 S BQIUPD(90621,IEN_",",.1)=6
 D FILE^DIE("","BQIUPD","ERROR")
 F EVT=2,14,16 D
 . S IEN=""
 . F  S IEN=$O(^BTPWQ("B",EVT,IEN)) Q:IEN=""  S BQIUPD(90629,IEN_",",.13)=6
 . F  S IEN=$O(^BTPWP("B",EVT,IEN)) Q:IEN=""  S BQIUPD(90620,IEN_",",.12)=6
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 NEW DA,DIK
 S DA=13,DIK="^BTPW(90621.1," D IX^DIK
 ;
 ; Removed the BGP COLO DXS taxonomy
 S DA(1)=51,DA=3,DIK="^BTPW(90621,"_DA(1)_",1," D ^DIK
 ;
 ; Removed the BGP PAP SMEAR DXS taxonomy
 S DA(1)=29,DA=2,DIK="^BTPW(90621,"_DA(1)_",1," D ^DIK
 ;
 ; Inactivate the OB/GYN CONSULT event in CMET
 S $P(^BTPW(90621,27,0),U,3)=DT,$P(^(0),U,4)="N"
 ;
 NEW TXN,N,VAL,DA,IENS,BQIUPD
 S TXN=$O(^ATXAX("B","BTPW COLP IMP NO BX CPTS",""))
 I TXN'="" D
 . S N=0
 . F  S N=$O(^ATXAX(TXN,21,N)) Q:'N  D
 .. S DA(1)=TXN,DA=N,IENS=$$IENS^DILF(.DA)
 .. S VAL=$P(^ATXAX(TXN,21,N,0),U,1)
 .. I $E(VAL,$L(VAL))'=" " S VAL=VAL_" "
 .. S BQIUPD(9002226.02101,IENS,.01)=VAL
 .. S BQIUPD(9002226.02101,IENS,.02)=VAL
 . D FILE^DIE("","BQIUPD","ERROR")
 ;
GLS ; Update glossary
 NEW GN,GNM,GSN,BQIUPD
 S GN=0
 F  S GN=$O(^BQI(90509.9,GN)) Q:'GN  D
 . S GNM=$P(^BQI(90509.9,GN,0),U,1)
 . S GSN=$O(^BQI(90508.2,"B",GNM,"")) Q:GSN=""
 . S BQIUPD(90508.2,GSN_",",1)="@"
 . D FILE^DIE("","BQIUPD","ERROR")
 . M ^BQI(90508.2,GSN,1)=^BQI(90509.9,GN,1)
 ;
 ; Update taxonomies
 D EN^BQI23PUC
 ;
IPC ; Update for IPC4
 I $P($G(^BQI(90508,1,"GPRA")),U,1)=2012 D
 . I $P(^BGPINDWC(1237,0),U,4)="HED.CWP.1" D
 .. S ^BGPINDWC(1237,17)="9^3^Appropriate Testing for Pharyngitis (2-18)^^^O^1"
 .. S ^BGPINDWC(1237,18,0)="^^3^3^3120926^"
 .. S ^BGPINDWC(1237,18,1,0)="Active Clinical patients who were ages 2-18 years who were diagnosed with "
 .. S ^BGPINDWC(1237,18,2,0)="pharyngitis and prescribed an antibiotic during the period six months "
 .. S ^BGPINDWC(1237,18,3,0)="(182 days) prior to the Report period."
 .. D GCHK^BQIGPUPD(0)
 ;
 ; Update IPC measures
 D ^BQI23PU4
 ;
 NEW PRV,DA,IEN,IENS,FAC
 S PRV=0
 F  S PRV=$O(^BQIPROV(PRV)) Q:'PRV  D
 . S IEN=$O(^BQIPROV(PRV,30,"B","2012_2045","")) I IEN="" Q
 . S DA(1)=PRV,DA=IEN,IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90505.43,IENS,.01)="2012_1966"
 S FAC=$O(^BQIFAC(0))
 I FAC S IEN=$O(^BQIFAC(FAC,30,"B","2012_2045",""))
 I IEN'="" D
 . S DA(1)=FAC,DA=IEN,IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90505.63,IENS,.01)="2012_1966"
 S BQIUPD(90508,"1,",11)="IPC4"
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 Q
 ;
DX ; Check diagnosis code pointers
 NEW CN,DN,DXC,DXN
 S CN=0
 F  S CN=$O(^BQI(90507.8,CN)) Q:'CN  D
 . S DN=0
 . F  S DN=$O(^BQI(90507.8,CN,10,DN)) Q:'DN  D
 .. S DXC=$P(^BQI(90507.8,CN,10,DN,0),U,2)_" "
 .. S DXN=$$FIND1^DIC(80,"","X",DXC,"BA","","ERROR")
 .. I $P(^BQI(90507.8,CN,10,DN,0),U,1)=DXN Q
 .. NEW DA,IENS
 .. S DA(1)=CN,DA=DN,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90507.801,IENS,.01)=DXN
 . S TN=0
 . F  S TN=$O(^BQI(90507.8,CN,11,TN)) Q:'TN  D
 .. S TAX=$P(^BQI(90507.8,CN,11,TN,0),U,1)
 .. S VAL=$$STXPT(TAX,"N")
 .. NEW DA,IENS
 .. S DA(1)=CN,DA=TN,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90507.811,IENS,.02)=VAL
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
STXPT(TXNM,TYP) ;  Set taxonomy pointer
 ;
 ;Input
 ;  TXNM - Taxonomy name
 ;  TYP  - Taxonomy Type (L = LAB, N = Non Lab)
 NEW IEN,SIEN,DA,IENS,BQUPD,VALUE,GLB
 S VALUE=""
 I TYP="L" D
 . S IEN=$O(^ATXLAB("B",TXNM,"")),GLB="ATXLAB("
 . I IEN="" S TYP="N"
 I TYP="N" S IEN=$O(^ATXAX("B",TXNM,"")),GLB="ATXAX("
 I IEN="" S VALUE="@"
 I IEN'="" S VALUE=IEN_";"_GLB
 Q VALUE
