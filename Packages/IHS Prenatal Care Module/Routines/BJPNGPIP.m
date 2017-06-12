BJPNGPIP ;GDIT/HS/BEE-Prenatal Care Module Problem List ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**3,7,8**;Feb 24, 2015;Build 25
 ;
 Q
 ;
PIP(DATA,DFN,VIEN,PIPLST) ;EP - BJPN GET PIP
 ;
 ;This RPC returns the patient PIP (PREGNANCY ISSUES AND PROBLEMS)
 ;
 ;Input:  DFN - Patient IEN
 ;       VIEN (optional) - Visit IEN
 ;     PIPLST (optional) - List of specific entries to return ($c(28) separated)
 ;
 NEW UID,II,RET,BGO,TMP,B,P,T,PRBIEN,VDT,I,PC,PPLST
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNGPIP D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Verify DFN was entered
 I $G(DFN)="" G XPIP
 S VIEN=$G(VIEN,"")
 ;
 ;Set up Header
 S @DATA@(II)="I00010PIPIEN^I00010PRBIEN^T00012PRIORITY^T00001PIP_STATUS^T00025SCOPE"
 S @DATA@(II)=@DATA@(II)_"^D00030LM_DT^T00050LM_BY^T00010IPL_STS^T00120ICD^T04096HOVER_ICD"
 S @DATA@(II)=@DATA@(II)_"^T00160PROVIDER_TEXT^T00360PROVIDER_NARRATIVE^T04096LAST_GOAL"
 S @DATA@(II)=@DATA@(II)_"^T04096LAST_CARE_PLAN^T04096LAST_VISIT_INSTRUCTION"
 S @DATA@(II)=@DATA@(II)_"^I00010HIDE_PRV^T00035PRV^D00015DEFINITIVE_EDD^T00001POV"
 S @DATA@(II)=@DATA@(II)_"^T00001INPATIENT_POV^T00001PRIMARY^T00001PATIENT_TYPE^T00001POV_DISP"
 S @DATA@(II)=@DATA@(II)_"^T00030ONSET_DT^T00050LOCATION^I00010POV_IEN^T04096LAST_OB"_$C(30)
 ;
 ;Get the visit date or default to DT if visit not passed in
 I $G(VIEN)]"" S VDT=$P($$GET1^DIQ(9000010,VIEN_",",".01","I"),".")
 S:$G(VDT)="" VDT=DT
 ;
 ;Call EHR API and format results into usable data
 D COMP^BJPNUTIL(DFN,UID,VIEN)
 S TMP=$NA(^TMP("BJPNIPL",UID))  ;Define compiled data reference
 ;
 ;Assemble Specific PIP List
 S PIPLST=$G(PIPLST,"") F I=1:1:$L(PIPLST,$C(28)) S PC=$P(PIPLST,$C(28),I) I PC]"" S PPLST(PC)=""
 ;
 ;Loop through problems for patient
 S PRBIEN="" F  S PRBIEN=$O(^BJPNPL("F",DFN,PRBIEN)) Q:PRBIEN=""  D
 . NEW BPIEN
 . S BPIEN="" F  S BPIEN=$O(^BJPNPL("F",DFN,PRBIEN,BPIEN)) Q:BPIEN=""  D
 .. NEW DEL,DESCID,CONCID,DESCTM,PTEXT,PNARR,BGO,API,XPRI,XSTS,XLMDT,XLMBY,IPLSTS,PRIMARY,DPOV,CDEL
 .. NEW ICD,ADDICD,ICDCNT,ADICD,HICD,GGO,CGO,VGO,GOAL,CARE,INST,DEDD,POV,IPOV,ITYPE,PRV,XPRV,XSCO
 .. NEW ONSET,LOC,PVIEN,TGO,CPGSTS,VOB,OB,X1,X2,X,DEDD,BRNG
 .. ;
 .. ;Handle specific PIP requests
 .. I $D(PPLST),'$D(PPLST(BPIEN)) Q
 .. ;
 .. ;Skip deletes
 .. S DEL=$$GET1^DIQ(90680.01,BPIEN_",",2.01,"I") Q:DEL]""  ;PIP Delete
 .. S DEL=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") I DEL]"" D  Q  ;IPL Delete
 ... ;
 ... ;If deleted on IPL, need to delete in PIP
 ... NEW BJPNUPD,ERROR
 ... S BJPNUPD(90680.01,BPIEN_",",2.01)=$$GET1^DIQ(9000011,PRBIEN_",",2.01,"I") ;Deleted By
 ... S BJPNUPD(90680.01,BPIEN_",",2.02)=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") ;Del Dt/Tm
 ... S BJPNUPD(90680.01,BPIEN_",",2.03)=$$GET1^DIQ(9000011,PRBIEN_",",2.03,"I") ;Del Rsn
 ... S BJPNUPD(90680.01,BPIEN_",",2.04)=$$GET1^DIQ(9000011,PRBIEN_",",2.04,"I") ;Del Other
 ... D FILE^DIE("","BJPNUPD","ERROR")
 .. ;
 .. ;Retrieve the entry from the API results
 .. S BGO=$O(@TMP@("P",PRBIEN,"")) Q:BGO=""   ;Quit if no IPL entry
 .. S API=$G(@TMP@("P",PRBIEN,BGO)) Q:API=""
 .. ;
 .. ;SNOMED DescId and ConcId
 .. S DESCID=$P(API,U,4)
 .. S:DESCID="" DESCID=$$GET1^DIQ(9000011,PRBIEN_",",80002,"I") Q:DESCID=""
 .. S DESCTM=$P($$DESC^BSTSAPI(DESCID_"^^1"),U,2) Q:DESCTM=""
 .. S CONCID=$P(API,U,3)
 .. S:CONCID="" CONCID=$$GET1^DIQ(9000011,PRBIEN_",",80001,"I") Q:CONCID=""
 .. ;
 .. ;PIP Priority
 .. S XPRI=$$GET1^DIQ(90680.01,BPIEN_",",.06,"E")
 .. ;
 .. ;Status
 .. S XSTS=$$GET1^DIQ(90680.01,BPIEN_",",.08,"E")
 .. ;
 .. ;Scope
 .. S XSCO=$$GET1^DIQ(90680.01,BPIEN_",",.07,"E")
 .. ;
 .. ;Last Modified Date
 .. S XLMDT=$$FMTE^BJPNPRL($$GET1^DIQ(9000011,PRBIEN_",",.03,"I"))
 .. ;
 .. ;Last Modified By
 .. S XLMBY=$$GET1^DIQ(9000011,PRBIEN_",",.14,"E")
 .. ;
 .. ;Get Window Start
 .. S DEDD=$$GET1^DIQ(90680.01,BPIEN_",",.09,"I")
 .. S X1=DEDD,X2=-280 D C^%DTC S BRNG=X
 .. ;
 .. ;IPL Status - Convert manually lower case can be displayed
 .. S IPLSTS=$P(API,U,6)
 .. S:IPLSTS="" IPLSTS=$$GET1^DIQ(9000011,PRBIEN_",",.12,"E")
 .. S IPLSTS=$S(IPLSTS="CHRONIC":"Chronic",IPLSTS="INACTIVE":"Inactive",IPLSTS="D":"DELETED",IPLSTS="SUB-ACUTE":"Sub-acute",IPLSTS="EPISODIC":"Episodic",IPLSTS="SOCIAL":"Social/Environmental",IPLSTS="ROUTINE/ADMIN":"Routine/Admin",1:"")
 .. ;
 .. ;Handle Personal Hx
 .. I $$GET1^DIQ(9000011,PRBIEN_",",.04,"I")="P" S IPLSTS="Personal Hx"
 .. ;
 .. ;ICD Information - Pull primary and additional ICD values
 .. S ICD=$P(API,U,9)
 .. S ADDICD=$P(API,U,13)
 .. I ADDICD]"" F ICDCNT=1:1:$L(ADDICD,"|") S ADICD=$P(ADDICD,"|",ICDCNT) I ADICD]"" S ICD=ICD_$S(ICD]"":"|",1:"")_ADICD
 .. ;
 .. ;ICD Hover field
 .. D
 ... NEW ADV,STS
 ... ;
 ... ;Only return if in ICD10
 ... I '$$ICD10^BSTSUTIL(DT) S HICD="No ICD9 mapping advice available" Q
 ... ;
 ... ;Get the mapping advice
 ... S STS=$$I10ADV^BSTSAPI("ADV",CONCID_"^1")
 ... S (HICD,ADV)="" F  S ADV=$O(ADV(ADV)) Q:ADV=""  S HICD=HICD_$S($L(HICD)]"":$C(13)_$C(10),1:"")_ADV(ADV)
 ... S:HICD HICD="No ICD10 mapping advice available"
 .. ;
 .. ;Location
 .. S LOC=$$GET1^DIQ(9000011,PRBIEN_",",.06,"I")
 .. ;
 .. ;Onset Date
 .. S ONSET=$$GET1^DIQ(9000011,PRBIEN_",",.13,"I")
 .. I ONSET]"" D
 ... I $E(ONSET,4,7)="0000" S ONSET="20"_$E(ONSET,2,3) Q  ;Year only
 ... I $E(ONSET,6,7)="00" S ONSET=+$E(ONSET,4,5)_"/20"_$E(ONSET,2,3) Q  ;Month/Year
 ... S ONSET=$$FMTE^BJPNPRL(ONSET,"5D")
 .. ;
 .. ;Provider Text
 .. S PNARR=$P(API,U,8)
 .. S PTEXT=$P(PNARR," | ",2)
 .. ;
 .. ;Reset Can Delete flag
 .. S CDEL="Y"
 .. ;
 .. ;Get latest Goal note
 .. S GOAL=""
 .. S GGO="" F  S GGO=$O(@TMP@("G",PRBIEN,GGO)) Q:GGO=""  D  Q:GOAL]""
 ... ;
 ... ;Skip inactive goals but mark as cannot delete
 ... S CPGSTS=$P($G(@TMP@("G",PRBIEN,GGO,0)),U,6)
 ... I CPGSTS="I" S CDEL="" Q
 ... ;
 ... ;Only include active
 ... I CPGSTS'="A" Q
 ... ;
 ... NEW NIEN,ND,BY,WHEN
 ... S ND=$G(@TMP@("G",PRBIEN,GGO,0))
 ... S BY=$P(ND,U,4)  ;BY
 ... S WHEN=$P($P(ND,U,5)," ")  ;WHEN
 ... S NIEN=0 F  S NIEN=$O(@TMP@("G",PRBIEN,GGO,NIEN)) Q:NIEN=""  D
 .... NEW NNT,L
 .... S NNT=$P($G(@TMP@("G",PRBIEN,GGO,NIEN)),U,2)
 .... S L=$E(GOAL,$L(GOAL))
 .... S GOAL=GOAL_$S(GOAL]"":$C(13)_$C(10),1:"")_NNT
 ... I GOAL]"",BY]"" S GOAL=GOAL_$C(13)_$C(10)_"Modified by: "_BY_" "_WHEN
 ... S CDEL=""
 .. ;
 .. ;Get latest Care Plan note
 .. S CARE=""
 .. S CGO="" F  S CGO=$O(@TMP@("C",PRBIEN,CGO)) Q:CGO=""  D  Q:CARE]""
 ... ;
 ... ;Skip inactive care plans but mark as cannot delete
 ... S CPGSTS=$P($G(@TMP@("C",PRBIEN,CGO,0)),U,6)
 ... I CPGSTS="I" S CDEL="" Q
 ... ;
 ... ;Only include active
 ... I CPGSTS'="A" Q
 ... ;
 ... NEW NIEN,ND,BY,WHEN
 ... S ND=$G(@TMP@("C",PRBIEN,CGO,0))
 ... S BY=$P(ND,U,4)  ;BY
 ... S WHEN=$P($P(ND,U,5)," ")  ;WHEN
 ... S NIEN=0 F  S NIEN=$O(@TMP@("C",PRBIEN,CGO,NIEN)) Q:NIEN=""  D
 .... NEW NNT,L,BY
 .... S ND=$G(@TMP@("C",PRBIEN,CGO,0))
 .... S NNT=$P($G(@TMP@("C",PRBIEN,CGO,NIEN)),U,2)
 .... S L=$E(CARE,$L(CARE))
 .... S CARE=CARE_$S(CARE]"":$C(13)_$C(10),1:"")_NNT
 ... I CARE]"",BY]"" S CARE=CARE_$C(13)_$C(10)_"Modified by: "_BY_" "_WHEN
 ... S CDEL=""
 .. ;
 .. ;Get latest V Visit Instruction
 .. S VGO=$O(@TMP@("I",PRBIEN,""))
 .. S INST="" I VGO]"" S INST=$$LVI^BJPNGNOT(PRBIEN,TMP,VGO,BRNG,.CDEL)
 .. ;
 .. ;Get latest V OB Note
 .. S VOB=$O(@TMP@("O",PRBIEN,""))
 .. S OB="" I VOB]"" S OB=$$LOB^BJPNGNOT(PRBIEN,TMP,VOB,BRNG,.CDEL)
 .. ;
 .. ;Treatment Regimen
 .. S TGO=$O(@TMP@("T",PRBIEN,"")) I TGO]"" S CDEL=""
 .. ;
 .. ;Visit POV
 .. S (IPOV,POV,ITYPE,DPOV)="" I VIEN]"" D
 ... S ITYPE=$$GET1^DIQ(9000010,VIEN_",",.07,"I") Q:ITYPE=""
 ... S ITYPE=$S(ITYPE="H":"H",1:"A")
 ... I $O(^AUPNPROB(PRBIEN,14,"B",VIEN,"")) S POV="Y"
 ... I $O(^AUPNPROB(PRBIEN,15,"B",VIEN,"")) S IPOV="Y"
 .. I (POV="Y")!(IPOV="Y") S DPOV="Y"
 .. ;
 .. ;Ever a POV - needed for deleting permission
 .. I $O(^AUPNPROB(PRBIEN,14,"B",""))]"" S CDEL=""
 .. I $O(^AUPNPROB(PRBIEN,15,"B",""))]"" S CDEL=""
 .. ;
 .. ;Get Primary/Secondary value
 .. S PRIMARY=$P(API,U,20)
 .. ;
 .. ;Get the V POV IEN
 .. S PVIEN=$P(API,U,21)
 .. ;
 .. ;Definitive EDD
 .. S DEDD=$$FMTE^BJPNPRL($$GET1^DIQ(90680.01,BPIEN_",",.09,"I"))
 .. ;
 .. ;PRV fields
 .. S (PRV,XPRV)=""
 .. S PRV=$$PPRV^BJPNPKL(VIEN)
 .. S:PRV]"" XPRV=$$GET1^DIQ(200,PRV_",",.01,"E")
 .. ;
 .. ;Set up entry
 .. S II=II+1,@DATA@(II)=BPIEN_U_PRBIEN_U_XPRI_U_XSTS_U_XSCO_U_XLMDT_U_XLMBY_U_IPLSTS
 .. S @DATA@(II)=@DATA@(II)_U_ICD_U_HICD_U_PTEXT_U_PNARR_U_GOAL_U_CARE_U_INST_U_PRV_U_XPRV
 .. S @DATA@(II)=@DATA@(II)_U_DEDD_U_POV_U_IPOV_U_PRIMARY_U_ITYPE_U_DPOV
 .. S @DATA@(II)=@DATA@(II)_U_ONSET_U_LOC_U_PVIEN_U_OB_$C(30)
 ;
XPIP S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
NOTES(DATA,DFN,PRBIEN,ITYPE,VIEN) ;EP - BJPN GET PR NOTES
 ;
 ;Get BJPN CARE PLANS, GOALS, VISIT INSTRUCTIONS
 ;
 ;This RPC returns the CVGT information for one problem - it is used on the
 ;PIP add/edit screen to populate the bottom CVGT section
 ;
 ;Input:  DFN - Patient IEN
 ;     PRBIEN - Problem IEN
 ;       ITYPE - (C) Care Plans, (G) Goals, (I) Visit Instructions, (T) Treatment Plan/Education
 ;       VIEN - If passed in, limit visit instructions and treatment reg returned to that visit
 ;
 S DFN=$G(DFN),PRBIEN=$G(PRBIEN),ITYPE=$G(ITYPE),VIEN=$G(VIEN)
 I ITYPE="" S BMXSEC="Null/Invalid TYPE value" Q
 ;
 NEW UID,II,SORT,PC,PARY,NEDT,TMP,SIGN,CNT,MDT,BGO,DEL,TYPE,TPC
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNGPIP",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNGPIP D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="T00001TYPE^I00010PRBIEN^I00010GCIIEN^I00010VIEN^D00030VISIT_DT^T00001NOTE_STATUS"
 S @DATA@(II)=@DATA@(II)_"^D00030LAST_MODIFIED^T00050MODIFIED_BY^T00160NOTE^I00010HIDE_DUZ^T00001SIGNED"_$C(30)
 ;
 ;For treatment request, include education as well
 I ITYPE["T",ITYPE'["E" S ITYPE=ITYPE_"~E"
 ;
 ;Verify DFN
 I DFN="" G XNOTES
 ;
 ;Definitive EDD date range check
 D GETPAR^CIAVMRPC(.NEDT,"BJPN POST DEDD DAYS","SYS",1,"I","")
 ;
 ;If blank default to 70
 I +$G(NEDT)<1 S NEDT=70
 ;
 ;Call EHR API and format results into usable data
 S TMP=$NA(^TMP("BJPNIPL",UID))  ;Define compiled data reference
 D COMP^BJPNUTIL(DFN,UID)
 ;
 ;Skip deletes
 S DEL=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") I DEL]"" Q  ;IPL Delete
 ;
 S CNT=0
 ;
 ;Loop through compiled results for type
 F TPC=1:1:$L(ITYPE,"~") S TYPE=$P(ITYPE,"~",TPC) I TYPE]"" S BGO="" F  S BGO=$O(@TMP@(TYPE,PRBIEN,BGO),-1) Q:BGO=""  D
 . ;
 . NEW APIRES,VISIT,DEDD,BRNG,ERNG,NIEN,X1,X2,X,VDT
 . NEW DTTM,MDBY,ILMBY,NOTE,NSTS,SIGN
 . ;
 . S SIGN=""
 . S APIRES=$G(@TMP@(TYPE,PRBIEN,BGO,0)) Q:APIRES=""
 . ;
 . ;Pull Visit - If V VISIT INSTRUCTIONS (GOALS and CARE PLANS are not visit driven)
 . S (VISIT,VDT)=""
 . I (TYPE="I")!(TYPE="O") S VISIT=$P(APIRES,U,9),VDT=$P(APIRES,U,4)
 . S:TYPE="T" VISIT=$P(APIRES,U,10),VDT=$P(APIRES,U,5)
 . I TYPE="E" D
 .. NEW VEDIEN
 .. S VEDIEN=$P(APIRES,U,6) Q:VEDIEN=""
 .. S VISIT=$$GET1^DIQ(9000010.16,VEDIEN_",",.03,"I")
 .. S VDT=$$GET1^DIQ(9000010,VISIT,.01,"I")
 . ;
 . ;Filter on visit
 . I ((TYPE="I")!(TYPE="T")!(TYPE="E"))!((TYPE="O")),VIEN]"",VIEN'=VISIT Q
 . ;
 . ;Skip Inactive Goals/Care Plans
 . I ((TYPE="G")!(TYPE="C")),$P(APIRES,U,6)'="A" Q
 . ;
 . ;Note IEN (Pointer to entry)
 . I TYPE'="E" S NIEN=$P(APIRES,U,2)
 . E  S NIEN=$P(APIRES,U,6)
 . Q:NIEN=""
 . ;
 . ;Pull Definitive EDD
 . S DEDD=$$GET1^DIQ(9000017,DFN_",",1311,"I")
 . S X1=DEDD,X2=-280 D C^%DTC S BRNG=X
 . S X1=DEDD,X2=NEDT D C^%DTC S ERNG=X
 . ;
 . ;Get note date/time entered and by - V VISIT INSTRUCTIONS/V OB
 . S (DTTM,ILMBY)=""
 . I TYPE="I" D
 .. S DTTM=$$GET1^DIQ(9000010.58,NIEN_",",1216,"I")
 .. S ILMBY=$$GET1^DIQ(9000010.58,NIEN_",",1217,"I")
 .. S SIGN=$P(APIRES,U,13)
 . I TYPE="O" D
 .. S DTTM=$$GET1^DIQ(9000010.43,NIEN_",",1216,"I")
 .. S ILMBY=$$GET1^DIQ(9000010.43,NIEN_",",1217,"I")
 .. S SIGN=$P(APIRES,U,13)
 . ;
 . ;Get note date/time entered and by - CARE PLAN
 . I TYPE'="I",TYPE'="T",TYPE'="E",TYPE'="O" D
 .. NEW IENS,DA
 .. S DA=$O(^AUPNCPL(NIEN,11,"B","A",""),-1) Q:DA=""
 .. S DA(1)=NIEN,IENS=$$IENS^DILF(.DA)
 .. S DTTM=$$GET1^DIQ(9000092.11,IENS,".03","I")
 .. S ILMBY=$$GET1^DIQ(9000092.11,IENS,".02","I")
 .. S SIGN=$P(APIRES,U,7)
 . ;
 . ;Get treatment plan date/time and by - V TREATMENT/REGIMEN
 . I TYPE="T" D
 .. S DTTM=$$GET1^DIQ(9000010.61,NIEN_",",1216,"I")
 .. S ILMBY=$$GET1^DIQ(9000010.61,NIEN_",",1217,"I")
 . ;
 . ;Get education plan date/time and by - V PATIENT ED
 . I TYPE="E" D
 .. S DTTM=$$GET1^DIQ(9000010.16,NIEN_",",1216,"I")
 .. S ILMBY=$$GET1^DIQ(9000010.16,NIEN_",",1217,"I")
 . ;
 . Q:DTTM=""
 . S MDBY=$$GET1^DIQ(200,ILMBY_",",".01","E")
 . ;
 . ;Get Note
 . I TYPE="T" S NOTE=$P($G(@TMP@(TYPE,PRBIEN,BGO,0)),U,14)
 . E  I TYPE="E" S NOTE=$P(APIRES,U,2)
 . E  D
 .. S NOTE=""
 .. NEW NIEN
 .. S NIEN=0 F  S NIEN=$O(@TMP@(TYPE,PRBIEN,BGO,NIEN)) Q:NIEN=""  D
 ... NEW NNT,L
 ... S NNT=$P($G(@TMP@(TYPE,PRBIEN,BGO,NIEN)),U,2)
 ... S L=$E(NOTE,$L(NOTE))
 ... S NOTE=NOTE_$S(NOTE]"":$C(13)_$C(10),1:"")_NNT
 . Q:NOTE=""
 . ;
 . ;Note Status
 . S NSTS="A"
 . I DEDD]"",DTTM'<BRNG,DTTM'>ERNG S NSTS="C"
 . ;
 . ;Determined signed/unsigned
 . S SIGN=$S(TYPE="T":"",SIGN]"":"S",1:"U")
 . ;
 . ;Set up record
 . S CNT=CNT+1,SORT(DTTM,CNT)=$S(TYPE="E":"T",1:TYPE)_U_PRBIEN_U_NIEN_U_VISIT_U_VDT_U_NSTS_U_$$FMTE^BJPNPRL(DTTM)_U_MDBY_U_NOTE_U_ILMBY_U_SIGN
 ;
 ;Sort - Most recent first
 S DTTM="" F  S DTTM=$O(SORT(DTTM),-1) Q:DTTM=""  D
 . S CNT="" F  S CNT=$O(SORT(DTTM,CNT),-1) Q:CNT=""  D
 .. S II=II+1,@DATA@(II)=SORT(DTTM,CNT)_$C(30)
 ;
XNOTES S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
