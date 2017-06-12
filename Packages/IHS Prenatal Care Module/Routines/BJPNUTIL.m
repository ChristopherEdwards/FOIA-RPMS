BJPNUTIL ;GDIT/HS/BEE-Prenatal Care Module Utility Calls ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**6,7,8**;Feb 24, 2015;Build 25
 ;
 Q
 ;
GETCOI(DATA,TEXT,VIEN,COUNT) ;BJPN SELECT INJURY CAUSE
 ;
 ;Accept search string and return list of matching Cause of Injury values to choose
 ;Uses a call to the Lexicon to generate the list
 ;
 ;Input
 ; TEXT - The string to search on
 ; VIEN - The visit IEN
 ;COUNT - The number of records to return (optional - default to 25)
 ;
 NEW UID,II,VDT,SEX,DFN,RET
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNUTIL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNUTIL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define header
 S @DATA@(0)="I00010IEN^T00020CODE^T00200DESCRIPTION"_$C(30)
 ;
 I $G(TEXT)="" S BMXSEC="Missing text to search on" G XGETCOI
 I $G(VIEN)="" S BMXSEC="Missing Visit IEN" G XGETCOI
 S:'+$G(COUNT) COUNT=25
 ;
 ;Get visit date and gender
 S VDT=$P($$GET1^DIQ(9000010,VIEN_",",.01,"I"),".") S:VDT="" VDT=DT
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I")
 S SEX=$$GET1^DIQ(2,DFN_",",.02,"I")
 ;
 ;Make the call
 D LEX(TEXT,COUNT,1,VDT,SEX,.RET)
 S RET="" F  S RET=$O(RET(RET)) Q:RET=""  S II=II+1,@DATA@(II)=RET(RET)_$C(30)
 ;
XGETCOI S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
LEX(SEARCH,COUNT,FILTER,DATE,GENDER,RET) ;EP - Perform Lexicon Lookup
  ;
 ; SEARCH - String to search on (Required)
 ; COUNT - Number of records to return (Optional) - Default 999
 ; FILTER - 0 - Regular Search - Filter out Cause of Injury Codes (Default)
 ;  1 - Cause of Injury Search - Return only Cause of Injury Codes
 ;  2 - Full Search - Return all results - no filtering
 ;  DATE - Date to search on (default to today)
 ; GENDER - Patient gender (M/F/U) (Optional)
 ;  RET - Return array
 ;
 ;Input checks
 I $G(SEARCH)="" Q
 S COUNT=$G(COUNT) S:'+COUNT COUNT=999
 S FILTER=$G(FILTER) S:FILTER="" FILTER=0
 S DATE=$G(DATE) S:DATE="" DATE=DT
 S GENDER=$G(GENDER)
 ;
 NEW ICD10,CSET,DIC,AUPNSEX,LEX,DELIMITER,DPLIST,TOTREC,ICD
 ;
 K ^TMP("LEXSCH"),^TMP("LEXFND"),LEX("LIST")
 ;
 ;Set gender variable used in filtering call
 S:($G(GENDER)]"") AUPNSEX=GENDER
 ;
 ;Determine if ICD-10
 S ICD10=0 I $$VERSION^XPDUTL("AICD")>3.51,$$IMP^ICDEXA(30)'>DATE S ICD10=1
 S CSET=$S(ICD10=0:"ICD",1:"10D")
 ;
 D CONFIG^LEXSET(CSET,CSET,DATE)
 ;
 ;Choose filter
 S DIC("S")="I $$FILTER^BJPNUTIL(+Y,LEXVDT,$G(ICD10),$G(FILTER))"
 ;
 ;Search
 D LOOK^LEXA(SEARCH,$G(CSET),$G(COUNT),$G(CSET),$G(DATE))
 ;
 ;Determine the delimiter
 S DELIMITER=$S(ICD10=0:"ICD-9-CM ",1:"ICD-10-CM ")
 ;
 S TOTREC=0,LEX="0" F  S LEX=$O(LEX("LIST",LEX)) Q:LEX=""  D
 . I '+LEX Q
 . NEW CODE,LIEN,DIEN,DESC
 . ;
 . ;Get code
 . S CODE=$P($P(LEX("LIST",LEX),DELIMITER,2),")")
 . ;
 . ;Look for code in file 80
 . I $$AICD() S ICD=$$ICDDX^ICDEX(CODE)
 . E  S ICD=$$ICDDX^ICDCODE(CODE)
 . ;
 . ;Tack on period
 . I $P(ICD,U)="-1",CODE'["." D
 .. S CODE=CODE_"."
 .. I $$AICD() S ICD=$$ICDDX^ICDEX(CODE)
 .. E  S ICD=$$ICDDX^ICDCODE(CODE)
 . ;
 . ;Filter out duplicates
 . I $D(DPLIST(CODE)) Q
 . ;
 . ;Not found
 . I $P(ICD,U)="-1" Q
 . ;
 . ;Create entry
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
 ;   ALEX - IEN of file 757.01
 ;       ALEXVDT - Date to use for screening by codes
 ;  ICD10 - 1 - ICD10, 0 - ICD9
 ; FILTER - 0 - No Cause of Injury, 1 - Only Cause of Injury, 2 - All codes
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
 . I '$$CHK^BJPNUTIL($P(ALEXICD,U,1),ICD10,ALEXVDT) S RETURN="" Q
 ;
 Q
 ;
CHK(Y,ICD10,ALEXVDT)   ;EP - SCREEN NON CAUSE OF INJURY AND INACTIVE CODES
 NEW A,I,%
 I $G(DUZ("AG"))'="I" Q 1
 S:ALEXVDT="" ALEXVDT=DT
 S I=$S($G(ICD10)=0:1,1:30)
 S %=$$ICDDX^AUPNVUTL(Y,ALEXVDT) I 1
 I $P(%,U,20)]"",$P(%,U,20)'=I Q 0   ;not correct coding system
 S I="CHKDX"_I
 G @I
 ;
CHKDX1     ;CODING SYSTEM 1 - ICD9
 ;
 ;Only return E codes
 I $E($P(%,U,2),1)'="E" Q 0
 ;
 ;Skip inactive codes
 I '$P(%,U,10) Q 0  ;INACTIVE
 ;
 ;If 'USE WITH SEX' field has a value check that value against AUPNSEX
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
 ;
CHKDX30   ;coding system 30-ICD10
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
 ;If 'USE WITH SEX' field has a value check against AUPNSEX
 I '$D(AUPNSEX) Q RET
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX S RET=0
 Q RET
 ;
AICD() ;EP - Return 1 if AICD 4.0
 Q $S($$VERSION^XPDUTL("AICD")="4.0":1,1:0)
 ;
LOG(BJPNCAT,BJPNACT,BJPNCALL,BJPNDESC,BJPNVDFN) ;EP - Log Prenatal Audit entry
 ;
 NEW BJPNDFN,X,RES
 ;
 ;See if BUSA has been installed
 S X="BUSAAPI" X ^%ZOSF("TEST") I '$T Q "BUSA has not been installed"
 ;
 ;Check the input
 I ",S,P,D,O,"'[(","_$G(BJPNCAT)_",") Q "Invalid Audit Category"
 I (BJPNCAT="P"),(",A,D,Q,P,E,C,"'[(","_$G(BJPNACT)_",")) Q "Invalid Audit Action"
 I $G(BJPNDESC)="" Q "Invalid Audit Log Description"
 S:$G(BJPNCALL)="" BJPNCALL="AMER Audit API Call"
 ;
 ;Handle single patients passed in
 I $D(BJPNVDFN)=1,$G(BJPNVDFN)]"" D
 . S BJPNDFN(1)=BJPNVDFN
 ;
 ;Handle multiple patients passed in
 I $D(BJPNVDFN)>9 D
 . NEW II,CNT
 . S II="",CNT=0 F  S II=$O(BJPNVDFN(II)) Q:II=""  S CNT=CNT+1,BJPNDFN(CNT)=BJPNVDFN(II)
 ;
 ;Perform audit call
 S RES=$$LOG^BUSAAPI("A",BJPNCAT,BJPNACT,BJPNCALL,BJPNDESC,"BJPNDFN")
 Q RES
 ;
ASTHMA(DATA,CODE,SNOMED) ;EP - BJPN CHECK FOR ASTHMA
 ;
 NEW UID,II,RET
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNUTIL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNUTIL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define header
 S @DATA@(0)="I00001RESULT"_$C(30)
 ;
 I $G(CODE)="",$G(SNOMED)="" S BMXSEC="Both ICD code and SNOMED cannot be null" G XASTHMA
 ;
 ;Call MSC to perform check
 D CHKASM^BGOASLK(.RET,$G(CODE),$G(SNOMED))
 S II=II+1,@DATA@(II)=+$G(RET)_$C(30)
 ;
XASTHMA S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ISINJ(DATA,SNOMED,VIEN) ;EP - BJPN CHECK FOR INJURY
 ;
 NEW UID,II,RET
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNUTIL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNUTIL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define header
 S @DATA@(0)="I00001RESULT"_$C(30)
 ;
 I $G(SNOMED)="" S BMXSEC="Missing Concept Id" G XISINJ
 I $G(VIEN)="" S BMXSEC="Missing VIEN" G XISINJ
 ;
 ;Call MSC to perform check
 D INJURY^BGOVPOV2(.RET,SNOMED,VIEN)
 S II=II+1,@DATA@(II)=+$G(RET)_$C(30)
 ;
XISINJ S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ASTCLS(DATA,FAKE) ;EP - BJPN GET ASTHMA CLASSES
 ;
 NEW UID,II
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNUTIL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNUTIL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define header
 S @DATA@(0)="T00050ASTHMA_CLASSIFICATIONS"_$C(30)
 ;
 ;Hardset entries
 S II=II+1,@DATA@(II)="INTERMITTENT"_$C(30)
 S II=II+1,@DATA@(II)="MILD PERSISTENT"_$C(30)
 S II=II+1,@DATA@(II)="MODERATE PERSISTENT"_$C(30)
 S II=II+1,@DATA@(II)="SEVERE PERSISTENT"_$C(30)
 ;
XASTCLS S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ASTCON(DATA,FAKE) ;EP - BJPN GET ASTHMA CONTROL
 ;
 NEW UID,II
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNUTIL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNUTIL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define header
 S @DATA@(0)="T00050ASTHMA_CONTROL"_$C(30)
 ;
 ;Hardset entries
 S II=II+1,@DATA@(II)="WELL CONTROLLED"_$C(30)
 S II=II+1,@DATA@(II)="NOT WELL CONTROLLED"_$C(30)
 S II=II+1,@DATA@(II)="VERY POORLY CONTROLLED"_$C(30)
 ;
XASTCON S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
INJPLC(DATA,FAKE) ;EP - BJPN GET INJURY PLACE LIST
 ;
 NEW UID,II
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNUTIL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNUTIL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define header
 S @DATA@(0)="T00005INJ_PLACE_CD^T00050INJURY_PLACE"_$C(30)
 ;
 ;Hardset entries
 S II=II+1,@DATA@(II)="A^HOME-INSIDE"_$C(30)
 S II=II+1,@DATA@(II)="B^HOME-OUTSIDE"_$C(30)
 S II=II+1,@DATA@(II)="C^FARM"_$C(30)
 S II=II+1,@DATA@(II)="D^SCHOOL"_$C(30)
 S II=II+1,@DATA@(II)="E^INDUSTRIAL PREMISES"_$C(30)
 S II=II+1,@DATA@(II)="F^RECREATIONAL AREA"_$C(30)
 S II=II+1,@DATA@(II)="G^STREET/HIGHWAY"_$C(30)
 S II=II+1,@DATA@(II)="H^PUBLIC BUILDING"_$C(30)
 S II=II+1,@DATA@(II)="I^RESIDENT INSTITUTION"_$C(30)
 S II=II+1,@DATA@(II)="J^HUNTING/FISHING"_$C(30)
 S II=II+1,@DATA@(II)="K^OTHER"_$C(30)
 S II=II+1,@DATA@(II)="L^UNKNOWN"_$C(30)
 ;
XINJPLC S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DXCAUSE(DATA,FAKE) ;EP - BJPN GET DX CAUSE
 ;
 NEW UID,II,RET,ARR
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNUTIL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNUTIL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define header
 S @DATA@(0)="T00010CODE^T00050DX_CAUSE"_$C(30)
 ;
 D GETSET^BGOUTL3(.RET,9000010.07,.07)
 ;
 S ARR="" F  S ARR=$O(RET(ARR)) Q:ARR=""  S II=II+1,@DATA@(II)=$P(RET(ARR),U)_U_$P(RET(ARR),U,2)_$C(30)
 ;
XDXCAUSE S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
COMP(DFN,UID,VIEN,PRBIEN) ;EP - Call EHR API and format results into usable data
 ;
 NEW RET,TMP,T,BGO,LAT
 ;
 ;If no problem passed in get all
 I $G(PRBIEN)="" D GET^BGOPROB(.RET,DFN,"ASEORPI","A",99999,2)
 ;
 ;If problem passed in, get one
 I +$G(PRBIEN) D GETONE^BGOPROB1(.RET,+PRBIEN,2)
 ;
 ;Reset compile global - data to be used by this call and future RPC calls
 K ^TMP("BJPNIPL",UID)
 ;
 ;Populate information
 S TMP=$NA(^TMP("BJPNIPL",UID))
 S (T,BGO)="" F  S BGO=$O(@RET@(BGO)) Q:BGO=""  D
 . NEW N
 . S N=$G(@RET@(BGO))
 . S P=$G(P)
 . I $P(N,U)="P" S P=$P(N,U,2) S:P]"" B=BGO,@TMP@("P",P,B)=N,T="P" Q  ;Problems
 . I $P(N,U)="C" S P=$P(N,U,3) S:P]"" B=BGO,@TMP@("C",P,B,0)=N,T="C" Q  ;Care Plans
 . I $P(N,U)="G" S P=$P(N,U,3) S:P]"" B=BGO,@TMP@("G",P,B,0)=N,T="G" Q  ;Goals
 . I $P(N,U)="I" S P=$P(N,U,3) S:P]"" B=BGO,@TMP@("I",P,B,0)=N,T="I" Q  ;Visit Instructions
 . I $P(N,U)="O" S P=$P(N,U,3) S:P]"" B=BGO,@TMP@("O",P,B,0)=N,T="O" Q  ;OB Note
 . I $P(N,U)="T" S P=$P(N,U,4) S:P]"" B=BGO,@TMP@("T",P,B,0)=N,T="T" Q  ;Treatment Regimen
 . I $P(N,U)="E" S:P]"" B=BGO,@TMP@("E",P,B,0)=$$PTED^BJPNPUTL(N)  ;Education
 . I $P(N,U)="A" S:P]"" B=BGO,@TMP@("A",P,B,0)=N  ;Asthma
 . I $P(N,U)="Q" S:P]"" B=BGO,@TMP@("Q",P,B,0)=N  ;Qualifiers
 . ;
 . ;C/G/I/O/T Text
 . I $E(N,1)="~",P]"",T]"",B]"" S @TMP@(T,P,B,$O(@TMP@(T,P,B,""),-1)+1)=N
 ;
 ;Get POVs
 I $G(VIEN)]"" D
 . NEW FNDPS,PVLST,FINFO
 . S PVLST=""
 . D GET^BGOVPOV(.RET,VIEN)
 . S BGO="" F  S BGO=$O(@RET@(BGO)) Q:BGO=""  D
 .. NEW N,P,PS,PENT,B,PVIEN
 .. S N=$G(@RET@(BGO))
 .. S P=$P(N,U,24)   ;Problem
 .. ;
 .. Q:P=""  ;Quite if no problem
 .. Q:'$D(@TMP@("P",P))  ;Quit if not in list
 .. S B=$O(@TMP@("P",P,"")) Q:B=""  ;Quit if no entry
 .. ;
 .. S PS=$P(N,U,16)  ;Primary/Secondary
 .. I PS="PRIMARY" S FNDPS(P)="Y"
 .. S PVIEN=$P(N,U)  ;POV IEN
 .. I PVIEN]"" S PVLST=PVLST_$S(PVLST]"":$C(29),1:"")_PVIEN
 .. ;
 .. ;Look for episodicity and injury info
 .. I $G(FINFO(P))="" D
 ... NEW EP,REV,INJCASS,PLC,INJDT,INJCEXT,INJCINT,AF
 ... S EP=$P(N,U,6) S:EP]"" FINFO(P)=1 ;Episodicity
 ... S REV=$P(N,U,11) S:REV]"" FINFO(P)=1 ;Injury Revisit
 ... S INJCASS=$P(N,U,12) S:INJCASS]"" FINFO(P)=1 ;Inj Association
 ... S PLC=$P($P(N,U,15),"~") S:PLC]"" FINFO(P)=1 ;Inj Place
 ... S INJDT=$P(N,U,13) S:INJDT]"" FINFO(P)=1 ;Injury Date
 ... S INJCEXT=$P(N,U,14) S:INJCEXT]"" FINFO(P)=1 ;Ext Inj Cause
 ... S INJCINT=$P(N,U,25) S:INJCINT]"" FINFO(P)=1 ;Int Inj Cause
 ... ;BJPN*2.0*6;Include abnormal findings
 ... S AF=$P($P(N,U,28),";")
 ... S:AF]"" AF=$O(^BSTS(9002318.6,"C","AF",AF,""))
 ... S:AF]"" FINFO(P)=1 ;Abnormal Findings
 ... S FINFO(P,"AF")=AF
 ... S FINFO(P,"EP")=EP
 ... S FINFO(P,"REV")=REV
 ... S FINFO(P,"INJCASS")=INJCASS
 ... S FINFO(P,"PLC")=PLC
 ... S FINFO(P,"INJDT")=INJDT
 ... S FINFO(P,"INJCEXT")=INJCEXT
 ... S FINFO(P,"INJCINT")=INJCINT
 .. ;
 .. ;BJPN*2.0*7;Moved from 20-29 to 30-39 because IPL API returns more fields now
 .. ;Set the Primary/Secondary,POV IEN, and Episodicity in the problem entry
 .. S $P(@TMP@("P",P,B),U,30,39)=$G(FNDPS(P))_U_PVLST_U_$G(FINFO(P,"EP"))_U_$G(FINFO(P,"REV"))_U_$G(FINFO(P,"PLC"))_U_$G(FINFO(P,"INJDT"))_U_$G(FINFO(P,"INJCEXT"))_U_$G(FINFO(P,"INJCINT"))_U_$G(FINFO(P,"INJCASS"))_U_$G(FINFO(P,"AF"))
 ;
 Q
 ;
INJURY(DATA,CODE,SNOMED) ;EP - BJPN INJURY CHECK
 ;
 NEW UID,II,RET
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNUTIL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNUTIL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define header
 S @DATA@(0)="I00001RESULT"_$C(30)
 ;
 I $G(CODE)="" S BMXSEC="Missing ICD code value" G XINJURY
 I $G(SNOMED)="" S BMXSEC="Missing SNOMED code" G XINJURY
 ;
 ;Call MSC to perform check
 D CHKASM^BGOASLK(.RET,CODE,SNOMED)
 S II=II+1,@DATA@(II)=+$G(RET)_$C(30)
 ;
XINJURY S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 Q
