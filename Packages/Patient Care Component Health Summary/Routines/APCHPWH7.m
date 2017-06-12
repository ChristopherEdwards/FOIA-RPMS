APCHPWH7 ; IHS/CMI/LAB - PCC HEALTH SUMMARY - MAIN DRIVER PART 2 ;
 ;;2.0;IHS PCC SUITE;**7,11**;MAY 14, 2009;Build 58
 ;
 ;EO MEASURES IN PWH
ASTHMA ;EP
 NEW APCHX,APCHSTH1,APCHSTH2
 Q:$$AGE^AUPNPAT(APCHSDFN)<5
 I $$AGE^AUPNPAT(APCHSDFN)>56 Q
 ;.D S^APCHPWH1("Asthma Medication Status",1)
 ;.;D S^APCHPWH1("This section only reports on people ages 5-56 who have asthma.")
 ;.;D S^APCHPWH1("You are over 56 years of age.")
 I $$EMP(DFN,$$DOB^AUPNPAT(DFN),DT) Q  ;has dx of emphysema
 I $$COPD(DFN,$$DOB^AUPNPAT(DFN),DT) Q  ;has copd
 D S^APCHPWH1("Asthma Medication Status",1)
 S APCHSTH1=$$HMR5ST^APCHSMAS(APCHSDFN)
 I 'APCHSTH1 D  Q  ;not asthma in both time periods
 .K ^TMP($J,"A")
 .D S^APCHPWH1("This section only reports on people who have asthma.  You do not have")
 .D S^APCHPWH1("asthma, so you are not included in this report.  If you think you have")
 .D S^APCHPWH1("asthma, talk to your doctor.")
 K ^TMP($J,"A")
 S APCHX=$$ASTHTHER(DFN,$$FMADD^XLFDT(DT,-365),DT)
 I $P(APCHX,U)=1 D  Q
 .D S^APCHPWH1("This reports looks to see if you were prescribed a medicine for your asthma.")
 .D S^APCHPWH1("You were prescribed at least one medication for your asthma.")
 D S^APCHPWH1("This reports looks to see if you were prescribed a medicine for your asthma.")
 D S^APCHPWH1("You were not prescribed any asthma medications this year. Talk to your doctor")
 D S^APCHPWH1("about what asthma treatment, if any, is best for you.")
 Q
EMP(P,BDATE,EDATE) ;
 NEW APCHG,X,Y,E
 K APCHG
 S Y="APCHG("
 S X=P_"^LAST DX [BGP EMPHYSEMA DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(APCHG(1)) Q 1  ;has a dx
 Q 0
COPD(P,BDATE,EDATE) ;
 NEW APCHG,X,Y,E
 K APCHG
 S Y="APCHG("
 S X=P_"^LAST DX [BGP COPD DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(APCHG(1)) Q 1  ;has a dx
 Q 0
PERASTH(P,BDATE,EDATE) ;EP
 ;I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 ;item 1 - one visit to er w/493 OR hospitalization
 NEW A,B,E,T,X,G,V,K,Y,APCHT,S,J,M
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q 0  ;not asthma or hosp or meds
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .S K=0
 .I $P(^AUPNVSIT(V,0),U,7)="H" S K=1
 .I $$CLINIC^APCLV(V,"C")=30 S K=1
 .Q:'K
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .S Y=$$PRIMPOV^APCLV(V,"I")
 .Q:'$$ICD^ATXAPI(Y,T,9)
 .S G=1_U_$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")) ;got one
 ;
 I G Q 1_U_"DX ON HOSP/OR ER ON "_$P(G,U,2)  ;had prim dx on 30 or H so meets denom
PER3 ;
 ;now check for meds
 S APCHT=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 S T=$O(^ATXAX("B","BGP HEDIS ASTHMA MEDS",0))
 S T3=$O(^ATXAX("B","BGP HEDIS ASTHMA NDC",0))
 S T1=$O(^ATXAX("B","BGP HEDIS ASTHMA INHALED MEDS",0))
 S T4=$O(^ATXAX("B","BGP HEDIS ASTHMA INHALED NDC",0))
 S T2=$O(^ATXAX("B","BGP HEDIS ASTHMA LEUK MEDS",0))
 S T5=$O(^ATXAX("B","BGP HEDIS ASTHMA LEUK NDC",0))
 S (X,G,M,D,E)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"AOS"'[$P(^AUPNVSIT(V,0),U,7)
 .S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(D)  I $D(^AUPNVPOV(Y,0)) S %=$P(^AUPNVPOV(Y,0),U) I $$ICD^ATXAPI(%,APCHT,9) S D=1
 .I D S G=G+1 ;got one visit
 .S Y=0 F  S Y=$O(^AUPNVMED("AD",V,Y)) Q:Y'=+Y  D
 ..S S=0
 ..S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 ..I $D(^ATXAX(T1,21,"B",Z))!($$NDC(Z,T4)),$P(^AUPNVMED(Y,0),U,8)="" S M=M+1 Q  ;it is an inhaled steroid that wasn't d/c'ed so 1 dispensing event
 ..I $D(^ATXAX(T,21,"B",Z))!($$NDC(Z,T3)) D
 ...Q:$$LEUK(Z,T2,T5)  ;don't count if it is a leukotriene
 ...S J=$P(^AUPNVMED(Y,0),U,8)
 ...I J]"" S S=$$FMADD^XLFDT(J,$P($P(^AUPNVSIT(V,0),U),"."))
 ...I J="" S S=$P(^AUPNVMED(Y,0),U,7)
 ...S K=S/30,M=M+K
 ..I $D(^ATXAX(T2,21,"B",Z))!($$NDC(Z,T5)) D  Q
 ...S J=$P(^AUPNVMED(Y,0),U,8)
 ...I J]"" S S=$$FMADD^XLFDT(J,$P($P(^AUPNVSIT(V,0),U),"."))
 ...I J="" S S=$P(^AUPNVMED(Y,0),U,7)
 ...S K=S/30,M=M+K,E=E+K
 I G>3,M>1 Q 1_U_"4 POVS AND 2 MEDS"  ;had 4 povs and 2 dispensing events
 I M>3,E<M Q 1_U_"4 meds"  ;had 4 meds, not all were leuko
 I M>3,E=M,G>0 Q 1_U_"LEUKOTRIENE AND 1 DX"  ;had all leuk and 1 dx
 Q ""
 ;
NDC(A,B) ;
 ;a is drug ien
 ;b is taxonomy ien
 NEW N
 S N=$P($G(^PSDRUG(A,2)),U,4)
 I N]"",B,$D(^ATXAX(B,21,"B",N)) Q 1
 Q 0
LEUK(A,B,C) ;
 ;a drug ien
 ;b tax ien
 ;c tax ien for ndc
 I $D(^ATXAX(B,21,"B",A)) Q 1
 I $$NDC(A,C) Q 1
 Q ""
ASTHTHER(P,BDATE,EDATE) ;EP
 ;get number of asthma medication events
 NEW APCHEDS1,T,T3,X,G,M,E,Z,D
 K APCHEDS1
 D GETMEDS^APCHSMU1(P,BDATE,EDATE,,,,,.APCHEDS1)
 I '$D(APCHEDS1) Q ""
 S T=$O(^ATXAX("B","BGP HEDIS PRIMARY ASTHMA MEDS",0))
 S T3=$O(^ATXAX("B","BGP HEDIS PRIMARY ASTHMA NDC",0))
 S (X,G,M,E)=0,D="" F  S X=$O(APCHEDS1(X)) Q:X'=+X!(D]"")  S V=$P(APCHEDS1(X),U,5),Y=+$P(APCHEDS1(X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .I $D(^ATXAX(T,21,"B",Z))!($$NDC(Z,T3)),$P(^AUPNVMED(Y,0),U,8)="" S D=1_U_$P(^PSDRUG(Z,0),U)_U_$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")) Q
 Q D
 ;
STROKE ;EP
 NEW APCHOXV,APCHD,APCHN
 K APCHOXV
 I $$AGE^AUPNPAT(APCHSDFN,DT)<18 Q  ;don't process this measure, pt under 18
 S APCHD1=0  ;Number of STROKE visits
 S APCHN1=0
 D TIAFIB(APCHSDFN,$$FMADD^XLFDT(DT,-365),DT,.APCHOXV)
 ;now evaluate result
 D S^APCHPWH1("Stroke/Anitcoagulation Therapy",1)
 ;
 I 'APCHOXV("DENOM")!($$AGE^AUPNPAT(APCHSDFN,DT)<18) D  Q
 .D S^APCHPWH1("This section only reports on people who had a blood clot in the brain (also")
 .D S^APCHPWH1("called a stroke) and an abnormal heart beat.  You do not have these")
 .D S^APCHPWH1("problems, so you are not included in this report.")
 .Q
 S X=0 F  S X=$O(APCHOXV(X)) Q:X'=+X  D
 .S Y="",M="" I $P(APCHOXV(X),U,2)]"" S Y=$$FMTE^XLFDT($P(APCHOXV(X),U,3)),M=$P(APCHOXV(X),U,2)
 I Y="" D  Q
 .D S^APCHPWH1("This report looks to see if you were prescribed a medicine to prevent")
 .D S^APCHPWH1("blood clots this year.  You were not prescribed any medications to ")
 .D S^APCHPWH1("prevent a blood clot this year.")
 D S^APCHPWH1("This report looks to see if you were prescribed a medicine to prevent")
 D S^APCHPWH1("blood clots this year.  You were prescribed "_M)
 D S^APCHPWH1("on "_Y_".")
 Q
 ;
TIAFIB(P,BDATE,EDATE,APCHR) ;EP
 NEW A,X,V,APCHG,G,C,T,B,E,APCHX,APCHV,APCHD
 K APCHR,APCHG,APCHX
 S APCHR="",APCHR(0)=""
 S X=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"APCHG(")
 I '$D(APCHG(1)) S APCHR("DENOM")=0 Q
 ;now go through and get rid of H and CHS
 S T=$O(^ATXAX("B","BGP TIA DXS",0))
 S A=0 F  S A=$O(APCHG(A)) Q:A'=+A  D
 .S V=$P(APCHG(A),U,5)
 .I '$D(^AUPNVSIT(V,0)) K APCHG(A) Q
 .I $P(^AUPNVSIT(V,0),U,3)="C" K APCHG(A) Q
 .I $P(^AUPNVSIT(V,0),U,7)'="H" K APCHG(A) Q
 .S X=0,G=0,E=0,B=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  D
 ..S C=$P($G(^AUPNVPOV(X,0)),U)
 ..Q:C=""
 ..I $$ICD^ATXAPI(C,T,9) S G=1,$P(APCHG(A),U,15)=$$VAL^XBDIQ1(9000010.07,X,.01)
 ..I $$VAL^XBDIQ1(9000010.07,X,.01)="427.31" S E=1
 .I G,E S B=1  ;have both
 .I 'B K APCHG(A)  ;no tia diagnosis
 I '$D(APCHG) S APCHR("DENOM")=0 Q
 ;reorder the diagnoses by visit date
 S A=0 F  S A=$O(APCHG(A)) Q:A'=+A  S V=$P(APCHG(A),U,5),D=$P($P($G(^AUPNVSIT(V,0)),U),"."),APCHX(D,V)=APCHG(A)
 ;now get the first one
 S APCHD=0,APCHC=0 F  S APCHD=$O(APCHX(APCHD)) Q:APCHD'=+APCHD  D
 .S APCHV=0 F  S APCHV=$O(APCHX(APCHD,APCHV)) Q:APCHV'=+APCHV  D
 ..S APCHC=APCHC+1,APCHR(APCHC)=APCHD  ;set denominator
 ..S G=$$ANTICOAG(P,$$FMADD^XLFDT(APCHD,-365),$$DSCHDATE^APCLV(APCHV),APCHD)  ; any ANTICOAG?
 ..S $P(APCHR(APCHC),U,2)=$P(G,U,2),$P(APCHR(APCHC),U,3)=$P(G,U,1)  ;set numerator column
 ..;S $P(APCHR(0),U,$P(G,U,2))=$P(APCHR(0),U,$P(G,U,2))+1
 S APCHR("DENOM")=APCHC
 Q
 ;
ANTICOAG(P,BDATE,EDATE,APCHAD) ;EP - was there ANTICOAG
 NEW APCHD,X,N,E,Y,T,D,C,APCHLT,L,J,APCHG,S,APCHD
 K APCHG S Y="APCHG(",X=P_"^ALL MED;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S X=0,G="" F  S X=$O(APCHG(X)) Q:X'=+X!(G]"")  D
 .S N=+$P(APCHG(X),U,4)  ;ien of v med
 .S C=$$ANTIDRUG(N)  ;not one of the drugs
 .Q:'$P(C,U)
 .;c=1^category of drug
 .I $P(^AUPNVMED(N,0),U,8)]"",$P(^AUPNVMED(N,0),U,8)'>EDATE Q  ;discontinued before discharge date
 .S S=$P(^AUPNVMED(N,0),U,7)
 .I $P($P(^AUPNVSIT($P(^AUPNVMED(N,0),U,3),0),U),".")=EDATE S G=$$FMTE^XLFDT(EDATE)_"^"_$P(C,U,2)_"^1"  ;PRESCRIBED ON DISCHARGE DATE
 .S V=$P(^AUPNVMED(N,0),U,3)
 .S V=$P($P(^AUPNVSIT(V,0),U),".")
 .I $$FMADD^XLFDT(V,S)<EDATE Q  ;not valid through discharge date
 .S G=V_"^"_$P(C,U,2)
 I G]"" Q G
 ;now check for cpts
 S G=$$CPTI^APCHSMU1(P,EDATE,EDATE,+$$CODEN^ICPTCOD("4073F"),,,"1P;2P;8P")
 I G Q $$FMTE^XLFDT($P(G,U,2))_"^ANTI-PLT CPT [4073F]^1"
 S G=$$CPTI^APCHSMU1(P,EDATE,EDATE,+$$CODEN^ICPTCOD("4075F"),,,"1P;2P;8P")
 I G Q $$FMTE^XLFDT($P(G,U,2))_"^ANTI-PLT CPT [4075F]^1"
 S G=$$CPTI^APCHSMU1(P,EDATE,EDATE,+$$CODEN^ICPTCOD("G8006"))
 I G Q $$FMTE^XLFDT($P(G,U,2))_"^ANTI-PLT CPT [G8006]^1"
 S G=$$TRANI^APCHSMU1(P,EDATE,EDATE,+$$CODEN^ICPTCOD("4073F"))
 I G Q $$FMTE^XLFDT($P(G,U,2))_"^ANTI-PLT CPT/TRAN [4073F]^1"
 S G=$$TRANI^APCHSMU1(P,EDATE,EDATE,+$$CODEN^ICPTCOD("4075F"))
 I G Q $$FMTE^XLFDT($P(G,U,2))_"^ANTI-PLT CPT/TRAN [4075F]^1"
 S G=$$TRANI^APCHSMU1(P,EDATE,EDATE,+$$CODEN^ICPTCOD("G8006"))
 I G Q $$FMTE^XLFDT($P(G,U,2))_"^ANTI-PLT CPT/TRAN [G8006]^1"
 Q ""
 ;now go get refusals of any of the above
 ;
 ;refusal of MEDS
 ;S T=$O(^ATXAX("B","BGP CMS WARFARIN MEDS",0))
 ;S G=$$REFTAX^APCHSMU1(P,50,T,EDATE,EDATE)
 ;I G Q $$FMTE^XLFDT(EDATE)_" ZZZZZ: DECLINED WARF^2"
 ;S T=$O(^ATXAX("B","DM AUDIT ANTI-PLATELET DRUGS",0))
 ;S G=$$REFTAX^APCHSMU1(P,50,T,EDATE,EDATE)
 ;I G Q $$FMTE^XLFDT(EDATE)_" ZZZZZ: DECLINED ANTI-PLT^2"
 ;S T=$O(^ATXAX("B","D AUDIT ASPIRIN DRUGS",0))
 ;S G=$$REFTAX^APCHSMU1(P,50,T,EDATE,EDATE)
 ;I G Q $$FMTE^XLFDT(EDATE)_" ZZZZZ: DECLINED ASA^2"
 ;CHECK BL700 CLASS REFUSALS
 S G=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,50,I)) Q:I=""!($P(G,U))  D
 .S (X,G)=0 F  S X=$O(^AUPNPREF("AA",P,50,I,X)) Q:X'=+X!($P(G,U))  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,50,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D=EDATE D
 .Q:$P($G(^PSDRUG(I,0)),U,2)'="BL700"
 .S G=$$FMTE^XLFDT(EDATE)_" ZZZZZ: DECLINED ANTI-PLT^2"
 I G]"" Q G
 S G=$$REFUSAL^APCHSMU(P,81,+$$CODEN^ICPTCOD("4073F"),EDATE,EDATE)
 I G Q $$FMTE^XLFDT(EDATE)_" ZZZZZ: DECLINED ANTI-PLT [4073F]^2"
 S G=$$REFUSAL^APCHSMU(P,81,+$$CODEN^ICPTCOD("4075F"),EDATE,EDATE)
 I G Q $$FMTE^XLFDT(EDATE)_" ZZZZZ: DECLINED ANTI-PLT [4075F]^2"
 S G=$$REFUSAL^APCHSMU(P,81,+$$CODEN^ICPTCOD("G8006"),EDATE,EDATE)
 I G Q $$FMTE^XLFDT(EDATE)_" ZZZZZ: DECLINED ANTI-PLT [G8006]^2"
 Q $$FMTE^XLFDT(EDATE)_" ZZZZZ: NO THERAPY^3"
 ;
ANTIDRUG(N) ;
 NEW G,T,I
 S I=$P($G(^AUPNVMED(N,0)),U)
 I 'I Q 0
 S G=0
 S T=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 I T,$D(^ATXAX(T,21,"B",I)) Q "1^"_$P(^PSDRUG(I,0),U,1)
 S T=$O(^ATXAX("B","BGP CMS WARFARIN MEDS",0))
 I T,$D(^ATXAX(T,21,"B",I)) Q "1^"_$P(^PSDRUG(I,0),U,1)
 S T=$O(^ATXAX("B","DM AUDIT ANTI-PLATELET DRUGS",0))
 I T,$D(^ATXAX(T,21,"B",I)) Q "1^"_$P(^PSDRUG(I,0),U,1)
 S G=$P(^PSDRUG(I,0),U,2)
 I G="BL700" Q "1^"_$P(^PSDRUG(I,0),U,1)
 I $P(^PSDRUG(I,0),U)["WARFARIN" Q "1^"_$P(^PSDRUG(I,0),U,1)
 Q ""
