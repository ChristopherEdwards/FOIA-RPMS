BGP7D51 ; IHS/CMI/LAB - measure I2 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
ICRSAMM ;EP
 K ^TMP($J,"A"),^TMP($J,"MEDS")
 S (BGPD1,BGPD2,BGPD3,BGPD4,BGPD5,BGPD6,BGPD7,BGPD8,BGPD9)=0
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7)=0
 I BGPAGEB<18 S BGPSTOP=1 Q  ;18 and older
 S BGPC1B=($E(BGPBDATE,1,3)-1)_$E(BGPBDATE,4,7)
 S BGPC1=$$CRIT1DEN(DFN,$$FMADD^XLFDT(BGPC1B,120),$$FMADD^XLFDT(BGPBDATE,120)) ;set equal to index start date
 K ^TMP($J,"A")
 I BGPC1="" S BGPSTOP=1 Q  ;no dx of depression
 S BGPC2=$$CRIT2DEN(DFN,$$FMADD^XLFDT($P(BGPC1,U,2),-30),$$FMADD^XLFDT($P(BGPC1,U,2),14)) ;set equal prescription start date
 K ^TMP($J,"MEDS")
 I BGPC2="" S BGPSTOP=1 Q  ;no prescription filled, therefore does not meet criteria 2 for denominator
 S BGPE=$$EXCL(DFN,$P(BGPC1,U),$P(BGPC2,U),$P(BGPC1,U,2))
 I BGPE S BGPSTOP=1 Q  ;met an exclusion criteria so don't count in denominator
 S BGPN1=$$OPC(DFN,$$FMADD^XLFDT($P(BGPC1,U,2),1),$$FMADD^XLFDT($P(BGPC1,U,2),84))
 S BGPN2=$$EAPT^BGP7D52(DFN,$P(BGPC2,U),$$FMADD^XLFDT($P(BGPC2,U),114),84,30,114)
 S BGPN3=$$EAPT^BGP7D52(DFN,$P(BGPC2,U),$$FMADD^XLFDT($P(BGPC2,U),231),180,51,231)
 I BGPACTCL S BGPD1=1
 I BGPACTUP S BGPD2=1
 S BGPVALUE=$S($G(BGPRTYPE)=3:"AC",BGPD1:"UP,AC",1:"UP")
 S BGPV=$S(BGPN1:"OPC",1:"NOT OPC")
 I BGPN2 S BGPV=BGPV_$S(BGPV]"":";",1:"")_" APT"
 I 'BGPN2 S BGPV=BGPV_$S(BGPV]"":";",1:"")_"NOT APT: "_$P(BGPN2,U,2)
 I BGPN3 S BGPV=BGPV_$S(BGPV]"":";",1:"")_"CONPT"
 I 'BGPN3 S BGPV=BGPV_$S(BGPV]"":";",1:"")_"NOT CONPT: "_$P(BGPN3,U,2)
 S BGPVALUE=BGPVALUE_" IESD: "_$$DATE^BGP7UTL($P(BGPC1,U,2))_"|||"_BGPV
 K %,A,B,C,D,E,F,G,H,J,K,M,N,O,P,Q,R,S,T,T1,T2,V,W,X,Y,Z
 Q
NDC(A,B) ;
 ;a is drug ien
 ;b is taxonomy ien
 S BGPNDC=$P($G(^PSDRUG(A,2)),U,4)
 I BGPNDC]"",B,$D(^ATXAX(B,21,"B",BGPNDC)) Q 1
 Q 0
CRIT1DEN(P,BDATE,EDATE) ;
 K Y,V,T,X,T2,D,BGPG,G,S,T1,A,B,F,W,%,Q,Z
 K ^TMP($J,"A")
 K S,Q
 S G="",S=0
 S T=$O(^ATXAX("B","BGP MAJOR DEPRESSION (ADM)",0))
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S X="",G="" F  S X=$O(^TMP($J,"A",X),-1) Q:X=""  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:"EC"[$P(^AUPNVSIT(V,0),U,7)
 .Q:'$D(^AUPNVPOV("AD",V))  ;NO POVS
 .S Y=$$PRIMPOV^APCLV(V,"I") ;get primary pov
 .I $$ICD^ATXCHK(Y,T,9) S S($P($P(^AUPNVSIT(V,0),U),"."))=$S($P(^AUPNVSIT(V,0),U,7)'="H":$P($P(^AUPNVSIT(V,0),U),"."),1:$$DSCHDATE^APCLV(V,"I"))_U_V,G=1 Q  ;had one primary dx of major depression
 .K Q S (C,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y  D
 ..Q:'$D(^AUPNVPOV(Y,0))
 ..S C=C+1
 ..S Q(C)=Y_U_$P(^AUPNVPOV(Y,0),U,12)_U_$P(^AUPNVPOV(Y,0),U)
 ..Q
 .S (Y,F)=0 F  S Y=$O(Q(Y)) Q:Y'=+Y  I $P(Q(Y),U,2)="P" K Q(Y) S F=1  ;has one marked as primary so kill it
 .I '$O(Q(0)) Q  ;no more povs left
 .I 'F S Y=$O(Q(0)) I Y K Q(Y)  ;kill off first one if none marked as primary
 .;now go through and see if any are depression
 .S F=0 F  S Y=$O(Q(Y)) Q:Y'=+Y  I $$ICD^ATXCHK($P(Q(Y),U,3),T,9) S F=1
 .I F=1,$P(^AUPNVSIT(V,0),U,7)="H" S S($P($P(^AUPNVSIT(V,0),U),"."))=$$DSCHDATE^APCLV(V,"I")_U_V,G=1 Q
 .I F=1 S D=$P($P(^AUPNVSIT(V,0),U,1),".") I '$D(S(D)) S S(D)=D_U_V,S=S+1
 .Q
 K ^TMP($J,"A")
 ;I G]"" Q G
 I G S Y=$O(S(0)) Q Y_U_S(Y)
 I S>1 S Y=$O(S(0)) Q Y_U_S(Y)
 Q ""
CRIT2DEN(P,BDATE,EDATE) ;
 K Y,V,T,X,T2,D,BGPG,G,S,T1,A,B,F,W,%,Q,Z
 ;see if there ACTIVE PRESCRIPTION of beta blockers in time window
 K ^TMP($J,"MEDS")
 S BGPG=""
 S Y="^TMP($J,""MEDS"",",X=P_"^ALL MED;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S T=$O(^ATXAX("B","BGP HEDIS ANTIDEPRESSANT MEDS",0))
 S T2=$O(^ATXAX("B","BGP HEDIS ANTIDEPRESSANT NDC",0))
 S X=0 F  S X=$O(^TMP($J,"MEDS",X)) Q:X'=+X!(BGPG]"")  S Y=+$P(^TMP($J,"MEDS",X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .S V=$P(^AUPNVMED(Y,0),U,3)
 .S G=0
 .S D=$P(^AUPNVMED(Y,0),U)
 .I $P(^AUPNVMED(Y,0),U,8)=$P($P(^AUPNVSIT(V,0),U),".") Q  ;date discont=visit
 .I T,$D(^ATXAX(T,21,"B",D))!($$NDC(D,T2)) S BGPG=$P($P(^AUPNVSIT(V,0),U),".")_U_V_U_Y Q
 .;S C=$P($G(^PSDRUG(D,0)),U,2)
 .;I C]"",T2,$D(^ATXAX(T2,21,"B",C)) S BGPG=$P($P(^AUPNVSIT(V,0),U),".")_U_V_U_Y Q
 K ^TMP($J,"MEDS")
 Q BGPG
EXCL(P,ISD,PSD,ISD1) ;
 K Y,V,T,X,T2,D,BGPG,G,S,T1,A,B,F,W,%,Q,Z
 S %=P_"^ALL DX [BGP MAJOR DEPRESSION PRIOR;DURING "_$$FMADD^XLFDT(ISD,-120)_"-"_$$FMADD^XLFDT(ISD,-1),E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) Q 1  ;HAD A VISIT PRIOR WITH DX
 ;now check for prescriptions
 K ^TMP($J,"MEDS")
 S BGPG=""
 S Y="^TMP($J,""MEDS"",",X=P_"^ALL MED;DURING "_$$FMADD^XLFDT(PSD,-90)_"-"_$$FMADD^XLFDT(PSD,-1) S E=$$START1^APCLDF(X,Y)
 S T=$O(^ATXAX("B","BGP HEDIS ANTIDEPRESSANT MEDS",0))
 S T2=$O(^ATXAX("B","BGP HEDIS ANTIDEPRESSANT VA CLASS",0))
 S X=0 F  S X=$O(^TMP($J,"MEDS",X)) Q:X'=+X!(BGPG]"")  S Y=+$P(^TMP($J,"MEDS",X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .S V=$P(^AUPNVMED(Y,0),U,3)
 .S G=0
 .S D=$P(^AUPNVMED(Y,0),U)
 .I $P(^AUPNVMED(Y,0),U,8)=$P($P(^AUPNVSIT(V,0),U),".") Q  ;date discont=visit
 .I T,$D(^ATXAX(T,21,"B",D))!($$NDC(D,T2)) S BGPG=$P($P(^AUPNVSIT(V,0),U),".")_U_V_U_Y Q
 .;S C=$P($G(^PSDRUG(D,0)),U,2)
 .;I C]"",T2,$D(^ATXAX(T2,21,"B",C)) S BGPG=$P($P(^AUPNVSIT(V,0),U),".")_U_V_U_Y Q
 K ^TMP($J,"MEDS")
 I BGPG]"" Q 1
 ;now check for hospital stay
 K ^TMP($J,"A")
 S G="",S=0
 S T=$O(^ATXAX("B","BGP ACUTE MENTAL HEALTH",0))
 S T1=$O(^ATXAX("B","BGP SUBSTANCE ABUSE",0))
 S T2=$O(^ATXAX("B","BGP POISONINGS SUBSTANCE ABUSE",0))
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMADD^XLFDT(ISD1,1)_"-"_$$FMADD^XLFDT(ISD1,245),E=$$START1^APCLDF(B,A)
 S X=0,G="" F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G]"")  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:$P(^AUPNVSIT(V,0),U,7)'="H"
 .Q:'$D(^AUPNVPOV("AD",V))  ;NO POVS
 .S Y=$$PRIMPOV^APCLV(V,"I") ;get primary pov
 .I $$ICD^ATXCHK(Y,T,9) S G=$P($P(^AUPNVSIT(V,0),U),".")_U_V Q  ;had one primary dx of major depression
 .I $$ICD^ATXCHK(Y,T1,9) S G=$P($P(^AUPNVSIT(V,0),U),".")_U_V Q
 .I $$ICD^ATXCHK(Y,T2,9) D  Q
 ..;CHECK SECONDARY POVS FOR SUBSTANCE ABUSE
 ..S Q=$$PRIMPOV^APCLV(V,"I")
 ..S (F,W,Z)=0 F  S W=$O(^AUPNVPOV("AD",V,W)) Q:W'=+W  D
 ...Q:'$D(^AUPNVPOV(W,0))
 ...S Z=$P(^AUPNVPOV(W,0),U)
 ...Q:W=Q
 ...I $$ICD^ATXCHK(Z,T1,9) S G=$P($P(^AUPNVSIT(V,0),U),".")_U_V Q
 K ^TMP($J,"A")
 I G]"" Q 1
 Q ""
OPC(P,BDATE,EDATE) ;
 ;3 visits or 2 visits and a telephone call
 ;A=# of outpt mental hlth visits
 ;B=# of outpt non mh visits
 ;C=# prescribing provider visits
 ;D=# of telephone calls for mh visits
 K Y,V,T,X,T2,D,BGPG,G,S,T1,A,B,F,W,%,Q,Z,C
 K ^TMP($J,"A")
 S Z="^TMP($J,""A"",",%=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,Z)
 I '$D(^TMP($J,"A",1)) Q ""
 S (A,B,C,D)=0
 S X=0,G="" F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G]"")  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:$$CLINIC^APCLV(V,"C")=30
 .I $$MHO(V) S A=A+1,A(V)="" I $$PPCHK(V) S C=C+1,C(V)="" Q
 .I $$MHT(V) S D=D+1,D(V)="" I $$PPCHK(V) S C=C+1,C(V)="" Q
 .I $$NMHO(V) S A=A+1,A(V)="" I $$PPCHK(V) S C=C+1,C(V)="" Q
 ;NOW CHECK BH AND ADD IN VISITS
 S E=9999999-BDATE,J=9999999-EDATE-1_".99" F  S J=$O(^AMHREC("AE",P,J)) Q:J'=+J!($P(J,".")>E)  S V=0 F  S V=$O(^AMHREC("AE",P,J,V)) Q:V'=+V  D
 .Q:'$D(^AMHREC(V,0))
 .S Y=$P(^AMHREC(V,0),U,16)
 .I Y,$D(A(Y)) Q  ;already checked this visit
 .I Y,$D(B(Y)) Q
 .I Y,$D(C(Y)) Q
 .I Y,$D(D(Y)) Q
 .S X=$P(^AMHREC(V,0),U,25) I X,$P($G(^DIC(40.7,X,0)),U,2)=30 Q
 .S X=$P(^AMHREC(V,0),U,7) I X,$P($G(^AMHTSET(X,0)),U,2)=9 Q
 .I $$BHMHO(V) S A=A+1 I $$PPCHK(V) S C=C+1 Q
 .I $$BHMHT(V) S D=D+1 I $$PPCHK(V) S C=C+1 Q
 .I $$BHNMHO(V) S A=A+1 I $$PPCHK(V) S C=C+1 Q
 K ^TMP($J,"A")
 I A>2,C Q 1
 I A=2,D>0,C Q 1
 Q ""
CPTV(V,T) ;does this visit have a cpt code in taxonomy T
 NEW X,G,Z
 I $G(T)="" Q ""
 I '$G(V) Q ""
 S T=$O(^ATXAX("B",T,0))
 I '$G(T) W BGPBOMB Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 S G=0
 S X=$P(^AUPNVSIT(V,0),U,17) I X,$$ICD^ATXCHK(X,T,1) Q 1
 S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(G)  D
 .Q:'$D(^AUPNVCPT(X,0))
 .S Z=$P(^AUPNVCPT(X,0),U)
 .I $$ICD^ATXCHK(Z,T,1) S G=1
 .Q
 Q G
POVV(V,T) ;does this visit have a pov of a code in taxonomy T
 NEW X,G,Z
 I $G(T)="" Q ""
 I '$G(V) Q ""
 S T=$O(^ATXAX("B",T,0))
 I '$G(T) W BGPBOMB Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 S G=0
 S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X!(G)  D
 .Q:'$D(^AUPNVPOV(X,0))
 .S Z=$P(^AUPNVPOV(X,0),U)
 .I $$ICD^ATXCHK(Z,T,9) S G=1
 .Q
 Q G
PRVV(V,T) ;does this visit have a primary provider with a class in taxonomy T
 NEW X
 I $G(T)="" Q ""
 I '$G(V) Q ""
 S T=$O(^ATXAX("B",T,0))
 I '$G(T) W BGPBOMB Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 S X=$$PRIMPROV^APCLV(V,"F")
 I X="" Q ""
 I $D(^ATXAX(T,21,"B",X)) Q 1
 Q 0
MHO(V) ;EP
 I '$$PRVV(V,"BGP MENTAL HEALTH PROV CLASS") Q ""
 I "AOS"[$P(^AUPNVSIT(V,0),U,7),$$CPTV(V,"BGP OPT MH VISIT CPTS MH")!($$POVV(V,"BGP OPT MH VISIT POVS")) Q 1
 I "AOS"[$P(^AUPNVSIT(V,0),U,7),($P(^AUPNVSIT(V,0),U,6)=$P($G(^BGPSITE(DUZ(2),0)),U,2)!($$CLINIC^APCLV(V,"C")=11)) Q 1
 Q 0
MHT(V) ;EP
 I '$$PRVV(V,"BGP MENTAL HEALTH PROV CLASS") Q ""
 I $P(^AUPNVSIT(V,0),U,7)="T" Q 1
 Q 0
PPCHK(V) ;EP
 I $$PRVV(V,"BGP PRESCRIBING PROVIDER CLASS") Q 1
 Q 0
NMHO(V) ;EP
 I $$PRVV(V,"BGP MENTAL HEALTH PROV CLASS") Q ""
 I "AOS"[$P(^AUPNVSIT(V,0),U,7),$$CPTV(V,"BGP MH OPT VISIT CPT NMH 1") Q 1
 I "AOST"[$P(^AUPNVSIT(V,0),U,7)!($P(^AUPNVSIT(V,0),U,6)=$P($G(^BGPSITE(DUZ(2),0)),U,2))!($$CLINIC^APCLV(V,"C")=11),$$POVV(V,"BGP OPT MH VISIT POVS") Q 1
 I "AOS"[$P(^AUPNVSIT(V,0),U,7),$$CPTV(V,"BGP MH OPT VISIT CPT NMH 3"),$$POVV(V,"BGP OPT MH VISIT POVS") Q 1
 Q 0
BHCPTV(V,T) ;does this visit have a cpt code in taxonomy T
 NEW X,G,Z
 I $G(T)="" Q ""
 I '$G(V) Q ""
 S T=$O(^ATXAX("B",T,0))
 I '$G(T) W BGPBOMB Q ""
 I '$D(^AMHREC(V,0)) Q ""
 S G=0
 S X=0 F  S X=$O(^AMHRPROC("AD",V,X)) Q:X'=+X!(G)  D
 .Q:'$D(^AMHRPROC(X,0))
 .S Z=$P(^AMHRPROC(X,0),U)
 .I $$ICD^ATXCHK(Z,T,1) S G=1
 .Q
 Q G
BHPOVV(V,T) ;does this visit have a pov of a code in taxonomy T
 NEW X,G,Z
 I $G(T)="" Q ""
 I '$G(V) Q ""
 S T=$O(^ATXAX("B",T,0))
 I '$G(T) W BGPBOMB Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 S G=0
 S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(G)  D
 .Q:'$D(^AMHRPRO(X,0))
 .S Z=$P(^AMHRPRO(X,0),U)
 .I Z="" Q
 .S Z=$P($G(^AMHPROB(Z,0)),U,5)
 .I Z="" Q
 .;S Z=$O(^ICD9("AB",Z,0))
 .S Z=+$$CODEN^ICDCODE(Z,80)
 .I Z="" Q
 .I $$ICD^ATXCHK(Z,T,9) S G=1
 .Q
 Q G
BHPRVV(V,T) ;does this visit have a primary provider with a class in taxonomy T
 NEW X,G,Y
 I $G(T)="" Q ""
 I '$G(V) Q ""
 S T=$O(^ATXAX("B",T,0))
 I '$G(T) W BGPBOMB Q ""
 S G=0
 S X=0 F  S X=$O(^AMHRPROV("AD",V,X)) Q:X'=+X!(G)  D
 .Q:'$D(^AMHRPROV(X,0))
 .I $P(^AMHRPROV(X,0),U,4)="P" S Y=$P(^AMHRPROV(X,0),U) I Y S G=$P($G(^VA(200,Y,53.5)),U)
 I 'G Q ""
 I $D(^ATXAX(T,21,"B",G)) Q 1
 Q 0
BHMHO(V) ;EP
 I '$$BHPRVV(V,"BGP MENTAL HEALTH PROV CLASS") Q ""
 I $$BHOTOC(V),$$BHCPTV(V,"BGP OPT MH VISIT CPTS MH")!($$BHPOVV(V,"BGP OPT MH VISIT POVS")) Q 1
 I $$BHOTOC(V),($P(^AMHREC(V,0),U,4)=$P($G(^BGPSITE(DUZ(2),0)),U,2)!($$BHCLINIC(V,"C")=11)) Q 1
 Q ""
BHMHT(V) ;EP
 I '$$BHPRVV(V,"BGP MENTAL HEALTH PROV CLASS") Q ""
 I $$BHTTOC(V) Q 1
 Q 0
BHPPCHK(V) ;EP
 I $$BHPRVV(V,"BGP PRESCRIBING PROVIDER CLASS") Q 1
 Q 0
BHNMHO(V) ;EP
 I $$BHPRVV(V,"BGP MENTAL HEALTH PROV CLASS") Q ""
 I $$BHOTOC(V),$$BHCPTV(V,"BGP MH OPT VISIT CPT NMH 1") Q 1
 I $$BHOTOC(V)!($$BHOTOC(V))!($P(^AMHREC(V,0),U,4)=$P($G(^BGPSITE(DUZ(2),0)),U,2))!($$CLINIC^APCLV(V,"C")=11),$$POVV(V,"BGP OPT MH VISIT POVS") Q 1
 I $$BHOTOC(V),$$BHCPTV(V,"BGP MH OPT VISIT CPT NMH 3"),$$BHPOVV(V,"BGP OPT MH VISIT POVS") Q 1
 Q 0
BHOTOC(V) ;EP is type of contact 2, 16
 NEW X
 S X=$P(^AMHREC(V,0),U,7)
 I X="" Q ""
 S X=$P($G(^AMHTSET(X,0)),U,2)
 I X=2 Q 1
 I X=16 Q 1
 Q ""
BHCLINIC(V) ;EP
 NEW X
 I '$D(^AMHREC(V,0)) Q ""
 S X=$P(^AMHREC(V,0),U,25)
 I X="" Q ""
 Q $P($G(^DIC(40.7,X,0)),U,2)
BHTTOC(V) ;EP is type of contact 8,15
 NEW X
 S X=$P(^AMHREC(V,0),U,7)
 I X="" Q ""
 S X=$P($G(^AMHTSET(X,0)),U,2)
 I X=8 Q 1
 I X=15 Q 1
 Q ""
