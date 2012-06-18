AGGPTLKP ;VNGT/HS/ALA-Patient Lookup ; 14 Apr 2010  6:58 AM
 ;;1.0;PATIENT REGISTRATION GUI;;Nov 15, 2010
 ;
 ;
 Q
 ;
FND(DATA,TEXT,TYPE,ALL,INAC) ; EP -- AGG LOOKUP PATIENTS
 ;
 ;Description - Find a list of patients based on search criteria
 ;Input
 ;  TEXT - Search text which can include name, SSN, HRN, etc.
 ;  TYPE - Search type, a code indicating which type of search
 ;  ALL  - If blank, search by users division, if '1' search all divisions
 ;  INAC - If blank, exclude inactive patients, if '1' include inactive patients
 ;Output
 ;  DATA
 ;
 NEW UID,II,FILE,FIELD,XREF,FLAGS,NUMB,SCREEN,BN,DFN,NAME,HRN,COMM,AQ
 NEW DOB,DOD,AL,ALFLG,X,SSN,SENS,ALIAS,NODE,DEC,ZZ,TXT,PDATA,HDR,MOMDN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("AGGPTLK",UID))
 ; NOTE: Since "DILIST" is used by the DIC calls it must use $J and not UID.
 K @DATA,^TMP("DILIST",$J)
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^AGGPTLKP D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S TYPE=$G(TYPE,"")
 D HDR
 S @DATA@(II)=HDR_$C(30)
 ; Check to include deceased patients in search
 S DEC=$P($G(^AGFAC(DUZ(2),0)),U,12)
 I TEXT[$C(28) D  G DONE
 . K ZZ
 . F AQ=1:1:$L(TEXT,$C(28)) D
 .. S PDATA=$P(TEXT,$C(28),AQ) Q:PDATA=""
 .. S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 .. D FULL(NAME,VALUE)
 .. S @NAME=VALUE
 . I $D(NARRAY) S PTNAME=$$F^XLFNAME1(.NARRAY,"C")
 . I $G(PTNAME)'="" S TEXT=PTNAME,TYPE="N" D @TYPE,LST2
 . I $G(AGGPTSSN)'="" S TEXT=AGGPTSSN,TYPE="S" D @TYPE,LST2
 . I $G(AGGPTDOB)'="" S TYPE="D",AGGPTDOB=$$DATE^AGGUL1(AGGPTDOB),TEXT=AGGPTDOB D @TYPE,LST2
 . K NARRAY,PTNAME,AGGPTSSN,AGGPTDOB,AGGPTFNM,AGGPTMNM,AGGPTLNM,AGGPTSFX
 . S AQ="" F  S AQ=$O(ZZ(AQ)) Q:AQ=""  S II=II+1,@DATA@(II)=ZZ(AQ)
 . K ZZ
 ;
 ; determine if the data text is in a date format that can be converted to
 ; FileMan date, then this is probably a date of birth search
 I $L(TEXT),$L(TEXT)<7,TEXT'?6AP S TYPE="H"
 I TEXT?1A.AN S TYPE=""
 I $$DATE^AGGUL1(TEXT)'="",$L(TEXT)>6 S TEXT=$$DATE^AGGUL1(TEXT),TYPE="D"
 ; If user enter spaces after comma, strip extraneous spaces
 S TEXT=$$REMDBL^XLFNAME1(TEXT," ")
 I TEXT?.E1", ".E D
 . S TEXT=$P(TEXT,", ")_","_$P(TEXT,", ",2,999)
 ;
 I TYPE'="" D @TYPE D LST G DONE
 ;
 ;  if no type of search was passed, the lookup will have to be through all cross-references
 I TYPE="" D
 . ; Change text to all uppercase
 . S TEXT=$$UP^XLFSTR(TEXT)
 . S FILE=2,FIELD=".01",XREF="",FLAGS="CMP",NUMB="*" ; Changed from "MP" to "CMP"
 . ;S SCREEN=$S(+DUZ(2):"I '$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)",1:"")
 . I $G(ALL)="" S SCREEN=$S(+DUZ(2):"I $D(^AUPNPAT(Y,41,DUZ(2),0)),$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)=""""",1:"")
 . I $G(ALL)'="" S SCREEN=""
 . I $G(INAC)'="" S SCREEN=$S(+DUZ(2):"I $G(^AUPNPAT(Y,41,DUZ(2),0))'=""""",1:"")
 . D LKUP
 D LST
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 K ^TMP("DILIST",$J)
 Q
 ;
N ;  if the type is 'N', lookup only in the patient name cross-reference
 I TYPE="N" D
 . S FILE=2,FIELD=.01,XREF="B",FLAGS="P",NUMB="*" ; Changed from "CP" to "P"
 . ;S SCREEN=$S(+DUZ(2):"I '$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)",1:"")
 . I $G(ALL)="" S SCREEN=$S(+DUZ(2):"I $D(^AUPNPAT(Y,41,DUZ(2),0)),$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)=""""",1:"")
 . I $G(ALL)'="" S SCREEN="",FLAGS="CP"
 . D LKUP
 Q
 ;
S ;  if the type is 'S', lookup only in the social security cross-reference
 I TYPE="S" D
 . S FILE=2,FIELD=.09,XREF="SSN",FLAGS="P",NUMB="*"
 . ;S SCREEN=$S(+DUZ(2):"I '$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)",1:"")
 . I $G(ALL)="" S SCREEN=$S(+DUZ(2):"I $D(^AUPNPAT(Y,41,DUZ(2),0)),$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)=""""",1:"")
 . I $G(ALL)'="" S SCREEN=""
 . D LKUP
 Q
 ;
D ;  if the type is 'D', lookup only in the date of birth cross-reference
 I TYPE="D" D
 . S FILE=2,FIELD="",XREF="ADOB",FLAGS="P",NUMB="*"
 . ;S SCREEN=$S(+DUZ(2):"I '$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)",1:"")
 . I $G(ALL)="" S SCREEN=$S(+DUZ(2):"I $D(^AUPNPAT(Y,41,DUZ(2),0)),$P($G(^AUPNPAT(Y,41,DUZ(2),0)),U,3)=""""",1:"")
 . I $G(ALL)'="" S SCREEN=""
 . D LKUP
 Q
 ;
H ;  if the type is 'H', lookup only in the health record number cross-reference
 I TYPE="H" D
 . S BN=0,DFN=""
 . F  S DFN=$O(^AUPNPAT("D",TEXT,DFN)) Q:DFN=""  D
 .. S LOC=0
 .. F  S LOC=$O(^AUPNPAT(DFN,41,LOC)) Q:'LOC  D
 ... I $P($G(^AUPNPAT(DFN,41,LOC,0)),U,3)'="" Q
 ... I $P($G(^AUPNPAT(DFN,41,LOC,0)),U,2)'=TEXT Q
 ... S BN=BN+1,$P(^TMP("DILIST",$J,BN,0),"^",1)=DFN
 ... S $P(^TMP("DILIST",$J,BN,0),"^",2)=$$GET1^DIQ(9000001,DFN_",",.01,"E")
 Q
 ;
LST ; For each patient found in the search, get the list data
 S BN=0 F  S BN=$O(^TMP("DILIST",$J,BN)) Q:'BN  D
 . S DFN=$P(^TMP("DILIST",$J,BN,0),"^",1)
 . S NAME=$$GET1^DIQ(9000001,DFN_",",.01,"E")
 . S HRN=$$HRN^AGGUL1(DFN),INACTIVE="N"
 . I $G(INAC)'="",HRN["*" S INACTIVE="Y"
 . I $G(ALL)=1 S HRN=$$HRNL^AGGUL2(DFN)
 . S SSN=$P(^DPT(DFN,0),U,9)
 . I '$D(^XUSEC("AGZVIEWSSN",DUZ)),SSN'["P",$G(ALL)'=1,SSN'="" S SSN="XXX-XX-"_$E(SSN,6,9)
 . S DOB=$$FMTE^AGGUL1($$GET1^DIQ(2,DFN_",",.03,"I"))
 . S DOD=$$FMTE^AGGUL1($$GET1^DIQ(2,DFN_",",.351,"I"))
 . ; if Date of Death and DECEASED PATIENTS in look-ups field is not YES, quit
 . I DEC'="Y",DOD'="" Q
 . S SENS=$E($$SENS^AGGUL1(DFN),1,1)
 . I $P($G(^AGFAC(DUZ(2),0)),U,11)="Y" S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"E"),MOMDN=$$GET1^DIQ(2,DFN_",",.2403,"E")
 . S ALIAS=""
 . ; Are we displaying an alias?
 . ; If there's no match on the patient's name and it isn't an alias it's a bad cross reference
 . ; If this is an alias it should sort after name matches (add one million to counter)
 . ;I TYPE'="H",TEXT?1A.E,$E(NAME,1,$L(TEXT))'=TEXT S ALIAS=$$ALIAS(DFN,TEXT) I 'ALIAS Q
 . ;S II=II+1,NODE=$S(ALIAS:1000000+II,1:II)
 . S ALIAS=$$ALLST(DFN)
 . S II=II+1
 . I $P($G(^AGFAC(DUZ(2),0)),U,11)="Y",$G(ALL)=1 S @DATA@(II)=DFN_U_NAME_U_HRN_U_SSN_U_DOB_U_DOD_U_SENS_U_ALIAS_U_INACTIVE_U_COMM_U_MOMDN_$C(30) Q
 . S @DATA@(II)=DFN_U_NAME_U_HRN_U_SSN_U_DOB_U_DOD_U_SENS_U_ALIAS_U_INACTIVE_$C(30)
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
ALLST(PTIEN) ;EP - List of Aliases
 NEW IEN,ALIAS,ANAM
 S ALIAS=""
 S IEN=0
 F  S IEN=$O(^DPT(PTIEN,.01,IEN)) Q:'IEN  D
 . S ANAM=$$GET1^DIQ(2.01,IEN_","_PTIEN_",",.01,"E")
 . S ALIAS=ALIAS_ANAM_"; "
 Q $$TKO^AGGUL1(ALIAS,"; ")
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
HDR ;
 S HDR="I00010DFN^T00030PATIENT_NAME^T00030HRN^T00009SSN^D00030DOB^D00030DOD^T00003SENS_FLAG^T01024ALIAS^T00001INACTIVE"
 I $P($G(^AGFAC(DUZ(2),0)),U,11)="Y",$G(ALL)=1 S HDR=HDR_"^T00030COMM^T00030MOMDN"
 Q
 ;
FULL(NAME,VALUE) ; Full Name
 I NAME="AGGPTLNM" S NARRAY("FAMILY")=VALUE
 I NAME="AGGPTFNM" S NARRAY("GIVEN")=VALUE
 I NAME="AGGPTMNM" S NARRAY("MIDDLE")=VALUE
 I NAME="AGGPTSFX" S NARRAY("SUFFIX")=VALUE
 F TXT="FAMILY","GIVEN","MIDDLE","SUFFIX" I $G(NARRAY(TXT))="" S NARRAY(TXT)=""
 Q
 ;
LST2 ; For each patient found in the search, get the list data
 S BN=0 F  S BN=$O(^TMP("DILIST",$J,BN)) Q:'BN  D
 . S DFN=$P(^TMP("DILIST",$J,BN,0),"^",1)
 . S NAME=$$GET1^DIQ(9000001,DFN_",",.01,"E")
 . S HRN=$$HRN^AGGUL1(DFN),INACTIVE="N"
 . I $G(INAC)'="",HRN["*" S INACTIVE="Y"
 . I $G(ALL)=1 S HRN=$$HRNL^AGGUL2(DFN)
 . S SSN=$P(^DPT(DFN,0),U,9)
 . I '$D(^XUSEC("AGZVIEWSSN",DUZ)),SSN'["P",$G(ALL)'=1 S SSN="XXX-XX-"_$E(SSN,6,9)
 . S DOB=$$FMTE^AGGUL1($$GET1^DIQ(2,DFN_",",.03,"I"))
 . S DOD=$$FMTE^AGGUL1($$GET1^DIQ(2,DFN_",",.351,"I"))
 . ; if Date of Death and DECEASED PATIENTS in look-ups field is not YES, quit
 . I DEC'="Y",DOD'="" Q
 . S SENS=$$SENS^AGGUL1(DFN)
 . I $P($G(^AGFAC(DUZ(2),0)),U,11)="Y" S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"E"),MOMDN=$$GET1^DIQ(2,DFN_",",.2403,"E")
 . S ALIAS=$$ALLST(DFN)
 . ; Are we displaying an alias?
 . ; If there's no match on the patient's name and it isn't an alias it's a bad cross reference
 . ; If this is an alias it should sort after name matches (add one million to counter)
 . ;I TYPE'="H",TEXT?1A.E,$E(NAME,1,$L(TEXT))'=TEXT S ALIAS=$$ALIAS(DFN,TEXT) I 'ALIAS Q
 . S ZZ(DFN)=""
 . I $P($G(^AGFAC(DUZ(2),0)),U,11)="Y",$G(ALL)=1 S ZZ(DFN)=DFN_"^"_NAME_"^"_HRN_"^"_SSN_"^"_DOB_"^"_DOD_"^"_SENS_"^"_ALIAS_"^"_INACTIVE_"^"_COMM_"^"_MOMDN_$C(30) Q
 . S ZZ(DFN)=DFN_"^"_NAME_"^"_HRN_"^"_SSN_"^"_DOB_"^"_DOD_"^"_SENS_"^"_ALIAS_"^"_INACTIVE_$C(30)
 Q
