APCLD317 ; IHS/CMI/LAB - 2003 DIABETES AUDIT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
DIETEDUC(P,BDATE,EDATE)  ;EP
 NEW D,BD,ED,X,Y,%DT,D,G,APCLVRD,V,APCL,RD,NRD
 S (RD,NRD)=""
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S D=9999999-ED,(RD,NRD)="" ;is this right???
 F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D=""!(D>(9999999-BD))  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$P(^AUPNVSIT(V,0),U,11)
 ..Q:'$P(^AUPNVSIT(V,0),U,9)
 ..Q:'$D(^AUPNVPOV("AD",V))
 ..Q:'$D(^AUPNVPRV("AD",V))
 ..Q:$$DNKA(V)
 ..Q:$P(^AUPNVSIT(V,0),U,7)="C"
 ..Q:$$CLINIC^APCLV(V,"C")=52
 ..I $$PRIMPROV^APCLV(V,"D")=29 S APCLVRD(V)="" Q
 ..I $$PRIMPROV^APCLV(V,"D")="07" S APCLVRD(V)="" Q
 ..I $$PRIMPROV^APCLV(V,"D")="34" S APCLVRD(V)="" Q
 ..Q
 .Q
 I $D(APCLVRD) S RD=1 ;a RD visit so a hit
 K APCL
 S X=P_"^EDUC [DM AUDIT DIET EDUC TOPICS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 NEW APCLDED S X=0 F  S X=$O(APCL(X)) Q:X'=+X  S APCLDED($P(APCL(X),U,5))=$$PC(+$P(APCL(X),U,4))
 S X=0 F  S X=$O(APCLDED(X)) Q:X'=+X  D
 .I APCLDED(X)="07"!(APCLDED(X)=29)!(APCLDED(X)=34) S RD=1 Q
 .I '$D(APCLVRD(X)) S NRD=1 ;a topic with this is not an provider documented, no RD visit
 S G=0
 I RD!(NRD) Q $S(RD+NRD=2:"Yes (RD & Non RD - Other)",RD:"Yes (RD)",1:"Yes (Non RD)")
 NEW T S T=$O(^ATXAX("B","DM AUDIT DIET EDUC TOPICS",0))
 I 'T Q "None"
 S (X,G)=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL(P,9999999.09,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 Q "None"_$S(G:" - Not Medically Indicated",1:"")
PC(V) ;return provider discipline of educ provider
 I 'V Q ""
 NEW X S X=$P(^AUPNVPED(V,0),U,5)
 I 'X Q ""
 ;IHS/CMI/LAB patch 11 01/11/2002
 I $P(^DD(9000010.16,.05,0),U,2)[200 Q $$PROVCLSC^XBFUNC1(X)
 NEW A S A=$P(^DIC(6,X,0),U,4)
 I 'A Q ""
 Q $P($G(^DIC(7,A,9999999)),U)
EXEDUC(P,BDATE,EDATE) ;EP
 NEW APCL,X,E,%,G
 S X=P_"^EDUC [DM AUDIT EXERCISE EDUC TOPICS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "Yes"
 S G=0
 NEW T S T=$O(^ATXAX("B","DM AUDIT EXERCISE EDUC TOPICS",0))
 I 'T Q "No"
 S X=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL(P,9999999.09,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 Q "No"_$S(G:" - Not Medically Indicated",1:"")
OTHEDUC(P,BDATE,EDATE) ;EP
 NEW APCL,X,E,%
 S X=P_"^EDUC [DM AUDIT OTHER EDUC TOPICS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "Yes"
 S G=0
 NEW T S T=$O(^ATXAX("B","DM AUDIT OTHER EDUC TOPICS",0))
 I 'T Q "No"
 S X=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL(P,9999999.09,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 Q "No"_$S(G:" - Not Medically Indicated",1:"")
DFE(P,BDATE,EDATE) ;EP
 NEW APCL,%,E,C K APCL S %=P_"^LAST EXAM DIABETIC FOOT EXAM;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) Q "Yes-Diabetic Foot Exam-"_$$FMTE^XLFDT($P(APCL(1),U))
 ;now check any clinic 65
 K APCL
 S %=P_"^ALL VISITS;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 NEW X,Y,R S (X,Y)=0 F  S X=$O(APCL(X)) Q:X'=+X!(Y)  S R=$$PRIMPROV^APCLV($P(APCL(X),U,5),"D") I (R=33!(R=25)!(R=84)),'$$DNKA($P(APCL(X),U,5)) S Y=1
 I Y Q "Yes - Podiatrist Visit"
 S X=0,Y=0 F  S X=$O(APCL(X)) Q:X'=+X!(Y)  S C=$$CLINIC^APCLV($P(APCL(X),U,5),"C") I C=65!(C="B7"),'$$DNKA($P(APCL(X),U,5)) S Y=1
 I Y Q "Yes - Podiatry Clinic visit"
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC FOOT EXAM, COMPLETE",0)),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 Q "No"_$S(G:" - Not Medically Indicated",1:"")
ADA(V) ;any ada other than 9991
 I '$G(V) Q ""
 NEW X,Y,Z,G
 S G="",X=0 F  S X=$O(^AUPNVDEN("AD",V,X)) Q:X'=+X!(G)  S Y=$P($G(^AUPNVDEN(X,0)),U) I Y,$D(^AUTTADA(Y,0)),$P(^AUTTADA(Y,0),U)'=9991 S G=1
 Q G
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
 S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,F,I,X)) Q:X'=+X!(G)  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,F,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S G=1_"^"_$P(^AUPNPREF(Y,0),U,7)
 Q G
EYE(P,BDATE,EDATE) ;EP
 NEW APCL,%,E K APCL S %=P_"^LAST EXAM DIABETIC EYE EXAM;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 I $D(APCL(1)) Q "Yes-Diabetic Eye Exam-"_$$FMTE^XLFDT($P(APCL(1),U))
 K APCL NEW BD,ED,T
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S T=$O(^ICPT("B",92250,0)),T1=$O(^ICPT("B",92012,0)),T2=$O(^ICPT("B",92014,0)),T3=$O(^ICPT("B",92015,0)),T4=$O(^ICPT("B",92004,0)),T5=$O(^ICPT("B",92002,0))
 I T,$D(^AUPNVCPT("AA",P,T)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="Yes-Fundus Photography-"_$$FMTE^XLFDT(D)
 ..Q
 .Q
T1 ;
 I T1,$D(^AUPNVCPT("AA",P,T1)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T1,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="Yes-Eye Exam/Est Pat-"_$$FMTE^XLFDT(D)
 ..Q
 .Q
T2 ;
 I T2,$D(^AUPNVCPT("AA",P,T2)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T2,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="Yes-CPT 92014-"_$$FMTE^XLFDT(D)
 ..Q
 .Q
T3 ;
 I T3,$D(^AUPNVCPT("AA",P,T3)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T3,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="Yes-CPT 92015-"_$$FMTE^XLFDT(D)
 ..Q
 .Q
T4 ;
 I T4,$D(^AUPNVCPT("AA",P,T4)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T4,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="Yes-CPT 92004-"_$$FMTE^XLFDT(D)
 ..Q
 .Q
T5 ;
 I T5,$D(^AUPNVCPT("AA",P,T5)) S %="" D  I %]"" Q %
 .S E=0 F  S E=$O(^AUPNVCPT("AA",P,T5,E)) Q:E'=+E!(%]"")  D
 ..S D=9999999-E ;date done
 ..I D>ED Q
 ..I D<BD Q
 ..S %="Yes-CPT 92002-"_$$FMTE^XLFDT(D)
 ..Q
 .Q
 S %=P_"^ALL VISITS;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 NEW X,Y,R S (X,Y)=0 F  S X=$O(APCL(X)) Q:X'=+X!(Y)  S R=$$PRIMPROV^APCLV($P(APCL(X),U,5),"D") I (R=24!(R=79)!(R="08")),'$$DNKA($P(APCL(X),U,5)),'$$REFR($P(APCL(X),U,5)) S Y=1
 I Y Q "Yes - Optometrist/Opthamalogist Visit"
 S X=0,Y=0 F  S X=$O(APCL(X)) Q:X'=+X!(Y)  S R=$$CLINIC^APCLV($P(APCL(X),U,5),"C") I (R=17!(R=18)!(R=64)!(R="A2")),'$$DNKA($P(APCL(X),U,5)),'$$REFR($P(APCL(X),U,5)) S Y=1
 I Y Q "Yes - Optometry/Opthamology Clinic visit"
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC EYE EXAM",0)),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 Q "No"_$S(G:" - Not Medically Indicated",1:"")
DENTAL(P,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 NEW APCL,%,E
 K APCL
 S %=P_"^LAST EXAM DENTAL;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 S %=$P($G(APCL(1)),U)
 I %]"" Q "Yes-Dental Exam-"_$$FMTE^XLFDT(%)
 K APCL
 S %=P_"^ALL VISITS;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 NEW X,Y S X=0,Y="" F  S X=$O(APCL(X)) Q:X'=+X!(Y]"")  I $$CLINIC^APCLV($P(APCL(X),U,5),"C")=56!($$CLINIC^APCLV($P(APCL(X),U,5),"C")="99"),$$ADA($P(APCL(X),U,5)),'$$DNKA($P(APCL(X),U,5)) S Y=$$FMTE^XLFDT($P(APCL(X),U))
 I Y]"" Q "Yes-Dental Clinic visit-"_Y
 S X=0,Y="" F  S X=$O(APCL(X)) Q:X'=+X!(Y]"")  I $$PRIMPROV^APCLV($P(APCL(X),U,5),"D")=52,$$ADA($P(APCL(X),U,5)),'$$DNKA($P(APCL(X),U,5)) S Y=$$FMTE^XLFDT($P(APCL(X),U))
 I Y]"" Q "Yes-Dentist Visit-"_$$FMTE^XLFDT(Y)
 S X=0,Y="" F  S X=$O(APCL(X)) Q:X'=+X!(Y]"")  I $$CLINIC^APCLV($P(APCL(X),U,5),"C")=56!($$CLINIC^APCLV($P(APCL(X),U,5),"C")="99"),'$$ADA($P(APCL(X),U,5)),$O(^AUPNVDEN("AD",$P(APCL(X),U,5),0)) S Y=1
 I Y Q "Refused"
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DENTAL EXAM",0)),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 Q "No"_$S(G:" - Not Medically Indicated",1:"")
