BGP8DPSI ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 K BGPTIND,BGPHIGH,BGPANS,BGPC,BGPGANS,BGPGC,BGPGI,BGPI,BGPX
 Q
 ;; ;
EN ;EP -- main entry point for APCH HMR DISPLAY
 D EN^VALM("BGP 08 PATED MEASURE SEL")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="IHS Patient Education Measures"
 S VALMHDR(2)="* indicates the performance measure has been selected"
 Q
 ;
INIT ; -- init variables and list array
 K BGPTIND S BGPHIGH=""
 S (X,Y,Z,C)=0 F  S X=$O(^BGPPEIE("AO",X)) Q:X'=+X  S Y=$O(^BGPPEIE("AO",X,Y)) Q:Y'=+Y  D
 .S C=C+1,BGPTIND(C,0)=C_")",$E(BGPTIND(C,0),5)=$P(^BGPPEIE(Y,0),U,2),BGPTIND(C,C)=Y I $D(BGPIND(Y)) S BGPTIND(C,0)="*"_BGPTIND(C,0)
 .Q
 S (VALMCNT,BGPHIGH)=C
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 W !
 I $G(BGPRTYPE)'=1 S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which item(s)"
 I $G(BGPRTYPE)=1 S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which Measure Topic"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPANS=Y,BGPC="" F BGPI=1:1 S BGPC=$P(BGPANS,",",BGPI) Q:BGPC=""  S BGPIND(BGPTIND(BGPC,BGPC))=""
ADDX ;
 D BACK
 Q
ADDALL ;
 F X=1:1:BGPHIGH S BGPIND(X)=""
 D BACK
 Q
 ;
REM ;
 W ! S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPANS=Y,BGPC="" F BGPI=1:1 S BGPC=$P(BGPANS,",",BGPI) Q:BGPC=""  K BGPIND(BGPTIND(BGPC,BGPC))
REMX ;
 D BACK
 Q
