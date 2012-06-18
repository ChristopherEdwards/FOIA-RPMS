BGP1CSII ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 K BGPPLST,BGPHIGH,BGPANS,BGPC,BGPGANS,BGPGC,BGPGI,BGPI,BGPX
 Q
 ;; ;
EN ;EP -- main entry point for CMS PT LIST DISPLAY
 D EN^VALM("BGP 11 CMS MEASURE PT LISTS")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="CMS Clinical Performance Topics"
 S VALMHDR(2)="* indicates the performance topic has been selected"
 Q
 ;
INIT ; -- init variables and list array
 K BGPPLST S BGPHIGH=""
 S (X,Y,Z,C)=0 F  S X=$O(^BGPCMSMB("AO",BGPXX,X)) Q:X'=+X  S Y=$O(^BGPCMSMB("AO",BGPXX,X,Y)) Q:Y'=+Y  D
 .S C=C+1,BGPPLST(C,0)=C_")",$E(BGPPLST(C,0),5)=$P(^BGPCMSMB(Y,0),U,3),BGPPLST(C,C)=Y I $D(BGPPLSTL(BGPXX,Y)) S BGPPLST(C,0)="*"_BGPPLST(C,0)
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
 S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which Patient List"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPANS=Y,BGPC="" F BGPI=1:1 S BGPC=$P(BGPANS,",",BGPI) Q:BGPC=""  S BGPPLSTL(BGPXX,BGPPLST(BGPC,BGPC))=""
ADDX ;
 D BACK
 Q
ADDALL ;
 F X=1:1:BGPHIGH S BGPPLSTL(BGPXX,X)=""
 D BACK
 Q
 ;
REM ;
 W ! S DIR(0)="LO^1:"_BGPHIGH,DIR("A")="Which Patient List(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPANS=Y,BGPC="" F BGPI=1:1 S BGPC=$P(BGPANS,",",BGPI) Q:BGPC=""  K BGPPLSTL(BGPXX,BGPPLST(BGPC,BGPC))
REMX ;
 D BACK
 Q
