BGP7XTS ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D EN^XBVK("BGP")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("BGP 07 TAXONOMY UPDATE")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="TAXONOMIES TO SUPPORT CRS REPORTING"
 S VALMHDR(2)="* Update Taxonomies"
 Q
 ;
INIT ; -- init variables and list array
 K BGPTAX S BGPHIGH="",C=0
 S T="LAB" F J=1:1 S Z=$T(@T+J),BGPX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BGPX=""  D
 .S BGPTAX(J,0)=J_")  "_BGPX,$E(BGPTAX(J,0),40)=Y
 .S I=$O(^ATXLAB("B",BGPX,0))
 .S BGPTAX("IDX",J,J)=I
 .S C=C+1
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
 D FULL^VALM1
 W !
 I '$D(^XUSEC("BGPZ TAXONOMY EDIT",DUZ)) W !!,"You do not have the security access to edit taxonomies.",!,"Please see your supervisor or program manager if you feel you should have",!,"the BGPZ TAXONOMY EDIT security key.",! D  Q
 .K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 S DIR(0)="NO^1:"_BGPHIGH,DIR("A")="Which Taxonomy"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy selected." G ADDX
 I $D(DIRUT) W !,"No taxonomy selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPTAXI=BGPTAX("IDX",Y,Y)
 D EP^BGP7XTL(BGPTAXI)
ADDX ;
 D BACK
 Q
DISP ;EP - add an item to the selected list - called from a protocol
 W !
 S DIR(0)="NO^1:"_BGPHIGH,DIR("A")="Which Taxonomy"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy selected." G ADDX
 I $D(DIRUT) W !,"No taxonomy selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BGPTAXI=BGPTAX("IDX",Y,Y)
 W !!!,$P(^ATXLAB(BGPTAXI,0),U)
 W !!,"Tests currently defined in this taxonomy:"
 S X=0 F  S X=$O(^ATXLAB(BGPTAXI,21,"B",X)) Q:X'=+X  D
 .S Y=$P($G(^LAB(60,X,0)),U) W !?5,Y
 W !!
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
DISPX ;
 D BACK
 Q
LAB ;
 ;;DM AUDIT CREATININE TAX;;CREATININE Lab tests
 ;;DM AUDIT HGB A1C TAX;;HGB A1C Lab Tests
 ;;DM AUDIT LIPID PROFILE TAX;;Lipid Profile Lab Tests
 ;;DM AUDIT LDL CHOLESTEROL TAX;;LDL Cholesterol Lab Tests
 ;;DM AUDIT TRIGLYCERIDE TAX;;Triglyceride Lab Tests
 ;;DM AUDIT HDL TAX;;HDL Lab Tests
 ;;DM AUDIT URINE PROTEIN TAX;;Urine Protein Lab Tests
 ;;DM AUDIT MICROALBUMINURIA TAX;;Microalbuminuia Lab Tests
 ;;DM AUDIT CHOLESTEROL TAX;;Cholesterol Tests
 ;;BGP GPRA ESTIMATED GFR TAX;;Estimated GFR Tests
 ;;BGP PAP SMEAR TAX;;Pap Smear tests
 ;;BGP GPRA FOB TESTS;;Fecal Occult Blood Tests
 ;;BGP HIV TEST TAX;;HIV lab tests
 ;;BGP CD4 TAX
 ;;BGP HIV VIRAL LOAD TAX
 ;;BGP CHLAMYDIA TESTS TAX;;Chlamydia lab taxonomy
 ;;
