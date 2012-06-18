APCLD997 ; IHS/CMI/LAB - 1999 DIABETES AUDIT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in PLDMDXS
 ;
DIETEDUC(P,BDATE,EDATE)  ;EP
 ;first find any visit to a dietician or nutrition that is not a DNKA
 ;any diet education given?  with RD, both, other, no
 NEW D,BD,ED,X,Y,%DT,D,G,APCLVRD,V,APCL
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S D=9999999-ED,D=D+1
 F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D=""!(D>(9999999-BD))  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$P(^AUPNVSIT(V,0),U,11)
 ..Q:'$P(^AUPNVSIT(V,0),U,9)
 ..Q:'$D(^AUPNVPOV("AD",V))
 ..Q:'$D(^AUPNVPRV("AD",V))
 ..Q:$$DNKA(V)
 ..I $$PRIMPROV^APCLV(V,"D")=29 S APCLVRD(V)="" Q
 ..I $$PRIMPROV^APCLV(V,"D")="07" S APCLVRD(V)="" Q
 ..Q
 .Q
 K APCL
 S X=P_"^EDUC [DM AUDIT DIET EDUC TOPICS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 NEW APCLDED S X=0 F  S X=$O(APCL(X)) Q:X'=+X  S APCLDED($P(APCL(X),U,5))=""
 I '$D(APCLVRD),$D(APCLDED) Q "Yes (Non RD)"
 I $D(APCLVRD),'$D(APCLDED) Q "Yes (RD)"
 NEW G S (X,G)=0 F  S X=$O(APCLDED(X)) Q:X'=+X  I '$D(APCLVRD(X)) S G=1
 I G Q "Yes (RD & Non RD)"
 I $D(APCLVRD) Q "Yes (RD)"
 S G=0
 NEW T S T=$O(^ATXAX("B","DM AUDIT DIET EDUC TOPICS",0))
 I 'T Q "None"
 S X=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  I $$REFUSAL(P,9999999.09,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE) S G=1
 I G Q "Refused"
 Q "None"
EXEDUC(P,BDATE,EDATE) ;EP
 NEW APCL,X,E,%,G
 S X=P_"^EDUC [DM AUDIT EXERCISE EDUC TOPICS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "Yes"
 S G=0
 NEW T S T=$O(^ATXAX("B","DM AUDIT EXERCISE EDUC TOPICS",0))
 I 'T Q "No"
 S X=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  I $$REFUSAL(P,9999999.09,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE) S G=1
 Q $S(G:"Refused",1:"No")
OTHEDUC(P,BDATE,EDATE) ;EP
 NEW APCL,X,E,%
 S X=P_"^EDUC [DM AUDIT OTHER EDUC TOPICS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "Yes"
 S G=0
 NEW T S T=$O(^ATXAX("B","DM AUDIT OTHER EDUC TOPICS",0))
 I 'T Q "No"
 S X=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  I $$REFUSAL(P,9999999.09,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE) S G=1
 Q $S(G:"Refused",1:"No")
DFE(P,BDATE,EDATE) ;EP
 NEW APCL,%,E K APCL S %=P_"^LAST EXAM DIABETIC FOOT EXAM;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) Q "Yes-Diabetic Foot Exam-"_$$FMTE^XLFDT($P(APCL(1),U))
  ;now check any clinic 65
 K APCL
 S %=P_"^ALL VISITS;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 NEW X,Y,R S (X,Y)=0 F  S X=$O(APCL(X)) Q:X'=+X!(Y)  S R=$$PRIMPROV^APCLV($P(APCL(X),U,5),"D") I (R=33!(R=25)),'$$DNKA($P(APCL(X),U,5)) S Y=1
 I Y Q "Yes - Podiatrist Visit"
 S X=0,Y=0 F  S X=$O(APCL(X)) Q:X'=+X!(Y)  I $$CLINIC^APCLV($P(APCL(X),U,5),"C")=65,'$$DNKA($P(APCL(X),U,5)) S Y=1
 I Y Q "Yes - Podiatry Clinic visit"
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC FOOT EXAM, COMPLETE",0)),BDATE,EDATE)
 I G Q "Refused"
 Q "No"
DNKA(V) ;is this a DNKA visit?
 I '$G(V) Q ""
 NEW D,N S D=$$PRIMPOV^APCLV(V,"C")
 I D=".0860" Q 1
 S N=$$PRIMPOV^APCLV(V,"N")
 I $E(D)="V",N["DNKA" Q 1
 I $E(D)="V",N["DID NOT KEEP APPOINTMENT" Q 1
 I $E(D)="V",N["DID NOT KEEP APPT" Q 1
 Q 0
REFR(V) ;
 I '$G(V) Q ""
 NEW D,N S D=$$PRIMPOV^APCLV(V,"C")
 I D="367.89"!(D="367.9")!($E(D,1,5)=372.0)!($E(D,1,5)=372.1) Q 1
 Q 0
REFUSAL(P,F,I,B,E) ;EP
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(B)="" Q ""
 I $G(E)="" Q ""
 NEW G,X,Y,%DT S X=B,%DT="P" D ^%DT S B=Y
 S X=E,%DT="P" D ^%DT S E=Y
 S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,F,I,X)) Q:X'=+X!(G)  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,F,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S G=1
 Q G
EYE(P,BDATE,EDATE) ;EP
 NEW APCL,%,E K APCL S %=P_"^LAST EXAM DIABETIC EYE EXAM;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) Q "Yes-Diabetic Eye Exam-"_$$FMTE^XLFDT($P(APCL(1),U))
 S %=P_"^ALL VISITS;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 NEW X,Y,R S (X,Y)=0 F  S X=$O(APCL(X)) Q:X'=+X!(Y)  S R=$$PRIMPROV^APCLV($P(APCL(X),U,5),"D") I (R=24!(R=79)!(R="08")),'$$DNKA($P(APCL(X),U,5)),'$$REFR($P(APCL(X),U,5)) S Y=1
 I Y Q "Yes - Optometrist/Opthamalogist Visit"
 S X=0,Y=0 F  S X=$O(APCL(X)) Q:X'=+X!(Y)  S R=$$CLINIC^APCLV($P(APCL(X),U,5),"C") I (R=17!(R=18)!(R=64)!(R="A2")),'$$DNKA($P(APCL(X),U,5)),'$$REFR($P(APCL(X),U,5)) S Y=1
 I Y Q "Yes - Optometry/Opthamology Clinic visit"
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC EYE EXAM",0)),BDATE,EDATE)
 I G Q "Refused"
 Q "No"
DENTAL(P,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 NEW APCL,%,E
 K APCL
 S %=P_"^LAST EXAM DENTAL;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 S %=$P($G(APCL(1)),U)
 I %]"" Q "Yes-Dental Exam-"_$$FMTE^XLFDT(%)
 K APCL
 S %=P_"^ALL VISITS;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 NEW X,Y S X=0,Y="" F  S X=$O(APCL(X)) Q:X'=+X!(Y]"")  I $$CLINIC^APCLV($P(APCL(X),U,5),"C")=56,'$$DNKA($P(APCL(X),U,5)) S Y=$$FMTE^XLFDT($P(APCL(X),U))
 I Y]"" Q "Yes-Dental Clinic visit-"_Y
 NEW X,Y S X=0,Y="" F  S X=$O(APCL(X)) Q:X'=+X!(Y]"")  I $$PRIMPROV^APCLV($P(APCL(X),U,5),"D")=52,'$$DNKA($P(APCL(X),U,5)) S Y=$$FMTE^XLFDT($P(APCL(X),U))
 I Y]"" Q "Yes-Dentist Visit-"_$$FMTE^XLFDT(Y)
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DENTAL EXAM",0)),BDATE,EDATE)
 I G Q "Refused"
 Q "No"
BPS(P,BDATE,EDATE,F) ;EP ;
 I $G(F)="" S F="E"
 NEW X,APCL,E,APCLL,APCLLL,APCLV
 S APCLLL=0,APCLV=""
 K APCL
 S X=P_"^LAST 50 MEAS BP;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 S APCLL=0 F  S APCLL=$O(APCL(APCLL)) Q:APCLL'=+APCLL!(APCLLL=3)  S APCLBP=$P($G(APCL(APCLL)),U,2) D
 .Q:$$CLINIC^APCLV($P(APCL(APCLL),U,5),"C")=30
 .S APCLLL=APCLLL+1
 .I F="E" S $P(APCLV,";",APCLLL)=APCLBP_"  "_$$FMTE^XLFDT($P(APCL(APCLL),U))
 .I F="I" S $P(APCLV,";",APCLLL)=$P(APCLBP," ")
 Q APCLV
HTNDX(P,EDATE) ;EP - is HTN on problem list
 I '$G(P) Q ""
 I '$D(^DPT(P)) Q ""
 NEW %,APCL,E
 K APCL
 S %=P_"^PROBLEM [DM AUDIT PROBLEM HTN DIAGNOSES" S E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) Q "Yes"
 K APCL
 S X=P_"^LAST 3 DX [SURVEILLANCE HYPERTENSION;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(") I $D(APCL(3)) Q "Yes"
 Q "No"
LASTHT(P,EDATE,F) ;PEP - return last ht and date
 I 'P Q ""
 I $G(F)="" S F="E"
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW %,APCLARRY,H,E
 S %=P_"^LAST MEAS HT;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_EDATE NEW X S E=$$START1^APCLDF(%,"APCLARRY(") S H=$P($G(APCLARRY(1)),U,2)
 I H="" Q H
 S H=$J(H,2,0)
 I F="I" Q H
 Q H_" inches "_$$FMTE^XLFDT($P(APCLARRY(1),U))
LASTWT(P,EDATE,F) ;PEP - return last wt
 I 'P Q ""
 I $G(F)="" S F="E"
 NEW %,APCLARRY,E,APCLW,X,APCLN,APCL,APCLD,APCLZ,APCLX
 NEW APCLV221 S APCLV221=$O(^ICD9("BA","V22.1 ",""))
 K APCL S APCLW="" S APCLX=P_"^LAST 24 MEAS WT;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_EDATE S E=$$START1^APCLDF(APCLX,"APCL(")
 S APCLN=0 F  S APCLN=$O(APCL(APCLN)) Q:APCLN'=+APCLN!(APCLW]"")  D
 . S APCLZ=$P(APCL(APCLN),U,5)
 . I '$D(^AUPNVPOV("AD",APCLZ)) S APCLW=$P(APCL(APCLN),U,2)_" lbs "_$$FMTE^XLFDT($P(APCL(APCLN),U)) Q
 . S APCLD=0 F  S APCLD=$O(^AUPNVPOV("AD",APCLZ,APCLD)) Q:'APCLD!(APCLW]"")  D
 .. I $P(^AUPNVPOV(APCLD,0),U)'=APCLV221 S APCLW=$P(APCL(APCLN),U,2)_" lbs "_$$FMTE^XLFDT($P(APCL(APCLN),U))
 ..Q
 Q $S(F="E":APCLW,1:+APCLW)
CMSFDX(P,R,T) ;EP - return date/dx of dm in register
 I '$G(P) Q ""
 I '$G(R) Q ""
 I $G(T)="" Q ""
 NEW D1,Y,X,D,G S (G,X)=0,(D,Y)="" F  S X=$O(^ACM(44,"C",P,X)) Q:X'=+X!(G)  I $P(^ACM(44,X,0),U,4)=R D
 .S D=$P($G(^ACM(44,X,"SV")),U,2),D1=D,D=$$FMTE^XLFDT(D)
 .S Y=$$VAL^XBDIQ1(9002244,X,.01)
 Q $S(T="D":$G(D),T="DX":$G(Y),T="ID":$G(D1),1:"")
 ;
PLDMDOO(P,F) ;EP
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .I $$ICD^ATXCHK(I,T,9) D
 ..I $P(^AUPNPROB(X,0),U,13)]"" S D($P(^AUPNPROB(X,0),U,13))=""
 ..Q
 .Q
 S D=$O(D(0)) Q $S(F="E":$$FMTE^XLFDT(D),1:$O(D(0)))
PLDMDXS(P) ;EP - get all DM dxs from problem list
 I '$G(P) Q ""
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q "<diabetes taxonomy missing>"
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .;I $$ICD^ATXCHK(I,T,9) S:D]"" D=D_";" S D=D_$P(^ICD9(I,0),U)  ;cmi/anch/maw 9/10/2007 orig line
 .I $$ICD^ATXCHK(I,T,9) S:D]"" D=D_";" S D=D_$P($$ICDDX^ICDCODE(I),U,2)  ;cmi/anch/maw 9/10/2007 csv
 .Q
 Q D
 ;
FRSTDMDX(P,F) ;EP return date of first dm dx
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW X,E,APCL,Y
 S Y="APCL("
 S X=P_"^FIRST DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y) S Y=$P($G(APCL(1)),U)
 Q $S(F="E":$$FMTE^XLFDT(Y),1:Y)
LASTDMDX(P,D) ;EP - last pcc dm dx
 I '$G(P) Q ""
 NEW X,E,APCL,Y
 S Y="APCL("
 S X=P_"^LAST DX [DM AUDIT TYPE II DXS;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_D S E=$$START1^APCLDF(X,Y)
 I $D(APCL(1)) Q "Type 2"
 K APCL S X=P_"^LAST DX [DM AUDIT TYPE I DXS;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_D S E=$$START1^APCLDF(X,Y)
 I $D(APCL(1)) Q "Type 1"
 Q ""
 ;
CESS(P,B,D) ;EP - find any cessation hf in 12 months before E
 I '$G(P) Q ""
 NEW APCL,E,X
 K APCL
 S X=P_"^LAST HEALTH [DM AUDIT CESSATION HLTH FACTOR;DURING "_B_"-"_D S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "Yes-"_$$FMTE^XLFDT($P(APCL(1),U))
 S X=P_"^EDUC [DM AUDIT SMOKING CESS EDUC;DURING "_B_"-"_E S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "Yes-"_$$FMTE^XLFDT($P(APCL(1),U))
 Q "No"
