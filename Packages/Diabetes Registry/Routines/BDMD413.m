BDMD413 ; IHS/CMI/LAB - 2012 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**5,8**;JUN 14, 2007;Build 53
 ;
LASTFLU(BDMPDFN,BDMBD,BDMED,BDMFORM) ;PEP - date of last FLU
 ;  Return the last recorded FLU:
 ;   - V Immunization: 15, 16, 88, 111
 ;   - V CPT [dm audit seasonal flu cpts]
 ;   If APCLFORM is A returns the string:
 ;     date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ; 
 I $G(BDMPDFN)="" Q ""
 I $G(BDMBD)="" S BDMBD=$$DOB^AUPNPAT(BDMPDFN)
 I $G(BDMED)="" S BDMED=DT
 I $G(BDMFORM)="" S BDMFORM="D"
 NEW BDMLAST,BDMVAL,BDMX,R,X,Y,V,E,T,G,BDMY,BDMF,Z,D,S
 S BDMLAST="",S=""
 S T=$O(^ATXAX("B","BGP FLU IZ CVX CODES",0))
 I 'T S S="15^16^88^111^135^140^141^144"
 I T S X=0 F  S X=$O(^ATXAX(T,21,"B",X)) Q:X=""  S S=S_X_"^"
 S R="" F E=1:1 S R=$P(S,U,E) Q:R=""  D
 .S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,R,"IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 .D E
 S BDMVAL=$$LASTCPTT^APCLAPIU(BDMPDFN,$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"DM AUDIT SEASONAL FLU CPTS","A")
 D E
 I BDMFORM="D" Q $P(BDMLAST,U)
 Q BDMLAST
E ;
 I $P(BDMVAL,U,1)>$P(BDMLAST,U,1) S BDMLAST=BDMVAL
 Q
FLU(P,BDATE,EDATE,R,F) ;EP
 NEW BDM,X,E,%,%DT,BD,B,D,C,Y,LFLU,TFLU,Z,G,T,S,A,J
 I $G(F)="" S F="E"
 I $G(R)="" S R=0
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-366)
 S LFLU=$$LASTFLU(P,BDATE,EDATE,"D")
 I LFLU]"" Q $S(F="E":"1  Yes  "_$$FMTE^XLFDT(LFLU),1:LFLU)
 ;
 I R Q ""
 S S=""
 S T=$O(^ATXAX("B","BGP FLU IZ CVX CODES",0))
 I 'T S S="15^16^88^111^135^140^141^144"
 I T S X=0 F  S X=$O(^ATXAX(T,21,"B",X)) Q:X=""  S S=S_X_"^"
 S A="",J="" F E=1:1 S A=$P(S,U,E) Q:A=""!(J]"")  D
 .S G=$$REFUSAL^BDMD417(P,9999999.14,$O(^AUTTIMM("C",A,0)),BDATE,EDATE)
 .I G,$P(G,U,2)'="N" S J="3  Refused "_$$FMTE^XLFDT($P(G,U,3)) Q
 .I G S J="2  No - Not Medically Indicated"_$$FMTE^XLFDT($P(G,U,3))
 I J]"" Q J
 S G="" F E=1:1 S Z=$P(S,U,E) Q:Z=""!(G)  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)<BDATE
 .Q:$P(^BIPC(X,0),U,4)>EDATE
 .S G=1_U_D
 I G Q "3  Refused  (Immunization package) "_$$FMTE^XLFDT($P(D,U,2))
 Q "2  No"
PNEU(P,EDATE,R,F) ;EP
 NEW BDM,X,E,B,%DT,Y,TPN,D,LPN,G,C,Z,T
 K TPN
 I $G(F)="" S F="E"
 I $G(R)="" S R=0
 S LPN=$$LASTPNEU^APCLAPI4(P,"",EDATE,"D")
 I LPN]"" Q $S(F="E":"1  Yes  "_$$FMTE^XLFDT(LPN),1:LPN)
 I R Q ""
 S G=$$REFUSAL^BDMD417(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:33,1:19),0)),$$FMTE^XLFDT($$FMADD^XLFDT(EDATE,-365)),EDATE)
 I G,$P(G,U,2)'="N" Q "3  Refused "_$$FMTE^XLFDT($P(G,U,3))
 I G Q "2  No - Not Medically Indicated "_$$FMTE^XLFDT($P(G,U,3))
 I '$$BI Q "2  No"
 S G=$$REFUSAL^BDMD417(P,9999999.14,$O(^AUTTIMM("C",100,0)),$$FMTE^XLFDT($$FMADD^XLFDT(EDATE,-365)),EDATE)
 I G,$P(G,U,2)'="N" Q "3  Refused "_$$FMTE^XLFDT($P(G,U,3))
 I G Q "2  No - Not Medically Indicated "_$$FMTE^XLFDT($P(G,U,3))
 S G=$$REFUSAL^BDMD417(P,9999999.14,$O(^AUTTIMM("C",109,0)),$$FMTE^XLFDT($$FMADD^XLFDT(EDATE,-365)),EDATE)
 I G,$P(G,U,2)'="N" Q "3  Refused "_$$FMTE^XLFDT($P(G,U,3))
 I G Q "2  No - Not Medically Indicated "_$$FMTE^XLFDT($P(G,U,3))
 S X=EDATE,%DT="P" D ^%DT S E=Y
 S G="" F Z=33,100,109 Q:G  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .;Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)>EDATE
 .S G=1_U_D
 I G Q "3  Refused "_$$FMTE^XLFDT($P(D,U,2))_"  Immunization package"
 Q "2  No"
LASTFLUN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S Y=$P(^AUPNVIMM(X,0),U) Q:'Y
 .Q:'$D(^AUTTIMM(Y,0))
 .S Y=$P(^AUTTIMM(Y,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I D<B Q  ;too early
 .I D>E Q  ;after time frame
 .I Y=88 S TFLU(9999999-D)="" Q
 .I Y=15 S TFLU(9999999-D)="" Q
 .I Y=16 S TFLU(9999999-D)="" Q
 .I Y=111 S TFLU(9999999-D)="" Q
 Q
LASTFLUO ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S Y=$P(^AUPNVIMM(X,0),U) Q:'Y
 .S Y=$P(^AUTTIMM(Y,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I D<B Q  ;too early
 .I D>E Q  ;after time frame
 .I Y=12 S TFLU(9999999-D)="" Q
 Q
LASTPNN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S Y=$P(^AUPNVIMM(X,0),U) Q:'Y
 .Q:'$D(^AUTTIMM(Y,0))
 .S Y=$P(^AUTTIMM(Y,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I D<B Q  ;too early
 .I D>E Q  ;after time frame
 .I Y=33 S TPN(9999999-D)="" Q
 .I Y=100 S TPN(9999999-D)="" Q
 .I Y=109 S TPN(9999999-D)="" Q
 Q
LASTPNO ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S Y=$P(^AUPNVIMM(X,0),U) Q:'Y
 .S Y=$P(^AUTTIMM(Y,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I D<B Q  ;too early
 .I D>E Q  ;after time frame
 .I Y=19 S TPN(9999999-D)="" Q
 Q
BI() ;
 Q $S($O(^AUTTIMM(0))>100:1,1:0)
BPS(P,BDATE,EDATE,F) ;EP ;
 I $G(F)="" S F="E"
 NEW X,BDM,E,BDML,BDMLL,BDMV,BDMVF
 S BDMLL=0,BDMV=""
 K BDM
 S X=P_"^LAST 50 MEAS BP;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 S BDML=0 F  S BDML=$O(BDM(BDML)) Q:BDML'=+BDML!(BDMLL=3)  S BDMBP=$P($G(BDM(BDML)),U,2) D
 .S BDMVF=+$P(BDM(BDML),U,4)
 .Q:$P($G(^AUPNVMSR(BDMVF,2)),U,1)  ;entered in error
 .Q:$$CLINIC^APCLV($P(BDM(BDML),U,5),"C")=30
 .S BDMLL=BDMLL+1
 .I F="E" S $P(BDMV,";",BDMLL)=BDMBP_" mm Hg "_$$FMTE^XLFDT($P(BDM(BDML),U))
 .I F="I" S $P(BDMV,";",BDMLL)=$P(BDMBP," ")
 Q BDMV
HTNDX(P,EDATE) ;EP - is HTN on problem list
 I '$G(P) Q ""
 I '$D(^DPT(P)) Q ""
 NEW %,BDM,E,X
 K BDM
 S %=P_"^PROBLEM [DM AUDIT PROBLEM HTN DIAGNOSES" S E=$$START1^APCLDF(%,"BDM(")
 I $D(BDM(1)) Q "1  Yes"
 K BDM
 S X=P_"^LAST 3 DX [SURVEILLANCE HYPERTENSION;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(3)) S Y=$$FMTE^XLFDT($P(BDM(3),U,1))_"  "_$$FMTE^XLFDT($P(BDM(2),U))_"  "_$$FMTE^XLFDT($P(BDM(1),U)) Q "1  Yes - DX on "_Y
 Q "2  No"
LASTHT(P,EDATE,F) ;PEP - return last ht and date
 I 'P Q ""
 I $G(F)="" S F="E"
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW %,BDMARRY,H,E,W,BDATE,D
 S %DT="P",X=EDATE D ^%DT S EDATE=Y
 S BDATE=$P(^DPT(P,0),U,3)
 S E=$O(^AUTTMSR("B","HT",0))
 S H=""
 S D=0 F  S D=$O(^AUPNVMSR("AA",P,E,D)) Q:D'=+D!(H]"")  D
 .S W=0 F  S W=$O(^AUPNVMSR("AA",P,E,D,W)) Q:W'=+W!(H]"")  D
 ..Q:'$D(^AUPNVMSR(W,0))
 ..Q:$P($G(^AUPNVMSR(W,2)),U,1)  ;entered in error
 ..S H=$P(^AUPNVMSR(W,0),U,4)
 ..S BDMARRY(1)=$$VD^APCLV($P(^AUPNVMSR(W,0),U,3))
 I H="" Q H
 I F="I" Q H
 S H=$J(H,5,2)
 Q H_" inches "_$$FMTE^XLFDT($P(BDMARRY(1),U))
LASTWT(P,BDATE,EDATE,F) ;PEP - return last wt
 I 'P Q ""
 I $G(F)="" S F="E"
 NEW %,BDMARRY,E,BDMW,X,BDMN,BDM,BDMD,BDMZ,BDMX,W,H,BDMVF
 K BDM S BDMW="" S BDMX=P_"^LAST 24 MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(BDMX,"BDM(")
 S BDMN=0 F  S BDMN=$O(BDM(BDMN)) Q:BDMN'=+BDMN!(BDMW]"")  D
 . S BDMVF=+$P(BDM(BDMN),U,4)
 . Q:$P($G(^AUPNVMSR(BDMVF,2)),U,1)  ;entered in error
 . S BDMZ=$P(BDM(BDMN),U,5)
 . I '$D(^AUPNVPOV("AD",BDMZ)) S BDMW=$P(BDM(BDMN),U,2)_" lbs "_$$FMTE^XLFDT($P(BDM(BDMN),U)) Q
 . S BDMD=0 F  S BDMD=$O(^AUPNVPOV("AD",BDMZ,BDMD)) Q:'BDMD!(BDMW]"")  D
 .. S ICD=$P($$ICDDX^ICDCODE($P(^AUPNVPOV(BDMD,0),U)),U,2) D  ;cmi/anch/maw 9/12/2007 csv
 ...I $E(ICD,1,3)="V22" Q
 ...I $E(ICD,1,3)="V23" Q
 ...I $E(ICD,1,3)="V27" Q
 ...I $E(ICD,1,3)="V28" Q
 ...I ICD>629.9999&(ICD<676.95) Q
 ...S BDMW=$P(BDM(BDMN),U,2)_" lbs "_$$FMTE^XLFDT($P(BDM(BDMN),U))
 ..Q
 Q $S(F="E":BDMW,1:+BDMW)
CMSFDX(P,R,T) ;EP - return date/dx of dm in register
 I '$G(P) Q ""
 I '$G(R) Q ""
 I $G(T)="" Q ""
 NEW D1,Y,X,D,G S X=0,(D,Y)="" F  S X=$O(^ACM(44,"C",P,X)) Q:X'=+X  I $P(^ACM(44,X,0),U,4)=R D
 .S D=$P($G(^ACM(44,X,"SV")),U,2),D1=D,D=$$FMTE^XLFDT(D)
 .S Y=$$VAL^XBDIQ1(9002244,X,.01)
 .I D1="" S D1=0
 .S G(9999999-D1)=D_"^"_D1_"^"_Y
 I '$O(G(0)) Q ""
 S Y=0,G=$O(G(Y))
 S D=$P(G(G),U),D1=$P(G(G),U,2),Y=$P(G(G),U,3)
 Q $S(T="D":$G(D),T="DX":$G(Y),T="ID":$G(D1),1:"")
 ;
PLDMDOO(P,F) ;EP
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"  ;deleted problem
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
 .Q:$P(^AUPNPROB(X,0),U,12)="D"  ;deleted problem
 .S I=$P(^AUPNPROB(X,0),U)
 .I $$ICD^ATXCHK(I,T,9) S:D]"" D=D_";" S D=D_$P($$ICDDX^ICDCODE(I),U,2)  ;cmi/anch/maw 9/12/2007 csv
 .Q
 Q D
 ;
FRSTDMDX(P,F) ;EP return date of first dm dx
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW X,E,BDM,Y
 S Y="BDM("
 S X=P_"^FIRST DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y) S Y=$P($G(BDM(1)),U)
 Q $S(F="E":$$FMTE^XLFDT(Y),1:Y)
LASTDMDX(P,D) ;EP - last pcc dm dx
 I '$G(P) Q ""
 NEW X,E,BDM,Y
 S Y="BDM("
 S X=P_"^LAST DX [DM AUDIT TYPE II DXS;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_D S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) Q "Type 2"
 K BDM S X=P_"^LAST DX [DM AUDIT TYPE I DXS;DURING "_$$DOB^AUPNPAT(P,"E")_"-"_D S E=$$START1^APCLDF(X,Y)
 I $D(BDM(1)) Q "Type 1"
 Q ""
INCHES ;
 NEW F,FI,Z
 S (X,Z)=$$LASTHT^BDMD413(BDMPD,BDMRED,"I")
 Q:X=""
 S X=X/12  ;get feet
 S F=$P(X,".")
 S FI=F*12  ;GET INCHES
 S X=Z-FI
 ;S X=$J(X,5,2)
 Q
DATE(D) ;EP
 I D="" Q D
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
HEP(P,EDATE,S,F) ;EP
 Q $$HEP^BDMDC13(P,$G(EDATE),$G(S),$G(F))
 NEW BDMC,BDMG,BDMX,BDMHEP,C,X,ED,G,T,BDM10743,V,Z,Y,BDMIMM,I,R,BDMZ
 ;get all immunizations
 S F=$G(F) I F="" S F="E"
 S S=$G(S)
 S C="8^42^43^44^45^51^102^104^110^132^146"
 D GETIMMS^BDMUTL(P,EDATE,C,.BDMX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BDMX(X)) Q:X'=+X  S BDMHEP(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 S T=$O(^ATXAX("B","BGP HEPATITIS CPTS",0))
 S BDM10743=0 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) S:Z=90743 BDM10743=1 I $$ICD^ATXCHK(Y,T,1) S BDMHEP(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) S:Z=90743 BDM10743=1 I $$ICD^ATXCHK(Y,T,1) S BDMHEP(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 20 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BDMHEP(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<21 K BDMHEP(X) Q
 .S Y=X
 ;now count them and see if there are 3 of them
 S BDMHEP=0,X=0 F  S X=$O(BDMHEP(X)) Q:X'=+X  S BDMHEP=BDMHEP+1
 I BDMHEP>2 Q "1  Yes"
I I BDMHEP=2,BDM10743 Q "1  Yes"  ;2 Hep B + 90743"
 I $G(S) D  Q %
 .S %=""
 .S X=0 F  S X=$O(BDMHEP(X)) Q:X'=+X  S %=X
 ;check for Evidence of desease and Contraindications and if yes, then quit
 K BDMG S %=P_"^LAST DX [BGP HEP EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BDMG(1)) Q "2  No - Evidence of Hep B"  ;_U_"Evid Hep B"
 I $$PLTAX^BDMD412(P,"BGP HEP EVIDENCE") Q "2  No - Evidence of Hep B"
 ;now go to Refusals
 S B=$$FMADD^XLFDT(EDATE,-365),E=EDATE,BDMNMI="",R=""
 F BDMIMM="8",42,43,44,45,51,102,104,110,132,146  D
 .S I=$O(^AUTTIMM("C",BDMIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BDMNMI=1 S R=1
 I R Q $S(BDMNMI:2,1:3)_"  "_$S(BDMNMI:"No - Not Medically Ind",1:"Refused")
 S R=$$CPTREFT^BDMD4DU(P,$$DOB^AUPNPAT(P),EDATE,$O(^ATXAX("B","BGP HEPATITIS CPTS",0)))
 I R S:$P(R,U,3)="N" BDMNMI=1 Q $S(BDMNMI:2,1:3)_"  "_$S(BDMNMI:"No - Not Medically Ind.",1:"Refused")_" "_$$FMTE^XLFDT($P(R,U,2))
 ;now check Refusals in imm pkg
 F BDMIMM=8,42,43,44,45,51,102,104,110,132,146 S R=$$IMMREF^BDMUTL(P,BDMIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R Q "3  Refused IMM Pkg"
 F BDMZ=8,42,43,44,45,51,102,104,110,132,146 S X=$$ANCONT^BDMUTL(P,BDMZ,EDATE) Q:X]""  ;cmi/maw 12/17/07 missing edate
 I X]"" Q X
 Q "2  No"
