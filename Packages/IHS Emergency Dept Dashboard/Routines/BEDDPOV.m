BEDDPOV ;GDIT/HS/BEE-BEDD Utility Routine 4 ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;;Jun 04, 2014;Build 13
 ;
 Q
 ;
DXLKP(VALUE,APCDD,SEX,FILTER) ;EP - Lookup to File 80 (DX)
 ;
 ;Input parameters
 ;  VALUE - The text string to look up
 ;  APCDD - The date to search on
 ;    SEX - The patient sex (optional)
 ; FILTER - 0 - No Cause of Injury, 1 - Only Cause of Injury, 2 - All codes (Default 0)
 ;
 ;Error Trapping
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BEDDPOV D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 NEW I,BEDDLEX,LEX
 ;
 ;Make sure needed values are defined
 S X="S:$G(U)="""" U=""""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 S SEX=$G(SEX)
 S:$G(FILTER)="" FILTER=0
 ;
 ;Reset scratch global
 K ^TMP("BEDDDX",$J)
 ;
 ;AICD and Lexicon ICD-10 have been installed. Use them for lookups
 D LEX(VALUE,APCDD,SEX,.BEDDLEX,FILTER)
 ;
 ;Place returned information in scratch global
 S I="" F  S I=$O(BEDDLEX(I)) Q:I=""  S ^TMP("BEDDDX",$J,I)=BEDDLEX(I)
 ;
 Q
 ;
LEX(BEDDTXT,APCDD,SEX,BEDDLEX,FILTER) ;EP - Perform Lexicon lookup
 ;
 ;This call was adapted from APCDAPOV
 ;Input parameters
 ;  BEDDTXT - The text string to look up
 ;    APCDD - The date to search on
 ;      SEX - The patient sex
 ;   FILTER - 0 - No Cause of Injury, 1 - Only Cause of Injury, 2 - All codes (Default 0)
 ;
 ;Return informaton
 ;  BEDDLEX - Array of matches
 ;            Format: BEDDLEX("LIST",#)=IEN^CODE^CODE DESCRIPTION
 ;
 NEW APCDIMP,DIC,I,ICDV,LEX,X,RET
 ;
 ;Quit if no search string
 I $G(BEDDTXT)="" Q
 ;
 ;Convert text to uppercase
 S BEDDTXT=$$UPPER^BEDDUTID(BEDDTXT)
 ;
 ;Make sure initial variables are set
 S:$G(U)="" U="^"
 S:$G(DT)="" DT=$$DT^XLFDT
 S:$G(APCDD)="" APCDD=DT
 S:$G(FILTER)="" FILTER=0
 ;
 ;Retrieve the codeset in place
 S APCDIMP=$$IMP^AUPNSICD(APCDD)
 ;
 ;Handle uncoded diagnosis entry
 ;
 ;Look up .9999 code (or switch to ZZZ.999 if ICD-10)
 I BEDDTXT=".9999",FILTER'=1 D  G XITL
 . NEW %
 . S %=$$ICDDX^AUPNVUTL($S(APCDIMP=1:".9999",1:"ZZZ.999"),,"E")
 . S BEDDLEX(1)=$P(%,U,1,2)_U_$P(%,U,4)
 ;
 ;Look for ICD-10 Uncoded diagnosis code
 I APCDIMP=30,((BEDDTXT="ZZZ.999")!($E(BEDDTXT,1,4)="ZZZ.")),FILTER'=1 D  G XITL
 . NEW %
 . S %=$$ICDDX^AUPNVUTL($S(APCDIMP=1:".9999",1:"ZZZ.999"),,"E")
 . S BEDDLEX(1)=$P(%,U,1,2)_U_$P(%,U,4)
 ;
 ;Look up Uncoded term
 I (($E(BEDDTXT,1,7)="UNCODED")!(BEDDTXT["UNCODED D")),FILTER'=1 D  G XITL
 . NEW %
 . S %=$$ICDDX^AUPNVUTL($S(APCDIMP=1:".9999",1:"ZZZ.999"),,"E")
 . S BEDDLEX(1)=$P(%,U,1,2)_U_$P(%,U,4)
 ;
 ;Not an uncoded diagnosis, call the Lexicon
 D LEX^AMERUTIL(BEDDTXT,100,FILTER,$P(APCDD,"."),SEX,.RET)
 ;
 ;I APCDIMP=1 D ICD9(BEDDTXT,$P(APCDD,"."),.LEX)
 ;I APCDIMP=30 D ICD10(BEDDTXT,$P(APCDD,"."),.LEX)
 ;
 ;Loop through results and format
 S I=0 F  S I=$O(RET(I)) Q:I=""  D
 . NEW ND,IEN,CODE,DESC
 . S ND=$G(RET(I))
 . S IEN=$P(ND,U)
 . S CODE=$P(ND,U,2)
 . S DESC=$P(ND,U,3)
 . ;S DESC=$P(ND,U,2)
 . ;S CODE=$P($P(DESC,"ICD-9-CM ",2),")")
 . ;S DESC=$E($P(DESC," (ICD-9-CM"),1,159)
 . S BEDDLEX(I)=IEN_U_CODE_U_DESC
 . K RET(I)
 ;
XITL Q
 ;
ICD9(XTEXT,APCDDATE,LEX) ;Perform Lexicon ICD9 lookup
 Q
 ;
ICD10(XTEXT,APCDDATE,LEX) ;Perform Lexicon ICD10 lookup
 ;
 NEW DIC
 K ^TMP("LEXSCH"),^TMP("LEXFND"),LEX("LIST")
 D CONFIG^LEXSET("10D","10D",APCDDATE)
 S DIC("S")="I $$ICDONE1^APCDAPOV(+Y,LEXVDT)"
 D LOOK^LEXA(XTEXT,"10D",10,"10D",APCDDATE)
 Q
 ;
XIT K Y,X,DO,D,DD,DIPGM,APCDTPCC
 Q
 ;
ICD(ICDIEN,VDT) ;Return ICD information
 ;
 ;Input:
 ;       ICDIEN - Pointer  to file 80
 ;           VDT - Date to search on
 ;
 ;Output:
 ;       Standard AICD ICD data string return
 ;
 NEW ICDINFO,X
 ;
 ;Make sure needed values are defined
 S X="S:$G(U)="""" U=""""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 S:$G(VDT)="" VDT=DT
 I $$AICD^AMERUTIL() S ICDINFO=$$ICDDX^ICDEX(ICDIEN,VDT)
 E  S ICDINFO=$$ICDDX^ICDCODE(ICDIEN,VDT)
 ;
 Q ICDINFO
 ;
ERR ;EP - Capture the error
 D ^%ZTER
 Q
 ;
LIST(VIEN,DUZ,DXLIST) ;EP - Return list of V POV entries on file for visit
 ;
 ;Input variables
 ;   VIEN - Visit IEN
 ;    DUZ - User IEN
 ;
 ;Output array
 ;   DXLIST - DXLIST(#)= [1] V POV IEN [2] Code [3] Code Description [4] P/S [5] Prov Narrative [6] Injury (Yes/No)
 ;
 ;Verify visit
 I $G(VIEN)="" Q
 ;
 NEW AMERPOV,POV,STS
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 ;Define DUZ variable
 I $G(DUZ)="" S STS="Missing DUZ" G XSAVE
 D DUZ^XUP(DUZ)
 ;
 ;Retrieve V POV entries
 S STS=$$POV^AMERUTIL("",VIEN,.AMERPOV)
 ;
 ;Format for BEDD
 S POV="" F  S POV=$O(AMERPOV(POV)) Q:POV=""  D
 . NEW VPOVIEN,ICDIEN,CODE,DESC,PS,NARR,N
 . S N=AMERPOV(POV)
 . S DXLIST(POV)=$P(N,U,6)_U_$P(N,U)_U_$P(N,U,5)_U_$P(N,U,2)_U_$P(N,U,3)_U_$P(N,U,7)
 ;
 Q
 ;
GETDX(VPOV) ;EP - Retrieve V POV information for a particular entry
 ;
 NEW RESULT,CODE,PS,NARR,DESC,VIEN,VDATE,ICDINFO,CODEIEN,INJ
 ;
 ;Check for VPOV entry
 I $G(VPOV)="" Q ""
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ; 
 ;Get the visit IEN and visit date
 S VIEN=$$GET1^DIQ(9000010.07,VPOV_",",".03","I") Q:VIEN="" ""
 S VDATE=$P($$GET1^DIQ(9000010,VIEN_",",.01,"I"),".")
 ;
 S RESULT=""
 ;
 S CODEIEN=$$GET1^DIQ(9000010.07,VPOV_",",".01","I") Q:CODEIEN=""  ;Code IEN
 S CODE=$$GET1^DIQ(9000010.07,VPOV_",",".01","E") Q:CODE="" ""  ;Code
 S PS=$$GET1^DIQ(9000010.07,VPOV_",",".12","I") ;Primary/Secondary
 S NARR=$$GET1^DIQ(9000010.07,VPOV_",",".04","E") Q:NARR=""  ;Provider Narrative
 ;
 ;Get whether an injury - Flag if injury date or cause of injury
 S INJ="No"
 I $$GET1^DIQ(9000010.07,VPOV_",",.13,"I") S INJ="Yes"
 E  I $$GET1^DIQ(9000010.07,VPOV_",",.09,"I") S INJ="Yes"
 ;
 ;Code Description
 I $$AICD^AMERUTIL() S ICDINFO=$$ICDDX^ICDEX(CODEIEN,VDATE)
 E  S ICDINFO=$$ICDDX^ICDCODE(CODEIEN,VDATE)
 S DESC=$P(ICDINFO,U,4) S:$E(DESC,1)="*" DESC=$E(DESC,2,9999)
 ;
 ;Return the results
 S RESULT=VPOV_U_CODE_U_DESC_U_PS_U_NARR_U_CODEIEN_U_INJ
 ;
 Q RESULT
 ;
DEL(VPOVIEN,DUZ) ;Delete a POV entry
 ;
 NEW VPOVUPD,ERROR,AUPNVSIT
 ;
 I $G(VPOVIEN)="" Q 0
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 ;Define DUZ variable
 I $G(DUZ)="" S STS="Missing DUZ" G XSAVE
 D DUZ^XUP(DUZ)
 ;
 ;Get the visit IEN
 S AUPNVSIT=$$GET1^DIQ(9000010.07,VPOVIEN,".03","I")
 ;
 S VPOVUPD(9000010.07,VPOVIEN_",",.01)="@"
 D FILE^DIE("","VPOVUPD","ERROR")
 ;
 ;Flag that visit was updated
 D MOD^AUPNVSIT
 ;
 I $D(ERROR) Q 0
 Q 1
 ;
SAVE(VPOVIEN,ICDIEN,PNARR,PS,CODE,INJ,VIEN,DUZ,DFN) ;Add/Update POV entry
 ;
 NEW STS,IN,X,APCDALVR,APCDPAT,APCDLOOK,APCDVSIT,APCDDATE,APCDTYPE,APCDCAT,APCDLOC,APCDCLN,PROV
 NEW APCDTDI,APCDTCD,APCDTPA,POVUPD,ERROR,ICD,AUPNVSIT,INJURY
 ;
 ;Make sure initial variables are set
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 ;Define DUZ variable
 I $G(DUZ)="" S STS="Missing DUZ" G XSAVE
 D DUZ^XUP(DUZ)
 ;
 ;Reset STS
 S STS=0
 ;
 ;Get the provider narrative IEN
 S PNARR=$$FNDNARR(PNARR)
 ;
 ;Get primary provider
 S PROV=""
 I $G(VIEN)>0 D
 . NEW IEN
 . ;
 . ;Loop through the list and find the primary provider
 . S IEN=0 F  S IEN=$O(^AUPNVPRV("AD",VIEN,IEN)) Q:IEN=""  D  Q:+PROV
 .. NEW PS
 .. S PS=$$GET1^DIQ(9000010.06,IEN_",",.04,"I") Q:PS'="P"
 .. ;
 .. ;Get the primary provider
 .. S PROV=$$GET1^DIQ(9000010.06,IEN_",",.01,"I")
 . ;
 . ;If there isn't one yet, use DUZ
 . S:PROV="" PROV=$G(DUZ)
 ;
 ;Retrieve the Injury information
 I $G(INJ)="YES" D
 . NEW INJPL
 . ;
 . ;Retrieve injury information
 . D INJURY^BEDDINJ(VIEN,.INJURY)
 . S:$G(INJURY("INDAT"))]"" APCDTDI=$P(INJURY("INDAT"),".")
 . S:$G(INJURY("ICIEN"))]"" APCDTCD=INJURY("ICIEN")
 . S INJPL=""
 . S:$G(INJURY("INSET"))]"" INJPL=INJURY("INSET")
 . ;
 . ;Injury place
 . I INJPL]"" S INJPL=$$GET1^DIQ(9009083,INJPL_",",.01,"E")
 . ;
 . ;Valid PCC values
 . ;A:HOME-INSIDE;B:HOME-OUTSIDE;C:FARM;D:SCHOOL;E:INDUSTRIAL PREMISES;F:RECREATIONAL AREA;
 . ;G:STREET/HIGHWAY;H:PUBLIC BUILDING;I:RESIDENT INSTITUTION;J:HUNTING/FISHING;K:OTHER;L:UNKNOWN
 . S APCDTPA="L"
 . I INJPL["HIGHWAY" S APCDTPA="G"
 . E  I INJPL["HOME" S APCDTPA="A"
 . E  I INJPL["INDUSTRIAL" S APCDTPA="E"
 . E  I INJPL["MINE" S APCDTPA="K"
 . E  I INJPL["OTHER" S APCDTPA="K"
 . E  I INJPL["PUBLIC" S APCDTPA="H"
 . E  I INJPL["FARM" S APCDTPA="C"
 . E  I INJPL["RECREATION" S APCDTPA="F"
 . E  I INJPL["RESIDENT" S APCDTPA="I"
 . E  I INJPL["UNSPECIFIED" S APCDTPA="L"
 . E  I INJPL["SCHOOL" S APCDTPA="D"
 . E  I INJPL["HUNTING" S APCDTPA="J"
 . E  I INJPL["FISHING" S APCDTPA="J"
 ;
 ;Location
 S APCDLOC=$$GET1^DIQ(9000010,VIEN_",",.06,"I")
 ;
 ;Process Adds
 I +VPOVIEN=0 D
 . ;
 . NEW APCDALVR
 . ;
 . ;Set Patient
 . S APCDALVR("APCDPAT")=DFN                              ;Patient DFN
 . ;
 . ;Define Visit IEN
 . S APCDALVR("APCDVSIT")=VIEN                            ;Visit IEN
 . ;
 . ;Define External ICD code
 . S APCDALVR("APCDTPOV")=CODE
 . ;
 . ;Location
 . S APCDALVR("APCDLOC")=$S(APCDLOC'="":APCDLOC,1:DUZ(2))
 . ;
 . ;Determine which template to use
 . S APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]"
 . ;
 . ;Make the add call
 . D ^APCDALVR
 . ;
 . ;If success get V Pointer
 . I '$D(APCDALVR("APCDAFLG")) S VPOVIEN=$G(APCDALVR("APCDADFN"))
 . I $D(APCDALVR("APCDAFLG")) S STS=-1
 ;
 ;Now perform edits (add in extra fields for adds)
 S POVUPD(9000010.07,+VPOVIEN_",",.12)=$S(PS="YES":"P",1:"S")            ;Primary/Secondary
 S POVUPD(9000010.07,+VPOVIEN_",",.04)=$S($G(PNARR)]"":PNARR,1:"@")      ;Prov Narrative
 S POVUPD(9000010.07,+VPOVIEN_",",.13)=$S($G(APCDTDI)]"":APCDTDI,1:"@")  ;Date of Injury
 S POVUPD(9000010.07,+VPOVIEN_",",.09)=$S($G(APCDTCD)]"":APCDTCD,1:"@")  ;Cause of Injury
 S POVUPD(9000010.07,+VPOVIEN_",",.11)=$S($G(APCDTPA)]"":APCDTPA,1:"@")  ;Injury Setting
 S POVUPD(9000010.07,+VPOVIEN_",",.01)=ICDIEN                        ;Code
 D FILE^DIE("","POVUPD","ERROR")
 ;
 ;Flag Visit update
 S AUPNVSIT=VIEN D MOD^AUPNVSIT
 ;
XSAVE Q STS
 ;
FNDNARR(NARR,CREATE) ;File narrative and return IEN
 N IEN,FDA,TRC,RET
 Q:'$L(NARR) ""
 S IEN=0,TRC=$E(NARR,1,30),NARR=$E(NARR,1,160),CREATE=$G(CREATE,1)
 F  S IEN=$O(^AUTNPOV("B",TRC,IEN)) Q:'IEN  Q:$P($G(^AUTNPOV(IEN,0)),U)=NARR
 Q:IEN!'CREATE IEN
 S FDA(9999999.27,"+1,",.01)=NARR
 S RET=$$UPDATE^BGOUTL(.FDA,"E",.IEN)
 Q $S(RET:RET,1:IEN(1))
 ;
GETPOV(VIEN) ;Return POV information for visit
 ;
 I $G(VIEN)="" Q 0
 ;
 NEW POV,PRMCNT,DXCNT,CNT
 ;
 ;
 ;Make sure needed values are defined
 S X="S:$G(U)="""" U=""""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 ;Reset values
 S (PRMCNT,DXCNT)=0
 ;
 ;Get POV information
 D POV^AMERUTIL("",VIEN,.POV)
 ;
 S CNT="" F  S CNT=$O(POV(CNT)) Q:CNT=""  D
 . S DXCNT=DXCNT+1  ;Total Dx entries
 . I $P(POV(CNT),"^",2)="P" S PRMCNT=PRMCNT+1  ;Total Primary Entries
 ;
 Q DXCNT_"^"_PRMCNT
