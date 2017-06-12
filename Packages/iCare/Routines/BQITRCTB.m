BQITRCTB ;GDHD/HS/ALA-CVD Tobacco ; 16 Jun 2016  3:16 PM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
ASSES(BQDFN) ;EP - Assessed Tobacco
 NEW MEET,DESC,X,TAX,TREF
 S MEET=1,DESC="No Tobacco Assessment in past year"
 S X=$$TOB^BQIRGASU(BQDFN)
 I X D
 . S $P(X,U,2)=$$DATE^BQIUL1($P(X,U,2))
 . S MEET=0,DESC="Last Tobacco HF was "_$$FMTMDY^BQIUL1($P(X,U,2))
 I X="" D
 . ;Patient Education Code
 . S BQTDATE=$$DATE^BQIUL1("T-12M"),RESULT=1
 . I $$FED^BQITREDU(BQTDATE,BQDFN,"TO-") S MEET=0,DESC="Patient met education code 'TO-'"
 . I $$FED^BQITREDU(BQTDATE,BQDFN,"-TO") S MEET=0,DESC="Patient met education code '-TO'"
 . I $$FED^BQITREDU(BQTDATE,BQDFN,"-SHS") S MEET=0,DESC="Patient met education code '-SHS'"
 . S SN=$O(^BGPSNOMM("B","TOBACCO SCREEN PATIENT ED",0))
 . I SN'="" D
 .. S CD=0 F  S CD=$O(^BGPSNOMM(SN,11,CD)) Q:'CD  D
 ... S SNOM=^BGPSNOMM(SN,11,CD,0)
 ... I $$FED^BQITREDU(BQTDATE,BQDFN,SNOM) S MEET=0,DESC="Patient met SNOMED subset TOBACCO SCREEN PATIENT ED" Q
 . ;
 . S TAX="BGP TOBACCO DXS",TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 . D BLD^BQITUTL(TAX,.TREF)
 . S N="" F  S N=$O(@TREF@(N)) Q:N=""  S DXC=$P(@TREF@(N),"^",1) D
 .. I $$FED^BQITREDU(BQTDATE,BQDFN,DXC) S MEET=0,DESC="Patient met taxonomy BGP TOBACCO DXS" Q
 . ;
 . S TAX="BGP TOBACCO SCREEN CPTS",TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 . D BLD^BQITUTL(TAX,.TREF)
 . S N="" F  S N=$O(@TREF@(N)) Q:N=""  S CPT=$P(@TREF@(N),"^",1) D
 .. I $$FED^BQITREDU(BQTDATE,BQDFN,CPT) S MEET=0,DESC="Patient met education BGP TOBACCO SCREEN CPTS" Q
 . ;
 . S N="" F  S N=$O(@TREF@(N)) Q:N=""  S CPT=$P(@TREF@(N),"^",1) D
 .. I $$TAX^BQITRUTL("T-12M","",1,BQDFN,9000010.18,"",,.TREF,"","") S MEET=0,DESC="Patient met CPT BGP TOBACCO SCREEN CPTS" Q
 ;
 Q MEET_U_DESC
 ;
EDUC ;EP - Education
 S MEET=1,DESC="No Tobacco Intervention"
 I $$FED^BQITREDU(BQTDATE,BQDFN,"TO-") S MEET=0,DESC="Patient met education code 'TO-'"
 I $$FED^BQITREDU(BQTDATE,BQDFN,"-TO") S MEET=0,DESC="Patient met education code '-TO'"
 I $$FED^BQITREDU(BQTDATE,BQDFN,"-SHS") S MEET=0,DESC="Patient met education code '-SHS'"
 S SN=$O(^BGPSNOMM("B","TOBACCO SCREEN PATIENT ED",0))
 I SN'="" D
 . S CD=0 F  S CD=$O(^BGPSNOMM(SN,11,CD)) Q:'CD  D
 .. S SNOM=^BGPSNOMM(SN,11,CD,0)
 .. I $$FED^BQITREDU(BQTDATE,BQDFN,SNOM) S MEET=0,DESC="Patient met SNOMED subset TOBACCO SCREEN PATIENT ED" Q
 ;
 S TAX="BGP TOBACCO DXS",TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 D BLD^BQITUTL(TAX,.TREF)
 S N="" F  S N=$O(@TREF@(N)) Q:N=""  S DXC=$P(@TREF@(N),"^",1) D
 . I $$FED^BQITREDU(BQTDATE,BQDFN,DXC) S MEET=0,DESC="Patient met taxonomy BGP TOBACCO DXS" Q
 ;
 S TAX="BGP TOBACCO SCREEN CPTS",TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 D BLD^BQITUTL(TAX,.TREF)
 S N="" F  S N=$O(@TREF@(N)) Q:N=""  S CPT=$P(@TREF@(N),"^",1) D
 . I $$FED^BQITREDU(BQTDATE,BQDFN,CPT) S MEET=0,DESC="Patient met education BGP TOBACCO SCREEN CPTS" Q
 Q
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
 D EDUC I 'MEET Q "0^"_DESC
 ;Dental Code
 S DNC=$$FIND1^DIC(9999999.31,"","X",1320,"B","","ERROR")
 S QFL=0
 I DNC'="" D
 . S IEN=""
 . F  S IEN=$O(^AUPNVDEN("B",DNC,IEN)) Q:IEN=""  D  Q:QFL
 .. I $$GET1^DIQ(9000010.05,IEN,.02,"I")'=BQDFN Q
 .. S VISIT=$$GET1^DIQ(9000010.05,IEN,.03,"I") Q:VISIT=""
 .. I $$GET1^DIQ(9000010,VISIT,.11,"I")=1 Q
 .. S VDATE=$$GET1^DIQ(9000010,VISIT,.01,"I")\1 Q:'VDATE
 .. I VDATE<BQTDATE Q
 .. S QFL=1
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
