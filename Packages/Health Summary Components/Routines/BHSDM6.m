BHSDM6 ;IHS/CIA/MGH - Health Summary for Diabetic Supplement ;04-Aug-2011 14:33;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1,2,6**;March 17, 2006;Build 5
 ;===================================================================
 ;Taken from APCHS9B6
 ;VA version of IHS components for supplemental summaries
 ; IHS/TUCSON/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ;  [ 02/20/04  1:53 PM ]
 ;;2.0;IHS RPMS/PCC Health Summary;**8,11,12**;JUN 24, 1997
 ;Patch 1 updates up to IHS patch 14
 ;Patch 2 code set versioning
 ;Patch 6 updated for tobacco changes
 ;===================================================================
DENTAL(P,APCHSED) ;EP
 NEW BHSY,DENTDATE,E
 K BHSY,DENTDATE
 NEW % S %=P_"^LAST EXAM DENTAL",E=$$START1^APCLDF(%,"BHSY(")
 S %=$P($G(BHSY(1)),U) I %]"" S DENTDATE=%
 I %]"",%>APCHSED Q "Yes   "_$$FMTE^XLFDT(%)_" (Dental Exam 30 recorded)"
 K BHSY S %=P_"^LAST ADA [APCH DM ADA EXAMS",E=$$START1^APCLDF(%,"BHSY(")
 S %=$P($G(BHSY(1)),U) I %]"",%>APCHSED Q "Yes   "_$$FMTE^XLFDT(%)_" (Dental ADA exam code recorded)"
 K BHSY,APCHV,^TMP($J,"DENTAL VISITS")
 S BHSY="^TMP($J,""DENTAL VISITS"",",%=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(APCHSED)_"-"_$$FMTE^XLFDT(DT),E=$$START1^APCLDF(%,BHSY)
 ;reorder by date of visit/reverse order
 S %=0 F  S %=$O(^TMP($J,"DENTAL VISITS",%)) Q:%'=+%  S APCHV(9999999-$P(^TMP($J,"DENTAL VISITS",%),U),$P(^TMP($J,"DENTAL VISITS",%),U,5))=""
 K ^TMP($J,"DENTAL VISITS")
 N PROV,D,V,G S (D,V)=0,G="" F  S D=$O(APCHV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(APCHV(D,V)) Q:V'=+V!(G)  S PROV=$$PRIMPROV^APCLV(V,"D") I PROV=52,$$ADA(V),'$$DNKA^BHSDM4(V) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Visit to Dentist)"
 S (D,V)=0,G="" F  S D=$O(APCHV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(APCHV(D,V)) Q:V'=+V!(G)  S PROV=$$CLINIC^APCLV(V,"C") I (PROV=56!(PROV=99)),$$ADA(V),'$$DNKA^BHSDM4(V) S G=9999999-D
 I G]"" Q "Maybe "_$$FMTE^XLFDT(G)_" (Dental Clinic Visit)"
 S G=$$REFDF^BHSDM3(P,9999999.15,$O(^AUTTEXAM("B","DENTAL EXAM",0)),$G(DENTDATE))
 I G]"" Q G
 S (D,V)=0,G="" F  S D=$O(APCHV(D)) Q:D'=+D!(G)  S V=0 F  S V=$O(APCHV(D,V)) Q:V'=+V!(G)  S PROV=$$CLINIC^APCLV(V,"C") I (PROV=56!(PROV=99)),$D(^AUPNVDEN("AD",V)),'$$ADA(V),'$$DNKA^BHSDM4(V) S G=9999999-D
 I G]"" Q "Patient Refused service (ada 9991) on "_$$FMTE^XLFDT(G)
 Q "No    "_$S($D(DENTDATE):$$FMTE^XLFDT(DENTDATE),1:"")
 ;
TOBACCO ;EP
 K BHDTOB
 ;D TOBACCO3
 ;I $D(BHDTOB) Q
 D TOBACCO0
 I $D(BHDTOB) Q
 D TOBACCO3
 I $D(BHDTOB) Q
 D TOBACCO1 ;check Problem file for tobacco use
 I $D(BHDTOB) Q
 D TOBACCO2 ;check POVs for tobacco use
 I $D(BHDTOB) Q
 S BHDTOB="UNDOCUMENTED",BHDTOB="UNDOCUMENTED"
 Q
TOBACCO0 ;check for tobacco documented in health factors
 ;S X=$$LASTHF^BHSMU(BHSDFN,"TOBACCO","B") I X]"" S BHDTOB=X
 NEW CTGN,HF,HFDT,LIST,RESULT,X,BTIU,BHST,CTG
 I '$G(DFN) Q ""
 F BHST=1:1 D  Q:CTG=""
 .S CTG=$P($T(TOBU+BHST),";;",2)
 .Q:CTG=""
 .S CTGN=$O(^AUTTHF("B",CTG,0)) I 'CTGN Q    ;ien of category passed
 .;
 .S HF=0
 .F  S HF=$O(^AUTTHF("AC",CTGN,HF))  Q:'+HF  D        ;find health factors in category
 ..Q:'$D(^AUPNVHF("AA",DFN,HF))                     ;quit if patient doesn't have health factor
 ..S HFDT=$O(^AUPNVHF("AA",DFN,HF,"")) Q:'HFDT      ;get visit date for health factor
 ..S LIST(HFDT)=$O(^AUPNVHF("AA",DFN,HF,HFDT,""))   ;store iens by date
 ;
 I '$O(LIST(0)) Q
 S HFDT=$O(LIST(0))                                  ;find latest date (inverse dates)
 S RESULT=$$GET1^DIQ(9000010.23,LIST(HFDT),.01)
 S BHDTOB=RESULT_" "_$$FMTE^XLFDT(9999999-HFDT)
 Q
TOBU ;;
 ;;TOBACCO (EXPOSURE)
 ;;TOBACCO (SMOKELESS - CHEWING/DIP)
 ;;TOBACCO (SMOKING)
 ;
 Q
TOBACCO3 ;lookup in health status
 N C
 S C=$O(^AUTTHF("B","TOBACCO",0)) ;ien of category passed
 I '$G(C) Q
 NEW H,D,O S H=0 K O
 F  S H=$O(^AUTTHF("AC",C,H))  Q:'+H  D
 .  Q:'$D(^AUPNHF("AA",BHSDFN,H))
 .  S D=$O(^AUPNHF("AA",BHSDFN,H,""))
 .  Q:'D
 .  S O(D)=$O(^AUPNHF("AA",BHSDFN,H,D,""))
 .  Q
 S D=$O(O(0))
 I D="" Q
 S BHDTOB=$$VAL^XBDIQ1(9000010.23,O(D),.01)_" "_$$FMTE^XLFDT((9999999-D))
 Q
TOBACCO1 ;check problem file for tobacco use
 K APCH,APCHX
 S APCHX=BHSDFN_"^PROBLEMS [DM AUDIT PROBLEM SMOKING DXS" S E=$$START1^APCLDF(APCHX,"APCH(") Q:E  I $D(APCH(1)) D
 . ;I $P(^ICD9($P(APCH(1),U,2),0),U,1)=305.13 S BHDTOB="PAST USE OF TOBACCO"_" - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(APCH(1),U,4),0),U,5),0),U),1,30) Q
 . I $$ICDDX^ICDCODE($P(APCH(1),U,2),U,2)=305.13 S BHDTOB="PAST USE OF TOBACCO"_" - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(APCH(1),U,4),0),U,5),0),U),1,30) Q  ;code set versioning cmi/anch/maw 8/27/2007 code set versioning
 . S BHDTOB="YES, USES TOBACCO - "_$E($P(^AUTNPOV($P(^AUPNPROB(+$P(APCH(1),U,4),0),U,5),0),U),1,30)
 .Q
 Q
TOBACCO2 ;check pov file for TOBACCO USE DOC
 K APCH S APCHX=BHSDFN_"^LAST DX [DM AUDIT SMOKING RELATED DXS" S E=$$START1^APCLDF(APCHX,"APCH(") Q:E  I $D(APCH(1)) D
 . I $P(APCH(1),U,2)=305.13 S BHDTOB="PAST USE OF TOBACCO"_" - "_$E($P(^AUTNPOV($P(^AUPNVPOV(+$P(APCH(1),U,4),0),U,4),0),U),1,30) Q
 . S BHDTOB="YES, USES TOBACCO"_" - "_$E($P(^AUTNPOV($P(^AUPNVPOV(+$P(APCH(1),U,4),0),U,4),0),U),1,30)
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
 .I Y>71019&(Y<71040),V>LCHEST S LCHEST=V Q
 S T=71019 F  S T=$O(^ICPT("B",T)) Q:T>71039  S X=0 F  S X=$O(^ICPT("B",T,X)) Q:X'=+X  D
 .S D=$O(^AUPNVCPT("AA",P,X,0)) I D S D=9999999-D
 .I D,D>LCHEST S LCHEST=D
 K BHSY S %=P_"^LAST PROCEDURE 87.44",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)),$P(BHSY(1),U)>LCHEST S LCHEST=$P(BHSY(1),U)
 K BHSY S %=P_"^LAST PROCEDURE 87.39",E=$$START1^APCLDF(%,"BHSY(")
 I $D(BHSY(1)),$P(BHSY(1),U)>LCHEST S LCHEST=$P(BHSY(1),U)
 Q $S(LCHEST]"":$$FMTE^XLFDT(LCHEST),1:"")
ADA(V) ;any ada other than 9991
 I '$G(V) Q ""
 NEW X,Y,Z,G
 S G="",X=0 F  S X=$O(^AUPNVDEN("AD",V,X)) Q:X'=+X!(G)  S Y=$P($G(^AUPNVDEN(X,0)),U) I Y,$D(^AUTTADA(Y,0)),$P(^AUTTADA(Y,0),U)'=9991 S G=1
 Q G
