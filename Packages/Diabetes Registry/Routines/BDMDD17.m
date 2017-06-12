BDMDD17 ; IHS/CMI/LAB - 2016 DIABETES AUDIT ; 03 Nov 2015  9:29 AM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
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
 ..I $$PRIMPROV^APCLV(V,"D")=29 S BDMVRD(V)="",BDMV=BDMV_" RD: "_$P(^DIC(7,$O(^DIC(7,"D",29,0)),0),U)_" Visit: "_$$DATE^BDMS9B1($$VD^APCLV(V))_" " Q
 ..I $$PRIMPROV^APCLV(V,"D")="07" S BDMVRD(V)="",BDMV=BDMV_" RD: "_$P(^DIC(7,$O(^DIC(7,"D","07",0)),0),U)_" Visit: "_$$DATE^BDMS9B1($$VD^APCLV(V))_" " Q
 ..I $$PRIMPROV^APCLV(V,"D")="34" S BDMVRD(V)="",BDMV=BDMV_" RD: "_$P(^DIC(7,$O(^DIC(7,"D",34,0)),0),U)_" Visit: "_$$DATE^BDMS9B1($$VD^APCLV(V))_" " Q
 ..;now check povs for V65.3 and label as non-rd
 ..;change this to check to see if in BGP DIETARY SURVEILLANCE DXS TAXONOMY calls are $$ICD^ATXCH(code)
 ..;S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  I $$VAL^XBDIQ1(9000010.07,X,.01)="V65.3" S NRD=1,BDMV=BDMV_"NRD: V65.3 Dx: "_$$DATE^BDMS9B1($$VD^APCLV(V))_" "
 ..N TAX
 ..S TAX=$O(^ATXAX("B","BGP DIETARY SURVEILLANCE DXS",0))
 ..;S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  I $$ICD^ATXCHK($$VALI^XBDIQ1(9000010.07,X,.01),TAX,9) S NRD=1,BDMV=BDMV_"NRD: "_$$VAL^XBDIQ1(9000010.07,X,.01)_" Dx: "_$$DATE^BDMS9B1($$VD^APCLV(V))_" "  ;p8 ICD-10
 ..S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  I $$ICD^BDMUTL($$VALI^XBDIQ1(9000010.07,X,.01),$P(^ATXAX(TAX,0),U),9) S NRD=1,BDMV=BDMV_"NRD: "_$$VAL^XBDIQ1(9000010.07,X,.01)_" Dx: "_$$DATE^BDMS9B1($$VD^APCLV(V))_" "  ;p8 ICD-10
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  S Z=$$VAL^XBDIQ1(9000010.18,X,.01) I Z=97802!(Z=97803)!(Z=97804) S RD=1,BDMV=BDMV_"RD: CPT "_Z_" "_$$DATE^BDMS9B1($$VD^APCLV(V))_" "
 ..;now check for education topics
 ..S T=$O(^ATXAX("B","DM AUDIT DIET EDUC TOPICS",0))
 ..S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  S Y=$P($G(^AUPNVPED(X,0)),U) D
 ...Q:'Y
 ...Q:'$D(^AUTTEDT(Y,0))
 ...I T,$D(^ATXAX(T,21,"B",Y)) S Z=$$PC(X) D  Q
 ....I Z="07"!(Z=29)!(Z=34) S RD=1,BDMV=BDMV_"RD: "_$P(^AUTTEDT(Y,0),U,2)_" "_$$DATE^BDMS9B1($$VD^APCLV(V))_" " Q
 ....S NRD=1,BDMV=BDMV_"NRD: "_$P(^AUTTEDT(Y,0),U,2)_" "_$$DATE^BDMS9B1($$VD^APCLV(V))_" "
 ...S J=$P(^AUTTEDT(Y,0),U,2) I $P(J,"-",2)="N"!($P(J,"-",2)="DT")!($P(J,"-")="MNT")!($P(J,"-",2)="MNT")!($P(J,"-")="DMCN") S Z=$$PC(X) D  Q
 ....I Z="07"!(Z=29)!(Z=34) S RD=1,BDMV=BDMV_"RD: "_$P(^AUTTEDT(Y,0),U,2)_" "_$$DATE^BDMS9B1($$VD^APCLV(V))_" " Q
 ....S NRD=1,BDMV=BDMV_"NRD: "_$P(^AUTTEDT(Y,0),U,2)_" "_$$DATE^BDMS9B1($$VD^APCLV(V))_" "
 ..Q
 .Q
 I $D(BDMVRD) S RD=1 ;a RD visit so a hit
 S G=0
 I RD!(NRD) Q $S(RD+NRD=2:"3  Yes (RD & Non RD - Other) "_U_BDMV,RD:"1  Yes (RD) "_BDMV,1:"2  Yes (Non RD) "_BDMV)
 Q "4  None"  ;_$S(G:" - Not Medically Indicated",1:"")
PC(V) ;return provider discipline of educ provider
 I 'V Q ""
 NEW X S X=$P(^AUPNVPED(V,0),U,5)
 I 'X Q ""
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
 S X=P_"^LAST DX [BGP EXERCISE COUNSELING DXS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")  ;p8 ICD-10
 I $D(BDM(1)) Q "1  Yes  POV: "_$P(BDM(1),U,3)_"  "_$$DATE^BDMS9B1($P(BDM(1),U))
 Q "2  No"
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
 .I $P(T,"-",1)="MNT" Q
 .I $P(T,"-",2)="DT" Q
 .I $P(T,"-",1)="DMCN" Q
 .I TX,$D(^ATXAX(TX,21,"AA",J)) S G="1  Yes "_T_"  "_$$DATE^BDMS9B1($$VD^APCLV($P(^AUPNVPED(I,0),U,3),"I"))
 .I $P(T,"-",1)="DM"!($P(T,"-",1)="DMC") S G="1  Yes "_T_"  "_$$DATE^BDMS9B1($$VD^APCLV($P(^AUPNVPED(I,0),U,3),"I")) Q
 .N CODE
 .S CODE=$P($$CODEN^BDMUTL($P(T,"-",1),80),"~")
 .I CODE>0 D  Q
 ..N TAX
 ..S TAX=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 ..I $$ICD^BDMUTL(CODE,$P(^ATXAX(TAX,0),U),9) S G="1  Yes "_T_"  "_$$DATE^BDMS9B1($$VD^APCLV($P(^AUPNVPED(I,0),U,3),"I"))
 .I $P(T,"-",1)]"",$$SNOMED^BDMUTL(2016,"DIABETES DIAGNOSES",$P(T,"-",1)) S G="1  Yes "_T_"  "_$$DATE^BDMS9B1($$VD^APCLV($P(^AUPNVPED(I,0),U,3),"I"))
 I G Q G
 Q "2  No"  ;_$S(G:" - Not Medically Indicated",1:"")
 ;
DFE(P,BDATE,EDATE,F,R) ;EP - FOOT EXAM
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 I $G(F)="" S F="E"
 NEW BDMY,BDMV,%,LASTI,A,D,V,G,PROV,E,T,PROVI,G
 S LASTI=""
 S BDMY(1)=$$LASTDFE^APCLAPI2(P,BDATE,EDATE,"D")
 I BDMY(1) S LASTI=$P(BDMY(1),U)_U_"1  Yes  "_$$DATE^BDMS9B1($P(BDMY(1),U))_" Diabetic Foot Exam"
 S G=$$LASTCPTT^BDMAPIU(P,BDATE,EDATE,"DM AUDIT CPT FOOT EXAM","E")
 I G,$P(BDMY(1),U)<$P(G,U,1) S LASTI=$P(G,U,1)_U_"1  Yes  "_$$DATE^BDMS9B1($P(G,U,1))_" "_$P(G,U,2)
 I LASTI]"",F="H" Q $P(LASTI,U,2)  ;in supplement
 I F="E",LASTI]"" Q $P(LASTI,U,2)  ; if in audit and has exam display it
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
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe  ",1:"Yes  ")_$$DATE^BDMS9B1($P(G,U))_"  "_$P(^DIC(7,PROVI,0),U,1)_" visit"
 S (D,V)=0,G=""
 F  S D=$O(BDMY(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMY(D,V)) Q:V'=+V!(G)  D
 .Q:$$DNKA(V)
 .Q:$P(^AUPNVSIT(V,0),U,7)="C"
 .Q:$$CLINIC^APCLV(V,"C")=52
 .S PROV=$$CLINIC^APCLV(V,"C"),PROVI=$$CLINIC^APCLV(V,"I") I PROV=65!(PROV="B7") S G=9999999-D
 I G]"" D
 .Q:$P(LASTI,U)>G
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe ",1:"Yes  ")_$$DATE^BDMS9B1($P(G,U))_"  "_$P(^DIC(40.7,PROVI,0),U,1)_" clinic visit"
 ;
 I $G(R) K T Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))  ;no refusals
 ;
 I LASTI]"" K T Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))
 ;
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC FOOT EXAM, COMPLETE",0)),BDATE,EDATE,"N")
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
 NEW D,N S D=$$PRIMPOV^APCLV(V,"I")
 I D="" Q 0
 ;change this to look at the DM AUDIT REFRACTION taxonomy
 N TAX
 S TAX=$O(^ATXAX("B","DM AUDIT REFRACTION DXS",0))
 ;I $$ICD^ATXCHK(D,TAX,9) Q 1
 I $$ICD^BDMUTL(D,$P(^ATXAX(TAX,0),U),9) Q 1  ;cmi/maw 05/15/2014 p8
 ;I D="367.89"!(D="367.9")!($E(D,1,5)=372.0)!($E(D,1,5)=372.1) Q 1
 Q 0
 ;
REFUSAL(P,F,I,B,E,T) ;EP
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(B)="" Q ""
 I $G(E)="" Q ""
 NEW G,X,Y,%DT,R S X=B,%DT="P" D ^%DT S B=Y
 S X=E,%DT="P" D ^%DT S E=Y
 S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,F,I,X)) Q:X'=+X!(G)  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,F,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) D
 .I $G(T)]"",T'=$P(^AUPNPREF(Y,0),U,7) Q
 .S G=1_"^"_$P(^AUPNPREF(Y,0),U,7)_U_$$DATE^BDMS9B1($P(^AUPNPREF(Y,0),U,3))_U_$$VAL^XBDIQ1(9000022,Y,.04)_U_$$VAL^XBDIQ1(9000022,Y,.07)_U_$$VAL^XBDIQ1(9000022,Y,.01)_U_$P(^AUPNPREF(Y,0),U,3)
 Q G
 ;
EYE(P,BDATE,EDATE,F,R) ;EP
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 I $G(F)="" S F="E"
 NEW BDMY,BDMV,%,LASTI,BD,ED,T,D,%,Y,X,G,V,PROV,T,PROVI
 S LASTI=$$LASTITEM^APCLAPIU(P,"03","EXAM",BDATE,EDATE,"D")
 I LASTI]"" S $P(LASTI,U,2)="1  Yes  "_$$DATE^BDMS9B1($P(LASTI,U))_" Diabetic Eye Exam" ; I F="H"!(F="D") Q LASTI
 I F="E",LASTI]"" Q $P(LASTI,U,2)  ; if in audit and has exam display it
 ;
 S X=$$LASTCPTT^BDMAPIU(P,BDATE,EDATE,"DM AUDIT EYE EXAM CPTS","E")
 I $P(X,U)>$P(LASTI,U) S LASTI=$P(X,U)_U_"1  Yes  "_$$DATE^BDMS9B1($P(X,U))_" "_$P(X,U,2) ;I F="H"!(F="D") Q LASTI
 K BDMV,BDMY
 I F="E",LASTI]"" Q $P(LASTI,U,2)
 ;
 S X=$$LASTPRCT^BDMAPIU(P,BDATE,EDATE,"DM AUDIT EYE EXAM PROCS","A")
 I $P(X,U)>$P(LASTI,U) S LASTI=$P(X,U)_U_"1  Yes  "_$$DATE^BDMS9B1($P(X,U,1))_" "_$P(X,U,2)
 I F="D" Q $P(LASTI,U)
 I LASTI,F="H" Q $P(LASTI,U,2)
 I LASTI,F="E" Q $P(LASTI,U,2)
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
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe",1:"Yes")_" "_$$DATE^BDMS9B1($P(G,U))_"  "_$P(^DIC(7,PROVI,0),U,1)_" Visit  "
 S (D,V)=0,G=""
 F  S D=$O(BDMY(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMY(D,V)) Q:V'=+V!(G)  D
 .Q:$$DNKA(V)
 .Q:$P(^AUPNVSIT(V,0),U,7)="C"
 .Q:$$CLINIC^APCLV(V,"C")=52
 .S PROV=$$CLINIC^APCLV(V,"C"),PROVI=$$CLINIC^APCLV(V,"I") I PROV=17!(PROV=18)!(PROV=64)!(PROV="A2"),'$$REFR(V) S G=9999999-D
 I G]"" D
 .Q:$P(LASTI,U)>G
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe",1:"Yes")_"  "_$$DATE^BDMS9B1($P(G,U))_" "_$P(^DIC(40.7,PROVI,0),U,1)_" Clinic Visit "
 ;
 I $G(R) Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))  ;no refusals
 ;
 I LASTI]"" Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))
 ;
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC EYE EXAM",0)),BDATE,EDATE,"N")
 Q "2  No"_$S(G:" - Not Medically Indicated",1:"")
 ;
DENTAL(P,BDATE,EDATE,F,R) ;EP
 NEW BDMY,BDMV,%,LASTI,BD,ED,T,D,%,Y,X,G,V,PROV
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 I $G(F)="" S F="E"
 S LASTI=$$LASTDENT^APCLAPI2(P,BDATE,EDATE,"D")
 I LASTI]"" S $P(LASTI,U,2)="1  Yes  "_$$DATE^BDMS9B1($P(LASTI,U))_" Dental Exam" I F="H" Q LASTI
 I F="E",LASTI]"" Q $P(LASTI,U,2)  ; if in audit and has exam display it
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
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe",1:"Yes")_" "_$$DATE^BDMS9B1($P(G,U))_"  Dentist Visit  "
 S (D,V)=0,G=""
 F  S D=$O(BDMY(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMY(D,V)) Q:V'=+V!(G)  S PROV=$$CLINIC^APCLV(V,"C") I PROV=56,$$ADA(V),$O(^AUPNVDEN("AD",V,0)),'$$DNKA(V) S G=9999999-D
 I G]"" D
 .Q:$P(LASTI,U)>G
 .S LASTI=G_U_"1  "_$S(F="H":"Maybe",1:"Yes")_" "_$$DATE^BDMS9B1($P(G,U))_" Dental Clinic Visit  "
 ;
 S (D,V)=0,G=""
 F  S D=$O(BDMY(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMY(D,V)) Q:V'=+V!(G)  I $$DCPT(V) S G=9999999-D
 I G]"" D
 .Q:$P(LASTI,U)>G
 .S LASTI=G_U_"1  Yes"_"  "_$$DATE^BDMS9B1($P(G,U))_" Dental CPT  "
 ;
 I $G(R) Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))  ;no refusals
 ;
 I LASTI]"" Q $S(F="D":$P(LASTI,U),1:$P(LASTI,U,2))
 ;
 NEW G S G=$$REFUSAL(P,9999999.15,$O(^AUTTEXAM("B","DENTAL EXAM",0)),BDATE,EDATE,"N")
 Q "2  No"_$S(G:" - Not Medically Indicated",1:"")
DCPT(V) ;
 NEW A,B,C
 S B=""
 S A=0 F  S A=$O(^AUPNVCPT("AD",V,A)) Q:A'=+A!(B)  D
 .I $$ICD^BDMUTL($P($G(^AUPNVCPT(A,0)),U,1),"DM AUDIT DENTAL EXAM CPTS",1) S B=1
 Q B
