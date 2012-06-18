APCLTAXG ; IHS/CMI/LAB - DISPLAY TAX ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D EN^XBVK("APCL")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("APCL TAXONOMY GENERIC SETUP")
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
 K APCLTAX S APCLHIGH="",C=0
 S J=0 F  S J=$O(^ATXTYPE(J)) Q:J'=+J  D
 .S C=C+1
 .S F=$P(^ATXTYPE(J,0),U,2)
 .Q:F=""
 .Q:'$D(^DIC(F))
 .S APCLTAX(C,0)=C_")  "_$P(^ATXTYPE(J,0),U),$E(APCLTAX(C,0),38)=$E($P(^DIC(F,0),U),1,30)
 .S $E(APCLTAX(J,0),70)=F
 .S APCLTAX("IDX",C,C)=J_U_F
 .Q
 S (VALMCNT,APCLHIGH)=C
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
 S DIR(0)="NO^1:"_APCLHIGH,DIR("A")="Which Taxonomy Type"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy type selected." G ADDX
 I $D(DIRUT) W !,"No taxonomy type selected." G ADDX
 S APCLTAXT=$P(APCLTAX("IDX",Y,Y),U,1),APCLTAXF=$P(APCLTAX("IDX",Y,Y),U,2)
 D FULL^VALM1 W:$D(IOF) @IOF
 S APCLFILE=APCLTAXF
 D EP^APCLTAXT
ADDX ;
 D BACK
 Q
