APCHPMH2 ; IHS/CMI/LAB - Patient Wellness Handout ;
 ;;2.0;IHS PCC SUITE;**7**;MAY 14, 2009
 ;
 ;
 ;
 Q
LAB(P,T,LT) ;EP
 I '$G(LT) S LT=""
 NEW D,V,G,X,J S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(G)  D
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
 N APCHREF,APCHT,V S APCHT=0 F  S APCHT=$O(^ATXLAB(T,21,"B",APCHT)) Q:APCHT'=+APCHT  D
 .S V=$$REF1(P,60,APCHT,D) I V]"" S APCHREF(9999999-$P(V,U,3))=V
 I $D(APCHREF) S %=0,%=$O(APCHREF(%)) I % S V=APCHREF(%) Q V
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
 I %="R"!(%="") Q "Declined"
 I %="N" Q "Not Med Ind"
 I %="F" Q "No Resp to F/U"
 Q ""
 ; 
 ;
GETLABSX ;get lab tests ordered today
 ;
 S APCHLR=$G(^DPT(APCHSDFN,"LR"))
 I $G(APCHLR)]"" S APCHLRO=0,APCHTSTP=0 D
 .F  S APCHLRO=$O(^LRO(69,DT,1,"AA",APCHLR,APCHLRO)) Q:APCHLRO=""  Q:APCHLRO'=+APCHLRO  D
 ..F  S APCHTSTP=$O(^LRO(69,DT,1,APCHLRO,2,"B",APCHTSTP)) Q:APCHTSTP'=+APCHTSTP  D
 ...S APCHTCTR=$O(^LRO(69,DT,1,APCHLRO,2,"B",APCHTSTP,0))
 ...S APCHTEST=$P(^LAB(60,APCHTSTP,0),U)
 ...S APCHTST(APCHTEST)=""
 ...Q
 ;
 ;
GETLABS ;get todays labs from V Lab File
 S APCHSIVD=9999999-DT
 I $D(^AUPNVLAB("AE",APCHSDFN,APCHSIVD)) S APCHTSTP=0,APCHVLAB=0 D
 .F  S APCHTSTP=$O(^AUPNVLAB("AE",APCHSDFN,APCHSIVD,APCHTSTP)) Q:APCHTSTP=""  Q:APCHTSTP'=+APCHTSTP  D
 ..S APCHTEST=$P(^LAB(60,APCHTSTP,0),U),APCHTST(APCHTEST)=""
 ..S APCHVLAB=$O(^AUPNVLAB("AE",APCHSDFN,APCHSIVD,APCHTSTP,APCHVLAB)) Q:APCHVLAB'=+APCHVLAB
 ..I $D(^AUPNVLAB(APCHVLAB,21)) S APCHCTR=0 F  S APCHCTR=$O(^AUPNVLAB(APCHVLAB,21,APCHCTR)) Q:'APCHCTR  D
 ...Q:APCHCTR'=+APCHCTR
 ...S APCHTST(APCHTEST,APCHCTR)=$P(^AUPNVLAB(APCHVLAB,21,APCHCTR,0),U)
 ..Q
 Q
 ;
APCHLHD ;
 ;S X="Lab tests can help measure health and some check to make sure that your" D S(X,1)
 ;S X="medicines are working right." D S(X)
 ;
