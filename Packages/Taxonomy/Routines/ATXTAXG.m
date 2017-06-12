ATXTAXG ; IHS/CMI/LAB - DISPLAY TAX ;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EOJ ;START CLEAN
 D EN
 Q
EOJ ;EP
 D EN^XBVK("ATX")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("ATX TAXONOMY GENERIC SETUP")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
HDR ; -- header code
 S VALMHDR(1)="ADD OR EDIT TAXONOMIES"
 S VALMHDR(2)="TAXONOMY TYPE",$E(VALMHDR(2),38)="FILE NAME",$E(VALMHDR(2),70)="FILE"
 Q
 ;
INIT ; -- init variables and list array
 K ATXTAX S ATXHIGH="",C=0
 S J=0 F  S J=$O(^ATXTYPE(J)) Q:J'=+J  D
 .S C=C+1
 .S F=$P(^ATXTYPE(J,0),U,2)
 .Q:F=""
 .Q:'$D(^DIC(F))
 .S ATXTAX(C,0)=C_")  "_$P(^ATXTYPE(J,0),U),$E(ATXTAX(C,0),38)=$E($P(^DIC(F,0),U),1,30)
 .S $E(ATXTAX(J,0),70)=F
 .S ATXTAX("IDX",C,C)=J_U_F
 .Q
 S (VALMCNT,ATXHIGH)=C
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
SEL ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
 W !
 S DIR(0)="NO^1:"_ATXHIGH,DIR("A")="Which Taxonomy Type"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy type selected." G ADDX
 I $D(DIRUT) W !,"No taxonomy type selected." G ADDX
 S ATXTAXT=$P(ATXTAX("IDX",Y,Y),U,1),ATXTAXF=$P(ATXTAX("IDX",Y,Y),U,2)
 D FULL^VALM1 W:$D(IOF) @IOF
 S ATXFILE=ATXTAXF
 D EP^ATXTAXT
ADDX ;
 D BACK
 Q
