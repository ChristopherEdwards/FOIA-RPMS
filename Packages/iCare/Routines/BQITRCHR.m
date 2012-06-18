BQITRCHR ;VNGT/HS/ALA-CVD Highest Risk Treatment Prompts ; 02 Sep 2008  11:52 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EKGE(BQDFN) ;EP  CVD.TP-23 No EKG Ever
 ; If no documented EKG ever
 NEW MEET,DESC,RETURN
 S MEET=0,DESC=""
 S RETURN=$$EKG^BQITRUT1(BQDFN,"")
 I $P(RETURN,U,1)=1 S MEET=1,DESC="Has not ever had an EKG procedure"
 I $P(RETURN,U,1)=0 S MEET=0,DESC="Has had an EKG procedure"
 Q MEET_U_DESC
 ;
EKG2(BQDFN) ;EP  CVD.TP-26 No Recent EKG
 ; If no EKG documented in past 2 years
 NEW MEET,DESC,RETURN
 S MEET=0,DESC=""
 S RETURN=$$EKG^BQITRUT1(BQDFN,"T-24M")
 I $P(RETURN,U,1)=0 S MEET=0,DESC="Has had EKG procedure in past 2 years"
 I $P(RETURN,U,1)=1 D
 . S MEET=1,DESC="Has not had an EKG procedure in past 2 years"
 . I $D(^BQIPAT(BQDFN,50,23)) S MEET=0
 Q MEET_U_DESC
 ;
ASA(BQDFN) ;EP  CV.TP-15 No ASA/Antiplatelet
 ; If age >30 AND NOT on ASA or Warfarin or other AntiPlatelet
 ; Medication or NOT contraindicated
 NEW CT,X,VISIT,VSDTM,MEET,DESC,TIEN,T2,PRGM,QFL,RESULT,TREF,GREF,IEN,ENDT,C
 NEW BQGPRG,BGPDXBD,BGPDXED,AGE
 S MEET=0,DESC=""
 S AGE=$$AGE^BQIAGE(BQDFN),DESC="Patient's age is "_AGE_" and "
 I AGE'>30 S DESC="Patient's age is "_AGE Q MEET_U_DESC
 D
 . S X=$$TAX^BQITRUTL("","DM AUDIT ASPIRIN DRUGS",1,BQDFN,9000010.14)
 . ; if returns a found medication, check if it is an active medication
 . I $P(X,U,1)=1 D
 .. I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 .. S $P(X,U,1)=0
 . I $P(X,U,1)=1 S MEET=0,DESC=DESC_"On ASA Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")" Q
 . I $P(X,U,1)=0 S MEET=1,DESC=DESC_"Not on ASA Meds; "
 . S X=$$TAX^BQITRUTL("","BGP CMS WARFARIN MEDS",1,BQDFN,9000010.14)
 . ; if returns a found medication, check if it is an active medication
 . I $P(X,U,1)=1 D
 .. I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 .. S $P(X,U,1)=0
 . I $P(X,U,1)=1 S MEET=0,DESC=DESC_"On Warfarin Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")" Q
 . I $P(X,U,1)=0 S MEET=1,DESC=DESC_"Not on Warfarin Meds; "
 . NEW TAX,TREF
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
 . S X=$$ASA^BQITRCON(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has a contraindication: "_$P(X,U,2) Q
 . I $P(X,U,1)=0 S DESC=DESC_" and not contraindicated"
 . S MEET=$S(MEET:0,1:1)
 . S X=$$ASA^BQITRALG(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has an allergy: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 Q MEET_U_DESC
 ;
ACEI(BQDFN) ;EP  CVD.TP-17 No ACEI or ARB
 ; If NOT on ACEI OR ARB, then check the patient for special conditions
 NEW CT,X,VISIT,VSDTM,MEET,DESC,TIEN,T2,PRGM,QFL,RESULT,TREF,GREF
 NEW IEN,ENDT,C,BQGPRG,BGPDXBD,BGPDXED,TAX,TREF
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="BGP CMS ACEI MEDS CLASS","BGP HEDIS ACEI MEDS","BGP HEDIS ACEI NDC" D BLD^BQITUTL(TAX,TREF)
 S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 ; if returns a found medication, check if it is an active medication
 I $P(X,U,1)=1 D
 . I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 . S $P(X,U,1)=0
 I $P(X,U,1)=1 S MEET=0,DESC=DESC_"On ACEI Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 I $P(X,U,1)=0 S MEET=1,DESC=DESC_"Not on ACEI Meds"
 ;
 K @TREF
 I MEET D
 . S DESC=""
 . F TAX="BGP CMS ARB MEDS CLASS","BGP HEDIS ARB MEDS","BGP HEDIS ARB NDC" D BLD^BQITUTL(TAX,TREF)
 . S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 . ; if returns a found medication, check if it is an active medication
 . I $P(X,U,1)=1 D
 .. I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 .. S $P(X,U,1)=0
 . I $P(X,U,1)=1 S MEET=0,DESC=DESC_"On ARB Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 . I $P(X,U,1)=0 S MEET=1,DESC=DESC_"Not on ARB Meds"
 . K @TREF
 I 'MEET Q MEET_U_DESC
 D
 . S X=$$ACEI^BQITRCON(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has a contraindication: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 . S X=$$ACEI^BQITRALG(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has an allergy: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 I 'MEET Q 0_U_DESC
 ;
 ; Check for special conditions
 S RETURN=$$ACB^BQITRACB(BQDFN,.BQRM)
 ;
 I $P(RETURN,U,1)=0 S DESC="Not on ACEI or ARB Meds but no conditions",MEET=0
 I $P(RETURN,U,1)=1 S DESC=DESC_" with "_$P(RETURN,U,2)
 Q MEET_U_DESC
 ;
HDL(BQDFN,TMFRAME) ;EP  CVD.TP-39 and CVD.TP-21 Low HDL
 ; If most recent HDL <40
 NEW MEET,DESC,X,TAX,TREF
 S MEET=0,DESC=""
 S TMFRAME=$G(TMFRAME,"")
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="DM AUDIT HDL TAX","BGP HDL LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL("",1,BQDFN,"",40,"<","","",.TREF)
 I $P(X,U,1)=1 S MEET=1,DESC="Most recent HDL is less than 40 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 I $P(X,U,1)=0 S MEET=0,DESC="Most recent HDL is greater than 40 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"
 K @TREF
 Q MEET_U_DESC
 ;
HLNS(BQDFN) ;EP  CVD.TP-19 High LDL/No Statin
 ; If most recent LDL >100 AND NOT on Statin
 NEW MEET,DESC,X,TAX,TREF
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="DM AUDIT LDL CHOLESTEROL TAX","BGP LDL LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL("T-12M",1,BQDFN,"",100,">","","",.TREF)
 I $P(X,U,1)=0 S MEET=0,DESC="Most recent LDL not greater than 100 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")" Q MEET_U_DESC
 I $P(X,U,1)=1 S MEET=1,DESC="Most recent LDL greater than 100 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_") and "_U_$P(X,U,2,5)
 K @TREF
 F TAX="BGP HEDIS STATIN MEDS","BGP HEDIS STATIN NDC" D BLD^BQITUTL(TAX,TREF)
 S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 ; if returns a found medication, check if it is an active medication
 I $P(X,U,1)=1 D
 . I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 . S $P(X,U,1)=0
 I $P(X,U,1)=1 S MEET=0,$P(DESC,U,1)=$P(DESC,U,1)_"and On Statin Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 I $P(X,U,1)=0 S MEET=1,$P(DESC,U,1)=$P(DESC,U,1)_"Not on Statin Meds"
 K @TREF
 Q MEET_U_DESC
 ;
HBP(BQDFN) ;EP  CVD.TP-16 High BP
 ; If 2 of last 3 non-ER blood pressures in past 2 years are
 ; Systolic >130 or Diastolic >80
 NEW MEET,DESC,X,TEXT,BQI,QFL
 S MEET=0,DESC="",TEXT=""
 S X=$$BP^BQITRUTL("T-24M",BQDFN,130,80,">")
 I $P(X,U,2)'="" D
 . NEW NDATE
 . S QFL=0
 . F BQI=1:1:3 D  Q:QFL
 .. I $P($P(X,U,2),";",BQI)="No BPs in timeframe" S TEXT=$P($P(X,U,2),";",BQI),QFL=1 Q
 .. S NDATE=$$FMTE^BQIUL1($P($P(X,U,2),";",BQI))_"("_$P($P(X,U,5),";",BQI)_")",TEXT=TEXT_NDATE_";"
 I $P(X,U,1)=0 S MEET=0,DESC="2 of last 3 non-ER BP are not valid values ["_TEXT_"]" Q MEET_U_DESC
 I $P(X,U,1)=1 S MEET=1,DESC=DESC_$$PBP^BQITRCKN(DESC,X)
 Q MEET_U_DESC
