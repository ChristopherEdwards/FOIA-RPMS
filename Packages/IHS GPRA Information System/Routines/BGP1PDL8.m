BGP1PDL8 ; IHS/CMI/LAB - print ind 1 ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
I1AGEP ;EP
 S X="CURRENT REPORT PERIOD" D S(X,1,1) S X=" " D S(X,1,1)
 S X=BGPHD2 D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U) S Y=V D S(Y,,X+1)
 S X="# w/Tobacco Screening" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/Tobacco Screening" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,3) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# Tobacco Users" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,4) S Y=V D S(Y,,X+1)
 S X="% Tobacco Users w/ % of Total Screened" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,5) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# Smokers" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,6) S Y=V D S(Y,,X+1)
 S X="% Smokers w/ % of Total Tobacco Users" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,7) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# Smokeless" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,8) S Y=V D S(Y,,X+1)
 S X="% Smokeless w/ % of Total Tobacco Users" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,9) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 ;S X="# Tobacco Users receiving" D S(X,1,1) S X="Cessation Counseling" D S(X,1,1)
 ;F X=1:1:6 S V=$P(BGPDAC(X),U,10) S Y=V D S(Y,,X+1)
 ;S X=" " D S(X,1,1) S X="% Tobacco Users w/ % of Total Screened receiving" D S(X,1,1) S X="Cessation Counseling" D S(X,1,1)
 ;F X=1:1:6 S V=$P(BGPDAC(X),U,11) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# ETS/Smk Home" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,12) S Y=V D S(Y,,X+1)
 S X="% ETS/Smk Home w/ % of Total Screened" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAC(X),U,13) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
PR ; 
 ;S X=^BGPINDB(BGPIC,53,1,0) D S(X,1,1)
 S X=" " D S(X,2,1)
 ;D H3
 S X=" " D S(X,1,1) S X="PREVIOUS YEAR PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U) S Y=V D S(Y,,X+1)
 S X="# w/Tobacco Screening" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/Tobacco Screening" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,3) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# Tobacco Users" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,4) S Y=V D S(Y,,X+1)
 S X="% Tobacco Users w/ % of Total Screened" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,5) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# Smokers" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,6) S Y=V D S(Y,,X+1)
 S X="% Smokers w/ % of Total Tobacco Users" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,7) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# Smokeless" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,8) S Y=V D S(Y,,X+1)
 S X="% Smokeless w/ % of Total Tobacco Users" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,9) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 ;S X="# Tobacco Users receiving" D S(X,1,1) S X="Cessation Counseling" D S(X,1,1)
 ;F X=1:1:6 S V=$P(BGPDAP(X),U,10) S Y=V D S(Y,,X+1)
 ;S X=" " D S(X,1,1) S X="% Tobacco Users w/ % of Total Screened receiving" D S(X,1,1) S X="Cessation Counseling" D S(X,1,1)
 ;F X=1:1:6 S V=$P(BGPDAP(X),U,11) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1)
 S X="# ETS/Smk Home" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,12) S Y=V D S(Y,,X+1)
 S X="% ETS/Smk Home w/ % of Total Screened" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAP(X),U,13) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
PB ;
 ;percentage changes
 S X=" " D S(X,1,1) S X="CHANGE FROM PREV YR %" D S(X,1,1)
 S X="w/Tobacco Screening" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="Tobacco Users" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="Smokers" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAP(X),U,7) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="Smokeless" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAP(X),U,9) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 ;S X="Tobacco Users receiving" D S(X,1,1) S X="Cessation Counseling" D S(X,1,1)
 ;F X=1:1:6 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAP(X),U,11) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="ETS" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,13),O=$P(BGPDAP(X),U,13) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
BL ;
 ;S X=^BGPINDB(BGPIC,53,1,0) D S(X,1,1) D H3
 S X=" " D S(X,1,1) S X="BASELINE REPORT PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U) S Y=V D S(Y,,X+1)
 S X="# w/Tobacco Screening" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/Tobacco Screening" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,3) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# Tobacco Users" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,4) S Y=V D S(Y,,X+1)
 S X="% Tobacco Users w/ % of Total Screened" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,5) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# Smokers" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,6) S Y=V D S(Y,,X+1)
 S X="% Smokers w/ % of Total Tobacco Users" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,7) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# Smokeless" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,8) S Y=V D S(Y,,X+1)
 S X="% Smokeless w/ % of Total Tobacco Users" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,9) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 ;S X="# Tobacco Users receiving" D S(X,1,1) S X="Cessation Counseling" D S(X,1,1)
 ;F X=1:1:6 S V=$P(BGPDAB(X),U,10) S Y=V D S(Y,,X+1)
 ;S X=" " D S(X,1,1) S X="% Tobacco Users w/ % of Total Screened w/ % of Total Screened receiving" D S(X,1,1) S X="Cessation Counseling" D S(X,1,1)
 ;F X=1:1:6 S V=$P(BGPDAB(X),U,11) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# ETS/Smk Home" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,12) S Y=V D S(Y,,X+1)
 S X="% ETS/Smk Home w/ % of Total Screened" D S(X,1,1)
 F X=1:1:6 S V=$P(BGPDAB(X),U,13) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
BP ;
 ;percentage changes
 S X=" " D S(X,1,1) S X="CHANGE FROM BASE YR %" D S(X,1,1)
 S X="w/Tobacco Screening" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="Tobacco Users" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="Smokers" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAB(X),U,7) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="Smokeless" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAB(X),U,9) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 ;S X="Tobacco Users receiving" D S(X,1,1) S X="Cessation Counseling" D S(X,1,1)
 ;F X=1:1:6 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAB(X),U,11) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="ETS" D S(X,1,1)
 F X=1:1:6 S N=$P(BGPDAC(X),U,13),O=$P(BGPDAB(X),U,13) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 Q
SETN ;set numerator fields
 S BGPCYN=$$V^BGP1DP1C(1,BGPRPT,N,P)
 S BGPPRN=$$V^BGP1DP1C(2,BGPRPT,N,P)
 S BGPBLN=$$V^BGP1DP1C(3,BGPRPT,N,P)
 S BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGPBLP=$S(BGPBLD:((BGPBLN/BGPBLD)*100),1:"")
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 NEW X
 I T=1 S X=$P($G(^BGPGPDCB(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=2 S X=$P($G(^BGPGPDPB(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=3 S X=$P($G(^BGPGPDBB(R,N)),U,P) Q $S(X]"":X,1:0)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPGPDCB(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPGPDPB(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPGPDBB(X,N)),U,P)
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
 S Y=" 5-13" D S(Y,1,2)
 S Y="14-17" D S(Y,,3)
 S Y="18-24" D S(Y,,4)
 S Y="25-44" D S(Y,,5)
 S Y="45-64" D S(Y,,6)
 S Y="65 AND OLDER" D S(Y,,7)
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
