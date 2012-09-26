BGP2D729 ; IHS/CMI/LAB - measure AHR.A ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
CHD(P,BDATE,EDATE) ;EP
 ;first dx prior to report period
 ;at least 2 visits during report period
 ;at least 2 Chd dxs ever
 I '$$V2^BGP2D1(P,BDATE,EDATE) Q ""  ;not 2 visits during report period
 K ^TMP($J)
 I '$$CHDV(P,$$DOB^AUPNPAT(P),$$FMADD^XLFDT(BDATE,-1),0,0) Q ""  ;first dx not prior to report period
 ;GET CHD DIAGNOSES AND SET BY VISIT
 I '$$CHDV(P,$$DOB^AUPNPAT(P),EDATE,1,1) Q ""  ;not two ever
 Q 1
CHDV(P,BDATE,EDATE,MIN,MINPROC) ;EP
 NEW A,B,E,T,X,G,V,Y,%,G,F,BGPG,BGPCNT,T1,BGPALL
 K BGPALL
 S BGPCNT=0
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S T=$O(^ATXAX("B","BGP CHD DXS",0))
 I 'T G CHDP
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(BGPCNT>MIN)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .I $G(BGPMFITI),'$D(^ATXAX(BGPMFITI,21,"B",$P(^AUPNVSIT(V,0),U,6))) Q
 .S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(BGPCNT>MIN)  I $D(^AUPNVPOV(Y,0)) D
 ..S %=$P(^AUPNVPOV(Y,0),U)
 ..I $$ICD^ATXCHK(%,T,9) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 ..;I $$ICD^ATXCHK(%,T1,9) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 ..;I $$ICD^ATXCHK(%,T2,9) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 I BGPCNT>MIN Q 1
CHDP ;NOW CHECK FOR MINPROC
 ;S BGPCNT=0
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(BGPCNT>MIN)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .I $G(BGPMFITI),'$D(^ATXAX(BGPMFITI,21,"B",$P(^AUPNVSIT(V,0),U,6))) Q
 .S T1=$O(^ATXAX("B","BGP PCI DXS",0))
 .S T2=$O(^ATXAX("B","BGP CABG DXS",0))
 .S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(BGPCNT>MINPROC)  I $D(^AUPNVPOV(Y,0)) D
 ..S %=$P(^AUPNVPOV(Y,0),U)
 ..;I $$ICD^ATXCHK(%,T,9) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 ..I $$ICD^ATXCHK(%,T1,9) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 ..I $$ICD^ATXCHK(%,T2,9) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 .;check for procedure in BGP CABG PROCS
 .S E=$O(^ATXAX("B","BGP CABG PROCS",0))
 .S F=$O(^ATXAX("B","BGP PCI CM PROCS",0))
 .S Y=0 F  S Y=$O(^AUPNVPRC("AD",V,Y)) Q:Y'=+Y!(BGPCNT>MINPROC)  D
 ..Q:'$D(^AUPNVPRC(Y,0))
 ..I $$ICD^ATXCHK($P(^AUPNVPRC(Y,0),U,1),E,0) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 ..I $$ICD^ATXCHK($P(^AUPNVPRC(Y,0),U,1),F,0) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1
 .;now check cpts
 .S E=$O(^ATXAX("B","BGP CABG CPTS",0))
 .S F=$O(^ATXAX("B","BGP PCI CPTS",0))
 .;S G=$O(^ATXAX("B","BGP PTCA CPTS",0))
 .S Y=0 F  S Y=$O(^AUPNVCPT("AD",V,Y)) Q:Y'=+Y!(BGPCNT>MINPROC)  D
 ..Q:'$D(^AUPNVCPT(Y,0))
 ..I $$ICD^ATXCHK($P(^AUPNVCPT(Y,0),U,1),E,1) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 ..I $$ICD^ATXCHK($P(^AUPNVCPT(Y,0),U,1),F,1) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 ..;I $$ICD^ATXCHK($P(^AUPNVCPT(Y,0),U,1),G,1) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 .;now check TRANS
 .S E=$O(^ATXAX("B","BGP CABG CPTS",0))
 .S F=$O(^ATXAX("B","BGP PCI CPTS",0))
 .;S G=$O(^ATXAX("B","BGP PTCA CPTS",0))
 .S Y=0 F  S Y=$O(^AUPNVTC("AD",V,Y)) Q:Y'=+Y!(BGPCNT>MINPROC)  D
 ..Q:'$D(^AUPNVTC(Y,0))
 ..S I=$P(^AUPNVTC(Y,0),U,7)
 ..Q:I=""
 ..I $$ICD^ATXCHK(I,E,1) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 ..I $$ICD^ATXCHK(I,F,1) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 ..;I $$ICD^ATXCHK(I,G,1) I '$D(BGPALL(V)) S BGPALL(V)="",BGPCNT=BGPCNT+1 Q
 .Q
 I BGPCNT>MIN Q 1
 Q ""
IHDCCVD(P,BDATE,EDATE) ;EP
 ;first dx prior to report period
 ;at least 2 visits during report period
 ;at least 2 ihd dxs ever
 I '$$V2^BGP2D1(P,BDATE,EDATE) Q ""  ;not 2 visits during report period
 K ^TMP($J)
 I '$$FIRSTIHD(P,EDATE) Q ""  ;first dx not prior to report period
 I '$$V2IHD(P,$$DOB^AUPNPAT(P),EDATE) Q ""  ;at least 2 IHD dxs ever
 Q 1
FIRSTIHD(P,EDATE) ;EP
 I $G(P)="" Q ""
 NEW BGPG,Y,X,E
 K BGPG
 S Y="BGPG("
 S X=P_"^FIRST DX [BGP IHD DXS (GPRA)" S E=$$START1^APCLDF(X,Y)
 I '$D(BGPG(1)) Q ""
 S X=$$FMDIFF^XLFDT(EDATE,$P(BGPG(1),U))
 Q $S(X>365:1,1:"")
 ;
V2IHD(P,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 I '$D(^AUPNVSIT("AC",P)) Q ""
 NEW A,B,E,T,X,G,V,Y,%,G
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S T=$O(^ATXAX("B","BGP IHD DXS (GPRA)",0))
 I 'T Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G>2)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .I $G(BGPMFITI),'$D(^ATXAX(BGPMFITI,21,"B",$P(^AUPNVSIT(V,0),U,6))) Q
 .S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(D)  I $D(^AUPNVPOV(Y,0)) S %=$P(^AUPNVPOV(Y,0),U) I $$ICD^ATXCHK(%,T,9) S D=1
 .Q:'D
 .S G=G+1
 .Q
 K ^TMP($J,"A")
 Q $S(G<2:"",1:1)
 ;
