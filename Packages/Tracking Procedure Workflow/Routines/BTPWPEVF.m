BTPWPEVF ;GDIT/HC/BEE - CMET Panel Event Filters ; 23 Oct 2012  1:24 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;**3**;Feb 07, 2011;Build 63
 ;
 Q
 ;
FINIT(STATUS,BDT,EDT,CATLST,COMM,PARMS) ;EP - Set up filters based on input parameters
 ;
 ; Input parameters
 ;   PARMS - Delimited list of input variables
 ;             -> STATUS  - Status
 ;             -> TMFRAME - Time frame
 ;             -> CAT     - Category
 ;             -> COMM    - Community
 ;             -> COMMTX  - Community Taxonomy
 ; Output parameters
 ;             -> STATUS  - Status
 ;             -> BDT     - Beginning Date
 ;             -> EDT     - End Date
 ;             -> CATLST     - Category List (Array)
 ;             -> COMM    - Community List (Array)
 ;  
 NEW BQ,TMFRAME,CAT,COMMTX
 ;
 ;Initialize output variables
 S CAT=$G(CAT,""),STATUS=$G(STATUS,""),TMFRAME=$G(TMFRAME,"")
 S COMM=$G(COMM,""),COMMTX=$G(COMMTX,""),BDT=$G(BDT,""),EDT=$G(EDT,"")
 ;
 ;Re-Assemble parameter list if in an array
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . N LIST,BN
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 ;Set up incoming variables
 F BQ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 .N PDATA,NAME,VALUE,BP,BV
 .S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 .S NAME=$P(PDATA,"=",1) Q:NAME=""
 .S VALUE=$P(PDATA,"=",2,99) Q:VALUE=""
 .F BP=1:1:$L(VALUE,$C(29)) S BV=$P(VALUE,$C(29),BP),@NAME=@NAME_$S(BP=1:"",1:$C(29))_BV
 ;
 ;Handle blank status
 S:STATUS="" STATUS="P"_$C(29)_"N"_$C(29)_"S"_$C(29)_"T"
 ;
 ;Set up search beginning/end dates
 S (BDT,EDT)=""
 I TMFRAME'="" D
 . I $E(TMFRAME,1)=">" S TMFRAME=$E(TMFRAME,2,99),EDT=$$DATE^BQIUL1(TMFRAME) Q
 . S BDT=$$DATE^BQIUL1(TMFRAME)
 ;
 ;Set up Community Taxonomy
 I COMMTX'="" D
 . N CM,TREF
 . S TREF="COMM" K @TREF
 . D BLD^BQITUTL(COMMTX,TREF)
 . S CM="" F  S CM=$O(COMM(CM)) Q:CM=""  S COMM=$G(COMM)_$S($G(COMM)]"":$C(29),1:"")_CM K COMM(CM)
 ;
 ;Set up Category List Array
 I CAT'="",CAT'=0 D
 . NEW CIN
 . F BQ=1:1:$L(CAT,$C(29)) S CIN=$P(CAT,$C(29),BQ),CATLST(CIN)=""
 ;
 ;Set up Community List Array
 S:'$D(COMM) COMM=""
 I COMM'="",COMM'=0 D
 . NEW CIN
 . F BQ=1:1:$L(COMM,$C(29)) S CIN=+$P(COMM,$C(29),BQ),COMM(CIN)=$P(^AUTTCOM(CIN,0),U,1)
 ;
 Q
 ;
PEFIL(STATUS,BDT,EDT,CATLST,COMM,QIEN) ;EP - Check entry on filters
 ;
 ; Input Parameters
 ; -> STATUS  - Status
 ; -> BDT     - Beginning Date
 ; -> EDT     - End Date
 ; -> CATLST  - Category List (Array)
 ; -> COMM    - Community List (Array)
 ; -> QIEN    - Pointer to CMET EVENT QUEUE (#90629) entry
 ;
 NEW PASS,VDT
 ;
 S STATUS=$G(STATUS,""),BDT=$G(BDT,""),EDT=$G(EDT,"")
 S PASS=1
 ;
 ;Beginning Date Check
 S VDT=$$GET1^DIQ(90629,QIEN_",",.03,"I")
 I BDT]"" D  I 'PASS G XPEFIL
 . I BDT>VDT S PASS=""
 ;
 ;End Date Check
 I EDT]"" D  I 'PASS G XPEFIL
 . I VDT>EDT S PASS=""
 ;
 ;Status Check
 I $TR(STATUS,$C(29))]"" D  I 'PASS G XPEFIL
 . NEW STS
 . S STS=$$GET1^DIQ(90629,QIEN_",",.08,"I")
 . I ($C(29)_STATUS_$C(29))'[($C(29)_STS_$C(29)) S PASS=""
 ;
 ;Category Check
 I $D(CATLST)>9 D  I 'PASS G XPEFIL
 . NEW CAT
 . S CAT=$$GET1^DIQ(90629,QIEN_",",.13,"I") Q:CAT=""
 . I '$D(CATLST(CAT)) S PASS=""
 ;
 ;Community Check
 I $D(COMM)>9 D  I 'PASS G XPEFIL
 . NEW DFN,PCOM
 . S DFN=$$GET1^DIQ(90629,QIEN_",",.02,"I") Q:DFN=""
 . S PCOM=$$GET1^DIQ(9000001,DFN_",",1117,"I") Q:PCOM=""
 . I '$D(COMM(PCOM)) S PASS=""
 ;
XPEFIL Q PASS
