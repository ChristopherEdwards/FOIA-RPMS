BGP0PDLL ; IHS/CMI/LAB - print ind 1 ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
 ;
I023 ;EP
I1AGE ;EP
 S BGPHD1="ACTIVE CLINICAL POPULATION",BGPHD2="Total Active Clinical"
 S X=^BGPINDT(BGPIC,53,1,0) D S(X,1,1) S X=" " D S(X,1,1) D H3 S X=" " D S(X,1,1)
 K BGPDAC,BGPDAP,BGPDAB S (C,D,E)=0 F BGPX="A","B","C","D","E","F" D I1AGE1,I1AGE2,I1AGE3
 D I1AGEP
 Q
I1AGE1 ;
 ;gather up all #'s
 S C=C+1
 S BGPF="G.F.1"_BGPX S BGPPC=$O(^BGPINDTC("C",BGPF,0))
 S BGPDF=$P(^BGPINDTC(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90377.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U)=$$V^BGP0DP1C(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U)=$$V^BGP0DP1C(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U)=$$V^BGP0DP1C(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPINDTC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90377.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,2)=$$V^BGP0DP1C(1,BGPRPT,N,P),$P(BGPDAC(C),U,3)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,2)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,2)=$$V^BGP0DP1C(2,BGPRPT,N,P),$P(BGPDAP(C),U,3)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,2)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,2)=$$V^BGP0DP1C(3,BGPRPT,N,P),$P(BGPDAB(C),U,3)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,2)/$P(BGPDAB(C),U)*100),1:"")
 Q
I1AGE2 ;
 S D=D+1
 S BGPF="G.G.1"_BGPX S BGPPC=$O(^BGPINDTC("C",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPINDTC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90377.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,4)=$$V^BGP0DP1C(1,BGPRPT,N,P),$P(BGPDAC(D),U,5)=$S($P(BGPDAC(D),U,1):($P(BGPDAC(D),U,4)/$P(BGPDAC(D),U,1)*100),1:"")
 S $P(BGPDAP(D),U,4)=$$V^BGP0DP1C(2,BGPRPT,N,P),$P(BGPDAP(D),U,5)=$S($P(BGPDAP(D),U,1):($P(BGPDAP(D),U,4)/$P(BGPDAP(D),U,1)*100),1:"")
 S $P(BGPDAB(D),U,4)=$$V^BGP0DP1C(3,BGPRPT,N,P),$P(BGPDAB(D),U,5)=$S($P(BGPDAB(D),U,1):($P(BGPDAB(D),U,4)/$P(BGPDAB(D),U,1)*100),1:"")
 Q
I1AGE3 ;
 S BGPF="G.H.1"_BGPX S BGPPC=$O(^BGPINDTC("C",BGPF,0))
 S E=E+1
 S BGPDF=$P(^BGPINDTC(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90377.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(E),U,6)=$$V^BGP0DP1C(1,BGPRPT,N,P)
 S $P(BGPDAP(E),U,6)=$$V^BGP0DP1C(2,BGPRPT,N,P)
 S $P(BGPDAB(E),U,6)=$$V^BGP0DP1C(3,BGPRPT,N,P)
 ;set 6th piece to numerator and 7th to %
 S BGPNF=$P(^BGPINDTC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90377.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(E),U,7)=$$V^BGP0DP1C(1,BGPRPT,N,P),$P(BGPDAC(E),U,8)=$S($P(BGPDAC(E),U,6):($P(BGPDAC(E),U,7)/$P(BGPDAC(E),U,6)*100),1:"")
 S $P(BGPDAP(E),U,7)=$$V^BGP0DP1C(2,BGPRPT,N,P),$P(BGPDAP(E),U,8)=$S($P(BGPDAP(E),U,6):($P(BGPDAP(E),U,7)/$P(BGPDAP(E),U,6)*100),1:"")
 S $P(BGPDAB(E),U,7)=$$V^BGP0DP1C(3,BGPRPT,N,P),$P(BGPDAB(E),U,8)=$S($P(BGPDAB(E),U,6):($P(BGPDAB(E),U,7)/$P(BGPDAB(E),U,6)*100),1:"")
 Q
 ;
I1AGEP ;
 S X="CURRENT REPORT PERIOD" D S(X,1,1) S X=" " D S(X,1,1)
 S X=BGPHD2 D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U) S Y=V D S(Y,,X+1)
 S X="# w/ alcohol screening/Dx/Proc-No Refusals or Pt Ed" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/ alcohol screening/Dx/Proc-No Refusals or Pt Ed" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,3) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# w/alcohol related education" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,4) S Y=V D S(Y,,X+1)
 S X="% w/alcohol related education" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,5) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 ;change demon and display
 S X=" " D S(X,1,2) S X="# Active Clinical w/ Alcohol Screening" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,6) S Y=V D S(Y,,X+1)
 S X="" D S(X,1,1)
 S X="# w/ positive alcohol screen" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,7) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X="% w/ positive alcohol screen" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,8) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
PR ;
 D S(" ",1,1)
 S X="PREVIOUS REPORT PERIOD" D S(X,1,1) S X=" " D S(X,1,1)
 S X=BGPHD2 D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U) S Y=V D S(Y,,X+1)
 S X="# w/ alcohol screening/Dx/Proc-No Refusals or Pt Ed" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/ alcohol screening/Dx/Proc-No Refusals or Pt Ed" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,3) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# w/alcohol related education" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,4) S Y=V D S(Y,,X+1)
 S X="% w/alcohol related education" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,5) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 ;change demon and display
 S X=" " D S(X,1,2) S X="# Active Clinical w/ Alcohol Screening" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,6) S Y=V D S(Y,,X+1)
 S X="" D S(X,1,1)
 S X="# w/ positive alcohol screen" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,7) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X="% w/ positive alcohol screen" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,8) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
PB ;
 ;percentage changes
 S X=" " D S(X,1,1) S X="CHANGE FROM PREV YR %" D S(X,1,1)
 S X="w/ alcohol screening/Dx/Proc-No Refusals or Pt Ed" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="w/alcohol related education" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="w/ positive alcohol screen" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,8),O=$P(BGPDAP(X),U,8) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
BL ;
 S X=^BGPINDT(BGPIC,53,1,0) D S(X,1,1) D H3
 S X=" " D S(X,1,1) S X="BASELINE REPORT PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U) S Y=V D S(Y,,X+1)
 S X="# w/ alcohol screening/Dx/Proc-No Refusals or Pt Ed" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/ alcohol screening/Dx/Proc-No Refusals or Pt Ed" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,3) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# w/alcohol related education" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,4) S Y=V D S(Y,,X+1)
 S X="% w/alcohol related education" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,5) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 ;change demon and display
 S X=" " D S(X,1,2) S X="# Active Clinical w/ Alcohol Screening" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,6) S Y=V D S(Y,,X+1)
 S X="" D S(X,1,1)
 S X="# w/ positive alcohol screen" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,7) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X="% w/ positive alcohol screen" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,8) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 ;percentage changes
 S X=" " D S(X,1,1) S X="CHANGE FROM BASE YR %" D S(X,1,1)
 S X="w/ alcohol screening/Dx/Proc-No Refusals or Pt Ed" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="w/alcohol related education" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="w/ positive alcohol screen" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,8),O=$P(BGPDAB(X),U,8) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 Q
SETN ;set numerator fields
 S BGPCYN=$$V^BGP9DP1C(1,BGPRPT,N,P)
 S BGPPRN=$$V^BGP9DP1C(2,BGPRPT,N,P)
 S BGPBLN=$$V^BGP9DP1C(3,BGPRPT,N,P)
 S BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGPBLP=$S(BGPBLD:((BGPBLN/BGPBLD)*100),1:"")
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 NEW X
 I T=1 S X=$P($G(^BGPGPDCN(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=2 S X=$P($G(^BGPGPDPN(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=3 S X=$P($G(^BGPGPDBN(R,N)),U,P) Q $S(X]"":X,1:0)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPGPDCN(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPGPDPN(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPGPDBN(X,N)),U,P)
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
CALC(N,O) ;
 NEW Z
 ;I O=0!(N=0)!(O="")!(N="") Q "**"
 ;NEW X,X2,X3
 ;S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 ;S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 ;I +O=0 Q "**"
 ;S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 S Z=N-O,Z=$FN(Z,"+,",1)
 Q Z
H3 ;EP
 ;S X="Age specific Tobacco Use" D S(X,1,1) S Y=" " D S(Y,1,1) S X=BGPHD1 D S(X,1,1) S Y=" " D S(Y,1,1)
 S X="Age Distribution" D S(X,1,1) S X=" " D S(X,1,1)
 S Y=" 12-19" D S(Y,1,2)
 S Y="20-24" D S(Y,,3)
 S Y="25-34" D S(Y,,4)
 S Y="35-44" D S(Y,,5)
 S Y="45-54" D S(Y,,6)
 S Y="55-75" D S(Y,,7)
 Q
SB(X) ;EP - Strip leading and trailing blanks from X.
 X ^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 Q X
H2 ;
 S BGPX="",BGPX=BGPCYN,$P(BGPX,U,2)=$$SB($J(BGPCYP,5,1)),$P(BGPX,U,3)=BGPPRN,$P(BGPX,U,4)=$$SB($J(BGPPRP,5,1)),$P(BGPX,U,5)=$$SB($J($$CALC(BGPCYP,BGPPRP),6)),$P(BGPX,U,6)=BGPBLN,$P(BGPX,U,7)=$$SB($J(BGPBLP,5,1))
 S $P(BGPX,U,8)=$$SB($J($$CALC(BGPCYP,BGPBLP),6))
 D S(BGPX,,2)
 Q
H1 ;EP
 S Y="REPORT" D S(Y,1,2)
 S Y="%" D S(Y,,3)
 S Y="PREV YR" D S(Y,,4)
 S Y="%" D S(Y,,5)
 S Y="CHG from" D S(Y,,6)
 S Y="BASE" D S(Y,,7)
 S Y="%" D S(Y,,8)
 S Y="CHG from" D S(Y,,9)
 S Y="PERIOD" D S(Y,1,2)
 S Y="PERIOD" D S(Y,,4)
 S Y="PREV YR %" D S(Y,,6)
 S Y="PERIOD" D S(Y,,7)
 S Y="BASE %" D S(Y,,9)
 Q
