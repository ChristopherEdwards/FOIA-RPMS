BSTSAPIC ;GDIT/HS/BEE-Standard Terminology API Program ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,3,4**;Sep 10, 2014;Build 32
 ;
 Q
 ;
MPADVICE(OUT,IN) ;EP - Returns ICD-10 mapping information for a specified Concept Id
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  IN - P1 - The Concept Id to look up
 ;     - P2 (Optional) - LOCAL - Pass 1 to perform local listing,
 ;                       Pass 2 for remote DTS listing
 ;     - P3 (Optional) - Exclude add/retired date information
 ;     - P4 (Optional) - DEBUG - Pass 1 to display debug information
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
 ; The VAR(#) list of records returns the mapping information on file for
 ; the specified concept. Multiple records per concept could be returned.
 ;
 ;Format:
 ; VAR(#,"MPADV","VAL")=Mapping Advice
 ; VAR(#,"MPADV","XADT")=Mapping Advice add date
 ; VAR(#,"MPADV","XRDT")=Mapping Advice retire date
 ; VAR(#,"MPCVL","VAL")=Mapping Category Value
 ; VAR(#,"MPCVL","XADT")="Mapping Category Value add date
 ; VAR(#,"MPCVL","XRDT")="Mapping Category Value retire date
 ; VAR(#,"MPGRP","VAL")=Map Group
 ; VAR(#,"MPGRP","XADT")=Map Group add date
 ; VAR(#,"MPGRP","XRDT")=Map Group retire date
 ; VAR(#,"MPPRI","VAL")=Map Priority
 ; VAR(#,"MPPRI","XADT")=Map Priority add date
 ; VAR(#,"MPPRI","XRDT")=Map Priority retire date
 ; VAR(#,"MPRUL","VAL")=Map Rule
 ; VAR(#,"MPRUL","XADT")=Map Rule add date
 ; VAR(#,"MPRUL","XRDT")=Map Rule retire date
 ; VAR(#,"MPTGN","VAL")=Map Target Name
 ; VAR(#,"MPTGN","XADT")=Map Target Name add date
 ; VAR(#,"MPTGN","XRDT")=Map Target Name retire date
 ; VAR(#,"MPTGT","VAL")=Map Target
 ; VAR(#,"MPTGT","XADT")=Map Target add date
 ; VAR(#,"MPTGT","XRDT")=Map Target retire date
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSAPIC D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 K @OUT
 ;
 N RESULT,SEARCH,NMID,SNAPDT,MAX,LOCAL,DEBUG,BSTSWS,BSTSR,BSTSD,X,%,%H,DAT,%D
 ;
 I $G(DT)="" D DT^DICRW
 S IN=$G(IN,"")
 S SEARCH=$P(IN,U) I 'SEARCH Q "0^Invalid Concept Id"
 S NMID=36
 S SNAPDT=""
 S MAX=100
 S LOCAL=$P(IN,U,2),LOCAL=$S(LOCAL=2:"",1:"1")
 S DAT=$P(IN,U,3)
 S DEBUG=$P(IN,U,4),DEBUG=$S(DEBUG=1:"1",1:"")
 ;
 S BSTSWS("SEARCH")=SEARCH
 S BSTSWS("STYPE")="F"
 S BSTSWS("NAMESPACEID")=NMID
 S BSTSWS("SUBSET")=""
 S BSTSWS("SNAPDT")=SNAPDT
 S BSTSWS("MAXRECS")=MAX
 S BSTSWS("DAT")=DAT
 ;
 ;Make DTS Lookup call
 S BSTSR=1
 I LOCAL'=1 S BSTSR=$$CNCSR^BSTSWSV("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;If no results, try performing local search
 I $D(RESULT)<10 S BSTSD=$$CNC^BSTSLKP("RESULT",.BSTSWS)
 ;
 ;If no results and local, try performing DTS lookup
 I $D(RESULT)<10,LOCAL S BSTSR=$$CNCSR^BSTSWSV("RESULT",.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;Get the detail for the record
 S BSTSD=""
 I $D(RESULT)>1 D
 . S BSTSD=$$ICDMAP(OUT,.BSTSWS,.RESULT)
 S $P(BSTSR,U)=$S(BSTSD=0:0,(+BSTSR)>0:+BSTSR,1:1)
 Q BSTSR
 ;
ICDMAP(OUT,BSTSWS,RESULT) ;EP - Set up mapping output information
 ;
 ;Input
 ; BSTSWS Array
 ; RESULT - [1]^[2]^[3]
 ;          [1] - Concept ID
 ;          [2] - DTS ID
 ;          [3] - Description Id
 ;
 ;Output
 ; Function returns - # Records Returned
 ;
 ; VAR(#) - List of Records - See above call for format
 ;
 N CNT,INMID,XNMID,MCNT,DFLD,%D
 ;
 ;Get the Namespace ID
 S XNMID=$G(BSTSWS("NAMESPACEID"))
 ;
 ;Determine whether to return date fields
 S DFLD=$G(BSTSWS("DAT")) S DFLD=1
 ;
 ;Pull return request
 S INMID=$O(^BSTS(9002318.1,"B",XNMID,""))
 ;
 S MCNT=0,CNT="" F  S CNT=$O(RESULT(CNT)) Q:CNT=""  D
 . ;
 . N CONC,CIEN,MIEN
 . ;
 . ;Get Concept IEN
 . S CONC=$P(RESULT(CNT),U)
 . S CIEN=$O(^BSTS(9002318.4,"C",NMID,CONC,"")) Q:CIEN=""
 . ;
 . ;Pull Mapping Information
 . S (MCNT,MIEN)=0 F  S MIEN=$O(^BSTS(9002318.4,CIEN,2,MIEN)) Q:'MIEN  D
 .. ;
 .. NEW MG,MGRIN,MGROUT,DA,IENS,MP,MPRIN,MPROUT
 .. NEW MT,MTRIN,MTROUT
 .. ;
 .. S DA(1)=CIEN,DA=MIEN,IENS=$$IENS^DILF(.DA)
 .. ;
 .. ;Pull Map Group
 .. S MG=$$GET1^DIQ(9002318.42,IENS,.02,"I")
 .. S MGRIN=$$GET1^DIQ(9002318.42,IENS,.03,"I")
 .. S MGROUT=$$GET1^DIQ(9002318.42,IENS,.04,"I")
 .. S MCNT=MCNT+1
 .. S @OUT@(MCNT,"MPGRP","VAL")=MG
 .. I 'DFLD S @OUT@(MCNT,"MPGRP","XADT")=MGRIN
 .. I 'DFLD S @OUT@(MCNT,"MPGRP","XRDT")=MGROUT
 .. ;
 .. ;Pull Map Priority
 .. S MP=$$GET1^DIQ(9002318.42,IENS,.05,"I")
 .. S MPRIN=$$GET1^DIQ(9002318.42,IENS,.06,"I")
 .. S MPROUT=$$GET1^DIQ(9002318.42,IENS,.07,"I")
 .. S @OUT@(MCNT,"MPPRI","VAL")=MP
 .. I 'DFLD S @OUT@(MCNT,"MPPRI","XADT")=MGRIN
 .. I 'DFLD S @OUT@(MCNT,"MPPRI","XRDT")=MGROUT
 .. ;
 .. ;Pull Map Target
 .. S MT=$$GET1^DIQ(9002318.42,IENS,.08,"I")
 .. S MTRIN=$$GET1^DIQ(9002318.42,IENS,.09,"I")
 .. S MTROUT=$$GET1^DIQ(9002318.42,IENS,.1,"I")
 .. S @OUT@(MCNT,"MPTGT","VAL")=MT
 .. I 'DFLD S @OUT@(MCNT,"MPTGT","XADT")=MTRIN
 .. I 'DFLD S @OUT@(MCNT,"MPTGT","XRDT")=MTROUT
 .. ;
 .. ;Pull Map Advice
 .. D
 ... NEW X,WP,II,MA,LINE,MARIN,MAROUT
 ... S X=$$GET1^DIQ(9002318.42,IENS,1,"","WP")
 ... S MA=""
 ... S II="" F  S II=$O(WP(II)) Q:II=""  S LINE=WP(II) I LINE]"" D
 .... S MA=MA_$S(MA]"":" ",1:"")_LINE
 ... S MARIN=$$GET1^DIQ(9002318.42,IENS,5.01,"I")
 ... S MAROUT=$$GET1^DIQ(9002318.42,IENS,5.02,"I")
 ... S @OUT@(MCNT,"MPADV","VAL")=MA
 ... I 'DFLD S @OUT@(MCNT,"MPADV","XADT")=MARIN
 ... I 'DFLD S @OUT@(MCNT,"MPADV","XRDT")=MAROUT
 .. ;
 .. ;Pull Map Target Name
 .. D
 ... NEW X,WP,II,MT,LINE,MTRIN,MTROUT
 ... S X=$$GET1^DIQ(9002318.42,IENS,2,"","WP")
 ... S MT=""
 ... S II="" F  S II=$O(WP(II)) Q:II=""  S LINE=WP(II) I LINE]"" D
 .... S MT=MT_$S(MT]"":" ",1:"")_LINE
 ... S MTRIN=$$GET1^DIQ(9002318.42,IENS,5.05,"I")
 ... S MTROUT=$$GET1^DIQ(9002318.42,IENS,5.06,"I")
 ... S @OUT@(MCNT,"MPTGN","VAL")=MT
 ... I 'DFLD S @OUT@(MCNT,"MPTGN","XADT")=MTRIN
 ... I 'DFLD S @OUT@(MCNT,"MPTFN","XRDT")=MTROUT
 .. ;
 .. ;Pull Map Rule
 .. D
 ... NEW X,WP,II,MR,LINE,MRRIN,MRROUT
 ... S X=$$GET1^DIQ(9002318.42,IENS,3,"","WP")
 ... S MR=""
 ... S II="" F  S II=$O(WP(II)) Q:II=""  S LINE=WP(II) I LINE]"" D
 .... S MR=MR_$S(MR]"":" ",1:"")_LINE
 ... S MRRIN=$$GET1^DIQ(9002318.42,IENS,5.03,"I")
 ... S MRROUT=$$GET1^DIQ(9002318.42,IENS,5.04,"I")
 ... S @OUT@(MCNT,"MPRUL","VAL")=MR
 ... I 'DFLD S @OUT@(MCNT,"MPRUL","XADT")=MRRIN
 ... I 'DFLD S @OUT@(MCNT,"MPRUL","XRDT")=MRROUT
 .. ;
 .. ;Pull Map Category Value
 .. D
 ... NEW X,WP,II,MCV,LINE,MCVRIN,MCVROUT
 ... S X=$$GET1^DIQ(9002318.42,IENS,4,"","WP")
 ... S MCV=""
 ... S II="" F  S II=$O(WP(II)) Q:II=""  S LINE=WP(II) I LINE]"" D
 .... S MCV=MCV_$S(MCV]"":" ",1:"")_LINE
 ... S MCVRIN=$$GET1^DIQ(9002318.42,IENS,5.07,"I")
 ... S MCVROUT=$$GET1^DIQ(9002318.42,IENS,5.08,"I")
 ... S @OUT@(MCNT,"MPCVL","VAL")=MCV
 ... I 'DFLD S @OUT@(MCNT,"MPCVL","XADT")=MCVRIN
 ... I 'DFLD S @OUT@(MCNT,"MPCVL","XRDT")=MCVROUT
 ;
 Q MCNT
 ;
SUBLST(OUT,IN) ;EP - Retrieve a subset listing
 ;
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  IN - P1 - The subset to list
 ;     - P2 - The namespace id (default to SNOMED US EXT '36')
 ;     - P3 (Optional) - LOCAL - Pass 1 or blank to perform local listing,
 ;                       Pass 2 for remote DTS listing
 ;     - P4 (Optional) - DEBUG - Pass 1 to display debug information
 ;
 ; BSTSBPRC - If 1, this was called from a background subset refresh
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]
 ; [1] - 2:Remote information returned
 ;       1:Local information returned
 ;       0:No Information Returned
 ; [2] - Primary Remote Error Message
 ; [3] - Secondary Remote Error Message (if applicable)
 ;
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BSTSAPIC D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 N SUB,LOCAL,DEBUG,BSTSWS,BSTSR,DLIST,SBCNT,SBNCNT,SLIST,%D,MFAIL,FWAIT,ABORT
 ;
 K @OUT
 ;
 I $G(DT)="" D DT^DICRW
 S IN=$G(IN,"")
 S SUB=$P(IN,U)
 S NMID=$P(IN,U,2) S:NMID="" NMID=36 S:NMID=30 NMID=36
 S LOCAL=$P(IN,U,3),LOCAL=$S(LOCAL=2:"",1:"1")
 S DEBUG=$P(IN,U,4),DEBUG=$S(DEBUG=1:"1",1:"")
 ;
 S BSTSWS("NAMESPACEID")=NMID
 S BSTSWS("SUBSET")=SUB
 S BSTSWS("BSTSBPRC")=$G(BSTSBPRC) K BSTSBPRC
 ;
 ;Set up scratch global
 S DLIST=$NA(^TMP("BSTSCMCL",$J)) ;DTS Return List
 S SLIST=$NA(^TMP("BSTSSUB",$J))
 K @DLIST,@SLIST,@OUT
 ;
 ;Make DTS search call
 S BSTSR=1
 ;
 ;Retrieve Failover Variables
 I $G(BSTSWS("BSTSBPRC"))=1 D
 . S MFAIL=$$FPARMS^BSTSVOFL()
 . S FWAIT=$P(MFAIL,U,2)
 . S MFAIL=$P(MFAIL,U)
 ;
 ;Perform DTS Search
 I LOCAL'=1 S BSTSR=$$SUBLST^BSTSWSV(DLIST,.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;Perform local search
 I $D(@DLIST)<10 D
 . ;
 . NEW CIEN,CTR,NMIEN
 . ;
 . ;Make sure we have a codeset (namespace)
 . S NMIEN=$O(^BSTS(9002318.1,"B",NMID,"")) Q:NMIEN=""
 . ;
 . S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"E",NMIEN,SUB,CIEN)) Q:CIEN=""  D
 .. NEW DTSID
 .. S DTSID=$$GET1^DIQ(9002318.4,CIEN_",",.08,"I") Q:DTSID=""
 .. S CTR=$G(CTR)+1,@DLIST@(CTR)=DTSID
 ;
 ;If no results and local, do a DTS lookup
 I $D(@DLIST)<10,LOCAL=1 S BSTSR=$$SUBLST^BSTSWSV(DLIST,.BSTSWS,DEBUG) S:+BSTSR $P(BSTSR,U)=2
 ;
 ;If background process and failure quit
 I $G(BSTSWS("BSTSBPRC"))=1,BSTSR="0^" Q BSTSR
 ;
 M @SLIST=@DLIST
 ;
 ;Loop through results and retrieve info
 S (ABORT,SBCNT)=0,SBNCNT=0 F  S SBCNT=$O(@SLIST@(SBCNT)) Q:'SBCNT  D  Q:ABORT=1
 . NEW CONC,DESC,DTSID,CIEN,PRE,OOD,PRDATA,TERM
 . S DTSID=$G(@SLIST@(SBCNT)) Q:DTSID=""
 . ;
 . ;Pull the concept IEN
 . S CIEN=$O(^BSTS(9002318.4,"D",NMID,DTSID,"")),CONC="",PRE="",TERM=""
 . ;
 . ;Pull the Concept ID
 . I CIEN]"" S CONC=$$GET1^DIQ(9002318.4,CIEN_",",".02","E")
 . ;
 . ;Pull the Preferred Term Description Id
 . S PRDATA="" I CIEN]"" S PRDATA=$$PDESC^BSTSSRCH(CIEN)
 . ;
 . ;See if the concept has already been updated
 . S OOD=0 I CIEN]"" D
 .. NEW LMOD
 .. S LMOD=$$GET1^DIQ(9002318.4,CIEN_",",".12","I")
 .. I LMOD="" S OOD=1 Q
 .. I $$GET1^DIQ(9002318.4,CIEN_",",".11","I")="Y" S OOD=1
 . ;
 . ;If not found or out of date, retrieve detail from server
 . S PRE=$P(PRDATA,U),TERM=$P(PRDATA,U,2)
 . I CIEN=""!(CONC="")!(PRE="")!(OOD) D  Q:ABORT
 .. N STS,SBVAR,TRY,FCNT
 .. ;
 .. ;Foreground call
 .. I $G(BSTSWS("BSTSBPRC"))="" D  Q
 ... S STS=$$DTSLKP^BSTSAPI("SBVAR",DTSID_"^"_NMID_"^^^^1")
 .. ;
 .. ;Background call try until completed - Hang max of 12 times
 .. S FCNT=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 ... D RESET^BSTSWSV1 ;Make sure the link is on
 ... S STS=$$DTSLKP^BSTSAPI("SBVAR",DTSID_"^"_NMID_"^^^^1") I +STS=2!(STS="0^") Q  ;Quit if success
 ... S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 .... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"SUBLST^BSTSAPIC - Processing DTSID: "_DTSID)
 .... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("SUBSET REFRESH FAILED ON DETAIL LOOKUP: "_DTSID)
 .... S FCNT=0
 . ;
 . ;Look again
 . I CIEN="" S CIEN=$O(^BSTS(9002318.4,"D",NMID,DTSID,"")) Q:CIEN=""
 . ;
 . ;Pull concept id and preferred term description id
 . S CONC=$$GET1^DIQ(9002318.4,CIEN_",",".02","E") Q:CONC=""
 . S PRDATA=$$PDESC^BSTSSRCH(CIEN)
 . S PRE=$P(PRDATA,U) Q:PRE=""
 . S TERM=$P(PRDATA,U,2) Q:TERM=""
 . S SBNCNT=SBNCNT+1,@OUT@(SBNCNT)=CONC_U_PRE_U_TERM
 ;
 S $P(BSTSR,U)=$S(SBNCNT=0:0,(+BSTSR)>0:+BSTSR,1:1)
 Q BSTSR
 ;
ERR ;
 D ^%ZTER
 Q
