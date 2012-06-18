BDMS9B6 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3**;JUN 14, 2007
 ;
 ;cmi/anch/maw 8/28/2007 code set versioning in TOBACCO1
 ;
DENTAL(P,BDMSED) ;EP
 NEW BDMY,DENTDATE
 K BDMY,DENTDATE
 NEW % S %=P_"^LAST EXAM DENTAL",E=$$START1^APCLDF(%,"BDMY(")
 S %=$P($G(BDMY(1)),U) I %]"" S DENTDATE=%
 I %]"",%>BDMSED Q "Yes   "_$$FMTE^XLFDT(%)_" (Dental Exam 30 recorded)"
 K BDMY S %=P_"^LAST ADA [BDM DM ADA EXAMS",E=$$START1^APCLDF(%,"BDMY(")
 S %=$P($G(BDMY(1)),U) I %]"",%>BDMSED Q "Yes   "_$$FMTE^XLFDT(%)_" (Dental ADA exam code recorded)"
 K BDMY,BDMV,^TMP($J,"DENTAL VISITS")
 S BDMY="^TMP($J,""DENTAL VISITS"",",%=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDMSED)_"-"_$$FMTE^XLFDT(DT),E=$$START1^APCLDF(%,BDMY)
 ;reorder by date of visit/reverse order
 S %=0 F  S %=$O(^TMP($J,"DENTAL VISITS",%)) Q:%'=+%  S BDMV(9999999-$P(^TMP($J,"DENTAL VISITS",%),U),$P(^TMP($J,"DENTAL VISITS",%),U,5))=""
 K ^TMP($J,"DENTAL VISITS")
 N PROV,D,V,G S (D,V)=0,G="" F  S D=$O(BDMV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMV(D,V)) Q:V'=+V!(G)  S PROV=$$PRIMPROV^APCLV(V,"D") I PROV=52,$$ADA(V),'$$DNKA^BDMS9B4(V) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Visit to Dentist)"
 S (D,V)=0,G="" F  S D=$O(BDMV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMV(D,V)) Q:V'=+V!(G)  S PROV=$$CLINIC^APCLV(V,"C") I (PROV=56!(PROV=99)),$$ADA(V),'$$DNKA^BDMS9B4(V) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Dental Clinic Visit)"
 S G=$$REFDF^BDMS9B3(P,9999999.15,$O(^AUTTEXAM("B","DENTAL EXAM",0)),$G(DENTDATE))
 I G]"" Q G
 S (D,V)=0,G="" F  S D=$O(BDMV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(BDMV(D,V)) Q:V'=+V!(G)  S PROV=$$CLINIC^APCLV(V,"C") I (PROV=56!(PROV=99)),$D(^AUPNVDEN("AD",V)),'$$ADA(V),'$$DNKA^BDMS9B4(V) S G=9999999-D
 I G]"" Q "Patient Refused service (ada 9991) on "_$$FMTE^XLFDT(G)
 Q "No    "_$S($D(DENTDATE):$$FMTE^XLFDT(DENTDATE),1:"")
 ;
TOBACCO ;EP
 K BDMTOB
 D TOBACCO0
 I $D(BDMTOB) Q
 D TOBACCO3
 I $D(BDMTOB) Q
 D TOBACCO1 ;check Problem file for tobacco use
 I $D(BDMTOB) Q
 D TOBACCO2 ;check POVs for tobacco use
 I $D(BDMTOB) Q
 S BDMTOB="UNDOCUMENTED",BDMTOB="UNDOCUMENTED"
 Q
TOBACCO0 ;check for tobacco documented in health factors
 S X=$$LASTHF^BDMSMU(BDMSDFN,"TOBACCO","B") I X]"" S BDMTOB=X
 Q
TOBACCO3 ;lookup in health status
 S C=$O(^AUTTHF("B","TOBACCO",0)) ;ien of category passed
 I '$G(C) Q
 NEW H,D,O S H=0 K O
 F  S H=$O(^AUTTHF("AC",C,H))  Q:'+H  D
 .  Q:'$D(^AUPNHF("AA",BDMSDFN,H))
 .  S D=$O(^AUPNHF("AA",BDMSDFN,H,""))
 .  Q:'D
 .  S O(D)=$O(^AUPNHF("AA",BDMSDFN,H,D,""))
 .  Q
 S D=$O(O(0))
 I D="" Q
 S BDMTOB=$$VAL^XBDIQ1(9000010.23,O(D),.01)_" "_$$FMTE^XLFDT((9999999-D))
 Q
TOBACCO1 ;check problem file for tobacco use
 K BDM S BDMX=BDMSDFN_"^PROBLEMS [DM AUDIT PROBLEM SMOKING DXS" S E=$$START1^APCLDF(BDMX,"BDM(") Q:E  I $D(BDM(1)) D
 . ;I $P(^ICD9($P(BDM(1),U,2),0),U,1)=305.13 S BDMTOB="PAST USE OF TOBACCO"_" - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(BDM(1),U,4),0),U,5),0),U),1,30) Q  cmi/anch/maw 8/27/2007 orig line
 . I $P($$ICDDX^ICDCODE($P(BDM(1),U,2),,,1),U,2)=305.13 S BDMTOB="PAST USE OF TOBACCO"_" - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(BDM(1),U,4),0),U,5),0),U),1,30) Q  ;cmi/anch/maw 8/27/2007 code set versioning
 . S BDMTOB="YES, USES TOBACCO - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(BDM(1),U,4),0),U,5),0),U),1,30)
 .Q
 Q
TOBACCO2 ;check pov file for TOBACCO USE DOC
 K BDM S BDMX=BDMSDFN_"^LAST DX [DM AUDIT SMOKING RELATED DXS" S E=$$START1^APCLDF(BDMX,"BDM(") Q:E  I $D(BDM(1)) D
 . I $P(BDM(1),U,2)=305.13 S BDMTOB="PAST USE OF TOBACCO"_" - "_$E($P(^AUTNPOV($P(^AUPNVPOV(+$P(BDM(1),U,4),0),U,4),0),U),1,30) Q
 . S BDMTOB="YES, USES TOBACCO"_" - "_$E($P(^AUTNPOV($P(^AUPNVPOV(+$P(BDM(1),U,4),0),U,4),0),U),1,30)
 .Q
 Q
 ;
CHEST(P) ;EP - get date of last chest xray from V RAD or V CPT
 ;FIX ALL RAD LOOKUPS TO LOOP THROUGH GLOBAL
 I $G(P)="" Q ""
 NEW X,Y,Z,G,LCHEST,T,D
 S LCHEST=""
 S (X,Y,V)=0 F  S X=$O(^AUPNVRAD("AC",P,X)) Q:X'=+X  D
 .S V=$P(^AUPNVRAD(X,0),U,3),V=$P($P($G(^AUPNVSIT(V,0)),U),".")
 .S Y=$P(^AUPNVRAD(X,0),U),Y=$P($G(^RAMIS(71,Y,0)),U,9)
 .I Y>71009&(Y<71036),V>LCHEST S LCHEST=V Q
 S T=71009 F  S T=$O(^ICPT("B",T)) Q:T>71035  S X=0 F  S X=$O(^ICPT("B",T,X)) Q:X'=+X  D
 .S D=$O(^AUPNVCPT("AA",P,X,0)) I D S D=9999999-D
 .I D,D>LCHEST S LCHEST=D
 K BDMY S %=P_"^LAST PROCEDURE 87.44",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)),$P(BDMY(1),U)>LCHEST S LCHEST=$P(BDMY(1),U)
 K BDMY S %=P_"^LAST PROCEDURE 87.39",E=$$START1^APCLDF(%,"BDMY(")
 I $D(BDMY(1)),$P(BDMY(1),U)>LCHEST S LCHEST=$P(BDMY(1),U)
 Q $S(LCHEST]"":$$FMTE^XLFDT(LCHEST),1:"")
ADA(V) ;any ada other than 9991
 I '$G(V) Q ""
 NEW X,Y,Z,G
 S G="",X=0 F  S X=$O(^AUPNVDEN("AD",V,X)) Q:X'=+X!(G)  S Y=$P($G(^AUPNVDEN(X,0)),U) I Y,$D(^AUTTADA(Y,0)),$P(^AUTTADA(Y,0),U)'=9991 S G=1
 Q G
