BGP9D24 ; IHS/CMI/LAB - STI MEASURE 18 Oct 2007 8:37 AM 03 Jul 2008 7:56 AM ; 
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
ISTI ;EP
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7,BGPN8,BGPN9,BGPN10,BGPN11,BGPN12,BGPD1,BGPD2,BGPD3,BGPD4,BGPD5)=0
 S BGPVALUE="",BGPDENV=""
 K BGPYAR,BGPZAR,BGPNUMV
 I $T(EN^BKMSTIDS)="" S BGPSTOP=1 Q  ;no routine to execute
 D EN^BKMSTIDS(DFN,BGPBDATE,BGPEDATE,"KEY",.BGPYAR,.BGPZAR)
 I '$D(BGPZAR) S BGPSTOP=1 Q  ;no incidences or diagnoses
 I $P($G(BGPZAR(0)),U)=0 S BGPSTOP=1 Q  ;no incidences or diagnoses
 S (BGPN1,BGPN2)=$P(BGPZAR(0),U,1)  ;TOTAL # OF INCIDENCES
 S BGPD1=$P(BGPZAR(0),U,2) ;TOTAL # SCREENINGS NEEDED
 S BGPN3=$P(BGPZAR(0),U,3) ;TOTAL # OF SCREENINGS DONE
 S BGPN4=$P(BGPZAR(0),U,4) ;TOTAL # OF REFUSALS
 S X=0 F  S X=$O(BGPZAR(X)) Q:X'=+X  D
 .S BGPNUMV(X)=""
 .S I=0,C=0,H="" F  S I=$O(BGPZAR(X,I)) Q:I=""  D
 ..I $D(BGPZAR(X,I,0)) S C=C+1 S BGPDENV=BGPDENV_$S(C=1:X_") ",1:"")_$P(BGPZAR(X,I,0),U,5)_"; "
 ..I $G(BGPYAR(I,"NUM","HIV"))=1 S H=$O(BGPYAR(I,"NUM","HIV",0)) I H S J=$P(BGPYAR(I,"NUM","HIV",H),U,2) I J'["POV" S H=""
 .D
 ..I $G(BGPZAR(X,"CHL"))]"" S Z=$G(BGPZAR(X,"CHL")) S:$P(Z,U) BGPD2=BGPD2+1 S:$P(Z,U,2) BGPN5=BGPN5+1 S:$P(Z,U,3) BGPN6=BGPN6+1 D
 ...S BGPNUMV(X)=BGPNUMV(X)_"CHL-"_$S($P(Z,U,2):"Y",1:"N")_" "_$P(Z,U,4)_"; " ;CHL SCREENINGS NEEDED/DONE
 ..I $G(BGPZAR(X,"GC"))]"" S Z=$G(BGPZAR(X,"GC")) S:$P(Z,U) BGPD3=BGPD3+1 S:$P(Z,U,2) BGPN7=BGPN7+1 S:$P(Z,U,3) BGPN8=BGPN8+1 D
 ...S BGPNUMV(X)=BGPNUMV(X)_"GC-"_$S($P(Z,U,2):"Y",1:"N")_" "_$P(Z,U,4)_"; " ;GON SCREENINGS NEEDED/DONE
 ..I $G(BGPZAR(X,"HIV"))]"" S Z=$G(BGPZAR(X,"HIV")) S:$P(Z,U) BGPD4=BGPD4+1 S:$P(Z,U,2) BGPN9=BGPN9+1 S:$P(Z,U,3) BGPN10=BGPN10+1 D
 ...S BGPNUMV(X)=BGPNUMV(X)_"HIV-"_$S($P(Z,U,2):"Y",1:"N")_" "_$P(Z,U,4)_"; " ;HIV SCREENINGS NEEDED/DONE
 ..I $G(BGPZAR(X,"SYP"))]"" S Z=$G(BGPZAR(X,"SYP")) S:$P(Z,U) BGPD5=BGPD5+1 S:$P(Z,U,2) BGPN11=BGPN11+1 S:$P(Z,U,3) BGPN12=BGPN12+1 D
 ...S BGPNUMV(X)=BGPNUMV(X)_"SYP-"_$S($P(Z,U,2):"Y",1:"N")_" "_$P(Z,U,4)_"; " ;SYP SCREENINGS NEEDED/DONE
 .I H]"" S BGPNUMV(X)=BGPNUMV(X)_"Prior HIV DX (Contraind): "_$$DATE^BGP9UTL(H)
 .S BGPVALUE="UP"_$S(BGPACTCL:";AC",1:"")_" "_BGPDENV_"|||"
 S X=0 F  S X=$O(BGPNUMV(X)) Q:X'=+X  S BGPVALUE=BGPVALUE_X_") "_BGPNUMV(X)_"; "
 Q
 ;
IASB ;EP
 S (BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPD1,BGPD2,BGPD3,BGPD4,BGPD5)=0
 S BGPVALUE=""
 I 'BGPACTUP S BGPSTOP=1 Q
 I BGPAGEB<15 S BGPSTOP=1 Q
 I BGPAGEB>34 S BGPSTOP=1 Q
 K BGPERV  ;will return array of all er visits with injury diagnosis fm date^injury dx^screen^positive^text^bni^bni text
 D ERINJ(DFN,BGPBDATE,BGPEDATE,.BGPERV)
 I '$G(BGPERV(0)) S BGPSTOP=1 Q  ;no injury visits
 S BGPD1=BGPERV(0)  ;total # of visits
 I BGPAGEB>14,BGPAGEB<25 S BGPD2=BGPERV(0)
 I BGPAGEB>24,BGPAGEB<35 S BGPD3=BGPERV(0)
 S X=0,BGPN1=0 F  S X=$O(BGPERV(X)) Q:X'=+X  I $P(BGPERV(X),U,4) S BGPN1=BGPN1+1  ;SCREEN ON EVERY VISIT?
 S X=0,BGPN2=0 F  S X=$O(BGPERV(X)) Q:X'=+X  I $P(BGPERV(X),U,5) S BGPN2=BGPN2+1  ;positive on at least one
 I BGPN2 S X=0,BGPN3=0 F  S X=$O(BGPERV(X)) Q:X'=+X  D
 .I $P(BGPERV(X),U,5),$P(BGPERV(X),U,7) S BGPN3=BGPN3+1
 I BGPN3 S X=0 F  S X=$O(BGPERV(X)) Q:X'=+X  I $P(BGPERV(X),U,5) S:$P(BGPERV(X),U,10)=1 BGPN4=BGPN4+1 S:$P(BGPERV(X),U,10)=2 BGPN5=BGPN5+1
 S BGPVALUE="UP"_$S(BGPACTCL:";AC",1:"")
 S V="",X=0,D="" F  S X=$O(BGPERV(X)) Q:X'=+X  S D=D_$S(D]"":"; ",1:"")_"ER Visit "_X_") "_$$DATE^BGP9UTL($P(BGPERV(X),U,1))_" ["_$P(BGPERV(X),U,3)_"]" D
 .S V=V_$S(V]"":"; ",1:"")
 .S V=V_"ER Visit "_X_") "
 .I '$P(BGPERV(X),U,4) S V=V_"No Scrn" Q
 .S V=V_$S($P(BGPERV(X),U,5):"Pos",1:"Neg/No Res")_" Scrn: "_$P(BGPERV(X),U,6)
 .I '$P(BGPERV(X),U,5) Q
 .I '$P(BGPERV(X),U,7) S V=V_", No BNI" Q
 .S V=V_", BNI "_$S($P(BGPERV(X),U,10)=1:"at ER",1:"in 7")_": "_$$DATE^BGP9UTL($P(BGPERV(X),U,8))_" "_$P(BGPERV(X),U,9)
 S BGPVALUE=BGPVALUE_" "_D_"|||"_V
 Q
 ;
ERINJ(P,BDATE,EDATE,BGPRET) ;
 ;did patient P have an ER visit with an injury dx?
 K ^TMP($J,"A")
 K BGPRET
 NEW A,G,B,E,D,CNT,T
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S T=$O(^ATXAX("B","BGP INJURY DIAGNOSES",0))
 S E=$O(^ATXAX("B","BGP CAUSE OF INJURY ECODES",0))
 S (X,G,CNT)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:$P(^AUPNVSIT(V,0),U,7)'="A"  ;ambulatory only
 .Q:$$CLINIC^APCLV(V,"C")'=30
 .Q:"CV"[$P(^AUPNVSIT(V,0),U,3)  ;no contract health
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .I $G(BGPMFITI),'$D(^ATXAX(BGPMFITI,21,"B",$P(^AUPNVSIT(V,0),U,6))) Q
 .S D=$P($P(^AUPNVSIT(V,0),U),".")
 .;check diagnosis for injury
 .S (G,A)=0 F  S A=$O(^AUPNVPOV("AD",V,A)) Q:A'=+A!(G)  D
 ..S B=$P($G(^AUPNVPOV(A,0)),U)
 ..I $$ICD^ATXCHK(B,T,9) S CNT=CNT+1,BGPRET(CNT)=D_U_V_U_$P($$ICDDX^ICDCODE(B),U,2),G=1,$P(BGPRET(CNT),U,4)=$$ERAS(V),$P(BGPRET(CNT),U,7)=$$BNI(P,V,BGPRET(CNT)) Q
 ..S B=$P($G(^AUPNVPOV(A,0)),U,9)
 ..I $$ICD^ATXCHK(B,E,9) S CNT=CNT+1,BGPRET(CNT)=D_U_V_U_$P($$ICDDX^ICDCODE(B),U,2),G=1,$P(BGPRET(CNT),U,4)=$$ERAS(V),$P(BGPRET(CNT),U,7)=$$BNI(P,V,BGPRET(CNT)) Q
 S BGPRET(0)=CNT
 Q
 ;
ERAS(V) ;was there screening on this visit V and was it positive
 I $G(V)="" Q ""
 NEW X,Y,Z,A,T
 S X=0,Z="" F  S X=$O(^AUPNVXAM("AD",V,X)) Q:X'=+X!($P(Z,U,2))  I $P(^AUTTEXAM(+$G(^AUPNVXAM(X,0)),0),U,2)=35 D
 .S Y=$P(^AUPNVXAM(X,0),U,4)
 .S Z=1_U_$S(Y="PO":"1^EXAM 35",1:"0^EXAM 35")
 .Q
 I $P(Z,U),$P(Z,U,2) Q Z
 ;check measurements
 S X=0,Z="" F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X!($P(Z,U,2))  D
 .I $P(^AUTTMSR(+$G(^AUPNVMSR(X,0)),0),U,1)="AUDT" D  Q
 ..S Y=$P(^AUPNVMSR(X,0),U,4)
 ..S Z=1_U_$S(Y>7.99999:"1^MSR AUDT",1:"0^MSR AUDT")
 .I $P(^AUTTMSR(+$G(^AUPNVMSR(X,0)),0),U,1)="AUDC" D
 ..S Y=$P(^AUPNVMSR(X,0),U,4)
 ..I $P(^DPT(P,0),U,2)="M" S Z=1_U_$S(Y]""&(Y'<4):"1^MSR AUDC",1:"0^MSR AUDC")
 ..I $P(^DPT(P,0),U,2)="F" S Z=1_U_$S(Y]""&(Y'<3):"1^MSR AUDC",1:"0^MSR AUDC")
 .I $P(^AUTTMSR(+$G(^AUPNVMSR(X,0)),0),U,1)="CRFT" D  Q
 ..S Y=$P(^AUPNVMSR(X,0),U,4)
 ..S Z=1_U_$S(Y=2!(Y=3)!(Y=4)!(Y=5)!(Y=6):"1^MSR CRFT",1:"0^MSR CRFT")
 I $P(Z,U),$P(Z,U,2) Q Z
 S X=0 F  S X=$O(^AUPNVHF("AD",V,X)) Q:X'=+X!($P(Z,U,2))  I $P(^AUTTHF($P(^AUTTHF(+$G(^AUPNVHF(X,0)),0),U,3),0),U)["ALCOHOL" D
 .S Y=$P(^AUTTHF(+$G(^AUPNVHF(X,0)),0),U)
 .S A="" I Y["CAGE",Y'[0 S A=1
 .S Z=1_U_A_U_Y
 I Z]"",$P(Z,U,2) Q Z
 ;screening CPT
 S T=$O(^ATXAX("B","BGP ALCOHOL SCREENING CPTS",0))
 S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!($P(Z,U,2))  D
 .I $$ICD^ATXCHK($P(+$G(^AUPNVCPT(X,0)),U,1),T,1) D
 ..S Y=$$VAL^XBDIQ1(9000010.18,X,.01)
 ..S Z=1_U_U_"screening CPT "_Y
 ..I Y="G0396"!(Y="G0397")!(Y=99408)!(Y=99409) S $P(Z,U,2)=1
 .Q
 I Z]"" Q Z
 ;screening pov
 S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X!($P(Z,U,2))  I $P($$ICDDX^ICDCODE(+$G(^AUPNVPOV(X,0))),U,2)="V79.1" D
 .S Z=1_U_U_"screening POV V79.1"
 .Q
 Q Z
 ;
BNI(P,V,E) ;
 I $P(E,U,4)'=1 Q ""  ;not a positive screen
 NEW D,X,%
 S D=$P($P(^AUPNVSIT(V,0),U),"."),%=""
 S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X!(%]"")  I $P(^AUTTEDT(+$G(^AUPNVPED(X,0)),0),U,2)="AOD-INJ" S %=1_U_D_U_"AOD-INJ"_U_1
 I %]"" Q %
 S T=$O(^ATXAX("B","BGP BNI CPTS",0))
 S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(%]"")  D
 .Q:'$$ICD^ATXCHK($P(+$G(^AUPNVCPT(X,0)),U,1),T,1)
 .S %=1_U_D_U_"CPT-"_$$VAL^XBDIQ1(9000010.18,X,.01)_U_1
 I %]"" Q %
 S X=$$BNII(P,D)
 Q X
BNII(P,BD) ;
 NEW Y,BGPG,E,X,T,%,D
 S Y=$$CPT^BGP9DU(P,BD,$$FMADD^XLFDT(BD,7),$O(^ATXAX("B","BGP BNI CPTS",0)),6,"CT")
 I $P(Y,U) Q 1_U_$P(Y,U,2)_U_"CPT "_$P(Y,U,3)_U_2
 K BGPG
 S Y="BGPG(",BGPDEP=""
 S X=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT(BD)_"-"_$$FMTE^XLFDT($$FMADD^XLFDT(BD,7)) S E=$$START1^APCLDF(X,Y)
 I '$D(BGPG(1)) G BNIMH
 S (X,D,E)=0,%="",T="" F  S X=$O(BGPG(X)) Q:X'=+X  D  I %]"" Q
 .S V=$P(^AUPNVPED(+$P(BGPG(X),U,4),0),U,3)
 .Q:'V
 .Q:$P($G(^AUPNVSIT(V,0)),U,7)="C"
 .Q:$P($G(^AUPNVSIT(V,0)),U,7)="T"
 .S T=$P(^AUPNVPED(+$P(BGPG(X),U,4),0),U)
 .Q:'T
 .Q:'$D(^AUTTEDT(T,0))
 .S T=$P(^AUTTEDT(T,0),U,2)
 .I T="AOD-INJ" S %=1_U_$P(BGPG(X),U)_U_"AOD-INJ"_U_2
 .Q
 I %]"" Q %
BNIMH ;
 S T="",%="" S E=9999999-BD,D=9999999-($$FMADD^XLFDT(BD,7))-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(%]"")  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(%]"")  D
 .S Z=$P(^AMHREC(V,0),U,7) I Z S Z=$P(^AMHTSET(Z,0),U,2) Q:Z=1  Q:Z=10  Q:Z=7
 .S X=0,%="" F  S X=$O(^AMHREDU("AD",V,X)) Q:X'=+X!(%]"")  S T=$P($G(^AMHREDU(X,0)),U) D
 ..Q:'T
 ..Q:'$D(^AUTTEDT(T,0))
 ..S T=$P(^AUTTEDT(T,0),U,2)
 ..I T="AOD-INJ" S %=1_U_(9999999-D)_U_"AOD-INJ"_U_2 Q
 .S T=$O(^ATXAX("B","BGP BNI CPTS",0))
 .S X=0 F  S X=$O(^AMHRPROC("AD",V,X)) Q:X'=+X!(%]"")  D
 ..Q:'$$ICD^ATXCHK($P(+$G(^AMHRPROC(X,0)),U,1),T,1)
 ..S %=1_U_(9999999-D)_U_"BH CPT: "_$$VAL^XBDIQ1(9002011.04,X,.01)_U_2 Q
 ..Q
 Q %
IPC ;EP
 S (BGPN1,BGPN2,BGPN3,BGPN4)=0
 S BGPVALUE=""
 I 'BGPACTCL Q  ;not active clinical
 S BGPVAL=$$PCV(DFN,BGPBDATE,BGPEDATE)  ;return #visits^list string
 S BGPN1=$P(BGPVAL,U)
 I BGPAGEB<18 S BGPN2=BGPN1
 I BGPAGEB>17,BGPAGEB<55 S BGPN3=BGPN1
 I BGPAGEB>54 S BGPN4=BGPN1
 S BGPVALUE="AC|||"_BGPN1_$S(BGPN1'=1:" visits: ",1:" visit: ")_$P(BGPVAL,U,2)
 K BGPVAL
 Q
 ;
PCV(P,BDATE,EDATE) ;EP
 ;all dxs V66.7 and get unique visits count
 K BGPG
 S Y="BGPG("
 S X=P_"^ALL DX V66.7;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I '$D(BGPG(1)) Q 0  ;no visits
 NEW X,C,R
 S R="",C=0
 S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  I '$D(X($P(BGPG(X),U,5))) D
 .S X($P(BGPG(X),U,5))=""
 .S C=C+1
 .S R=R_$S(R="":"",1:"; ")_$$DATE^BGP9UTL($P($P(^AUPNVSIT($P(BGPG(X),U,5),0),U),"."))
 Q C_U_R
 ;
