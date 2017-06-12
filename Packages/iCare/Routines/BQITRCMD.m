BQITRCMD ;GDHS/HS/ALA-CVD Medications ; 16 Jun 2016  7:52 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
ASA(BQDFN) ; EP - No ASA/Antiplatelet
 ; If NOT on ASA OR Warfarin OR other Anti Platelet Medication or
 ; NOT contraindicated
 NEW CT,X,VISIT,VSDTM,MEET,DESC,TIEN,T2,PRGM,QFL,RESULT,IEN
 NEW ENDT,C,BQGPRG,BGPDXBD,BGPDXED,TAX,TREF
 S MEET=0,DESC=""
 D
 . ; If not on ASA Medications
 . S X=$$TAX^BQITRUTL("","DM AUDIT ASPIRIN DRUGS",1,BQDFN,9000010.14)
 . ; if returns a found medication, check if it is an active medication
 . I $P(X,U,1)=1 D
 .. I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 .. S $P(X,U,1)=0
 . I $P(X,U,1)=1 D  Q
 .. S MEET=0,DESC=DESC_"On ASA Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 . S MEET=1,DESC=DESC_"Not on ASA Meds; "
 . ; If not on Warfarin Medications
 . S X=$$TAX^BQITRUTL("","BGP CMS WARFARIN MEDS",1,BQDFN,9000010.14)
 . ; if returns a found medication, check if it is an active medication
 . I $P(X,U,1)=1 D
 .. I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 .. S $P(X,U,1)=0
 . I $P(X,U,1)=1 D  Q
 .. S MEET=0,DESC=DESC_"On Warfarin Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 . S MEET=1,DESC=DESC_"Not on Warfarin Meds; "
 . ; If not on other Anti Platelet Medications
 . S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 . F TAX="BGP CMS ANTI-PLATELET CLASS","BGP ANTI-PLATELET DRUGS" D BLD^BQITUTL(TAX,TREF)
 . S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 . ; if returns a found medication, check if it is an active medication
 . I $P(X,U,1)=1 D
 .. I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 .. S $P(X,U,1)=0
 . I $P(X,U,1)=1 S MEET=0,DESC=DESC_"On Anti-Platelet Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 . I $P(X,U,1)=0 S MEET=1,DESC=DESC_"Not on Anti-Platelet Meds"
 . K @TREF
 D
 . ; If ASA/Warfarin/Anti-Platelet Medication contraindication
 . S X=$$ASA^BQITRCON(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has a contraindication: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 . ; Check for allergy
 . S X=$$ASA^BQITRALG(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has an allergy: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 Q MEET_U_DESC
 ;
RASA(BQDFN) ;EP - At Risk
 ; If NOT on ASA OR Warfarin OR other Anti Platelet Medication or
 ; NOT contraindicated
 NEW CT,X,VISIT,VSDTM,MEET,DESC,TIEN,T2,PRGM,QFL,RESULT,IEN
 NEW ENDT,C,BQGPRG,BGPDXBD,BGPDXED,TAX,TREF,AGE,SEX
 S MEET=0,DESC=""
 S AGE=$$AGE^BQIAGE(BQDFN),SEX=$P($G(^DPT(BQDFN,0)),U,2)
 I SEX="M",AGE<50 Q MEET_U_DESC
 I SEX="F",AGE<60 Q MEET_U_DESC
 D
 . ; If not on ASA Medications
 . S X=$$TAX^BQITRUTL("","DM AUDIT ASPIRIN DRUGS",1,BQDFN,9000010.14)
 . ; if returns a found medication, check if it is an active medication
 . I $P(X,U,1)=1 D
 .. I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 .. S $P(X,U,1)=0
 . I $P(X,U,1)=1 D  Q
 .. S MEET=0,DESC=DESC_"On ASA Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 . S MEET=1,DESC=DESC_"Not on ASA Meds; "
 . ; If not on Warfarin Medications
 . S X=$$TAX^BQITRUTL("","BGP CMS WARFARIN MEDS",1,BQDFN,9000010.14)
 . ; if returns a found medication, check if it is an active medication
 . I $P(X,U,1)=1 D
 .. I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 .. S $P(X,U,1)=0
 . I $P(X,U,1)=1 D  Q
 .. S MEET=0,DESC=DESC_"On Warfarin Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 . S MEET=1,DESC=DESC_"Not on Warfarin Meds; "
 . ; If not on other Anti Platelet Medications
 . S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 . F TAX="BGP CMS ANTI-PLATELET CLASS","BGP ANTI-PLATELET DRUGS" D BLD^BQITUTL(TAX,TREF)
 . S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 . ; if returns a found medication, check if it is an active medication
 . I $P(X,U,1)=1 D
 .. I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 .. S $P(X,U,1)=0
 . I $P(X,U,1)=1 S MEET=0,DESC=DESC_"On Anti-Platelet Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 . I $P(X,U,1)=0 S MEET=1,DESC=DESC_"Not on Anti-Platelet Meds"
 . K @TREF
 D
 . ; If ASA/Warfarin/Anti-Platelet Medication contraindication
 . S X=$$ASA^BQITRCON(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has a contraindication: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 . ; Check for allergy
 . S X=$$ASA^BQITRALG(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has an allergy: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 Q MEET_U_DESC
 ;
STAT(BQDFN) ; EP - No Statin
 NEW CT,X,VISIT,VSDTM,MEET,DESC,TIEN,T2,PRGM,QFL,RESULT,TREF
 NEW GREF,IEN,ENDT,C,BQGPRG,BGPDXBD,BGPDXED,TAX
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="BGP HEDIS STATIN MEDS","BGP HEDIS STATIN NDC" D BLD^BQITUTL(TAX,TREF)
 S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 ; if returns a found medication, check if it is an active medication
 I $P(X,U,1)=1 D
 . I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 . S $P(X,U,1)=0
 I $P(X,U,1)=1 S MEET=0,DESC=DESC_"On Statin Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 I $P(X,U,1)=0 S MEET=1,DESC=DESC_"Not on Statin Meds"
 D
 . ; If Statin Medication is contraindicated
 . S X=$$STAT^BQITRCON(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has a contraindication: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 . ; Check for allergy
 . S X=$$STAT^BQITRALG(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has an allergy: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 K @TREF
 Q MEET_U_DESC
