AMERUTIL ;GDIT/HS/BEE - AMER UTILITY CALLS ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**6,7,8**;MAR 03, 2009;Build 23
 ;
 Q
 ;
POV(AUPNPAT,AMERPCC,AMERPOV) ;EP - Return a list of POV entries for a visit
 ;
 ;Pass in DFN or VIEN, plus array to return information in
 ;
 ;Returns list of POVs in the following format:
 ;AMERPOV(CNT)=[1]^[2]^[3]^[4]^[5]
 ;[1] - ICD code
 ;[2] - P-Primary, S-Secondary
 ;[3] - Provider Narrative
 ;[4] - IEN Pointer to file 80
 ;[5] - ICD Description Value
 ;[6] - V POV IEN
 ;[7] - Injury (Yes/No)
 ;
 ;Function returns: [1] # of POV entries on file in piece 1 ^[2] Primary POV entered
 ;
 ;Quit if no DFN or visit IEN passed in
 I $G(AUPNPAT)="",$G(AMERPCC)="" Q "0"
 ;
 ;If Visit IEN is blank retrieve from ER ADMISSION file
 S:$G(AMERPCC)="" AMERPCC=$$GET1^DIQ(9009081,AUPNPAT,1.1,"I")
 I AMERPCC="" Q "0"
 ;
 ;Reset output array
 K AMERPOV
 ;
 NEW IEN,CNT,PRM
 ;
 ;Loop through the POVs for the visit
 S (CNT,IEN,PRM)=0 F  S IEN=$O(^AUPNVPOV("AD",AMERPCC,IEN)) Q:'IEN  D
 . NEW ICDIEN,VDATE,PS,ICDINFO,ICD,ICDDESC,PNAR,ICDV,INJ
 . ;
 . ;Get the narrative
 . S PNAR=$$GET1^DIQ(9000010.07,IEN,.04,"E")
 . ;
 . ;Get the ICD Information
 . S VDATE=$$FMTDATE($$GET1^DIQ(9000010,AMERPCC,.01,"I"))
 . S ICDIEN=+$$GET1^DIQ(9000010.07,IEN,.01,"I")
 . I $$AICD() S ICDINFO=$$ICDDX^ICDEX(ICDIEN,VDATE)
 . E  S ICDINFO=$$ICDDX^ICDCODE(ICDIEN,VDATE)
 . S ICD=$P(ICDINFO,U,2) Q:ICD=""
 . ;
 . ;Get the description
 . S ICDDESC=$P(ICDINFO,U,4)
 . ;
 . ;Get primary/secondary
 . S PS=$$GET1^DIQ(9000010.07,IEN_",",.12,"I")
 . S:PS="" PS="S"
 . ;AMER*3.0*7;Track if more than one Primary
 . ;S:PS="P" PRM=1
 . S:PS="P" PRM=PRM+1
 . ;
 . ;Get whether an injury - Flag if injury date or cause of injury
 . S INJ="No"
 . I $$GET1^DIQ(9000010.07,IEN_",",.13,"I") S INJ="Yes"
 . E  I $$GET1^DIQ(9000010.07,IEN_",",.09,"I") S INJ="Yes"
 . ;
 . ;Set return entry
 . S CNT=CNT+1
 . S AMERPOV(CNT)=ICD_U_PS_U_PNAR_U_ICDIEN_U_ICDDESC_U_IEN_U_INJ
 ;
 Q CNT_U_PRM
 ;
AICD()   ;EP - Return 1 if AICD 4.0
 Q $S($$VERSION^XPDUTL("AICD")="4.0":1,1:0)
 ;
FMTDATE(X,TM) ;EP - Return formated date - Taken from BGOUTL
 Q:'X ""
 N M,D,V
 S M=$E(X,4,5),D=$E(X,6,7),V=$E(X,1,3)+1700
 S:M&D V=D_"/"_V
 S:M V=M_"/"_V
 I $G(TM) D
 .S X=X#1
 .Q:'X
 .S X=$TR($J(X*10000\1,4),0)
 .S V=V_" "_$E(X,1,2)_":"_$E(X,3,4)
 Q V
 ;
S(X) ;EP - Screen formatting - Based on AGVDF
 NEW AMERM1,AMERMVDF
 S AMERM1("X")=$X
 S AMERM1("LN")=$T(@X),AMERM1(1)=$P(AMERM1("LN"),";;",2),AMERM1(2)=$P(AMERM1("LN"),";;",3),AMERM1(3)=$P(AMERM1("LN"),";;",4)
 S AMERMVDF(+IOST(0),X)=$P($G(^%ZIS(2,+IOST(0),AMERM1(1))),"^",AMERM1(2),AMERM1(3))
 I AMERMVDF(+IOST(0),X)="" S AMERMVDF(+IOST(0),X)="*0"
 W @AMERMVDF(+IOST(0),X)
 S $X=AMERM1("X")
 S X=""
 Q X
 ;
LEX(SEARCH,COUNT,FILTER,DATE,GENDER,RET) ;EP - Perform Lexicon Lookup
 ;
 ; SEARCH - The string to search on (Required)
 ; COUNT  - The number of records to return (Optional) - Default 999
 ; FILTER - 0 - Regular Search - Filter out Cause of Injury Codes (Default)
 ;          1 - Cause of Injury Search - Return only Cause of Injury Codes
 ;          2 - Full Search - Return all results - no filtering
 ;   DATE - The date to search on (default to today)
 ; GENDER - The patient gender (M/F/U) (Optional)
 ;    RET - Return array
 ;
 ;Input checks
 I $G(SEARCH)="" Q
 S COUNT=$G(COUNT) S:'+COUNT COUNT=999
 S FILTER=$G(FILTER) S:FILTER="" FILTER=0
 S DATE=$G(DATE) S:DATE="" DATE=DT
 S GENDER=$G(GENDER)
 ;
 NEW ICD10,CSET,DIC,AUPNSEX,LEX,DELIMITER,DPLIST,TOTREC
 ;
 K ^TMP("LEXSCH"),^TMP("LEXFND"),LEX("LIST")
 ;
 ;Set gender variable used in filtering call
 S:($G(GENDER)]"") AUPNSEX=GENDER
 ;
 ;Determine if ICD-10 has been implemented
 S ICD10=0 I $$VERSION^XPDUTL("AICD")>3.51,$$IMP^ICDEXA(30)'>DATE S ICD10=1
 S CSET=$S(ICD10=0:"ICD",1:"10D")
 ;
 D CONFIG^LEXSET(CSET,CSET,DATE)
 ;S DIC("S")="I $$ICDONE1^APCDAPOV(+Y,LEXVDT)"
 ;
 ;Choose the filter
 S DIC("S")="I $$FILTER^AMERUTIL(+Y,LEXVDT,$G(ICD10),$G(FILTER))"
 ;
 ;Perform search
 D LOOK^LEXA(SEARCH,$G(CSET),$G(COUNT),$G(CSET),$G(DATE))
 ;
 ;Determine the delimiter
 S DELIMITER=$S(ICD10=0:"ICD-9-CM ",1:"ICD-10-CM ")
 ;
 S TOTREC=0,LEX="0" F  S LEX=$O(LEX("LIST",LEX)) Q:LEX=""  D
 . I '+LEX Q
 . NEW CODE,LIEN,DIEN,DESC
 . ;
 . ;Get the code
 . S CODE=$P($P(LEX("LIST",LEX),DELIMITER,2),")")
 . ;
 . ;Look for code in file 80
 . I $$AICD() S ICD=$$ICDDX^ICDEX(CODE)
 . E  S ICD=$$ICDDX^ICDCODE(CODE)
 . ;
 . ;If cannot find, tack on a period
 . I $P(ICD,U)="-1",CODE'["." D
 .. S CODE=CODE_"."
 .. I $$AICD() S ICD=$$ICDDX^ICDEX(CODE)
 .. E  S ICD=$$ICDDX^ICDCODE(CODE)
 . ;
 . ;Filter out duplicates
 . I $D(DPLIST(CODE)) Q
 . ;
 . ;Quit if code not found
 . I $P(ICD,U)="-1" Q
 . ;
 . ;Create entry to return
 . S DIEN=$P(ICD,U) Q:DIEN=""
 . S CODE=$P(ICD,U,2)
 . S DESC=$P(ICD,U,4)
 . S TOTREC=TOTREC+1,RET(TOTREC)=DIEN_U_CODE_U_DESC
 . S DPLIST(CODE)=""
 Q
 ;
 ;Filter on Cause of Injury
FILTER(ALEX,ALEXVDT,ICD10,FILTER) ;Filtering for Lexicon lookup
 ;
 ;Input parameters
 ;          ALEX - IEN of file 757.01
 ;       ALEXVDT - Date to use for screening by codes
 ;         ICD10 - 1 - ICD10, 0 - ICD9
 ;        FILTER - 0 - No Cause of Injury, 1 - Only Cause of Injury, 2 - All codes
 ;
 NEW RETURN,APCDDATE
 ;
 ;Default to return
 S RETURN=1
 ;
 ;For FILTER equal 2 - Return all
 I $G(FILTER)=2 Q RETURN
 ;
 ;ICD9 - Filter 0
 I FILTER=0,ICD10=0 D  Q RETURN
 . N ALEXICD
 . S ALEXVDT=$S(+$G(ALEXVDT)>0:ALEXVDT,1:$$DT^XLFDT)
 . S ALEX=$$ICDONE^LEXU(ALEX,ALEXVDT) I ALEX="" S RETURN="" Q
 . S ALEXICD=$$ICDDX^AUPNVUTL(ALEX,ALEXVDT,"E")
 . I $P(ALEXICD,"^",2)="INVALID CODE" S RETURN="" Q
 . S APCDDATE=ALEXVDT
 . I '$$CHK^AUPNSICD($P(ALEXICD,U,1)) S RETURN="" Q
 ;
 ;ICD10 - Filter 0
 I FILTER=0,ICD10=1 D  Q RETURN
 . N ALEXICD
 . S ALEX=$$ONE^LEXU(ALEX,ALEXVDT,"10D") I ALEX="" S RETURN="" Q
 . S ALEXICD=$$ICDDX^AUPNVUTL(ALEX,ALEXVDT,"E")
 . I $P(ALEXICD,"^",2)="INVALID CODE" S RETURN="" Q
 . S APCDDATE=ALEXVDT
 . I '$$CHK^AUPNSICD($P(ALEXICD,U,1)) S RETURN="" Q
 ;
 ;Both ICD9/ICD10 - Filter 1
 I FILTER=1 D  Q RETURN
 . N ALEXICD,ALEVXDT,%
 . S ALEX=$$ONE^LEXU(ALEX,ALEXVDT,$S(ICD10=1:"10D",1:"ICD")) I ALEX="" S RETURN="" Q
 . S ALEXICD=$$ICDDX^AUPNVUTL(ALEX,ALEXVDT,"E")
 . I $P(ALEXICD,"^",2)="INVALID CODE" S RETURN="" Q
 . I '$$CHK^AMERUTIL($P(ALEXICD,U,1),ICD10,ALEXVDT) S RETURN="" Q
 ;
 Q
 ;
CHK(Y,ICD10,ALEXVDT)   ;EP - SCREEN NON CAUSE OF INJURY AND INACTIVE CODES
 NEW A,I,%
 I $G(DUZ("AG"))'="I" Q 1
 S:ALEXVDT="" ALEXVDT=DT
 S I=$S($G(ICD10)=0:1,1:30)
 S %=$$ICDDX^AUPNVUTL(Y,ALEXVDT,"I") I 1
 I $P(%,U,20)]"",$P(%,U,20)'=I Q 0   ;not correct coding system
 S I="CHKDX"_I
 G @I
 ;
CHKDX1   ;CODING SYSTEM 1 - ICD9
 ;
 ;Only return E codes
 I $E($P(%,U,2),1)'="E" Q 0
 ;
 ;Skip inactive codes
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 ;
 ;If 'USE WITH SEX' field has a value check that value against AUPNSEX
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
 ;
CHKDX30  ;coding system 30 - ICD10
 NEW RET
 S RET=0
 I $E($P(%,U,2),1)="V" S RET=1
 I 'RET,$E($P(%,U,2),1)="W" S RET=1
 I 'RET,$E($P(%,U,2),1)="X" S RET=1
 I 'RET,$E($P(%,U,2),1)="Y" D
 . NEW EXC
 . S EXC=$E($P(%,U,2),1,3)
 . ;
 . ;Handle exceptions to the list
 . I EXC'="Y92",EXC'="Y93" S RET=1
 . S RET=0
 ;
 I '$P(%,U,10) S RET=0  ;STATUS IS INACTIVE
 ;
 ;If 'USE WITH SEX' field has a value check that value against AUPNSEX
 I '$D(AUPNSEX) Q RET
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX S RET=0
 Q RET
 ;
 ;Locations of screen handling options for device
HIN ;;7;;1;;1;;HI INTENSITY ON
HIF ;;7;;2;;2;;HI INTENSITY OFF
RVN ;;5;;4;;4;;REVERSE VIDEO ON
RVF ;;5;;5;;5;;REVERSE VIDEO OFF
ULN ;;6;;4;;4;;UNDERLINE ON
ULF ;;6;;5;;5;;UNDERLINE OFF
DTP ;;17;;1;;1;;DOUBLE HIGH TOP HALF
DTB ;;17;;2;;2;;DOUBLE HIGH BOTTOM HALF
BLN ;;5;;8;;8;;BLINK ON
BLF ;;5;;9;;9;;BLINK OFF
IOF ;;1;;2;;2;;FORM FEED/CLEAR SCREEN
10  ;;5;;1;;1;;TEN PITCH
12  ;;5;;2;;2;;TWELVE PITCH
16  ;;12.1;;1;;250;;SIXTEEN PITCH
