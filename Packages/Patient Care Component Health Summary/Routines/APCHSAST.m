APCHSAST ; IHS/CMI/LAB - ; 20 Sep 2010  1:44 PM
 ;;2.0;IHS PCC SUITE;**2,5,7,11**;MAY 14, 2009;Build 58
 ;
 ;BJPC v1.0 patch 1
S(Y,F,C,T) ;EP - set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("APCHAST",$J,"DCS",0),U)+1,$P(^TMP("APCHAST",$J,"DCS",0),U)=%
 S ^TMP("APCHAST",$J,"DCS",%)=X
 Q
EP(DFN) ;PEP - Asthma supplement for health summary
 NEW APCHX,APCHQUIT,APCHSX
 NEW X,Y,Z,A,I,B,E,T
 D EP2(DFN)
W ;write out array
 W:$D(IOF) @IOF
 K APCHQUIT
 S APCHX=0 F  S APCHX=$O(^TMP("APCHAST",$J,"DCS",APCHX)) Q:APCHX'=+APCHX!($D(APCHQUIT))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(APCHQUIT)
 .W !,^TMP("APCHAST",$J,"DCS",APCHX)
 .Q
 I $D(APCHQUIT) S APCHSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 ;D EN^XBVK("BAT")
 K N,%,T,F,X,Y,B,C,E,F,H,L,N,P,T,W,M,T,T1,T2,T3
 Q
HEADER ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 W !,APCHSHDR
 W !,"ASTHMA PATIENT CARE SUMMARY                      Report Date:  ",$$FMTE^XLFDT(DT),!
 Q
EP2(DFN) ;EP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("APCHAST",$J,"DCS"
 K ^TMP("APCHAST",$J,"DCS")
 S ^TMP("APCHAST",$J,"DCS",0)=0
 D SETARRAY
 Q
SETARRAY ;set up array containing dm care summary
 S X=APCHSHDR D S(X)
 S X="ASTHMA PATIENT CARE SUMMARY                   Report Date:  "_$$FMTE^XLFDT(DT) D S(X,1)
 S X=$P(^DPT(DFN,0),U),$E(X,35)="HRN: "_$$HRN^AUPNPAT(DFN,DUZ(2)) D S(X,1)
 S X="DOB: "_$$DOB^AUPNPAT(DFN,"E")_"  Age: "_$$AGE^AUPNPAT(DFN)_"  "_$$SEX^AUPNPAT(DFN) ;S Y=$$VAL^XBDIQ1(90181.01,DFN,.02)
 S Y="" I $T(ATAG^BQITDUTL)="" S Y="Asthma Diagnostic Tag:  Data Not Available"  S $E(X,35)=Y
 I $T(ATAG^BQITDUTL)]"" S T=$$ATAG^BQITDUTL(DFN,"Asthma") S Y="Asthma Diagnostic Tag:  "_$S($P(T,U,2)="P":"Proposed",$P(T,U,2)="A":"Accepted",1:"None") S $E(X,35)=Y
 ;put icare tag here at in place of asthma register status
 ; S $E(X,35)="Asthma Register Status: "_$S(Y]"":Y,1:"NOT ON REGISTER") D S(X)
 D S(X)
 I $O(^BDPRECN("C",DFN,0)) D  I 1
 .D S(" ")
 .S APCHSX=0 F  S APCHSX=$O(^BDPRECN("C",DFN,APCHSX)) Q:APCHSX'=+APCHSX  D
 ..S A=$P($G(^BDPRECN(APCHSX,0)),U)
 ..Q:A=""
 ..Q:'$D(^BDPTCAT(A,0))
 ..Q:$P(^BDPTCAT(A,0),U,8)="N"
 ..S A=$$VAL^XBDIQ1(90360.1,APCHSX,.01)
 ..;S X="",$E(X,(38-$L(A)))=A,X=X_":  "_$$VAL^XBDIQ1(90360.1,APCHSX,.03) D S(X)
 ..S X="",X=A,X=X_":  "_$$VAL^XBDIQ1(90360.1,APCHSX,.03) D S(X)
 .Q
 E  S X="DESIGNATED PRIMARY CARE PROVIDER: "_$$VAL^XBDIQ1(9000001,DFN,.14) D S(X)
 D S(" ")
 K APCHPL,APCHASEV D PLASTA(DFN,.APCHPL) ;get problem list # and narrative
 I '$D(APCHPL) S Y="ASTHMA IS NOT ON THIS PATIENT'S PROBLEM LIST; CONSIDER ADDING" D S(Y,1)
 I $D(APCHPL) D
 .S X=0,C=0 F  S X=$O(APCHPL(X)) Q:X'=+X  D
 ..S C=C+1
 ..I C=1 S Y="Asthma-Related Problem List: " D S(Y)
 ..I C'=1 D S("")
 ..;I C'=1 S Y="              "
 ..K Z
 ..S APCHSNRQ=APCHPL(X),APCHSICL=5 D ICD^APCHSAS1
 ..S D=0 F  S D=$O(Z(D)) Q:D=""  D
 ...;I D=1 S Y=Y_Z(D) D S(Y)
 ...D S(Z(D))
 ..S Y="     Asthma Severity: "_$S($P(^AUPNPROB(X,0),U,15)]"":$$VAL^XBDIQ1(9000011,X,.15),1:"None Documented") D S(Y)
 ..S Y="     Date of Onset: "_$S($P(^AUPNPROB(X,0),U,13)]"":$$VAL^XBDIQ1(9000011,X,.13),1:"None Documented") D S(Y)
 ..S Y="     Date Last Updated: "_$$VAL^XBDIQ1(9000011,X,.03) D S(Y)
 ..;notes
 ..S APCHX=0 F  S APCHX=$O(^AUPNPROB(X,11,APCHX)) Q:APCHX'=+APCHX  D
 ...S S=$P(^AUPNPROB(X,11,APCHX,0),U,1),S=$S($P(^AUTTLOC(S,0),U,7)]"":$P(^AUTTLOC(S,0),U,7),1:"??")
 ...S S=$P(APCHPL(X)," ")_S
 ...S APCHY=0 F  S APCHY=$O(^AUPNPROB(X,11,APCHX,11,APCHY)) Q:APCHY'=+APCHY  D
 ....S APCHSICL=6,APCHSNRQ=S_$P(^AUPNPROB(X,11,APCHX,11,APCHY,0),U)_" "_$$FMTE^XLFDT($P(^AUPNPROB(X,11,APCHX,11,APCHY,0),U,5))_" "_$P(^AUPNPROB(X,11,APCHX,11,APCHY,0),U,3) D ICD^APCHSAS1
 ....S E=0 F  S E=$O(Z(E)) Q:E=""  D S(Z(E))
 S X="Most Recent Control: "_$$LASTACON^APCHSMAS(DFN,7) D S(X,1)
 ;get and display FH
 K APCHTFH
 D FMH^APCHSAS1(DFN,.APCHTFH)
 S Y="Asthma-Related FAMILY HEALTH HISTORY:  "
 I '$D(APCHTFH) S Y=Y_"None Documented" D S(Y,1)
 I $D(APCHTFH) D S(Y,1) D S("Date Last Mod Relation/Status/Diagnosis") D
 .S X=0 F  S X=$O(APCHTFH(X)) Q:X=""  D
 ..I X=1,APCHTFH(1)="" Q
 ..D S(APCHTFH(X))
 ;S B=$$LASTITEM^APCHSMU(DFN,"BPF","MEASUREMENT","B")
 S B=$$PBPF(DFN,"B")
 I $P(B,U)]"" S X="Personal Best Peak Flow   "_$P(B,U,2)_" liters/minute on "_$$FMTE^XLFDT($P(B,U)) D S(X,1)
 I $P(B,U)="" S X="Personal Best Peak Flow:  None Documented." D S(X,1)
 S X="Peak Flow Zones",$E(X,21)="Green (80-100%)",$E(X,39)=$$GREEN($P(B,U,2)) D S(X,1)
 S X="",$E(X,21)="Yellow (50-79%)",$E(X,39)=$$YELLOW($P(B,U,2)) D S(X)
 S X="",$E(X,21)="Red (< 50%)",$E(X,39)=$$RED($P(B,U,2)) D S(X)
 S APCHX=0,Y="" K APCHY F  S APCHX=$O(^AUTTEDT("C","ASM-SMP",APCHX)) Q:APCHX'=+APCHX  D
 .S APCHY=$$LASTITEM^APCHSMU(DFN,"`"_APCHX,"EDUCATION")
 .Q:APCHY=""
 .S APCHY($P(APCHY,U,1))=""
 S Y=$O(APCHY(0))
 I Y]"" S X="Date of Last Asthma Action Plan:  "_$$FMTE^XLFDT(Y)_$S($$FMDIFF^XLFDT(DT,Y)>365:"  Needs to be reviewed.",1:"") D S(X,1)
 I Y="" D
 .S Y=$$LASTAM(DFN,1) I Y]"" S X="Date of Last Asthma Management Plan:  "_$$FMTE^XLFDT(Y)_$S($$FMDIFF^XLFDT(DT,Y)>365:"  Needs to be reviewed.",1:"") D S(X,1)
 .I Y="" S X="Date of Last Asthma Action Plan:  NEEDS TO BE REVIEWED" D S(X,1)
TRIGHF ;trigger health factors
 S APCHG=0 K APCHSX
 S APCHC=$O(^AUTTHF("B","ASTHMA TRIGGERS",0))
 G:'APCHC TOB
 S APCHF=0 F  S APCHF=$O(^AUTTHF("AC",APCHC,APCHF)) Q:APCHF'=+APCHF  D
 .Q:'$D(^AUPNVHF("AA",DFN,APCHF))
 .S D=$O(^AUPNVHF("AA",DFN,APCHF,""))
 .S APCHG=APCHG+1
 .S X="  "_$P(^AUTTHF(APCHF,0),U),$E(X,35)="Yes, documented on "_$$FMTE^XLFDT((9999999-D)) S APCHSX(APCHG)=X
 S X="Triggers:  "_$S('APCHG:"No Triggers identified.",1:"") D S(X,1)
 S APCHG=0 F  S APCHG=$O(APCHSX(APCHG)) Q:APCHG'=+APCHG  D S(APCHSX(APCHG))
TOB ;
 ;S Y=$$LASTTOBS^APCLAPI7(DFN,,,"A"),X="Last Recorded TOBACCO Screening: "_$P(Y,U,2)_"  "_$$FMTE^XLFDT($P(Y,U,1))  D S(X,1)
 S Y=$$LASTSMOK^APCLAPI7(DFN,,,"A"),X="Last TOBACCO (SMOKING) Screening: "_$P(Y,U,2)_"  "_$$DATE^APCHSMU($P(Y,U,1))  D S(X,1)
 S Y=$$LASTSMLE^APCLAPI7(DFN,,,"A"),X="Last TOBACCO (SMOKELESS) Screening: "_$P(Y,U,2)_"  "_$$DATE^APCHSMU($P(Y,U,1))  D S(X,1)
 S Y=$$LASTSMEX^APCLAPI7(DFN,,,"A"),X="Last TOBACCO (EXPOSURE) Screening: "_$P(Y,U,2)_"  "_$$DATE^APCHSMU($P(Y,U,1))  D S(X,1)
V D LAST5
 S X="Last 5 Visits w/LUNG FUNCTION Measurements" D S(X,1)
 S X="",$E(X,3)="DATE",$E(X,20)="FEV1/FVC",$E(X,38)="Highest Visit Peak Flow",$E(X,65)="FEF 25-75" D S(X)
 S X="",$P(X,"-",75)="" D S(X)
 I '$D(APCHL) S X="NO MEASUREMENTS DOCUMENTED" D S(X) G ASFD
 S D=0,C=0 F  S D=$O(APCHL(D)) Q:D'=+D!(C>5)  D
 .S C=C+1,V=0 F  S V=$O(APCHL(D,V)) Q:V'=+V  D
 ..S X="",$E(X,3)=$$FMTE^XLFDT((9999999-D),"1D")
 ..I $P(APCHL(D,V),U,3)]"" S $E(X,20)=$P(APCHL(D,V),U,3)
 ..I $P(APCHL(D,V),U,4)]"" S $E(X,38)=$P(APCHL(D,V),U,4)
 ..I $P(APCHL(D,V),U,5)]"" S $E(X,65)=$P(APCHL(D,V),U,5)
 ..D S(X)
ASFD ;asthma symptom free days
 K APCHASFD
 K APCHL
 S X=DFN_"^ALL MEAS ASFD"_";DURING "_$$FMADD^XLFDT(DT,-365)_"-"_DT S E=$$START1^APCLDF(X,"APCHL(")
 I '$D(APCHL(1)) S Y="Asthma Symptom-Free Days:" D S(Y,1) D S("Asthma Symptom Free Days should be reviewed at every Asthma visit")
 I $D(APCHL) D
 .S Y="Asthma Symptom-Free Days:" D S(Y,1)
 .S Y=" Visit Date",$E(Y,20)="Symptom-Free Days" D S(Y)
 .S X="",$P(X,"-",50)="" D S(X)
 .S X=0 F  S X=$O(APCHL(X)) Q:X'=+X  S APCHL("D",(9999999-$P(APCHL(X),U)),+$P(APCHL(X),U,4))=APCHL(X)
 .S D=0,C=0 F  S D=$O(APCHL("D",D)) Q:D'=+D!(C>3)  D
 ..S I=0,C=C+1 F  S I=$O(APCHL("D",D,I)) Q:I'=+I  D
 ...S Y=" "_$$FMTE^XLFDT((9999999-D)),$E(Y,20)=$P(APCHL("D",D,I),U,2) D S(Y)
 ;
ADM ;
 K APCHASFD
 K APCHL
 S X=DFN_"^ALL MEAS ADM"_";DURING "_$$FMADD^XLFDT(DT,-365)_"-"_DT S E=$$START1^APCLDF(X,"APCHL(")
 I '$D(APCHL(1)) S Y="Asthma Work/School Days Missed:" D S(Y,1) D S("Asthma Work/School days missed should be reviewed at every Asthma visit")
 I $D(APCHL) D
 .S Y="Asthma Work/School Days Missed:" D S(Y,1)
 .S Y=" Visit Date",$E(Y,20)="Work/School Days Missed" D S(Y)
 .S X="",$P(X,"-",50)="" D S(X)
 .S X=0 F  S X=$O(APCHL(X)) Q:X'=+X  S APCHL("D",(9999999-$P(APCHL(X),U)),+$P(APCHL(X),U,4))=APCHL(X)
 .S D=0,C=0 F  S D=$O(APCHL("D",D)) Q:D'=+D!(C>3)  D
 ..S I=0,C=C+1 F  S I=$O(APCHL("D",D,I)) Q:I'=+I  D
 ...S Y=" "_$$FMTE^XLFDT((9999999-D)),$E(Y,20)=$P(APCHL("D",D,I),U,2) D S(Y)
 ;
N ;more stuff
 D N^APCHSAS1
 Q
 ;
PBPF(P,F) ;EP - BEST PEAK FLOW
 I $G(F)="" S F="D"
 NEW APCHY,%,E,Y K APCHY S %=P_"^ALL MEAS BPF",E=$$START1^APCLDF(%,"APCHY(")
 S %="",Y=0 F  S Y=$O(APCHY(Y)) Q:Y'=+Y  I $P(APCHY(Y),U,1)>$P(%,U,1) S %=APCHY(Y)
 Q $S(F="D":$P(%,"^"),F="B":$P(%,"^")_"^"_$P(%,"^",2),1:$P(%,"^",2))
 ;
GREEN(V) ;EP - GREEN VALUE
 NEW P,P1
 I $G(V)="" Q ""
 S P=$J((V*.80),3,0),P1=V
 Q P_"-"_V_" liters/minute"
YELLOW(V)  ;EP - YELLOW VALUE
 NEW P,P1
 I $G(V)="" Q ""
 S P=(V*.50)
 S P=$J(P,3,0)
 S P1=(V*.80),P1=P1-1,P1=$J(P1,3,0)
 Q P_"-"_P1_" liters/minute"
RED(V,D) ;EP - RED VALUE
 NEW P,P1
 I $G(V)="" Q ""
 S P=((.50*V))
 S P=$J(P,3,0)
 Q "<"_P_"   liters/minute"
 ;
 ;
PLAST(P,F) ;EP
 ;1 return 1 if yes, null if no
 ;2 return problem number _ provdier narrative
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW I,A,B,G,S
 S G="",A=0 F  S A=$O(^AUPNPROB("AC",P,A)) Q:A'=+A!(G]"")  D
 .Q:$P(^AUPNPROB(A,0),U,12)="D"
 .S I=$P(^AUPNPROB(A,0),U) Q:'$D(^ICD9(I,0))  S S=$P(^ICD9(I,0),U)
 .I '$O(^ATXAX("B","BGP ASTHMA DXS",0)),$E(S,1,3)'="493" Q
 .I $O(^ATXAX("B","BGP ASTHMA DXS",0)),'$$ICD^ATXAPI(I,$O(^ATXAX("B","BGP ASTHMA DXS",0)),9) Q
 .S G=A
 .Q
 I G="" Q ""
 I F=1 Q 1
 I F=2 S G=$$PLN(G) Q G
 Q ""
PLASTA(P,R) ;EP
 ;1 return 1 if yes, null if no
 ;2 return problem number _ provdier narrative
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW I,A,B,G,S
 K R
 S G="",A=0 F  S A=$O(^AUPNPROB("AC",P,A)) Q:A'=+A!(G]"")  D
 .Q:$P(^AUPNPROB(A,0),U,12)="D"
 .S I=$P(^AUPNPROB(A,0),U) Q:'$D(^ICD9(I,0))  S S=$P(^ICD9(I,0),U)
 .I '$O(^ATXAX("B","BGP ASTHMA DXS",0)),$E(S,1,3)'="493" Q
 .I $O(^ATXAX("B","BGP ASTHMA DXS",0)),'$$ICD^ATXAPI(I,$O(^ATXAX("B","BGP ASTHMA DXS",0)),9) Q
 .S APCHPL(A)=$$PLN(A)
 .Q
 Q
DXAST(P) ;EP
 I '$G(P) Q ""
 NEW D,I,A,G,S
 S (D,G)=0 F  S D=$O(^AUPNVPOV("AA",P,D)) Q:D'=+D!(G)  D
 .S I=0 F  S I=$O(^AUPNVPOV("AA",P,D,I)) Q:I'=+I!(G)  D
 ..S A=$P(^AUPNVPOV(I,0),U),S=$P(^ICD9(A,0),U)
 ..I '$O(^ATXAX("B","BGP ASTHMA DXS",0)),$E(S,1,3)'="493" Q
 ..I $O(^ATXAX("B","BGP ASTHMA DXS",0)),'$$ICD^ATXAPI(A,$O(^ATXAX("B","BGP ASTHMA DXS",0)),9) Q
 ..S G=1
 ..Q
 .Q
 Q G
 ;
 ;
 ;
LAST5 ;
 K APCHD,APCHV,APCHL
 S M="FVFC",P=3 D GETM
 S M="PF",P=4 D GETM
 S M="FEF",P=5 D GETM
 K APCHD,APCHV
 Q
GETM ;
 S X=DFN_"^ALL MEASUREMENT "_M S E=$$START1^APCLDF(X,"APCHD(")
 S X=0 F  S X=$O(APCHD(X)) Q:X'=+X  D
 .S I=+$P(APCHD(X),U,4),V=$P(APCHD(X),U,5),R=$P(APCHD(X),U,2)
 .I M'="FVFC" D  Q
 ..Q:$P($G(APCHL((9999999-$P($P(^AUPNVSIT(V,0),U),".")),V)),U,P)>$P(^AUPNVMSR(I,0),U,4)
 ..S $P(APCHL((9999999-$P($P(^AUPNVSIT(V,0),U),".")),V),U,P)=$P(^AUPNVMSR(I,0),U,4)
 .S Y=$$FVFC($P(^AUPNVMSR(I,0),U,4))
 .Q:$P($G(APCHL((999999-$P($P(^AUPNVSIT(V,0),U),".")),V)),U,3)>Y
 .S $P(APCHL((9999999-$P($P(^AUPNVSIT(V,0),U),".")),V),U,3)=$P(^AUPNVMSR(I,0),U,4)_" ("_Y_")"
 K APCHD,APCHV
 Q
 ;
FVFC(R) ;
 NEW F,S,V
 S F=$P(R,"/")
 S S=$P(R,"/",2)
 I S="" Q ""
 I F="" Q ""
 I S=0 Q 0
 S P=F/S
 I $L($P(P,"."))>3 S P=P+.005
 Q $$STRIP^XLFSTR($J(P,5,2)," ")
 S P=$P(P,".")_"."_$E($P(P,".",2),1,2)
 Q P
 ; 
PLN(E) ;
 NEW S
 S S=$P(^AUPNPROB(E,0),U,6),S=$S('S:"??",$P(^AUTTLOC(S,0),U,7)]"":$P(^AUTTLOC(S,0),U,7),1:"??")
 Q S_$P(^AUPNPROB(E,0),U,7)_"  "_$$VAL^XBDIQ1(9000011,E,.05)_$S($P(^AUPNPROB(E,0),U,12)="I":" (INACTIVE)",1:"")_" ("_$$VAL^XBDIQ1(9000011,E,.01)_") "
 ;
LASTAM(P,F) ;EP - return date of last asthma management plan = yes
 I '$G(P) Q ""
 I '$G(F) S F=1
 NEW D,I,V,% S D=$O(^AUPNVAST("AM",P,0))
 I 'D Q ""
 I F=1 Q 9999999-D
 I F=2 Q $$FMTE^XLFDT(9999999-D)
 I F=3 D  Q %
 .S I=$O(^AUPNVAST("AM",P,D,1,0))
 .I I S V=$P($G(^AUPNVAST(I,0)),U,3)
 .S %=(9999999-D)_"^ASTHMA MANAGEMENT PLAN^^"_V_"^9000010.41^"_I
 Q ""
 ;
LASTSEV(P,F) ;EP - return highest CLASSIFICATION recorded
 NEW D,LAST,E,S,X,T
 I '$G(P) Q ""
 I '$G(F) S F=1
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 I 'T Q ""
 S S=""
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .S C=$P($G(^AUPNPROB(X,0)),U)
 .Q:C=""
 .Q:'$$ICD^ATXAPI(C,T,9)  ;not asthma dx
 .Q:$P(^AUPNPROB(X,0),U,15)=""  ;no classification
 .S E=$P(^AUPNPROB(X,0),U,15)
 .I E'>$P(S,U,1) Q
 .S S=E_U_$$VAL^XBDIQ1(9000011,X,.15)_U_$P(^AUPNPROB(X,0),U,3)
 I F=1 Q $P(S,U)
 I F=2 Q $P(S,U,3)
 I F=3 Q $$FMTE^XLFDT($P(S,U,3))
 I F=4 Q $P($P(S,U,2),"-",2)
 I F=5 Q $P(S,U,2)
 Q ""
