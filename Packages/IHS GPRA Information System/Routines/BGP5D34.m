BGP5D34 ; IHS/CMI/LAB - indicator C ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
CNTDTAP ;
 S (X,Y)="",C=0 F  S X=$O(BGPDTAP(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPDTAP(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPDTAP=0,X=0 F  S X=$O(BGPDTAP(X)) Q:X'=+X  S BGPDTAP=BGPDTAP+1
 Q
RESET ;RESET WORKING ARRAYS
 K BGPDT M BGPDT=BGPADT
 K BGPDIP M BGPDIP=BGPADIP
 K BGPTET M BGPTET=BGPATET
 K BGPPER M BGPPER=BGPAPER
 K BGPTD M BGPTD=BGPATD
 Q
RESETD ;RESET DUPES
 S (X,Y)="",C=0 F  S X=$O(BGPDT(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPDT(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BGPDIP(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPDIP(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BGPTET(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPTET(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BGPTD(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPTD(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BGPPER(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPPER(X) Q
 .S Y=X
 S BGPDT=0,X=0 F  S X=$O(BGPDT(X)) Q:X'=+X  S BGPDT=BGPDT+1
 S BGPTD=0,X=0 F  S X=$O(BGPTD(X)) Q:X'=+X  S BGPTD=BGPTD+1
 S BGPDIP=0,X=0 F  S X=$O(BGPDIP(X)) Q:X'=+X  S BGPDIP=BGPDIP+1
 S BGPTET=0,X=0 F  S X=$O(BGPTET(X)) Q:X'=+X  S BGPTET=BGPTET+1
 S BGPPER=0,X=0 F  S X=$O(BGPPER(X)) Q:X'=+X  S BGPPER=BGPPER+1
 Q
DTAP(P,EDATE) ;EP
 K ^TMP($J,"CPT")
 K BGPC,BGPG,BGPX
 ;first gather up all cpt codes that relate in any way to dtap and store in ^TMP
 S ED=9999999-EDATE-1,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90700!(Y=90721)!(Y=90723)!(Y=90701)!(Y=90711)!(Y=90720)!(Y=90702)!(Y=90718)!(Y=90719)!(Y=90703) S ^TMP($J,"CPT",9999999-ED,Y)=""
 ;now gather up all DTAP immunizations, cpts and check for 4 ten days apart
 K BGPDTAP
 S BGPEVTD=0,BGPEVDIP=0,BGPEVPER=0  ;CONTROL FOR HAVING IMM OR NOT
 ;get all immunizations
 S C="20^50^106^107^110^1^22^102"
 D GETIMMS^BGP5D32(P,EDATE,C,.BGPX)
 ;go through and set into DTAP if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPDTAP(X)=""
 D CNTDTAP  ;count to see if there are 4
 I BGPDTAP>3 Q 1_U_"4 Dtap/Dtp"  ;had 4 dtap by cvx so code is 1
 ;now get cpts for dtap or dtp
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90700!(Y=90721)!(Y=90723)!(Y=90701)!(Y=90711)!(Y=90720)!(Y=90749)!(Y=90698) S BGPDTAP(D)=""
 D CNTDTAP  ;count to see if there are 4
 I BGPDTAP>3 Q 1_U_"4 Dtap/Dtp"  ;had 4 dtap cvx or cpts so code is 1
DT ;add in dt's
 K BGPDT,BGPADT
 S C="28"
 K BGPX D GETIMMS^BGP5D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPDT(X)="",BGPADT(X)=""
 ;add in dt cpts
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90702 S BGPDT(D)="",BGPADT(D)=""
 ;are there 3 dt and 1 dtap by cvx and/or cpt?
DT1 ;
 ;kill off any that are on the same day as the dtaps
 S (X,Y)="",C=0 F  S X=$O(BGPDT(X)) Q:X'=+X  I $D(BGPDTAP(X)) K BGPDT(X)
 S (X,Y)="",C=0 F  S X=$O(BGPDT(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPDT(X) Q
 .S Y=X
 S BGPDT=0,X=0 F  S X=$O(BGPDT(X)) Q:X'=+X  S BGPDT=BGPDT+1
 I BGPDT>2,$O(BGPDTAP(0)) Q 1_U_"Dtap and 3 DTs"
TETCVX ;
 K BGPTET,BGPATET
 S C="35^112"
 K BGPX D GETIMMS^BGP5D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPTET(X)="",BGPATET(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90703 S BGPTET(D)="",BGPATET(D)=""
DIPCVX ;
 K BGPDIP,BGPADIP
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90719 S BGPDIP(D)="",BGPADIP(D)=""
PERCVX ;
 K BGPPER,BGPAPER
 S C="11"
 K BGPX D GETIMMS^BGP5D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPPER(X)="",BGPAPER(X)=""
TDCVX ;
 K BGPTD,BGPATD
 S C="9"
 K BGPX D GETIMMS^BGP5D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPTD(X)="",BGPATD(X)=""
 S D=0 F  S D=$O(^TMP($J,"CPT",D)) Q:D'=+D  S Y="" F  S Y=$O(^TMP($J,"CPT",D,Y)) Q:Y=""  D
 .I Y=90718 S BGPTD(D)=""
 S BGPCODE=1 D TEST
 I BGPVAL]"" Q BGPVAL
 ;PV
DTPPV ;
 D RESET
 K BGPG S %=P_"^ALL DX V06.1;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPDTAP($P(BGPG(1),U))=""
 K BGPG S %=P_"^ALL DX V06.2;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPDTAP($P(BGPG(1),U))=""
 K BGPG S %=P_"^ALL DX V06.3;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPDTAP($P(BGPG(1),U))=""
 K BGPG S %=P_"^ALL PROCEDURE 99.39;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPDTAP($P(BGPG(1),U))=""
 D CNTDTAP  ;count to see if there are 4
 I BGPDTAP>3 Q 2_U_"4 Dtap/Dtp"  ; had 4 dtap/cpt/pv/proc
DTPV ;
 K BGPG S %=P_"^ALL DX V06.5;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPDT($P(BGPG(1),U))="",BGPADT($P(BGPG(1),U))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
DTPV1 ;
 ;kill off any that are on the same day as the dtaps
 S (X,Y)="",C=0 F  S X=$O(BGPDT(X)) Q:X'=+X  I $D(BGPDTAP(X)) K BGPDT(X)
 D RESETD
 I BGPDT>2,$O(BGPDTAP(0)) Q 2_U_"Dtap and 3 DTs"
 D RESET
TETPV ;
 K BGPG S %=P_"^ALL DX V03.7;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPTET($P(BGPG(1),U))="",BGPATET($P(BGPG(1),U))=""
 K BGPG S %=P_"^ALL PROCEDURE 99.38;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPTET($P(BGPG(1),U))="",BGPATET($P(BGPG(1),U))=""
DIPPV ;
 K BGPG S %=P_"^ALL DX V03.5;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPDIP($P(BGPG(1),U))="",BGPADIP($P(BGPG(1),U))=""
 K BGPG S %=P_"^ALL PROCEDURE 99.36;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPDIP($P(BGPG(1),U))="",BGPADIP($P(BGPG(1),U))=""
PERPV ;
 K BGPG S %=P_"^ALL DX V03.6;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPPER($P(BGPG(1),U))="",BGPAPER($P(BGPG(1),U))=""
 K BGPG S %=P_"^ALL PROCEDURE 99.37;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPPER($P(BGPG(1),U))="",BGPAPER($P(BGPG(1),U))=""
TDPV ;
 K BGPG S %=P_"^ALL DX V06.5;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPTD($P(BGPG(1),U))="",BGPATD($P(BGPG(1),U))=""
 S BGPCODE=2 D TEST
EVIDTET ;
 S BGPEVTD=""
 K BGPG S %=P_"^LAST DX 037.;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S BGPEVTD=1
 I $$PLCODE^BGPDU(P,"037.") S BGPEVTD=1
 D RESETD
 I BGPEVTD,BGPPER>3,BGPDIP>3 Q 4_U_"evid tet, 4 dip, 4 per"
 D RESET
EVIDPER ;
 S BGPEVPER=""
 K BGPG S %=P_"^LAST DX [BGP PERTUSSIS EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S BGPEVPER=1
 I $$PLTAX^BGPDU(P,"BGP PERTUSSIS EVIDENCE") S BGPEVPER=1
 D RESETD
 I BGPEVPER,BGPDT>3 Q 4_U_"Evid per 3 dt"
 I BGPEVPER,BGPTD>3 Q 4_U_"Evid per 3 td"
 I BGPEVPER,BGPTET>3,BGPDIP>3 Q 4_U_"evid per 3 tet 3 dip"
EVIDDIP ;
 D RESET
 S BGPDIPEV=""
 K BGPG S %=P_"^LAST DX [BGP DIPHTHERIA EVIDENCE;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S BGPEVDIP=1
 I $$PLTAX^BGPDU(P,"BGP DIPHTHERIA EVIDENCE") S BGPEVDIP=1
 D RESETD
 I BGPEVDIP,BGPTD>3,BGPPER>3 Q 4_U_"Evid Dip 4 Tetanus 4 Per"
 I BGPEVDIP,BGPTET>3,BGPPER>3 Q 4_U_"Evid Dip 4 Tetanus 4 Per"
 I BGPEVDIP,BGPDT>3,BGPPER>3 Q 4_U_"evid dip 4 dt 4 per"
REF ;
 ;now go to refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=20,50,106,107,110,1,22,102  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" Dtap or DT"
 ;now check refusals in imm pkg
 F BGPIMM=20,50,106,107,110,1,22,102 Q:R  S R=$$IMMREF^BGP5D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R Q 3_U_" ref Dtap or DT"
 ;get dt and td refusals and count with 4 Pertussis
 S (R,BGPNMI)="" F BGPIMM=9  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R,BGPDTAP>2 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" td has 3 DTap"
 I R,BGPPER>3 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"ref")_" td has per"
 ;now check refusals in imm pkg
 S R=""
 F BGPIMM=9 S R=$$IMMREF^BGP5D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R,BGPDTAP>2 Q 3_U_" refused td has 3 DTap"
 I R>3,BGPPER>3 Q 3_U_" refused td has per"
 S (R,BGPNMI)="" F BGPIMM=28  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R,BGPDTAP>0 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI dtap",1:"ref dtap")
 I R,BGPPER>3 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI dtap",1:"ref dtap")
 ;now check refusals in imm pkg
 S (R,BGPNMI)="" F BGPIMM=28 S R=$$IMMREF^BGP5D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R,BGPDTAP>0 Q 3_U_"ref dtap"
 I R,BGPPER>3 Q 3_U_"ref dtap"
 ;PERTUSSIS refusals and count with 4 dt OR TD or Tet & Dip
 S (R,BGPNMI)="" F BGPIMM=11  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R,(BGPDT>3!(BGPTD>3)) Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI dtap",1:"ref dtap")
 I R,BGPD>3,BGPTET>3 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI dtap",1:"ref dtap")
 ;now check refusals in imm pkg
 S (R,BGPNMI)="" F BGPIMM=11 S R=$$IMMREF^BGP5D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R,(BGPDT>3!(BGPTD>3)) Q 3_U_"ref dtap"
 ;TETANUS refusals and count with 4 PERTUSSIS AND DIP
 S (R,BGPNMI)="" F BGPIMM=35,112  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R,BGPPER>3,BGPD>3 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI dtap",1:"ref dtap")
 ;now check refusals in imm pkg
 S R="" F BGPIMM=35,112 S R=$$IMMREF^BGP5D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I BGPPER>3,BGPD>3,R Q 3_U_"ref dtap"
 Q ""
TEST ;
 ;NOW TEST FOR ALL POSSIBLE COMBINATIONS OF HAVING MET INDICATOR
 ;1 DTAP AND 3 EACH TET,PER,DIP
 ;kill off any dip or tet on same day as a dtap
 S BGPVAL=""
 S (X,Y)="",C=0 F  S X=$O(BGPDIP(X)) Q:X'=+X  I $D(BGPDTAP(X)) K BGPDIP(X)
 S (X,Y)="",C=0 F  S X=$O(BGPDIP(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPDIP(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BGPTET(X)) Q:X'=+X  I $D(BGPDTAP(X)) K BGPTET(X)
 S (X,Y)="",C=0 F  S X=$O(BGPTET(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPTET(X) Q
 .S Y=X
 S BGPDIP=0,X=0 F  S X=$O(BGPDIP(X)) Q:X'=+X  S BGPDIP=BGPDIP+1
 S BGPTET=0,X=0 F  S X=$O(BGPTET(X)) Q:X'=+X  S BGPTET=BGPTET+1
 I BGPTET>2,BGPDIP>1,$O(BGPDTAP(0)) S BGPBAL=BGPCODE_U_"Dtap & 3 TET & 3 DIP" Q
DTPER ;is there 4 DT and 4 pertussis?
 D RESET
 ;delete ones not 10 days apart
 S (X,Y)="",C=0 F  S X=$O(BGPDT(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPDT(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BGPPER(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPPER(X) Q
 .S Y=X
 S BGPDT=0,X=0 F  S X=$O(BGPDT(X)) Q:X'=+X  S BGPDT=BGPDT+1
 S BGPPER=0,X=0 F  S X=$O(BGPPER(X)) Q:X'=+X  S BGPPER=BGPPER+1
 I BGPPER>3,BGPDT>3 S BGPVAL=BGPCODE_U_"3 DT & 3 PER" Q
TDPER ;
 D RESET
 ;delete ones not 10 days apart
 S (X,Y)="",C=0 F  S X=$O(BGPTD(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPTD(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BGPPER(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPPER(X) Q
 .S Y=X
 S BGPTD=0,X=0 F  S X=$O(BGPTD(X)) Q:X'=+X  S BGPTD=BGPTD+1
 S BGPPER=0,X=0 F  S X=$O(BGPPER(X)) Q:X'=+X  S BGPPER=BGPPER+1
 I BGPPER>3,BGPTD>3 S BGPVAL=BGPCODE_U_"3 TD & 3 PER" Q
DIPTETPE ;
 D RESET
 S (X,Y)="",C=0 F  S X=$O(BGPPER(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPPER(X) Q
 .S Y=X
 S BGPPER=0,X=0 F  S X=$O(BGPPER(X)) Q:X'=+X  S BGPPER=BGPPER+1
 S (X,Y)="",C=0 F  S X=$O(BGPDIP(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPDIP(X) Q
 .S Y=X
 S (X,Y)="",C=0 F  S X=$O(BGPTET(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPTET(X) Q
 .S Y=X
 S BGPDIP=0,X=0 F  S X=$O(BGPDIP(X)) Q:X'=+X  S BGPDIP=BGPDIP+1
 S BGPTET=0,X=0 F  S X=$O(BGPTET(X)) Q:X'=+X  S BGPTET=BGPTET+1
 I BGPPER>3,BGPDIP>3,BGPTET>3 S BGPVAL=BGPCODE_U_"3 EACH DIP,TET,PER" Q
 Q
90700 ;;
90721 ;;
90723 ;;
90701 ;;
90711 ;;
90720 ;;
90702 ;;
90718 ;;
90719 ;;
90703 ;;
