BGPD3 ; IHS/CMI/LAB - indicator 3 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
I3A ;EP ;EP - indicator 2a
 Q:'BGPDMPAT  ;not in the simple population for denominator
 S BGPMBP=$$MEANBP(DFN,BGPEDATE)
 ;set value 2,3,4 piece and set list
 I $P(BGPMBP,U,2) D S(BGPRPT,$S(BGPTIME=1:13,BGPTIME=0:43,BGPTIME=8:83,1:999),$P(BGPMBP,U,2),1) ;set piece 2,3,4
 I $D(BGPLIST(6)),BGPTIME=1 S ^XTMP("BGPD",BGPJ,BGPH,"LIST",6,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEE,DFN)=$P(BGPMBP,U)
 Q
I3B ;EP
 ;;Q:'$D(BGPIND(7))
 Q:'BGPDMPAT  ;not in the simple population for denominator
 Q:'BGP2BD
 ;set value 2,3,4 piece and set list
 I $P(BGPMBP,U,2) D S(BGPRPT,$S(BGPTIME=1:13,BGPTIME=0:43,BGPTIME=8:83,1:999),$P(BGPMBP,U,2)+5,1) ;set piece 2,3,4
 I $D(BGPLIST(7)),BGPTIME=1 S ^XTMP("BGPD",BGPJ,BGPH,"LIST",7,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEE,DFN)=$P(BGPMBP,U)
 Q
I3C ;EP
 ;Q:'$D(BGPIND(8))
 Q:'BGPDMPAT  ;not in the simple population for denominator
 Q:'BGP2CD
 ;set value 2,3,4 piece and set list
 I $P(BGPMBP,U,2) D S(BGPRPT,$S(BGPTIME=1:13,BGPTIME=0:43,BGPTIME=8:83,1:999),$P(BGPMBP,U,2)+10,1) ;set piece 2,3,4
 I $D(BGPLIST(8)),BGPTIME=1 S ^XTMP("BGPD",BGPJ,BGPH,"LIST",8,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEE,DFN)=$P(BGPMBP,U)
 Q
S(R,N,P,V) ;
 I 'V Q  ;no value to add
 S $P(^BGPD(R,N),U,P)=$P($G(^BGPD(R,N)),U,P)+V
 Q
MEANBP(P,EDATE) ;
 NEW S,D,DS,X
 S D=$$FMADD^XLFDT(EDATE,-365)
 S X=$$BPS(P,D,EDATE,"I")
 S S=$$SYSMEAN(X) I S="" Q "^4"
 S DS=$$DIAMEAN(X) I DS="" Q "^4"
 I S<130&(DS<80) Q S_"/"_DS_" CON"_U_2
 Q S_"/"_DS_" UNC"_U_3
SYSMEAN(X) ;EP
 I X="" Q ""
 NEW Y,C S C=0 F Y=1:1:3 I $P(X,";",Y)]"" S C=C+1
 I C'=3 Q ""
 S C=0 F Y=1:1:3 S C=$P($P(X,";",Y),"/")+C
 Q C\3
DIAMEAN(X) ;EP
 I X="" Q ""
 NEW Y,C S C=0 F Y=1:1:3 I $P(X,";",Y)]"" S C=C+1
 I C'=3 Q ""
 S C=0 F Y=1:1:3 S C=$P($P(X,";",Y),"/",2)+C
 Q C\3
BPS(P,BDATE,EDATE,F) ;EP ;
 I $G(F)="" S F="E"
 NEW X,BGPG,E,BGPGL,BGPGLL,BGPGV
 S BGPGLL=0,BGPGV=""
 K BGPG
 S X=P_"^LAST 50 MEAS BP;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"BGPG(")
 S BGPGL=0 F  S BGPGL=$O(BGPG(BGPGL)) Q:BGPGL'=+BGPGL!(BGPGLL=3)  S BGPGBP=$P($G(BGPG(BGPGL)),U,2) D
 .Q:$$CLINIC^APCLV($P(BGPG(BGPGL),U,5),"C")=30
 .S BGPGLL=BGPGLL+1
 .I F="E" S $P(BGPGV,";",BGPGLL)=BGPGBP_"  "_$$FMTE^XLFDT($P(BGPG(BGPGL),U))
 .I F="I" S $P(BGPGV,";",BGPGLL)=$P(BGPGBP," ")
 Q BGPGV
