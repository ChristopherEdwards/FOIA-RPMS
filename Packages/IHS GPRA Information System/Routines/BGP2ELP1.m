BGP2ELP1 ; IHS/CMI/LAB - print ind 1 ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
I1 ;EP ; diabetes prevalence
 D H1^BGP2DPH ;column headers
I1A1 ;001.A, 001.B, 001.C
 F BGPPC1="1.1","1.2","1.3" Q:BGPQUIT  D PI
 D I1AGE
 Q
I2 ;EP
 I $Y>(BGPIOSL-13) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPELIW(BGPIC,53,1,0)
 D H1^BGP2DPH
 F BGPPC1="2.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL12
 Q
I3 ;EP
 I $Y>(BGPIOSL-13) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPELIW(BGPIC,53,1,0)
 D H1^BGP2DPH
 F BGPPC1="3.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL13
 Q
I4 ;EP
 I $Y>(BGPIOSL-13) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPELIW(BGPIC,53,1,0)
 D H1^BGP2DPH
 F BGPPC1="4.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL14
 Q
I5 ;EP
 I $Y>(BGPIOSL-13) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPELIW(BGPIC,53,1,0)
 D H1^BGP2DPH
 F BGPPC1="5.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL15
 Q
I6 ;EP
 I $Y>(BGPIOSL-13) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPELIW(BGPIC,53,1,0)
 D H1^BGP2DPH
 F BGPPC1="6.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL16
 Q
I7 ;EP
 D H1^BGP2DPH
 F BGPPC1="7.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL17
 Q
I8 ;
 D H1^BGP2DPH
 F BGPPC1="8.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL18
 Q
I9 ;EP
 D H1^BGP2DPH
 F BGPPC1="9.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL19
 Q
I10 ;EP
 D H1^BGP2DPH
 F BGPPC1="10.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL10
 Q
I11 ;EP
 D H1^BGP2DPH
 F BGPPC1="11.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1A
 Q
I12 ;EP
 D H1^BGP2DPH
 F BGPPC1="12.1","12.2","12.3" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1B
 Q
I13 ;EP
 D H1^BGP2DPH
 F BGPPC1="13.1","13.2","13.3" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1C
 Q
I14 ;EP
 D H1^BGP2DPH
 F BGPPC1="14.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1D
 Q
I15 ;EP
 D H1^BGP2DPH
 F BGPPC1="15.1","15.2","15.3" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1E
 Q
I16 ;EP
 D H1^BGP2DPH
 F BGPPC1="16.1","16.2","16.3" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1F
 Q
I17 ;EP
 D H1^BGP2DPH
 F BGPPC1="17.1","17.2","17.3" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1G
 Q
I18 ;EP
 D H1^BGP2DPH
 F BGPPC1="18.1","18.2","18.3" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1H
 Q
I19 ;EP
 D H1^BGP2DPH
 F BGPPC1="19.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1I
 Q
EFR ;EP
 D H1^BGP2DPH
 S BGPPC0=$P(^BGPELIW(BGPIC,0),U,6)
 F BGPPCX=1,2,3 S BGPPC1=BGPPC0_"."_BGPPCX Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1O
 Q
IEDA ;EP
 D H1^BGP2DPH
 S BGPPC0=$P(^BGPELIW(BGPIC,0),U,6)
 F BGPPCX=1,2,3 S BGPPC1=BGPPC0_"."_BGPPCX Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1P
 Q
IELDFSA ;EP
 D H1^BGP2DPH
 F BGPPC1="22.1","22.2","22.3" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1J
 Q
IELDASA ;EP
 D H1^BGP2DPH
 F BGPPC1="23.1" Q:BGPQUIT  D PI
 S BGPNODEN=1 S BGPPC1="23.2" Q:BGPQUIT  D PI K BGPNODEN
 D I1AGE^BGP2EL1K
 Q
IELDPHA ;EP
 D IELDPHA^BGP2EL1L
 Q
IRAO ;EP
 D H1^BGP2DPH
 F BGPPC1="20.1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1M
 Q
IRAA ;EP
 D H1^BGP2DPH
 F BGPPC1=$P(^BGPELIW(BGPIC,0),U,6)_".1" Q:BGPQUIT  D PI
 D I1AGE^BGP2EL1N
 Q
AWV ;EP
 D H1^BGP2DPH
 K BGPNODEN
 F BGPPC9=1:1:3 S BGPPC1="28."_BGPPC9 Q:BGPQUIT  D PI
 D ^BGP2EL1T
 Q
PCV ;EP
 D H1^BGP2DPH
 S BGPNODEN=1 F BGPPC9=1:1:7 S BGPPC1="27."_BGPPC9  Q:BGPQUIT  S BGPNODEN=1 D PI K BGPNODEN
 I BGPQUIT K BGPNODEN Q
 D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPELIW(BGPIC,53,1,0) D H1^BGP2DPH
 S BGPNODEN=1 F BGPPC9=8:1:15 S BGPPC1="27."_BGPPC9  Q:BGPQUIT  S BGPNODEN=1 D PI K BGPNODEN
 I BGPQUIT K BGPNODEN Q
 D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPELIW(BGPIC,53,1,0) D H1^BGP2DPH
 S BGPNODEN=1 F BGPPC9=16:1:22 S BGPPC1="27."_BGPPC9  Q:BGPQUIT  S BGPNODEN=1 D PI K BGPNODEN
 I BGPQUIT K BGPNODEN Q
 D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPELIW(BGPIC,53,1,0) D H1^BGP2DPH
 S BGPNODEN=1 F BGPPC9=23:1:30 S BGPPC1="27."_BGPPC9 Q:BGPQUIT  S BGPNODEN=1 D PI K BGPNODEN
 I BGPQUIT K BGPNODEN Q
 K BGPNODEN
 F BGPPC9=31:1:33 S BGPPC1="27."_BGPPC9 Q:BGPQUIT  D PI
 D ^BGP2EL1S
 Q
PI ;EP
 S BGPDENP=0
 S BGPPC2=0 F  S BGPPC2=$O(^BGPELIIW("ABC",BGPPC1,BGPPC2)) Q:BGPPC2=""  S BGPPC=$O(^BGPELIIW("ABC",BGPPC1,BGPPC2,0)) D PI1
 Q
PI1 ;
 S BGPDF=$P(^BGPELIIW(BGPPC,0),U,8)
 ;get denominator value of measure
 S BGPNP=$P(^DD(90549.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S BGPCYD=$$V(1,BGPRPT,N,P)
 S BGPPRD=$$V(2,BGPRPT,N,P)
 S BGPBLD=$$V(3,BGPRPT,N,P)
 ;write out denominator
 I 'BGPDENP D
 .Q:$G(BGPNODEN)  ;no denominator to display
 .I $Y>(BGPIOSL-13) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPELIW(BGPIC,53,1,0) D H1^BGP2DPH
 .W !!,$P(^BGPELIIW(BGPPC,0),U,17)
 .I $P(^BGPELIIW(BGPPC,0),U,18)]"" D
 ..W !,$P(^BGPELIIW(BGPPC,0),U,18)
 .I $P(^BGPELIIW(BGPPC,0),U,21)]""  D
 ..W !,$P(^BGPELIIW(BGPPC,0),U,21)
 .W ?20,$$C(BGPCYD,0,8),?35,$$C(BGPPRD,0,8),?58,$$C(BGPBLD,0,8),!
 .S BGPDENP=1
 S BGPNF=$P(^BGPELIIW(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90549.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 D SETN
 ;write header
 I $Y>(IOSL-5) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPELIW(BGPIC,53,1,0) D H1^BGP2DPH
 I $P(^BGPELIIW(BGPPC,0),U,22) W !
 W !,$P(^BGPELIIW(BGPPC,0),U,15)
 I $P(^BGPELIIW(BGPPC,0),U,16)]"" W !?1,$P(^BGPELIIW(BGPPC,0),U,16)
 I $P(^BGPELIIW(BGPPC,0),U,19)]"" W !?1,$P(^BGPELIIW(BGPPC,0),U,19)
 D H2^BGP2DPH
 Q
SETN ;EP set numerator fields
 S BGPCYN=$$V(1,BGPRPT,N,P)
 S BGPPRN=$$V(2,BGPRPT,N,P)
 S BGPBLN=$$V(3,BGPRPT,N,P)
 S BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGPBLP=$S(BGPBLD:((BGPBLN/BGPBLD)*100),1:"")
 Q
I1AGE ; special age tallies
 D I1AGE^BGP2EL11
 Q
SL(V) ;
 I V="" S V=0
 Q $$STRIP^XLFSTR($J(V,5,1)," ")
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 I T=1 Q $P($G(^BGPELDCW(R,N)),U,P)
 I T=2 Q $P($G(^BGPELDPW(R,N)),U,P)
 I T=3 Q $P($G(^BGPELDBW(R,N)),U,P)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPELDCW(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPELDPW(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPELDBW(X,N)),U,P)
 .Q
 Q C
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
