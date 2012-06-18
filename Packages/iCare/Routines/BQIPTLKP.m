BQIPTLKP ;PRXM/HC/ALA-Patient Lookup ; 29 Oct 2005  6:51 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
FND(DATA,TEXT,TYPE) ; EP -- BQI LOOKUP PATIENTS
 ;
 ;Description - Find a list of patients based on search criteria
 ;Input
 ;  TEXT - Search text which can include name, SSN, HRN, etc.
 ;  TYPE - Search type, a code indicating which type of search
 ;Output
 ;  DATA
 ;
 NEW UID,II,FILE,FIELD,XREF,FLAGS,NUMB,SCREEN,BN,DFN,NAME,HRN
 NEW DOB,DOD,AL,ALFLG,X,SSN,SENS,ALIAS,NODE
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIPTLK",UID))
 ; NOTE: Since "DILIST" is used by the DIC calls it must use $J and not UID.
 K @DATA,^TMP("DILIST",$J)
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIPTLKP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S TYPE=$G(TYPE,"")
 ; determine if the data text is in a date format that can be converted to
 ; FileMan date, then this is probably a date of birth search
 I $L(TEXT),$L(TEXT)<7,TEXT'?6AP S TYPE="H"
 I TEXT?1A.AN S TYPE=""
 I $$DATE^BQIUL1(TEXT)'="",$L(TEXT)>6 S TEXT=$$DATE^BQIUL1(TEXT),TYPE="D"
 ; If user enter spaces after comma, strip extraneous spaces
 S TEXT=$$REMDBL^XLFNAME1(TEXT," ")
 I TEXT?.E1", ".E D
 . S TEXT=$P(TEXT,", ")_","_$P(TEXT,", ",2,999)
 ;
 S @DATA@(II)="I00010DFN^T00030PATIENT_NAME^T00015HRN^T00009SSN^D00030DOB^D00030DOD^T00001ALIAS_FLAG^T00001SENS_FLAG"_$C(30)
 ;
 ;  if no type of search was passed, the lookup will have to be through all cross-references
 I TYPE="" D
 . ; Change text to all uppercase
 . S TEXT=$$UP^XLFSTR(TEXT)
 . S FILE=9000001,FIELD=".01",XREF="",FLAGS="MP",NUMB="*" ; Changed from "CMP" to "MP"
 . ;S SCREEN=$S(+DUZ(2):"I '$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)",1:"")
 . D LKUP
 ;
 ;  if the type is 'N', lookup only in the patient name cross-reference
 I TYPE="N" D
 . S FILE=2,FIELD=.01,XREF="B",FLAGS="P",NUMB="*" ; Changed from "CP" to "P"
 . ;S SCREEN=$S(+DUZ(2):"I '$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)",1:"")
 . D LKUP
 ;
 ;  if the type is 'S', lookup only in the social security cross-reference
 I TYPE="S" D
 . S FILE=2,FIELD=.09,XREF="SSN",FLAGS="P",NUMB="*"
 . ;S SCREEN=$S(+DUZ(2):"I '$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)",1:"")
 . D LKUP
 ;
 ;  if the type is 'D', lookup only in the date of birth cross-reference
 I TYPE="D" D
 . S FILE=2,FIELD=.03,XREF="ADOB",FLAGS="P",NUMB="*"
 . ;S SCREEN=$S(+DUZ(2):"I '$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)",1:"")
 . D LKUP
 ;
 ;  if the type is 'H', lookup only in the health record number cross-reference
 I TYPE="H" D
 . S BN=0,DFN=""
 . F  S DFN=$O(^AUPNPAT("D",TEXT,DFN)) Q:DFN=""  D
 .. S LOC=0
 .. F  S LOC=$O(^AUPNPAT(DFN,41,LOC)) Q:'LOC  D
 ... I $P($G(^AUPNPAT(DFN,41,LOC,0)),U,3)'="" Q
 ... I $P($G(^AUPNPAT(DFN,41,LOC,0)),U,2)'=TEXT Q
 ... S BN=BN+1,$P(^TMP("DILIST",$J,BN,0),"^",1)=DFN
 ... S $P(^TMP("DILIST",$J,BN,0),"^",2)=$$GET1^DIQ(9000001,DFN_",",.01,"E")
 ;
 ; For each patient found in the search, get the list data
 S BN=0 F  S BN=$O(^TMP("DILIST",$J,BN)) Q:'BN  D
 . S DFN=$P(^TMP("DILIST",$J,BN,0),"^",1)
 . S NAME=$$GET1^DIQ(9000001,DFN_",",.01,"E")
 . S HRN=$$HRNL^BQIULPT(DFN),SSN=$$GET1^DIQ(2,DFN_",",.09,"E")
 . I '$D(^XUSEC("AGZVIEWSSN",DUZ)),SSN'["P",SSN'="" S SSN="XXX-XX-"_$E(SSN,6,9)
 . S DOB=$$FMTE^BQIUL1($$GET1^DIQ(2,DFN_",",.03,"I"))
 . S DOD=$$FMTE^BQIUL1($$GET1^DIQ(2,DFN_",",.351,"I"))
 . S AL=0,ALFLG="N" D
 .. S AL=$O(^DPT(DFN,.01,AL)) Q:'AL  S ALFLG="Y"
 . S SENS=$$SENS^BQIULPT(DFN)
 . S ALIAS=""
 . ; Are we displaying an alias?
 . ; If there's no match on the patient's name and it isn't an alias it's a bad cross reference
 . ; If this is an alias it should sort after name matches (add one million to counter)
 . I TYPE'="H",TEXT?1A.E,$E(NAME,1,$L(TEXT))'=TEXT S ALIAS=$$ALIAS(DFN,TEXT) I 'ALIAS Q
 . S II=II+1,NODE=$S(ALIAS:1000000+II,1:II)
 . S @DATA@(NODE)=DFN_"^"_NAME_"^"_HRN_"^"_SSN_"^"_DOB_"^"_DOD_"^"_ALFLG_"^"_SENS_$C(30)
 ;
DONE ;
 S II=II+1,@DATA@(1000000+II)=$C(31)
 K ^TMP("DILIST",$J)
 Q
 ;
LKUP ;
 D FIND^DIC(FILE,"",FIELD,FLAGS,TEXT,"",XREF,$G(SCREEN),"","","ERROR")
 Q
 ;
ALIAS(PTIEN,TEXT) ;EP
 ; Does this patient's alias match the TEXT?
 N IEN,ALIAS,ALFND
 S IEN=0,ALFND=""
 F  S IEN=$O(^DPT(PTIEN,.01,IEN)) Q:'IEN!ALFND  D
 . S ALIAS=$$GET1^DIQ(2.01,IEN_","_PTIEN_",",.01,"E")
 . I $E(ALIAS,1,$L(TEXT))=TEXT S ALFND=1
 Q ALFND
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(1000000+II)=$C(31)
 Q
