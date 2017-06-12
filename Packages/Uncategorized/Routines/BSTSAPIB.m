BSTSAPIB ;GDIT/HS/BEE-Standard Terminology API Program ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,3,6**;Sep 10, 2014;Build 20
 ;
 Q
 ;
VALTERM(OUT,IN) ;PEP - Returns whether a given term is a valid
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
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
 ;
 ;     - P3 (Optional) - Snapshot Date to check (default DT)
 ;     - P4 (Optional) - LOCAL - Pass 1 or blank to perform local listing,
 ;                       Pass 2 for remote DTS listing
 ;     - P5 (Optional) - DEBUG - Pass 1 to display debug information
 ;     - P6 (Optional) - Mapping Parameters - Ex. EPI=288527008;VST=2087394;AF=With;PRB=50239
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 2:Remote information returned
 ;       1:Local information returned
 ;       0:No Information Returned
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 ; VAR(#) record(s) returned for any exact match
 ; Please see routine BSTSCDET, tag DETAIL for a detailed description of the
 ; information being returned by this API.
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSAPIB D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 N SEARCH,NMID,SNAPDT,MAX,LOCAL,NMIEN,RLIST,I,NSEARCH,C,%D
 N RESULT,DEBUG,BSTSR,BSTSI,BSTSWS,RES,BSTSD,X,%,%H,UPSRCH,INDATE
 K @OUT,STS
 ;
 I $G(DT)="" D DT^DICRW
 S IN=$G(IN,"")
 S SEARCH=$P(IN,U) I $TR(SEARCH," ")="" Q "0^Invalid Search String"
 S UPSRCH=$$UP^XLFSTR(SEARCH)
 S NMID=$P(IN,U,2) S:NMID="" NMID=36 S:NMID=30 NMID=36
 ;
 ;Convert namespace to number if needed
 I NMID'?1N.N D  I NMID="" Q "0^Invalid Namespace"
 . S NMID=$O(^BSTS(9002318.1,"D",NMID,"")) Q:NMID=""
 . S NMID=$$GET1^DIQ(9002318.1,NMID_",",".01","I")
 ;
 S SNAPDT=$P(IN,U,3) S:SNAPDT]"" SNAPDT=$$DATE^BSTSUTIL(SNAPDT)
 S:SNAPDT="" SNAPDT=DT_".0001"
 S INDATE=$P(SNAPDT,".")
 S SNAPDT=$$FMTE^BSTSUTIL(SNAPDT)
 S MAX=50
 S LOCAL=$P(IN,U,4),LOCAL=$S(LOCAL=2:"",1:"1")
 S DEBUG=$P(IN,U,5),DEBUG=$S(DEBUG=1:"1",1:"")
 ;
 ;Handle strings with "'"
 S NSEARCH="" F I=1:1:$L(SEARCH) S C=$E(SEARCH,I),NSEARCH=NSEARCH_$S(C="'":"'",1:"")_C
 S BSTSWS("SEARCH")=NSEARCH
 S BSTSWS("STYPE")="S"
 S BSTSWS("NAMESPACEID")=NMID
 S BSTSWS("SUBSET")=""
 S BSTSWS("SNAPDT")=SNAPDT
 S BSTSWS("INDATE")=INDATE
 S BSTSWS("MAXRECS")=MAX
 S BSTSWS("BCTCHRC")=""
 S BSTSWS("BCTCHCT")=""
 S BSTSWS("RET")="PSCBIXAV"
 S BSTSWS("DAT")=""
 S BSTSWS("EXACTMATCH")="T"
 S BSTSWS("MPPRM")=$P(IN,U,7) ;BSTS*1.0*6;Mapping parameters
 ;
 ;Check for new version
 D CHECK^BSTSVRSN
 ;
 ;Make DTS Lookup call
 S BSTSR=1
 I LOCAL'=1 S BSTSR=$$SEARCH^BSTSWSV("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;If no results, try performing local search
 I $D(RESULT)<10 S BSTSD=$$SRC^BSTSSRCH("RESULT",.BSTSWS)
 ;
 ;If local search and no record try DTS Lookup
 I $D(RESULT)<10,LOCAL S BSTSR=$$SEARCH^BSTSWSV("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;Now loop through and find exact term - Combine like terms
 ;
 S NMIEN=$O(^BSTS(9002318.1,"B",NMID,""))
 S RES="" F  S RES=$O(RESULT(RES)) Q:RES=""  D
 . N REC,DIEN,TIEN,TERM,MATCH
 . S MATCH=0
 . S REC=RESULT(RES)
 . S DIEN=$P(REC,U,3) Q:DIEN=""
 . S TIEN=$O(^BSTS(9002318.3,"D",NMIEN,DIEN,"")) Q:TIEN=""
 . S TERM=$$GET1^DIQ(9002318.3,TIEN_",",1,"E") Q:TERM=""
 . ;
 . ;Perform regular match
 . I UPSRCH=($$UP^XLFSTR(TERM)) S MATCH=1
 . ;
 . ;Perform special concept search for UNII
 . I MATCH=0,NMID=5180 D
 .. N FSN,CIEN,DSC,CON
 .. S CIEN=$$GET1^DIQ(9002318.3,TIEN_",",.03,"I") Q:CIEN=""
 .. S FSN=$$GET1^DIQ(9002318.4,CIEN_",",1,"I") Q:FSN=""
 .. I UPSRCH'=($$UP^XLFSTR(FSN)) Q
 .. S CON=$$GET1^DIQ(9002318.4,CIEN_",",.02,"I") Q:CON=""
 .. S DSC=$P($$CONC^BSTSAPI(CON_"^5180"),"^") Q:DSC=""
 .. S $P(RESULT(RES),U,3)=DSC
 .. S MATCH=1
 . ;
 . I MATCH=0 K RESULT(RES) Q
 . ;
 . Q:$D(RLIST($P(RESULT(RES),U,1,2)))
 . S RLIST($P(RESULT(RES),U,1,2))=$P(RESULT(RES),U,3)
 K RESULT S RES="" F I=1:1 S RES=$O(RLIST(RES)) Q:RES=""  S RESULT(I)=RES_U_RLIST(RES)
 ;
 ;Get the detail for the record
 S BSTSD=0
 I $D(RESULT)>1 D
 . S BSTSWS("STYPE")="S"
 . S BSTSD=$$DETAIL^BSTSSRCH(OUT,.BSTSWS,.RESULT)
 S $P(BSTSR,U)=$S(BSTSD=0:0,(+BSTSR)>0:+BSTSR,1:1)
 Q BSTSR
 ;
DSCLKP(OUT,IN) ;EP - Returns detail information for a specified Description Id
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  IN - P1 - The Description Id to look up
 ;     - P2 (Optional) - The code set Id (default SNOMED US EXT '36')
 ;     - P3 (Optional) - LOCAL - Pass 1 or blank to perform local listing,
 ;                       Pass 2 for remote DTS listing
 ;     - P4 (Optional) - DEBUG - Pass 1 to display debug information
 ;     - P5 (Optional) - Snapshot Date to check (default DT)
 ;     - P6 (Optional) - Mapping Parameters - Ex. EPI=288527008;VST=2087394;AF=With;PRB=50239
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
 ; Information returned is in the same (full detail) format
 ; as the detail returned for each record in the
 ; search API
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSAPIB D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ; 
 K @OUT
 ;
 N RESULT,SEARCH,NMID,SNAPDT,MAX,LOCAL,DEBUG,BSTSWS,BSTSR,BSTSD,X,%,%H,DIFILE,%D,INDATE
 ;
 I $G(DT)="" D DT^DICRW
 S IN=$G(IN,"")
 S SEARCH=$P(IN,U) I SEARCH="" Q "0^Invalid Description Id"
 S NMID=$P(IN,U,2) S:NMID="" NMID=36 S:NMID=30 NMID=36
 S SNAPDT=$P(IN,U,5)
 S:SNAPDT="" SNAPDT=DT
 S SNAPDT=SNAPDT_".2400"
 S INDATE=$P(SNAPDT,".")
 S SNAPDT=$$FMDT2XML^BSTSUTIL(SNAPDT)
 S MAX=100
 S LOCAL=$P(IN,U,3),LOCAL=$S(LOCAL=2:"",1:"1")
 S DEBUG=$P(IN,U,4),DEBUG=$S(DEBUG=1:"1",1:"")
 ;
 S BSTSWS("SEARCH")=SEARCH
 S BSTSWS("STYPE")="S"
 S BSTSWS("NAMESPACEID")=NMID
 S BSTSWS("SUBSET")=""
 S BSTSWS("SNAPDT")=SNAPDT
 S BSTSWS("INDATE")=INDATE
 S BSTSWS("MAXRECS")=MAX
 S BSTSWS("BCTCHRC")=""
 S BSTSWS("BCTCHCT")=""
 S BSTSWS("RET")="PSCBIXAV"
 S BSTSWS("DAT")=""
 S BSTSWS("MPPRM")=$P(IN,U,6) ;BSTS*1.0*6;Mapping parameters
 ;
 ;Make DTS Lookup call
 S BSTSR=1
 I LOCAL'=1 S BSTSR=$$DSCLKP^BSTSWSV("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;If no results, try performing local search
 I $D(RESULT)<10 S BSTSD=$$DSC^BSTSLKP("RESULT",.BSTSWS)
 ;
 ;If local search and no record try DTS Lookup
 I $D(RESULT)<10,LOCAL S BSTSR=$$DSCLKP^BSTSWSV("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;Get the detail for the record
 S BSTSD=0
 I $D(RESULT)>1 D
 . S BSTSD=$$DETAIL^BSTSSRCH(OUT,.BSTSWS,.RESULT)
 S $P(BSTSR,U)=$S(BSTSD=0:0,(+BSTSR)>0:+BSTSR,1:1)
 Q BSTSR
 ;
DTSLKP(OUT,IN) ;EP - Returns detail information for a specified DTS Id
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  IN - P1 - The DTS Id to look up
 ;     - P2 (Optional) - The code set Id (default SNOMED US EXT '36')
 ;     - P3 (Optional) - Snapshot Date to check (default DT)
 ;     - P4 (Optional) - LOCAL - Pass 1 to perform local listing, otherwise leave
 ;                       blank for remote listing
 ;     - P5 (Optional) - DEBUG - Pass 1 to display debug information
 ;     - P6 (System Use Only) - TBYPASS - Pass 1 to bypass server timeout checks, otherwise
 ;                              leave blank. Do not use for regular calls
 ;     - P7 (Optional) - Mapping Parameters - Ex. EPI=288527008;VST=2087394;AF=With;PRB=50239
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 2:Remote information returned
 ;       1:Local information returned
 ;       0:No Information Returned
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 ; VAR(#) record is returned for a match
 ; Information returned is in the same (full detail) format
 ; as the detail returned for each record in the
 ; search API
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSAPIB D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ; 
 K @OUT
 ;
 N RESULT,SEARCH,NMID,SNAPDT,MAX,LOCAL,DEBUG,BSTSWS,BSTSR,BSTSD,X,%,%H
 N DIFILE,%D,INDATE,TBYPASS
 ;
 I $G(DT)="" D DT^DICRW
 S IN=$G(IN,"")
 S SEARCH=$P(IN,U) I 'SEARCH Q "0^Invalid DTS Id"
 S NMID=$P(IN,U,2) S:NMID="" NMID=36 S:NMID=30 NMID=36
 S SNAPDT=$P(IN,U,3) S:SNAPDT]"" SNAPDT=$$DATE^BSTSUTIL(SNAPDT)
 ;BSTS*1.0*6;Default snapshot date to one day in the future
 ;S:SNAPDT="" SNAPDT=DT_".0001"
 I SNAPDT="" D
 . NEW X1,X2,X
 . S X1=DT,X2=1
 . D C^%DTC
 . S SNAPDT=X_".0001"
 S INDATE=$P(SNAPDT,".")
 S SNAPDT=$$FMTE^BSTSUTIL(SNAPDT)
 S MAX=100
 S LOCAL=$P(IN,U,4),LOCAL=$S(LOCAL=1:"1",1:"")
 S DEBUG=$P(IN,U,5),DEBUG=$S(DEBUG=1:"1",1:"")
 S TBYPASS=$P(IN,U,6),TBYPASS=$S(TBYPASS=1:"1",1:"")
 ;
 S BSTSWS("SEARCH")=SEARCH
 S BSTSWS("STYPE")="F"
 S BSTSWS("NAMESPACEID")=NMID
 S BSTSWS("SUBSET")=""
 S BSTSWS("SNAPDT")=SNAPDT
 S BSTSWS("INDATE")=INDATE
 S BSTSWS("MAXRECS")=MAX
 S BSTSWS("BCTCHRC")=""
 S BSTSWS("BCTCHCT")=""
 S BSTSWS("RET")="PSCBIXAV"
 S BSTSWS("DAT")=""
 S BSTSWS("TBYPASS")=TBYPASS
 S BSTSWS("MPPRM")=$P(IN,U,7) ;BSTS*1.0*6;Mapping parameters
 ;
 ;Make DTS Lookup call
 S BSTSR=1
 ;
 I LOCAL'=1 S BSTSR=$$DTSSR^BSTSWSV("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;If no results, try performing local search
 I $D(RESULT)<10 S BSTSD=$$DTS^BSTSLKP("RESULT",.BSTSWS)
 ;
 ;If no results and local, make DTS call
 I $D(RESULT)<10,LOCAL S BSTSR=$$DTSSR^BSTSWSV("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;Get the detail for the record
 S BSTSD=0
 I $D(RESULT)>1 D
 . S BSTSWS("STYPE")="F"
 . S BSTSD=$$DETAIL^BSTSSRCH(OUT,.BSTSWS,.RESULT)
 S $P(BSTSR,U)=$S(BSTSD=0:0,(+BSTSR)>0:+BSTSR,1:1)
 Q BSTSR
 ;
CNCLKP(OUT,IN) ;EP - Returns detail information for a specified Concept Id
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  IN - P1 - The Concept Id to look up
 ;     - P2 (Optional) - The code set Id (default SNOMED US EXT '36')
 ;     - P3 (Optional) - Snapshot Date to check (default DT)
 ;     - P4 (Optional) - LOCAL - Pass 1 or blank to perform local listing,
 ;                       Pass 2 for remote DTS listing
 ;     - P5 (Optional) - DEBUG - Pass 1 to display debug information
 ;     - P6 (Optional) - Mapping Parameters - Ex. EPI=288527008;VST=2087394;AF=With;PRB=50239
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 2:Remote information returned
 ;       1:Local information returned
 ;       0:No Information Returned
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 ; VAR(#) record is returned for a match
 ; Information returned is in the same (full detail) format
 ; as the detail returned for each record in the
 ; search API
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSAPIB D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 K @OUT
 ;
 N RESULT,SEARCH,NMID,SNAPDT,MAX,LOCAL,DEBUG,BSTSWS,BSTSR,BSTSD,X,%,%H,DIFILE,%D,INDATE
 ;
 I $G(DT)="" D DT^DICRW
 S IN=$G(IN,"")
 S SEARCH=$P(IN,U) I SEARCH="" Q "0^Invalid Concept Id"
 S NMID=$P(IN,U,2) S:NMID="" NMID=36 S:NMID=30 NMID=36
 S SNAPDT=$P(IN,U,3) S:SNAPDT="" SNAPDT=DT
 S INDATE=$P(SNAPDT,".")
 S SNAPDT=SNAPDT_".2400"
 S SNAPDT=$$FMDT2XML^BSTSUTIL(SNAPDT)
 S MAX=100
 S LOCAL=$P(IN,U,4),LOCAL=$S(LOCAL=2:"",1:"1")
 S DEBUG=$P(IN,U,5),DEBUG=$S(DEBUG=1:"1",1:"")
 ;
 S BSTSWS("SEARCH")=SEARCH
 S BSTSWS("STYPE")="F"
 S BSTSWS("NAMESPACEID")=NMID
 S BSTSWS("SUBSET")=""
 S BSTSWS("SNAPDT")=SNAPDT
 S BSTSWS("INDATE")=INDATE
 S BSTSWS("MAXRECS")=MAX
 S BSTSWS("BCTCHRC")=""
 S BSTSWS("BCTCHCT")=""
 S BSTSWS("RET")="PSCBIXAV"
 S BSTSWS("DAT")=""
 S BSTSWS("MPPRM")=$P(IN,U,6) ;BSTS*1.0*6;Mapping parameters
 ;
 ;Make DTS Lookup call
 S BSTSR=1
 I LOCAL'=1 S BSTSR=$$CNCSR^BSTSWSV("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;If no results, try performing local search
 I $D(RESULT)<10 S BSTSD=$$CNC^BSTSLKP("RESULT",.BSTSWS)
 ;
 ;If local search and no results try doing DTS lookup
 I $D(RESULT)<10,LOCAL S BSTSR=$$CNCSR^BSTSWSV("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;Get the detail for the record
 S BSTSD=0
 I $D(RESULT)>1 D
 . S BSTSWS("STYPE")="F"
 . S BSTSD=$$DETAIL^BSTSSRCH(OUT,.BSTSWS,.RESULT)
 S $P(BSTSR,U)=$S(BSTSD=0:0,(+BSTSR)>0:+BSTSR,1:1)
 Q BSTSR
 ;
VALSBTRM(OUT,IN) ;EP - Returns whether a given term is in a particular subset
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  IN - P1 - Description Id of term to check
 ;     - P2 - The subset to look in
 ;     - P3 (Optional) - The code set Id (default SNOMED US EXT '36')
 ;     - P4 (Optional) - LOCAL - Pass 1 or blank to perform local listing,
 ;                       Pass 2 for remote DTS listing
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
 ; Single VAR record is returned
 ; VAR = 1:Term is in the provided subset, 0:Term is not in the provided subset
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSAPIB D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 NEW NMID,DSC,SUB,LOCAL,DEBUG,DIN,SBVAR,BSTSR,SB,%D
 ;
 K @OUT
 ;
 I $G(DT)="" D DT^DICRW
 S IN=$G(IN,"")
 S NMID=$P(IN,U,3) S:NMID="" NMID=36 S:NMID=30 NMID=36
 S DSC=$P(IN,U) I DSC="" S @OUT=0 Q "0^Missing Description Id"
 S SUB=$P(IN,U,2) I SUB="" S @OUT=0 Q "0^Missing Subset"
 S LOCAL=$P(IN,U,4)
 S DEBUG=$P(IN,U,5)
 S DIN=DSC_U_NMID_U_LOCAL_U_DEBUG
 ;
 ;Retrieve the detail for the term
 S BSTSR=$$DSCLKP^BSTSAPI("SBVAR",DIN)
 ;
 S @OUT=0
 ;
 ;Loop through subsets for a match
 S SB="" F  S SB=$O(SBVAR(1,"SUB",SB)) Q:SB=""  I $G(SBVAR(1,"SUB",SB,"SUB"))=SUB S @OUT=1 Q
 ;
 Q BSTSR
 ;
ERR ;
 D ^%ZTER
 Q
