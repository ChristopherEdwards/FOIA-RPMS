APCLV1 ; IHS/CMI/LAB - visit entry utilities/get codes ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;IHS/TUCSON/LAB - patch 1 modified subroutine FACTX to check
 ;for existence of AUTTLOC( node 3/4/97
 ;cmi/anch/maw 9/12/2007 code set versioning in EM
COMM ;EP ; get COMMUNITY - STATE,COUNTY,COMMUNITY codes
 NEW Y,%,P,Z
 S %=""
 I '$D(^AUPNVSIT(V,0)) Q %
 S P=$P(^AUPNVSIT(V,0),U,5)
 I 'P Q %
 I '$D(^AUPNPAT(P)) Q %
 S Y=$O(^AUPNPAT(P,51,""),-1) I 'Y Q %
 S Z=$P(^AUPNPAT(P,51,Y,0),U,3)
 I 'Z S Z=$P($G(^AUPNPAT(P,11)),U,17)
 I 'Z Q ""
 Q $S($G(F)="E":$P(^AUTTCOM(Z,0),U),$G(F)="C":$P(^AUTTCOM(Z,0),U,8),1:Z)
 ;
CHART ;EP - returns ASUFAC_HRN ( 12 digits, HRN is left zero filled)
 NEW L,%,C,S,P,Z
 S %=""
 I '$D(^AUPNVSIT(V,0)) Q %
 S Z=^AUPNVSIT(V,0)
 S P=$P(Z,U,5)
 I 'P Q %
 I $P(Z,U,6),$D(^AUPNPAT(P,41,$P(Z,U,6),0)) S L=$P(Z,U,6) S %=$$GETCHART(L) I %]"" Q %
 I $G(DUZ(2)) S L=DUZ(2) S %=$$GETCHART(L)
 I %="" S L=$O(^AUPNPAT(P,41,0)) I L S %=$$GETCHART(L)
 I %="" S %="      ??????"
 Q %
GETCHART(L) ;
 S S=$P(^AUTTLOC(L,0),U,10)
 I S="" Q S
 S C=$P($G(^AUPNPAT(P,41,L,0)),U,2)
 I C="" Q C
 S C=$E("000000",1,6-$L(C))_C
 S %=S_C
 Q %
 ;
GETABBRV ;
LOCENC ;EP - given visit ien V, return loc. of encounter in format F
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,6)
 I Y="" Q Y
 I '$D(^AUTTLOC(Y)) Q -1
 Q $S($G(F)="E":$P(^DIC(4,Y,0),U),$G(F)="C":$P(^AUTTLOC(Y,0),U,10),1:Y)
 ;
VD ; EP - given visit ien in V, return date of visit in internal or external format
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U)
 I Y="" Q Y
 Q $S($G(F)="S":$$FMTE^XLFDT(Y,"2D"),$G(F)="E":$$FMTE^XLFDT(Y,"1D"),1:$P(Y,"."))
 ;
VDTM ;EP - given visit ien in V, return visit date and time in F format
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U)
 I Y="" Q Y
 Q $S($G(F)="S":$$FMTE^XLFDT(Y,"2"),$G(F)="E":$$FMTE^XLFDT(Y,"1"),1:Y)
 ;
TIME ;EP - given visit ien in V, returns visit time of day in format F
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U)
 I Y="" Q Y
 S Y=$S($G(F)="E":$$FMTE^XLFDT(Y,"2"),$G(F)="P":$$FMTE^XLFDT(Y,"2P"),1:Y)
 I $G(F)="P" Q $P(Y," ",2,99)
 I $G(F)="E" Q $P(Y,"@",2)
 Q $P(Y,".",2)
 ;
LASTVD(P,F) ;PEP - given patient DFN in P, return pt's last pcc visit date,
 ;   using the data fetcher.  Returns date in format specified in F.
 I '$G(P) Q ""
 I $G(F)="" S F="I"
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW Y,ERR,LVD
 S ERR=$$START1^APCLDF(P_"^LAST VISIT","LVD(")
 I '$D(LVD(1)) Q ""  ;IHS/CMI/LAB
 S Y=$P(LVD(1),U)
 Q $S($G(F)="S":$$FMTE^XLFDT(Y,"2D"),$G(F)="E":$$FMTE^XLFDT(Y,"1D"),1:$P(Y,"."))
 ;
DOW ;EP - returns
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P($P(^AUPNVSIT(V,0),U),".")
 I Y="" Q Y
 Q $S($G(F)="E":$$DOW^XLFDT(Y),1:$$DOW^XLFDT(Y,1))
 ;
TYPE ;EP type of visit
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,3)
 Q $S(Y="":Y,$G(F)="E":$$EXTSET^XBFUNC(9000010,.03,Y),1:Y)
 ;
SC ;EP - service category
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,7)
 Q $S(Y="":Y,$G(F)="E":$$EXTSET^XBFUNC(9000010,.07,Y),1:Y)
 ;
CLINIC ;EP - clinic
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,8)
 I Y="" Q Y
 I '$D(^DIC(40.7,Y)) Q -1
 Q $S($G(F)="E":$P(^DIC(40.7,Y,0),U),$G(F)="C":$P(^DIC(40.7,Y,0),U,2),1:Y)
 ;
EM ;EP - eval&man cpt code
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,17)
 I Y="" Q Y
 I '$D(^ICPT(Y)) Q -1
 ;Q $S($G(F)="E":$P(^ICPT(Y,0),U,2),$G(F)="C":$P(^ICPT(Y,0),U),1:Y)  ;cmi/anch/maw 9/12/2007 orig line
 Q $S($G(F)="E":$P($$CPT^ICPTCOD(Y),U,3),$G(F)="C":$P($$CPT^ICPTCOD(Y),U,2),1:Y)  ;cmi/anch/maw 9/10/2007 csv
 ;
LS ;EP - level of service code
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,19)
 Q $S(Y="":Y,$G(F)="E":$$EXTSET^XBFUNC(9000010,.19,Y),1:Y)
 ;
NLAB ;EP - #labs
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW %,Y
 S (Y,%)=0 F  S Y=$O(^AUPNVLAB("AD",V,Y)) Q:Y'=+Y  S %=%+1
 Q %
NRX ;EP - #rxs
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW %,Y
 S (Y,%)=0 F  S Y=$O(^AUPNVMED("AD",V,Y)) Q:Y'=+Y  S %=%+1
 Q %
 ;
ADMSERV ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW %,Y,Z
 S %="",Z=$O(^AUPNVINP("AD",V,0))
 I 'Z Q %
 S Y=$$VALI^XBDIQ1(9000010.02,Z,.04)
 Q $S('Y:%,$G(F)="C":$P($G(^DIC(45.7,Y,9999999)),U),$G(F)="I":Y,$G(F)="E":$P(^DIC(45.7,Y,0),U),1:"")
DSCHSERV ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW %,Y,Z
 S %="",Z=$O(^AUPNVINP("AD",V,0))
 I 'Z Q %
 S Y=$$VALI^XBDIQ1(9000010.02,Z,.05)
 Q $S('Y:%,$G(F)="C":$P($G(^DIC(45.7,Y,9999999)),U),$G(F)="I":Y,$G(F)="E":$P(^DIC(45.7,Y,0),U),1:"")
ADMTYPE ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW %,Y,Z
 S %="",Z=$O(^AUPNVINP("AD",V,0))
 I 'Z Q %
 S Y=$$VALI^XBDIQ1(9000010.02,Z,.07)
 I $P(^DD(9000010.02,.07,0),U,2)[42.1 Q $S('Y:%,$G(F)="C":$P($G(^DIC(42.1,Y,9999999)),U),$G(F)="I":Y,$G(F)="E":$P(^DIC(42.1,Y,0),U),1:"")
 I $P(^DD(9000010.02,.07,0),U,2)[405.1 Q $S('Y:%,$G(F)="C":$P($G(^DG(405.1,Y,"IHS")),U),$G(F)="I":Y,$G(F)="E":$P(^DG(405.1,Y,0),U),1:"")
 Q ""
DSCHTYPE ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW %,Y,Z
 S %="",Z=$O(^AUPNVINP("AD",V,0))
 I 'Z Q %
 S Y=$$VALI^XBDIQ1(9000010.02,Z,.06)
 I $P(^DD(9000010.02,.06,0),U,2)[42.2 Q $S('Y:%,$G(F)="C":$P($G(^DIC(42.2,Y,9999999)),U),$G(F)="I":Y,$G(F)="E":$P(^DIC(42.2,Y,0),U),1:"")
 I $P(^DD(9000010.02,.06,0),U,2)[405.1 Q $S('Y:%,$G(F)="C":$P($G(^DG(405.1,Y,"IHS")),U),$G(F)="I":Y,$G(F)="E":$P(^DG(405.1,Y,0),U),1:"")
 Q ""
DSCHDATE ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y,Z
 S Z=$O(^AUPNVINP("AD",V,0)) I 'Z Q Z
 S Y=$P(^AUPNVINP(Z,0),U)
 I Y="" Q Y
 Q $S($G(F)="S":$$FMTE^XLFDT(Y,"2D"),$G(F)="E":$$FMTE^XLFDT(Y,"1D"),1:$P(Y,"."))
CONSULTS ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y,Z
 I $P(^AUPNVSIT(V,0),U,7)'="H" Q ""
 S Z=$O(^AUPNVINP("AD",V,0)) I 'Z Q Z
 Q $P(^AUPNVINP(Z,0),U,8)
LOS ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y,Z,X,X1,X2
 S Z=$O(^AUPNVINP("AD",V,0)) I 'Z Q Z
 S X1=$P($P(^AUPNVINP(Z,0),U),"."),X2=$P($P(^AUPNVSIT($P(^AUPNVINP(Z,0),U,3),0),U),".") D ^%DTC
 S:X=0 X=1
 Q X
FACTX ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW %,Y,Z
 S %="",Z=$O(^AUPNVINP("AD",V,0))
 I 'Z Q %
 I F="I" Q $$VALI^XBDIQ1(9000010.02,Z,.09)
 I F="C" S Y=$$VALI^XBDIQ1(9000010.02,Z,.09) S Y=+Y S Y=$S('Y:"",$D(^AUTTLOC(Y,0)):$P(^AUTTLOC(Y,0),U,10),1:"") Q Y  ;IHS/TUCSON/LAB - patch1 changed this line to check for existence of AUTTLOC node 3/4/97
 Q $$VAL^XBDIQ1(9000010.02,Z,.09)
ACTTIME ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$O(^AUPNVTM("AD",V,0))
 I 'Y Q Y
 Q $$VALI^XBDIQ1(9000010.19,Y,.01)
TRAVTIME ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$O(^AUPNVTM("AD",V,0))
 I 'Y Q Y
 Q $$VALI^XBDIQ1(9000010.19,Y,.04)
CHSCOST ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$O(^AUPNVCHS("AD",V,0))
 I 'Y Q Y
 Q $$VALI^XBDIQ1(9000010.03,Y,.06)
 ;
PATIENT ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,5)
 I Y="" Q Y
 I '$D(^DPT(Y)) Q -1
 Q $S($G(F)="E":$P(^DPT(Y,0),U),$G(F)="C":$$CHART^APCLV(V),1:Y)
 ;
DLM ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,13)
 I Y="" Q Y
 Q $S($G(F)="S":$$FMTE^XLFDT(Y,"2D"),$G(F)="E":$$FMTE^XLFDT(Y,"1D"),1:$P(Y,"."))
 ;
DVEX ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,14)
 I Y="" Q Y
 Q $S($G(F)="S":$$FMTE^XLFDT(Y,"2D"),$G(F)="E":$$FMTE^XLFDT(Y,"1D"),1:$P(Y,"."))
 ;
DWEX ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P($G(^AUPNVSIT(V,11)),U,6)
 I Y="" Q Y
 Q $S($G(F)="S":$$FMTE^XLFDT(Y,"2D"),$G(F)="E":$$FMTE^XLFDT(Y,"1D"),1:$P(Y,"."))
 ;
APWI ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,16)
 Q $S(Y="":Y,$G(F)="E":$$EXTSET^XBFUNC(9000010,.16,Y),1:Y)
 ;
CODT ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,18)
 I Y="" Q Y
 Q $S($G(F)="S":$$FMTE^XLFDT(Y,"2D"),$G(F)="E":$$FMTE^XLFDT(Y,"1D"),1:$P(Y,"."))
 ;
APDT ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 S Y=$P(^AUPNVSIT(V,0),U,25)
 I Y="" Q Y
 Q $S($G(F)="S":$$FMTE^XLFDT(Y,"2D"),$G(F)="E":$$FMTE^XLFDT(Y,"1D"),1:$P(Y,"."))
OUTSL ;EP
 I 'V Q -1
 I '$D(^AUPNVSIT(V)) Q -1
 NEW Y
 Q $P($G(^AUPNVSIT(V,21)),U)
 ;
PCHART ;EP
 NEW %,C,S,Z
 S %=""
 I '$D(^AUPNPAT(P,0)) Q %
 I 'L Q %
 I '$D(^AUPNPAT(P,41,L,0)) Q %
 S %=$$GETCHART(L)
 I %="" S %="      ??????"
 S %=$P(^AUTTLOC(L,0),U,7)_$E(%,7,12)
 Q %
 ;
APCWL ;EP
 I $G(V)="" Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 NEW R,L,P,C S R=^AUPNVSIT(V,0)
 I $P(R,U,11) Q ""  ;deleted visit
 I '$P(R,U,9) Q ""  ;no dep entries
 I '$D(^AUPNVPOV("AD",V)) Q ""  ;no pov's
 I '$D(^AUPNVPRV("AD",V)) Q ""  ; no provider
 I $P(R,U,3)="" Q ""
 I $P(R,U,7)="" Q ""
 I "AOS"'[$P(R,U,7) Q ""  ;no A, O S
 I "CVS"[$P(R,U,3) Q ""  ;no contract, state or VA
 S P=$P(R,U,5)
 I 'P Q ""  ;no patient
 I '$D(^DPT(P,0)) Q ""  ;no patient
 I $P(^DPT(P,0),U)["DEMO,PATIENT" Q ""  ;no demo,patient visits
 S L=$P(R,U,6)
 I L="" Q ""  ;no location
 I '$D(^AUTTLOC(L,0)) Q ""  ;location invalid
 ;check clinic
 N CL  ;cmi/anch/maw 8/7/2007
 S C=$P(R,U,8)  ;cmi/anch/maw 8/7/2007 split line here for dental mod
 S CL=$S(C:$P(^DIC(40.7,C,0),U,2),1:25)  ;if no clinic make it other
 I CL=56,$D(^AUPNVMED("AD",V)) Q 1  ;dental visit with med
 I C,$P($G(^DIC(40.7,C,90000)),U)'="Y" Q ""  ;cmi/anch/maw 8/7/2007 moved this line and modified from split line
 ;I $T(@C)]"" Q ""  ;not a workload reportable clinic code
 S D=$$PRIMPROV^APCLV(V,"F")  ;get internal of prov disc
 I D="" Q ""
 I '$D(^DIC(7,D,9999999)) Q ""  ;can't check discipline
 I $P($G(^DIC(7,D,9999999)),U,5)="Y" Q 1
 Q ""
CLEX ;
09 ;;
11 ;;
36 ;;
41 ;;
42 ;;
51 ;;
52 ;;
53 ;;
54 ;;
60 ;;
99 ;;
