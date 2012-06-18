BGP5ETS ; IHS/CMI/LAB - DISPLAY IND LISTS ;
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
 D EN^VALM("BGP 05 ELDER TAXONOMY UPDATE")
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
 S VALMHDR(1)="TAXONOMIES TO SUPPORT 2005 ELDER REPORTING"
 S VALMHDR(2)="* Update Taxonomies"
 Q
 ;
INIT ; -- init variables and list array
 K BGPTAX S BGPHIGH="",C=0
 S T="TAXS" F J=1:1 S Z=$T(@T+J),BGPX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BGPX=""  D
 .S BGPTAX(J,0)=J_")  "_BGPX,$E(BGPTAX(J,0),38)=$E(Y,1,30)
 .S I=$O(^ATXAX("B",BGPX,0))
 .S $E(BGPTAX(J,0),70)=$$VAL^XBDIQ1(9002226,I,.15)
 .S BGPTAX("IDX",J,J)=I_U_"T"
 .S C=C+1
 .Q
 S J=J-1 S T="LAB" F K=1:1 S Z=$T(@T+K),BGPX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BGPX=""  D
 .S J=J+1
 .S BGPTAX(J,0)=J_")  "_BGPX,$E(BGPTAX(J,0),38)=$E(Y,1,30),$E(BGPTAX(J,0),70)="LAB TEST"
 .S I=$O(^ATXLAB("B",BGPX,0))
 .S BGPTAX("IDX",J,J)=I_U_"L"
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
 S DIR(0)="NO^1:"_BGPHIGH,DIR("A")="Which Taxonomy"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy selected." G ADDX
 I $D(DIRUT) W !,"No taxonomy selected." G ADDX
 S BGPTAXI=$P(BGPTAX("IDX",Y,Y),U,1),BGPTAXT=$P(BGPTAX("IDX",Y,Y),U,2)
 I BGPTAXT="L" S BGPTAXN=$P(^ATXLAB(BGPTAXI,0),U)
 I BGPTAXT="T" S BGPTAXN=$P(^ATXAX(BGPTAXI,0),U)
 I BGPTAXT="L",$P(^ATXLAB(BGPTAXI,0),U,22) W !!,"The ",$P(^ATXLAB(BGPTAXI,0),U)," is READ ONLY.",!,"You can not update it." D PAUSE G ADDX
 I BGPTAXT="T",$P(^ATXAX(BGPTAXI,0),U,22) W !!,"The ",$P(^ATXAX(BGPTAXI,0),U)," is READ ONLY.",!,"You can not update it." D PAUSE G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 D EP^BGP5CTL(BGPTAXI)
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
 S BGPTAXI=$P(BGPTAX("IDX",Y,Y),U,1),BGPTAXT=$P(BGPTAX("IDX",Y,Y),U,2)
 W !!!,$S(BGPTAXT="L":$P(^ATXLAB(BGPTAXI,0),U),1:$P(^ATXAX(BGPTAXI,0),U))
 W !!,"Items currently defined to this taxonomy:"
 I BGPTAXT="L" S X=0 F  S X=$O(^ATXLAB(BGPTAXI,21,"B",X)) Q:X=""  D
 .S Y=$P($G(^LAB(60,X,0)),U) W !?5,Y
 I BGPTAXT="T",'$P(^ATXAX(BGPTAXI,0),U,13) S X=0 F  S X=$O(^ATXAX(BGPTAXI,21,"B",X)) Q:X=""  D
 .W !?5,$$VAL^XBDIQ1($P(^ATXAX(BGPTAXI,0),U,15),X,.01)
 I BGPTAXT="T",$P(^ATXAX(BGPTAXI,0),U,13) S X=0 F  S X=$O(^ATXAX(BGPTAXI,21,"B",X)) Q:X=""  D
 .S H=0 F  S H=$O(^ATXAX(BGPTAXI,21,"B",X,H)) Q:H=""  D
 ..W !?5,$P(^ATXAX(BGPTAXI,21,H,0),U)_"-"_$P(^ATXAX(BGPTAXI,21,H,0),U,2)
 W !!
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
DISPX ;
 D BACK
 Q
TAXS ;
 ;;BGP HEDIS OSTEOPOROSIS DRUGS;;Osteoporosis Medications Taxonomy
 ;;
LAB ;
 ;;DM AUDIT CHOLESTEROL TAX;;Cholesterol Taxonomy
 ;;BGP GPRA ESTIMATED GFR TAX;;Estimated GFR Taxonomy
 ;;BGP GPRA FOB TESTS;;Fecal Occult Blood Tests taxonomy
 ;;DM AUDIT HGB A1C TAX;;HGB A1C Lab Taxonomy
 ;;DM AUDIT HDL TAX;;HDL Lab Taxonomy
 ;;DM AUDIT LIPID PROFILE TAX;;Lipid Profile Lab Taxonomy
 ;;DM AUDIT LDL CHOLESTEROL TAX;;LDL Cholesterol Lab Taxonomy
 ;;DM AUDIT MICROALBUMINURIA TAX;;Microalbuminuia Lab Taxonomy
 ;;DM AUDIT TRIGLYCERIDE TAX;;Triglyceride Lab Taxonomy
 ;;DM AUDIT URINE PROTEIN TAX;;Urine Protein Lab Taxonomy
 ;;
