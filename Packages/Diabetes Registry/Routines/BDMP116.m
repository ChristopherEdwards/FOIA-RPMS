BDMP116 ; IHS/CMI/LAB - 2003 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**4**;JUN 14, 2007
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in TOBACCO1
 ;
SYSMEAN(P,BDATE,EDATE) ;EP
 NEW X S X=$$BPS^BDMP113(P,BDATE,EDATE,"I")
 I X="" Q ""
 NEW Y,C S C=0 F Y=1:1:3 I $P(X,";",Y)]"" S C=C+1
 I C'=3 Q ""
 S C=0 F Y=1:1:3 S C=$P($P(X,";",Y),"/")+C
 Q C\3
 Q ""
DIAMEAN(P,BDATE,EDATE) ;EP
 NEW X S X=$$BPS^BDMP113(P,BDATE,EDATE,"I")
 I X="" Q ""
 NEW Y,C S C=0 F Y=1:1:3 I $P(X,";",Y)]"" S C=C+1
 I C'=3 Q ""
 S C=0 F Y=1:1:3 S C=$P($P(X,";",Y),"/",2)+C
 Q C\3
LIPID(P,BDATE,EDATE) ;EP
 NEW X,BDM,E,G,S,O
 S (S,O,G)="",X=P_"^MEDS [DM AUDIT LIPID LOWERING DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) S O=1
 K BDM
 S X=P_"^MEDS [DM AUDIT STATIN DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) S S=1
 I S,O Q "Both"
 I S Q "Statin"
 I O Q "Other"
 ;refusal of NMI
 S G=0
 NEW T S T=$O(^ATXAX("B","DM AUDIT LIPID LOWERING DRUGS",0))
 I 'T Q "None"
 S X=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^BDMP117(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None - Not Medically Indicated"
 NEW T S T=$O(^ATXAX("B","DM AUDIT STATIN DRUGS",0))
 I 'T Q "None"
 S (X,G)=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^BDMP117(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None - Not Medically Indicated"
 ;
 Q "None"
 ;
 ;
ACE(P,BDATE,EDATE) ;EP
 NEW X,BDM,E,X,Y,%DT,BD,G
 S X=P_"^MEDS [DM AUDIT ACE INHIBITORS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) Q "Yes"
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
 S (G,X)=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^BDMP117(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 Q "No"_$S(G:" - Not Medically Indicated",1:"")
 ;
SELF(P,BDATE,EDATE) ;EP
 NEW T,BDM,E,X,%DT,Y,ED,BD
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S E=$$LASTHF^BDMP119(P,"DIABETES SELF MONITORING",BD,ED,"F")
 I E]"" Q $S(E["YES":"Yes",E["NO":"No",E["REFUSED":"Refused",1:"")
 S X=P_"^MEDS [DM AUDIT SELF MONITOR DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) Q "Yes"
 Q "No"
SDM(P,BDATE,EDATE) ;EP
 NEW T,BDM,E,X,%DT,Y,ED,BD
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 S X=BDATE,%DT="P" D ^%DT S BD=Y
 S E=$$LASTHF^BDMP119(P,"STAGED DIABETES MANAGEMENT",BD,ED)
 I E Q "Yes"
 S T=$O(^ATXAX("B","DM AUDIT SDM PROVIDERS",0))
 I 'T Q ""
 S %=P_"^ALL DX [SURVEILLANCE DIABETES;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BDM(")
 ;check to see if one of the providers was the primary prov
 NEW X,V,G,P,P1 S (G,X)=0 F  S X=$O(BDM(X)) Q:X'=+X!(G)  S V=$P(BDM(X),U,5) D
 .S P=0 F  S P=$O(^AUPNVPRV("AD",V,P)) Q:P'=+P!(G)  S P1=$P(^AUPNVPRV(P,0),U) I $D(^ATXAX(T,21,"B",P1)) S G=1
 .Q
 Q $S(G:"Yes",1:"No")
PERI(P,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 NEW BDM,% S %=P_"^LAST ADA [DM AUDIT PERIDONTAL ADA CODES;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BDM(")
 I $D(BDM(1)) Q "Yes "_$$FMTE^XLFDT($P(BDM(1),U))
 K BDM
 S %=P_"^ALL VISITS;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BDM(")
 NEW X,Y S X=0,Y=0 F  S X=$O(BDM(X)) Q:X'=+X!(Y)  I $$CLINIC^APCLV($P(BDM(X),U,5),"C")=56 S Y=1
 I Y Q "Yes - clinic 56 visit"
 Q "No"
 ;
ASPIRIN(P,BDATE,EDATE) ;EP
 NEW X,BDM,E,A,N,G
 S (A,B,G,N)=""
 S X=P_"^MEDS [DM AUDIT ASPIRIN DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) S A=1
 K BDM S X=P_"^MEDS [DM AUDIT ANTI-PLATELET DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) S N=1
 I A+N=2 Q "Both"
 I A Q "Aspirin"
 I N Q "Other"
 ;refusal of NMI
 S G=0
 NEW T S T=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 I 'T Q "None"
 S X=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^BDMP117(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None - Not Medically Indicated"
 NEW T S T=$O(^ATXAX("B","DM AUDIT ANTI-PLATELET DRUGS",0))
 I 'T Q "None"
 S (X,G)=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^BDMP117(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None - Not Medically Indicated"
 ;
 Q "None"
 ;
TOBACCO(P,EDATE) ;EP
 I '$G(P) Q ""
 NEW BDMTOB,BDM,X,E
 D TOBACCO0
 I $D(BDMTOB) Q BDMTOB
 D TOBACCO3
 I $D(BDMTOB) Q BDMTOB
 D TOBACCO1 ;check Problem file for tobacco use
 I $D(BDMTOB) Q BDMTOB
 D TOBACCO2 ;check POVs for tobacco use
 I $D(BDMTOB) Q BDMTOB
 Q "3  Not Documented "
TOBACCO0 ;check for tobacco documented in health factors
 K BDM S X=P_"^LAST HEALTH [DM AUDIT TOBACCO HLTH FACTORS" S E=$$START1^APCLDF(X,"BDM(") Q:E  I $D(BDM(1)) D  ;S BDMTOBN=$O(BDMTOB("")),BDMTOB=BDMTOB(BDMTOBN)
 . I $P(BDM(1),U,3)["CURRENT" S BDMTOB="1  Current User" Q
 . S BDMTOB="2  Not a Current User "
 .Q
 Q
TOBACCO3 ;lookup in health status
 S %=$O(^ATXAX("B","DM AUDIT TOBACCO HLTH FACTORS",0))
 Q:'%
 S (X,Y)=0 F  S X=$O(^AUPNHF("AA",P,X)) Q:X'=+X!(Y)  I $D(^ATXAX(%,21,"B",X)) S Y=X
 Q:'Y
 S Y=$P(^AUTTHF(Y,0),U)
 S BDMTOB=Y
 I Y["CURRENT" S BDMTOB="1  Current User" Q
 S BDMTOB="2  Not a Current User"
 Q
TOBACCO1 ;check problem file for tobacco use
 K BDM S X=P_"^PROBLEMS [DM AUDIT PROBLEM SMOKING DXS" S E=$$START1^APCLDF(X,"BDM(") Q:E  I $D(BDM(1)) D
 . ;I $P(^ICD9($P(BDM(1),U,2),0),U,1)=305.13 S BDMTOB="2  Not a Current User"_" - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(BDM(1),U,4),0),U,5),0),U),1,30) Q  ;cmi/anch/maw 9/10/2007 orig line
 . I $P($$ICDDX^ICDCODE($P(BDM(1),U,2)),U,2)=305.13 S BDMTOB="2  Not a Current User"_" - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(BDM(1),U,4),0),U,5),0),U),1,30) Q  ;cmi/anch/maw 9/12/2007 csv
 . S BDMTOB="1  Current user - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(BDM(1),U,4),0),U,5),0),U),1,30)
 .Q
 Q
TOBACCO2 ;check pov file for TOBACCO USE DOC
 NEW D,%DT
 S %DT="P",X=EDATE D ^%DT S D=Y
 NEW BDATE S BDATE=$$FMADD^XLFDT(D,-365),BDATE=$$FMTE^XLFDT(BDATE)
 K BDM S X=P_"^LAST DX [DM AUDIT SMOKING RELATED DXS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(") Q:E  I $D(BDM(1)) D
 . I $P(BDM(1),U,2)=305.13 S BDMTOB="2  Not a Current User"_" - "_$E($P(^AUTNPOV($P(^AUPNVPOV(+$P(BDM(1),U,4),0),U,4),0),U),1,30) Q
 . S BDMTOB="1  Current user"_" - "_$E($P(^AUTNPOV($P(^AUPNVPOV(+$P(BDM(1),U,4),0),U,4),0),U),1,30)
 .Q
 Q
 ;
THERAPY(P,BD,EDATE) ;EP - therapy code for epi
 I '$G(P) Q ""
 NEW STR,TNAME,X,Y,%DT
 S STR="",TNAME=""
 S X=$$SULF^BDMP112(P,BD,EDATE)
 I X]"" S STR=STR_5
 S X=$$MET^BDMP112(P,BD,EDATE)
 I X]"" S STR=STR_2
 S X=$$ACAR^BDMP112(P,BD,EDATE)
 I X]"" S STR=STR_3
 S X=$$TROG^BDMP112(P,BD,EDATE)
 I X]"" S STR=STR_"4"
 I STR]"" Q STR
 Q 1
 ;
TYPE(P,R,EDATE) ;EP return type 1 or 2 for epi file
 I '$G(P) Q ""
 NEW TYPE S TYPE=""
 I $G(R) S TYPE=$$CMSFDX^BDMP113(P,R,"DX")
 I TYPE="NIDDM" Q 2
 I TYPE["TYPE II" Q 2
 I TYPE="IDDM" Q 1
 I TYPE["2" Q 2
 I TYPE["1" Q 1
 S TYPE="" NEW X,I,C S X=$$PLDMDXS^BDMP113(P)
 F I=1:1 S C=$P(X,";",I) Q:C=""!(TYPE]"")  I $E(C,6)=0!($E(C,6)=2) S TYPE=2
 I TYPE]"" Q TYPE
 F I=1:1 S C=$P(X,";",I) Q:C=""!(TYPE]"")  I $E(C,6)=1!($E(C,6)=3) S TYPE=1
 I TYPE]"" Q TYPE
 S X=$$LASTDMDX^BDMP113(P,EDATE)
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
 I $G(R) S DATE=$$CMSFDX^BDMP113(P,R,"ID")
 I DATE]"" S EARLY=DATE
 S DATE=$$PLDMDOO^BDMP113(P,"I")
 I DATE]"",DATE<EARLY S EARLY=DATE
 I EARLY=9999999 S EARLY=""
 Q $S(F="I":EARLY,1:$$D(EARLY))
D(D) ;
 I D="" Q ""
 Q $S($E(D,4,5)="00":"07",1:$E(D,4,5))_"/"_$S($E(D,6,7)="00":"15",1:$E(D,6,7))_"/"_(1700+$E(D,1,3))
 ;
 ;;
