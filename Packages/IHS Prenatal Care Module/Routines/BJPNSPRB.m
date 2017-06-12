BJPNSPRB ;GDIT/HS/BEE-Prenatal Care Module Add/Edit RPCs - Other ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**6,7**;Feb 24, 2015;Build 53
 ;
 Q
 ;
PCHECK(DATA,DFN,CONCID,VIEN,DESCID,LAT,PRBIEN,CHG) ;EP - BJPN CHECK FOR PROBLEM
 ;
 ;BJPN*2.0*7;Call now being made to PCHECK^BJPNSPRB
 D PCHECK^BJPNPCHK(.DATA,DFN,CONCID,VIEN,DESCID,LAT,PRBIEN,CHG)
 Q
 ;
PROB(DATA,PRBIEN,PIPIEN,VIEN) ;EP - BJPN GET PROBLEM
 ;
 ;This RPC returns the detail for a particular problem
 ; * The IPL pointer is required - all relevant IPL data will be returned
 ; * The PIP pointer is optional - if present the relevant PIP data will be returned
 ;
 ;Input:
 ;     PRBIEN - Pointer to IPL
 ;     PIPIEN - Pointer to PIP (optional)
 ;       VIEN - Visit IEN
 ;
 NEW UID,II,RET,BGO,TMP,B,P,T,VDT,DFN,ONSET,LOC,EPROB,IPROB,IPRIO,CLASS,EP,INJREV,INJPLC,INJDT,EPSMD,EVAR
 NEW DEL,DESCID,CONCID,DESCTM,PTEXT,PNARR,BGO,API,XPRI,XSTS,XLMDT,XLMBY,IPLSTS,PRIMARY,QUAL,ASTHMA
 NEW ICD,ADDICD,ICDCNT,ADICD,HICD,GGO,CGO,VGO,GOAL,CARE,INST,DEDD,POV,IPOV,ITYPE,PRV,XPRV,XSCO,PVIEN
 NEW INJASS,INJCIEN,INJCCOD,INJCDSC,INJCHK,ABN,PLAT,ILAT,ELAT
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNSPRB",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 ;Set up Header
 S II=0
 S @DATA@(II)="I00010PIPIEN^I00010PRBIEN^T00012PRIORITY^T00001PIP_STATUS^T00025SCOPE"
 S @DATA@(II)=@DATA@(II)_"^T00025DESC_ID^T00500DESC_TERM^T00025CONC_ID^T00001IPL_PRIORITY^T00001CLASS"
 S @DATA@(II)=@DATA@(II)_"^D00030LM_DT^T00050LM_BY^T00010IPL_STS^T00120ICD^T04096HOVER_ICD"
 S @DATA@(II)=@DATA@(II)_"^T00160PROVIDER_TEXT^T00360PROVIDER_NARRATIVE^T04096LAST_GOAL"
 S @DATA@(II)=@DATA@(II)_"^T04096LAST_CARE_PLAN^T04096LAST_VISIT_INSTRUCTION"
 S @DATA@(II)=@DATA@(II)_"^I00010HIDE_PRV^T00035PRV^D00015DEFINITIVE_EDD^T00001POV"
 S @DATA@(II)=@DATA@(II)_"^T00001INPATIENT_POV^T00001PRIMARY^T00001PATIENT_TYPE^T00030ONSET_DT"
 S @DATA@(II)=@DATA@(II)_"^T00050LOCATION^T00015EXTERNAL_PROB^T00015INTERNAL_PROB"
 S @DATA@(II)=@DATA@(II)_"^T00015POV_IEN^T00250ASTHMA^T00050EPISODICITY^T00025EPISODICITY_SMD^T00050INJURY_REVISIT"
 S @DATA@(II)=@DATA@(II)_"^T00050INJURY_PLACE^D00030INJURY_DT^T00050INJ_ASSOC^I00020INJ_CAUSE_IEN"
 S @DATA@(II)=@DATA@(II)_"^T00020INJ_CAUSE_CODE^T00200INJ_CAUSE_DESC^T00001INJ_CHECKED^T04096QUALIFIERS^T00001ABNORMAL"
 S @DATA@(II)=@DATA@(II)_"^T00001PROMPT_LATERALITY^T00040INT_LATERALITY^T00040EXT_LATERALITY"_$C(30)
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNSPRB D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Verify PRBIEN and VIEN (at minimum) were entered
 I $G(PRBIEN)="" S BMXSEC="Required IPL PRBIEN is missing" G XPROB
 I $G(VIEN)="" S BMXSEC="Required visit IEN is missing" G XPROB
 S PIPIEN=$G(PIPIEN) S:PIPIEN=0 PIPIEN=""
 ;
 ;Get the DFN
 S DFN=$$GET1^DIQ(9000011,PRBIEN_",",.02,"I") I DFN="" S BMXSEC="Invalid DFN value in IPL entry" G XPROB
 ;
 ;If PIPIEN, verify it matches to PRBIEN
 I $G(PIPIEN)]"",'$D(^BJPNPL("F",DFN,PRBIEN,PIPIEN)) S BMXSEC="The PIPIEN does not point to the IPL entry" G XPROB
 ;
 ;Get the visit date or default to DT if visit not passed in
 I $G(VIEN)]"" S VDT=$P($$GET1^DIQ(9000010,VIEN_",",".01","I"),".")
 S:$G(VDT)="" VDT=DT
 ;
 ;Call EHR API and format results into usable data
 D COMP^BJPNUTIL(DFN,UID,VIEN,PRBIEN)
 S TMP=$NA(^TMP("BJPNIPL",UID))  ;Define compiled data reference
 ;
 ;Get IPL and PIP information
 ;
 ;Skip deletes
 S DEL=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") I DEL]"" D  S BMXSEC="The input IPL problem has been deleted" G XPROB  ;IPL Delete
 . ;
 . ;If deleted on IPL, need to make sure it is deleted in PIP
 . NEW BJPNUPD,ERROR
 . S BJPNUPD(90680.01,PIPIEN_",",2.01)=$$GET1^DIQ(9000011,PRBIEN_",",2.01,"I") ;Deleted By
 . S BJPNUPD(90680.01,PIPIEN_",",2.02)=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") ;Del Dt/Tm
 . S BJPNUPD(90680.01,PIPIEN_",",2.03)=$$GET1^DIQ(9000011,PRBIEN_",",2.03,"I") ;Del Rsn
 . S BJPNUPD(90680.01,PIPIEN_",",2.04)=$$GET1^DIQ(9000011,PRBIEN_",",2.04,"I") ;Del Other
 . D FILE^DIE("","BJPNUPD","ERROR")
 S DEL=$$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I") I DEL]"" S PIPIEN="",BMXSEC="The input PIP problem has been deleted" G XPROB
 ;
 ;Retrieve the entry from the API results
 S BGO=$O(@TMP@("P",PRBIEN,"")) I BGO="" G XPROB   ;Quit if no IPL entry
 S API=$G(@TMP@("P",PRBIEN,BGO)) I API="" G XPROB  ;Quit if no problem string
 ;
 ;SNOMED DescId and ConcId
 S DESCID=$P(API,U,4)
 S:DESCID="" DESCID=$$GET1^DIQ(9000011,PRBIEN_",",80002,"I") I DESCID="" G XPROB  ;Quit if no Desc ID
 S DESCTM=$P($$DESC^BSTSAPI(DESCID_"^^1"),U,2) I DESCTM="" G XPROB  ;Quit if no Description Term
 S CONCID=$P(API,U,3)
 S:CONCID="" CONCID=$$GET1^DIQ(9000011,PRBIEN_",",80001,"I") I CONCID="" G XPROB  ;Quit if no Concept ID
 ;
 ;Onset Date
 S ONSET=$$GET1^DIQ(9000011,PRBIEN_",",.13,"I")
 I ONSET]"" D
 . I $E(ONSET,4,7)="0000" S ONSET="20"_$E(ONSET,2,3) Q  ;Year only
 . I $E(ONSET,6,7)="00" S ONSET=+$E(ONSET,4,5)_"/20"_$E(ONSET,2,3) Q  ;Month/Year
 . S ONSET=$$FMTE^BJPNPRL(ONSET)
 ;
 ;Location
 S LOC=$$GET1^DIQ(9000011,PRBIEN_",",.06,"I")
 ;
 ;External problem
 S EPROB=$P(API,U,5)
 ;
 ;Internal problem
 S IPROB=$$GET1^DIQ(9000011,PRBIEN_",",.07,"I")
 ;
 ;PIP Priority
 I +PIPIEN S XPRI=$$GET1^DIQ(90680.01,PIPIEN_",",.06,"E")
 E  S XPRI=""
 ;
 ;IPL Priority
 S IPRIO="" I PRBIEN]"" D
 . NEW PRIEN
 . S PRIEN=$O(^BGOPROB("B",PRBIEN,"")) Q:PRIEN=""
 . S IPRIO=$$GET1^DIQ(90362.22,PRIEN_",",.02,"I")
 . S:IPRIO="" IPRIO=0
 ;
 ;Status
 I +PIPIEN S XSTS=$$GET1^DIQ(90680.01,PIPIEN_",",.08,"E")
 E  S XSTS=""
 ;
 ;Scope
 I +PIPIEN S XSCO=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"E")
 E  S XSCO=""
 ;
 ;Class
 S CLASS=$$GET1^DIQ(9000011,PRBIEN_",",.04,"I")
 ;
 ;Last Modified Date
 S XLMDT=$$FMTE^BJPNPRL($$GET1^DIQ(9000011,PRBIEN_",",.03,"I"))
 ;
 ;Last Modified By
 S XLMBY=$$GET1^DIQ(9000011,PRBIEN_",",.14,"E")
 ;
 ;IPL Status - Convert manually lower case can be displayed
 S IPLSTS=$P(API,U,6)
 S:IPLSTS="" IPLSTS=$$GET1^DIQ(9000011,PRBIEN_",",.12,"E")
 S IPLSTS=$S(IPLSTS="CHRONIC":"Chronic",IPLSTS="INACTIVE":"Inactive",IPLSTS="D":"DELETED",IPLSTS="SUB-ACUTE":"Sub-Acute",IPLSTS="EPISODIC":"Episodic",IPLSTS="SOCIAL":"Social",IPLSTS="ROUTINE/ADMIN":"Admin",1:"")
 ;
 ;ICD Information - Pull primary and additional ICD values
 S ICD=$P(API,U,9)
 S ADDICD=$P(API,U,13)
 I ADDICD]"" F ICDCNT=1:1:$L(ADDICD,"|") S ADICD=$P(ADDICD,"|",ICDCNT) I ADICD]"" S ICD=ICD_$S(ICD]"":"|",1:"")_ADICD
 ;
 ;ICD Hover field - Not used for problem add/edit
 S HICD=""
 ;
 ;Provider Text
 S PNARR=$P(API,U,8)
 S PTEXT=$P(PNARR," | ",2)
 ;
 ;Get latest Goal note
 S GGO=$O(@TMP@("G",PRBIEN,""))
 S GOAL="" I GGO]"" S GOAL=$P($G(@TMP@("G",PRBIEN,GGO,1)),U,2)
 ;
 ;Get latest Care Plan note
 S CGO=$O(@TMP@("C",PRBIEN,""))
 S CARE="" I CGO]"" S CARE=$P($G(@TMP@("C",PRBIEN,CGO,1)),U,2)
 ;
 ;Get latest V Visit Instruction
 S VGO=$O(@TMP@("I",PRBIEN,""))
 S INST="" I VGO]"" S INST=$P($G(@TMP@("I",PRBIEN,VGO,1)),U,2)
 ;
 ;Visit POV
 S (IPOV,POV,ITYPE)="" I VIEN]"" D
 . S ITYPE=$$GET1^DIQ(9000010,VIEN_",",.07,"I") Q:ITYPE=""
 . S ITYPE=$S(ITYPE="H":"H",1:"A")
 . I $O(^AUPNPROB(PRBIEN,14,"B",VIEN,"")) S POV="Y"
 . I $O(^AUPNPROB(PRBIEN,15,"B",VIEN,"")) S IPOV="Y"
 ;
 ;Get Primary/Secondary value
 S PRIMARY=$P(API,U,30)
 ;
 ;Get V POV IEN
 S PVIEN=$P(API,U,31)
 ;
 ;Get the Episodicity
 S EP=$P(API,U,32)
 S EPSMD=$$VALTERM^BSTSAPI("EVAR",EP_"^^1")
 S EPSMD=$G(EVAR(1,"CON"))
 ;
 ;Get the injury revisit
 S INJREV=$P(API,U,33)
 ;
 ;Get the injury place
 S INJPLC=$P(API,U,34)
 ;
 ;Get the injury date
 S INJDT=$P(API,U,35)
 ;
 S INJASS=$P(API,U,38)
 S INJCIEN="" I PVIEN]"" S INJCIEN=$$GET1^DIQ(9000010.07,PVIEN_",",.09,"I")
 S INJCCOD=$P(API,U,37)
 S INJCDSC=$P(API,U,36)
 S INJCHK="" I (INJPLC]"")!(INJCCOD]"")!(INJCDSC]"")!(INJASS]"")!(INJCIEN]"")!(INJDT]"") S INJCHK="Y"
 ;
 ;Definitive EDD
 I +PIPIEN S DEDD=$$FMTE^BJPNPRL($$GET1^DIQ(90680.01,PIPIEN_",",.09,"I"))
 E  S DEDD=""
 ;
 ;PRV fields
 S (PRV,XPRV)=""
 S PRV=$$PPRV^BJPNPKL(VIEN)
 S:PRV]"" XPRV=$$GET1^DIQ(200,PRV_",",.01,"E")
 ;
 ;Qualifiers - Loop through entries and assemble
 S QUAL="",BGO="" F  S BGO=$O(@TMP@("Q",PRBIEN,BGO)) Q:BGO=""  D
 . ;
 . NEW STR,N
 . S N=$G(@TMP@("Q",PRBIEN,BGO,0))
 . ;Return: TYPE (C/S) [1] 29 IEN [2] 29 CONCID [3] 29 TERM [4] 29 LMDT [5] 29 LMBY [6]
 . S STR=$P(N,U,2)_$C(29)_$P(N,U,3)_$C(29)_$P(N,U,4)_$C(29)_$P(N,U,5)_$C(29)_$C(29)
 . ;
 . ;If IEN is populated and severity - get last modified by
 . I +$P(N,U,3),$P(N,U,2)="S" D
 .. NEW DA,IENS,BY,LMDT,LMBY
 .. S DA(1)=PRBIEN,DA=$P(N,U,3),IENS=$$IENS^DILF(.DA)
 .. S LMDT=$$GET1^DIQ(9000011.13,IENS,.05,"I")
 .. S LMBY=$$GET1^DIQ(9000011.13,IENS,.04,"I")
 .. I LMDT="" D
 ... S LMDT=$$GET1^DIQ(9000011.13,IENS,.03,"I")
 ... S LMBY=$$GET1^DIQ(9000011.13,IENS,.02,"I")
 .. S $P(STR,$C(29),5)=LMBY
 .. S $P(STR,$C(29),6)=LMDT
 . ;
 . S QUAL=QUAL_$S(QUAL="":"",1:$C(28))_STR
 ;
 ;Asthma
 S ASTHMA="",BGO=$O(@TMP@("A",PRBIEN,"")) I BGO]"" D
 . S ASTHMA=$TR($G(@TMP@("A",PRBIEN,BGO,0)),"^",$C(29))
 ;
 ;Abnormal Findings
 S ABN=$P(API,U,39)
 ;
 ;BJPN*2.0*7;Added laterality
 S PLAT=$P(API,U,19),PLAT=$S(PLAT=1:"Y",1:"N")  ;Prompt for laterality
 S ILAT=$P(API,U,20)
 S ELAT="" I $TR(ILAT,"|")]"" S ELAT=$$CVPARM^BSTSMAP1("LAT",$P(ILAT,"|"))_"|"_$$CVPARM^BSTSMAP1("LAT",$P(ILAT,"|",2))
 ;
 ;Set up entry
 S II=II+1,@DATA@(II)=PIPIEN_U_PRBIEN_U_XPRI_U_XSTS_U_XSCO_U_DESCID_U_DESCTM_U_CONCID_U_IPRIO_U_CLASS_U_XLMDT_U_XLMBY_U_IPLSTS
 S @DATA@(II)=@DATA@(II)_U_ICD_U_HICD_U_PTEXT_U_PNARR_U_GOAL_U_CARE_U_INST_U_PRV_U_XPRV
 S @DATA@(II)=@DATA@(II)_U_DEDD_U_POV_U_IPOV_U_PRIMARY_U_ITYPE_U_ONSET_U_LOC_U_EPROB
 S @DATA@(II)=@DATA@(II)_U_IPROB_U_PVIEN_U_ASTHMA_U_EP_U_EPSMD_U_INJREV_U_INJPLC_U_INJDT
 S @DATA@(II)=@DATA@(II)_U_INJASS_U_INJCIEN_U_INJCCOD_U_INJCDSC_U_INJCHK_U_QUAL_U_ABN_U_PLAT_U_ILAT_U_ELAT
 S @DATA@(II)=@DATA@(II)_$C(30)
 ;
XPROB S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SUBSET(DATA,SUBSET) ;EP - BJPN GET SUBSET
 ;
 ;This RPC accepts a SNOMED subset value and returns the entries in the subset
 ;
 ;Input parameter:
 ;  SUBSET - The SNOMED subset to look up and return a list of members
 ;
 NEW CNT,UID,II,RET,OUT
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNSPRB",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNSPRB D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(0)="T00300TEXT^T00025DESC_ID^T00025CONC_ID"_$C(30)
 ;
 ;Input checks
 I $G(SUBSET)="" S BMXSEC="Missing Subset" G XSUBSET
 ;
 ;Call EHR API to retrieve the list of information
 S OUT="RET"
 ;
 ;Default to local search
 S $P(SUBSET,U,3)=1
 ;
 D SUBLST^BSTSAPI(OUT,SUBSET)
 ;
 ;Loop through results and output
 S CNT="" F  S CNT=$O(RET(CNT)) Q:CNT=""  D
 . NEW N
 . S N=$G(RET(CNT))
 . S II=II+1,@DATA@(II)=$P(N,U,3)_U_$P(N,U,2)_U_$P(N,U)_$C(30)
 ;
XSUBSET S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
