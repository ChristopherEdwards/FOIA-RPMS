BGP6ELLN ; IHS/CMI/LAB - print ind 1 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 ;this routine for Measure I23 ONLY
IELDPHA ;EP
 D H1
 F BGPPC1="24.1","24.2" S X="" D S(X,1,1) D PI
 Q
PI ;EP
 S BGPPC=0 F  S BGPPC=$O(^BGPELIIS("AP",BGPPC1,BGPPC)) Q:BGPPC=""  D PI1
 Q
PI1 ;
 K BGPEXCT,BGPSDP,BGPCYP,BGPBLP,BGPPRD
 S (BGPCYD,BGPPRD,BGPBLD)=""
 S BGPNF=$P(^BGPELIIS(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90376.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 D SETN
 S X=$P(^BGPELIIS(BGPPC,0),U,15) D S(X,1,1)
 I $P(^BGPELIIS(BGPPC,0),U,16)]"" S X=$P(^BGPELIIS(BGPPC,0),U,16) D S(X,1,1)
 I $P(^BGPELIIS(BGPPC,0),U,19)]"" S Y=$P(^BGPELIIS(BGPPC,0),U,19) D S(Y,1,1)
 D H2
 Q
H2 ;
 S BGPX="",BGPX=BGPCYN,$P(BGPX,U,2)="",$P(BGPX,U,3)=BGPPRN,$P(BGPX,U,4)="",$P(BGPX,U,5)=$$SB($J($$CALC(BGPCYN,BGPPRN),6)),$P(BGPX,U,6)=BGPBLN,$P(BGPX,U,7)=""
 S $P(BGPX,U,8)=$$SB($J($$CALC(BGPCYN,BGPBLN),6))
 D S(BGPX,,2)
 Q
H1 ;EP
 S Y="REPORT" D S(Y,1,2)
 S Y=" " D S(Y,,3)
 S Y="PREV YR" D S(Y,,4)
 S Y=" " D S(Y,,5)
 S Y="CHG from" D S(Y,,6)
 S Y="BASE" D S(Y,,7)
 S Y=" " D S(Y,,8)
 S Y="CHG from" D S(Y,,9)
 S Y="PERIOD" D S(Y,1,2)
 S Y="PERIOD" D S(Y,,4)
 S Y="PREV YR  " D S(Y,,6)
 S Y="PERIOD" D S(Y,,7)
 S Y="BASE  " D S(Y,,9)
 Q
SETN ;EP set numerator fields
 D SETN^BGP6ELL1
 Q
SL(V) ;
 I V="" S V=0
 Q $$STRIP^XLFSTR($J(V,5,1)," ")
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
S(Y,F,P) ;set up array
 I '$G(F) S F=0
 S %=$P(^TMP($J,"BGPDEL",0),U)+F,$P(^TMP($J,"BGPDEL",0),U)=%
 I '$D(^TMP($J,"BGPDEL",%)) S ^TMP($J,"BGPDEL",%)=""
 S $P(^TMP($J,"BGPDEL",%),U,P)=Y
 Q
CALC(N,O) ;ENTRY POINT
 NEW Z
 S Z=N-O,Z=$FN(Z,"+,",0)
 Q Z
SB(X) ;EP - Strip leading and trailing blanks from X.
 X ^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 Q X
