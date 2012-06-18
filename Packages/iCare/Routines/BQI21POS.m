BQI21POS ;VNGT/HS/ALA-Version 2.1 Post Install ; 19 Feb 2009  1:13 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN ; Entry point
 ;
 ;Set the version number
 NEW DA
 S DA=$O(^BQI(90508,0))
 S BQIUPD(90508,DA_",",.08)="2.1.0.60"
 S BQIUPD(90508,DA_",",.09)="2.1.0T60"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 ; Remove the alerts glossary from the site parameter file
 K ^BQI(90508,1,16)
 ; Update Mail Merge glossary from the site parameter file
 NEW DA,IEN
 S DA=0
 F  S DA=$O(^BQI(90508,1,17,DA)) Q:'DA  K ^BQI(90508,1,17,DA)
 S IEN=$O(^BQI(90509.9,"B","MAIL MERGE GLOSSARY UPDATE",""))
 I IEN'="" D
 . NEW N
 . S N=0
 . F  S N=$O(^BQI(90509.9,IEN,1,N)) Q:'N  S ^BQI(90508,1,17,N,0)=^BQI(90509.9,IEN,1,N,0)
 . S ^BQI(90508,1,17,0)=^BQI(90509.9,IEN,1,0)
 ;
 ; Add ARV Stability entries to 90506.1
 NEW BI,BJ,BK,BN,BQIUPD,ERROR,IEN,ND,NDATA,TEXT,VAL
 F BI=1:1 S TEXT=$P($T(ARV+BI),";;",2) Q:TEXT=""  D
 . F BJ=1:1:$L(TEXT,"~") D
 .. S NDATA=$P(TEXT,"~",BJ)
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. I ND=0 D
 ... NEW DIC,X,Y
 ... S DIC(0)="LQZ",DIC="^BQI(90506.1,",X=$P(VAL,U,1)
 ... D ^DIC
 ... S IEN=+Y
 ... I IEN=-1 K DO,DD D FILE^DICN S IEN=+Y
 .. I ND=1 S BQIUPD(90506.1,IEN_",",1)=VAL Q
 .. F BK=1:1:$L(VAL,"^") D
 ... S BN=$O(^DD(90506.1,"GL",ND,BK,"")) I BN="" Q
 ... I $P(VAL,"^",BK)'="" S BQIUPD(90506.1,IEN_",",BN)=$P(VAL,"^",BK) Q
 ... I $P(VAL,"^",BK)="" S BQIUPD(90506.1,IEN_",",BN)="@"
 . D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Re-Index File
 K ^BQI(90506.1,"AC"),^BQI(90506.1,"AD")
 NEW DIK
 S DIK="^BQI(90506.1,",DIK(1)=3.01
 D ENALL^DIK
 ;
 ;Update the EHR reminders
 S TJOB="Weekly" D EHR^BQIRMDR1
 ;Update the CMET reminders
 D CMET^BQIRMDR1
 ;
 ; Update pointers for community alerts
 D DX^BQI202PU
 I $G(^BQI(90507.8,2,10,2,0))="" D
 . NEW DXN
 . S $P(^BQI(90507.8,2,10,2,0),U,2)="042.",^BQI(90507.8,2,10,"AC","042.",2)=""
 . S DXN=$O(^ICD9("BA","042. ",""))
 . S $P(^BQI(90507.8,2,10,2,0),U,1)=DXN,^BQI(90507.8,2,10,"B",DXN,2)=""
 NEW CN,TXN,TAX,TTYP,VAL,BQIUPD
 S CN=0
 F  S CN=$O(^BQI(90507.8,CN)) Q:'CN  D
 . S TXN=0
 . F  S TXN=$O(^BQI(90507.8,CN,11,TXN)) Q:'TXN  D
 .. S TAX=$P(^BQI(90507.8,CN,11,TXN,0),U,1)
 .. S TTYP="N"
 .. S VAL=$$STXPT(TAX,TTYP)
 .. NEW DA,IENS
 .. S DA(1)=CN,DA=TXN,IENS=$$IENS^DILF(.DA)
 .. S BQIUPD(90507.811,IENS,.02)=VAL
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Update HMS reminder taxonomy pointers
 S REG=0
 F  S REG=$O(^BQI(90507,REG)) Q:'REG  D
 . S N=0
 . F  S N=$O(^BQI(90507,REG,10,N)) Q:'N  D
 .. S X=$P(^BQI(90507,REG,10,N,0),U,1)
 .. S IEN=N_","_REG_","
 .. I $P(^BQI(90507,REG,10,N,0),U,5)="T" S VAL=$$STXPT(X,"L")
 .. E  S VAL=$$STXPT(X,"N")
 .. S BQIUPD(90507.01,IEN,.02)=VAL
 . I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 . ;
 . S RP=0
 . F  S RP=$O(^BQI(90507,REG,20,RP)) Q:'RP  D
 .. S N=0
 .. F  S N=$O(^BQI(90507,REG,20,RP,10,N)) Q:'N  D
 ... S X=$P(^BQI(90507,REG,20,RP,10,N,0),U,1)
 ... S IEN=N_","_RP_","_REG_","
 ... S TIEN=$O(^BQI(90507,REG,10,"B",X,""))
 ... I $P(^BQI(90507,REG,10,TIEN,0),U,5)="T" S VAL=$$STXPT(X,"L")
 ... E  S VAL=$$STXPT(X,"N")
 ... S BQIUPD(90507.03,IEN,.02)=VAL
 . I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 ; Set BTPWRPC into BQIRPC
 NEW IEN,DA,X,DIC,Y
 S DA(1)=$$FIND1^DIC(19,"","B","BQIRPC","","","ERROR"),DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LMNZ"
 S X="BTPWRPC"
 D ^DIC I +Y<1 K DO,DD D FILE^DICN
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
 ;
ARV ;
 ;;0|BQIHSTA^^ARV Stability^^90451.01^45^^T02048BQIHSTA^^^^^^^^1~3|6^^^D^12~5|
 ;;0|BKMHSCOM^^ARV Stability Comment^^90451.145^20^^T01024BKMHSCOM^^^^^^^^1~1|S VAL=$$HIVM^BQIRGUTL(DFN,45,FLD,4) I VAL'=""!($G(MVALUE)'="") S VAL=$$HIVS^BQIRGUTL(VAL,MVALUE,"; ")~3|6^^^O^^^^D~5|
 ;;0|BKMHSDT^^ARV Stability Date^^90451.145^.01^^D00015BKMHSDT^^^^^^^^1~1|~3|6^^^O^^^^D~5|
 ;;0|BKMHSRG^^ARV Stability Regimen^^90451.145^.03^^T00030BKMHSRG^^^^^^^^1~1|S VAL=$$HIVM^BQIRGUTL(DFN,45,FLD,.03) I VAL'="" S VAL=$$HIVS^BQIRGUTL(VAL,MVALUE,"; ")~3|6^^^O^^^^D~5|
 ;;0|BKMHSST^^ARV Stability Status^^90451.145^.02^^T00030BKMHSST^^^^^^^^1~1|S VAL=$$HIVM^BQIRGUTL(DFN,45,FLD,.02) I VAL'="" S VAL=$$HIVS^BQIRGUTL(VAL,MVALUE,"; ")~3|6^^^O^^^^D~5|
 ;;0|BKMHSWHN^^ARV Stability Last Edited Date^^90451.145^.05^^D00030BKMHSWHN~1|S VAL=$P($$HIVM^BQIRGUTL(DFN,45,FLD,.05)," ",1,2) I VAL'="" S VAL=$$HIVS^BQIRGUTL(VAL,MVALUE,"; ")~3|6^^^O^^^^D~5|
 ;;0|BKMHSWHO^^ARV Stability Last Edited By^^90451.145^.04^^T00035BKMHSWHO^^^^^^^^~1|S VAL=$$HIVM^BQIRGUTL(DFN,45,FLD,.04) I VAL'="" S VAL=$$HIVS^BQIRGUTL(VAL,MVALUE,"; "),MVALUE=$$STRIP^BQIRGUTL(MVALUE_VAL,"; "),VAL=""~3|6^^^O^^^^D~5|
 ;;0|REMMETH^^Communication Preference^^9000001^4002^^T00010REMMETH~1|~3|1^^Demographics^O^35~5|
 ;;0|PFLANG^^Preferred Language^^^^^T00050PFLANG~1|S VAL=$$PFLNG^BQIULPT(DFN)~3|1^^Demographics^O^36~5|
 ;;0|ALGY^^Allergies^^^^^T01024ALGY^^^^^^^125~1|S VAL=$$ALG^BQIPTALG(DFN)~3|1^^Other Patient Data^O^37~5|
 ;;
