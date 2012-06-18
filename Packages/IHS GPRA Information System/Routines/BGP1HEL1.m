BGP1HEL1 ; IHS/CMI/LAB - print ind 1 01 Jul 2010 8:00 PM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
IP ;EP
 D H1
 S BGPPC1=$P(^BGPHEIB(BGPIC,0),U,6) D PI
 Q
PI ;EP
 S BGPDENP=0
 ;S BGPPC2=0 F  S BGPPC2=$O(^BGPHEIIB("AB",BGPPC1,BGPPC2)) Q:BGPPC2=""  S BGPPC=$O(^BGPHEIIB("AB",BGPPC1,BGPPC2,0)) D PI1
 ;S BGPPC3=0 F  S BGPPC3=$O(^BGPHEIIB("AB",BGPPC1,BGPPC3)) Q:BGPPC3=""  S BGPPC=$O(^BGPHEIIB("ABC",BGPPC1,BGPPC3,0)),BGPPC2=$P(^BGPHEIIB(BGPPC,12),U,4) D PI1
 S BGPPC3=0 F  S BGPPC3=$O(^BGPHEIIB("AC",BGPPC1,BGPPC3)) Q:BGPPC3=""  D
 .;BGPPC3=1,2 pieces
 .S BGPPC4=0 F  S BGPPC4=$O(^BGPHEIIB("AC",BGPPC1,BGPPC3,BGPPC4)) Q:BGPPC4=""  D
 ..S BGPPC=$O(^BGPHEIIB("AC",BGPPC1,BGPPC3,BGPPC4,0))
 ..S BGPPC2=BGPPC3_"."_BGPPC4
 ..D PI1
 Q
PI1 ;
 S BGPDF=$P(^BGPHEIIB(BGPPC,0),U,8)
 ;get denominator value of measure
 S BGPNP=$P(^DD(90546.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S BGPCYD=$$V(1,BGPRPT,N,P)
 S BGPPRD=$$V(2,BGPRPT,N,P)
 S BGPBLD=$$V(3,BGPRPT,N,P)
 ;write out denominator
 I $P(BGPPC2,".",3)=1 S Y=" " D S(Y,1,1) D
 .I $E($P(^BGPHEIIB(BGPPC,0),U,4),1,3)="I.B"!($E($P(^BGPHEIIB(BGPPC,0),U,4),1,3)="I.F") Q
 .S Y=$P(^BGPHEIIB(BGPPC,0),U,17) D S(Y,1,1)
 .I $P(^BGPHEIIB(BGPPC,0),U,18)]"" D
 ..I BGPRTYPE'=4,$P(^BGPHEIIB(BGPPC,0),U,18)["GPRA D" Q
 ..D S($P(^BGPHEIIB(BGPPC,0),U,18),1,1)
 .I $P(^BGPHEIIB(BGPPC,0),U,21)]"" D
 ..I BGPRTYPE'=4,$P(^BGPHEIIB(BGPPC,0),U,18)["GPRA D" Q
 ..D S($P(^BGPHEIIB(BGPPC,0),U,21),1,1)
 .S Y=BGPCYD_"^^"_BGPPRD_"^^^"_BGPBLD D S(Y,,2)
 .S BGPDENP=1
 ;get numerator value of measure and calc %
 I $P(^BGPHEIIB(BGPPC,0),U,4)["C-"!($P(^BGPHEIIB(BGPPC,0),U,4)["I.") D
 .S BGPDF=$P(^BGPHEIIB(BGPPC,0),U,8)
 .;get denominator value of measure
 .S BGPNP=$P(^DD(90546.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 .S BGPCYD=$$V(1,BGPRPT,N,P)
 .S BGPPRD=$$V(2,BGPRPT,N,P)
 .S BGPBLD=$$V(3,BGPRPT,N,P)
 S BGPNF=$P(^BGPHEIIB(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90546.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 D SETN
 ;write header for 1.A.1
 ;I $P($G(^BGPHEIIB(BGPPC,12)),U,4)="37.2.1" S X=" " D S(X,1,1)
 S Y=" " D S(Y,1,1) S Y=$P(^BGPHEIIB(BGPPC,0),U,15) D S(Y,1,1)
 I $P(^BGPHEIIB(BGPPC,0),U,16)]"" S Y=$P(^BGPHEIIB(BGPPC,0),U,16) D S(Y,1,1)
 I $P(^BGPHEIIB(BGPPC,0),U,19)]"" S Y=$P(^BGPHEIIB(BGPPC,0),U,19) D S(Y,1,1)
 D H2
 Q
SETN ;set numerator fields
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
 I T=1 S X=$P($G(^BGPHEDCB(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=2 S X=$P($G(^BGPHEDPB(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=3 S X=$P($G(^BGPHEDBB(R,N)),U,P) Q $S(X]"":X,1:0)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPHEDCB(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPHEDPB(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPHEDBB(X,N)),U,P)
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
H3 ;EP
 ;S X="Age specific Diabetes Prevalence" D S(X,1,1) S Y=" " D S(Y,1,1) S X=BGPHD1 D S(X,1,1) S Y=" " D S(Y,1,1)
 S X="Age Distribution" D S(X,1,1) S X=" " D S(X,1,1)
 S Y="<15" D S(Y,1,2)
 S Y="15-19" D S(Y,,3)
 S Y="20-24" D S(Y,,4)
 S Y="25-34" D S(Y,,5)
 S Y="35-44" D S(Y,,6)
 S Y="45-54" D S(Y,,7)
 S Y="55-64" D S(Y,,8)
 S Y=">64 yrs" D S(Y,,9)
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
