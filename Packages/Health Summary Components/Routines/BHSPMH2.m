BHSPMH2 ;IHS/MSC/MGH - Health Summary for Patient wellness handout ;17-Mar-2009 15:49;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1,2**;March 17,2006
 ;=============================================================
 ;Taken from routine APCHSMPH2
 ; IHS/CMI/GRL Patient Health Summary - Post Visit ;
 ;;2.0;IHS RPMS/PCC Health Summary;**15**;JUN 24, 1997
 ;
 ;
 ;
 Q
LAB(P,T,LT) ;EP
 I '$G(LT) S LT=""
 NEW D,V,G,X,J,R S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(G)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y!(G)  D
 ...I $D(^ATXLAB(T,21,"B",X)),$P(^AUPNVLAB(Y,0),U,4)]"" S G=Y Q
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...S G=Y
 ...Q
 ..Q
 .Q
 I 'G S R=$$REF(P,T) Q "||||||"_R
 Q $P(^AUPNVLAB(G,0),U,4)_"|||"_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0),U),"."))_"|||"_$$REF(P,T,$P($P(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0),U),"."))_"|||"_G
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
 ;
DATE(D) ;EP - convert to slashed date
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
REF(P,T,D) ;return refusal string after date D for test is tax T
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(D) S D=""
 N BHSREF,BHST,V S BHST=0 F  S BHST=$O(^ATXLAB(T,21,"B",BHST)) Q:BHST'=+BHST  D
 .S V=$$REF1(P,60,BHST,D) I V]"" S BHSREF(9999999-$P(V,U,3))=V
 I $D(BHSREF) S %=0,%=$O(BHSREF(%)) I % S V=BHSREF(%) Q V
 Q ""
REF1(P,F,I,D,T) ; ;
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(D)="" S D=""
 I $G(T)="" S T="E"
 NEW X,N S X=$O(^AUPNPREF("AA",P,F,I,0))
 I 'X Q ""  ;none of this item was refused
 S N=$O(^AUPNPREF("AA",P,F,I,X,0))
 NEW Y S Y=9999999-X
 I D]"",Y>D Q $S(T="I":Y,1:$$TYPEREF(N)_"-"_$$DATE(Y))
 I T="I" Q Y  ;quit on internal form of date
 Q $$TYPEREF(N)_"-"_$$DATE(Y)
 ;
TYPEREF(N) ;
 NEW % S %=$P(^AUPNPREF(N,0),U,7)
 I %="R"!(%="") Q "Refused"
 I %="N" Q "Not Med Ind"
 I %="F" Q "No Resp to F/U"
 Q ""
 ;
 ;
GETLABSX ;get lab tests ordered today
 ;
 N BHSLR,BHSTSTP,BHSLRO,BHSTEST,BHSTST,BHSVLAB,BHSTSTP,BHSSIVD,BHSTCTR,BHSCTR
 S BHSLR=$G(^DPT(BHSDFN,"LR"))
 I $G(BHSLR)]"" S BHSLRO=0,BHSTSTP=0 D
 .F  S BHSLRO=$O(^LRO(69,DT,1,"AA",BHSLR,BHSLRO)) Q:BHSLRO=""  Q:BHSLRO'=+BHSLRO  D
 ..F  S BHSTSTP=$O(^LRO(69,DT,1,BHSLRO,2,"B",BHSTSTP)) Q:BHSTSTP'=+BHSTSTP  D
 ...S BHSTCTR=$O(^LRO(69,DT,1,BHSLRO,2,"B",BHSTSTP,0))
 ...S BHSTEST=$P(^LAB(60,BHSTSTP,0),U)
 ...S BHSTST(BHSTEST)=""
 ...Q
 ;
 ;
GETLABS ;get todays labs from V Lab File
 S BHSLR=$G(^DPT(BHSSDFN,"LR"))
 I $D(^AUPNVLAB("AE",BHSSDFN,BHSSIVD)) S BHSTSTP=0,BHSVLAB=0 D
 .F  S BHSTSTP=$O(^AUPNVLAB("AE",BHSSDFN,BHSSIVD,BHSTSTP)) Q:BHSTSTP=""  Q:BHSTSTP'=+BHSTSTP  D
 ..S BHSTEST=$P(^LAB(60,BHSTSTP,0),U),BHSTST(BHSTEST)=""
 ..S BHSVLAB=$O(^AUPNVLAB("AE",BHSSDFN,BHSSIVD,BHSTSTP,BHSVLAB)) Q:BHSVLAB'=+BHSVLAB
 ..I $D(^AUPNVLAB(BHSVLAB,21)) S BHSCTR=0 F  S BHSCTR=$O(^AUPNVLAB(BHSVLAB,21,BHSCTR)) Q:'BHSCTR  D
 ...Q:BHSCTR'=+BHSCTR
 ...S BHSTST(BHSTEST,BHSCTR)=$P(^AUPNVLAB(BHSVLAB,21,BHSCTR,0),U)
 ..Q
 Q
 ;
BHSLHD ;
 ;S X="Lab tests can help measure health and some check to make sure that your" D S(X,1)
 ;S X="medicines are working right." D S(X)
 ;
