BQITRADD ;APTIV/HC/ALA-Add Treatment Prompt API ; 23 Jan 2008  11:50 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ;
NON(DTAG,NAME,PRI,RMK,EXEC) ;EP - Non-interactive entry point API
 ; Input
 ;   DTAG - Diagnosis Tag
 ;   NAME - Treatment Prompt name
 ;   PRI  - Priority
 ;   RMK  - Remarks an array of sequential numbers RMK(1)=text,RMK(2)=text
 ;   EXEC - Executable
 ;
 NEW PRE,DIC,X,DA,BQIUPD,ERROR,IENS,FDA,BQIEN,DIK,Y
 S DTAG=$G(DTAG,""),NAME=$G(NAME,""),PRI=$G(PRI,"")
 I DTAG?.N I $G(^BQI(90506.2,DTAG,0))="" Q "-1^Tag not found"
 I DTAG'?.N S DTAG=$O(^BQI(90506.2,"B",DTAG,""))
 I DTAG="" Q "-1^Tag not found"
 ;
 S PRE=$P(^BQI(90506.2,DTAG,0),U,9) S:PRE="" PRE=$P(^(0),U,7)
 I $E(NAME,1,$L(PRE))'=PRE S NAME=PRE_" "_NAME
 I $O(^BQI(90508.5,"B",NAME,""))'="" Q "-1^Treatment prompt name already exists"
 ;
 S DIC="^BQI(90508.5,",DIC(0)="LMNZ",X=NAME
 D ^DIC
 S DA=+Y I DA=-1 Q DA_U_"Not able to create entry for "_NAME
 I $O(^BQI(90508.5,"AD",DTAG,PRI,""))'="" D DEL(DA) Q "-1^This priority already exists. Please try again."
 S BQIUPD(90508.5,DA_",",.02)=DTAG
 S BQIUPD(90508.5,DA_",",.03)=PRI
 D FILE^DIE("","BQIUPD","ERROR")
 I $D(ERROR)>0 D DEL(DA) Q "-1^"_$G(ERROR("DIERR",1,"TEXT",1))
 I '$D(RMK) Q "-1^Need remarks for treatment prompt"
 D WP^DIE(90508.5,DA_",",1,"","RMK","ERROR")
 I $D(ERROR)>0 D DEL(DA) Q "-1^"_$G(ERROR("DIERR",1,"TEXT",1))
 I $G(EXEC)="" D DEL(DA) Q "-1^No executable entered"
 K FDA
 S IENS="+1,"_DA_","
 S FDA(90508.55,IENS,.01)=1
 S FDA(90508.55,IENS,1)=EXEC
 D UPDATE^DIE("","FDA","BQIEN","ERROR")
 I $D(ERROR) D DEL(DA) Q "-1^"_$G(ERROR("DIERR",1,"TEXT",1))
 Q 1
 ;
DEL(DA) ; Delete entry
 NEW DIK
 S DIK="^BQI(90508.5,"
 D ^DIK
 Q
