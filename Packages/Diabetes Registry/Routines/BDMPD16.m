BDMPD16 ; IHS/CMI/LAB - 2003 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;
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
 S X=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^BDMPD17(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None - Not Medically Indicated"
 NEW T S T=$O(^ATXAX("B","DM AUDIT ANTI-PLATELET DRUGS",0))
 I 'T Q "None"
 S (X,G)=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^BDMPD17(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None - Not Medically Indicated"
 ;
 Q "None"
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
 S X=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^BDMPD17(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None - Not Medically Indicated"
 NEW T S T=$O(^ATXAX("B","DM AUDIT STATIN DRUGS",0))
 I 'T Q "None"
 S (X,G)=0 F  S X=$O(^ATXAX(T,21,X)) Q:X'=+X!(G)  S G=$$REFUSAL^BDMPD17(P,50,$P(^ATXAX(T,21,X,0),U),BDATE,EDATE)
 I G,$P(G,U,2)'="N" Q "Refused"
 I G Q "None - Not Medically Indicated"
 ;
 Q "None"
 ;
THERAPY(P,BD,EDATE) ;EP - therapy code for epi
 I '$G(P) Q ""
 NEW STR,TNAME,X,Y,%DT
 S STR="",TNAME=""
 S X=$$SULF^BDMDD12(P,BD,EDATE)
 I X]"" S STR=STR_5
 S X=$$MET^BDMDD12(P,BD,EDATE)
 I X]"" S STR=STR_2
 S X=$$ACAR^BDMDD12(P,BD,EDATE)
 I X]"" S STR=STR_3
 S X=$$TROG^BDMDD12(P,BD,EDATE)
 I X]"" S STR=STR_"4"
 I STR]"" Q STR
 Q 1
 ;
