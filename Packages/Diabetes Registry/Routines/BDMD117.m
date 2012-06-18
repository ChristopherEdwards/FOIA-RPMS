BDMD117 ; IHS/CMI/LAB - 2011 DIABETES AUDIT ; 13 Mar 2011  1:52 PM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**4**;JUN 14, 2007
DIETEDUC(P,BDATE,EDATE)  ;EP
 NEW D,BD,ED,X,Y,%DT,D,G,BDMVRD,V,BDM,RD,NRD,BDMV
 S (RD,NRD,BDMV)=""
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S D=9999999-ED,(RD,NRD)=""
 F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D=""!(D>(9999999-BD))  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$P(^AUPNVSIT(V,0),U,11)
 ..Q:'$P(^AUPNVSIT(V,0),U,9)
 ..Q:$$DNKA(V)
 ..Q:$P(^AUPNVSIT(V,0),U,7)="C"
 ..Q:$$CLINIC^APCLV(V,"C")=52
 ..I $$PRIMPROV^APCLV(V,"D")=29 S BDMVRD(V)="",BDMV=BDMV_" RD: "_$P(^DIC(7,$O(^DIC(7,"D",29,0)),0),U)_" Visit: "_$$VD^APCLV(V,"E")_" " Q
 ..I $$PRIMPROV^APCLV(V,"D")="07" S BDMVRD(V)="",BDMV=BDMV_" RD: "_$P(^DIC(7,$O(^DIC(7,"D","07",0)),0),U)_" Visit: "_$$VD^APCLV(V,"E")_" " Q
 ..I $$PRIMPROV^APCLV(V,"D")="34" S BDMVRD(V)="",BDMV=BDMV_" RD: "_$P(^DIC(7,$O(^DIC(7,"D",34,0)),0),U)_" Visit: "_$$VD^APCLV(V,"E")_" " Q
 ..;now check povs for V65.3 and label as non-rd
 ..S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  I $$VAL^XBDIQ1(9000010.07,X,.01)="V65.3" S NRD=1,BDMV=BDMV_"NRD: V65.3 Dx: "_$$VD^APCLV(V,"E")_" "
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  S Z=$$VAL^XBDIQ1(9000010.18,X,.01) I Z=97802!(Z=97803)!(Z=97804) S RD=1,BDMV=BDMV_"RD: CPT "_Z_" "_$$VD^APCLV(V,"E")_" "
 ..;now check for education topics
 ..S T=$O(^ATXAX("B","DM AUDIT DIET EDUC TOPICS",0))
 ..S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  S Y=$P($G(^AUPNVPED(X,0)),U) D
 ...Q:'Y
 ...Q:'$D(^AUTTEDT(Y,0))
 ...I T,$D(^ATXAX(T,21,"B",Y)) S Z=$$PC(X) D  Q
 ....I Z="07"!(Z=29)!(Z=34) S RD=1,BDMV=BDMV_"RD: "_$P(^AUTTEDT(Y,0),U,2)_" "_$$VD^APCLV(V,"E")_" " Q
 ....S NRD=1,BDMV=BDMV_"NRD: "_$P(^AUTTEDT(Y,0),U,2)_" "_$$VD^APCLV(V,"E")_" "
 ...S J=$P(^AUTTEDT(Y,0),U,2) I $P(J,"-",2)="N"!($P(J,"-",2)="DT")!($P(J,"-")="MNT")!($P(J,"-",2)="MNT") S Z=$$PC(X) D  Q
 ....I Z="07"!(Z=29)!(Z=34) S RD=1,BDMV=BDMV_"RD: "_$P(^AUTTEDT(Y,0),U,2)_" "_$$VD^APCLV(V,"E")_" " Q
 ....S NRD=1,BDMV=BDMV_"NRD: "_$P(^AUTTEDT(Y,0),U,2)_" "_$$VD^APCLV(V,"E")_" "
 ..Q
 .Q
 I $D(BDMVRD) S RD=1 ;a RD visit so a hit
 S G=0
 I RD!(NRD) Q $S(RD+NRD=2:"3  Yes (RD & Non RD - Other) "_U_BDMV,RD:"1  Yes (RD) "_BDMV,1:"2  Yes (Non RD) "_BDMV)
 NEW T S T=$O(^ATXAX("B","DM AUDIT DIET EDUC TOPICS",0))
 NEW G,X,Y,%DT S X=BDATE,%DT="P" D ^%DT S B=Y
 S X=EDATE,%DT="P" D ^%DT S E=Y
 S G=0
 S I=0 F  S I=$O(^AUPNPREF("AA",BDMPD,9999999.09,I)) Q:I'=+I!(G)  D
 .S A=0 I $D(^ATXAX(T,21,"B",I)) S A=1
 .S Z=$P($G(^AUTTEDT(I,0)),U,2) I $P(Z,"-",2)="N"!($P(Z,"-",2)="DT")!($P(Z,"-")="MNT")!($P(Z,"-",2)="MNT") S A=1
 .Q:'A
 .S X=0 F  S X=$O(^AUPNPREF("AA",BDMPD,9999999.09,I,X)) Q:X'=+X!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNPREF("AA",BDMPD,9999999.09,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S G=1_"^"_$P(^AUPNPREF(Y,0),U,7)_U_Y
 I G,$P(G,U,2)'="N" S Y=$P(G,U,3) Q "5  Refused "_$$VAL^XBDIQ1(9000022,Y,.04)_" "_$$VAL^XBDIQ1(9000022,Y,.03)_" "_$$VAL^XBDIQ1(9000022,Y,.07)
 Q "4  None"_$S(G:" - Not Medically Indicated",1:"")
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
 NEW BDM,X,E,%,G
 S X=P_"^LAST EDUC [DM AUDIT EXERCISE EDUC TOPICS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) Q "1  Yes  "_$P(BDM(1),U,3)_"  "_$$DATE^BDMS9B1($P(BDM(1),U,1))
 K BDM
 S X=P_"^ALL EDUC;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 S X=0,G=0 F  S X=$O(BDM(X)) Q:X'=+X!(G)  S I=+$P(BDM(X),U,4),E=$P($G(^AUPNVPED(I,0)),U),T=$P($G(^AUTTEDT(E,0)),U,2) I $P(T,"-",2)="EX" S G=1
 I G Q "1  Yes "_T_"  "_$$VD^APCLV($P(^AUPNVPED(I,0),U,3),"E")
 K BDM
 S X=P_"^LAST DX V65.41;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) Q "1  Yes  POV: "_$P(BDM(1),U,3)_"  "_$$DATE^BDMS9B1($P(BDM(1),U))
 S G=0
 NEW T S T=$O(^ATXAX("B","DM AUDIT EXERCISE EDUC TOPICS",0))
 NEW G,X,Y,%DT S X=BDATE,%DT="P" D ^%DT S B=Y
 S X=EDATE,%DT="P" D ^%DT S E=Y
 S G=0
 S I=0 F  S I=$O(^AUPNPREF("AA",BDMPD,9999999.09,I)) Q:I'=+I!(G)  D
 .S A=0 I $D(^ATXAX(T,21,"B",I)) S A=1
 .S Z=$P($G(^AUTTEDT(I,0)),U,2) I $P(Z,"-",2)="EX" S A=1
 .Q:'A
 .S X=0 F  S X=$O(^AUPNPREF("AA",BDMPD,9999999.09,I,X)) Q:X'=+X!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNPREF("AA",BDMPD,9999999.09,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S G=1_"^"_$P(^AUPNPREF(Y,0),U,7)_U_Y
 I G,$P(G,U,2)'="N" S Y=$P(G,U,3) Q "3  Refused "_$$VAL^XBDIQ1(9000022,Y,.04)_" "_$$VAL^XBDIQ1(9000022,Y,.03)_" "_$$VAL^XBDIQ1(9000022,Y,.07)
 Q "2  No"_$S(G:" - Not Medically Indicated",1:"")
OTHEDUC(P,BDATE,EDATE) ;EP
 NEW BDM,X,E,%,T,TX
 S TX=$O(^ATXAX("B","DM AUDIT OTHER EDUC TOPICS",0))
 K BDM
 S X=P_"^ALL EDUC;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 S X=0,G=0 F  S X=$O(BDM(X)) Q:X'=+X!(G)  D
 .S I=+$P(BDM(X),U,4)
 .S J=$P($G(^AUPNVPED(I,0)),U)
 .Q:'J
 .S T=$P($G(^AUTTEDT(J,0)),U,2)
 .I $P(T,"-",2)="EX" Q
 .I $P(T,"-",2)="N" Q
 .I $P(T,"-",2)="MNT" Q
 .I $P(T,"-",2)="DT" Q
 .I TX,$D(^ATXAX(TX,21,"AA",I)) S G="1  Yes "_T_"  "_$$VD^APCLV($P(^AUPNVPED(I,0),U,3),"E")
 .I $E($P(T,"-",1),1,3)="250"!($P(T,"-",1)="DM")!($P(T,"-",1)="DMC") S G="1  Yes "_T_"  "_$$VD^APCLV($P(^AUPNVPED(I,0),U,3),"E")
 I G Q G
 S X=BDATE,%DT="P" D ^%DT S B=Y
 S X=EDATE,%DT="P" D ^%DT S E=Y
 S G=""
 S I=0 F  S I=$O(^AUPNPREF("AA",BDMPD,9999999.09,I)) Q:I'=+I!(G)  D
 .S A=0
 .S Z=$P($G(^AUTTEDT(I,0)),U,2)
 .I $P(Z,"-",2)="EX" Q
 .I $P(Z,"-",2)="N" Q
 .I $P(Z,"-",2)="MNT" Q
 .I $P(Z,"-",2)="DT" Q
 .I $P(Z,"-",1)="MNT" Q
 .I $D(^ATXAX(TX,21,"B",I)) S A=1
 .I $E($P(Z,"-",1),1,3)="250"!($P(Z,"-",1)="DM")!($P(Z,"-",1)="DMC") S A=1
 .Q:'A
 .S X=0 F  S X=$O(^AUPNPREF("AA",BDMPD,9999999.09,I,X)) Q:X'=+X!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNPREF("AA",BDMPD,9999999.09,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S G=1_"^"_$P(^AUPNPREF(Y,0),U,7)_U_Y
 I G,$P(G,U,2)'="N" S Y=$P(G,U,3) Q "3  Refused "_$$VAL^XBDIQ1(9000022,Y,.04)_" "_$$VAL^XBDIQ1(9000022,Y,.03)_" "_$$VAL^XBDIQ1(9000022,Y,.07)
 Q "2  No"_$S(G:" - Not Medically Indicated",1:"")
 ;
DFE(P,BDATE,EDATE,F,R) ;EP - FOOT EXAM
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 I $G(F)="" S F="E"
 NEW BDMY,BDMV,%,LASTI,A,D,V,G,PROV,E,T,PROVI
 S LASTI=""
 S BDMY(1)=$$LASTDFE^APCLAPI2(P,BDATE,EDATE,"D")
 I BDMY(1) S LASTI=$P(BDMY(1),U)_U_"1  Yes - Diabetic Foot Exam - "_$$DATE^BDMS9B1($P(BDMY(1),U))
 ;now check any clinic 65 or prov 33/25
 ;
 K T
 S T="T"
 D ALLV^BDMAPIU(P,BDATE,EDATE,.T)
 ;reorder by date of visit/reverse order
 S %=0 F  S %=$O(T(%)) Q:%'=+%  S BDMY((9999999-$P(T(%),U)),$P(T(%),U,5))=T(%)
 N PROV,D,V,G
 S (D,V)=0,G=""
 F  S D=$O(BDMY(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMY(D,V)) Q:V'=+V!(G)  D
 .Q:$$DNKA(V)
 .Q:$P(^AUPNVSIT(V,0),U,7)="C"
 .Q:$$CLINIC^APCLV(V,"C")=52
 .S PROV=$$PRIMPROV^APCLV(V,"D"),PROVI=$$PRIMPROV^APCLV(V,"F") I (PROV=33!(PROV=25)!(PROV=84)) S G=9999999-D
 I G]"" D
 .Q:$P(LASTI,U)>G
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe",1:"Yes")_" - "_$P(^DIC(7,PROVI,0),U,1)_" Visit - "_$$DATE^BDMS9B1($P(G,U))
 S (D,V)=0,G=""
 F  S D=$O(BDMY(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMY(D,V)) Q:V'=+V!(G)  D
 .Q:$$DNKA(V)
 .Q:$P(^AUPNVSIT(V,0),U,7)="C"
 .Q:$$CLINIC^APCLV(V,"C")=52
 .S PROV=$$CLINIC^APCLV(V,"C"),PROVI=$$CLINIC^APCLV(V,"I") I PROV=65!(PROV="B7") S G=9999999-D
 I G]"" D
 .Q:$P(LASTI,U)>G
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe",1:"Yes")_" - "_$P(^DIC(40.7,PROVI,0),U,1)_" visit - "_$$DATE^BDMS9B1($P(G,U))
 ;
 I $G(R) Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))  ;no refusals
 ;
 I LASTI]"" Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))
 ;
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC FOOT EXAM, COMPLETE",0)),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "3  Refused - "_$P(G,U,3)
 Q "2  No"_$S(G:" - Not Medically Indicated",1:"")
 ;
ADA(V) ;any ada other than 9991
 I '$G(V) Q ""
 NEW X,Y,Z,G
 S G="",X=0 F  S X=$O(^AUPNVDEN("AD",V,X)) Q:X'=+X!(G)  S Y=$P($G(^AUPNVDEN(X,0)),U) I Y,$D(^AUTTADA(Y,0)),$P(^AUTTADA(Y,0),U)'=9991 S G=1
 Q G
DNKA(V) ;EP - is this a DNKA visit?
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
 ;
REFUSAL(P,F,I,B,E) ;EP
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(B)="" Q ""
 I $G(E)="" Q ""
 NEW G,X,Y,%DT,R S X=B,%DT="P" D ^%DT S B=Y
 S X=E,%DT="P" D ^%DT S E=Y
 S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,F,I,X)) Q:X'=+X!(G)  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,F,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) D
 .S G=1_"^"_$P(^AUPNPREF(Y,0),U,7)_U_$$DATE^BDMS9B1($P(^AUPNPREF(Y,0),U,3))_U_$$VAL^XBDIQ1(9000022,Y,.04)_U_$$VAL^XBDIQ1(9000022,Y,.07)_U_$$VAL^XBDIQ1(9000022,Y,.01)_U_$P(^AUPNPREF(Y,0),U,3)
 Q G
 ;
EYE(P,BDATE,EDATE,F,R) ;EP
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 I $G(F)="" S F="E"
 NEW BDMY,BDMV,%,LASTI,BD,ED,T,D,%,Y,X,G,V,PROV,T,PROVI
 S LASTI=$$LASTDEYE^APCLAPI2(P,BDATE,EDATE,"D")
 I LASTI]"" S $P(LASTI,U,2)="1  Yes - Diabetic Eye Exam - "_$$DATE^BDMS9B1($P(LASTI,U))
 ;
 S X=$$LASTCPTT^BDMAPIU(P,BDATE,EDATE,$O(^ATXAX("B","DM AUDIT EYE EXAM CPTS",0)),"E")
 I $P(X,U)>$P(LASTI,U) S LASTI=$P(X,U)_U_"1  Yes - "_$P(X,U,2)_" - "_$$DATE^BDMS9B1($P(X,U))
 K BDMV,BDMY
 ;
 K T
 S T="T"
 D ALLV^BDMAPIU(P,BDATE,EDATE,.T)
 ;reorder by date of visit/reverse order
 S %=0 F  S %=$O(T(%)) Q:%'=+%  S BDMY((9999999-$P(T(%),U)),$P(T(%),U,5))=T(%)
 N PROV,D,V,G
 S (D,V)=0,G=""
 F  S D=$O(BDMY(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMY(D,V)) Q:V'=+V!(G)  D
 .Q:$$DNKA(V)
 .Q:$P(^AUPNVSIT(V,0),U,7)="C"
 .Q:$$CLINIC^APCLV(V,"C")=52
 .S PROV=$$PRIMPROV^APCLV(V,"D"),PROVI=$$PRIMPROV^APCLV(V,"F") I (PROV=24!(PROV=79)!(PROV="08")),'$$REFR(V) S G=9999999-D
 I G]"" D
 .Q:$P(LASTI,U)>G
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe",1:"Yes")_" - "_$P(^DIC(7,PROVI,0),U,1)_" ("_PROV_") Visit - "_$$DATE^BDMS9B1($P(G,U))
 S (D,V)=0,G=""
 F  S D=$O(BDMY(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMY(D,V)) Q:V'=+V!(G)  D
 .Q:$$DNKA(V)
 .Q:$P(^AUPNVSIT(V,0),U,7)="C"
 .Q:$$CLINIC^APCLV(V,"C")=52
 .S PROV=$$CLINIC^APCLV(V,"C"),PROVI=$$CLINIC^APCLV(V,"I") I PROV=17!(PROV=18)!(PROV=64)!(PROV="A2"),'$$REFR(V) S G=9999999-D
 I G]"" D
 .Q:$P(LASTI,U)>G
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe",1:"Yes")_" - "_$P(^DIC(40.7,PROVI,0),U,1)_" ("_PROV_") Visit - "_$$DATE^BDMS9B1($P(G,U))
 ;
 I $G(R) Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))  ;no refusals
 ;
 I LASTI]"" Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))
 ;
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC EYE EXAM",0)),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "3  Refused - "_$P(G,U,3)
 Q "2  No"_$S(G:" - Not Medically Indicated",1:"")
 ;
DENTAL(P,BDATE,EDATE,F,R) ;EP
 NEW BDMY,BDMV,%,LASTI,BD,ED,T,D,%,Y,X,G,V,PROV
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 I $G(F)="" S F="E"
 S LASTI=$$LASTDENT^APCLAPI2(P,BDATE,EDATE,"D")
 I LASTI]"" S $P(LASTI,U,2)="1  Yes - Dental Exam - "_$$DATE^BDMS9B1($P(LASTI,U))
 ;
 K BDMV,BDMY
 ;
 K T
 S T="T"
 D ALLV^BDMAPIU(P,BDATE,EDATE,.T)
 ;reorder by date of visit/reverse order
 S %=0 F  S %=$O(T(%)) Q:%'=+%  S BDMY((9999999-$P(T(%),U)),$P(T(%),U,5))=T(%)
 N PROV,D,V,G
 S (D,V)=0,G=""
 F  S D=$O(BDMY(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMY(D,V)) Q:V'=+V!(G)  D
 .Q:$$DNKA(V)
 .Q:$P(^AUPNVSIT(V,0),U,7)="C"
 .Q:$$CLINIC^APCLV(V,"C")=52
 .S PROV=$$PRIMPROV^APCLV(V,"D") I PROV=52,$$ADA(V) S G=9999999-D
 I G]"" D
 .Q:$P(LASTI,U)>G
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe",1:"Yes")_" - Dentist Visit - "_$$DATE^BDMS9B1($P(G,U))
 S (D,V)=0,G=""
 F  S D=$O(BDMY(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMY(D,V)) Q:V'=+V!(G)  S PROV=$$CLINIC^APCLV(V,"C") I PROV=56,$$ADA(V),$O(^AUPNVDEN("AD",V,0)),'$$DNKA(V) S G=9999999-D
 I G]"" D
 .Q:$P(LASTI,U)>G
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe",1:"Yes")_" - Dental Clinic visit - "_$$DATE^BDMS9B1($P(G,U))
 ;
 I $G(R) Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))  ;no refusals
 ;
 I LASTI]"" Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))
 ;
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DENTAL EXAM",0)),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "3  Refused - "_$P(G,U,3)
 Q "2  No"_$S(G:" - Not Medically Indicated",1:"")
