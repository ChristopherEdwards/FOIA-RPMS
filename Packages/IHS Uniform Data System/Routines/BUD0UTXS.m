BUD0UTXS ; IHS/CMI/LAB - DISPLAY IND LISTS 16 Dec 2010 1:48 PM ;
 ;;6.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2012;Build 25
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D EN^XBVK("BUD")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("BUD 10 TAXONOMY UPDATE")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="TAXONOMIES TO SUPPORT UDS REPORTING"
 S VALMHDR(2)="* Update Taxonomies"
 Q
 ;
INIT ; -- init variables and list array
 K BUDTAX S BUDHIGH="",C=0
 S T="LAB" F J=1:1 S Z=$T(@T+J),BUDX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BUDX=""  D
 .S BUDTAX(J,0)=J_")  "_BUDX,$E(BUDTAX(J,0),40)=Y
 .S I=$S(Y="LAB":$O(^ATXLAB("B",BUDX,0)),1:$O(^ATXAX("B",BUDX,0)))
 .S BUDTAX("IDX",J,J)=I_U_Y
 .S C=C+1
 .Q
 S (VALMCNT,BUDHIGH)=C
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
 S DIR(0)="NO^1:"_BUDHIGH,DIR("A")="Which Taxonomy"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy selected." G ADDX
 I $D(DIRUT) W !,"No taxonomy selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BUDTAXI=$P(BUDTAX("IDX",Y,Y),U,1)
 S BUDTAXT=$P(BUDTAX("IDX",Y,Y),U,2)
 D EP^BUD0UTXL(BUDTAXI,BUDTAXT)
ADDX ;
 D BACK
 Q
LAB ;
 ;;BGP PAP SMEAR TAX;;LAB
 ;;BGP HIV TEST TAX;;LAB
 ;;DM AUDIT HGB A1C TAX;;LAB
 ;;BUD HEPATITIS B TESTS;;LAB
 ;;BUD HEPATITIS C TESTS;;LAB
 ;;BUD DIABETES MEDS TAX;;DRUG
 ;;
