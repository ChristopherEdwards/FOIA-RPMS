APCLD516 ; IHS/CMI/LAB - 2005 DIABETES AUDIT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in TOBACCO1
 ;
TBCODE(P,EDATE,R) ;EP
 NEW APCLJ,APCLI,X
 S APCLJ=""
 ;return computed TB Status Code
 S X=$$TBTX^APCLD512(P)
 I X]"",X["TX COMPLETE" Q 1
 I X]"" Q 2
 I $$PPD^APCLD518(P,EDATE)["POS" D  Q APCLJ
 .I $$TBTX^APCLD512(P)["TX COMPLETE" S APCLJ=1 Q
 .S APCLJ=2
 .Q
 I $$PPD^APCLD518(P,EDATE)["NEG" S APCLJ=4 D  Q APCLJ
 .I $$DODX(P,R,"I")="" S APCLJ=4 Q
 .S D=$$DODX(P,R,"I"),E=$$PPD^APCLD518(P,EDATE,"I") S APCLJ=$S(D>E:4,1:3)
 .Q
 S APCLJ=5
 Q APCLJ
 ;;
1 ;;PPD +, treatment complete
2 ;;PPD +, not treated/treatment incomplete or unknown treatment
3 ;;PPD -, up-to-date (placed after dm dx)
4 ;;PPD -, before DM dx or date unknown
5 ;;PPD Status unknown
BI() ;
 Q $S($O(^AUTTIMM(0))>100:1,1:0)
SYSMEAN(P,BDATE,EDATE) ;EP
 NEW X S X=$$BPS^APCLD513(P,BDATE,EDATE,"I")
 I X="" Q ""
 NEW Y,C S C=0 F Y=1:1:3 I $P(X,";",Y)]"" S C=C+1
 I C'=3 Q ""
 S C=0 F Y=1:1:3 S C=$P($P(X,";",Y),"/")+C
 Q C\3
 Q ""
DIAMEAN(P,BDATE,EDATE) ;EP
 NEW X S X=$$BPS^APCLD513(P,BDATE,EDATE,"I")
 I X="" Q ""
 NEW Y,C S C=0 F Y=1:1:3 I $P(X,";",Y)]"" S C=C+1
 I C'=3 Q ""
 S C=0 F Y=1:1:3 S C=$P($P(X,";",Y),"/",2)+C
 Q C\3
PPDDATE(P,EDATE) ;EP
 NEW X S X=$$LASTNP^APCLD518(P,EDATE)
 Q X
LIPID(P,BDATE,EDATE) ;EP
 NEW X,APCL,E,G,S,O
 S (S,O,G)="",X=P_"^MEDS [DM AUDIT LIPID LOWERING DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) S O=1
 K APCL
 S X=P_"^MEDS [DM AUDIT STATIN DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) S S=1
 I S,O Q "Both"
 I S Q "Statin"
 I O Q "Other"
 ;refusal of NMI
 S G=0
 NEW T S T=$O(^ATXAX("B","DM AUDIT LIPID LOWERING DRUGS",0))
 I 'T Q "None"
 S X=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^APCLD517(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None-Not Medically Indicated"
 NEW T S T=$O(^ATXAX("B","DM AUDIT STATIN DRUGS",0))
 I 'T Q "None"
 S (X,G)=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^APCLD517(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None-Not Medically Indicated"
 ;
 Q "None"
 ;
 ;
ACE(P,BDATE,EDATE) ;EP
 NEW X,APCL,E,X,Y,%DT,BD,G
 S X=P_"^MEDS [DM AUDIT ACE INHIBITORS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "Yes"
 ;go through all v meds until 9999999-D and find all drugs with class CV800 or CV805
 NEW D,%DT K %DT S X=BDATE,%DT="P" D ^%DT S D=Y
 NEW V,I,%
 S %=""
 S I=0 F  S I=$O(^AUPNVMED("AA",P,I)) Q:I'=+I!(%)!(I>(9999999-D))  D
 .S V=0 F  S V=$O(^AUPNVMED("AA",P,I,V)) Q:V'=+V  S G=$P(^AUPNVMED(V,0),U) I $P($G(^PSDRUG(G,0)),U,2)="CV800"!($P($G(^PSDRUG(G,0)),U,2)="CV805") S %=$P($P(^AUPNVSIT($P(^AUPNVMED(V,0),U,3),0),U),".")
 I %]"" Q "Yes"
 ;refusals
 NEW T S T=$O(^ATXAX("B","DM AUDIT ACE INHIBITORS",0))
 I 'T Q "No"
 S (G,X)=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^APCLD517(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 Q "No"_$S(G:" - Not Medically Indicated",1:"")
 ;
SELF(P,BDATE,EDATE) ;EP
 NEW T,APCL,E,X,%DT,Y,ED,BD
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S E=$$LASTHF^APCLD519(P,"DIABETES SELF MONITORING",BD,ED,"F")
 I E]"" Q $S(E["YES":"Yes",E["NO":"No",E["REFUSED":"Refused",1:"")
 S X=P_"^MEDS [DM AUDIT SELF MONITOR DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) Q "Yes"
 Q "No"
SDM(P,BDATE,EDATE) ;EP
 NEW T,APCL,E,X,%DT,Y,ED,BD
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S E=$$LASTHF^APCLD519(P,"STAGED DIABETES MANAGEMENT",BD,ED)
 I E Q "Yes"
 S T=$O(^ATXAX("B","DM AUDIT SDM PROVIDERS",0))
 I 'T Q ""
 S %=P_"^ALL DX [SURVEILLANCE DIABETES;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"APCL(")
 ;check to see if one of the providers was the primary prov
 NEW X,V,G,P,P1 S (G,X)=0 F  S X=$O(APCL(X)) Q:X'=+X!(G)  S V=$P(APCL(X),U,5) D
 .S P=0 F  S P=$O(^AUPNVPRV("AD",V,P)) Q:P'=+P!(G)  S P1=$P(^AUPNVPRV(P,0),U) I $D(^ATXAX(T,21,"B",P1)) S G=1
 .Q
 Q $S(G:"Yes",1:"No")
 ;
ASPIRIN(P,BDATE,EDATE) ;EP
 NEW X,APCL,E,A,N,G
 S (A,B,G,N)=""
 S X=P_"^MEDS [DM AUDIT ASPIRIN DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) S A=1
 K APCL S X=P_"^MEDS [DM AUDIT ANTI-PLATELET DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL(1)) S N=1
 I A+N=2 Q "Both"
 I A Q "Aspirin"
 I N Q "Other"
 ;refusal oR NMI
 S G=0
 NEW T S T=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 I 'T Q "None"
 S X=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^APCLD517(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None - Not Medically Indicated"
 NEW T S T=$O(^ATXAX("B","DM AUDIT ANTI-PLATELET DRUGS",0))
 I 'T Q "None"
 S (X,G)=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^APCLD517(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None - Not Medically Indicated"
 ;
 Q "None"
 ;
TOBACCO(P,EDATE) ;EP
 I '$G(P) Q ""
 NEW APCLTOB,APCL,X,E
 D TOBACCO0
 I $D(APCLTOB) Q APCLTOB
 ;D TOBACCO3
 ;I $D(APCLTOB) Q APCLTOB
 D TOBACCO1 ;check Problem file for tobacco use
 I $D(APCLTOB) Q APCLTOB
 D TOBACCO2 ;check POVs for tobacco use
 I $D(APCLTOB) Q APCLTOB
 S X=$$DENT(P,APCLRBD,APCLRED)
 I X]"" Q X
 Q "3  Not Documented "
TOBACCO0 ;check for tobacco documented in health factors
 K APCL S X=P_"^LAST HEALTH [DM AUDIT TOBACCO HLTH FACTORS"_";DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(") Q:E  I $D(APCL(1)) D  ;S APCLTOBN=$O(APCLTOB("")),APCLTOB=APCLTOB(APCLTOBN)
 . I $P(APCL(1),U,3)["CURRENT"!($P(APCL(1),U,3)["CESS") S APCLTOB="1  Current User" Q
 . S APCLTOB="2  Not a Current User "
 .Q
 Q
TOBACCO3 ;lookup in health status
 S %=$O(^ATXAX("B","DM AUDIT TOBACCO HLTH FACTORS",0))
 Q:'%
 S X=0 K Y F  S X=$O(^AUPNHF("AA",P,X)) Q:X'=+X  I $D(^ATXAX(%,21,"B",X)) S D=$O(^AUPNHF("AA",P,X,0)),Y(9999999-D)=X
 Q:'$D(Y)
 S X=$O(Y(0))
 S Y=Y(X)
 S Y=$P(^AUTTHF(Y,0),U)
 S APCLTOB=Y
 I Y["CURRENT"!(Y["CESS") S APCLTOB="1  Current User" Q
 S APCLTOB="2  Not a Current User"
 Q
TOBACCO1 ;check problem file for tobacco use
 K APCL S X=P_"^PROBLEMS [DM AUDIT PROBLEM SMOKING DXS" S E=$$START1^APCLDF(X,"APCL(") Q:E  I $D(APCL(1)) D
 . ;I $P(^ICD9($P(APCL(1),U,2),0),U,1)=305.13 S APCLTOB="2  Not a Current User"_" - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(APCL(1),U,4),0),U,5),0),U),1,30) Q  ;cmi/anch/maw 9/10/2007 orig line
 . I $P($$ICDDX^ICDCODE($P(APCL(1),U,2)),U,2)=305.13 S APCLTOB="2  Not a Current User"_" - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(APCL(1),U,4),0),U,5),0),U),1,30) Q  ;cmi/anch/maw 9/10/2007 csv
 . S APCLTOB="1  Current user - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(APCL(1),U,4),0),U,5),0),U),1,30)
 .Q
 Q
TOBACCO2 ;check pov file for TOBACCO USE DOC
 NEW D,%DT
 S %DT="P",X=EDATE D ^%DT S D=Y
 NEW BDATE S BDATE=$$FMADD^XLFDT(D,-365),BDATE=$$FMTE^XLFDT(BDATE)
 K APCL S X=P_"^LAST DX [DM AUDIT SMOKING RELATED DXS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"APCL(") Q:E  I $D(APCL(1)) D
 . I $P(APCL(1),U,2)=305.13 S APCLTOB="2  Not a Current User"_" - "_$E($P(^AUTNPOV($P(^AUPNVPOV(+$P(APCL(1),U,4),0),U,4),0),U),1,30) Q
 . S APCLTOB="1  Current user"_" - "_$E($P(^AUTNPOV($P(^AUPNVPOV(+$P(APCL(1),U,4),0),U,4),0),U),1,30)
 .Q
 Q
DENT(P,BDATE,EDATE) ;EP
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S X=0,G="" F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .S Z=0 F  S Z=$O(^AUPNVDEN("AD",V,Z)) Q:Z'=+Z!(G)  S B=$P($G(^AUPNVDEN(Z,0)),U) I B S B=$P($G(^AUTTADA(B,0)),U) I B=1320 S G="1  Current user - Ada Code 1320 "
 .Q
 Q G
 ;
THERAPY(P,BD,EDATE) ;EP - therapy code for epi
 I '$G(P) Q ""
 NEW STR,TNAME,X,Y,%DT
 S STR="",TNAME=""
 S X=$$INSULIN^APCLD512(P,BD,EDATE)
 I X]"" S STR=STR_"2"
 S X=$$SULF^APCLD512(P,BD,EDATE)
 I X]"" S STR=STR_3
 S X=$$MET^APCLD512(P,BD,EDATE)
 I X]"" S STR=STR_4
 S X=$$ACAR^APCLD512(P,BD,EDATE)
 I X]"" S STR=STR_5
 S X=$$TROG^APCLD512(P,BD,EDATE)
 I X]"" S STR=STR_"6"
 I STR]"" Q STR
 S X=$$REFMED^APCLD512(P,BD,EDATE)
 I X Q 9
 Q 1
 ;
TYPE(P,R,EDATE) ;EP return type 1 or 2 for epi file
 I '$G(P) Q ""
 NEW TYPE S TYPE=""
 I $G(R) S TYPE=$$CMSFDX^APCLD513(P,R,"DX")
 I TYPE="NIDDM" Q 2
 I TYPE["TYPE II" Q 2
 I TYPE="IDDM" Q 1
 I TYPE["2" Q 2
 I TYPE["1" Q 1
 S TYPE="" NEW X,I,C S X=$$PLDMDXS^APCLD513(P)
 F I=1:1 S C=$P(X,";",I) Q:C=""!(TYPE]"")  I $E(C,6)=0!($E(C,6)=2) S TYPE=2
 I TYPE]"" Q TYPE
 F I=1:1 S C=$P(X,";",I) Q:C=""!(TYPE]"")  I $E(C,6)=1!($E(C,6)=3) S TYPE=1
 I TYPE]"" Q TYPE
 S X=$$LASTDMDX^APCLD513(P,EDATE)
 I X[2 Q 2
 I X[1 Q 1
 Q ""
 ;
DURDM(P,R,EDATE) ;EP
 I '$G(P) Q ""
 NEW Y S Y=$$DODX(P,R,"I")
 I Y="" Q ""
 I Y>EDATE Q ""
 Q ($$FMDIFF^XLFDT(EDATE,Y,1)\365)
DODX(P,R,F) ;EP - date of dx for epi file
 I $G(F)="" S F="E"
 NEW DATE,EARLY
 S DATE="",EARLY=9999999
 I $G(R) S DATE=$$CMSFDX^APCLD513(P,R,"ID")
 I DATE]"" S EARLY=DATE
 S DATE=$$PLDMDOO^APCLD513(P,"I")
 I DATE]"",DATE<EARLY S EARLY=DATE
 I EARLY=9999999 S EARLY=""
 Q $S(F="I":EARLY,1:$$D(EARLY))
D(D) ;
 I D="" Q ""
 Q $S($E(D,4,5)="00":"07",1:$E(D,4,5))_"/"_$S($E(D,6,7)="00":"15",1:$E(D,6,7))_"/"_(1700+$E(D,1,3))
 ;
 ;;
