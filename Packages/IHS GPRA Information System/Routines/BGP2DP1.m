BGP2DP1 ; IHS/CMI/LAB - print ind 1 21 Mar 2010 12:55 PM ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
I1 ;EP
 I '$G(BGPSUMON) D H1^BGP2DPH
I1A1 ;
 I BGPINDW'="E" F BGPPC1="1.1","1.2","1.3" Q:BGPQUIT  D PI
 I BGPINDW="E" F BGPPC1="1.4" D PI
 I BGPINDW'="E" D I1AGE^BGP2DP1C
 Q
IREG ;EP
 I $Y>(BGPIOSL-13),'$G(BGPSUMON) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPINDW(BGPIC,53,1,0) W:$D(^BGPINDW(BGPIC,53,2,0)) !,^BGPINDW(BGPIC,53,2,0)
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:$P(^BGPINDW(BGPIC,0),U,13) S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IEDA ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:3,6:1:8 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 D I1AGE^BGP2DP14
 Q
IASCRN ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:4 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 D I1AGE^BGP2DP8
 Q
IHIV ;
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:4,8,9 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 D I1AGE^BGP2DP1H
 Q
PHYACT ;
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:$P(^BGPINDW(BGPIC,0),U,13) S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 D I1AGE^BGP2PDLT
 Q
I9 ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1,3 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 D I1AGE^BGP2DP19
 Q
I12 ;EP
 D H1^BGP2DPH
 F BGPPC1="12.1","12.2","12.3" Q:BGPQUIT  D PI
 F BGPPC1="12.4","12.5" Q:BGPQUIT  W ! D PI
 F BGPPC1="12.6","12.7" Q:BGPQUIT  D PI
 Q
I13 ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:3 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
I14 ;EP
 I $Y>(BGPIOSL-13),'$G(BGPSUMON) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPINDW(BGPIC,53,1,0) W:$D(^BGPINDW(BGPIC,53,2,0)) !,^BGPINDW(BGPIC,53,2,0)
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:3 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
I007 ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:7 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
I008 ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:5 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IB ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:6 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IH ;EP
 D H1^BGP2DPH
 I BGPRTYPE'=9 D  I 1
 .S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:6 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 .D I1AGE^BGP2DP12
 Q
I91 ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:3 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 D I1AGE^BGP2DP13
 Q
IG ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI W !
 Q
IF ;EP
 I '$G(BGPSUMON) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPINDW(BGPIC,53,1,0) W:$D(^BGPINDW(BGPIC,53,2,0)) !,^BGPINDW(BGPIC,53,2,0)
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:3 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IA ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:18 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
ICRSAMM ;EP 23
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
I031A ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:13 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
ID ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:9 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
I0302 ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:9 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
I0303 ;EP
 I $Y>(BGPIOSL-13),'$G(BGPSUMON) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPINDW(BGPIC,53,1,0) W:$D(^BGPINDW(BGPIC,53,2,0)) !,^BGPINDW(BGPIC,53,2,0)
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:3 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
I0302A ;EP
 I $Y>(BGPIOSL-13),'$G(BGPSUMON) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPINDW(BGPIC,53,1,0) W:$D(^BGPINDW(BGPIC,53,2,0)) !,^BGPINDW(BGPIC,53,2,0)
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:4 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IHEDBBH ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:6 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IHEDPBH ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:6 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IHEDCHM ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:6 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IE2 ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:1 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IE1 ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:1 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IK ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:6 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IOMW ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IRAO ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
II ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IAS ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:$P(^BGPINDW(BGPIC,0),U,13) S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IAA ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:$P(^BGPINDW(BGPIC,0),U,13) S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 D ^BGP2DP1L
 Q
IMTA ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1,2,4 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 D ^BGP2DP1M
 D ^BGP2DP1N
 Q
IL ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IMS ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IC2 ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IAST1 ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:12 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IRAR ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IHEDCWP ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
IHEDURI ;EP
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
I28 ;EP
 I '$G(BGPSUMON) D HEADER^BGP2DPH Q:BGPQUIT  W !!,^BGPINDW(BGPIC,53,1,0) W:$D(^BGPINDW(BGPIC,53,2,0)) !,^BGPINDW(BGPIC,53,2,0)
 D H1^BGP2DPH
 S BGPORDP=$P(^BGPINDW(BGPIC,12),U,6) F BGPORDP1=1:1:2 S BGPPC1=BGPORDP_"."_BGPORDP1 Q:BGPQUIT  D PI
 Q
PI ;EP
 D PI^BGP2DP1C
 Q
