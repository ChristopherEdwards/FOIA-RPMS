BQITRCBP ;GDHD/HSD/ALA-CVD Blood Pressure ; 13 Jun 2016  9:01 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
 ;
BP(BQDFN,TMFRAME) ;EP
 ; If 2 of last 3 non-ER blood pressures in past 2 years are Systolic >140
 ; or Diastolic >90
 NEW X,DESC,TEXT,BQI,QFL,AGE,BCT
 S DESC="",TEXT=""
 S X=$$BP^BQITRUTL(TMFRAME,BQDFN)
 I 'X Q "0^No BPs in past 2 years"
 S AGE=$$AGE^BQIAGE(BQDFN)
 I AGE<60 S X=$$BP^BQITRUTL(TMFRAME,BQDFN,140,90,">")
 I AGE'<60 S X=$$BP^BQITRUTL(TMFRAME,BQDFN,150,90,">")
 I $P(X,U,2)'="" D
 . NEW NDATE
 . S QFL=0,BCT=0
 . F BQI=1:1:3 D  Q:QFL
 .. I $P($P(X,U,2),";",BQI)="No BPs in last 2 years" S TEXT=$P($P(X,U,2),";",BQI),QFL=1 Q
 .. ;S NDATE=$$FMTE^BQIUL1($P($P(X,U,2),";",BQI))_" ("_$P($P(X,U,5),";",BQI)_")",TEXT=TEXT_NDATE_";"
 .. S NDATE=$$FMTMDY^BQIUL1($P($P(X,U,2),";",BQI))_" ("_$P($P(X,U,5),";",BQI)_")",TEXT=TEXT_NDATE_";"
 .. I $P($P(X,U,2),";",BQI)="" S BCT=BCT+1
 I $P(X,U,1)=0,(3-BCT)<2 S DESC="Patient has less than 2 BPs in last 2 years" Q $P(X,U,1)_U_DESC
 I $P(X,U,1)=0,(3-BCT)>1 S DESC="2 of last 3 non-ER BP do not meet criteria ["_TEXT_"]" Q $P(X,U,1)_U_DESC
 I $P(X,U,1)=1 S DESC=DESC_$$PBP(DESC,X)
 Q $P(X,U,1)_U_DESC
 ;
PBP(NDESC,NX) ;EP - Parse Blood Pressure values
 NEW DATES,MIENS,DDSC,MDT,MVAL,MIEN
 S DATES=$P(NX,U,2),MIENS=$P(NX,U,3),DDSC=""
 F BQJ=1:1:$L(DATES,";") S MDT=$P(DATES,";",BQJ) Q:MDT=""  D
 . S MIEN=$P(MIENS,";",BQJ),MVAL=""
 . I MIEN'="" S MVAL=$$GET1^DIQ(9000010.01,MIEN_",",.04,"E")
 . ;S DDSC=DDSC_$$FMTE^BQIUL1(MDT)_" ("_MVAL_"); "
 . S DDSC=DDSC_$$FMTMDY^BQIUL1(MDT)_" ("_MVAL_"); "
 S DDSC=$$TKO^BQIUL1(DDSC,"; ")
 Q NDESC_" "_DDSC
 ;
NBP(BQDFN) ;EP
 ; If no blood pressures taken in past 2 years
 NEW X,DESC,TEXT,BQI,QFL,AGE,BCT
 S DESC="",TEXT=""
 S X=$$BP^BQITRUTL("T-12M",BQDFN)
 I 'X Q "1^No BPs in past year"
 Q 0
