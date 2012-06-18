BQITRCSG ;VNGT/HS/ALA-CVD Significant Risk Treatment Prompts ; 02 Sep 2008  11:52 AM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
HBP(BQDFN) ;EP  CVD.TP-27 High BP
 ; If 2 of last 3 non-ER blood pressures in past 2 years are
 ; Systolic =>140 or Diastolic =>90
 NEW X,MEET,DESC,TEXT,BQI,QFL
 S MEET=0,DESC="",TEXT=""
 S X=$$BP^BQITRUTL("T-24M",BQDFN,140,90,"'<")
 I $P(X,U,2)'="" D
 . NEW NDATE
 . S QFL=0
 . F BQI=1:1:3 D  Q:QFL
 .. I $P($P(X,U,2),";",BQI)="No BPs in timeframe" S TEXT=$P($P(X,U,2),";",BQI),QFL=1 Q
 .. S NDATE=$$FMTE^BQIUL1($P($P(X,U,2),";",BQI))_"("_$P($P(X,U,5),";",BQI)_")",TEXT=TEXT_NDATE_";"
 I $P(X,U,1)=0 S MEET=0,DESC="2 of last 3 non-ER BP are not valid values ["_TEXT_"]" Q MEET_U_DESC
 I $P(X,U,1)=1 D
 . S MEET=1,DESC=DESC_$$PBP^BQITRCKN(DESC,X)
 Q MEET_U_DESC
 ;
TGR(BQDFN) ;EP  CVD.TP-37 TG Recommendation
 ; If patient's most recent TG (within last 5 years) is >500
 NEW MEET,DESC,X,TREF,TAX
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="DM AUDIT TRIGLYCERIDE TAX","BGP TRIGLYCERIDE LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL("T-60M",1,BQDFN,"",500,">","","",.TREF)
 I $P(X,U,1)=1 S MEET=1,DESC="Most recent Triglyceride is greater than 500 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 I $P(X,U,1)=0 S MEET=0,DESC="Most recent Triglyceride is not greater than 500 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"
 K @TREF
 Q MEET_U_DESC
 ;
TGRNG(BQDFN) ;EP  CVD.TP-36  TG not at Goal
 ; If patient's most recent TG (within last 5 years) is 150-499
 NEW MEET,DESC,X,TREF,TAX
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="DM AUDIT TRIGLYCERIDE TAX","BGP TRIGLYCERIDE LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL("T-60M",1,BQDFN,"",149,">",500,"<",.TREF)
 I $P(X,U,1)=1 S MEET=1,DESC="Most recent Triglyceride is 150-499 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 I $P(X,U,1)=0 S MEET=0,DESC="Most recent Triglyceride is not between 150-499 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"
 K @TREF
 Q MEET_U_DESC
 ;
HLDL(BQDFN) ;EP  CVD-TP.38 High LDL
 ; If most recent LDL >160
 NEW MEET,DESC,X,TREF,TAX
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="DM AUDIT LDL CHOLESTEROL TAX","BGP LDL LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL("",1,BQDFN,"",160,">","","",.TREF)
 I $P(X,U,1)=1 S MEET=1,DESC="LDL greater than 160 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 I $P(X,U,1)=0 S MEET=0,DESC="LDL not greater than 160 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"
 K @TREF
 Q MEET_U_DESC
 ;
LHDL(BQDFN) ;EP  CVD-TP.39 Low HDL
 ; If LDL <=160 and if ON Statin or contraindicated AND HDL <40
 NEW X,MEET,DESC,RETURN,TREF,TAX,DDESC
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="DM AUDIT LDL CHOLESTEROL TAX","BGP LDL LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL("",1,BQDFN,"",160,"'>","","",.TREF)
 I $P(X,U,1)=1 S MEET=1,DESC=DESC_"LDL less than or equal to 160 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"
 I $P(X,U,1)=0 S MEET=0,DESC=DESC_"LDL greater than 160 ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"
 I 'MEET Q MEET_U_DESC
 S DDESC=DESC
 S RETURN=$$STAT(BQDFN)
 I $P(RETURN,U,1)=0 Q 0_U_DDESC_" and "_$P(RETURN,U,2)
 I $P(RETURN,U,1)=1 S $P(DESC,U,1)=$P(DESC,U,1)_"; "_$P(RETURN,U,2)
 S RETURN=$$HDL^BQITRCHR(BQDFN)
 I $P(RETURN,U,1)=0 Q 0_U_$P(RETURN,U,2)
 I $P(RETURN,U,1)=1 S $P(DESC,U,1)=$P(DESC,U,1)_"; "_$P(RETURN,U,2,6)
 Q 1_U_DESC
 ; 
STAT(BQDFN) ; EP  CVD.TP-39 Not on Statin
 NEW CT,X,VISIT,VSDTM,MEET,DESC,TIEN,T2,PRGM,QFL,RESULT,TREF,GREF,IEN,ENDT
 NEW C,BQGPRG,BGPDXBD,BGPDXED,TAX,TREF
 S MEET=0,DESC=""
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="BGP HEDIS STATIN MEDS","BGP HEDIS STATIN NDC" D BLD^BQITUTL(TAX,TREF)
 S X=$$TAX^BQITRUTL("","",1,BQDFN,9000010.14,"","",.TREF)
 ; if returns a found medication, check if it is an active medication
 I $P(X,U,1)=1 D
 . I $$ACTMED^BKMQQCR4($P(X,U,5)) Q
 . S $P(X,U,1)=0
 I $P(X,U,1)=1 S MEET=1,DESC=DESC_"On Statin Meds ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$$GET1^DIQ(9000010.14,$P(X,U,5)_",",.01,"E")_")"
 I $P(X,U,1)=0 S MEET=0,DESC=DESC_"Not on Statin Meds "
 D
 . S X=$$STAT^BQITRCON(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has a contraindication: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 . S X=$$STAT^BQITRALG(BQDFN,$G(BDATE,""),$G(EDATE,""))
 . I $P(X,U,1)=1 S MEET=0,DESC="Has an allergy: "_$P(X,U,2) Q
 . S MEET=$S(MEET:0,1:1)
 Q MEET_U_DESC
