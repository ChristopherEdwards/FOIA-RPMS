BDMD996 ; IHS/CMI/LAB - 1999 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in TOBACCO1
 ;
TBCODE(P,EDATE,R) ;EP
 NEW BDMJ,BDMI
 S BDMJ=""
 ;return computed TB Status Code
 S X=$$TBTX^BDMD998(P)
 I X]"",X["TX COMPLETE" Q 1
 I X]"" Q 2
 I $$PPD^BDMD998(P,EDATE)["POS" D  Q BDMJ
 .I $$TBTX^BDMD998(P)["TX COMPLETE" S BDMJ=1 Q
 .S BDMJ=2
 .Q
 I $$PPD^BDMD998(P,EDATE)["NEG" S BDMJ=4 D  Q BDMJ
 .I $$DODX(P,R,"I")="" S BDMJ=5 Q
 .S D=$$DODX(P,R,"I"),E=$$PPD^BDMD998(P,EDATE,"I") S BDMJ=$S(D>E:4,1:3)
 .Q
 S BDMJ=6
 Q BDMJ
 ;;
1 ;;PPD +, treatment complete
2 ;;PPD +, not treated/treatment incomplete or unknown treatment
3 ;;PPD -, up-to-date (placed after dm dx)
4 ;;PPD -, before DM dx
5 ;;PPD -, DM dx date unknown
6 ;;PPD Status unknown
BI() ;
 Q $S($O(^AUTTIMM(0))>100:1,1:0)
SYSMEAN(P,BDATE,EDATE) ;EP
 NEW X S X=$$BPS^BDMD997(P,BDATE,EDATE,"I")
 I X="" Q ""
 NEW Y,C S C=0 F Y=1:1:3 I $P(X,";",Y)]"" S C=C+1
 I C'=3 Q ""
 S C=0 F Y=1:1:3 S C=$P($P(X,";",Y),"/")+C
 Q C\3
 Q ""
DIAMEAN(P,BDATE,EDATE) ;EP
 NEW X S X=$$BPS^BDMD997(P,BDATE,EDATE,"I")
 I X="" Q ""
 NEW Y,C S C=0 F Y=1:1:3 I $P(X,";",Y)]"" S C=C+1
 I C'=3 Q ""
 S C=0 F Y=1:1:3 S C=$P($P(X,";",Y),"/",2)+C
 Q C\3
PPDDATE(P,EDATE) ;EP
 NEW X S X=$$LASTNP^BDMD998(P,EDATE)
 Q X
FLU(P,BDATE,EDATE) ;EP
 NEW BDM,X,E
 S X=EDATE,%DT="P" D ^%DT S BD=Y
 S BD=$$FMADD^XLFDT(BD,-(15*30)),BD=$$FMTE^XLFDT(BD)
 S X=P_"^LAST IMM "_$S($$BI:88,1:12)_";DURING "_BD_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) Q "Yes-"_$$FMTE^XLFDT($P(BDM(1),U))
 I $$REFUSAL^BDMD997(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:88,1:12),0)),BD,EDATE) Q "Refused"
 Q "No"
PNEU(P,EDATE) ;EP
 NEW BDM,X,E
 S X=P_"^LAST IMM "_$S($$BI:33,1:19)_";DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) Q "Yes - "_$$FMTE^XLFDT($P(BDM(1),U))
 I $$REFUSAL^BDMD997(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:33,1:19),0)),$$DOB^AUPNPAT(P,"E"),EDATE) Q "Refused"
 Q "No"
TD(P,EDATE) ;EP
 NEW BDM,X,E,B,%DT,Y,TDD
 S %DT="P",X=EDATE D ^%DT S B=Y
 S X=P_"^LAST IMM "_$S($$BI:9,1:"02")_";DURING "_$$FMTE^XLFDT($$FMADD^XLFDT(B,-3653))_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) S TDD($P(BDM(1),U))=""
 K BDM S X=P_"^LAST IMM "_$S($$BI:1,1:"03")_";DURING "_$$FMTE^XLFDT($$FMADD^XLFDT(B,-3653))_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) S TDD($P(BDM(1),U))=""
 K BDM S X=P_"^LAST IMM "_$S($$BI:28,1:"34")_";DURING "_$$FMTE^XLFDT($$FMADD^XLFDT(B,-3653))_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) S TDD($P(BDM(1),U))=""
 K BDM S X=P_"^LAST IMM "_$S($$BI:20,1:"42")_";DURING "_$$FMTE^XLFDT($$FMADD^XLFDT(B,-3653))_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) S TDD($P(BDM(1),U))=""
 K BDM S BDM="",X=0 F  S X=$O(TDD(X)) Q:X'=+X  S BDM=X
 I BDM]"" Q "Yes - "_$$FMTE^XLFDT(BDM)
 S B=$$FMTE^XLFDT($$FMADD^XLFDT(B,-3653))
 I $$REFUSAL^BDMD997(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:9,1:"02"),0)),B,EDATE) Q "Refused"
 I $$REFUSAL^BDMD997(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:1,1:"03"),0)),B,EDATE) Q "Refused"
 I $$REFUSAL^BDMD997(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:28,1:34),0)),B,EDATE) Q "Refused"
 I $$REFUSAL^BDMD997(P,9999999.14,$O(^AUTTIMM("C",$S($$BI:20,1:42),0)),B,EDATE) Q "Refused"
 Q "No"
 ;
ACE(P,BDATE,EDATE) ;EP
 NEW X,BDM,E,X,Y,%DT,BD
 S X=P_"^MEDS [DM AUDIT ACE INHIBITORS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) Q "Yes"
 ;go through all v meds until 9999999-D and find all drugs with class CV800 or CV805
 NEW D,%DT K %DT S X=BDATE,%DT="P" D ^%DT S D=Y
 NEW V,I,%
 S %=""
 S I=0 F  S I=$O(^AUPNVMED("AA",P,I)) Q:I'=+I!(%)!(I>(9999999-D))  D
 .S V=0 F  S V=$O(^AUPNVMED("AA",P,I,V)) Q:V'=+V  S G=$P(^AUPNVMED(V,0),U) I $P($G(^PSDRUG(G,0)),U,2)="CV800"!($P($G(^PSDRUG(G,0)),U,2)="CV805") S %=$P($P(^AUPNVSIT($P(^AUPNVMED(V,0),U,3),0),U),".")
 Q $S(%]"":"Yes",1:"No")
 ;
SELF(P,BDATE,EDATE) ;EP
 NEW X,BDM,E
 S X=P_"^MEDS [DM AUDIT SELF MONITOR DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) Q "Yes"
 Q "No"
SDM(P,BDATE,EDATE) ;EP
 NEW T,BDM,E S T=$O(^ATXAX("B","DM AUDIT SDM PROVIDERS",0))
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
 NEW X,BDM,E
 S X=P_"^MEDS [DM AUDIT ASPIRIN DRUGS"_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(")
 I $D(BDM(1)) Q "Yes"
 Q "No"
 ;
TOBACCO(P,EDATE) ;EP
 I '$G(P) Q ""
 NEW BDMTOB,BDM,X,E
 D TOBACCO3
 I $D(BDMTOB) Q BDMTOB
 D TOBACCO0
 I $D(BDMTOB) Q BDMTOB
 D TOBACCO1 ;check Problem file for tobacco use
 I $D(BDMTOB) Q BDMTOB
 D TOBACCO2 ;check POVs for tobacco use
 I $D(BDMTOB) Q BDMTOB
 Q "4  Not Documented "
TOBACCO0 ;check for tobacco documented in health factors
 K BDM S X=P_"^LAST HEALTH [DM AUDIT TOBACCO HLTH FACTORS" S E=$$START1^APCLDF(X,"BDM(") Q:E  I $D(BDM(1)) D  ;S BDMTOBN=$O(BDMTOB("")),BDMTOB=BDMTOB(BDMTOBN)
 . I $P(BDM(1),U,3)["NON" S BDMTOB="2  Never used" Q
 . I $P(BDM(1),U,3)["PREVIOUS" S BDMTOB="3  Past use" Q
 . S BDMTOB="1  Current user"
 .Q
 Q
TOBACCO3 ;lookup in health status
 S %=$O(^ATXAX("B","DM AUDIT TOBACCO HLTH FACTORS",0))
 Q:'%
 S (X,Y)=0 F  S X=$O(^AUPNHF("AA",P,X)) Q:X'=+X!(Y)  I $D(^ATXAX(%,21,"B",X)) S Y=X
 Q:'Y
 S Y=$P(^AUTTHF(Y,0),U)
 S BDMTOB=Y
 I Y["NON" S BDMTOB="2  Never used" Q
 I Y["PREVIOUS" S BDMTOB="3  Past use" Q
 S BDMTOB="1  Current user"
 Q
TOBACCO1 ;check problem file for tobacco use
 K BDM S X=P_"^PROBLEMS [DM AUDIT PROBLEM SMOKING DXS" S E=$$START1^APCLDF(X,"BDM(") Q:E  I $D(BDM(1)) D
 . ;I $P(^ICD9($P(BDM(1),U,2),0),U,1)=305.13 S BDMTOB="3  Past use"_" - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(BDM(1),U,4),0),U,5),0),U),1,30) Q  ;cmi/anch/maw 9/10/2007 orig line
 . I $P($$ICDDX^ICDCODE($P(BDM(1),U,2)),U,2)=305.13 S BDMTOB="3  Past use"_" - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(BDM(1),U,4),0),U,5),0),U),1,30) Q  ;cmi/anch/maw 9/10/2007 csv
 . S BDMTOB="1  Current user - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(BDM(1),U,4),0),U,5),0),U),1,30)
 .Q
 Q
TOBACCO2 ;check pov file for TOBACCO USE DOC
 NEW D,%DT
 S %DT="P",X=EDATE D ^%DT S D=Y
 NEW BDATE S BDATE=$$FMADD^XLFDT(D,-365),BDATE=$$FMTE^XLFDT(BDATE)
 K BDM S X=P_"^LAST DX [DM AUDIT SMOKING RELATED DXS;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BDM(") Q:E  I $D(BDM(1)) D
 . I $P(BDM(1),U,2)=305.13 S BDMTOB="3  Past use"_" - "_$E($P(^AUTNPOV($P(^AUPNVPOV(+$P(BDM(1),U,4),0),U,4),0),U),1,30) Q
 . S BDMTOB="1  Current user"_" - "_$E($P(^AUTNPOV($P(^AUPNVPOV(+$P(BDM(1),U,4),0),U,4),0),U),1,30)
 .Q
 Q
 ;
THERAPY(P,BD,EDATE) ;EP - therapy code for epi
 I '$G(P) Q ""
 NEW STR,TNAME,X,Y,%DT
 S STR="",TNAME=""
 S X=$$INSULIN^BDMD998(P,BD,EDATE)
 I X]"" S STR=STR_"2"
 S X=$$SULF^BDMD998(P,BD,EDATE)
 I X]"" S STR=STR_3
 S X=$$MET^BDMD998(P,BD,EDATE)
 I X]"" S STR=STR_4
 S X=$$ACAR^BDMD998(P,BD,EDATE)
 I X]"" S STR=STR_5
 S X=$$TROG^BDMD998(P,BD,EDATE)
 I X]"" S STR=STR_"6"
 I STR]"" Q STR
 Q 1
 ;
TYPE(P,R,EDATE) ;EP return type 1 or 2 for epi file
 I '$G(P) Q ""
 NEW TYPE S TYPE=""
 I $G(R) S TYPE=$$CMSFDX^BDMD997(P,R,"DX")
 I TYPE="NIDDM" Q 2
 I TYPE["TYPE II" Q 2
 I TYPE="IDDM" Q 1
 I TYPE["2" Q 2
 I TYPE["1" Q 1
 S TYPE="" NEW X,I,C S X=$$PLDMDXS^BDMD997(P)
 F I=1:1 S C=$P(X,";",I) Q:C=""!(TYPE]"")  I $E(C,6)=0!($E(C,6)=2) S TYPE=2
 I TYPE]"" Q TYPE
 F I=1:1 S C=$P(X,";",I) Q:C=""!(TYPE]"")  I $E(C,6)=1!($E(C,6)=3) S TYPE=1
 I TYPE]"" Q TYPE
 S X=$$LASTDMDX^BDMD997(P,EDATE)
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
 I $G(R) S DATE=$$CMSFDX^BDMD997(P,R,"ID")
 I DATE]"" S EARLY=DATE
 S DATE=$$PLDMDOO^BDMD997(P,"I")
 I DATE]"",DATE<EARLY S EARLY=DATE
 S DATE=$$FRSTDMDX^BDMD997(P,"I")
 I DATE]"",DATE<EARLY S EARLY=DATE
 I EARLY=9999999 S EARLY=""
 Q $S(F="I":EARLY,1:$$D(EARLY))
D(D) ;
 I D="" Q ""
 Q $S($E(D,4,5)="00":"07",1:$E(D,4,5))_"/"_$S($E(D,6,7)="00":"15",1:$E(D,6,7))_"/"_$E(D,2,3)
