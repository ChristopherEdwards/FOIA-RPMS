APCHS9B4 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ; 
 ;;2.0;IHS PCC SUITE;**2,5**;MAY 14, 2009
 ;
 ;cmi/anch/maw 8/27/2007 code set versioning in HYSTER, EYE
 ;
FRSTDMDX(P,F) ;EP return date of first dm dx
 I $G(F)="" S F="E"
 I '$G(P) Q ""
 NEW X,E,APCHS,Y
 S Y="APCHS("
 S X=P_"^FIRST DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y) S Y=$P($G(APCHS(1)),U)
 Q $S(F="E":$$FMTE^XLFDT(Y),1:Y)
CMSFDX(P,F) ;EP - return date/dx of dm in register
 I $G(F)="" S F="E"
 I '$G(P) Q ""
 ;NEW R S R=$O(^ACM(41.1,"B","IHS DIABETES",0)) I 'R Q ""
 NEW R,N,D,D1,Y,X,G S R=0,N="",D="" F  S N=$O(^ACM(41.1,"B",N)) Q:N=""!(D]"")  S R=0 F  S R=$O(^ACM(41.1,"B",N,R)) Q:R'=+R!(D]"")  I N["DIAB" D
 .S (G,X)=0,(D,Y)="" F  S X=$O(^ACM(44,"C",P,X)) Q:X'=+X!(D]"")  I $P(^ACM(44,X,0),U,4)=R D
 ..S D=$P($G(^ACM(44,X,"SV")),U,2) I D]"" S D1=D,D=$S(F="E":$$FMTE^XLFDT(D),1:D)
 Q $G(D)
 ;
PLDMDOO(P,F) ;EP get first dm dx from case management
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:$P(^AUPNPROB(X,0),U,12)'="D"
 .S I=$P(^AUPNPROB(X,0),U)
 .I $$ICD^ATXCHK(I,T,9) D
 ..I $P(^AUPNPROB(X,0),U,13)]"" S D($P(^AUPNPROB(X,0),U,13))=""
 ..Q
 .Q
 S D=$O(D(0))
 I D="" Q D
 Q $S(F="E":$$FMTE^XLFDT(D),1:D)
DNKA(V) ;EP is this a DNKA visit?
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
 I D="367.89"!(D="367.9") Q 1
 Q 0
DFE(P,APCHSED) ;EP
 NEW APCHY,APCHV,%,LDFE S LDFE="",%=P_"^LAST EXAM DIABETIC FOOT EXAM",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) S LDFE=$P(APCHY(1),U)
 I $D(APCHY(1)),$P(APCHY(1),U)'<APCHSED S APCHX="Yes   "_$$FMTE^XLFDT($P(APCHY(1),U))_" (Diabetic Foot Exam, Complete)" Q APCHX
 ;now check any clinic 65 or prov 33/25
 K APCHY,APCHV
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(APCHSED)_"-"_$$FMTE^XLFDT(DT),E=$$START1^APCLDF(%,"APCHY(")
 ;reorder by date of visit/reverse order
 S %=0 F  S %=$O(APCHY(%)) Q:%'=+%  S APCHV(9999999-$P(APCHY(%),U),$P(APCHY(%),U,5))=""
 N PROV,D,V,G S (D,V)=0,G="" F  S D=$O(APCHV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(APCHV(D,V)) Q:V'=+V!(G)  S PROV=$$PRIMPROV^APCLV(V,"D") I (PROV=33!(PROV=25)),'$$DNKA(V) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Visit to Podiatrist)"
 S (D,V)=0,G="" F  S D=$O(APCHV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(APCHV(D,V)) Q:V'=+V!(G)  S PROV=$$CLINIC^APCLV(V,"C") I PROV=65!(PROV="B7"),'$$DNKA(V) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Visit to Podiatry Clinic)"
 S G=$$REFDF^APCHS9B3(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC FOOT EXAM, COMPLETE",0)),$G(LDFE))
 I G]"" Q G
 Q "No    "_$S($D(LDFE):$$FMTE^XLFDT(LDFE),1:"")
 ;
EYE(P,APCHSED) ;EP
 NEW APCHY,LDEE,%,APCHEX S APCHEX=0 S LDEE="",%=P_"^LAST EXAM DIABETIC EYE EXAM",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) S LDEE=$P(APCHY(1),U),APCHEX=+$P(APCHY(1),U,4)
 I $P($G(APCHY(1)),U)'<APCHSED S APCHX="Yes   "_$$FMTE^XLFDT($P(APCHY(1),U))_" (Diabetic Eye Exam) result: "_$P($$VAL^XBDIQ1(9000010.13,+$P(APCHY(1),U,4),.04),"/",1) Q APCHX
 K APCHY S APCHCPT=""
 NEW T,C,APCHCPT,APCHCPT1
 F C=92250,92012,92014,92004,92002 S T=$O(^ICPT("B",C,0)) D
 .I T S APCHY=$O(^AUPNVCPT("AA",P,T,0)) I APCHY D  ;I APCHY D  I APCHY'<APCHSED Q "Yes   "_$$FMTE^XLFDT(APCHY)_" (Fundus Photography)"
 ..S APCHY=9999999-APCHY
 ..I LDEE<APCHY S LDEE=APCHY,APCHEX=0,APCHCPT=T,APCHCPT1=C
 ;I LDEE,LDEE'<APCHSED Q "Yes   "_$$FMTE^XLFDT(LDEE)_" (CPT "_APCHCPT1_"-"_$E($P(^ICPT(APCHCPT,0),U,2),1,28)_")"  ;cmi/anch/maw 8/28/2007 orig line
 I LDEE,LDEE'<APCHSED Q "Yes   "_$$FMTE^XLFDT(LDEE)_" (CPT "_APCHCPT1_"-"_$E($P($$CPT^ICPTCOD(APCHCPT,LDEE),U,3),1,28)_")"  ;cmi/anch/maw 8/28/2007 code set versioning
 ;now check any clinic 17 or 18
 K APCHY,APCHV
 S %=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(APCHSED)_"-"_$$FMTE^XLFDT(DT),E=$$START1^APCLDF(%,"APCHY(")
 ;reorder by date of visit/reverse order
 S %=0 F  S %=$O(APCHY(%)) Q:%'=+%  S APCHV(9999999-$P(APCHY(%),U),$P(APCHY(%),U,5))=""
 N PROV,D,V,G
 S (D,V)=0,G="" F  S D=$O(APCHV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(APCHV(D,V)) Q:V'=+V!(G)  S PROV=$$PRIMPROV^APCLV(V,"D") I (PROV=24!(PROV=79)!(PROV="08")),'$$DNKA(V),'$$REFR(V),$P(^AUPNVSIT(V,0),U,9) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Ophthalmologist or Optometrist Visit)"
 S (D,V)=0,G="" F  S D=$O(APCHV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(APCHV(D,V)) Q:V'=+V!(G)  S PROV=$$CLINIC^APCLV(V,"C") I (PROV=17!(PROV=18)!(PROV=64)),'$$DNKA(V),'$$REFR(V),$P(^AUPNVSIT(V,0),U,9) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Optometry or Ophthalmology Clinic)"
 S G=$$REFDF^APCHS9B3(P,9999999.15,$O(^AUTTEXAM("B","DIABETIC EYE EXAM",0)),$G(LDEE))
 I G]"" Q G
 S %="No    "_$S($D(LDEE):$$FMTE^XLFDT(LDEE),1:"")
 I APCHEX S %=%_" (Diabetic Eye Exam) result: "_$P($$VAL^XBDIQ1(9000010.13,APCHEX,.04),"/",1)
 Q %
PAP(P,APCHSED) ;EP
 I $$SEX^AUPNPAT(P)'="F" Q "N/A"
 S LPAP=$$LASTPAP^APCLAPI1(P)
 S G=$$REFDF^APCHS9B3(P,60,$O(^LAB(60,"B","PAP SMEAR",0)),$G(LPAP))
 I G]"" Q $G(LPAP)_"^"_G
 Q $G(LPAP)
OLDPAP ;
 ;NEW APCHY S APCHY=$$HYSTER(APCHSDFN,DT) I APCHY]"" Q APCHY
 NEW APCHY,%,LPAP S LPAP="",%=P_"^LAST LAB PAP SMEAR",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) S LPAP=$P(APCHY(1),U)
 NEW APCHY,%,LPAP S LPAP="",%=P_"^LAST LAB [BGP PAP SMEAR TAX",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) S LPAP=$P(APCHY(1),U)
 ;get last pap smear via loinc code
 S APCHLT=$O(^ATXAX("B","BGP PAP LOINC CODES",0))
 I APCHLT D
 .S D=0,G="" F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D=""!(G]"")  D
 ..S T=0 F  S T=$O(^AUPNVLAB("AE",P,D,T)) Q:T=""!(G]"")  D
 ...S I=0 F  S I=$O(^AUPNVLAB("AE",P,D,T,I)) Q:I=""!(G]"")  D
 ....Q:'$D(^AUPNVLAB(I,0))
 ....S J=$P($G(^AUPNVLAB(I,11)),U,13)
 ....Q:J=""
 ....Q:'$$LOINC^APCHS9B2(J,APCHLT)
 ....S V=$P(^AUPNVLAB(I,0),U,3)
 ....S G=$P($P($G(^AUPNVSIT(V,0)),U),".")
 ....Q
 I G]"" D
 .Q:LPAP>G
 .S LPAP=G
 K APCHY S %=P_"^LAST DX V76.2",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) D
 .Q:LPAP>$P(APCHY(1),U)
 .S LPAP=$P(APCHY(1),U)
 K APCHY S %=P_"^LAST PROCEDURE 91.46",E=$$START1^APCLDF(%,"APCHY(")
 I $D(APCHY(1)) D
 .Q:LPAP>$P(APCHY(1),U)
 .S LPAP=$P(APCHY(1),U)
 K APCHY NEW % F %=1:1 S T=$T(PAPCPTS+%^APCHSMU) Q:$P(T,";;",2)=""  S T=$P(T,";;",2),T=$O(^ICPT("B",T,0)) I T S APCHY(1)=$O(^AUPNVCPT("AA",P,T,0)) I APCHY(1) S APCHY(1)=9999999-APCHY(1) D
 .Q:LPAP>$P(APCHY(1),U)
 .S LPAP=$P(APCHY(1),U)
 S T="PAP SMEAR",T=$O(^BWPN("B",T,0))
 I T S X=$$WH^APCHSMU2(P,$$DOB^AUPNPAT(P),DT,T,3)
 I X]"" D
 .Q:LPAP>X
 .S LPAP=X
 S G=$$REFDF^APCHS9B3(P,60,$O(^LAB(60,"B","PAP SMEAR",0)),$G(LPAP))
 I G]"" Q $G(LPAP)_"^"_G
 Q $G(LPAP)
 ;
MAMREF(P,LMAM) ;EP
 NEW G,APCHY
 S G=""
 K APCHY S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",76090,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",76091,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",76092,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q G
 K APCHY S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",77055,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",77056,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",77057,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q G
 K APCHY S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",77058,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D",77059,APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D","G0202",APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q G
 K APCHY S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D","G0204",APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q G
 S G="" S APCHY=0 F  S APCHY=$O(^RAMIS(71,"D","G0206",APCHY)) Q:APCHY'=+APCHY!(G]"")  D
 .S G=$$REFDF^APCHS9B3(P,71,APCHY,$G(LMAM))
 I G]"" Q G
 Q $G(LMAM)
 ;
HYSTER(P,EDATE) ;EP 
 I '$G(P) Q ""
 ;cmi/anch/maw 8/27/2007 mods for code set versioning
 N APCHSVDT
 S F=0,S="" F  S F=$O(^AUPNVPRC("AC",P,F)) Q:F'=+F!(S)  S APCHSVDT=$P(+^AUPNVSIT($P(^AUPNVPRC(F,0),U,3),0),"."),C=$P($$ICDOP^ICDCODE(+^AUPNVPRC(F,0),APCHSVDT),U,2) D
 .;cmi/anch/maw 8/27/2007 end of mods
 .S G=0 S:(C=68.4)!(C=68.5)!(C=68.6)!(C=68.7)!(C=68.9) G=C
 .Q:G=0
 .S D=$P(^AUPNVPRC(F,0),U,6) I D="" S D=$P($P(^AUPNVSIT($P(^AUPNVPRC(F,0),U,3),0),U),".")
 .;I D>EDATE Q
 .S S=1
 I S]"" Q "Pt had Hysterectomy on "_$$FMTE^XLFDT(D,2)_" procedure: "_G
 S T="HYSTERECTOMY",T=$O(^BWPN("B",T,0))
 I T D  I X]"" Q "Hysterectomy documented in Women's Health: "_$$FMTE^XLFDT(X,2)
 .S X=$$WH^APCHSMU2(P,$$DOB^AUPNPAT(P),EDATE,T,3)
 S T=$O(^ATXAX("B","BGP HYSTERECTOMY CPTS",0))
 I T D  I X]"" Q "Pt had Hysterectomy on "_$$FMTE^XLFDT($P(X,U),2)_" CPT: "_$P(X,U,2)
 .S X=$$CPT^APCHSMU2(P,$P(^DPT(P,0),U,3),EDATE,T,5)
 Q ""
