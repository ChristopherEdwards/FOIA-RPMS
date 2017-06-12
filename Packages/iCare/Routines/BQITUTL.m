BQITUTL ;PRXM/HC/ALA-Diagnoses Category Utility Program ; 02 Mar 2006  1:21 PM
 ;;2.4;ICARE MANAGEMENT SYSTEM;;Apr 01, 2015;Build 41
 Q
 ;
BLD(TAX,REF,BQTTYP) ;PEP - Build a taxonomy
 NEW BQTXN
 ;Input
 ;  TAX - Taxonomy name
 ;  REF - reference where list will reside
 I '$$PATCH^XPDUTL("ATX*5.1*11") D BLDTAX^BQITUIX(TAX,REF) Q
 S BQTTYP=$G(BQTTYP,"")
 I BQTTYP="" D
 . S BQQN=$O(^BQI(90508,1,10,"B",TAX,""))
 . I BQQN'="" S BQQY=$P(^BQI(90508,1,10,BQQN,0),U,3)
 . S BQTTYP=$S($G(BQQY)=5:"L",1:"")
 I BQTTYP="L" S BQTXN=$O(^ATXLAB("B",TAX,""))
 E  S BQTXN=$O(^ATXAX("B",TAX,0))
 I BQTXN="" Q
 D BLDTAX^ATXAPI(TAX,REF,BQTXN,BQTTYP)
 K BQTTYP,BQQY
 Q
 ;
BLDSV(FILEREF,VAL,TARGET) ;PEP - Add a single value to a taxonomy
 ;Description
 ;  Use this if no taxonomy was given but an individual code
 ;Input
 ;  FILEREF - File where the code resides
 ;  VAL - Value
 ;  TARGET - reference where entry is to be placed
 ;
 ; The LOINC x-ref in LAB does not use the check digit (piece 2).
 I FILEREF=95.3 S FILE="^LAB(60)",INDEX="AF",VAL=$P(VAL,"-")
 I FILEREF=80 S FILE="^ICD9",INDEX="BA"
 I FILEREF=80.1 S FILE="^ICD0",INDEX="BA"
 I FILEREF=81 S FILE="^ICPT",INDEX="BA"
 S END=VAL
 ;
 ; Backup one entry so loop can find all the entries in the range.
 S VAL=$O(@FILE@(INDEX,VAL),-1)
 F  S VAL=$O(@FILE@(INDEX,VAL)) Q:VAL=""  Q:$$CHECK(VAL,END)  D
 .S IEN=""
 .F  S IEN=$O(@FILE@(INDEX,VAL,IEN)) Q:IEN=""  D
 ..S NAME=$P($G(@FILE@(IEN,0)),U,1)
 ..S @TARGET@(IEN)=NAME
 ;
 K FILEREF,FILE,INDEX,VAL,END,NAME,IEN,TARGET
 Q
 ;
SNOM(SUB,REF) ;PEP - Build a SNOMED subset
 NEW BQIOK,TTREF
 S TTREF=$NA(^TMP("BQISNOM",$J)) K @TTREF
 S BQIOK=$$SUBLST^BSTSAPI(TTREF,SUB_"^36^1")
 S BQN="" F  S BQN=$O(@TTREF@(BQN)) Q:BQN=""  S CID=$P(@TTREF@(BQN),U,1),@REF@(CID)=$P(@TTREF@(BQN),U,3)
 K @TTREF
 Q
 ;
CHECK(V,E) ;EP
 N Z
 I V=E Q 0
 S Z(V)=""
 S Z(E)=""
 I $O(Z(""))=E Q 1
 Q 0
 ;
ARY(DEF,REF) ;EP - Build an array from a definition
 ;Input
 ;  DEF - Definition name
 ;  REF - array name
 ;
 NEW IEN,BN,BDXN,DIC,X,Y,DATA
 S DIC(0)="NZ",X=DEF,DIC="^BQI(90506.2,"
 D ^DIC
 S BDXN=+Y I BDXN<1 Q
 ;
 S BN=0
 F  S BN=$O(^BQI(90506.2,BDXN,5,"B",BN)) Q:'BN  D
 . S IEN=0
 . F  S IEN=$O(^BQI(90506.2,BDXN,5,"B",BN,IEN)) Q:'IEN  D
 .. S DATA=^BQI(90506.2,BDXN,5,IEN,0)
 .. ; If the taxonomy check only flag is set, do not include
 .. I $P(DATA,U,11)=1 Q
 .. ; Exclude the SEARCH ORDER field and only take pieces 2-10
 .. S @REF@(BN)=$P(DATA,U,2,10)
 Q
 ;
GDF(BQDN,BQREF) ;EP - Get basic Definition information
 ;  used mainly for the subdefinitions which can be called
 ;  by the code in the main diagnosis category executable program
 ;
 ;Input
 ;  BQDN  - Diag Cat definition internal entry number
 ;  BQREF - Array reference
 ;Output
 ;  BQDEF  - Definition name
 ;  BQEXEC - Diag Cat special executable program
 ;  BQPRG  - Diag Cat standard executable program
 ;  BQGLB  - Temporary global reference
 ;
 ;  If it's inactive, ignore
 I $$GET1^DIQ(90506.2,BQDN_",",.03,"I")=1 Q
 S BQDEF=$$GET1^DIQ(90506.2,BQDN_",",.01,"E")
 S BQEXEC=$$GET1^DIQ(90506.2,BQDN_",",1,"E")
 S BQPRG=$$GET1^DIQ(90506.2,BQDN_",",.04,"E")
 ;I $G(BQREF)="" S BQREF="BQIRY"
 K @BQREF
 D ARY(BQDEF,BQREF)
 S BQGLB=$NA(^TMP("BQIPOP",UID))
 K @BQGLB
 Q
 ;
GDXN(DEF) ;EP - Get IEN of a definition
 ;Input
 ;  DEF - Diagnosis Category definition name
 ;Output
 ;  Returns the internal entry number of the category definition
 NEW DIC,X,Y
 S DIC(0)="NZ",X=DEF,DIC="^BQI(90506.2,"
 D ^DIC
 Q +Y
 ;
MEAS(BQDFN,MEAS) ;EP - Get measurement
 NEW VALUE,RVDT,QFL,IEN,RES,VISIT,RESULT,VDATE
 I MEAS'?.N S MEAS=$$FIND1^DIC(9999999.07,,"MX",MEAS)
 S VALUE=0
 S RVDT="",QFL=0
 F  S RVDT=$O(^AUPNVMSR("AA",BQDFN,MEAS,RVDT)) Q:RVDT=""  D  Q:QFL
 . S IEN=""
 . F  S IEN=$O(^AUPNVMSR("AA",BQDFN,MEAS,RVDT,IEN)) Q:IEN=""  D  Q:QFL
 .. S RES=$G(^AUPNVMSR(IEN,0)),VISIT=$P(RES,U,3),RESULT=$P(RES,U,4),VDATE=""
 .. I $P($G(^AUPNVMSR(IEN,2)),U,1)=1 Q
 .. I VISIT'="" S VDATE=$P(^AUPNVSIT(VISIT,0),U,1)\1
 .. S VALUE="1^"_VDATE_U_RESULT_U_VISIT_U_IEN,QFL=1
 Q VALUE
