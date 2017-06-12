BSTSRPC ;GDIT/HS/BEE - SNOMED Utilities - RPC Search ; 10 Aug 2012  9:24 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**3,7,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
SEARCH(DATA,SEARCH,PC) ;EP - BSTS SNOMED SEARCH
 ;
 ;Description
 ;  Returns a list of SNOMED CT Terms matching the specified search string
 ;  
 ;Input
 ;  SEARCH - The string to search on
 ;      PC - Return Parent/Children
 ;
 ;Output
 ;  ^TMP("BSTSRPC") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 N UID,BSTSII,SVAR,STS,II,%D,NMID
 ;
 S SEARCH=$TR(SEARCH,"|","^")
 S $P(SEARCH,U,5)=""
 S PC=$G(PC)
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BSTSRPC",UID))
 S SVAR=$NA(^TMP("BSTSRPC1",UID))
 K @DATA,@SVAR
 ;
 S BSTSII=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSRPC D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 D HDR
 ;
 ;Validate input
 I $G(SEARCH)="" G DONE
 ;
 ;Perform lookup
 S NMID=$P(SEARCH,U,3) S:NMID="" NMID=36
 S STS=$$SEARCH^BSTSAPI(SVAR,SEARCH)
 ;
 ;Output Results
 S II=0 F  S II=$O(@SVAR@(II)) Q:II=""  D
 . NEW PRBD,PRBT,CONC,DTS,FSND,FSNT,PRED,PRET,CHD
 . NEW ISA,ICD,SUB,SYN,MICD,D10,ISHDR,LAT,DFSTS,REPI
 . ;
 . ;Problem Description and Term
 . S PRBD=$G(@SVAR@(II,"PRB","DSC"))
 . S PRBT=$G(@SVAR@(II,"PRB","TRM"))
 . S CONC=$G(@SVAR@(II,"CON"))
 . S DTS=$G(@SVAR@(II,"DTS"))
 . S FSND=$G(@SVAR@(II,"FSN","DSC"))
 . S FSNT=$G(@SVAR@(II,"FSN","TRM"))
 . S PRED=$G(@SVAR@(II,"PRE","DSC"))
 . S PRET=$G(@SVAR@(II,"PRE","TRM"))
 . S ISHDR=$S(PRED=PRBD:"",1:"S")
 . S LAT=$S($G(@SVAR@(II,"LAT"))=1:1,1:0)
 . S DFSTS=$G(@SVAR@(II,"STS"))
 . S REPI=$S($G(@SVAR@(II,"EPI"))=1:1,1:0)
 . ;
 . ;ICD
 . S ICD="" I $D(@SVAR@(II,"ICD")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@SVAR@(II,"ICD",ICNT)) Q:ICNT=""  D
 ... NEW ICDE
 ... S ICDE=$G(@SVAR@(II,"ICD",ICNT,"COD"))
 ... S ICD=ICD_$S(ICD]"":$C(28),1:"")_ICDE
 . ;
 . ;ICD10
 . S D10=""
 . ;
 . ;Subsets
 . S SUB="" I $D(@SVAR@(II,"SUB")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@SVAR@(II,"SUB",ICNT)) Q:ICNT=""  D
 ... NEW SB
 ... S SB=$G(@SVAR@(II,"SUB",ICNT,"SUB"))
 ... S SUB=SUB_$S(SUB]"":$C(28),1:"")_SB
 . ;
 . ;Synonyms
 . S SYN=PRED_$C(29)_PRET_$C(29)_"Preferred"_$C(29)_"1" I $D(@SVAR@(II,"SYN")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@SVAR@(II,"SYN",ICNT)) Q:ICNT=""  D
 ... NEW TRM,DSC
 ... S TRM=$G(@SVAR@(II,"SYN",ICNT,"TRM"))
 ... S DSC=$G(@SVAR@(II,"SYN",ICNT,"DSC"))
 ... S SYN=SYN_$S(SYN]"":$C(28),1:"")_DSC_$C(29)_TRM_$C(29)_"Synonym"_$C(29)_2
 . ;
 . ;ISA
 . S ISA="" I $D(@SVAR@(II,"ISA")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@SVAR@(II,"ISA",ICNT)) Q:ICNT=""  D
 ... NEW DTS,CON,TRM,CIEN
 ... S DTS=$G(@SVAR@(II,"ISA",ICNT,"DTS")) Q:DTS=""
 ... S CON=$G(@SVAR@(II,"ISA",ICNT,"CON"))
 ... S TRM=$G(@SVAR@(II,"ISA",ICNT,"TRM"))
 ... S ISA=ISA_$S(ISA]"":$C(28),1:"")_DTS_$C(29)_CON_$C(29)_TRM
 ... ;
 ... ;BSTSv2.0;Added parents to expansion list
 ... Q:'PC
 ... S CIEN=$O(^BSTS(9002318.4,"D",NMID,DTS,"")) Q:CIEN=""
 ... I $$GET1^DIQ(9002318.4,CIEN_",",".03","I")'="P",$$GET1^DIQ(9002318.4,CIEN_",",".15","I")="" Q
 ... S SYN=SYN_$S(SYN]"":$C(28),1:"")_DTS_$C(29)_TRM_$C(29)_"Parent"_$C(29)_3
 . ;
 . ;BSTSv2.0;Added children to expansion list
 . ;Children
 . I PC S CHD="" I $D(@SVAR@(II,"CHD")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@SVAR@(II,"CHD",ICNT)) Q:ICNT=""  D
 ... NEW DTS,CON,TRM,CIEN
 ... S DTS=$G(@SVAR@(II,"CHD",ICNT,"DTS")) Q:DTS=""
 ... S CON=$G(@SVAR@(II,"CHD",ICNT,"CON"))
 ... S TRM=$G(@SVAR@(II,"CHD",ICNT,"TRM"))
 ... ;
 ... ;BSTSv2.0;Added parents to expansion list
 ... S CIEN=$O(^BSTS(9002318.4,"D",NMID,DTS,"")) Q:CIEN=""
 ... I $$GET1^DIQ(9002318.4,CIEN_",",".03","I")'="P",$$GET1^DIQ(9002318.4,CIEN_",",".15","I")="" Q
 ... S SYN=SYN_$S(SYN]"":$C(28),1:"")_DTS_$C(29)_TRM_$C(29)_"Child"_$C(29)_4
 . ;
 . S MICD=ICD
 . ;Save entry
 . S BSTSII=BSTSII+1,@DATA@(BSTSII)=PRBD_U_PRBT_U_PRED_U_PRET_U_CONC_U_DTS_U_FSND_U_FSNT_U_ISA
 . S @DATA@(BSTSII)=@DATA@(BSTSII)_U_ICD_U_SUB_U_D10_U_SYN_U_ISHDR_U_MICD_U_LAT_U_DFSTS_U_REPI_$C(30)
 ;
DONE ;
 S BSTSII=BSTSII+1,@DATA@(BSTSII)=$C(31)
 Q
 ;
USEARCH(DATA,SEARCH) ;EP - BSTS SNOMED UNIVERSE SEARCH
 ;
 ;BSTS*1.0*8;Moved to new routine to free up space
 D USEARCH^BSTSRPCU(.DATA,.SEARCH)
 Q
 ;
ICD2SMD(DATA,INPUT) ;EP - BSTS ICD9 TO SNOMED
 ;
 ;Description
 ;  Returns a list of SNOMED CT Terms matching the specified ICD9 code
 ;  
 ;Input
 ;  INPUT - "|" Delimited string
 ;          [1] ICD9 Code 
 ;          [2] Subset(s) (Optional) - Include only concepts in these subsets
 ;                                     (multiple subsets delimited by "~")
 ;
 ;Output
 ;  ^TMP("BSTSRPC") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 N UID,BSTSII,SVAR,STS,II,SUBSETS,SNAPDT,%D
 ;
 S INPUT=$G(INPUT,"")
 S INPUT=$TR(INPUT,"|","^")
 ;
 ;Strip off trailing "."
 S $P(INPUT,U)=$$TKO^BSTSUTIL($P(INPUT,U),".")
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BSTSRPC",UID))
 ;S SVAR=$NA(^TMP("BSTSRPC1",UID))  ;Switch to local
 K @DATA
 ;
 S BSTSII=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSRPC D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 D IHDR
 ;
 ;Validate input
 I $P(INPUT,U)="" G IDONE
 S SUBSETS=$P(INPUT,U,2) S:SUBSETS]"" SUBSETS="~"_SUBSETS_"~"
 S SNAPDT=$P(INPUT,U,3)
 ;
 ;Perform lookup - ICD9
 I $E($P(INPUT,U),1)'="?" S STS=$$ICD2SMD^BSTSAPI("SVAR",$P(INPUT,U)_"^BCIX^")
 ;
 ;Perform lookup - Text
 I $E($P(INPUT,U),1)="?" D
 . NEW STRING
 . S STRING=$E($P(INPUT,U),2,9999)
 . S STS=$$SEARCH^BSTSAPI("SVAR",STRING_"^F^^^^^BCIX")
 ;
 ;Output Results
 S II=0 F  S II=$O(SVAR(II)) Q:II=""  D
 . NEW CONC,DESC,PTERM,REL,SCHK,SUB,ICD
 . ;
 . ;Perform subset check to see it this Concept should be returned
 . S SCHK=0 I SUBSETS]"",$D(SVAR(II,"SUB")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(SVAR(II,"SUB",ICNT)) Q:ICNT=""  D
 ... NEW SB
 ... S SB=$G(SVAR(II,"SUB",ICNT,"SUB"))
 ... I SUBSETS[("~"_SB_"~") S SCHK=1
 . I SUBSETS]"",'SCHK Q
 . ;
 . ;Get Concept ID
 . S CONC=$G(SVAR(II,"CON")) Q:CONC=""
 . ;
 . ;Get Description Id of Preferred Term
 . S DESC=$G(SVAR(II,"PRB","DSC")) Q:DESC=""
 . ;
 . ;Get Preferred Term
 . S PTERM=$G(SVAR(II,"PRB","TRM")) Q:PTERM=""
 . ;
 . ;ICD9
 . S ICD="" I $D(SVAR(II,"ICD")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(SVAR(II,"ICD",ICNT)) Q:ICNT=""  D
 ... NEW ICDE
 ... S ICDE=$G(SVAR(II,"IC9",ICNT,"COD"))
 ... S ICD=ICD_$S(ICD]"":$C(28),1:"")_ICDE
 . ;
 . ;Initialize Relations Value
 . S REL=""
 . ;
 . ;Subsets
 . S SUB="" I $D(SVAR(II,"SUB")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(SVAR(II,"SUB",ICNT)) Q:ICNT=""  D
 ... NEW SB
 ... S SB=$G(SVAR(II,"SUB",ICNT,"SUB"))
 ... S SUB=SUB_$S(SUB]"":$C(28),1:"")_SB
 . ;
 . ;Get ISA (Parents) first
 . I $D(SVAR(II,"ISA")) D
 .. NEW ICNT,PICD
 .. S ICNT="" F  S ICNT=$O(SVAR(II,"ISA",ICNT)) Q:ICNT=""  D
 ... NEW DTS,PDSC,PTRM,VR,STS,PCNC,SCHK
 ... ;
 ... ;Pull DTSId of Parent
 ... S DTS=$G(SVAR(II,"ISA",ICNT,"DTS")) Q:DTS=""
 ... ;
 ... ;Look up entry
 ... S STS=$$DTSLKP^BSTSAPI("VR",DTS_"^^^1")
 ... ;
 ... ;Perform subset check to see it this Concept should be returned
 ... S SCHK=0 I SUBSETS]"",$D(VR(1,"SUB")) D
 .... NEW ICNT
 .... S ICNT="" F  S ICNT=$O(VR(1,"SUB",ICNT)) Q:ICNT=""  D
 ..... NEW SB
 ..... S SB=$G(VR(1,"SUB",ICNT,"SUB"))
 ..... I SUBSETS[("~"_SB_"~") S SCHK=1
 ... I SUBSETS]"",'SCHK Q
 ... ;
 ... S PDSC=$G(VR(1,"PRE","DSC")) Q:PDSC=""
 ... S PTRM=$G(VR(1,"PRE","TRM")) Q:PTRM=""
 ... S PCNC=$G(VR(1,"CON")) Q:PCNC=""
 ... ;
 ... ;ICD9 - Parent
 ... S PICD="" I $D(VR(1,"IC9")) D
 .... NEW ICNT
 .... S ICNT="" F  S ICNT=$O(VR(1,"IC9",ICNT)) Q:ICNT=""  D
 ..... NEW ICDE
 ..... S ICDE=$G(VR(1,"IC9",ICNT,"COD"))
 ..... S PICD=PICD_$S(PICD]"":$C(26),1:"")_ICDE
 ... ;
 ... ;Set up output
 ... S REL=REL_$S(REL]"":$C(28),1:"")_"P"_$C(29)_PCNC_$C(29)_PDSC_$C(29)_PTRM_$C(29)_PICD
 . ;
 . ;Now get Children
 . I $D(SVAR(II,"CHD")) D
 .. NEW ICNT,CICD
 .. S ICNT="" F  S ICNT=$O(SVAR(II,"CHD",ICNT)) Q:ICNT=""  D
 ... NEW DTS,PDSC,PTRM,VR,STS,PCNC,SCHK
 ... ;
 ... ;Pull DTSId of Child
 ... S DTS=$G(SVAR(II,"CHD",ICNT,"DTS")) Q:DTS=""
 ... ;
 ... ;Look up entry
 ... S STS=$$DTSLKP^BSTSAPI("VR",DTS_"^^^1")
 ... ;
 ... ;Perform subset check to see it this Concept should be returned
 ... S SCHK=0 I SUBSETS]"",$D(VR(1,"SUB")) D
 .... NEW ICNT
 .... S ICNT="" F  S ICNT=$O(VR(1,"SUB",ICNT)) Q:ICNT=""  D
 ..... NEW SB
 ..... S SB=$G(VR(1,"SUB",ICNT,"SUB"))
 ..... I SUBSETS[("~"_SB_"~") S SCHK=1
 ... I SUBSETS]"",'SCHK Q
 ... ;
 ... S PDSC=$G(VR(1,"PRE","DSC")) Q:PDSC=""
 ... S PTRM=$G(VR(1,"PRE","TRM")) Q:PTRM=""
 ... S PCNC=$G(VR(1,"CON")) Q:PCNC=""
 ... ;
 ... ;ICD - Children
 ... S CICD="" I $D(VR(1,"IC9")) D
 .... NEW ICNT
 .... S ICNT="" F  S ICNT=$O(VR(1,"IC9",ICNT)) Q:ICNT=""  D
 ..... NEW ICDE
 ..... S ICDE=$G(VR(1,"IC9",ICNT,"COD"))
 ..... S CICD=CICD_$S(CICD]"":$C(26),1:"")_ICDE
 ... ;
 ... ;Set up output
 ... S REL=REL_$S(REL]"":$C(28),1:"")_"C"_$C(29)_PCNC_$C(29)_PDSC_$C(29)_PTRM_$C(29)_CICD
 . ;
 . ;Save entry
 . S BSTSII=BSTSII+1
 . S @DATA@(BSTSII)=CONC_U_DESC_U_PTERM_U_REL_U_SUB_U_ICD_$C(30)
 ;
IDONE ;
 S BSTSII=BSTSII+1,@DATA@(BSTSII)=$C(31)
 Q
 ;
IHDR ;
 NEW HDR
 S HDR="T00050CONCID^T00050DESC_ID^T00250PREF_TRM^T04096RELATIONS^T04096SUBSETS^T04096ICD9"
 S @DATA@(BSTSII)=HDR_$C(30)
 Q
 ;
HDR ;
 NEW HDR
 S HDR="T00050PRB_DSC^T00250PRB_TRM^T00050PREF_DSC^T00250PREF_TRM^T00050CONCID^T00030DTSID^T00050FSN_DSC^T00250FSN_TRM"
 S HDR=HDR_"^T04096ISA^T04096ICD9^T04096SUBSETS^T0409610D^T04096SYNONYMS"
 S HDR=HDR_"^T00001ISA_SYN_HDR^T04096MAPPED_ICD^T00001PROMPT_LATERALITY^T00020DEFAULT_STATUS^T00001REQUIRE_EPISODICITY"
 S @DATA@(BSTSII)=HDR_$C(30)
 Q
 ;
SUBSET(DATA,INPUT) ;EP - BSTS GET SUBSET LIST
 ;
 ;Description
 ;  Returns a list of Subsets available to select from
 ;  
 ;Input
 ; INPUT - P1 (Optional) - Namespace ID - Default to SNOMED US EXT (#36)
 ;       - P2 (Optional) - LOCAL - Pass 1 to perform local listing, otherwise leave
 ;                         blank for remote listing
 ;       - P3 (Optional) - DEBUG - Pass 1 to display debug information
 ;       - P4 (Optional) - IPL - Pass 1 to return only problem list subsets (SRCH*)
 ;
 ;Output
 ;  ^TMP("BSTSRPC") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 ;Always look LOCAL
 S $P(INPUT,"|",2)=1
 ;
 N UID,BSTSII,STS,II,VAR,IPL,%D
 ;
 S INPUT=$TR($G(INPUT),"|","^")
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BSTSRPC",UID))
 K @DATA
 ;
 S BSTSII=0
 S IPL=$P(INPUT,"^",4)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSRPC D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S STS=$$SUBSET^BSTSAPI("VAR",$P(INPUT,U,1,3))
 ;
 ;Define header
 S @DATA@(0)="T04096SUBSET^T04096DISPLAY_SUBSETS"_$C(30)
 ;
 ;Loop through list and set up results
 S II="" F  S II=$O(VAR(II)) Q:II=""  D
 . ;
 . NEW DISPSB
 . ;
 . ;Filter for Integrated Problem List
 . I IPL,$E(VAR(II),1,4)'="SRCH" Q
 . S DISPSB=VAR(II) I $E(VAR(II),1,5)="SRCH " S DISPSB=$E(VAR(II),6,999)
 . ;
 . S BSTSII=BSTSII+1,@DATA@(BSTSII)=VAR(II)_U_DISPSB_$C(30)
 ;
 S BSTSII=BSTSII+1,@DATA@(BSTSII)=$C(31)
 Q
 ;
CDSET(DATA,INPUT) ;EP - BSTS GET CODESETS
 ;
 ;Description
 ;  Returns a list of Codesets available to select from
 ;  
 ;Input
 ; INPUT - P1 (Optional) - LOCAL - Pass 1 to perform local listing, otherwise leave
 ;                         blank for remote listing
 ;       - P2 (Optional) - DEBUG - Pass 1 to display debug information
 ;       - P3 (Optional) - Pass 1 to return codesets for the standalone search tool
 ;
 ;  10       ICD-9-CM
 ;X 32768    IHS
 ;X 32769    SNOMED CT to ICD-10-CM Old
 ;X 32770    ECLIPS
 ;X 32771    IHS VANDF
 ;X 32772    GMRA Signs Symptoms
 ;X 32773    GMRA Allergies with Maps
 ;X 35290    SNOMED CT US Ext to ICD-10-CM
 ;X 32774    IHS Med Route
 ;  1552     RxNorm R
 ;  36       SNOMED CT US Extension
 ;  30       SNOMED CT
 ;  5180     FDA UNII
 ;
 ;Output
 ;  ^TMP("BSTSRPC") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 N UID,BSTSII,STS,II,VAR,SA,%D
 ;
 S INPUT=$TR($G(INPUT),"|","^")
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BSTSRPC",UID))
 K @DATA
 ;
 S BSTSII=0
 S SA=$P(INPUT,"^",3)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSRPC D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S STS=$$CODESETS^BSTSAPI("VAR",$P(INPUT,U,1,2))
 ;
 ;Define header
 S @DATA@(0)="T00010CODE^T04096CODESET_NAME"_$C(30)
 ;
 ;Loop through list and set up results
 S II="" F  S II=$O(VAR(II)) Q:II=""  D
 . ;
 . NEW CODE,CODESET
 . ;
 . S CODE=$P(VAR(II),U)
 . S CODESET=$P(VAR(II),U,3)
 . ;
 . ;Filter for Standalone
 . I SA=1,CODE<32770,CODE>32667 Q
 . I SA=1,CODE=35290 Q
 . ;
 . ;Save entry
 . S BSTSII=BSTSII+1,@DATA@(BSTSII)=CODE_U_CODESET_$C(30)
 ;
 S BSTSII=BSTSII+1,@DATA@(BSTSII)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BSTSII),$D(DATA) S BSTSII=BSTSII+1,@DATA@(BSTSII)=$C(31)
 Q
