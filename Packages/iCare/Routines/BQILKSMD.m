BQILKSMD ;GDIT/HS/BEE - SNOMED Utilities ; 10 Aug 2012  9:24 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**3,4**;Apr 18, 2012;Build 66
 ;
 Q
 ;
SEARCH(DATA,SEARCH) ;EP - BQI SNOMED SEARCH
 ;
 ;Description
 ;  Returns a list of SNOMED CT Terms matching the specified search string
 ;  
 ;Input
 ;  SEARCH - The string to search on
 ;
 ;Output
 ;  ^TMP("BQILKSMD") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 N UID,BQII,SVAR,STS,II
 ;
 S SEARCH=$TR(SEARCH,"|","^")
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQILKSMD",UID))
 S SVAR=$NA(^TMP("BQILKSER",UID))
 K @DATA,@SVAR
 ;
 S BQII=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQILKSMD D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 D HDR
 ;
 ;Validate input
 I $G(SEARCH)="" G DONE
 ;
 ;Perform lookup
 S STS=$$SEARCH^BSTSAPI(SVAR,SEARCH)
 ;
 ;Output Results
 S II=0 F  S II=$O(@SVAR@(II)) Q:II=""  D
 . NEW PRBD,PRBT,CONC,DTS,FSND,FSNT,PRED,PRET
 . NEW ISA,ICD9,SUB,SYN,MICD,D10,ISHDR
 . ;
 . ;Problem Description and Term
 . S PRBD=$G(@SVAR@(II,"PRB","DSC"))
 . S PRBT=$G(@SVAR@(II,"PRB","TRM"))
 . W !,II,?10,"PRBD: ",PRBD,"|",PRBT
 . S CONC=$G(@SVAR@(II,"CON"))
 . S DTS=$G(@SVAR@(II,"DTS"))
 . S FSND=$G(@SVAR@(II,"FSN","DSC"))
 . S FSNT=$G(@SVAR@(II,"FSN","TRM"))
 . S PRED=$G(@SVAR@(II,"PRE","DSC"))
 . S PRET=$G(@SVAR@(II,"PRE","TRM"))
 . S ISHDR=$S(PRED=PRBD:"",1:"S")
 . ;
 . ;ISA
 . S ISA="" I $D(@SVAR@(II,"ISA")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@SVAR@(II,"ISA",ICNT)) Q:ICNT=""  D
 ... NEW DTS,CON,TRM
 ... S DTS=$G(@SVAR@(II,"ISA",ICNT,"DTS"))
 ... S CON=$G(@SVAR@(II,"ISA",ICNT,"CON"))
 ... S TRM=$G(@SVAR@(II,"ISA",ICNT,"TRM"))
 ... S ISA=ISA_$S(ISA]"":$C(28),1:"")_DTS_$C(29)_CON_$C(29)_TRM
 . ;
 . ;ICD9
 . S ICD9="" I $D(@SVAR@(II,"ICD")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@SVAR@(II,"ICD",ICNT)) Q:ICNT=""  D
 ... NEW ICD
 ... S ICD=$G(@SVAR@(II,"ICD",ICNT,"COD"))
 ... S ICD9=ICD9_$S(ICD9]"":$C(28),1:"")_ICD
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
 . S SYN=PRED_$C(29)_PRET_$C(29)_"Preferred" I $D(@SVAR@(II,"SYN")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(@SVAR@(II,"SYN",ICNT)) Q:ICNT=""  D
 ... NEW TRM,DSC
 ... S TRM=$G(@SVAR@(II,"SYN",ICNT,"TRM"))
 ... S DSC=$G(@SVAR@(II,"SYN",ICNT,"DSC"))
 ... S SYN=SYN_$S(SYN]"":$C(28),1:"")_DSC_$C(29)_TRM_$C(29)_"Synonym"
 . ;
 . S MICD=ICD9
 . ;Save entry
 . S BQII=BQII+1,@DATA@(BQII)=PRBD_U_PRBT_U_CONC_U_DTS_U_FSND_U_FSNT_U_ISA
 . S @DATA@(BQII)=@DATA@(BQII)_U_ICD9_U_SUB_U_D10_U_SYN_U_ISHDR_U_MICD_$C(30)
 ;
DONE ;
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
HDR ;
 NEW HDR
 S HDR="T00050PRB_DSC^T00250PRB_TRM^T00050CONCID^T00030DTSID^T00050FSN_DSC^T00250FSN_TRM"
 S HDR=HDR_"^T04096ISA^T04096ICD9^T04096SUBSETS^T0409610D^T04096SYNONYMS"
 S HDR=HDR_"^T00001ISA_SYN_HDR^T04096MAPPED_ICD"
 S @DATA@(BQII)=HDR_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
