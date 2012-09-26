BGP2ELL1 ; IHS/CMI/LAB - print ind 1 ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
I1 ;EP
 D H1
I1A1 ;001.A, 001.B, 001.C
 F BGPPC1="1.1","1.2","1.3" D PI
 D I1AGE^BGP2ELL2
 Q
I2 ;EP
 D H1
 F BGPPC1="2.1" D PI
 D I1AGE^BGP2ELL3
 Q
I3 ;EP
 D H1
 F BGPPC1="3.1" D PI
 D I1AGE^BGP2ELL4
 Q
I4 ;
 D H1
 F BGPPC1="4.1" D PI
 D I1AGE^BGP2ELL5
 Q
I5 ;EP
 D H1
 F BGPPC1="5.1" D PI
 D I1AGE^BGP2ELL6
 Q
I6 ;EP
 D H1
 F BGPPC1="6.1" D PI
 D I1AGE^BGP2ELL7
 Q
I7 ;EP
 D H1
 F BGPPC1="7.1" D PI
 D I1AGE^BGP2ELL8
 Q
I8 ;EP
 D H1
 F BGPPC1="8.1" D PI
 D I1AGE^BGP2ELL9
 Q
I9 ;EP
 D H1
 F BGPPC1="9.1" D PI
 D I1AGE^BGP2ELLA
 Q
I10 ;EP
 D H1
 F BGPPC1="10.1" D PI
 D I1AGE^BGP2ELLB
 Q
I11 ;EP
 D H1
 F BGPPC1="11.1" D PI
 D I1AGE^BGP2ELLC
 Q
I12 ;EP
 D H1
 F BGPPC1="12.1","12.2","12.3" D PI
 D I1AGE^BGP2ELLD
 Q
I13 ;EP
 D H1
 F BGPPC1="13.1","13.2","13.3" D PI
 D I1AGE^BGP2ELLE
 Q
I14 ;EP
 D H1
 F BGPPC1="14.1" D PI
 D I1AGE^BGP2ELLF
 Q
I15 ;EP
 D H1
 F BGPPC1="15.1","15.2","15.3" D PI
 D I1AGE^BGP2ELLG
 Q
I16 ;EP
 D H1
 F BGPPC1="16.1","16.2","16.3" D PI
 D I1AGE^BGP2ELLH
 Q
I17 ;EP
 D H1
 F BGPPC1="17.1","17.2","17.3" D PI
 D I1AGE^BGP2ELLI
 Q
I18 ;EP
 D H1
 F BGPPC1="18.1","18.2","18.3" D PI
 D I1AGE^BGP2ELLJ
 Q
I19 ;EP
 D H1
 F BGPPC1="19.1" D PI
 D I1AGE^BGP2ELLK
 Q
EFR ;EP
 D H1
 S BGPPC0=$P(^BGPELIW(BGPIC,0),U,6)
 F BGPPCX=1,2,3 S BGPPC1=BGPPC0_"."_BGPPCX D PI
 D I1AGE^BGP2ELLR
 Q
IEDA ;EP
 D H1
 S BGPPC0=$P(^BGPELIW(BGPIC,0),U,6)
 F BGPPCX=1,2,3 S BGPPC1=BGPPC0_"."_BGPPCX D PI
 D I1AGE^BGP2ELLS
 Q
IELDFSA ;EP
 D H1
 F BGPPC1="22.1","22.2","22.3" D PI
 D I1AGE^BGP2ELLL
 Q
IELDASA ;EP
 D H1
 F BGPPC1="23.1" D PI
 S BGPNODEN=1 S BGPPC1="23.2" D PI K BGPNODEN
 D I1AGE^BGP2ELLM
 Q
IELDPHA ;EP
 D IELDPHA^BGP2ELLN
 Q
IRAO ;EP
 D H1
 F BGPPC1="20.1" D PI
 D I1AGE^BGP2ELLO
 Q
IRAA ;EP
 D H1
 F BGPPC1="21.1" D PI
 D I1AGE^BGP2ELLP
 Q
PCV ;EP
 D H1
 S BGPNODEN=1 F BGPPC9=1:1:30 S BGPPC1="27."_BGPPC9  S BGPNODEN=1 D PI K BGPNODEN
 K BGPNODEN
 F BGPPC9=31:1:33 S BGPPC1="27."_BGPPC9 D PI
 D I1AGE^BGP2ELLW
 Q
AWV ;EP
 D H1
 F BGPPC9=1:1:3 S BGPPC1="28."_BGPPC9 D PI
 D I1AGE^BGP2ELLX
 Q
PI ;EP
 S BGPDENP=0
 S BGPPC2=0 F  S BGPPC2=$O(^BGPELIIW("ABC",BGPPC1,BGPPC2)) Q:BGPPC2=""  S BGPPC=$O(^BGPELIIW("ABC",BGPPC1,BGPPC2,0)) D PI1
 ;S BGPPC2=0 F  S BGPPC2=$O(^BGPELIIW("AB",BGPPC1,BGPPC2)) Q:BGPPC2=""  S BGPPC=$O(^BGPELIIW("AB",BGPPC1,BGPPC2,0)) D PI1
 Q
PI1 ;
 S BGPDF=$P(^BGPELIIW(BGPPC,0),U,8)
 ;get denominator value of measure
 S BGPNP=$P(^DD(90549.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S BGPCYD=$$V(1,BGPRPT,N,P)
 S BGPPRD=$$V(2,BGPRPT,N,P)
 S BGPBLD=$$V(3,BGPRPT,N,P)
 ;write out denominator
 I 'BGPDENP S Y=" " D S(Y,1,1) D
 .Q:$G(BGPNODEN)
 .S Y=$P(^BGPELIIW(BGPPC,0),U,17) D S(Y,1,1)
 .I $P(^BGPELIIW(BGPPC,0),U,18)]"" D
 ..D S($P(^BGPELIIW(BGPPC,0),U,18),1,1)
 .I $P(^BGPELIIW(BGPPC,0),U,21)]"" D
 ..D S($P(^BGPELIIW(BGPPC,0),U,21),1,1)
 .S Y=BGPCYD_"^^"_BGPPRD_"^^^"_BGPBLD D S(Y,,2)
 .I BGPPC2'=12.1 S BGPDENP=1
  S BGPNF=$P(^BGPELIIW(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90549.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 D SETN
 ;write header for 1.A.1
 S Y=" " D S(Y,1,1)
 S Y=$P(^BGPELIIW(BGPPC,0),U,15) D S(Y,1,1)
 I $P(^BGPELIIW(BGPPC,0),U,16)]"" S Y=$P(^BGPELIIW(BGPPC,0),U,16) D S(Y,1,1)
 I $P(^BGPELIIW(BGPPC,0),U,19)]"" S Y=$P(^BGPELIIW(BGPPC,0),U,19) D S(Y,1,1)
 D H2^BGP2ELL2
 Q
SETN ;EP set numerator fields
 S BGPCYN=$$V(1,BGPRPT,N,P)
 S BGPPRN=$$V(2,BGPRPT,N,P)
 S BGPBLN=$$V(3,BGPRPT,N,P)
 S BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGPBLP=$S(BGPBLD:((BGPBLN/BGPBLD)*100),1:"")
 Q
SL(V) ;
 I V="" S V=0
 Q $$STRIP^XLFSTR($J(V,5,1)," ")
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 NEW X
 I T=1 S X=$P($G(^BGPELDCW(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=2 S X=$P($G(^BGPELDPW(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=3 S X=$P($G(^BGPELDBW(R,N)),U,P) Q $S(X]"":X,1:0)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPELDCW(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPELDPW(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPELDBW(X,N)),U,P)
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
 S Z=N-O,Z=$FN(Z,"+,",1)
 Q Z
SB(X) ;EP - Strip leading and trailing blanks from X.
 X ^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 Q X
H2 ;
 S BGPX=""
 S BGPX=BGPCYN
 S $P(BGPX,U,2)=$$SB^BGP2ELL2($J(BGPCYP,5,1)),$P(BGPX,U,3)=BGPPRN,$P(BGPX,U,4)=$$SB^BGP2ELL2($J(BGPPRP,5,1)),$P(BGPX,U,5)=$$SB^BGP2ELL2($J($$CALC(BGPCYP,BGPPRP),6)),$P(BGPX,U,6)=BGPBLN,$P(BGPX,U,7)=$$SB^BGP2ELL2($J(BGPBLP,5,1))
 S $P(BGPX,U,8)=$$SB^BGP2ELL2($J($$CALC(BGPCYP,BGPBLP),6))
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
