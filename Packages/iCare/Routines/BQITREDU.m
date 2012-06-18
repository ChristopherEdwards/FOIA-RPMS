BQITREDU ;PRXM/HC/ALA-Find Education ; 21 May 2007  3:15 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
FED(DATE,BQDFN,CODE) ;EP - Find education
 ; Input
 ;    DATE  - Date to search from
 ;    BQDFN - Patient internal entry number
 ;    CODE  - Education code to search for
 ;
 ;Build the topic data
 NEW TREF,RES,IEN,TIEN,VIEN,VSDTM
 S TREF=$NA(^TMP("BQITOPIC",UID)),RES=0_U_"No PED"
 S DATE=$G(DATE,"")
 K @TREF
 D EDTP^BQITRUTL(TREF,CODE)
 S IEN=""
 F  S IEN=$O(^AUPNVPED("AC",BQDFN,IEN)) Q:IEN=""  D
 . S TIEN=$P($G(^AUPNVPED(IEN,0)),U,1) I TIEN="" Q
 . I '$D(@TREF@(TIEN)) Q
 . S VIEN=$P(^AUPNVPED(IEN,0),U,3) I VIEN="" Q
 . S VSDTM=$P($G(^AUPNVSIT(VIEN,0)),U,1)\1 I VSDTM=0 Q
 . I DATE'="",VSDTM<DATE Q
 . S RES=1_U_VSDTM_U_U_VIEN_U_IEN
 K @TREF
 Q RES
 ;
SMOK(BQDFN) ; EP - Find smoking for a patient
 ; Input
 ;   BQDFN - Patient internal entry number
 ;
 NEW BQIARRAY,BA,LBA,NP,VIEN,VDATE,BQDEF,BQEXEC,BQGLB,BQIRY,ENDT
 NEW EXDT,PLFLG,RESULT,TMREF,TOB,TPIEN,MTYP,DNC,BQTDATE,QFL,TAX
 NEW TCC,VISIT
 S UID=$G(UID,$J),RESULT=""
 S TMREF=$NA(^TMP("BQITOBAC",UID)) K @TMREF
 ; if patient current tobacco user
 S TOB=$$PAT^BQITD12("Tobacco Users (Smokers)","BQIARRAY",BQDFN)
 I TOB D
 . S BA="BQIARRAY" F  S BA=$Q(@BA) Q:BA=""  S LBA=BA
 . S NP=$L(LBA,",")
 . I $F(LBA,",""P"",") S TPIEN=$P($P(LBA,",",NP),")",1) S BQTDATE=$$PROB^BQIUL1(TPIEN)
 . I $F(LBA,",""V"",") S VIEN=$P($P(LBA,",",NP-1),")",1) S BQTDATE=$P($G(^AUPNVSIT(VIEN,0)),U,1)\1
 . M @TMREF=BQIARRAY
 . S RESULT="Patient tagged as current tobacco user"
 ;
 I 'TOB D
 . ; Check for new CPT taxonomy
 . S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 . D BLD^BQITUTL("BGP TOBACCO USER CPTS",TREF)
 . S IEN=""
 . F  S IEN=$O(^AUPNVCPT("AC",BQDFN,IEN),-1) Q:IEN=""  D
 .. S TIEN=$$GET1^DIQ(9000010.18,IEN,.01,"I") I TIEN="" Q
 .. I '$D(@TREF@(TIEN)) Q
 .. S VIEN=$$GET1^DIQ(9000010.18,IEN,.03,"I") Q:VIEN=""
 .. I $$GET1^DIQ(9000010,VIEN,.11,"I")=1 Q
 .. S VDATE=$$GET1^DIQ(9000010,VIEN,.01,"I")\1 Q:'VDATE
 .. S @TMREF@(VDATE,IEN)=VIEN,TOB=1,RESULT="Patient had a CPT from BGP TOBACCO USER CPTS"
 ;
 ; If not current tobacco user, quit
 I 'TOB Q 0_"^Patient not a current tobacco user"
 ;I $D(@TMREF)<1 Q 0
 ;
 I $G(BQTDATE)="" S BQTDATE=$O(@TMREF@(""),-1)
 ;
 ; if current tobacco user, check for tobacco intervention
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 D BLD^BQITUTL("BGP TOBACCO INTERVENTION CPTS",TREF)
 S IEN="",QFL=0
 F  S IEN=$O(^AUPNVCPT("AC",BQDFN,IEN),-1) Q:IEN=""  D  Q:QFL
 . S TIEN=$$GET1^DIQ(9000010.18,IEN,.01,"I") I TIEN="" Q
 . I '$D(@TREF@(TIEN)) Q
 . S VIEN=$$GET1^DIQ(9000010.18,IEN,.03,"I") Q:VIEN=""
 . I $$GET1^DIQ(9000010,VIEN,.11,"I")=1 Q
 . S VDATE=$$GET1^DIQ(9000010,VIEN,.01,"I")\1 Q:'VDATE
 . I VDATE'>BQTDATE Q
 . S QFL=1
 I QFL Q 0_"^Patient had tobacco intervention CPT from BGP TOBACCO INTERVENTION CPTS"
 ;
 ; If intervention has been documented after most recent tobacco use
 ;
 ;Patient Education Code CVD.ED.3
 I $$FED(BQTDATE,BQDFN,"TO-") Q 0_"^Patient met education code 'TO-'"
 I $$FED(BQTDATE,BQDFN,"-TO") Q 0_"^Patient met education code '-TO'"
 I $$FED(BQTDATE,BQDFN,"-SHS") Q 0_"^Patient met education code '-SHS'"
 I $$FED(BQTDATE,BQDFN,"305.1") Q 0_"^Patient met education dx 305.1"
 I $$FED(BQTDATE,BQDFN,"649.00") Q 0_"^Patient met education dx 649.00"
 I $$FED(BQTDATE,BQDFN,"649.01") Q 0_"^Patient met education dx 649.01"
 I $$FED(BQTDATE,BQDFN,"649.02") Q 0_"^Patient met education dx 649.02"
 I $$FED(BQTDATE,BQDFN,"649.03") Q 0_"^Patient met education dx 649.03"
 I $$FED(BQTDATE,BQDFN,"649.04") Q 0_"^Patient met education dx 649.04"
 ;
 ;Dental Code
 S DNC=$$FIND1^DIC(9999999.31,"","X",1320,"B","","ERROR")
 S IEN="",QFL=0
 F  S IEN=$O(^AUPNVDEN("B",DNC,IEN)) Q:IEN=""  D  Q:QFL
 . I $$GET1^DIQ(9000010.05,IEN,.02,"I")'=BQDFN Q
 . S VISIT=$$GET1^DIQ(9000010.05,IEN,.03,"I") Q:VISIT=""
 . I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 . S VDATE=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:'VDATE
 . I VDATE<BQTDATE Q
 . S QFL=1
 I QFL Q 0_"^Patient met Dental Code 1320"
 ;
 ;Clinic Code 94
 S TCC=$$FIND1^DIC(40.7,"","X",94,"C","","ERROR")
 S VISIT="",QFL=0
 F  S VISIT=$O(^AUPNVSIT("AC",BQDFN,VISIT)) Q:VISIT=""  D  Q:QFL
 . I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 . S VDATE=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:'VDATE
 . I VDATE<BQTDATE Q
 . I $$GET1^DIQ(9000010,VISIT,.08,"I")'=TCC Q
 . S QFL=1
 I QFL Q 0_"^Patient had a visit in TOBACCO CESSATION CLINIC"
 ;
 ;Medication with Name containing
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="BGP CMS SMOKING CESSATION MEDS","BGP CMS SMOKING CESSATION NDC" D BLD^BQITUTL("BGP TOBACCO USER CPTS",TREF)
 F MTYP="NICOTINE PATCH","NICOTINE POLACRILEX","NICOTINE INHALER","NICOTINE NASAL SPRAY" D MED^BQITRUTL(TREF,MTYP)
 S TIEN="",QFL=0
 F  S TIEN=$O(@TREF@(TIEN)) Q:TIEN=""  D  Q:QFL
 . S IEN=""
 . F  S IEN=$O(^AUPNVMED("B",TIEN,IEN)) Q:IEN=""  D  Q:QFL
 .. I $$GET1^DIQ(9000010.14,IEN,.02,"I")'=BQDFN Q
 .. S VISIT=$$GET1^DIQ(9000010.14,IEN,.03,"I") Q:VISIT=""
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. S VDATE=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:'VDATE
 .. I VDATE<BQTDATE Q
 .. S QFL=1
 I QFL Q 0_"^Patient had smoking cessation medication"
 ;
 Q 1_"^Patient current smoker but no smoking cessation intervention"
