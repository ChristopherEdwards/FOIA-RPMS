BSTSLSRC ;GDIT/HS/BEE BSTS - New local Search ; 15 Nov 2012  4:26 PM
 ;;1.0;IHS STANDARD TERMINOLOGY;**4,5,6**;Sep 10, 2014;Build 20
 Q
 ;
SRC(OUT,IN) ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  IN - BSTSWS Array
 ;
 ;Output
 ; @VAR@(#) - [1]^[2]^[3]
 ; [1] - Concept ID
 ; [2] - DTS ID
 ; [3] - Descriptor ID
 ;
 N II,TEXT,ARRAY,NM,TMP,SEARCH,STYPE,NMID,SUB,SNAPDT,MAX,BCTCHRC,BCTCHCT,DEBUG,CHKDT
 N SCREEN,FILE,FIELD,FLAGS,INDEX,VAL,ERROR,TMP2,RES,RCNT,OCNT,CNT,%,%1,I,X,INMID
 ;
 ;Define input variables 
 F II=1:1 S TEXT=$P($T(FLD+II),";;",2) Q:TEXT=""  S ARRAY($P(TEXT,"^",1))=$P(TEXT,"^",2)
 S NM="" F  S NM=$O(IN(NM)) Q:NM=""  I $G(ARRAY(NM))'="" S @ARRAY(NM)=IN(NM)
 S:$G(NMID)="" NMID=36
 ;
 S INMID=$O(^BSTS(9002318.1,"B",NMID,"")) I INMID="" Q "0^Invalid Codeset"
 ;
 S CHKDT=$P($$DATE^BSTSUTIL(IN("SNAPDT")),".") I CHKDT="" Q "0^Invalid Check Date"
 ;
 ;Define scratch globals
 S TMP=$NA(^TMP("BSTSSRCH",$J))
 K @TMP
 ;
 ;Convert to uppercase
 S SEARCH=$$UP^XLFSTR(SEARCH)
 ;
 ;Loop through each search term and perform look up
 F II=1:1:$L(SEARCH," ") S VAL=$P(SEARCH," ",II) I VAL]"" D
 . NEW WORD,TIEN
 . ;
 . ;Strip out common words
 . I ^DD("KWIC")[(U_VAL_U) Q
 . ;
 . ;Look for exact matches
 . S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"E",NMID,VAL,TIEN)) Q:TIEN=""  D MATCH(10000,VAL,TIEN,NMID,SEARCH,STYPE)
 . ;
 . ;Look for partial matches
 . S WORD=VAL F  S WORD=$O(^BSTS(9002318.3,"E",NMID,WORD)) Q:WORD'[VAL  D
 .. S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"E",NMID,WORD,TIEN)) Q:TIEN=""  D MATCH(5000,VAL,TIEN,NMID,SEARCH,STYPE)
 ;
 ;Now Filter and Sort by finding count
 S TMP2=$NA(^TMP("BSTSSRCH2",$J)) K @TMP2
 S RES="" F  S RES=$O(@TMP@(RES)) Q:RES=""  D
 . N FILTER,CNT,CONC,CIEN,RIN,ROUT
 . S FILTER=0
 . ;
 . ;GET THE CONC and CIEN
 . S CONC=$P(RES,U) Q:CONC=""
 . S CIEN=$$CIEN^BSTSLKP(CONC,NMID) Q:CIEN=""
 . ;
 . ;Quit if out of date
 . ;BSTS*1.0*4;Change to out of date checking
 . ;Allow out of date concepts since server is probably offline
 . ;but queue for later update
 . ;I $$GET1^DIQ(9002318.4,CIEN_",",".11","I")="Y" Q
 . I ($$GET1^DIQ(9002318.4,CIEN_",",".11","I")="Y")!($$GET1^DIQ(9002318.4,CIEN_",",".12","I")="") S ^XTMP("BSTSPROCQ","C",CIEN)=""
 . ;
 . ;Check revision dates
 . S RIN=$$GET1^DIQ(9002318.4,CIEN_",",".05","I")
 . S ROUT=$$GET1^DIQ(9002318.4,CIEN_",",".06","I")
 . I CHKDT]"",RIN]"",CHKDT<RIN Q  ;Check date is before revision in
 . I CHKDT]"",ROUT]"",CHKDT>ROUT Q  ;Check date is after revision out
 . ;
 . ;Subset filter
 . ;BSTS*1.0*6;ALL search now filter by IHS PROBLEM ALL SNOMED
 . ;I SUB]"",SUB'["ALL" D  Q:FILTER
 . I SUB]"" D  Q:FILTER
 .. N SB,ISB
 .. S FILTER=1
 .. F ISB=1:1:$L(SUB,"~") S SB=$P(SUB,"~",ISB) I SB]"",$D(^BSTS(9002318.4,CIEN,4,"B",SB)) S FILTER=0
 . ;
 . S CNT=@TMP@(RES),@TMP2@(CNT,RES)=""
 ;
 ;Set up output
 S (RCNT,OCNT)=0,CNT="" F  S CNT=$O(@TMP2@(CNT),-1) Q:CNT=""  D
 . N RES
 . S RES="" F  S RES=$O(@TMP2@(CNT,RES),-1) Q:RES=""  D
 .. N D,DI
 .. S RCNT=RCNT+1 Q:RCNT>MAX
 .. ;
 .. ;Start at record
 .. I +BCTCHRC>0,RCNT<(+BCTCHRC) Q
 .. S OCNT=OCNT+1
 .. ;
 .. ;Grab BCTCHCT records
 .. I +BCTCHCT>0,OCNT>(+BCTCHCT) Q
 .. ;
 .. ;Set up output
 .. S @OUT@(OCNT)=RES
 ;
 K @TMP,@TMP2
 ;
 ;Return 1 on successful search
 Q $S(OCNT>0:1,1:0)
 ;
MATCH(WT,VAL,TIEN,NMID,SEARCH,STYPE) ;Perform matching checks/weighting
 ;
 NEW TERM,TYPE,CPT,ENT,DESC,FILTER,CIEN
 ;
 ;Get the type - skip FSN for SNOMED
 S TYPE=$$GET1^DIQ(9002318.3,TIEN_",",.09,"I") Q:TYPE=""
 I TYPE="F",NMID=36 Q
 ;
 ;Get the term
 S TERM=$$UP^XLFSTR($$GET1^DIQ(9002318.3,TIEN_",",1,"E")) Q:TERM=""
 ;
 ;Implement AND logic - must have all terms
 S FILTER=0
 D  Q:FILTER
 . NEW PC
 . FOR PC=1:1:$L(SEARCH," ") D  Q:FILTER
 .. NEW WD
 .. S WD=$P(SEARCH," ",PC)
 .. I TERM'[WD S FILTER=1
 ;
 ;Put greatest weight on exact match
 I SEARCH=TERM S WT=WT+500000000
 ;
 ;BSTS*1.0*6;SRCH Common Terms weighting
 S CIEN=$$GET1^DIQ(9002318.3,TIEN_",",.03,"I") I CIEN]"" D
 . I $O(^BSTS(9002318.4,"E",INMID,"SRCH Common Terms",CIEN,""))]"" S WT=WT+50000000
 ;
 ;Look for starting match - Heavily weight starting matches with search string
 I STYPE="F",(TYPE="P"!(TYPE="F")),SEARCH=$E(TERM,1,$L(SEARCH)) S WT=WT+500000
 I STYPE="S",SEARCH=$E(TERM,1,$L(SEARCH)) S WT=WT+100000
 ;
 ;Put higher weight if term starts with any word
 I VAL=$E(TERM,1,$L(VAL)) S WT=WT+100000
 ;
 ;Give higher weight to preferred terms in FSN searches
 I STYPE="F",(TYPE="P"!(TYPE="F")) S WT=WT+500000
 ;
 ;Log entry
 S CPT=$$GET1^DIQ(9002318.3,TIEN_",",".03","I") Q:CPT=""
 S ENT=$$GET1^DIQ(9002318.4,CPT_",",".02","I")_U_$$GET1^DIQ(9002318.4,CPT_",",".08","I")_U
 S DESC=$$GET1^DIQ(9002318.3,TIEN_",",".02","I")
 ;
 ;If FSN search pull FSN ID
 I STYPE="F" S DESC=$P($$PDESC^BSTSSRCH(CPT),U) Q:DESC=""
 S ENT=ENT_DESC
 S @TMP@(ENT)=$G(@TMP@(ENT))+WT
 ;
 Q
 ;
FLD ;;
 ;;SEARCH^SEARCH
 ;;STYPE^STYPE
 ;;NAMESPACEID^NMID
 ;;SUBSET^SUB
 ;;SNAPDT^SNAPDT
 ;;MAXRECS^MAX
 ;;BCTCHRC^BCTCHRC
 ;;BCTCHCT^BCTCHCT
 ;;DEBUG^DEBUG
 Q
