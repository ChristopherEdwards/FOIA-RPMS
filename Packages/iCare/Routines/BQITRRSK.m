BQITRRSK ;PRXM/HC/ALA-Treatment Prompts Risk Factors ; 23 May 2007  3:20 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
RSK(BQDFN,BQRM) ;EP - CVD.TP-32 Missing Risk factors
 ; Input
 ;   BQDFN - Patient IEN
 ;If ANY of the following data is missing for the patient
 NEW ACT,X,COND,BQI,QFL,BN,LBN,LAST,DDESC
 S ACT=0,LCNT=0
 ; Tobacco Use Screen
 D
 . S X=$$TAX^BQITRUTL("T-12M","BGP GPRA SMOKING DXS",1,BQDFN,9000010.07)
 . I $P(X,U,1)=1 Q
 . S X=$$TAX^BQITRUTL("T-12M","BGP TOBACCO USER HLTH FACTORS",1,BQDFN,9000010.23)
 . I $P(X,U,1)=1 Q
 . S X=$$TAX^BQITRUTL("T-12M","BGP TOBACCO SCREEN CPTS",1,BQDFN,9000010.18)
 . I $P(X,U,1)=1 Q
 . S X=$$TAX^BQITRUTL("T-12M","BGP TOBACCO CESS DENTAL CODE",1,BQDFN,9000010.05)
 . I $P(X,U,1)=1 Q
 . S X=$$FED^BQITRUTL("T-12M",BQDFN,"TO-")
 . I $P(X,U,1)=1 Q
 . S X=$$CLN^BQITRUTL("T-12M",BQDFN,94)
 . I $P(X,U,1)=1 Q
 . S ACT=ACT+1,COND(ACT)="Tobacco Use Screen last year"
 ;
 ;Total Cholesterol
 D
 . S X=$$LAB^BQITRUTL("T-60M",0,BQDFN,"DM AUDIT CHOLESTEROL TAX",0,">")
 . I $P(X,U,1)=1 Q
 . S X=$$LAB^BQITRUTL("T-60M",0,BQDFN,"BGP TOTAL CHOLESTEROL LOINC",0,">")
 . I $P(X,U,1)=1 Q
 . S ACT=ACT+1,COND(ACT)="Total Cholesterol last 5 years"
 ;
 ;HDL in past 5 years
 D
 . S X=$$LAB^BQITRUTL("T-60M",0,BQDFN,"DM AUDIT HDL TAX",0,">")
 . I $P(X,U,1)=1 Q
 . S X=$$LAB^BQITRUTL("T-60M",0,BQDFN,"BGP HDL LOINC CODES",0,">")
 . I $P(X,U,1)=1 Q
 . S ACT=ACT+1,COND(ACT)="HDL last 5 years"
 ;
 ;LDL in past 5 years
 D
 . S X=$$LAB^BQITRUTL("T-60M",0,BQDFN,"DM AUDIT LDL CHOLESTEROL TAX",0,">")
 . I $P(X,U,1)=1 Q
 . S X=$$LAB^BQITRUTL("T-60M",0,BQDFN,"BGP LDL LOINC CODES",0,">")
 . I $P(X,U,1)=1 Q
 . S ACT=ACT+1,COND(ACT)="LDL last 5 years"
 ;
 ;BP last year
 S X=$$BP(BQDFN,"T-12M")
 I X=0 S ACT=ACT+1,COND(ACT)="BP last year"
 ;
 ;Update the remarks
 I ACT=0 K BQRM Q 0_U_"Not missing data"
 ;
 I ACT>0 D
 . S BN=0,DDESC=""
 . F  S BN=$O(BQRM(BN)) Q:BN=""  D
 .. I BQRM(BN)["|" D
 ... S LBN=$O(BQRM(BN)) I LBN'="" S LAST=BQRM(LBN)
 ... S BI=0 F  S BI=$O(COND(BI)) Q:BI=""  D
 .... S BQRM(BN)=$C(10)_"   "_COND(BI),BN=BN+1,DDESC=DDESC_COND(BI)_"; "
 . S BN=$O(BQRM(BN),-1)+1
 . I $G(LAST)'="" S BQRM(BN)=LAST
 Q 1_U_DDESC
 ;
HDL(BQDFN) ;EP - HDL Goal CVD.TP-35 HDL Not at Goal
 ; If patient's most recent HDL (within last 5 years) not at goal
 ; (=>40 for men and =>45 for women)
 NEW SEX,VAL,Y,MEET,DESC,TAX,TREF
 S MEET=0,DESC=""
 S SEX=$$GET1^DIQ(2,BQDFN_",",.02,"I")
 ;
 S TREF=$NA(^TMP("BQITAX",UID)) K @TREF
 F TAX="DM AUDIT HDL TAX","BGP HDL LOINC CODES" D BLD^BQITUTL(TAX,TREF)
 S X=$$LAB^BQITRUTL("T-60M",1,BQDFN,"",0,">","","",.TREF)
 I 'X D
 . S MEET=0,DESC="Most recent HDL not at goal ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 I X D
 . I SEX="M",$P(X,U,3)<40 S MEET=1,DESC="Most recent HDL at goal ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 . I SEX="F",$P(X,U,3)<45 S MEET=1,DESC="Most recent HDL at goal ("_$$FMTE^BQIUL1($P(X,U,2))_" "_$P(X,U,3)_")"_U_$P(X,U,2,5)
 Q MEET_U_DESC
 ;
BP(BDFN,TMFRAME) ;EP -- Blood Pressure for a single patient
 ;  Get the Mean Blood Pressure value for a patient and a time frame
 ;Input
 ;  BDFN - Patient IEN
 ;  TMFRAME - Time frame in relative date format
 ;
 ;  Get a list of all BP measures in the time frame
 NEW BDATE,EDATE,BTYP,BCLN,DATE,QFL,RESULT
 S BDATE=(9999999-DT),RESULT=0
 S EDATE=(9999999-$$DATE^BQIUL1(TMFRAME))
 ;
 S BTYP=$$FIND1^DIC(9999999.07,,"X","BP")
 S BCLN=$$FIND1^DIC(40.7,"","Q","30","C","","ERROR")
 S DATE=BDATE-.01,QFL=0
 F  S DATE=$O(^AUPNVMSR("AA",BDFN,BTYP,DATE)) Q:DATE=""!(DATE>EDATE)  D  Q:QFL
 . S IEN=""
 . F  S IEN=$O(^AUPNVMSR("AA",BDFN,BTYP,DATE,IEN),-1) Q:IEN=""!(QFL)  D
 .. S VISIT=$P(^AUPNVMSR(IEN,0),U,3) I VISIT="" Q
 .. ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 .. I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,IEN_",",2,"I")=1
 .. I $P($G(^AUPNVSIT(VISIT,0)),U,8)=BCLN Q
 .. I $P($G(^AUPNVSIT(VISIT,0)),U,11)=1 Q
 .. S RESULT=1,QFL=1
 Q RESULT
