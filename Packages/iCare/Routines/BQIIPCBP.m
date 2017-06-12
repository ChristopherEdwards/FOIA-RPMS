BQIIPCBP ;GDIT/HS/ALA-IPC Blood Pressure ; 21 Oct 2014  12:00 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;**5**;Apr 18, 2012;Build 17
 ;
PAT(DFN) ;EP
 I '$$VTHR^BQIUL1(DFN) Q "NDA"
 NEW HTN,CVD
 S HTN=$$ATAG^BQITDUTL(DFN,"Hypertension")
 S CVD=$$ATAG^BQITDUTL(DFN,"CVD Known")
 I 'CVD D
 . S CVD=$$ATAG^BQITDUTL(DFN,"CVD Highest Risk")
 . ;I 'CVD S CVD=$$ATAG^BQITDUTL(DFN,"CVD Significant Risk")
 I 'HTN,'CVD Q "N/A"
 ;
 NEW BGPVALUE,BGPVALUD,BGPBP,BDT,EDT,BGPN1,BGPN2,BPGN3,BGPN4,BGPN5,AGE
 S BGPVALUE="",BGPVALUD="",BGPBP="",BGPN5=0
 S BDT=$$DATE^BQIUL1("T-12M"),EDT=DT
 S AGE=$$AGE^BQIAGE(DFN,"")
 ;
 I AGE<18 Q "N/A"
 ;
 S BGPVALUE=$$MEANBP(DFN,BDT,EDT)
 I BGPVALUE'="" D
 . I CVD Q
 . I 'HTN Q
 . I AGE>59 S BGPN5=$S($P(BGPVALUE,U,2)=5:1,1:0)
 I BGPVALUE="" S BGPBP=$$BPCPT(DFN,BDT,EDT) I BGPBP]"" S BGPN1=1 D  G BPX
 . S (BGPN2,BGPN4)=$S($P(BGPBP,U)=1:1,1:0),BGPN3=$S('$P(BGPBP,U):1,1:0)
 S BGPN1=$S($P(BGPVALUE,U,2):1,1:0)
 S BGPN2=$S($P(BGPVALUE,U,2)=2:1,1:0)
 S BGPN3=$S($P(BGPVALUE,U,2)=3:1,1:0)
 S BGPN4=$S($P(BGPVALUE,U,2)=4:1,1:0)
 I BGPN2 S BGPN4=1  ;IF <130/80 THEN ALSO IS <140/90
 I BGPN5 S BGPN4=1  ;IF <150/90 and age then is equivalent to in control
BPX ;
 I BGPN4 Q "YES"
 Q "NO"
 ;
MEANBP(P,BDATE,EDATE,GDEV) ;EP
 NEW X,S,DS
 S GDEV=$G(GDEV)
 S X=$$BPS(P,BDATE,EDATE,"I",GDEV)
 S S=$$SYSMEAN(X) I S="" Q ""
 S DS=$$DIAMEAN(X) I DS="" Q ""
 I S<130&(DS<80) Q S_"/"_DS_U_2
 I S<140&(DS<90) Q S_"/"_DS_U_4
 I S<150&(DS<90) Q S_"/"_DS_U_5
 Q S_"/"_DS_U_3
 ;
SYSMEAN(X) ;EP
 NEW Y,C,T
 I X="" Q ""
 S C=0 F Y=1:1:3 I $P(X,";",Y)]"" S C=C+1
 I C<2 Q ""
 S T=0 F Y=1:1:3 S T=$P($P(X,";",Y),"/")+T
 Q T\C
 ;
DIAMEAN(X) ;EP
 NEW C,Y,T
 I X="" Q ""
 S C=0 F Y=1:1:3 I $P(X,";",Y)]"" S C=C+1
 I C<2 Q ""
 S T=0 F Y=1:1:3 S T=$P($P(X,";",Y),"/",2)+T
 ;Q $$STRIP^XLFSTR($J((T/C),5,1)," ")
 Q T\C
 ;
GDEV(V) ;EP
 I $P(^AUPNVSIT(V,0),U,7)="H" Q 1
 I $P(^AUPNVSIT(V,0),U,7)="I" Q 1
 I $P(^AUPNVSIT(V,0),U,7)="S" Q 1
 I $P(^AUPNVSIT(V,0),U,7)="O" Q 1
 NEW C
 S C=$$CLINIC^APCLV(V,"C")
 I C=30 Q 1
 I C=23 Q 1
 I C=44 Q 1
 I C="C1" Q 1
 I C="D4" Q 1
 Q 0
 ;
BPS(P,BDATE,EDATE,F,GDEV) ;EP ;
 I $G(F)="" S F="E"
 NEW BGPGLL,BGPGV,BGPG,A,B,E,Y,V,BGPBP,X,Z
 S BGPGLL=0,BGPGV=""
 K BGPG
 K ^TMP($J,"BPV")
 S A="^TMP($J,""BPV"",",B=P_"^LAST 365 VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"BPV",1)) Q ""
 S Y=0 F  S Y=$O(^TMP($J,"BPV",Y)) Q:Y'=+Y!(BGPGLL=3)  D
 .S V=$P(^TMP($J,"BPV",Y),U,5)
 .Q:$$CLINIC^APCLV(V,"C")=30
 .Q:$$GDEV(V)
 .Q:'$D(^AUPNVMSR("AD",V))
 .;NOW GET ALL BPS ON THIS VISIT
 .S BGPBP=""
 .S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVMSR(X,0))  ;BAD AD XREF
 ..S T=$P($G(^AUPNVMSR(X,0)),U)
 ..Q:T=""  ;BAD AD XREF
 ..Q:$P($G(^AUTTMSR(T,0)),U)'="BP"
 ..Q:$P($G(^AUPNVMSR(X,2)),U,1)  ;entered in error so skip it
 ..S Z=$P(^AUPNVMSR(X,0),U,4)  ;blood pressure value
 ..I BGPBP="" S BGPBP=Z Q
 ..I $P(Z,"/")'>$P(BGPBP,"/") S BGPBP=Z
 .Q:BGPBP=""
 .S BGPGLL=BGPGLL+1
 .I F="E" S $P(BGPGV,";",BGPGLL)=BGPBP_"  "_$$FMTE^XLFDT($P(^TMP($J,"BPV",Y),U))
 .I F="I" S $P(BGPGV,";",BGPGLL)=$P(BGPBP," ")
 K ^TMP($J,"BPV")
 Q BGPGV
 ;
BPCPT(P,BDATE,EDATE,GDEV) ;EP
 NEW S,D,C,E,BGPG,X,Y,G,T,M,A,Z,L
 K BGPG S Y="BGPG(",X=P_"^ALL VISIT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,Y)
 S X=0,G="" F  S X=$O(BGPG(X)) Q:X'=+X  D
 .S V=$P(BGPG(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:$$CLINIC^APCLV(V,"C")=30
 .Q:$$GDEV^BGP4D2(V)
 .S E=0 F  S E=$O(^AUPNVCPT("AD",V,E)) Q:E'=+E  D
 ..S C=$P($G(^AUPNVCPT(E,0)),U)
 ..I 'C Q
 ..S D=$P($P(^AUPNVSIT(V,0),U),"."),D=(9999999-D)_"."_$P(D,".",2)
 ..I $$ICD^BGP4UTL2(C,$O(^ATXAX("B","BGP SYSTOLIC BP CPTS",0)),1) D
 ...S Y=$P($$CPT^ICPTCOD(C),U,2)
 ...S:'$D(S(D)) S(D)=Y,A(D)=Y_U_"S"
 ...I +S(D)>+Y S S(D)=Y
 ..I $$ICD^BGP4UTL2(C,$O(^ATXAX("B","BGP DIASTOLIC BP CPTS",0)),1) D
 ...S Y=$P($$CPT^ICPTCOD(C),U,2)
 ...S:'$D(T(D)) T(D)=Y,A(D)=Y_U_"T"
 ...I +T(D)>+Y S T(D)=Y
 ..I $$ICD^BGP4UTL2(C,$O(^ATXAX("B","BGP BP MEASURED CPT",0)),1) D
 ...S Y=$P($$CPT^ICPTCOD(C),U,2)
 ...S:'$D(M(D)) M(D)=Y,A(D)=Y_U_"M"
 .S E=0 F  S E=$O(^AUPNVPOV("AD",V,E)) Q:E'=+E  D
 ..S Y=$$VAL^XBDIQ1(9000010.07,E,.01)
 ..I Y="" Q
 ..Q:'$$ICD^BGP4UTL2($$VALI^XBDIQ1(9000010.07,E,.01),$O(^ATXAX("B","BGP HYPERTENSION SCREEN DXS",0)),9)
 ..S D=$P($P(^AUPNVSIT(V,0),U),"."),D=(9999999-D)_"."_$P(D,".",2)
 ..S:'$D(M(D)) M(D)=Y,A(D)=Y_U_"M"
 I '$D(S),'$D(T),'$D(M) Q ""  ;
 S L=$O(A(0)),Z=$P(A(L),U,2) I Z="M" Q 0_U_$P(A(L),U,1)
 S S=$O(S(0)) I S S S=S(S)
 S D=$O(T(0)) I D S D=T(D)
 I S=""!(D="") Q 0_U_S_"/"_D
 I S="3074F"!(S="3075F"),D="3078F"!(D="3079F") Q 1_U_S_"/"_D
 Q 0_U_S_"/"_D
