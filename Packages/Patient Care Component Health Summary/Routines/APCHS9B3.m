APCHS9B3 ; IHS/CMI/LAB - women's health supplement ;
 ;;2.0;IHS PCC SUITE;**7**;MAY 14, 2009
 ;
 ;
WHP ;EP called from supplement entry
 Q
 W:'$D(ZTQUEUED) !,"Women's Health Profile not available." Q
 ;IHS/CMI/LAB - disabled WHP until BW is patched for device control
 I $E(IOST)="C" D  I $D(DIRUT) S APCHSQIT=1 Q
 .W !! S DIR("A")="WOMEN'S HEALTH PROFILE WILL NOW BE DISPLAYED ("_"^"_" to exit, return to continue",DIR(0)="EO" KILL DA D ^DIR KILL DIR
 NEW X S X="BWPROF" X ^%ZOSF("TEST") I '$T W:'$D(ZTQUEUED) !,"Profile not available." Q
 I $T(EP^BWPROF)="" W:'$D(ZTQUEUED) !,"Profile not available." Q
 D EP^BWPROF(APCHSPAT,0,1)
 Q
 ;
BI() ;EP- check to see if using new imm package or not 1/5/1999 IHS/CMI/LAB
 Q $S($O(^AUTTIMM(0))<100:0,1:1)
TD(P,APCHSED) ;EP
 NEW APCHY,X,E,B,%DT,Y,TDD
 S TDD=$$LASTTD^APCLAPI4(P)
 S X=$$FMADD^XLFDT(DT,-(10*365))
 I TDD>X Q "Yes  "_$$FMTE^XLFDT(TDD)
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",9,0)))
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",1,0)))
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",20,0)))
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",22,0)))
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",28,0)))
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",35,0)))
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",50,0)))
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",106,0)))
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",107,0)))
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",110,0)))
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",113,0)))
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(P,9999999.14,$O(^AUTTIMM("C",115,0)))
 I G]"" Q G
 Q "No   "_$$FMTE^XLFDT(TDD,U)
FLU(P) ;EP
 NEW APCHY,%,LFLU,E,T,X
 S LFLU=$$LASTFLU^APCLAPI4(P)
 I LFLU="" G FLUR
 ;K APCHY S %=0 F  S %=$O(LFLU(%)) Q:%'=+%  S APCHY(1)=%
FLU1 NEW D S D=$S($E(DT,4,5)>7:$E(DT,1,3)_"0801",1:$E(DT,1,3)-1_"0801")
 I LFLU'<D Q "Yes  "_$$FMTE^XLFDT($P(LFLU,U))
FLUR ;
 S G=$$REFDF^APCHS9B3(APCHSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:15,1:12),0)),LFLU)
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(APCHSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:16,1:12),0)),LFLU)
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(APCHSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:88,1:12),0)),LFLU)
 I G]"" Q G
 S G=$$REFDF^APCHS9B3(APCHSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:111,1:12),0)),LFLU)
 I G]"" Q G
 Q "No   "_$$FMTE^XLFDT(LFLU,U)
REFDF(P,F,I,D) ;EP - dm item refused?
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(D)="" S D=""
 NEW X S X=$O(^AUPNPREF("AA",P,F,I,0))
 I 'X Q ""  ;none of this item was refused
 NEW Y S Y=9999999-X
 I D]"",Y>D Q "Patient Declined "_$$VAL^XBDIQ1(F,I,.01)_" on "_$$FMTE^XLFDT(Y)
 I D]"",Y<D Q ""
 Q "Patient Declined "_$$VAL^XBDIQ1(F,I,.01)_" on "_$$FMTE^XLFDT(Y)
DIETV(P) ;EP
 I '$G(P) Q ""
 ;get all dietician visits
 ;go through all visits in AA and get last to Prov 29 or 
 NEW D,V,G,X S (D,V,G)="" F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D'=+D!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$P(^AUPNVSIT(V,0),U,11)
 ..Q:'$P(^AUPNVSIT(V,0),U,9)
 ..Q:'$D(^AUPNVPOV("AD",V))
 ..Q:'$D(^AUPNVPRV("AD",V))
 ..Q:$$DNKA^APCHS9B4(V)
 ..Q:$$CLINIC^APCLV(V,"C")=52  ;chart review
 ..I $P(^AUPNVSIT(V,0),U,7)="C" Q  ;chart review
 ..I $$CLINIC^APCLV(V,"C")=67 S G=V Q
 ..S X=$$DIETP(V) ; is there a prov 07 or 29
 ..I X S G=V Q
 ..Q
 .Q
 I 'G Q ""
 Q $$FMTE^XLFDT($P($P(^AUPNVSIT(G,0),U),"."))_"  "_$E($$PRIMPOV^APCLV(G,"N"),1,39)
DIETP(V) ;are any providers an 07 or 29
 I '$G(V) Q ""
 NEW X,Y,Z,H
 S H="",Z=0 F  S Z=$O(^AUPNVPRV("AD",V,Z)) Q:Z'=+Z!(H)  D
 .S Y=$P(^AUPNVPRV(Z,0),U) ;provider ien
 .I $P(^DD(9000010.06,.01,0),U,2)[200 S Y=$$PROVCLSC^XBFUNC1(Y) I Y=29!(Y="07") S H=1 Q
 .I $P(^DD(9000010.06,.01,0),U,2)[6 S Y=$P($G(^DIC(6,Y,0)),U,4) I Y S Y=$P($G(^DIC(7,Y,9999999)),U,1) I Y="07"!(Y=29) S H=1
 .Q
 Q H
SELF(P,D) ;EP
 I '$G(P) Q ""
 I '$G(D) S D=0 ;if don't pass date look at all time
 NEW V,I,%
 S %=""
 NEW T S T=$O(^ATXAX("B","DM AUDIT SELF MONITOR DRUGS",0))
 I 'T Q "<<Missing DM AUDIT SELF MONITOR DRUGS taxonomy>>"
 S I=0 F  S I=$O(^AUPNVMED("AA",P,I)) Q:I'=+I!(%)!(I>(9999999-D))  D
 .S V=0 F  S V=$O(^AUPNVMED("AA",P,I,V)) Q:V'=+V  I $D(^AUPNVMED(V,0)) S G=$P(^AUPNVMED(V,0),U) I $D(^ATXAX(T,21,"B",G)) S %=V
 I %]"" D  Q %
 .I $P(^AUPNVMED(%,0),U,8)="" S %="Yes, dispensed "_$$VAL^XBDIQ1(9000010.14,%,.01)_" on "_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),".")) Q
 .I $P(^AUPNVMED(%,0),U,8)]"" S %="Discontinued - "_$$VAL^XBDIQ1(9000010.14,%,.01)_" on "_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),".")) Q
 S V=$$LASTHF^APCHSMU(APCHSDFN,"DIABETES SELF MONITORING","B") I V]"" Q V
 Q "No Evidence in the past year"
EDUCREF ;EP - gather up all education provided in past year in APCHX
 K APCHX,APCHY
 S APCHY=0 F  S APCHY=$O(^AUPNPREF("AA",APCHSPAT,9999999.09,APCHY)) Q:APCHY'=+APCHY  I $$EDT(APCHY) S APCHD=$O(^AUPNPREF("AA",APCHSPAT,9999999.09,APCHY,0)) I APCHD<(9999999-APCHSBEG) D
 .S APCHX($P(^AUTTEDT(APCHY,0),U))=$$FMTE^XLFDT(9999999-APCHD)
 K APCHY S %=APCHSDFN_"^ALL EDUC;DURING "_$$FMTE^XLFDT(APCHSBEG)_"-"_$$FMTE^XLFDT(DT) S E=$$START1^APCLDF(%,"APCHY(") ;IHS/CMI/LAB patch 3 1/13/98 added $$FMTE^XLFDT to _DT replaced " - " with "-"
 I '$D(APCHY) Q
 NEW X,APCHP K APCHP S X=0,E="" F  S X=$O(APCHY(X)) Q:X'=+X  S E=+$P(APCHY(X),U,4) I $P(^AUPNVPED(E,0),U,6)=5 S E=$P(^AUPNVPED(E,0),U) I $$EDT(E) S APCHX($P(APCHY(X),U,2))=$$FMTE^XLFDT($P(APCHY(X),U))
 Q
EDT(E) ;
 ;is this ien in any taxonomy
 NEW T
 S T=$O(^ATXAX("B","DM AUDIT DIABETES EDUC TOPICS",0))
 I T,$D(^ATXAX(T,21,"B",E)) Q 1
 S T=$O(^ATXAX("B","DM AUDIT DIET EDUC TOPICS",0))
 I T,$D(^ATXAX(T,21,"B",E)) Q 1
 S T=$O(^ATXAX("B","DM AUDIT EXERCISE EDUC TOPICS",0))
 I T,$D(^ATXAX(T,21,"B",E)) Q 1
 S T=$O(^ATXAX("B","DM AUDIT OTHER EDUC TOPICS",0))
 I T,$D(^ATXAX(T,21,"B",E)) Q 1
 S T=$P($G(^AUTTEDT(E,0)),U,2)
 I $P(T,"-")="DM" Q 1
 I $P(T,"-")="DMC" Q 1
 Q ""
