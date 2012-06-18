BDMP1TS ; IHS/CMI/LAB - DISPLAY IND LISTS ; 
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**4**;JUN 14, 2007
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 I '$D(BDMGUI) D EN^XBVK("BDM")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("BDMP1 TAXONOMY UPDATE")
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
 S VALMHDR(1)="TAXONOMIES TO SUPPORT PRE-DIABETES/METABOLIC SYNDROME REPORTING"
 S VALMHDR(2)="* Update Taxonomies"
 Q
 ;
INIT ;EP -- init variables and list array
 K BDMTAX S BDMHIGH="",C=0
 S T="TAXS" F J=1:1 S Z=$T(@T+J),BDMX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BDMX=""  D
 .S BDMTAX(J,0)=J_")  "_BDMX,$E(BDMTAX(J,0),38)=$E(Y,1,30)
 .S I=$O(^ATXAX("B",BDMX,0))
 .S $E(BDMTAX(J,0),70)=$$VAL^XBDIQ1(9002226,I,.15)
 .S BDMTAX("IDX",J,J)=I_U_"T"
 .S C=C+1
 .Q
 S J=J-1 S T="LAB" F K=1:1 S Z=$T(@T+K),BDMX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BDMX=""  D
 .S J=J+1
 .S BDMTAX(J,0)=J_")  "_BDMX,$E(BDMTAX(J,0),38)=$E(Y,1,30),$E(BDMTAX(J,0),70)="LAB TEST"
 .S I=$O(^ATXLAB("B",BDMX,0))
 .S BDMTAX("IDX",J,J)=I_U_"L"
 .S C=C+1
 .Q
 S (VALMCNT,BDMHIGH)=C
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
 S DIR(0)="NO^1:"_BDMHIGH,DIR("A")="Which Taxonomy"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy selected." G ADDX
 I $D(DIRUT) W !,"No taxonomy selected." G ADDX
 S BDMTAXI=$P(BDMTAX("IDX",Y,Y),U,1),BDMTAXT=$P(BDMTAX("IDX",Y,Y),U,2)
 I BDMTAXT="L" S BDMTAXN=$P(^ATXLAB(BDMTAXI,0),U)
 I BDMTAXT="T" S BDMTAXN=$P(^ATXAX(BDMTAXI,0),U)
 I BDMTAXT="L",$P(^ATXLAB(BDMTAXI,0),U,22) W !!,"The ",$P(^ATXLAB(BDMTAXI,0),U)," is READ ONLY.",!,"You can not update it." D PAUSE G ADDX
 I BDMTAXT="T",$P(^ATXAX(BDMTAXI,0),U,22) W !!,"The ",$P(^ATXAX(BDMTAXI,0),U)," is READ ONLY.",!,"You can not update it." D PAUSE G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 D EP^BDMP1TL(BDMTAXI)
ADDX ;
 D BACK
 Q
DISP ;EP - add an item to the selected list - called from a protocol
 W !
 S DIR(0)="NO^1:"_BDMHIGH,DIR("A")="Which Taxonomy"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy selected." G ADDX
 I $D(DIRUT) W !,"No taxonomy selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BDMTAXI=$P(BDMTAX("IDX",Y,Y),U,1),BDMTAXT=$P(BDMTAX("IDX",Y,Y),U,2)
 W !!!,$S(BDMTAXT="L":$P(^ATXLAB(BDMTAXI,0),U),1:$P(^ATXAX(BDMTAXI,0),U))
 W !!,"Items currently defined to this taxonomy:"
 I BDMTAXT="L" S X=0 F  S X=$O(^ATXLAB(BDMTAXI,21,"B",X)) Q:X=""  D
 .S Y=$P($G(^LAB(60,X,0)),U) W !?5,Y
 I BDMTAXT="T",'$P(^ATXAX(BDMTAXI,0),U,13) S X=0 F  S X=$O(^ATXAX(BDMTAXI,21,"B",X)) Q:X=""  D
 .W !?5,$$VAL^XBDIQ1($P(^ATXAX(BDMTAXI,0),U,15),X,.01)
 I BDMTAXT="T",$P(^ATXAX(BDMTAXI,0),U,13) S X=0 F  S X=$O(^ATXAX(BDMTAXI,21,"B",X)) Q:X=""  D
 .S H=0 F  S H=$O(^ATXAX(BDMTAXI,21,"B",X,H)) Q:H=""  D
 ..W !?5,$P(^ATXAX(BDMTAXI,21,H,0),U)_"-"_$P(^ATXAX(BDMTAXI,21,H,0),U,2)
 W !!
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
DISPX ;
 D BACK
 Q
TAXS ;
 ;;SURVEILLANCE DIABETES;;Diabetes Diagnoses Codes;;DX
 ;;SURVEILLANCE HYPERTENSION;;Hypertension Diagnoses Codes
 ;;DM AUDIT PROBLEM SMOKING DXS;;Smoking related diagnoses for Problem List
 ;;DM AUDIT PROBLEM HTN DIAGNOSES;;Hypertension Diagnoses
 ;;DM AUDIT PROBLEM DIABETES DX;;Diabetes Diagnoses
 ;;DM AUDIT SMOKING RELATED DXS;;Smoking related diagnoses for POVs
 ;;DM AUDIT DIET EDUC TOPICS;;Diabetes Diet Education Topics
 ;;DM AUDIT EXERCISE EDUC TOPICS;;Diabetes Excercise Education Topics
 ;;DM AUDIT SMOKING CESS EDUC;;Smoking Cess Education Topics
 ;;DM AUDIT TOBACCO HLTH FACTORS;;Tobacco Health Factors
 ;;DM AUDIT CESSATION HLTH FACTOR;;Smoking Cessation Health Factors
 ;;DM AUDIT SULFONYLUREA DRUGS;;Sulfonylurea Drug Taxonomy
 ;;DM AUDIT METFORMIN DRUGS;;Metformin Drug Taxonomy
 ;;DM AUDIT ACARBOSE DRUGS;;Acarbose Drug Taxonomy
 ;;DM AUDIT LIPID LOWERING DRUGS;;Lipid Lowering Drug Taxonomy
 ;;DM AUDIT STATIN DRUGS;;Statin Drug Taxonomy
 ;;DM AUDIT GLITAZONE DRUGS;;Glitzaone Drug Taxonomy
 ;;DM AUDIT ACE INHIBITORS;;ACE Inhibitor Drug Taxonomy
 ;;DM AUDIT ASPIRIN DRUGS;;Aspirin Drug Taxonomy
 ;;DM AUDIT ANTI-PLATELET DRUGS;;Anti-Platelet Drug Taxonomy
 ;;
LAB ;
 ;;DM AUDIT FASTING GLUCOSE TESTS;;Fasting Glucose Tests Taxonomy
 ;;DM AUDIT CHOLESTEROL TAX;;Cholesterol Lab Taxonomy
 ;;DM AUDIT LDL CHOLESTEROL TAX;;LDL Cholesterol Lab Taxonomy
 ;;DM AUDIT HDL TAX;;HDL Lab Taxonomy
 ;;DM AUDIT TRIGLYCERIDE TAX;;Triglyceride Lab Taxonomy
 ;;DM AUDIT 75GM 2HR GLUCOSE;;75 gm 2hr glucose test Taxonomy
 ;;
