BSTSSRCH ;GDIT/HS/ALA-Search terms ; 15 Nov 2012  4:26 PM
 ;;1.0;IHS STANDARD TERMINOLOGY;**3**;Sep 10, 2014;Build 19
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
 ;Make call to new search logic
 Q $$SRC^BSTSLSRC(.OUT,.IN)
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
 ;Define scratch global
 S TMP=$NA(^TMP("BSTSSRCH",$J))
 K @TMP
 ;
 ;Define FileMan scratch global
 K ^TMP("DILIST",$J)
 ;
 ;Loop through each search term and perform look up
 S SCREEN="I $P(^(0),U,8)="_INMID
 S FILE=9002318.3,FIELD=".02;.03;.09;1",FLAGS="PCM",INDEX="E"
 F II=1:1:$L(SEARCH," ") S VAL=$P(SEARCH," ",II) D
 . N N,TOT,VALUE
 . S VALUE=$$UP^XLFSTR(VAL)
 . D FIND^DIC(FILE,"",FIELD,FLAGS,VALUE,"",INDEX,SCREEN,"","","ERROR")
 . S TOT=$P($G(^TMP("DILIST",$J,0)),"^",1)
 . I TOT=0 Q
 . F N=1:1:TOT D FND(N,SEARCH,NMID)
 . Q
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
 . I $$GET1^DIQ(9002318.4,CIEN_",",".11","I")="Y" Q
 . ;
 . ;Check revision dates
 . S RIN=$$GET1^DIQ(9002318.4,CIEN_",",".05","I")
 . S ROUT=$$GET1^DIQ(9002318.4,CIEN_",",".06","I")
 . I CHKDT]"",RIN]"",CHKDT<RIN Q  ;Check date is before revision in
 . I CHKDT]"",ROUT]"",CHKDT>ROUT Q  ;Check date is after revision out
 . ;
 . ;Subset filter
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
 K @TMP,@TMP2,^TMP("DILIST",$J,0)
 ;
 ;Return 1 on successful search
 Q $S(OCNT>0:1,1:0)
 ;
FDESC(CIEN) ;EP - Retrieve Description Id of FSN
 ;
 N TIEN,NMID,DESC
 ;
 S NMID=$$GET1^DIQ(9002318.4,CIEN_",",.07,"E") Q:NMID="" ""
 S (DESC,TIEN)="" F  S TIEN=$O(^BSTS(9002318.3,"C",NMID,CIEN,TIEN)) Q:TIEN=""  D  Q:DESC
 . N TYPE
 . S TYPE=$$GET1^DIQ(9002318.3,TIEN_",",.09,"I") I TYPE'="F" Q
 . S DESC=$$GET1^DIQ(9002318.3,TIEN_",",.02,"E")
 ;
 Q DESC
 ;
PDESC(CIEN) ;EP - Retrieve Description Id of Preferred Term
 ;
 N TIEN,NMID,DESC
 ;
 S NMID=$$GET1^DIQ(9002318.4,CIEN_",",.07,"E") Q:NMID="" ""
 S (DESC,TIEN)="" F  S TIEN=$O(^BSTS(9002318.3,"C",NMID,CIEN,TIEN)) Q:TIEN=""  D  Q:DESC
 . N TYPE,TERM
 . S TYPE=$$GET1^DIQ(9002318.3,TIEN_",",.09,"I")
 . ;
 . ;For SNOMED look for preferred
 . ;For UNII look for FSN
 . ;For RXNORM look for preferred
 . I NMID=36,TYPE'="P" Q
 . I NMID=5180,TYPE'="F" Q
 . I NMID=1552,TYPE'="P" Q
 . I NMID>32770,NMID<32780,TYPE'="F" Q
 . ;
 . S DESC=$$GET1^DIQ(9002318.3,TIEN_",",.02,"E")
 . S TERM=$$GET1^DIQ(9002318.3,TIEN_",",1,"E")
 . S DESC=DESC_U_TERM
 ;
 Q DESC
 ;
FND(N,SEARCH,NMID) ;Set up return entry
 N ENT,CPT,FILTER,DESC,TERM,WGT,USEARCH,PC,UTERM
 S CPT=$P(^TMP("DILIST",$J,N,0),U,4) Q:CPT=""
 S ENT=$P(^BSTS(9002318.4,CPT,0),"^",2)_"^"_$P(^(0),"^",8)_"^"
 S DESC=$P(^TMP("DILIST",$J,N,0),U,3) Q:DESC=""
 S TERM=$P(^TMP("DILIST",$J,N,0),U,6)
 ;
 S FILTER=0
 ;
 ;Skip FSN terms and out of date entries
 D  Q:FILTER
 . N TIEN,TTYP
 . S TIEN=$O(^BSTS(9002318.3,"D",INMID,DESC,"")) Q:TIEN=""
 . S TTYP=$$GET1^DIQ(9002318.3,TIEN_",",.09,"I")
 . ;I TTYP="F" S FILTER=1
 . I ((NMID<32771)!(NMID>32780)),TTYP="F" S FILTER=1 Q
 . I $$GET1^DIQ(9002318.3,TIEN_",",.11,"I")="Y" S FILTER=1
 ;
 ;Implement AND logic - must have all terms
 D  Q:FILTER
 . NEW PC
 . FOR PC=1:1:$L(SEARCH," ") D  Q:FILTER
 .. NEW WD
 .. S WD=$P(SEARCH," ",PC)
 .. ;
 .. ;Strip out comparison words
 .. I (WD="")!(WD="OR")!(WD="AND")!(WD="NOT") Q
 .. I ($$UP^XLFSTR(TERM))'[($$UP^XLFSTR(WD)) S FILTER=1
 ;
 ;Determine weight value (look for exact match)
 S USEARCH=$$UP^XLFSTR(SEARCH)
 S UTERM=$$UP^XLFSTR(TERM)
 S WGT=1 F PC=1:1:$L(USEARCH," ") I $P(USEARCH," ",PC)=$P(UTERM," ",PC) S WGT=WGT+1
 I UTERM=USEARCH S WGT=WGT+5
 ;
 ;Log entry
 I STYPE="F" S DESC=$P($$PDESC^BSTSSRCH(CPT),U) Q:DESC=""
 S ENT=ENT_DESC
 S @TMP@(ENT)=$G(@TMP@(ENT))+WGT
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
 ;
SXF ;EP - Set cross-reference
 S %1=1 F %=1:1:$L(X)+1 D
 . S I=$E(X,%)
 . I "(,.?! '/&:;)"[I S I=$E($E(X,%1,%-1),1,30),%1=%+1
 . S I=$$UP^XLFSTR(I)
 . I $L(I)>2,^DD("KWIC")'[I D
 .. NEW CDSET
 .. S CDSET=$$GET1^DIQ(9002318.3,DA_",",.08,"E") Q:CDSET=""
 .. ;
 .. ;Strip leading '-'/'+'
 .. I "-+"[$E(I,1) S I=$E(I,2,9999)
 .. ;
 .. ;Strip quotes
 .. S I=$TR(I,"""","")
 .. ;
 .. ;Save entry
 .. S ^BSTS(9002318.3,"E",CDSET,I,DA)=""
 Q
 ;
KXF ;EP - Kill cross-reference
 S %1=1 F %=1:1:$L(X)+1 D
 . S I=$E(X,%)
 . I "(,.?! '/&:;)"[I S I=$E($E(X,%1,%-1),1,30),%1=%+1
 . S I=$$UP^XLFSTR(I)
 . I $L(I)>2 D
 .. NEW CDSET
 .. S CDSET=$$GET1^DIQ(9002318.3,DA_",",.08,"E") Q:CDSET=""
 .. ;
 .. ;Strip leading '-'/'+'
 .. I "-+"[$E(I,1) S I=$E(I,2,9999)
 .. ;
 .. ;Strip quotes
 .. S I=$TR(I,"""","")
 .. ;
 .. ;Kill entry
 .. K ^BSTS(9002318.3,"E",CDSET,I,DA)
 Q
 ;
DETAIL(OUT,BSTSWS,RESULT) ;EP - Return Details for each Concept/Term
 ;
 ;Return the concept detail
 ;
 ;Call moved to new routine because of space issues
 Q $$DETAIL^BSTSCDET(OUT,.BSTSWS,.RESULT)
