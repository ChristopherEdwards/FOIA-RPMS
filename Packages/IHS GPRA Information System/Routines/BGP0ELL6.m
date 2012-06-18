BGP0ELL6 ; IHS/CMI/LAB - print ind ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
 ;
I1AGE ;EP
 S BGPHD1="ACTIVE DIABETIC PATIENTS =>55",BGPHD2="Active Diabetic Patients"
 S X=" " D S(X,1,1) D H3^BGP0ELL2 S X=" " D S(X,1,1)
 K BGPDAC,BGPDAP,BGPDAB S (C,D,E,F,G,H,I,J,K)=0 F BGPX="NPB.5","NPB.6","NPB.7","NPB.8" D I1AGE1
 D I1AGEP
 Q
I1AGE1 ;
 S C=C+1
 S BGPF="ELD."_BGPX S BGPPC=$O(^BGPELIIT("C",BGPF,0))
 S BGPDF=$P(^BGPELIIT(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90379.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U)=$$V(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U)=$$V(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U)=$$V(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPELIIT(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90379.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,2)=$$V(1,BGPRPT,N,P),$P(BGPDAC(C),U,3)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,2)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,2)=$$V(2,BGPRPT,N,P),$P(BGPDAP(C),U,3)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,2)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,2)=$$V(3,BGPRPT,N,P),$P(BGPDAB(C),U,3)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,2)/$P(BGPDAB(C),U)*100),1:"")
 Q
I1AGEP ;
 S X=" " D S(X,1,1)
 S X="CURRENT REPORT PERIOD" D S(X,1,1) S X=" " D S(X,1,1)
 S X=BGPHD2 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAC(X),U) S Y=V D S(Y,,X+1)
 S X="# w/ est GFR & quant UP assmt or w/ ESRD (GPRA)" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAC(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/ est GFR & quant UP assmt or w/ ESRD (GPRA)" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAC(X),U,3) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
PR ; 
 S X=" " D S(X,1,1) S X="PREVIOUS YEAR PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAP(X),U) S Y=V D S(Y,,X+1)
 S X="# w/ est GFR & quant UP assmt or w/ ESRD (GPRA)" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAP(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/ est GFR & quant UP assmt or w/ ESRD (GPRA)" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAP(X),U,3) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 ;percentage changes
 S X=" " D S(X,1,1) S X="CHANGE FROM PREV YR %" D S(X,1,1)
 S X="# w/ est GFR & quant UP assmt or w/ ESRD (GPRA)" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) S Y=$$SB^BGP0ELL2($J((N-O),6,1)) D S(Y,,X+1)
BL ;
 S X=" " D S(X,1,1) S X="BASELINE REPORT PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U) S Y=V D S(Y,,X+1)
 S X="# w/ est GFR & quant UP assmt or w/ ESRD (GPRA)" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/ est GFR & quant UP assmt or w/ ESRD (GPRA)" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,3) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 ;percentage changes
 S X=" " D S(X,1,1) S X="CHANGE FROM BASE YR %" D S(X,1,1)
 S X="# w/ est GFR & quant UP assmt or w/ ESRD (GPRA)" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) S Y=$$SB^BGP0ELL2($J((N-O),6,1)) D S(Y,,X+1)
 Q
SETN ;set numerator fields
 S BGPCYN=$$V(1,BGPRPT,N,P)
 S BGPPRN=$$V(2,BGPRPT,N,P)
 S BGPBLN=$$V(3,BGPRPT,N,P)
 S BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGPBLP=$S(BGPBLD:((BGPBLN/BGPBLD)*100),1:"")
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 NEW X
 I T=1 S X=$P($G(^BGPELDCT(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=2 S X=$P($G(^BGPELDPT(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=3 S X=$P($G(^BGPELDBT(R,N)),U,P) Q $S(X]"":X,1:0)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPELDCT(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPELDPT(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPELDBT(X,N)),U,P)
 .Q
 Q $S(C:C,1:0)
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
S(Y,F,P) ;set up array
 I '$G(F) S F=0
 S %=$P(^TMP($J,"BGPDEL",0),U)+F,$P(^TMP($J,"BGPDEL",0),U)=%
 I '$D(^TMP($J,"BGPDEL",%)) S ^TMP($J,"BGPDEL",%)=""
 S $P(^TMP($J,"BGPDEL",%),U,P)=Y
 Q
