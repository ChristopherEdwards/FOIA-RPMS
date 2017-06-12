APCHPWHU ; IHS/CMI/LAB - PCC HEALTH SUMMARY ;
 ;;2.0;IHS PCC SUITE;**6,7,11**;MAY 14, 2009;Build 58
 ;
SUBHEAD ;EP - print subheader
 NEW X
 S X=$TR($J("",(IOM-10))," ","_")
 D S^APCHPWH1(X,1)
 ;S X=$S($P(^APCHPWHC(APCHSCMP,0),U,4)]"":$P(^APCHPWHC(APCHSCMP,0),U,4),1:$P(^APCHPWHC(APCHSCMP,0),U))_" - "
 ;D S^APCHPWH1(X)
 Q
WRITET(TEXT) ;EP
 NEW X,Y
 S X=$O(^APCHPWHI("B",TEXT,0))
 I X="" Q
 S Y=0 F  S Y=$O(^APCHPWHI(X,11,Y)) Q:Y'=+Y  D S^APCHPWH1(^APCHPWHI(X,11,Y,0))
 Q
WRITEF(FORM,TEXT) ;EP
 NEW X,Y
 S X=$O(^APCHPWHF(FORM,11,"B",TEXT,0))
 I X="" Q
 S Y=0 F  S Y=$O(^APCHPWHF(FORM,11,X,11,Y)) Q:Y'=+Y  D S^APCHPWH1(^APCHPWHF(FORM,11,X,11,Y,0))
 Q
EHR(DFN,APCHPWHT)  ;*16*  CMI/GRL support for EHR
 D EN^XBNEW("PRINT^APCHPWHG","DFN;APCHSTYP")
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;---------- 
 ;
UPDLOG(P,T,D) ;EP - update pwh log
 I $G(P)="" Q
 I $G(T)="" Q
 NEW DIC,X,DD,DO,D0
 S X=P,DIC="^APCHPWHL(",DIC(0)="L",DIADD=1,DLAYGO=9001027
 S DIC("DR")=".02////"_T_";.03////"_D_";.04////"_DT_";.05///"_$$NOW^XLFDT_";.06////"_DUZ(2)
 K DD,D0,D0
 D FILE^DICN
 Q
 ;
UPDDEF ;EP - called from option to update default PWH for the site
 W !!,"This option is used to set the default Patient Wellness Handout"
 W !,"for a site."
 W !!
 K DIC S DIC="^APCCCTRL(",DIC("B")=$P(^DIC(4,DUZ(2),0),U),DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 Q
 S DA=+Y,DIE="^APCCCTRL(",DR=".16" D ^DIE
 D ^XBFMK
 Q
 ;
CPT(P,BDATE,EDATE,T,F,SCEX) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 S SCEX=$G(SCEX)
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V
 S ED=(9999999-EDATE),BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
 ..I SCEX]"",SCEX[$P(^AUPNVSIT(V,0),U,7) Q
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(G)  D
 ...I $$ICD^ATXAPI($P(^AUPNVCPT(X,0),U),T,1) S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 I F=5 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P($$CPT^ICPTCOD($P(^AUPNVCPT(G,0),U)),U,2)
 I F=6 S V=$P(^AUPNVCPT(G,0),U,3) I V Q 1_"^"_$P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P($$CPT^ICPTCOD($P(^AUPNVCPT(G,0),U)),U,2)_"^"_G
 Q ""
 ;
RAD(P,BDATE,EDATE,T,F) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V,C
 S ED=(9999999-EDATE),BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVRAD("AD",V))
 ..S X=0 F  S X=$O(^AUPNVRAD("AD",V,X)) Q:X'=+X!(G)  D
 ...S C=$P(^AUPNVRAD(X,0),U) Q:C=""  S C=$P($G(^RAMIS(71,C,0)),U,9) Q:C=""
 ...I $$ICD^ATXAPI(C,T,1) S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 I F=5 S V=$P(^AUPNVRAD(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P(^RAMIS(71,$P(^AUPNVRAD(G,0),U),0),U,9)
 I F=6 S V=$P(^AUPNVRAD(G,0),U,3) I V Q 1_"^"_$P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P(^RAMIS(71,$P(^AUPNVRAD(G,0),U),0),U)_"^"_G
 Q ""
 ;
TRAN(P,BDATE,EDATE,T,F) ;EP - return ien of CPT entry if patient had this CPT IN A TRAN CODE
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V
 S ED=(9999999-EDATE),BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVTC("AD",V))
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X!(G)  D
 ...I $$ICD^ATXAPI($P(^AUPNVTC(X,0),U,7),T,1) S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVTC(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVTC(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 I F=5 S V=$P(^AUPNVTC(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P($$CPT^ICPTCOD($P(^AUPNVTC(G,0),U,7)),U,2)
 I F=6 S V=$P(^AUPNVTC(G,0),U,3) I V Q 1_"^"_$P($P($G(^AUPNVSIT(V,0)),U),".")_"^"_$P($$CPT^ICPTCOD($P(^AUPNVTC(G,0),U,7)),U,2)_"^"_G
 Q ""
 ;
