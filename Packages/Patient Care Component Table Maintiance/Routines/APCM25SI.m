APCM25SI ; IHS/CMI/LAB - IHS MU ;
 ;;1.0;MU PERFORMANCE REPORTS;**7**;MAR 26, 2012;Build 15
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 K APCMTIND,APCMHIGH,APCMANS,APCMC,APCMGANS,APCMGC,APCMGI,APCMI,APCMX
 Q
 ;; ;
EN ;EP -- main entry point for SELECTION
 D EN^VALM("APCM 25 S2 INDICATOR SEL")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="IHS Modified Stage 2 MU Performance Reports"
 S VALMHDR(2)="* indicates the Performance Measure has been selected"
 Q
 ;
INIT ; -- init variables and list array
 K APCMTIND S APCMHIGH=""
 S APCMXREF=$S(APCMRPTT=1:"EOORDER",1:"AH")
 S (X,Y,Z,C)=0 F  S X=$O(^APCM25OB(APCMXREF,X)) Q:X'=+X  F  S Y=$O(^APCM25OB(APCMXREF,X,Y)) Q:Y'=+Y  D
 .S C=C+1,APCMTIND(C,0)=C_")",$E(APCMTIND(C,0),5)=$P(^APCM25OB(Y,0),U,5),APCMTIND(C,C)=Y I $D(APCMIND(Y)) S APCMTIND(C,0)="*"_APCMTIND(C,0)
 .Q
 S (VALMCNT,APCMHIGH)=C
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
 S DIR(0)="LO^1:"_APCMHIGH,DIR("A")="Which Performance Measure(s)"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No Performance Measures selected." G ADDX
 I $D(DIRUT) W !,"No Performance Measures selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S APCMANS=Y,APCMC="" F APCMI=1:1 S APCMC=$P(APCMANS,",",APCMI) Q:APCMC=""  S APCMIND(APCMTIND(APCMC,APCMC))=""
ADDX ;
 D BACK
 Q
ADDALL ;
 S X=0 F  S X=$O(APCMTIND(X)) Q:X'=+X  S APCMIND(APCMTIND(X,X))=""
 D BACK
 Q
 ;
MS ;
 S X=0 F  S X=$O(APCMTIND(X)) Q:X'=+X  S Y=APCMTIND(X,X) I $P(^APCM25OB(Y,0),U,3)="M" S APCMIND(APCMTIND(X,X))=""
 D BACK
 Q
 ;
CM ;
 S X=0 F  S X=$O(APCMTIND(X)) Q:X'=+X  S Y=APCMTIND(X,X) I $P(^APCM25OB(Y,0),U,3)="C" S APCMIND(APCMTIND(X,X))=""
 D BACK
 Q
REM ;
 W ! S DIR(0)="LO^1:"_APCMHIGH,DIR("A")="Which Performance Measure(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No Performance Measures selected." G ADDX
 I $D(DIRUT) W !,"No Performance Measures selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S APCMANS=Y,APCMC="" F APCMI=1:1 S APCMC=$P(APCMANS,",",APCMI) Q:APCMC=""  K APCMIND(APCMTIND(APCMC,APCMC))
REMX ;
 D BACK
 Q
