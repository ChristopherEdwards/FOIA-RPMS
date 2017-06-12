BSTSAPIF ;GDIT/HS/BEE-Standard Terminology API Function Calls ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,3,7,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
VSBTRMF(IN) ;PEP - Returns whether a given term is in a particular subset
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  IN - P1 - Description Id of term to check
 ;     - P2 - The subset to look in
 ;     - P3 (Optional) - The code set Id (default SNOMED US EXT '36')
 ;     - P4 (Optional) - LOCAL - Pass 1 to perform local listing, otherwise leave
 ;                       blank for remote listing
 ;     - P5 (Optional) - DEBUG - Pass 1 to display debug information
 ;
 ;Output
 ;
 ; VAR = 1:Term is in the provided subset
 ;       0:Term is not in the provided subset
 ;
 NEW FOUT,STS,%D
 ;
 S STS=$$VALSBTRM^BSTSAPIB("FOUT",IN)
 Q FOUT
 ;
ICD2SMD(OUT,IN) ;EP - Returns a list of SMOMED codes for the specified ICD9 code
 ;
 ;Input
 ; OUT - OUTPUT array of SNOMED concepts to return
 ;  IN - The ICD9 Code to search on
 ;
 I $G(IN)="" Q
 ;
 NEW NMID,CIEN,RCNT,%D
 ;
 ;Get IEN for SNOMED
 S NMID=$O(^BSTS(9002318.1,"B",36,"")) Q:NMID=""
 ;
 ;Loop through entries and find matches
 S RCNT=0,CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"I",NMID,IN,CIEN)) Q:CIEN=""  D
 . ;
 . NEW DTSID,CONC
 . ;
 . S DTSID=$$GET1^DIQ(9002318.4,CIEN_",",.08,"I") Q:DTSID=""
 . ;
 . S CONC=$$GET1^DIQ(9002318.4,CIEN_",",.02,"I") Q:CONC=""
 . ;
 . ;Set up return entry
 . S RCNT=RCNT+1 S @OUT@(RCNT)=CONC_U_DTSID
 Q 1
 ;
DILKP(OUT,IN) ;EP - Performs a drug ingredient lookup on a specified value
 ;
 ;Input
 ;  IN - P1 - The exact term to lookup
 ;     - P2 - Lookup Type (N-NDC,V-VUID)
 ;     - P3 (Optional) - LOCAL - Pass 1 or blank to perform local listing
 ;                       Pass 2 for a remote DTS listing
 ;     - P4 (Optional) - DEBUG - Pass 1 to display debug information
 ;     - P5 (System Use Only) - TBYPASS - Pass 1 to bypass server timeout checks, otherwise
 ;                              leave blank. Do not use for regular calls
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 2:Remote information returned
 ;       1:Local information returned
 ;       0:No Information Returned
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 ; VAR(#) record is returned for any exact match
 ; 
 ; VAR(1,"RXN","CON")=RxNorm Code
 ; VAR(1,"RXN","TRM")=RxNorm Term
 ; VAR(1,"RXN","TDC")=RxNorm Tradename code
 ; VAR(1,"RXN","TDT")=RxNorm Tradename term
 ; VAR(1,"RXN","TTY")=First TTY value for the RxNorm
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSAPIF D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 N SEARCH,NMID,SNAPDT,MAX,LOCAL,NMIEN,RLIST,I,LTYPE,RXSTR,UNSTR,%D
 N RESULT,DEBUG,BSTSR,BSTSI,BSTSWS,RES,BSTSD,X,%,%H,UPSRCH,CONC,CONCDT,TBYPASS
 K @OUT
 ;
 I $G(DT)="" D DT^DICRW
 S IN=$G(IN,"")
 S SEARCH=$P(IN,U) I $TR(SEARCH," ")="" Q "0^Invalid Search String"
 S LTYPE=$P(IN,U,2) I LTYPE'="N",LTYPE'="V" Q "0^Invalid Lookup Type"
 S SNAPDT=DT_".2400"
 S SNAPDT=$$FMDT2XML^BSTSUTIL(SNAPDT)
 S LOCAL=$P(IN,U,3),LOCAL=$S(LOCAL=2:"",1:"1")
 S DEBUG=$P(IN,U,4),DEBUG=$S(DEBUG=1:"1",1:"")
 S TBYPASS=$P(IN,U,5),TBYPASS=$S(TBYPASS=1:"1",1:"")
 ;
 S BSTSWS("SEARCH")=SEARCH
 S BSTSWS("SNAPDT")=SNAPDT
 S BSTSWS("MAXRECS")=100
 S BSTSWS("TBYPASS")=TBYPASS
 ;
 S BSTSWS("NAMESPACEID")=1552
 I LTYPE="N" S BSTSWS("PROPERTY")=110,BSTSWS("LTYPE")="N"
 E  S BSTSWS("PROPERTY")=209,BSTSWS("LTYPE")="V"
 S NMID=1552
 ;
 ;Perform RxNorm DTS Lookup
 ;
 ;Make DTS Lookup call
 S BSTSR=1,BSTSD=""
 I LOCAL'=1 S BSTSR=$$DILKP^BSTSWSV1("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;If no results, try performing local search
 I $D(RESULT)<10 S BSTSD=$$VNLKP^BSTSLKP("RESULT",.BSTSWS)
 ;
 ;If local search and no record try DTS Lookup
 I $D(RESULT)<10,LOCAL S BSTSR=$$DILKP^BSTSWSV1("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2,BSTSD=""
 ;
 ;Define output for no results
 S:$D(RESULT)<10 BSTSD=0
 ;
 ;Get the concept information
 S CONC=$P($G(RESULT(1)),U)
 S RXSTR=""
 ;
 S:CONC]"" RXSTR=$$CNCLKP^BSTSAPI("CONCDT",CONC_"^"_BSTSWS("NAMESPACEID")_"^^1")
 S @OUT@(1,"RXN","CON")=CONC
 S @OUT@(1,"RXN","TRM")=$G(CONCDT(1,"FSN","TRM")) ;$P(RXSTR,U,2)
 S @OUT@(1,"RXN","TDC")=$G(CONCDT(1,"IAR",1,"CON"))
 S @OUT@(1,"RXN","TDT")=$G(CONCDT(1,"IAR",1,"TRM"))
 S @OUT@(1,"RXN","TTY")=$G(CONCDT(1,"TTY",1,"TTY"))
 ;
 S $P(BSTSR,U)=$S(BSTSD=0:0,(+BSTSR)>0:+BSTSR,1:1)
 Q BSTSR
 ;
ASSOC(IN) ;EP - Returns the associations for each type (SMD, RxNorm, UNII)
 ;
 ;Input
 ;  IN - P1 - The exact term to lookup
 ;     - P2 (Optional) - The code set Id or Name (default SNOMED US EXT '36')
 ;                          ID      NAME
 ;                          32770   ECLIPS
 ;                          5180    FDA UNII
 ;                          32773   GMRA Allergies with Maps
 ;                          32772   GMRA Signs Symptoms
 ;                          32771   IHS VANDF
 ;                          32774   IHS Med Route
 ;                          1552    RxNorm R
 ;                          36      SNOMED CT US Extension
 ;     - P3 (Optional) - Snapshot Date to check (default DT)
 ;     - P4 (Optional) - LOCAL - Pass 1 or blank to perform local listing
 ;                       Pass 2 for remote DTS listing
 ;     - P5 (Optional) - DEBUG - Pass 1 to display debug information
 ;
 ;Output
 ;Function returns - [1]^[2]^[3]
 ; Where:
 ; [1] - SNOMED Association(s) - ";" Delimited
 ; [2] - RxNorm Association(s) - ";" Delimited
 ; [3] - UNII Association(s) - ";" Delimited
 ;
 NEW RES,BSTSVAR,%D
 ;
 S RES=$$VALTERM^BSTSAPI("BSTSVAR",$G(IN))
 I +RES D  Q RES
 . ;
 . NEW CNT,SMD,RXN,UNI,CON
 . ;
 . ;SNOMED
 . S (SMD,CNT)="" F  S CNT=$O(BSTSVAR(1,"ASM",CNT)) Q:CNT=""  D
 .. S CON=$G(BSTSVAR(1,"ASM",CNT,"CON")) Q:CON=""
 .. S SMD=SMD_$S(SMD]"":";",1:"")_CON
 . ;
 . ;RxNorm
 . S (RXN,CNT)="" F  S CNT=$O(BSTSVAR(1,"ARX",CNT)) Q:CNT=""  D
 .. S CON=$G(BSTSVAR(1,"ARX",CNT,"CON")) Q:CON=""
 .. S RXN=RXN_$S(RXN]"":";",1:"")_CON
 . ;
 . ;UNII
 . S (UNI,CNT)="" F  S CNT=$O(BSTSVAR(1,"AUN",CNT)) Q:CNT=""  D
 .. S CON=$G(BSTSVAR(1,"AUN",CNT,"CON")) Q:CON=""
 .. S UNI=UNI_$S(UNI]"":";",1:"")_CON
 .;
 . S RES=SMD_U_RXN_U_UNI
 ;
 Q ""
 ;
DI2RX(IN) ;EP - Performs a drug ingredient lookup on a specified value
 ; Returns only the first RxNorm mapping as a function call output
 ;
 ;Input
 ;  IN - P1 - The exact term to lookup
 ;     - P2 - Lookup Type (N-NDC,V-VUID)
 ;     - P3 (Optional) - LOCAL - Pass 1 or blank to perform local listing,
 ;                       Pass 2 for remote DTS listing
 ;     - P4 (Optional) - DEBUG - Pass 1 to display debug information
 ;
 ;Output
 ; Function returns - [1]^[2]
 ; [1] - The RxNorm Code of the first RxNorm mapping (if more than one)
 ; [2] - The RxNorm Term of the first RxNorm mapping
 ; [3] - The RxNorm Tradename code
 ; [4] - The RxNorm Tradename term
 ; [5] - The first TTY value for the RxNorm
 ;
 ;
 NEW DOUT,STS,RES,%D
 ;
 S STS=$$DILKP^BSTSAPI("DOUT",IN)
 I 'STS Q ""
 S $P(RES,U)=$G(DOUT(1,"RXN","CON"))
 S $P(RES,U,2)=$G(DOUT(1,"RXN","TRM"))
 S $P(RES,U,3)=$G(DOUT(1,"RXN","TDC"))
 S $P(RES,U,4)=$G(DOUT(1,"RXN","TDT"))
 S $P(RES,U,5)=$G(DOUT(1,"RXN","TTY"))
 Q RES
 ;
USEARCH(OUT,IN) ;EP - Perform Codeset Universe Search
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  IN - P1 - Search string
 ;     - P2 - Search Type - (F-Fully specified name, S-Synonyms)
 ;     - P3 (Optional) - Namespace ID - Default to SNOMED US EXT (#36)
 ;                     ID      NAME
 ;                     5180    FDA UNII
 ;                     32773   GMRA Allergies with Maps
 ;                     32772   GMRA Signs Symptoms
 ;                     32771   IHS VANDF
 ;                     1552    RxNorm R
 ;                     36      SNOMED CT US Extension
 ; 
 ;     - P4 (Optional) - Maximum number of concepts/terms to return (default 25)
 ;     - P5 (Optional) - DEBUG - Pass 1 to display debug information
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 2:Remote information returned
 ;       1:Local information returned
 ;       0:No Information Returned
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 ; VAR(#) - List of Records
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSAPIF D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 N SEARCH,STYPE,NMID,SUB,SNAPDT,MAX,BCTCHRC,BCTCHCT,LOCAL,SLIST,%D
 N RESULT,DEBUG,BSTSR,BSTSI,RET,DAT,BSTSWS,BSTSD,X,%,%H,INDATE
 K @OUT
 ;
 I $G(U)="" S U="^"
 I $G(DT)="" D DT^DICRW
 S IN=$G(IN,"")
 S SEARCH=$P(IN,U) Q:($TR(SEARCH," ")="") "0^Invalid Search String"
 S STYPE=$P(IN,U,2) I STYPE'="F",STYPE'="S" Q "0^Invalid Search Type"
 S NMID=$P(IN,U,3) S:NMID="" NMID=36 S:NMID=30 NMID=36
 S SUB=$P(IN,U,6)
 S SNAPDT="" S:SNAPDT]"" SNAPDT=$$DATE^BSTSUTIL(SNAPDT)
 S INDATE=$P(SNAPDT,".")
 S:SNAPDT="" SNAPDT=DT_".0001"
 S SNAPDT=$$FMTE^BSTSUTIL(SNAPDT)
 S MAX=$P(IN,U,5) S:'MAX MAX=25
 S RET="PSBIXCA"
 S DAT=""
 S BCTCHRC=""
 S BCTCHCT="" I BCTCHRC,'BCTCHCT S BCTCHCT=MAX
 S LOCAL=""
 S DEBUG=$P(IN,U,6),DEBUG=$S(DEBUG=1:"1",1:"")
 ;
 S BSTSWS("SEARCH")=SEARCH
 S BSTSWS("STYPE")=STYPE
 S BSTSWS("NAMESPACEID")=NMID
 S BSTSWS("SUBSET")=SUB
 S BSTSWS("SNAPDT")=SNAPDT
 S BSTSWS("INDATE")=INDATE
 S BSTSWS("MAXRECS")=MAX
 S BSTSWS("BCTCHRC")=BCTCHRC
 S BSTSWS("BCTCHCT")=BCTCHCT
 S BSTSWS("RET")=RET
 S BSTSWS("DAT")=DAT
 S BSTSWS("DEBUG")=DEBUG
 ;
 S BSTSI=0
 ;
 ;Make DTS search call
 S BSTSR=1
 ;
 ;DTS Call
 S BSTSR=$$USEARCH^BSTSWSV1(OUT,.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;Now loop through and get the detail
 I $D(RESULT) D
 . ;
 . NEW DLIST,ERSLT
 . ;
 . ;Define scratch global
 . S DLIST=$NA(^TMP("BSTSCMCL",$J)) ;DTS Return List
 . ;
 . NEW RCNT
 . ;
 . S RCNT="" F  S RCNT=$O(RESULT(RCNT)) Q:RCNT=""  D
 .. ;
 .. NEW REC,CONCID,DTSID,DSCID,STATUS
 .. S REC=RESULT(RCNT)
 .. ;
 .. S CONCID=$P(RESULT(RCNT),"^")
 .. S DTSID=$P(RESULT(RCNT),"^",2)
 .. S DSCID=$P(RESULT(RCNT),"^",3)
 .. ;
 .. ;Not Found or in need of update
 .. S BSTSWS("DTSID")=DTSID
 .. ;
 .. ;Clear result file
 .. K @DLIST
 .. ;
 .. ;Get Detail for concept
 .. S STATUS=$$DETAIL^BSTSCMCL(.BSTSWS,.ERSLT)
 .. ;
 .. ;Assemble output for RPC
 .. S @SLIST@(RCNT)=$P($G(@DLIST@(1,"CONCEPTID")),U)
 ;
 Q BSTSR
 ;
 ;BSTS*1.0*7;Added EQUIV API Call
EQUIV(OUT,IN) ;PEP - Returns equivalent laterality concepts
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  IN - P1 - Concept Id
 ;     - P2 - Laterality Attribute|Qualifier
 ;            7771000 or 272741003|7771000 - Laterality|Left
 ;            24028007 or 272741003|24028007 - Laterality|Right
 ;            51440002 or 272741003|51440002 - Laterality|Bilateral
 ;
 ;Output
 ; OUT(#) = Matching Concept ID [1] ^ Matching Laterality Attribute|Qualifier [2] ^ Exact Match (1/0) [3]
 ;          ^ entry is lateralized or is an equivalent lateralized concept (1/0)
 ;
 NEW CONC,LAT,NCNT,BSTSVAR,STS,ENTLOG,AT,ECNC,ATLAT,MLAT
 ;
 I $G(IN)="" Q
 I $G(OUT)="" Q
 ;
 K @OUT
 ;
 ;Retrieve concept id
 S CONC=$P(IN,U) Q:CONC=""
 S ATLAT=$P(IN,U,2) I ATLAT]"",$L(ATLAT,"|")=1 S ATLAT="272741003"_"|"_ATLAT
 S LAT=$P(ATLAT,"|",2)
 S AT=$P(ATLAT,"|")
 ;
 ;Get the concept detail
 S STS=$$CNCLKP^BSTSAPI("BSTSVAR",CONC)
 ;
 ;Set up the passed in entry, and if laterality non-lateralized entry
 S NCNT=$G(NCNT)+1,@OUT@(NCNT)=CONC_U_ATLAT_U_1_U_$S(ATLAT]"":1,$G(BSTSVAR(1,"EQM","LAT"))]"":1,1:"0")
 I ATLAT="" S ENTLOG(CONC)=""
 E  S ENTLOG(CONC,ATLAT)=""
 I ATLAT]"" D
 . S NCNT=$G(NCNT)+1,@OUT@(NCNT)=CONC_U_U_0_U
 . S ENTLOG(CONC)=""
 ;
 ;Now look for a matching equivalant concept
 S ECNC=$G(BSTSVAR(1,"EQM","CON")) I ECNC]"" D
 . NEW ELAT
 . S ELAT=$G(BSTSVAR(1,"EQM","LAT")) S:ELAT]"" ELAT="272741003|"_$O(^BSTS(9002318.6,"D","LAT",ELAT,""))
 . S NCNT=$G(NCNT)+1,@OUT@(NCNT)=ECNC_U_ELAT_U_1_U
 . I ELAT="" S ENTLOG(ECNC)="" Q
 . ;
 . ;Log entry
 . S ENTLOG(ECNC,ELAT)=""
 . ;
 . ;If laterality, catch the parent concept as well as non-exact match
 . S NCNT=$G(NCNT)+1,@OUT@(NCNT)=ECNC_U_U_0_U
 . Q
 ;
 ;Now look for a concept with matching laterality
 S MLAT="" F  S MLAT=$O(BSTSVAR(1,"EQC",MLAT)) Q:MLAT=""  D
 . NEW ILAT,CON
 . ;
 . ;Get SNOMED for the laterality
 . S ILAT=$O(^BSTS(9002318.6,"D","LAT",MLAT,"")) Q:ILAT=""
 . ;
 . ;Get the concept
 . S CON=$G(BSTSVAR(1,"EQC",MLAT,"CON"))
 . ;
 . ;Look for match - if not a match return as non-exact match
 . I LAT'=ILAT D  Q
 .. I LAT="" D
 ... S NCNT=$G(NCNT)+1,@OUT@(NCNT)=CON_U_U_0_U
 ... I $G(BSTSVAR(1,"LAT")),'$D(ENTLOG(CONC,ILAT)) S NCNT=$G(NCNT)+1,@OUT@(NCNT)=CONC_U_"272741003|"_ILAT_U_0
 . ;
 . ;Set entry
 . S NCNT=$G(NCNT)+1,@OUT@(NCNT)=CON_U_U_1_U
 ;
 Q
 ;
ERR ;
 D ^%ZTER
 Q
