BQITRCKN ;VNGT/HS/ALA-CVD Known Treatment Prompts ; 02 Sep 2008  11:51 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ;
ASA(BQDFN) ; EP  CVD.TP-1 No ASA/Antiplatelet
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
STAT(BQDFN) ; EP  CVD.TP-2 No Statin
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
 ;
BETA(BQDFN,ONF) ;EP CVD.TP-3 No Beta Blocker
 ; Input parameter
 ;   BQDFN - Patient internal entry number
 ;   ONF   - 'On' flag 1=if on medication, 0=if not on medication
 NEW CT,X,VISIT,VSDTM,MEET,DESC,TIEN,T2,PRGM,QFL,RESULT,GREF,IEN,ENDT,C,BQGPRG,BGPDXBD,BGPDXED
 S MEET=0,DESC=""
 S ONF=$G(ONF,0)
 ;
 ; If 2 of last 3 non-ER blood pressures in past 2 years are Systolic >130
 ; or Diastolic >80
 S RESULT=$$BP(BQDFN)
 I $P(RESULT,U,1)=0 Q RESULT
 ; And not on Beta Blocker and not contraindicated
 I 'ONF S RESULT=$$BETAN(BQDFN)
 ; And on Beta Blocker and not contraindicated
 I ONF S RESULT=$$BETAO(BQDFN)
 Q RESULT
 ;
BETAN(BQDFN) ;EP - Not on Beta Blocker
 NEW X,MEET,DESC,TAX,TREF
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="BGP CMS BETA BLOCKER CLASS","BGP HEDIS BETA BLOCKER MEDS","BGP HEDIS BETA BLOCKER NDC" D BLD^BQITUTL(TAX,TREF)
 S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 ; if returns a found medication, check if it is an active medication
 I $P(X,U,1)=1 D
 . I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 . S $P(X,U,1)=0
 I $P(X,U,1)=1 S MEET=0,DESC=DESC_"On Beta Blocker Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 I $P(X,U,1)=0 S MEET=1,DESC="Not on Beta Blocker Meds"
 D
 . S X=$$BETA^BQITRCON(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has a contraindication: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 . S X=$$BETA^BQITRALG(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has an allergy: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 K @TREF
 Q MEET_U_DESC
 ;
BETAO(BQDFN) ;EP - On Beta Blocker
 NEW X,MEET,DESC,TAX,TREF
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="BGP CMS BETA BLOCKER CLASS","BGP HEDIS BETA BLOCKER MEDS","BGP HEDIS BETA BLOCKER NDC" D BLD^BQITUTL(TAX,TREF)
 S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 ; if returns a found medication, check if it is an active medication
 I $P(X,U,1)=1 D
 . I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 . S $P(X,U,1)=0
 I $P(X,U,1)=1 S MEET=1,DESC=DESC_"On Beta Blocker Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 I $P(X,U,1)=0 S MEET=0,DESC="Not on Beta Blocker Meds"
 K @TREF
 D
 . S X=$$BETA^BQITRCON(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has a contraindication: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 . S X=$$BETA^BQITRALG(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has an allergy: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 Q MEET_U_DESC
 ;
ACEI(BQDFN) ;EP CVD.TP-4 (TP-5) No ACEI
 ; If 2 of last 3 non-ER blood pressures in past 2 years are Systolic >130
 ; or Diastolic >80 and not on ACEI or ARB and not contraindicated
 NEW CT,X,VISIT,VSDTM,MEET,DESC,TIEN,T2,PRGM,QFL,RESULT,TREF,GREF,IEN
 NEW ENDT,C,BQGPRG,BGPDXBD,BGPDXED,TAX,TREF,TEXT,BQI,QFL
 S MEET=0,DESC="",TEXT=""
 S X=$$BP^BQITRUTL("T-24M",BQDFN,130,80,">")
 I $P(X,U,2)'="" D
 . NEW NDATE
 . S QFL=0
 . F BQI=1:1:3 D  Q:QFL
 .. I $P($P(X,U,2),";",BQI)="No BPs in timeframe" S TEXT=$P($P(X,U,2),";",BQI),QFL=1 Q
 .. S NDATE=$$FMTE^BQIUL1($P($P(X,U,2),";",BQI))_"("_$P($P(X,U,5),";",BQI)_")",TEXT=TEXT_NDATE_";"
 I $P(X,U,1)=0 S MEET=0,DESC="2 of last 3 non-ER BP are not valid values ["_TEXT_"]" Q MEET_U_DESC
 I $P(X,U,1)=1 S MEET=1,DESC=DESC_$$PBP(DESC,X)
 I 'MEET Q MEET_U_DESC
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="BGP CMS ACEI MEDS CLASS","BGP HEDIS ACEI MEDS","BGP HEDIS ACEI NDC" D BLD^BQITUTL(TAX,TREF)
 S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 ; if returns a found medication, check if it is an active medication
 I $P(X,U,1)=1 D
 . I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 . S $P(X,U,1)=0
 I $P(X,U,1)=1 S MEET=0,DESC=DESC_"On ACEI Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 I $P(X,U,1)=0 S MEET=1,DESC=DESC_" and Not on ACEI Meds"
 I MEET D ACCON
 K @TREF
 I MEET Q MEET_U_DESC
 F TAX="BGP CMS ARB MEDS CLASS","BGP HEDIS ARB MEDS","BGP HEDIS ARB NDC" D BLD^BQITUTL(TAX,TREF)
 S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 ; if returns a found medication, check if it is an active medication
 I $P(X,U,1)=1 D
 . I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 . S $P(X,U,1)=0
 I $P(X,U,1)=1 S MEET=0,DESC=DESC_"On ARB Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 I $P(X,U,1)=0 S MEET=1,DESC="Not on ARB Meds"
 I MEET D ACCON
 K @TREF
 Q MEET_U_DESC
 ;
ACCON ; Check for ACEI contraindication
 S X=$$ACEI^BQITRCON(BQDFN,$G(BDATE,""),$G(EDATE,""))
 I $P(X,U,1)=1 S MEET=0,DESC="Has a contraindication: "_$P(X,U,2) Q
 S MEET=$S(MEET:0,1:1)
 S X=$$ACEI^BQITRALG(BQDFN,$G(BDATE,""),$G(EDATE,""))
 I $P(X,U,1)=1 S MEET=0,DESC="Has an allergy: "_$P(X,U,2) Q
 S MEET=$S(MEET:0,1:1)
 Q
 ;
HBP(BQDFN) ;EP  CVD.TP-5 High BP
 ; If 2 of last 3 non-ER blood pressures in past 2 years are Systolic >130
 ; or Diastolic >80 and on beta blocker and on ACEI or ARB and not
 ; contraindicated
 NEW RESULT1,RESULT2,X,MEET,DESC
 S MEET=0,DESC=""
 S RESULT1=$$BETA(BQDFN,1)
 ; If '0', not on Beta Blocker
 I $P(RESULT1,U,1)=0 Q RESULT1
 S RESULT2=$$ACEI(BQDFN)
 ; If '1', not on ACEI
 I $P(RESULT2,U,1)=1 Q RESULT2
 S MEET=1,DESC=DESC_$P(RESULT1,U,2)_" and "_$P(RESULT2,U,2)
 Q MEET_U_DESC
 ;
HLDL(BQDFN,TMFRAME) ;EP  CVD.TP-6 High LDL
 ; If most recent LDL in past year >100 and on Statin Medication
 NEW X,MEET,DESC,TAX,TREF,X1
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="DM AUDIT LDL CHOLESTEROL TAX","BGP LDL LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL("T-12M",1,BQDFN,"",100,">","","",.TREF)
 I $P(X,U,1)=0 S MEET=0,DESC="Most recent LDL not greater than 100 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"
 I $P(X,U,1)=1 S MEET=1,DESC="Most recent LDL greater than 100 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_") and ",X1=X
 I 'MEET Q MEET_U_DESC
 K @TREF
 F TAX="BGP HEDIS STATIN MEDS","BGP HEDIS STATIN NDC" D BLD^BQITUTL(TAX,TREF)
 S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 ; if returns a found medication, check if it is an active medication
 I $P(X,U,1)=1 D
 . I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 . S $P(X,U,1)=0
 I $P(X,U,1)=0 S MEET=0,DESC=DESC_"Not on Statin Meds "
 I $P(X,U,1)=1 S MEET=1,DESC=DESC_"On Statin Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 K @TREF
 Q MEET_U_DESC_U_$P(X1,U,2,5)
 ;
LHDL(BQDFN) ;EP  CVD.TP-7 Low HDL
 ; If most recent LDL in past year is <=100 AND HDL in past year is <40
 NEW MEET,DESC,X,HDL,LDL,TAX,TREF
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="DM AUDIT HDL TAX","BGP HDL LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL("T-12M",1,BQDFN,"",40,"<","","",.TREF)
 I $P(X,U,1)=1 S HDL=X,MEET=1,DESC="HDL in past year less than 40 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_") and "
 I $P(X,U,1)=0 S MEET=0,DESC="HDL in past year not less than 40 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"
 I 'MEET Q MEET_U_DESC
 ;
 K @TREF
 F TAX="DM AUDIT LDL CHOLESTEROL TAX","BGP LDL LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL("T-12M",1,BQDFN,"",100,"'>","","",.TREF)
 I $P(X,U,1)=1 S LDL=X,MEET=1,DESC=DESC_"LDL in past year not greater than 100 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 I $P(X,U,1)=0 S MEET=0,DESC=DESC_"LDL in past year greater than 100 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 K @TREF
 Q MEET_U_DESC
 ;
NLDL(BQDFN) ;EP  CVD.TP-8 No LDL
 ; No LDL in past year
 NEW MEET,DESC,X,TAX,TREF
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="DM AUDIT LDL CHOLESTEROL TAX","BGP LDL LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL("T-12M",1,BQDFN,"",0,">","","",.TREF)
 I $P(X,U,1)=1 S MEET=0,DESC="Has LDL in past year ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 I $P(X,U,1)=0 S MEET=1,DESC="No LDL in past year"
 K @TREF
 Q MEET_U_DESC
 ;
HTG(BQDFN,TMFRAME) ;EP  CVD.TP-9  High TG
 ; Most recent TG in past year >150
 NEW MEET,DESC,X,TAX,TREF
 S MEET=0,DESC=""
 S TMFRAME=$G(TMFRAME,"")
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="DM AUDIT TRIGLYCERIDE TAX","BGP TRIGLYCERIDE LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL(TMFRAME,1,BQDFN,"",150,">","","",.TREF)
 I $P(X,U,1)=1 S MEET=1,DESC="Most recent Triglyceride in past year greater than 150 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 I $P(X,U,1)=0 S MEET=0,DESC="Most recent Triglyceride in past year is not greater than 150 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 K @TREF
 Q MEET_U_DESC
 ;
PBP(NDESC,NX) ;EP - Parse Blood Pressure values
 NEW DATES,MIENS,DDSC,MDT,MVAL,MIEN
 S DATES=$P(NX,U,2),MIENS=$P(NX,U,3),DDSC=""
 F BQJ=1:1:$L(DATES,";") S MDT=$P(DATES,";",BQJ) Q:MDT=""  D
 . S MIEN=$P(MIENS,";",BQJ),MVAL=""
 . I MIEN'="" S MVAL=$$GET1^DIQ(9000010.01,MIEN_",",.04,"E")
 . S DDSC=DDSC_$$FMTE^BQIUL1(MDT)_" "_MVAL_" "
 Q NDESC_" "_DDSC
 ;
BP(BQDFN) ;EP
 ; If 2 of last 3 non-ER blood pressures in past 2 years are Systolic >130
 ; or Diastolic >80
 NEW X,DESC,TEXT,BQI,QFL
 S DESC="",TEXT=""
 S X=$$BP^BQITRUTL("T-24M",BQDFN,130,80,">")
 I $P(X,U,2)'="" D
 . NEW NDATE
 . S QFL=0
 . F BQI=1:1:3 D  Q:QFL
 .. I $P($P(X,U,2),";",BQI)="No BPs in timeframe" S TEXT=$P($P(X,U,2),";",BQI),QFL=1 Q
 .. S NDATE=$$FMTE^BQIUL1($P($P(X,U,2),";",BQI))_"("_$P($P(X,U,5),";",BQI)_")",TEXT=TEXT_NDATE_";"
 I $P(X,U,1)=0 S DESC="2 of last 3 non-ER BP are not valid values ["_TEXT_"]" Q $P(X,U,1)_U_DESC
 I $P(X,U,1)=1 S DESC=DESC_$$PBP(DESC,X)
 Q $P(X,U,1)_U_DESC
