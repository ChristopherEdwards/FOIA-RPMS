BQITBMI ;PRXM/HC/ALA-Calculate BMI value ; 04 Apr 2006  1:22 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ;**Program Description**
 ; This program calculates BMI and other measurements for a patient
 ; and time frame.
 Q
 ;
OBMI(BDFN,TMFRAME) ;EP
 NEW BHT,BWT,BDATE,EDATE,HT,WT,HDATE,WDATE,DATE,QFL,IEN,HVISIT,HVSDTM,AGE
 NEW BDATE19,CAGE,BDATE50
 NEW WVISIT,WVSDTM,BGPBMIH,HIEN,WIEN
 ;I $G(TMFRAME)="" S TMFRAME="T-60M"
 S BHT=$$FIND1^DIC(9999999.07,,"X","HT")
 S BWT=$$FIND1^DIC(9999999.07,,"X","WT")
 S BDATE=(9999999-DT)
 S EDATE=(9999999-$$DATE^BQIUL1(TMFRAME))
 S BDATE19=$$DATE^BQIUL1("T-12M")
 S BDATE50=$$DATE^BQIUL1("T-24M")
 S CAGE=$$AGE^BQIAGE(BDFN) ; patient's current age
 ; Patients younger than 2 years cannot have BMI calculated. 
 I CAGE<2 Q ""
 S HT="",WT="",HDATE="",WDATE=""
 S BDATE=BDATE-.01 ;Make range inclusive
 S DATE=BDATE,QFL=0
 S TMDATA=$NA(^TMP("BQIBM",UID))
 K @TMDATA
FD ;  Find data
 F  S DATE=$O(^AUPNVMSR("AA",BDFN,BHT,DATE)) Q:DATE=""!(DATE>EDATE)  D  Q:QFL
 . S IEN=""
 . F  S IEN=$O(^AUPNVMSR("AA",BDFN,BHT,DATE,IEN)) Q:IEN=""!(QFL)  D
 .. ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 .. I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,IEN_",",2,"I")=1
 .. S HT=$P(^AUPNVMSR(IEN,0),U,4),HDATE=DATE
 .. S HVISIT=$P(^AUPNVMSR(IEN,0),U,3),HIEN=IEN
 .. I $P($G(^AUPNVSIT(HVISIT,0)),U,11)=1 Q
 .. S HVSDTM=$P(^AUPNVSIT(HVISIT,0),U,1)
 .. ; If patient <19 years only look at the last year
 .. I CAGE<19,HVSDTM<BDATE19 S HT="",HDATE="" Q
 .. I CAGE>49,HVSDTM<BDATE50 S HT="",HDATE="" Q
 .. S @TMDATA@(BDFN,"CRITERIA",HVSDTM,"BMI-Height")=HVISIT
 .. S $P(@TMDATA@(BDFN,"CRITERIA",HVSDTM,"BMI-Height"),U,3)=IEN_U_"9000010.01"
 .. S $P(@TMDATA@(BDFN,"V",HVSDTM),U,2)=HT
 ;
 S DATE=BDATE,QFL=0
 F  S DATE=$O(^AUPNVMSR("AA",BDFN,BWT,DATE)) Q:DATE=""!(DATE>EDATE)  D  Q:QFL
 . S IEN=""
 . F  S IEN=$O(^AUPNVMSR("AA",BDFN,BWT,DATE,IEN)) Q:IEN=""!(QFL)  D
 .. ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 .. I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,IEN_",",2,"I")=1
 .. S WT=$P(^AUPNVMSR(IEN,0),U,4),WDATE=DATE
 .. S WVISIT=$P(^AUPNVMSR(IEN,0),U,3),WIEN=IEN
 .. I $P($G(^AUPNVSIT(WVISIT,0)),U,11)=1 Q
 .. S WVSDTM=$P(^AUPNVSIT(WVISIT,0),U,1)
 .. I WT'="" S AGE=$$AGE^BQIAGE(BDFN,WVSDTM) D
 ... ; If patient <19 years only look at the last year
 ... I CAGE<19,WVSDTM<BDATE19 S WT="",WDATE="" Q
 ... I CAGE>49,WVSDTM<BDATE50 S WT="",WDATE="" Q
 ... S @TMDATA@(BDFN,"CRITERIA",WVSDTM,"BMI-Weight")=WVISIT
 ... S $P(@TMDATA@(BDFN,"CRITERIA",WVSDTM,"BMI-Weight"),U,3)=IEN_U_"9000010.01"
 ... S $P(@TMDATA@(BDFN,"V",WVSDTM),U,1)=WT
 ;
 S VSDTM="",QFL=0,HT="",WT=""
 F  S VSDTM=$O(@TMDATA@(BDFN,"V",VSDTM),-1) Q:VSDTM=""  D  Q:QFL
 . I CAGE<19,VSDTM<BDATE19 K @TMDATA@(BDFN,"V",VSDTM) Q
 . I CAGE>50,VSDTM<BDATE50 K @TMDATA@(BDFN,"V",VSDTM) Q
 . S RESULTS=@TMDATA@(BDFN,"V",VSDTM)
 . I CAGE<19 D  Q
 .. S HT=$P(RESULTS,"^",2),WT=$P(RESULTS,"^",1)
 .. I HT=""!(WT="") Q
 .. S HVISIT=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Height"),U,1)
 .. S HIEN=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Height"),U,3)
 .. S WVISIT=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Weight"),U,1)
 .. S WIEN=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Weight"),U,3)
 .. S QFL=1
 . I HT="" D
 .. S HT=$P(RESULTS,"^",2) I HT="" Q
 .. S HVISIT=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Height"),U,1)
 .. S HIEN=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Height"),U,3)
 .. I WT'="" Q
 .. I WT="" S WT=$P(RESULTS,"^",1) I WT="" Q
 .. S WVISIT=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Weight"),U,1)
 .. S WIEN=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Weight"),U,3)
 . I WT="" D
 .. S WT=$P(RESULTS,"^",1) I WT="" Q
 .. S WVISIT=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Weight"),U,1)
 .. S WIEN=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Weight"),U,3)
 .. I HT'="" Q
 .. I HT="" S HT=$P(RESULTS,"^",2) I HT="" Q
 .. S HVISIT=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Height"),U,1)
 .. S HIEN=$P(@TMDATA@(BDFN,"CRITERIA",VSDTM,"BMI-Height"),U,3)
 . I HT'=""&(WT'="") S QFL=1
 ;
 I +HT=0!(+WT=0) Q ""
 ;
 K @TMDATA
 S WT=WT*.45359,HT=(HT*.0254),HT=(HT*HT),BGPBMIH=(WT/HT)
 S AGE=$$AGE^BQIAGE(BDFN,$P(^AUPNVSIT(WVISIT,0),U,1)\1)
 Q BGPBMIH_"^"_AGE_"^"_HVISIT_","_WVISIT_"^"_HIEN_","_WIEN
 ;
OB(BDFN,BBMI,AGE) ;EP - obese
 ;Description - Checks if a patient is classified as obese
 ;Input
 ;  BDFN - Patient IEN
 ;  BBMI - Patient BMI value
 ;  AGE  - Age of patient when measure was taken
 NEW SEX,R
 I $G(BBMI)="" Q 0
 I AGE<2 Q 0
 S SEX=$P(^DPT(BDFN,0),U,2)
 I SEX="" Q 0
 S R=0,R=$O(^APCLBMI("H",SEX,AGE,R))
 I 'R S R=$O(^APCLBMI("H",SEX,AGE)) I R S R=$O(^APCLBMI("H",SEX,R,""))
 I 'R Q 0
 I BBMI>$P(^APCLBMI(R,0),U,7)!(BBMI<$P(^APCLBMI(R,0),U,6)) Q "0^Outside Data Check Limits"
 I BBMI'<$P(^APCLBMI(R,0),U,5) Q 1
 Q 0
 ;
OW(BDFN,BBMI,AGE) ;EP - overweight
 ;Description - Checks if a patient is classified as overweight
 ;Input
 ;  BDFN - Patient IEN
 ;  BBMI - Patient BMI value
 ;  AGE  - Age of patient when measure was taken
 NEW SEX,R
 I $G(BBMI)="" Q 0
 I AGE<2 Q 0
 S SEX=$P(^DPT(BDFN,0),U,2)
 I SEX="" Q 0
 S R=0,R=$O(^APCLBMI("H",SEX,AGE,R))
 I 'R S R=$O(^APCLBMI("H",SEX,AGE)) I R S R=$O(^APCLBMI("H",SEX,R,""))
 I 'R Q 0
 I BBMI>$P(^APCLBMI(R,0),U,7)!(BBMI<$P(^APCLBMI(R,0),U,6)) Q "0^Outside Data Check Limits"
 I BBMI'<$P(^APCLBMI(R,0),U,4),BBMI<$P(^APCLBMI(R,0),U,5) Q 1
 Q 0
 ;
BP(BDFN,TMFRAME) ;EP -- Blood Pressure for a single patient
 ;  Get the Mean Blood Pressure value for a patient and a time frame
 ;Input
 ;  BDFN - Patient IEN
 ;  TMFRAME - Time frame in relative date format
 ;
 ;  Get a list of all BP measures in the time frame
 NEW N,TBP,TTBP,BDATE,EDATE,E,%,VISIT,CT,TSYS,TDIA,SYS,VIENS
 K TBP,TTBP
 S BDATE=(9999999-DT)
 S EDATE=(9999999-$$DATE^BQIUL1(TMFRAME))
 ;
 S BTYP=$$FIND1^DIC(9999999.07,,"X","BP")
 S BCLN=$$FIND1^DIC(40.7,"","Q","30","C","","ERROR")
 S DATE=BDATE-.01,CT=0,QFL=0
 F  S DATE=$O(^AUPNVMSR("AA",BDFN,BTYP,DATE)) Q:DATE=""!(DATE>EDATE)  D  Q:QFL
 . S IEN=""
 . F  S IEN=$O(^AUPNVMSR("AA",BDFN,BTYP,DATE,IEN),-1) Q:IEN=""!(QFL)  D
 .. S VISIT=$P(^AUPNVMSR(IEN,0),U,3) I VISIT="" Q
 .. ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 .. I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,IEN_",",2,"I")=1
 .. I $P(^AUPNVSIT(VISIT,0),U,8)=BCLN Q
 .. I $P(^AUPNVSIT(VISIT,0),U,11)=1 Q
 .. S CT=CT+1
 .. S TBP(CT)=$P(^AUPNVSIT(VISIT,0),U,1)\1_U_$P(^AUPNVMSR(IEN,0),U,4)_U_"BP"_U_IEN_";AUPNVMSR"_U_VISIT
 ;  check for multiple BPs in the same visit and use the lowest BP
 S N="" F  S N=$O(TBP(N)) Q:'N  D
 . S VISIT=$P(TBP(N),U,5),SYS=$P($P(TBP(N),U,2),"/",1)
 . I VISIT=""!(SYS="") Q
 . S TTBP(VISIT,SYS)=N
 S CT=0,VISIT="",TSYS="",TDIA="",VIENS="",IENS=""
 F  S VISIT=$O(TTBP(VISIT),-1) Q:VISIT=""!(CT=3)  D
 . S SYS=$O(TTBP(VISIT,"")),N=TTBP(VISIT,SYS)
 . S DIA=$P($P(TBP(N),U,2),"/",2)
 . NEW RIEN
 . S RIEN=$P($P(TBP(N),U,4),";",1),IENS=IENS_RIEN_","
 . S TSYS=TSYS+SYS,TDIA=TDIA+DIA,CT=CT+1,VIENS=VIENS_VISIT_","
 K TBP,TTBP
 I CT<2 Q ""
 Q $J((TSYS/CT),3,0)_U_$J((TDIA/CT),2,0)_U_VIENS_U_IENS
 ;
ABP(TMFRAME,TPGLOB) ;EP -- Blood Pressure for all patients
 ; Input
 ;   TMFRAME - Timeframe for search
 ;   TPGLOB  - Temporary global
 NEW BDATE,EDATE,TMDATA,BTYP,IEN,BCLN,DATE,VISIT,MIEN,DFN,RESULT,TTBP
 NEW TDIA,TSYS,DIA,SYS,N,VIENS,CT,IENS,BQBDT
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S BDATE=$$DATE^BQIUL1(TMFRAME),EDATE=DT
 S BTYP=$$FIND1^DIC(9999999.07,,"X","BP")
 S BCLN=$$FIND1^DIC(40.7,"","Q","30","C","","ERROR")
 S TMDATA=$NA(^TMP("BQIBPA",UID))
 K @TMDATA
 S DATE=BDATE
 F  S DATE=$O(^AUPNVSIT("B",DATE)) Q:DATE=""!((DATE\1)>EDATE)  D
 . S VISIT=""
 . F  S VISIT=$O(^AUPNVSIT("B",DATE,VISIT)) Q:VISIT=""  D
 .. I $$GET1^DIQ(9000010,VISIT_",",.08,"I")=BCLN Q
 .. I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
 .. S MIEN=""
 .. F  S MIEN=$O(^AUPNVMSR("AD",VISIT,MIEN),-1) Q:MIEN=""  D
 ... I $$GET1^DIQ(9000010.01,MIEN_",",.01,"I")'=BTYP Q
 ... ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 ... I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,MIEN_",",2,"I")=1
 ... S DFN=$$GET1^DIQ(9000010.01,MIEN_",",.02,"I") I DFN="" Q
 ... S RESULT=$$GET1^DIQ(9000010.01,MIEN_",",.04,"E") I RESULT="" Q
 ... ;I $G(@TMDATA@(DFN))'<3 Q
 ... S @TMDATA@(DFN)=$G(@TMDATA@(DFN))+1
 ... S @TMDATA@(DFN,"V","BP",DATE,MIEN)=VISIT_"^"_$$GET1^DIQ(9000010.01,MIEN_",",.04,"E")
 ;
 S DFN=""
 F  S DFN=$O(@TMDATA@(DFN)) Q:DFN=""  D
 . I $G(@TMDATA@(DFN))<2 K @TMDATA@(DFN) Q
 . S BQBDT="" K TTBP
 . F  S BQBDT=$O(@TMDATA@(DFN,"V","BP",BQBDT),-1) Q:BQBDT=""  D
 .. S N="" F  S N=$O(@TMDATA@(DFN,"V","BP",BQBDT,N)) Q:N=""  D
 ... S VISIT=$P(@TMDATA@(DFN,"V","BP",BQBDT,N),U,1),SYS=$P($P(@TMDATA@(DFN,"V","BP",BQBDT,N),U,2),"/",1)
 ... S TTBP(VISIT,N,SYS)=$P(@TMDATA@(DFN,"V","BP",BQBDT,N),U,2)
 . S VISIT="",TSYS=0,TDIA=0,VIENS="",CT=0,IENS=""
 . F  S VISIT=$O(TTBP(VISIT),-1) Q:VISIT=""  D  Q:CT>2
 .. S MIEN=""
 .. F  S MIEN=$O(TTBP(VISIT,MIEN),-1) Q:MIEN=""  D  Q:CT>2
 ... S SYS=$O(TTBP(VISIT,MIEN,"")),N=TTBP(VISIT,MIEN,SYS)
 ... S DIA=$P(N,"/",2)
 ... S TSYS=(TSYS+SYS),TDIA=(TDIA+DIA),CT=CT+1,VIENS=VIENS_VISIT_","
 ... S IENS=IENS_MIEN_","
 . K TTBP
 . S @TPGLOB@(DFN)=$J((TSYS/CT),3,0)_U_$J((TDIA/CT),2,0)_U_VIENS_U_IENS
 K @TMDATA
 Q
 ;
ABMI(TMFRAME,TPGLOB) ;EP - Get BMIs for all patients
 ; Input
 ;   TMFRAME - Timeframe for search
 ;   TPGLOB  - Temporary global
 ;
 NEW BDATE,EDATE,BHT,BWT,TMDATA,DATE,VISIT,MIEN,BTYP,RESULT,DFN,AGE,H,W,HT,WT
 NEW QFL,RESULTS,VSDTM,BMI,CAGE,HVISIT,WVISIT,HVSDTM,WVSDTM,UID
 NEW BDATE19,BDATE50
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 ;I $G(TMFRAME)="" S TMFRAME="T-60M"
 S BDATE19=$$DATE^BQIUL1("T-12M") ; Patients <19 are limited to the past year
 S BDATE50=$$DATE^BQIUL1("T-24M")
 S BDATE=$$DATE^BQIUL1(TMFRAME),EDATE=DT
 S BHT=$$FIND1^DIC(9999999.07,,"X","HT")
 S BWT=$$FIND1^DIC(9999999.07,,"X","WT")
 S TMDATA=$NA(^TMP("BQIBM",UID))
 K @TMDATA
 S DATE=EDATE
 F  S DATE=$O(^AUPNVSIT("B",DATE),-1) Q:DATE=""!((DATE\1)<BDATE)  D
 . S VISIT=""
 . F  S VISIT=$O(^AUPNVSIT("B",DATE,VISIT)) Q:VISIT=""  D
 .. I $$GET1^DIQ(9000010,VISIT_",",.11,"I")=1 Q
 .. S MIEN=""
 .. F  S MIEN=$O(^AUPNVMSR("AD",VISIT,MIEN),-1) Q:MIEN=""  D
 ... S BTYP=$$GET1^DIQ(9000010.01,MIEN_",",.01,"I")
 ... I BTYP'=BHT,BTYP'=BWT Q
 ... ; if the new ENTERED IN ERROR field exists, exclude the record if it is marked as an error
 ... I $$VFIELD^DILFD(9000010.01,2) Q:$$GET1^DIQ(9000010.01,MIEN_",",2,"I")=1
 ... S DFN=$$GET1^DIQ(9000010.01,MIEN_",",.02,"I") I DFN="" Q
 ... S CAGE=$$AGE^BQIAGE(DFN)
 ... ; Patients younger than 2 years cannot have BMI calculated. 
 ... I CAGE<2 Q
 ... S RESULT=$$GET1^DIQ(9000010.01,MIEN_",",.04,"E") I RESULT="" Q
 ... S @TMDATA@(DFN)=CAGE
 ... I BTYP=BHT D
 .... S H=RESULT
 .... I $P($G(@TMDATA@(DFN,"V",DATE)),"^",2)="" S $P(@TMDATA@(DFN,"V",DATE),"^",2)=H
 .... I $P($G(@TMDATA@(DFN,"CRITERIA",DATE,"BMI-Height")),U,1)="" S $P(@TMDATA@(DFN,"CRITERIA",DATE,"BMI-Height"),U,1)=VISIT
 .... I $P($G(@TMDATA@(DFN,"CRITERIA",DATE,"BMI-Height")),U,3)="" S $P(@TMDATA@(DFN,"CRITERIA",DATE,"BMI-Height"),U,3)=MIEN_U_"9000010.01"
 ... I BTYP=BWT D
 .... I $P($G(@TMDATA@(DFN,"V",DATE)),"^",1)="" S $P(@TMDATA@(DFN,"V",DATE),"^",1)=RESULT
 .... I $P($G(@TMDATA@(DFN,"CRITERIA",DATE,"BMI-Weight")),U,1)="" S $P(@TMDATA@(DFN,"CRITERIA",DATE,"BMI-Weight"),U,1)=VISIT
 .... I $P($G(@TMDATA@(DFN,"CRITERIA",DATE,"BMI-Weight")),U,3)="" S $P(@TMDATA@(DFN,"CRITERIA",DATE,"BMI-Weight"),U,3)=MIEN_U_"9000010.01"
 ;
 S DFN=""
 F  S DFN=$O(@TMDATA@(DFN)) Q:DFN=""  D
 . S VSDTM="",QFL=0,HT="",WT=""
 . F  S VSDTM=$O(@TMDATA@(DFN,"V",VSDTM),-1) Q:VSDTM=""  D  Q:QFL
 .. S CAGE=$$AGE^BQIAGE(DFN)
 .. I CAGE<19,VSDTM<BDATE19 Q
 .. I CAGE>49,VSDTM<BDATE50 Q
 .. S RESULTS=@TMDATA@(DFN,"V",VSDTM)
 .. I CAGE<19 D  Q
 ... S HT=$P(RESULTS,"^",2),WT=$P(RESULTS,"^",1)
 ... I HT=""!(WT="") Q
 ... S HVISIT=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Height"),U,1)
 ... S HIEN=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Height"),U,3)
 ... S WVISIT=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Weight"),U,1)
 ... S WIEN=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Weight"),U,3)
 ... S QFL=1
 ... S WT=WT*.45359,HT=(HT*.0254),HT=(HT*HT),BMI=(WT/HT)
 ... S AGE=$$AGE^BQIAGE(DFN,$P(^AUPNVSIT(WVISIT,0),U,1)\1)
 ... S @TPGLOB@(DFN)=BMI_"^"_AGE_"^"_CAGE,QFL=1
 ... S $P(@TPGLOB@(DFN,"CRITERIA","BMI-Height","V",HVISIT,HIEN),U,1)=$P(^AUPNVSIT(HVISIT,0),U,1)
 ... S $P(@TPGLOB@(DFN,"CRITERIA","BMI-Weight","V",WVISIT,WIEN),U,1)=$P(^AUPNVSIT(WVISIT,0),U,1)
 .. I HT="" D
 ... S HT=$P(RESULTS,"^",2) I HT="" Q
 ... S HVISIT=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Height"),U,1)
 ... S HIEN=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Height"),U,3)
 ... I WT'="" Q
 ... I WT="" S WT=$P(RESULTS,"^",1) I WT="" Q
 ... S WVISIT=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Weight"),U,1)
 ... S WIEN=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Weight"),U,3)
 .. I WT="" D
 ... S WT=$P(RESULTS,"^",1) I WT="" Q
 ... S WVISIT=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Weight"),U,1)
 ... S WIEN=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Weight"),U,3)
 ... ;S AGE=$$AGE^BQIAGE(DFN,VSDTM)
 ... I HT'="" Q
 ... I HT="" S HT=$P(RESULTS,"^",2) I HT="" Q
 ... S HVISIT=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Height"),U,1)
 ... S HIEN=$P(@TMDATA@(DFN,"CRITERIA",VSDTM,"BMI-Height"),U,3)
 .. ;I HT'=""&(WT'="") Q
 .. I HT=""!(WT="") Q
 .. S WT=WT*.45359,HT=(HT*.0254),HT=(HT*HT),BMI=(WT/HT)
 .. S AGE=$$AGE^BQIAGE(DFN,$P(^AUPNVSIT(WVISIT,0),U,1)\1)
 .. S @TPGLOB@(DFN)=BMI_"^"_AGE_"^"_CAGE,QFL=1
 .. S $P(@TPGLOB@(DFN,"CRITERIA","BMI-Height","V",HVISIT,HIEN),U,1)=$P(^AUPNVSIT(HVISIT,0),U,1)
 .. S $P(@TPGLOB@(DFN,"CRITERIA","BMI-Weight","V",WVISIT,WIEN),U,1)=$P(^AUPNVSIT(WVISIT,0),U,1)
 K @TMDATA
 Q
