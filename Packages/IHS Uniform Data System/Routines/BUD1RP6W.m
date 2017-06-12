BUD1RP6W ; IHS/CMI/LAB - UDS REPORT PROCESSOR 01 Dec 2011 4:03 PM ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
 ;
 ;
ROTACONT(P,C,ED) ;EP - ANALPHYLAXIS/IMMUNE DEF
 NEW X
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G=D_U_"Anaphylaxis"
 .I $P(^BICONT(R,0),U,1)["Immune" S G=D_U_$P(^BICONT(R,0),U,1)
 .I $P(^BICONT(R,0),U,1)="Neomycin Allergy" S G=D_U_"Neomycin Allergy"
 Q G
ROTA(P,BDATE,EDATE) ;EP
 ;check for a contraindication from DOB to 2nd birthday
 NEW X,G,N,BUDG,BUDX,BUDC,BUDOPV,BUDAPOV,C,BD,ED,V,Y,E
 ;now check for evidence of disease
 S X=$$LASTDXI^BUD1UTL1(P,"008.61",$$DOB^AUPNPAT(P),EDATE)
 I X]"" Q "1^ROTAVIRUS Evidence: "_$P(X,U,2)_" on "_$$DATE^BUD1UTL1($P(X,U,3))
 S X=$$LASTDX^BUD1UTL1(P,"BUD ROTA CONTRA DXS",$$DOB^AUPNPAT(P),EDATE)
 I X]"" Q "1^ROTAVIRUS Contraindication: "_$P(X,U,2)_" on "_$$DATE^BUD1UTL1($P(X,U,3))
 I $$PLCODE^BUD1DU(P,"008.61") Q "1^ROTAVIRUS Evidence: 008.61 on Problem List"
 S X=$$PLTAX^BUD1DU(P,"BUD ROTA CONTRA DXS") I X Q "1^ROTAVIRUS Contraindication: "_$P(X,U,2)_" on Problem List"
 F BUDZ=119,74,116,122 S X=$$ROTACONT(P,BUDZ,EDATE) Q:X]""
 I X]"" Q "1^ROTAVIRUS Contraindication IM package: "_$$DATE^BUD1UTL1($P(X,U))_" "_$P(X,U,2)
 S G=""
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X!(G)  D
 .;Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE  ;entered after 2ND birthday
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .Q:'$$ANAREACT^BUD1RP6C(X)  ;quit if anaphylactic is not a reaction/sign/symptom
 .I N["NEOMYCIN" S G="1^ROTAVIRUS Contraindiction: "_$$DATE^BUD1UTL1($P($P($G(^GMR(120.8,X,0)),U,4),"."))_"  Allergy Tracking: "_N
 I G]"" Q G
 ;now get imms and see if there are 3
 K BUDC,BUDG,BUDX
 K BUDOPV,BUDAPOV
 S BUDOPV2=0
ROTAIMM ;get all immunizations
 S C="119"
 K BUDX D GETIMMS^BUD1RP6C(P,BDATE,EDATE,C,.BUDX)
 ;now get cpt codes
 S X=0 F  S X=$O(BUDX(X)) Q:X'=+X  S BUDOPV(X)=BUDX(X),BUDAPOV(X)=BUDX(X)
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90681 D
 ....S BUDOPV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUD1UTL1((9999999-$P(ED,"."))),BUDAPOV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUD1UTL1((9999999-$P(ED,".")))
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90681 D
 ....S BUDOPV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUD1UTL1((9999999-$P(ED,"."))),BUDAPOV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUD1UTL1((9999999-$P(ED,".")))
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S (X,Y)="",C=0 F  S X=$O(BUDOPV(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDOPV(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BUDOPV=0,X=0 F  S X=$O(BUDOPV(X)) Q:X'=+X  S BUDOPV=BUDOPV+1
 I BUDOPV>1 S Y="1^ROTA 2: total #: "_BUDOPV,X="" F  S X=$O(BUDOPV(X)) Q:X'=+X  S Y=Y_"  "_BUDOPV(X)
 I BUDOPV>1 Q Y
 I BUDOPV=1 S BUDOPV2=2
 ;NOW TRY FOR 3 DOSE
 K BUDC,BUDG,BUDX
 K BUDOPV,BUDAPOV
ROT3IMM ;get all immunizations
 S C="74^116^122"
 K BUDX D GETIMMS^BUD1RP6C(P,BDATE,EDATE,C,.BUDX)
 ;now get cpt codes
 S X=0 F  S X=$O(BUDX(X)) Q:X'=+X  S BUDOPV(X)=BUDX(X),BUDAPOV(X)=BUDX(X)
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90680 D
 ....S BUDOPV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUD1UTL1((9999999-$P(ED,"."))),BUDAPOV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUD1UTL1((9999999-$P(ED,".")))
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90680 D
 ....S BUDOPV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUD1UTL1((9999999-$P(ED,"."))),BUDAPOV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUD1UTL1((9999999-$P(ED,".")))
 ..S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  D
 ...S Y=$$VAL^XBDIQ1(9000010.07,X,.01) I Y="008.61" D
 ....S BUDOPV(9999999-$P(ED,"."))="POV: "_Y_" on "_$$DATE^BUD1UTL1((9999999-$P(ED,"."))),BUDAPOV(9999999-$P(ED,"."))="POV: "_Y_" on "_$$DATE^BUD1UTL1((9999999-$P(ED,".")))
 S (X,Y)="",C=0 F  S X=$O(BUDOPV(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDOPV(X) Q
 .S Y=X
 ;now count them and see if there are 3 of them
 S BUDOPV=0,X=0 F  S X=$O(BUDOPV(X)) Q:X'=+X  S BUDOPV=BUDOPV+1
 I BUDOPV>2 S Y="1^ROTA: total #: "_BUDOPV,X="" F  S X=$O(BUDOPV(X)) Q:X'=+X  S Y=Y_"  "_BUDOPV(X)
 I BUDOPV>2 Q Y
 S BUDOPV=BUDOPV+BUDOPV2
 I BUDOPV>2 S Y="1^ROTA: total #: "_BUDOPV,X="" F  S X=$O(BUDOPV(X)) Q:X'=+X  S Y=Y_"  "_BUDOPV(X)
 I BUDOPV>2 Q Y
 Q "0^"_(3-BUDOPV)_" ROTAVIRUS"
