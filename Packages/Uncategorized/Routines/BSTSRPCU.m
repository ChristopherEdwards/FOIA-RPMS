BSTSRPCU ;GDIT/HS/BEE - SNOMED Utilities - RPC Universe Search ; 10 Aug 2012  9:24 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
USEARCH(DATA,SEARCH) ;EP - BSTS SNOMED UNIVERSE SEARCH
 ;
 ;Description
 ;  Perform a Codeset Universe Lookup
 ;  Returns a set of terms matching the specified search string
 ;  
 ;Input
 ;  SEARCH - The string to search on
 ;
 ;Output
 ;  ^TMP("BSTSRPCU") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 N UID,BSTSII,SVAR,STS,II,%D
 ;
 S SEARCH=$TR(SEARCH,"|","^")
 S $P(SEARCH,U,5)=""
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BSTSRPCU",UID))
 S SVAR=$NA(^TMP("BSTSRPC1",UID))
 K @DATA,@SVAR
 ;
 S BSTSII=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSRPCU D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 D UHDR
 ;
 ;Validate input
 I $G(SEARCH)="" G UDONE
 ;
 ;Perform lookup
 S STS=$$USEARCH^BSTSAPIF(SVAR,SEARCH)
 ;
 ;Output Results
 S II=0 F  S II=$O(@SVAR@(II)) Q:II=""  D
 . NEW PRBD,PRBT,CONC,DTS,FSND,FSNT,ISA,SYN,PS,SUB
 . NEW ASSC,MAPP
 . ;
 . ;Problem Description and Term
 . S PRBD=$P($G(@SVAR@(II)),U,3)
 . S PRBT=$P($G(@SVAR@(II)),U,2)
 . S CONC=$P($G(@SVAR@(II)),U)
 . S DTS=$P($G(@SVAR@(II)),U,8)
 . S FSND=$P($G(@SVAR@(II)),U,5)
 . S FSNT=$P($G(@SVAR@(II)),U,4)
 . ;
 . ;ISA
 . S ISA=$P($G(@SVAR@(II)),U,7)
 . ;
 . ;Synonym
 . S SYN=$P($G(@SVAR@(II)),U,6)
 . ;
 . ;Preferred/Synonym
 . S PS=$P($G(@SVAR@(II)),U,10)
 . ;
 . ;Subsets
 . S SUB=$P($G(@SVAR@(II)),U,9) D
 . ;
 . ;Associations
 . S ASSC=$P($G(@SVAR@(II)),U,11)
 . ;
 . ;Mappings
 . S MAPP=$P($G(@SVAR@(II)),U,12)
 . ;
 . ;Save entry
 . S BSTSII=BSTSII+1,@DATA@(BSTSII)=PRBT_U_PRBD_U_PS_U_FSNT_U_CONC_U_FSND_U_SYN_U_ISA_U_DTS_U_SUB_U_ASSC_U_MAPP
 . S @DATA@(BSTSII)=@DATA@(BSTSII)_$C(30)
 ;
 ;Reset Scratch Global
 K @SVAR
 ;
UDONE ;
 S BSTSII=BSTSII+1,@DATA@(BSTSII)=$C(31)
 Q
 ;
UHDR ;
 NEW HDR
 S HDR="T00250PRB_TRM^T00050PRB_DSC^T00001PS^T00250FSN_TERM^T00250CONCID^T00050FSN_DSC"
 S HDR=HDR_"^T04096SYNONYMS^T04096RELATION^T00050HIDDEN_DTSID^T04096SUBSETS^T04096ASSOCIATION^T04096MAPPING"
 S @DATA@(BSTSII)=HDR_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BSTSII),$D(DATA) S BSTSII=BSTSII+1,@DATA@(BSTSII)=$C(31)
 Q
