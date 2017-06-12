BSTSUTIL ;GDIT/HS/BEE-Standard Terminology Utility Program ; 5 Nov 2012  9:53 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**2,3,4,8**;Sep 10, 2014;Build 35
 ;
 Q
 ;
DTCHG(X1,X2) ;EP - ADD/SUBTRACT FROM DATE
 ;
 NEW X,%H
 I $G(X1)="" Q ""
 I $G(X2)="" Q ""
 ;
 D C^%DTC
 Q X
 ;
EP2FMDT(MSECS,DTONLY) ;EP - Convert UNIX (EPOCH) Date to FileMan Date (and Time)
 ;
 ;Input
 ; MSECS  - UNIX (EPOCH) date - Milliseconds since Jan 1, 1970
 ; DTONLY (Optional) - If 1, return only date portion
 ;
 ;Output
 ; FDT - FileMan Date format
 ;
 NEW MDATE,MTIME
 S DTONLY=$G(DTONLY),DTONLY=$S(DTONLY="1":"1",1:"")
 Q:MSECS'?12.13N "" ; Do not convert date beyond 11/19/2280
 S MSECS=MSECS\1000
 S MDATE=(MSECS\86400+47117)
 S MTIME=+(MSECS#86400)
 ;
 Q $$HTFM^XLFDT(MDATE_","_MTIME,DTONLY)
 ;
EP2EXDT(MSECS,FORMAT) ;EP - Convert UNIX (EPOCH) Date to External Date (and Time)
 ;
 ;Input
 ; MSECS  - UNIX (EPOCH) date - Milliseconds since Jan 1, 1970
 ; FORMAT - XLFDT format field (optional) - default is "5DZ"
 ;
 ;Output
 ; FDT - External Date (Time) format
 ;
 NEW MDATE,MTIME
 S FORMAT=$G(FORMAT,"") S:FORMAT="" FORMAT="5DZ"
 Q:MSECS'?12.13N "" ; Do not convert date beyond 11/19/2280
 S MSECS=MSECS\1000
 S MDATE=(MSECS\86400+47117)
 S MTIME=+(MSECS#86400)
 ;
 Q $$HTE^XLFDT(MDATE_","_MTIME,FORMAT)
 ;
FMDT2EP(FDT) ;EP - FileMan Date (and Time) to UNIX (EPOCH) Date
 ;
 ;Input
 ; FDT - FileMan Date (and Time)
 ;
 ;Output
 ; MSECS  - UNIX (EPOCH) date - Milliseconds since Jan 1, 1970
 ;
 NEW DOLH,DOLD,DOLT,EPOCH
 S DOLH=$$FMTH^XLFDT(FDT)
 S DOLD=+$P(DOLH,",")
 S DOLT=+$P(DOLH,",",2)
 S EPOCH=((DOLD-47117)*86400)+DOLT
 ;
 Q (EPOCH*1000)
 ;
EXDT2EP(EXDT) ;EP - External Date (and Time) to UNIX (EPOCH) Date
 ;
 ;Input
 ; EXDT - External Date (and Time)
 ;
 ;Output
 ; MSECS  - UNIX (EPOCH) date - Milliseconds since Jan 1, 1970
 ;
 NEW DOLH,DOLD,DOLT,EPOCH,X,Y,%DT
 S X=EXDT,%DT="TS"
 D ^%DT
 I Y="-1" Q Y  ;Invalid date
 ;
 S DOLH=$$FMTH^XLFDT(Y)
 S DOLD=+$P(DOLH,",")
 S DOLT=+$P(DOLH,",",2)
 S EPOCH=((DOLD-47117)*86400)+DOLT
 ;
 Q (EPOCH*1000)
 ;
DATE(DATE) ;EP - Convert standard date/time to a FileMan date/time
 ;Input
 ;  DATE - In a standard format
 ;Output
 ;  -1 is if it couldn't convert to a FileMan date
 ;  otherwise a standard FileMan date
 NEW %DT,X,Y
 I DATE[":" D
 . I DATE["/",$L(DATE," ")=3 S DATE=$P(DATE," ",1)_"@"_$P(DATE," ",2)_$P(DATE," ",3) Q
 . I $L(DATE," ")=3 S DATE=$P(DATE," ",1,2)_"@"_$P(DATE," ",3)
 . I $L(DATE," ")>3 S DATE=$P(DATE," ",1,3)_"@"_$P(DATE," ",4,99)
 S %DT="TS",X=DATE D ^%DT
 I Y=-1 S Y=""
 ;
 Q Y
 ;
DTS2FMDT(DATE,FORMAT) ;EP - Convert Date/Time from DTS to a FileMan date/time
 ;Input
 ;  DATE - In a standard format - 'CCYY-MM-DD HH:MM:SS'
 ;  FORMAT - 1 - Return Date only
 ;
 ;Output
 ;  -1 is if it couldn't convert to a FileMan date - 'CYYMMDD'
 ;  otherwise a standard FileMan date
 NEW %DT,X,Y
 ;
 S %DT="T"
 S X=$P(DATE,"-",2)_"/"_$P($P(DATE,"-",3)," ")_"/"_$P(DATE,"-")
 ;
 I $G(FORMAT)'=1 D
 . I $P(DATE," ",2)[":" S X=X_"@"_$P(DATE," ",2,99)
 . S %DT="ST"
 D ^%DT
 ;
 I Y=-1 S Y=""
 ;
 Q Y
 ;
FMDT2XML(DATE) ;EP - Convert Date/Time from FileMan to XML
 ;Input
 ;  DATE - In a standard FileMan format
 ;
 ;Output
 ;  Convert to a XML date - 'CCYY-MM-DD HH:MM:SS'
 ;
 NEW X
 S X=$S($E(DATE,1)="2":"19",1:"20")_$E(DATE,2,3)_"-"_$E(DATE,4,5)_"-"_$E(DATE,6,7)_"T00:00:00"
 ;
 Q X
 ;
SQL2XML(DATE) ;EP - Convert date from SQL to XML formats
 ;Input
 ;  DATE - In SQL format - 'JUN 13, 2013'
 ;
 ;Output
 ;  "" is if it couldn't convert to a XML date - '2013-06-13T00:00:00'
 ; 
 ;NEW %DT,X,Y,FMDT,M,D
 ;
 ;S %DT="TS",X=DATE D ^%DT
 ;I Y=-1 Q ""
 NEW %DT,X,Y,FMDT,M,D
 I DATE[":" D
 . I DATE["/",$L(DATE," ")=3 S DATE=$P(DATE," ",1)_"@"_$P(DATE," ",2)_$P(DATE," ",3) Q
 . I $L(DATE," ")=3 S DATE=$P(DATE," ",1,2)_"@"_$P(DATE," ",3)
 . I $L(DATE," ")>3 S DATE=$P(DATE," ",1,3)_"@"_$P(DATE," ",4,99)
 S %DT="TS",X=DATE D ^%DT
 I Y=-1 Q ""
 ;
 S Y=$$FMTE^XLFDT($P(Y,"."),"7")
 S M=$P(Y,"/",2) S:$L(M)=1 M="0"_M
 S D=$P(Y,"/",3) S:$L(D)=1 D="0"_D
 S Y=$P(Y,"/")
 S Y=Y_"-"_M_"-"_D_"T00:00:01"
 Q Y
 ;
FMTE(Y)  ;EP - Convert Fileman Date/Time to 'MMM DD, CCYY HH:MM:SS' format.
 ;Description
 ;  Receives Date (Y) in FileMan format and returns formatted date.
 ;
 ;Input
 ;  Y - FileMan date/time (i.e. 3051024.123456).
 ;
 ;Output
 ;  Date/Time in External format (i.e. OCT 24,2005 12:34:56).
 ;
 NEW DATM,XX,I,V,DA
 S DATM=$TR($$FMTE^DILIBF(Y,"5U"),"@"," ")
 I DATM["24:00" S DATM=$P(DATM," ",1,2)_" 00:00"
 S XX="" F I=1:1:$L(DATM) S V=$E(DATM,I,I),XX=XX_V I V="," S XX=XX_" "
 S DATM=XX
 Q DATM
 ;
WRAP(OUT,TEXT,RM,IND) ;EP - Wrap the text and insert in array
 ;
 NEW SP
 ;
 I $G(TEXT)="" S OUT(1)="" Q
 I $G(RM)="" Q
 I $G(IND)="" S IND=0
 S $P(SP," ",80)=" "
 ;
 ;Strip out $c(10)
 S TEXT=$TR(TEXT,$C(10))
 ;
 F  I $L(TEXT)>0 D  Q:$L(TEXT)=0
 . NEW PIECE,SPACE,LINE
 . S PIECE=$E(TEXT,1,RM)
 . ;
 . ;Handle Line feeds
 . I PIECE[$C(13) D  Q
 .. NEW LINE,I
 .. S LINE=$P(PIECE,$C(13)) S:LINE="" LINE=" "
 .. S OUT=$G(OUT)+1,OUT(OUT)=LINE
 .. F I=1:1:$L(PIECE) I $E(PIECE,I)=$C(13) Q
 .. S TEXT=$E(SP,1,IND)_$$STZ($E(TEXT,I+1,9999999999))
 . ;
 . ;Check if line is less than right margin
 . I $L(PIECE)<RM S OUT=$G(OUT)+1,OUT(OUT)=PIECE,TEXT="" Q
 . ;
 . ;Locate last space in line and handle if no space
 . F SPACE=$L(PIECE):-1:(IND+1) I $E(PIECE,SPACE)=" " Q
 . I (SPACE=(IND+1)) D  S:TEXT]"" TEXT=$E(SP,1,IND)_TEXT Q
 .. S LINE=PIECE,OUT=$G(OUT)+1,OUT(OUT)=LINE,TEXT=$$STZ($E(TEXT,RM+1,999999999))
 . ;
 . ;Handle line with space
 . S LINE=$E(PIECE,1,SPACE-1),OUT=$G(OUT)+1,OUT(OUT)=LINE,TEXT=$$STZ($E(TEXT,SPACE+1,999999999))
 . S:TEXT]"" TEXT=$E(SP,1,IND)_TEXT
 ;
 Q
 ;
STZ(TEXT) ;EP - Strip Leading Spaces
 NEW START
 F START=1:1:$L(TEXT) I $E(TEXT,START)'=" " Q
 Q $E(TEXT,START,9999999999)
 ;
ICDSX ;EP - Set cross-reference
 NEW CSET
 S CSET=$$CSET() I CSET="" Q
 S ^BSTS(9002318.4,"F",CSET,X,DA(1))=""
 Q
 ;
ICDKX ;EP - Kill cross-reference
 NEW CSET
 S CSET=$$CSET() I CSET="" Q
 K ^BSTS(9002318.4,"F",CSET,X,DA(1))
 Q
 ;
SBSX ;EP - Set cross-reference
 NEW CSET
 S CSET=$$CSET() I CSET="" Q
 S ^BSTS(9002318.4,"E",CSET,X,DA(1),DA)=""
 Q
 ;
SBKX ;EP - Kill cross-reference
 NEW CSET
 S CSET=$$CSET() I CSET="" Q
 K ^BSTS(9002318.4,"E",CSET,X,DA(1),DA)
 Q
 ;
NDSX ;EP - Set cross-reference
 NEW CSET
 S CSET=$$CSET() I CSET="" Q
 S ^BSTS(9002318.4,"G",CSET,X,DA(1),DA)=""
 Q
 ;
NDKX ;EP - Kill cross-reference
 NEW CSET
 S CSET=$$CSET() I CSET="" Q
 K ^BSTS(9002318.4,"G",CSET,X,DA(1),DA)
 Q
 ;
VUSX ;EP - Set cross-reference
 NEW CSET
 S CSET=$$CSET() I CSET="" Q
 S ^BSTS(9002318.4,"H",CSET,X,DA(1),DA)=""
 Q
 ;
VUKX ;EP - Kill cross-reference
 NEW CSET
 S CSET=$$CSET() I CSET="" Q
 K ^BSTS(9002318.4,"H",CSET,X,DA(1),DA)
 Q
 ;
I2SSX ;EP - Set cross-reference
 NEW CSET
 S CSET=$$CSET() I CSET="" Q
 S ^BSTS(9002318.4,"I",CSET,X,DA(1))=""
 Q
 ;
I2SKX ;EP - Kill cross-reference
 NEW CSET
 S CSET=$$CSET() I CSET="" Q
 K ^BSTS(9002318.4,"I",CSET,X,DA(1))
 Q
 ;
CSET() ;EP - Get the codeset
 Q $P($G(^BSTS(9002318.4,DA(1),0)),U,7)
 ;
DEL ;EP - Delete a codeset from cache
 ;
 NEW NMID,C,DIR,X,Y
 ;
 S DIR(0)="F"
 S DIR("A")="Enter codeset IEN to clear out: "
 D ^DIR
 I +Y<1 Q
 S NMID=+Y
 ;
 I '$D(^BSTS(9002318.3,"C",NMID)) W !!,"No entries defined for codeset" H 2 Q
 ;
 ;Loop through index and clear out each entry
 W !!,"DELETING TERMS"
 S C="" F  S C=$O(^BSTS(9002318.3,"C",NMID,C)) Q:C=""  D
 . NEW TIEN,DA,DIK
 . S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"C",NMID,C,TIEN)) Q:TIEN=""  D
 .. W !,"TIEN: ",TIEN,?10,$G(^BSTS(9002318.3,TIEN,0))
 .. S DA=TIEN,DIK="^BSTS(9002318.3,"
 .. D ^DIK
 ;
 W !!,"DELETING CONCEPTS"
 S C="" F  S C=$O(^BSTS(9002318.4,"C",NMID,C)) Q:C=""  D
 . NEW CIEN,DA,DIK
 . S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"C",NMID,C,CIEN)) Q:CIEN=""  D
 .. W !,"CIEN: ",CIEN,?10,$G(^BSTS(9002318.4,CIEN,0))
 .. S DA=CIEN,DIK="^BSTS(9002318.4,"
 .. D ^DIK
 Q
 ;
ICD10(VDT) ;EP - Determine to return ICD9 or ICD10
 ;
 ;Input value
 ; VDT - Date to check on
 ;
 ;Output value
 ; 1 - Use ICD10
 ; 0 - Use ICD9
 ;
 S:$G(VDT)="" VDT=DT
 ;
 I $$VERSION^XPDUTL("AICD")>3.51,$$IMP^ICDEXA(30)'>VDT Q 1
 Q 0
 ;
COUNT ;Return totals of codesets and subsets
 NEW SB,CD,S,I,C
 ;
 ;Get subsets first
 S S="" F  S S=$O(^BSTS(9002318.4,"E",9,S)) Q:S=""  S I="" F  S I=$O(^BSTS(9002318.4,"E",9,S,I)) Q:I=""  S SB(S)=$G(SB(S))+1
 ;
 ;Now get codesets
 S C="" F  S C=$O(^BSTS(9002318.4,"C",C)) Q:C=""  S I="" F  S I=$O(^BSTS(9002318.4,"C",C,I)) Q:I=""  S CD(C)=$G(CD(C))+1
 ;
 W !,"Subsets: "
 S S="" F  S S=$O(SB(S)) Q:S=""  W !,S,"=",SB(S)
 W !!,"Codesets: "
 S C="" F  S C=$O(CD(C)) Q:C=""  W !,C,"=",CD(C)
 Q
 ;
TKO(STR,VAL) ;EP - Take off ending character
 ;
 ;Description
 ;  This will take off the ending character at the end of
 ;  a string
 ;Input
 ;  STR - String of data
 ;  VAL - Delimiter character
 ;Output
 ;  same STR without the ending character
 ;
 I $G(STR)="" Q ""
 I $G(VAL)="" Q ""
 ;
 NEW LV
 S LV=$L(VAL)
 I $E(STR,$L(STR)-(LV-1),$L(STR))=VAL S STR=$E(STR,1,$L(STR)-LV)
 ;
 Q STR
 ;
CKJOB(ZTSK) ;Check the status of a job
 ;
 NEW ST
 ;
 ;Check on current job
 D STAT^%ZTLOAD
 S ST=$G(ZTSK(2))
 ;
 ;Pending - Don't start
 I ST["Pending" Q 1
 ;
 ;Running - Don't start
 I ST["Running" Q 1
 ;
 ;Finished/Inactive/Interrupted/Undefined - clear and allow start
 Q 0
 ;
CDJOB(NMIEN,TYPE,JTIME) ;EP - Kick off BSTS Background Process
 ;
 NEW TJOB,ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,BSTSUPD,ERROR,FIELD,ZTSK
 ;
 ;Determine field to pull
 I TYPE="C" S FIELD=".07"  ;Regular Codeset
 I TYPE="I10" S FIELD=".07"  ;ICD10 Autocodeable
 I TYPE="I9" S FIELD=".07"  ;ICD9 Autocodeable
 I TYPE="CCD" S FIELD=".07" ;Custom Codesets
 I (TYPE="S")!(TYPE="S1552") S FIELD=".08"  ;Subset
 I TYPE="I" S FIELD=".09"  ;ICD9 TO SNOMED
 ;
 ;Get the previous task number
 S TJOB=$$GET1^DIQ(9002318.1,NMIEN_",",FIELD,"I")
 ;
 ;Running or pending - Do not start
 I TJOB]"",$$CKJOB(TJOB) Q
 ;
 ;Other status - clear task
 I TJOB]"" D
 . NEW BSTSUPD,ERR
 . S BSTSUPD(9002318.1,NMIEN_",",FIELD)="@"
 . D FILE^DIE("","BSTSUPD","ERR")
 ;
 ;Queue the process off in the background
 K IO("Q")
 ;
 ;Regular codeset refresh
 I TYPE="C" D
 . S ZTRTN="RES^BSTSVRSN",ZTDESC="BSTS - Refresh Codeset"
 . S ZTSAVE("NMIEN")=""
 ;
 ;Subset refresh
 I TYPE="S" D
 . S ZTRTN="SUB^BSTSVRSN",ZTDESC="BSTS - Update IHS Standard Terminology Subsets"
 . S ZTSAVE("NMIEN")=""
 ;
 ;Subset refresh
 I TYPE="S1552" D
 . S ZTRTN="SUB^BSTSVRXN",ZTDESC="BSTS - Update IHS Standard Terminology RxNorm Subsets"
 . S ZTSAVE("NMIEN")=""
 ;
 ;ICD9 to SNOMED process
 I TYPE="I" D
 . S ZTRTN="JOB^BSTSUTIL",ZTDESC="BSTS - Preload SNOMED Concepts"
 . S ZTSAVE("NMIEN")=""
 ;
 ;ICD10 Autocodeable
 I TYPE="I10" D
 . S ZTRTN="ACODE^BSTSVRSC",ZTDESC="BSTS - Refresh ICD-10 Autocodeable Codeset"
 . S ZTSAVE("NMIEN")=""
 ;
 ;Custom Codesets
 I TYPE="CCD" D
 . S ZTRTN="CDST^BSTSVRSC",ZTDESC="BSTS - Update IHS Standard Terminology Local Cache Refresh"
 . S ZTSAVE("NMIEN")=""
 ;
 ;ICD9 Autocodeable
 I TYPE="I9" D
 . S ZTRTN="A9CODE^BSTSVRSC",ZTDESC="BSTS - Refresh ICD-9 Autocodeable Codeset"
 ;
 S ZTIO=""
 I +$G(JTIME) S ZTDTH=$$JBTIME^BSTSVOFL()
 E  S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,2)
 D ^%ZTLOAD
 ;
 ;Save task to file
 S BSTSUPD(9002318.1,NMIEN_",",FIELD)=$G(ZTSK)
 D FILE^DIE("","BSTSUPD","ERR")
 ;
 Q
 ;
PLOAD(NMIEN) ;Job off process to pre-load SNOMED concepts at site
 ;
 ;Quit if process has run before
 I $$GET1^DIQ(9002318.1,NMIEN_",",".09","I")]"" Q 0
 ;
 ;Do not perform check if background process is running
 L +^BSTS(9002318.1,0):0 E  Q 1
 L -^BSTS(9002318.1,0)
 ;
 ;Make sure ICD9 to SNOMED background process isn't already running
 L +^TMP("BSTSICD2SMD"):0 E  Q 1
 L -^TMP("BSTSICD2SMD")
 ;
 ;Queue the process off in the background
 D CDJOB^BSTSUTIL(NMIEN,"I")
 ;
 Q 0
 ;
JOB ;Background process to preload SNOMED concepts corresponding to ICD9 values
 ;
 ;Lock process
 L +^TMP("BSTSICD2SMD"):0 E  Q
 ;
 NEW AUPNPROB,JTMP,UID,JTMP,SVAR,MFAIL,FWAIT,ABORT
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S JTMP=$NA(^TMP("BSTS1POS",UID))
 S SVAR=$NA(^TMP("BSTSRPC1",UID))
 K @JTMP,^XTMP("BSTSLCMP","QUIT")
 ;
 ;Retrieve Failover Variables
 S MFAIL=$$FPARMS^BSTSVOFL()
 S FWAIT=$P(MFAIL,U,2)
 S MFAIL=$P(MFAIL,U)
 ;
 S AUPNPROB=0 F  S AUPNPROB=$O(^AUPNPROB(AUPNPROB)) Q:'AUPNPROB  D  Q:$D(^XTMP("BSTSLCMP","QUIT"))
 . NEW ICD9,STS,TRY,FCNT
 . ;
 . ;Reset scratch global
 . K @SVAR
 . ;
 . ;Get the ICD9 code
 . S ICD9=$$GET1^DIQ(9000011,AUPNPROB,.01,"E") Q:ICD9=""
 . ;
 . ;Strip off trailing "."
 . S ICD9=$$TKO^BSTSUTIL(ICD9,".")
 . ;
 . ;Skip if that ICD9 already processed
 . I $D(@JTMP@(ICD9)) Q
 . ;
 . ;Pre-load the SNOMED for that ICD9 - Try call maximum of 12 times
 . S (ABORT,FCNT,STS)=0 F TRY=1:1:(12*MFAIL) D  I +STS=2!(STS="0^") Q
 .. D RESET^BSTSWSV1  ;Reset the DTS link to on
 .. S STS=$$ICD2SMD^BSTSAPI(SVAR,ICD9_"^BCIX^2") I +STS=2!(STS="0^") Q
 .. S FCNT=FCNT+1 I FCNT'<MFAIL D  ;Fail handling
 ... S ABORT=$$FAIL^BSTSVOFL(MFAIL,FWAIT,TRY,"JOB^BSTSUTIL - Looking up ICD9: "_ICD9)
 ... I ABORT=1 S ^XTMP("BSTSLCMP","QUIT")=1 D ELOG^BSTSVOFL("ICD9 TO SNOMED LOOKUP FAILED ON ICD9: "_ICD9)
 ... S FCNT=0
 . ;
 . ;Mark the entry processed
 . S @JTMP@(ICD9)=""
 ;
 ;Remove entry when done
 K @JTMP
 ;
 ;Unlock process
 L -^TMP("BSTSICD2SMD")
 ;
 NEW FAIL
 S FAIL=$S($D(^XTMP("BSTSLCMP","QUIT")):1,1:0)
 K ^XTMP("BSTSLCMP")
 S:FAIL ^XTMP("BSTSLCMP","QUIT")=1
 ;
 Q
