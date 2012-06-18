BQITUTL ;PRXM/HC/ALA-Diagnoses Category Utility Program ; 02 Mar 2006  1:21 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
BLD(TAX,REF) ;EP - Build a taxonomy
 ;Input
 ;  TAX - Taxonomy name
 ;  REF - reference where list will reside
 D BLDTAX^BQITUIX(TAX,REF)
 Q
 ;
BLDSV(FILEREF,VAL,TARGET) ;EP - Add a single value to a taxonomy
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
