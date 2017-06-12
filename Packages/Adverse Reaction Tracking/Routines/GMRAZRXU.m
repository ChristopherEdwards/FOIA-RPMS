GMRAZRXU ; IHS/MSC/MGH - RxNorm and UNI code ;04-Feb-2014 16:21;DU
 ;;4.0;Adverse Reaction Tracking;**1007**;Mar 29, 1996;Build 18
 ;
 ;When a new allergy is stored, find the Rxnorm and/or UNI codes to be attached to the allergy and it symptoms
RXNORM(GMRAIEN) ;EP
 N TYPE
 S TYPE=$P($G(^GMR(120.8,GMRAIEN,0)),U,3)
 I $P(TYPE,";",2)="GMRD(120.82," D GMR(GMRAIEN)
 E  D ING(GMRAIEN)
 D SIGNS(GMRAIEN)
 Q
 ;Lookup and set the UNII code associated with this GMR allergy
GMR(GMRAIEN) ;GMR files
 N TXT,ARR,IN,OUT,X,UNII,IEN,ERR,IEN2
 Q:'GMRAIEN
 S TXT=$P($G(^GMR(120.8,GMRAIEN,0)),U,2)
 ;Do Apelon lookup here
 S IN=TXT_U_"32773^^1"
 S X=$$ASSOC^BSTSAPI(IN)
 I $P(X,U,3)'="" D
 . S IEN=GMRAIEN_","
 . S FDA(120.8,IEN,9999999.15)=$P(X,U,3)
 . D UPDATE^DIE(,"FDA","IEN2","ERR")
 Q
 ;Lookup the drug ingredients and store the RxNorm and UNII codes associated with each
ING(GMRAIEN) ;drug ingredients
 N TXT,ARR,IN,OUT,X,RXNORM,UNII,IEN,ERR,ING,VUID,PRIM,RET,AIEN
 S RET=0
 S IEN=0 F  S IEN=$O(^GMR(120.8,GMRAIEN,2,IEN)) Q:'+IEN  D
 .S ING=$P($G(^GMR(120.8,GMRAIEN,2,IEN,0)),U,1)
 .S PRIM=$$GET1^DIQ(50.416,ING,.02,"I")
 .S ING=$P($G(^PS(50.416,ING,0)),U)
 .S AIEN=IEN_","_GMRAIEN_","
 .;Lookup the RxNorm and UNII based on the name
 .S IN=ING_U_"32771^^1"
 .S X=$$ASSOC^BSTSAPI(IN)
 .I $P(X,U,2)'=""!($P(X,U,3)'="") D
 ..I $P(X,U,2)'="" S FDA(120.802,AIEN,9999999.01)=$P(X,U,2)
 ..I $P(X,U,3)'="" S FDA(120.802,AIEN,9999999.02)=$P(X,U,3)
 ..D UPDATE^DIE(,"FDA","IEN2","ERR")
 .I $P(X,U,2)=""&($P(X,U,3)="") D
 ..Q:PRIM=""
 ..S IN=PRIM_U_"32771^^1"
 ..S X=$$ASSOC^BSTSAPI(IN)
 ..I $P(X,U,2)'="" S FDA(120.802,AIEN,9999999.01)=$P(X,U,2)
 ..I $P(X,U,3)'="" S FDA(120.802,AIEN,9999999.02)=$P(X,U,3)
 ..D UPDATE^DIE(,"FDA","IEN2","ERR")
 Q
 ;For signs/symptoms
SIGNS(GMRAIEN) ;signs multiple
 N REACT,X,IN,FNUM,FDA,IEN2,ERR
 S RET=0
 S IEN=0 F  S IEN=$O(^GMR(120.8,GMRAIEN,10,IEN)) Q:'+IEN  D
 .S AIEN=IEN_","_GMRAIEN_","
 .S REACT=$$GET1^DIQ(120.81,AIEN,.01)
 .S IN=REACT_"^32772^^1"
 .S X=$$ASSOC^BSTSAPI(IN)
 .I $P(X,U,1)'="" D
 ..S FNUM=120.81
 ..S FDA(FNUM,AIEN,9999999.12)=$P(X,U,1)
 ..D UPDATE^DIE(,"FDA","IEN2","ERR")
 Q
BACKLOAD ;EP  Backload this data on entire allergy file
 N GMRAIEN,DFN,REACT,TYPE,DATA,EIE
 S GMRAIEN=0  F  S GMRAIEN=$O(^GMR(120.8,GMRAIEN)) Q:'+GMRAIEN  D
 .S DATA=$G(^GMR(120.8,GMRAIEN,0))
 .S DFN=$P(DATA,U),REACT=$P(DATA,U,2),TYPE=$P(DATA,U,3)
 .Q:(DFN="")!(REACT="")!(TYPE="")
 .S EIE=$$GET1^DIQ(120.8,GMRAIEN,22,"I")
 .Q:EIE=1
 .D RXNORM(GMRAIEN)
 Q
