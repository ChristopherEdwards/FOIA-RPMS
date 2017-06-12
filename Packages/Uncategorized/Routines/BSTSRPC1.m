BSTSRPC1 ;GDIT/HS/BEE - SNOMED Utilities - RPC Calls ; 10 Aug 2012  9:24 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
DETAIL(DATA,DTSID) ;EP - BSTS GET CONCEPT DETAIL
 ;
 ;Description
 ;  Returns the detail for a passed in concept
 ;  
 ;Input
 ;  DTSID - The internal DTS IEN
 ;
 ;Output
 ;  ^TMP("BSTSRPC1") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 N UID,II,STS,SVAR,REC,CIEN,CONCID
 ;
 I $G(DTSID)="" S BMXSEC="BSTS GET CONCEPT DETAIL - DTSID is Null" Q
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BSTSRPC1",UID))
 K @DATA
 S II=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSRPC1 D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 D HDR
 ;
 ;Look for the entry in local cache
 S CONCID="",CIEN=$O(^BSTS(9002318.4,"D",36,DTSID,""))
 I CIEN]"" S CONCID=$$GET1^DIQ(9002318.4,CIEN_",",.02,"I")
 ;
 ;Perform local lookup
 I CONCID]"" S STS=$$CNCLKP^BSTSAPI("SVAR",CONCID)
 ;
 ;Perform lookup
 I CONCID="" S STS=$$DTSLKP^BSTSAPI("SVAR",DTSID)
 ;
 ;Output Results
 S REC=1 I $D(SVAR(REC)) D
 . NEW PRBD,PRBT,CONC,DTS,FSND,FSNT,PRED,PRET
 . NEW ICD,LAT,DFSTS,REPI,PAF,SEL
 . ;
 . ;Problem Description and Term
 . S PRBD=$G(SVAR(REC,"PRB","DSC"))
 . S PRBT=$G(SVAR(REC,"PRB","TRM"))
 . S CONC=$G(SVAR(REC,"CON"))
 . S DTS=$G(SVAR(REC,"DTS"))
 . S FSND=$G(SVAR(REC,"FSN","DSC"))
 . S FSNT=$G(SVAR(REC,"FSN","TRM"))
 . S PRED=$G(SVAR(REC,"PRE","DSC"))
 . S PRET=$G(SVAR(REC,"PRE","TRM"))
 . S LAT=$S($G(SVAR(REC,"LAT"))=1:1,1:0)
 . S DFSTS=$G(SVAR(REC,"STS"))
 . S REPI=$S($G(SVAR(REC,"EPI"))=1:1,1:0)
 . S PAF=$S($G(SVAR(REC,"ABN"))=1:1,1:0)
 . S SEL=$S($G(SVAR(REC,"PAS"))=1:"Y",1:"")
 . ;
 . ;ICD
 . S ICD="" I $D(SVAR(REC,"ICD")) D
 .. NEW ICNT
 .. S ICNT="" F  S ICNT=$O(SVAR(REC,"ICD",ICNT)) Q:ICNT=""  D
 ... NEW ICDE
 ... S ICDE=$G(SVAR(REC,"ICD",ICNT,"COD"))
 ... S ICD=ICD_$S(ICD]"":$C(28),1:"")_ICDE
 . ;
 . ;Save entry
 . S II=II+1,@DATA@(II)=PRBD_U_PRBT_U_PRED_U_PRET_U_CONC_U_DTS_U_FSND_U_FSNT
 . S @DATA@(II)=@DATA@(II)_U_ICD_U_LAT_U_DFSTS_U_REPI_U_PAF_U_SEL_$C(30)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
TAHEAD(DATA,NMID,COUNT,SEARCH,SUBSETS) ;EP - BSTS SEARCH TYPE AHEAD
 ;
 ;Description
 ;  This call returns some recommended concepts based on what the user has typed
 ;  in so far. Since the call has to be very fast, straight global reads are being
 ;  performed instead of FileMan utility reads.
 ;  
 ;Input
 ;     NMID - External codeset namespace id
 ;    COUNT - Number of results to return
 ;   SEARCH - String to search on
 ; SUBSET(S) - Subsets to limit results to - delimit subsets by "~"
 ;
 ;Output
 ;  ^TMP("BSTSRPC1") - Name of global (passed by reference) in which the data is stored.
 ;
 ;Variables Used
 ;  UID - Unique TMP global subscript.
 ;
 N UID,II,WORD,WRD,TIEN,SUBLST,I,P,SUB,FND,CIEN,R,CNT,FLVL,UPTRM,UPSRC,OWRD,TRM,OWLST
 ;
 ;Check input variables
 S:$G(NMID)="" NMID=36 ;Default to SNOMED
 S:$G(COUNT)="" COUNT=10
 I $TR($G(SEARCH)," ")="" S BMXSEC="BSTS SEARCH TYPE AHEAD - SEARCH is Null" Q
 S SUBSETS=$G(SUBSETS)
 ;
 ;Implement SNOMED galaxy filtering
 I NMID=36,SUBSETS="" S SUBSETS="IHS PROBLEM ALL SNOMED"
 ;
 ;Put subsets in an array
 I $TR(SUBSETS,"~")]"" F I=1:1:$L(SUBSETS,"~") S SUB=$P(SUBSETS,"~",I) I SUB]"" S SUBLST(SUB)=""
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BSTSRPC1",UID))
 K @DATA
 S II=0,CNT=1
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSRPC1 D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(0)="T04096RESULTS"_$C(30)
 ;
 ;Process first word in the string to establish base list
 S UPSRC=$$UP^XLFSTR(SEARCH)
 S WORD=$P(UPSRC," ") I WORD="" G XTAHEAD
 S OWRD=$S($L(UPSRC," ")>1:0,1:1)
 ;
 ;Match check
 S WRD=$$PREV(WORD) F  S WRD=$O(^BSTS(9002318.3,"E",NMID,WRD)) Q:(WRD="")!(WRD'[WORD)  D  I OWRD,CNT>COUNT Q
 . ;
 . S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"E",NMID,WRD,TIEN)) Q:TIEN=""  D  I OWRD,CNT>COUNT Q
 .. ;
 .. ;Subset check
 .. S FND="" I $TR(SUBSETS,"~")]"" D  Q:FND=""
 ... S CIEN=$P($G(^BSTS(9002318.3,TIEN,0)),U,3) Q:CIEN=""
 ... S SUB="" F  S SUB=$O(SUBLST(SUB)) Q:SUB=""  D  I FND Q
 .... I $D(^BSTS(9002318.4,CIEN,4,"B",SUB)) S FND=1
 .. ;
 .. ;Handle single word entry
 .. I OWRD D  Q
 ... I '$D(OWLST($$MIXC(WRD))) S R("S",99999-CNT,$$MIXC(WRD))="",OWLST($$MIXC(WRD))="",CNT=CNT+1
 .. ;
 .. ;Filter out FSN for SNOMED
 .. I NMID=36,$P($G(^BSTS(9002318.3,TIEN,0)),U,9)="F" Q
 .. ;
 .. ;Set up the entry
 .. S UPTRM=$$UP^XLFSTR($P($G(^BSTS(9002318.3,TIEN,1)),U)) Q:UPTRM=""
 .. S R("R",UPTRM)=TIEN_U_$S(WRD=WORD:3,1:1)
 .. S CNT=CNT+1
 ;
 ;Now loop through remaining words and filter
 ;
 ;Process remaining words
 I 'OWRD,$D(R)>9 F P=2:1:$L(UPSRC," ") S WORD=$P(UPSRC," ",P) I WORD]"" D
 . S (FND,UPTRM)="" F  S UPTRM=$O(R("R",UPTRM)) Q:UPTRM=""  D
 .. S FND="" F I=1:1:$L(UPTRM," ") S WRD=$P(UPTRM," ",I) I WRD]"",$E(WRD,1,$L(WORD))=WORD D  S FND=1 Q
 ... S $P(R("R",UPTRM),U,2)=$P(R("R",UPTRM),U,2)+$S(WRD=WORD:3,1:1)
 .. I 'FND K R("R",UPTRM)
 . Q
 ;
 ;Add extra weighting
 I 'OWRD S UPTRM="" F  S UPTRM=$O(R("R",UPTRM)) Q:UPTRM=""  D
 . I UPSRC=UPTRM S $P(R("R",UPTRM),U,2)=$P(R("R",UPTRM),U,2)+100
 . F I=1:1:$L(UPSRC," ") D
 .. I $E($P(UPTRM," ",I),1,$L($P(UPSRC," ",I)))=$P(UPSRC," ",I) S $P(R("R",UPTRM),U,2)=$P(R("R",UPTRM),U,2)+5
 . S TIEN=$P(R("R",UPTRM),U),TRM=$P($G(^BSTS(9002318.3,TIEN,1)),U) Q:TRM=""
 . S R("S",$P(R("R",UPTRM),U,2),TRM)=""
 . K R("R",UPTRM)
 ;
 ;Now output
 S R="" F  S R=$O(R("S",R),-1) Q:R=""  D  I II'<COUNT Q
 . S TRM="" F  S TRM=$O(R("S",R,TRM)) Q:TRM=""  D  I II'<COUNT Q
 .. S II=II+1,@DATA@(II)=TRM_$C(30)
 ;
XTAHEAD ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
MIXC(WORD) ;Convert to mix case
 ;
 Q $E(WORD,1)_$$LOW^XLFSTR($E(WORD,2,9999))
 ;
PREV(WORD) ;Return string right before passed in string
 ;
 NEW L,A,LST
 ;
 ;Get last character
 S L=$E(WORD,$L(WORD)) Q:L="" ""
 ;
 ;Get ASCII of previous character
 S A=$A(L) S:A>1 A=A-1
 ;
 ;Define highest ASCII
 S LST=$C(65535)
 ;
 ;Return word string just before word
 S WORD=$E(WORD,1,$L(WORD)-1)_$C(A)_LST_LST_LST_LST
 ;
 Q WORD
 ;
HDR ;
 NEW HDR
 S HDR="T00050PRB_DSC^T00250PRB_TRM^T00050PREF_DSC^T00250PREF_TRM^T00050CONCID^T00030DTSID^T00050FSN_DSC^T00250FSN_TRM"
 S HDR=HDR_"^T04096ICD^T00001PROMPT_LATERALITY^T00020DEFAULT_STATUS^T00001REQUIRE_EPISODICITY^T00001PROMPT_AF^T00001SELECTABLE"
 S @DATA@(0)=HDR_$C(30)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
