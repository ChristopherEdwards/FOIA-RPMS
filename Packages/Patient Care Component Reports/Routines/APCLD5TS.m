APCLD5TS ; IHS/CMI/LAB - DISPLAY IND LISTS ;
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
 D EN^VALM("APCLD5 TAXONOMY UPDATE")
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
 S VALMHDR(1)="TAXONOMIES TO SUPPORT 2005 DIABETES AUDIT REPORTING"
 S VALMHDR(2)="* Update Taxonomies"
 Q
 ;
INIT ;PEP - CALLED FROM BDM -- init variables and list array
 K APCLTAX S APCLHIGH="",C=0
 S T="TAXS" F J=1:1 S Z=$T(@T+J),APCLX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:APCLX=""  D
 .S APCLTAX(J,0)=J_")  "_APCLX,$E(APCLTAX(J,0),38)=$E(Y,1,30)
 .S I=$O(^ATXAX("B",APCLX,0))
 .S $E(APCLTAX(J,0),70)=$$VAL^XBDIQ1(9002226,I,.15)
 .S APCLTAX("IDX",J,J)=I_U_"T"
 .S C=C+1
 .Q
 S J=J-1 S T="LAB" F K=1:1 S Z=$T(@T+K),APCLX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:APCLX=""  D
 .S J=J+1
 .S APCLTAX(J,0)=J_")  "_APCLX,$E(APCLTAX(J,0),38)=$E(Y,1,30),$E(APCLTAX(J,0),70)="LAB TEST"
 .S I=$O(^ATXLAB("B",APCLX,0))
 .S APCLTAX("IDX",J,J)=I_U_"L"
 .S C=C+1
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
ADD ;EP - add an item to the selected list - called from a protocol
 D FULL^VALM1
 W !
 S DIR(0)="NO^1:"_APCLHIGH,DIR("A")="Which Taxonomy"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy selected." G ADDX
 I $D(DIRUT) W !,"No taxonomy selected." G ADDX
 S APCLTAXI=$P(APCLTAX("IDX",Y,Y),U,1),APCLTAXT=$P(APCLTAX("IDX",Y,Y),U,2)
 I APCLTAXT="L" S APCLTAXN=$P(^ATXLAB(APCLTAXI,0),U)
 I APCLTAXT="T" S APCLTAXN=$P(^ATXAX(APCLTAXI,0),U)
 I APCLTAXT="L",$P(^ATXLAB(APCLTAXI,0),U,22) W !!,"The ",$P(^ATXLAB(APCLTAXI,0),U)," taxonomy is READ ONLY.",!,"You can not update it." D PAUSE G ADDX
 I APCLTAXT="T",$P(^ATXAX(APCLTAXI,0),U,22) W !!,"The ",$P(^ATXAX(APCLTAXI,0),U)," taxonomy is READ ONLY.",!,"You can not update it." D PAUSE G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 D EP^APCLD5TL(APCLTAXI)
ADDX ;
 D BACK
 Q
DISP ;EP - add an item to the selected list - called from a protocol
 W !
 S DIR(0)="NO^1:"_APCLHIGH,DIR("A")="Which Taxonomy"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No taxonomy selected." G ADDX
 I $D(DIRUT) W !,"No taxonomy selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S APCLTAXI=$P(APCLTAX("IDX",Y,Y),U,1),APCLTAXT=$P(APCLTAX("IDX",Y,Y),U,2)
 W !!!,$S(APCLTAXT="L":$P(^ATXLAB(APCLTAXI,0),U),1:$P(^ATXAX(APCLTAXI,0),U))
 W !!,"Items currently defined to this taxonomy:"
 I APCLTAXT="L" S X=0 F  S X=$O(^ATXLAB(APCLTAXI,21,"B",X)) Q:X=""  D
 .S Y=$P($G(^LAB(60,X,0)),U) W !?5,Y
 I APCLTAXT="T",'$P(^ATXAX(APCLTAXI,0),U,13) S X=0 F  S X=$O(^ATXAX(APCLTAXI,21,"B",X)) Q:X=""  D
 .W !?5,$$VAL^XBDIQ1($P(^ATXAX(APCLTAXI,0),U,15),X,.01)
 I APCLTAXT="T",$P(^ATXAX(APCLTAXI,0),U,13) S X=0 F  S X=$O(^ATXAX(APCLTAXI,21,"B",X)) Q:X=""  D
 .S H=0 F  S H=$O(^ATXAX(APCLTAXI,21,"B",X,H)) Q:H=""  D
 ..W !?5,$P(^ATXAX(APCLTAXI,21,H,0),U)_"-"_$P(^ATXAX(APCLTAXI,21,H,0),U,2)
 W !!
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
DISPX ;
 D BACK
 Q
TAXS ;
 ;;SURVEILLANCE DIABETES;;Diabetes Diagnoses Codes
 ;;SURVEILLANCE HYPERTENSION;;Hypertension Diagnoses Codes
 ;;SURVEILLANCE TUBERCULOSIS;;Tuberculosis Diagnoses Codes
 ;;DM AUDIT DEPRESSIVE DISORDERS;;Depressive Disorders Diagnoses Codes
 ;;DM AUDIT DIET EDUC TOPICS;;Diabetes Diet Education Topics
 ;;DM AUDIT EXERCISE EDUC TOPICS;;Diabetes Excercise Education Topics
 ;;DM AUDIT OTHER EDUC TOPICS;;Other Diabetes Education Topics
 ;;DM AUDIT SMOKING CESS EDUC;;Smoking Cess Education Topics
 ;;DM AUDIT TOBACCO HLTH FACTORS;;Tobacco Health Factors
 ;;DM AUDIT PROBLEM SMOKING DXS;;Smoking related diagnoses for Problem List
 ;;DM AUDIT PROBLEM HTN DIAGNOSES;;Hypertension Diagnoses
 ;;DM AUDIT PROBLEM DIABETES DX;;Diabetes Diagnoses
 ;;DM AUDIT SMOKING RELATED DXS;;Smoking related diagnoses for POVs
 ;;DM AUDIT CESSATION HLTH FACTOR;;Smoking Cessation Health Factors
 ;;DM AUDIT SELF MONITOR DRUGS;;Self Monitoring Drugs Taxonomy
 ;;DM AUDIT TB HEALTH FACTORS;;TB Status Health Factors
 ;;DM AUDIT INSULIN DRUGS;;Insulin Drug Taxonomy
 ;;DM AUDIT SULFONYLUREA DRUGS;;Sulfonylurea Drug Taxonomy
 ;;DM AUDIT METFORMIN DRUGS;;Metformin Drug Taxonomy
 ;;DM AUDIT ACARBOSE DRUGS;;Acarbose Drug Taxonomy
 ;;DM AUDIT LIPID LOWERING DRUGS;;Lipid Lowering Drug Taxonomy
 ;;DM AUDIT STATIN DRUGS;;Statin Drug Taxonomy
 ;;DM AUDIT GLITAZONE DRUGS;;Glitzaone Drug Taxonomy
 ;;DM AUDIT ACE INHIBITORS;;ACE Inhibitor Drug Taxonomy
 ;;DM AUDIT ASPIRIN DRUGS;;Aspirin Drug Taxonomy
 ;;DM AUDIT ANTI-PLATELET DRUGS;;Anti-Platelet Drug Taxonomy
 ;;DM AUDIT SDM PROVIDERS;;SDM providers Taxonomy
 ;;DM AUDIT TYPE II DXS;;Type II Diagnoses
 ;;DM AUDIT TYPE I DXS;;Type I Diagnoses
 ;;
LAB ;
 ;;DM AUDIT URINE PROTEIN TAX;;Urine Protein Lab Taxonomy
 ;;DM AUDIT MICROALBUMINURIA TAX;;Microalbuminuia Lab Taxonomy
 ;;DM AUDIT HGB A1C TAX;;HGB A1C Lab Taxonomy
 ;;DM AUDIT CREATININE TAX;;Creatinine Lab Taxonomy
 ;;DM AUDIT CHOLESTEROL TAX;;Cholesterol Lab Taxonomy
 ;;DM AUDIT LDL CHOLESTEROL TAX;;LDL Cholesterol Lab Taxonomy
 ;;DM AUDIT HDL TAX;;HDL Lab Taxonomy
 ;;DM AUDIT TRIGLYCERIDE TAX;;Triglyceride Lab Taxonomy
 ;;DM AUDIT URINALYSIS TAX;;Urinalysis Lab Taxonomy
 ;;DM AUDIT A/C RATIO TAX;;A/C RATIO Lab Taxonomy
 ;;DM AUDIT LIPID PROFILE TAX;;Lipid Profile taxonomy
 ;;
