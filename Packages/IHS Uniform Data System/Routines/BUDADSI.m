BUDADSI ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 K BUDTIND,BUDHIGH,BUDANS,BUDC,BUDGANS,BUDGC,BUDGI,BUDI,BUDX
 Q
 ;; ;
EN ;EP -- main entry point for APCH HMR DISPLAY
 D EN^VALM("BUD 13 INDICATOR SELECTION")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="UDS Lists for Table 6B"
 S VALMHDR(2)="* indicates the list has been selected"
 Q
 ;
INIT ; -- init variables and list array
 K BUDTIND S BUDHIGH=""
 S (X,Y,Z,C)=0 F  S X=$O(^BUDQLST2("OR",X)) Q:X'=+X  S Y=0 F  S Y=$O(^BUDQLST2("OR",X,Y))  Q:Y'=+Y  D
 .S C=C+1,BUDTIND(C,0)=C_")",$E(BUDTIND(C,0),5)=$P(^BUDQLST2(Y,0),U,1),BUDTIND(C,C)=Y I $D(BUDIND(Y)) S BUDTIND(C,0)="*"_BUDTIND(C,0)
 .Q
 S (VALMCNT,BUDHIGH)=C
 Q
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
 NEW BUDMCNT
 S BUDMCNT=0
 W !
 S DIR(0)="LO^1:"_BUDHIGH,DIR("A")="Which List(s)"
ADD1 ;
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BUDANS=Y,BUDC="" F BUDI=1:1 S BUDC=$P(BUDANS,",",BUDI) Q:BUDC=""  S BUDIND(BUDTIND(BUDC,BUDC))=""
 ;
ADDX ;
 D BACK
 Q
ADDALL ;
 F X=1:1:BUDHIGH S BUDIND(X)=""
 D BACK
 Q
 ;
REM ;
 W ! S DIR(0)="LO^1:"_BUDHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BUDANS=Y,BUDC="" F BUDI=1:1 S BUDC=$P(BUDANS,",",BUDI) Q:BUDC=""  K BUDIND(BUDTIND(BUDC,BUDC))
REMX ;
 D BACK
 Q
