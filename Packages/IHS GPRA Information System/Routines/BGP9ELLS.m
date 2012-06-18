BGP9ELLS ; IHS/CMI/LAB - print ind 01 Jul 2008 7:56 PM ; 
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
I1AGE ;EP
 S BGPHD1="ACTIVE CLINICAL PTS 65+",BGPHD2="# Active Clinical Pts 65+"
 S X=" " D S(X,1,1) D H3 S X=" " D S(X,1,1)
 K BGPDAC,BGPDAP,BGPDAB
 S (C,D,E,F,G,H,I,J,K)=0 S BGPX="D",C=0 F BGPZZZ=1,2,3 D
 .S BGPZ=BGPZZZ D I1AGE1
 .S BGPP=4,BGPP1=5,BGPZ=BGPZZZ+3 D I1AGE2
 .S BGPP=6,BGPP1=7,BGPZ=BGPZZZ+6 D I1AGE2
 .S BGPP=8,BGPP1=9,BGPZ=BGPZZZ+9 D I1AGE2
 .S BGPP=10,BGPP1=11,BGPZ=BGPZZZ+12 D I1AGE2
 .S BGPP=12,BGPP1=13,BGPZ=BGPZZZ+15 D I1AGE2
 .S BGPP=14,BGPP1=15,BGPZ=BGPZZZ+18 D I1AGE2
 .S BGPP=16,BGPP1=17,BGPZ=BGPZZZ+21 D I1AGE2
 .S BGPP=18,BGPP1=19,BGPZ=BGPZZZ+24 D I1AGE2
 .S BGPP=20,BGPP1=21,BGPZ=BGPZZZ+27 D I1AGE2
 .S BGPP=22,BGPP1=23,BGPZ=BGPZZZ+30 D I1AGE2
 .S BGPP=24,BGPP1=25,BGPZ=BGPZZZ+33 D I1AGE2
 .S BGPP=26,BGPP1=27,BGPZ=BGPZZZ+36 D I1AGE2
 .S BGPP=28,BGPP1=29,BGPZ=BGPZZZ+39 D I1AGE2
 .S BGPP=30,BGPP1=31,BGPZ=BGPZZZ+42 D I1AGE2
 .S BGPP=32,BGPP1=33,BGPZ=BGPZZZ+45 D I1AGE2
 .S BGPP=34,BGPP1=35,BGPZ=BGPZZZ+48 D I1AGE2
 .S BGPP=36,BGPP1=37,BGPZ=BGPZZZ+51 D I1AGE2
 .S BGPP=38,BGPP1=39,BGPZ=BGPZZZ+54 D I1AGE2
 .S BGPP=40,BGPP1=41,BGPZ=BGPZZZ+57 D I1AGE3
 D I1AGEP
 ;MALE
 S BGPHD1="MALE ACTIVE CLINICAL PTS 65+",BGPHD2="# Male Active Clinical Pts 65+"
 S X=" " D S(X,1,1) D H3 S X=" " D S(X,1,1)
 K BGPDAC,BGPDAP,BGPDAB
 S (C,D,E,F,G,H,I,J,K)=0 S BGPX="E",C=0 F BGPZZZ=1,2,3 D
 .S BGPZ=BGPZZZ D I1AGE1
 .S BGPP=4,BGPP1=5,BGPZ=BGPZZZ+3 D I1AGE2
 .S BGPP=6,BGPP1=7,BGPZ=BGPZZZ+6 D I1AGE2
 .S BGPP=8,BGPP1=9,BGPZ=BGPZZZ+9 D I1AGE2
 .S BGPP=10,BGPP1=11,BGPZ=BGPZZZ+12 D I1AGE2
 .S BGPP=12,BGPP1=13,BGPZ=BGPZZZ+15 D I1AGE2
 .S BGPP=14,BGPP1=15,BGPZ=BGPZZZ+18 D I1AGE2
 .S BGPP=16,BGPP1=17,BGPZ=BGPZZZ+21 D I1AGE2
 .S BGPP=18,BGPP1=19,BGPZ=BGPZZZ+24 D I1AGE2
 .S BGPP=20,BGPP1=21,BGPZ=BGPZZZ+27 D I1AGE2
 .S BGPP=22,BGPP1=23,BGPZ=BGPZZZ+30 D I1AGE2
 .S BGPP=24,BGPP1=25,BGPZ=BGPZZZ+33 D I1AGE2
 .S BGPP=26,BGPP1=27,BGPZ=BGPZZZ+36 D I1AGE2
 .S BGPP=28,BGPP1=29,BGPZ=BGPZZZ+39 D I1AGE2
 .S BGPP=30,BGPP1=31,BGPZ=BGPZZZ+42 D I1AGE2
 .S BGPP=32,BGPP1=33,BGPZ=BGPZZZ+45 D I1AGE2
 .S BGPP=34,BGPP1=35,BGPZ=BGPZZZ+48 D I1AGE2
 .S BGPP=36,BGPP1=37,BGPZ=BGPZZZ+51 D I1AGE2
 .S BGPP=38,BGPP1=39,BGPZ=BGPZZZ+54 D I1AGE2
 .S BGPP=40,BGPP1=41,BGPZ=BGPZZZ+57 D I1AGE3
 D I1AGEP
 ;FEMALE
 S BGPHD1="FEMALE ACTIVE CLINICAL PTS 65+",BGPHD2="# Female Active Clinical Pts 65+"
 S X=" " D S(X,1,1) D H3 S X=" " D S(X,1,1)
 K BGPDAC,BGPDAP,BGPDAB
 S (C,D,E,F,G,H,I,J,K)=0 S BGPX="F",C=0 F BGPZZZ=1,2,3 D
 .S BGPZ=BGPZZZ D I1AGE1
 .S BGPP=4,BGPP1=5,BGPZ=BGPZZZ+3 D I1AGE2
 .S BGPP=6,BGPP1=7,BGPZ=BGPZZZ+6 D I1AGE2
 .S BGPP=8,BGPP1=9,BGPZ=BGPZZZ+9 D I1AGE2
 .S BGPP=10,BGPP1=11,BGPZ=BGPZZZ+12 D I1AGE2
 .S BGPP=12,BGPP1=13,BGPZ=BGPZZZ+15 D I1AGE2
 .S BGPP=14,BGPP1=15,BGPZ=BGPZZZ+18 D I1AGE2
 .S BGPP=16,BGPP1=17,BGPZ=BGPZZZ+21 D I1AGE2
 .S BGPP=18,BGPP1=19,BGPZ=BGPZZZ+24 D I1AGE2
 .S BGPP=20,BGPP1=21,BGPZ=BGPZZZ+27 D I1AGE2
 .S BGPP=22,BGPP1=23,BGPZ=BGPZZZ+30 D I1AGE2
 .S BGPP=24,BGPP1=25,BGPZ=BGPZZZ+33 D I1AGE2
 .S BGPP=26,BGPP1=27,BGPZ=BGPZZZ+36 D I1AGE2
 .S BGPP=28,BGPP1=29,BGPZ=BGPZZZ+39 D I1AGE2
 .S BGPP=30,BGPP1=31,BGPZ=BGPZZZ+42 D I1AGE2
 .S BGPP=32,BGPP1=33,BGPZ=BGPZZZ+45 D I1AGE2
 .S BGPP=34,BGPP1=35,BGPZ=BGPZZZ+48 D I1AGE2
 .S BGPP=36,BGPP1=37,BGPZ=BGPZZZ+51 D I1AGE2
 .S BGPP=38,BGPP1=39,BGPZ=BGPZZZ+54 D I1AGE2
 .S BGPP=40,BGPP1=41,BGPZ=BGPZZZ+57 D I1AGE3
 D I1AGEP
 Q
I1AGE1 ;
 S C=C+1
 S BGPF="EDA."_BGPX_"."_BGPZ S BGPPC=$O(^BGPELIIN("C",BGPF,0))
 S BGPDF=$P(^BGPELIIN(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90538.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U)=$$V(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U)=$$V(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U)=$$V(3,BGPRPT,N,P)
 ;
 S BGPNF=$P(^BGPELIIN(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90538.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,2)=$$V(1,BGPRPT,N,P),$P(BGPDAC(C),U,3)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,2)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,2)=$$V(2,BGPRPT,N,P),$P(BGPDAP(C),U,3)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,2)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,2)=$$V(3,BGPRPT,N,P),$P(BGPDAB(C),U,3)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,2)/$P(BGPDAB(C),U)*100),1:"")
 Q
I1AGE2 ;
 ;S D=D+1
 S BGPF="EDA."_BGPX_"."_BGPZ S BGPPC=$O(^BGPELIIN("C",BGPF,0))
 ;
 S BGPNF=$P(^BGPELIIN(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90538.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,BGPP)=$$V(1,BGPRPT,N,P),$P(BGPDAC(C),U,BGPP1)=$S($P(BGPDAC(C),U,2):($P(BGPDAC(C),U,BGPP)/$P(BGPDAC(C),U,2)*100),1:"")
 S $P(BGPDAP(C),U,BGPP)=$$V(2,BGPRPT,N,P),$P(BGPDAP(C),U,BGPP1)=$S($P(BGPDAP(C),U,2):($P(BGPDAP(C),U,BGPP)/$P(BGPDAP(C),U,2)*100),1:"")
 S $P(BGPDAB(C),U,BGPP)=$$V(3,BGPRPT,N,P),$P(BGPDAB(C),U,BGPP1)=$S($P(BGPDAB(C),U,2):($P(BGPDAB(C),U,BGPP)/$P(BGPDAB(C),U,2)*100),1:"")
 Q
I1AGE3 ;
 ;S D=D+1
 S BGPF="EDA."_BGPX_"."_BGPZ S BGPPC=$O(^BGPELIIN("C",BGPF,0))
 ;
 S BGPNF=$P(^BGPELIIN(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90538.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,BGPP)=$$V(1,BGPRPT,N,P),$P(BGPDAC(C),U,BGPP1)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,BGPP)/$P(BGPDAC(C),U,1)*100),1:"")
 S $P(BGPDAP(C),U,BGPP)=$$V(2,BGPRPT,N,P),$P(BGPDAP(C),U,BGPP1)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,BGPP)/$P(BGPDAP(C),U,1)*100),1:"")
 S $P(BGPDAB(C),U,BGPP)=$$V(3,BGPRPT,N,P),$P(BGPDAB(C),U,BGPP1)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,BGPP)/$P(BGPDAB(C),U,1)*100),1:"")
 Q
I1AGEP ;
 S X=" " D S(X,1,1)
 S X="CURRENT REPORT PERIOD" D S(X,1,1) S X=" " D S(X,1,1)
 S X=BGPHD2 D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U) S Y=V D S(Y,,X+1)
 S X="# w/exposure to at least 1 harmful drug" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/exposure to at least 1 harmful drug" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,3) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="A. # w/antianxiety Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,4) S Y=V D S(Y,,X+1)
 S X="% A. w/antianxiety Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,5) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="B. # w/antiemetic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,6) S Y=V D S(Y,,X+1)
 S X="% B. w/antiemetic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,7) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="C. # w/analgesic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,8) S Y=V D S(Y,,X+1)
 S X="% C. w/analgesic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,9) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="D. # w/antihistamine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,10) S Y=V D S(Y,,X+1)
 S X="% D. w/antihistamine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,11) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="E. # w/antipsychotic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,12) S Y=V D S(Y,,X+1)
 S X="% E. w/antipsychotic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,13) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="F. # w/amphetamine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,14) S Y=V D S(Y,,X+1)
 S X="% F. w/amphetamine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,15) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="G. # w/barbiturate Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,16) S Y=V D S(Y,,X+1)
 S X="% G. w/barbiturate Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,17) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="H. # w/benzodiazepine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,18) S Y=V D S(Y,,X+1)
 S X="% H. w/benzodiazepine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,19) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="I. # w/other benzodiazepine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,20) S Y=V D S(Y,,X+1)
 S X="% I. w/other benzodiazepine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,21) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="J. # w/calcium channel blocker Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,22) S Y=V D S(Y,,X+1)
 S X="% J. w/calcium channel blocker Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,23) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="K. # w/gastro antispasmodic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,24) S Y=V D S(Y,,X+1)
 S X="% K. w/gastro antispasmodic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,25) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="L. # w/belladonna alkaloid Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,26) S Y=V D S(Y,,X+1)
 S X="% L. w/belladonna alkaloid Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,27) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="M. # w/skeletal muscle relaxant Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,28) S Y=V D S(Y,,X+1)
 S X="% M. w/skeletal muscle relaxant Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,29) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="N. # w/oral estrogen Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,30) S Y=V D S(Y,,X+1)
 S X="% N. w/oral estrogen Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,31) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="O. # w/oral hypoglycemic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,32) S Y=V D S(Y,,X+1)
 S X="% O. w/oral hypoglycemic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,33) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="P. # w/narcotic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,34) S Y=V D S(Y,,X+1)
 S X="% P. w/narcotic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,35) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="Q. # w/vasodilator Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,36) S Y=V D S(Y,,X+1)
 S X="% Q. w/vasodilator Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,37) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="R. # w/other avoid meds Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,38) S Y=V D S(Y,,X+1)
 S X="% R. w/other avoid meds Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,39) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# w/ exposure to multiple harmful drugs" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,40) S Y=V D S(Y,,X+1)
 S X="% w/ exposure to multiple harmful drugs" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAC(X),U,41) S Y=$$SB^BGP9ELL2($J(V,6,1)) D S(Y,,X+1)
 D I1AGEP^BGP9ELLT
 Q
S(Y,F,P) ;set up array
 I '$G(F) S F=0
 S %=$P(^TMP($J,"BGPDEL",0),U)+F,$P(^TMP($J,"BGPDEL",0),U)=%
 I '$D(^TMP($J,"BGPDEL",%)) S ^TMP($J,"BGPDEL",%)=""
 S $P(^TMP($J,"BGPDEL",%),U,P)=Y
 Q
CALC(N,O) ;
 NEW Z
 S Z=N-O,Z=$FN(Z,"+,",1)
 Q Z
H3 ;EP
 S X="Drugs to be Avoided in the Elderly" D S(X,1,1) S Y=" " D S(Y,1,1) S X=BGPHD1 D S(X,1,1) S Y=" " D S(Y,1,1)
 S X="Age Distribution" D S(X,1,1) S X=" " D S(X,1,1)
 S Y="65-74" D S(Y,1,2)
 S Y="75-84" D S(Y,,3)
 S Y=">84 yrs" D S(Y,,4)
 Q
SB(X) ;EP
 X ^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 Q X
H2 ;
 S BGPX="",BGPX=BGPCYN
 S $P(BGPX,U,2)=$$SB^BGP9ELL2($J(BGPCYP,5,1)),$P(BGPX,U,3)=BGPPRN,$P(BGPX,U,4)=$$SB^BGP9ELL2($J(BGPPRP,5,1)),$P(BGPX,U,5)=$$SB^BGP9ELL2($J($$CALC(BGPCYP,BGPPRP),6)),$P(BGPX,U,6)=BGPBLN,$P(BGPX,U,7)=$$SB^BGP9ELL2($J(BGPBLP,5,1))
 S $P(BGPX,U,8)=$$SB^BGP9ELL2($J($$CALC(BGPCYP,BGPBLP),6))
 D S(BGPX,,2)
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 NEW X
 I T=1 S X=$P($G(^BGPELDCN(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=2 S X=$P($G(^BGPELDPN(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=3 S X=$P($G(^BGPELDBN(R,N)),U,P) Q $S(X]"":X,1:0)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPELDCN(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPELDPN(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPELDBN(X,N)),U,P)
 .Q
 Q $S(C:C,1:0)
C(X,X2,X3) ;
 NEW A,B,C,D,E,F,G,H,I,J,K
 D COMMA^%DTC
 Q X
