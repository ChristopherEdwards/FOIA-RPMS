APCLPYR ; IHS/CMI/LAB - Patients by Payer (Insurer) - Driver ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;For Medicare Part D, add the selections fo the prompt below, then
 ;check the subsections in APCLPYR2 (MCR) and APCLPYR5 (RR).
 ;
 D ^XBCLS
 W !,"This option allows you to print a list of patients who are registered at"
 W !,"the facility that you select, who have insurance coverage with the insurer"
 W !,"that you select."
 W !
 ;
 W !,"========================================================================",!
 K DIC,DIR,DIE,DA,DD,DO,DR
 S DIC="^AUTTLOC("
 S DIC(0)="AEQMZ"
 S DIC("A")="Which Facility: "
 S DIC("B")=DUZ(2)
 D ^DIC
 K DIC,DIR,DIE,DA,DD,DO,DR
 I Y<0 Q
 S APCLFAC=+Y
 ;
 W !,"========================================================================",!!
 W "You may select from the following types of insurance"
 K DIR
 S DIR(0)="S^1:Medicare Part A;2:Medicare Part B;3:Medicaid;4:A Selected Private Insurance;5:Railroad Part A;6:Railroad Part B"
 S DIR("A")="Select a type of insurance"
 D ^DIR
 I $D(DIRUT) Q
 I Y=1 S APCLTYP="MRA"
 I Y=2 S APCLTYP="MRB"
 I Y=3 S APCLTYP="MCD"
 I Y=4 S APCLTYP="PVT"
 I Y=5 S APCLTYP="RRA"
 I Y=6 S APCLTYP="RRB"
 ;
 I APCLTYP="PVT" D  Q:'APCLPYR
 .W !!,"========================================================================",!
 .S APCLPYR=0
 .K DIC,DD,DA,DIE,DLAYGO,DR,DO
 .S DIC(0)="AEQMZ"
 .S DIC="^AUTNINS("
 .D ^DIC
 .I Y<0 K DIC Q
 .S APCLPYR=+Y
 ;
 I APCLTYP="MCD" D  Q:'APCLMCST
 .W !!,"========================================================================",!
 .S APCLMCST=0,APCLPYR=0
 .K DIC,DIE,DIR,DA,DD,DO,DR
 .S DIC(0)="AEQMZ"
 .S DIC=5
 .S DIC("A")="Select a Medicaid State: "
 .D ^DIC
 .K DIC,DIE,DIR,DA,DD,DO,DR
 .I Y<0 Q
 .S APCLMCST=+Y
 .W !!,"You may further specify a specific Plan Name.  If you don't"
 .W !,"enter a Plan Name, then all Plans for that state will be"
 .W !,"selected.",!
 .S DIC(0)="AEQMZ"
 .S DIC("A")="Select a Medicaid Plan Name (optional): "
 .S DIC="^AUTNINS("
 .D ^DIC
 .K DIC,DIE,DIR,DR,DA,DD,DO
 .I Y<0 Q
 .S APCLPYR=+Y
 ;
 ;
 W !!,"========================================================================",!!
 W "Do you want patients that only have this one insurer (no other coverage)?",!
 K DIR
 S DIR(0)="Y"
 S DIR("B")="N"
 D ^DIR
 I $D(DIRUT) K APCLPYR,DIR Q
 S APCLOTH=0
 I Y=1 S APCLOTH=1
 ;
 W !!,"========================================================================",!!
 W "You may select eligibility in three different ways"
 K DIR
 S DIR(0)="S^1:Currently Active Eligibility Dates;2:Any Past or Current Eligibility Dates;3:Selected Eligibility Dates"
 S DIR("A")="Select Type of Eligibility Dates"
 D ^DIR
 I $D(DIRUT) Q
 I Y=1 S APCLACT=1,APCLBDAT=DT,APCLEDAT=DT
 I Y=2 S APCLACT=0,APCLBDAT=0,APCLEDAT=0
 I Y=3 D
 .S APCLACT=1
 .W !
 .S %DT="AE"
 .S %DT("A")="Enter a Beginning Eligibility Date: "
 .D ^%DT
 .S APCLBDAT=0
 .I Y>0 S APCLBDAT=Y
 .S %DT="AE"
 .S %DT("A")="Enter an Ending Eligibility Date: "
 .D ^%DT
 .S APCLEDAT=0
 .I Y>0 S APCLEDAT=Y
 .W !!
 .W "Restrict the report to eligibility dates starting after ",$E(APCLBDAT,4,5),"/",$E(APCLBDAT,6,7),"/",$E(APCLBDAT,2,3),"?",!
 .K DIR
 .S DIR(0)="Y"
 .S DIR("B")="N"
 .D ^DIR
 .I Y=1 S APCLACT=2
 ;
 I APCLTYP="PVT" S APCLALL=0
 I APCLTYP'="PVT" D
 .W !!,"========================================================================",!!
 .W "Do you want to print all beginning and ending eligibility date pairs?",!
 .K DIR
 .S DIR(0)="Y"
 .S DIR("B")="N"
 .D ^DIR
 .I $D(DIRUT) K APCLPYR,APCLBDAT,APCLEDAT,APCLACT,DIR Q
 .S APCLALL=0
 .I Y=1 S APCLALL=1
 ;
 W !!,"========================================================================",!!
 W "How do you want this report sorted?"
 K DIR
 S DIR(0)="S^1:Patient Name;2:Patient HRNO"
 S DIR("A")="Sort the Report By"
 S DIR("B")=1
 D ^DIR
 I $D(DIRUT) Q
 I Y=1 S APCLSORT="NAME"
 I Y=2 S APCLSORT="HRNO"
 ;
 W !!,"========================================================================",!
 S XBRP="EN^APCLPYR"
 S XBNS="APCL"
 S XBRX="EOJ^APCLPYR"
 D ^XBDBQUE
 Q
 ;
EOJ ;
 X ^%ZIS("C")
 K ^TMP($J,"APCLPYR")
 D EN^XBVK("APCL")
 K DIR,DIE,DIC,DA,DD,DR,DO,DLAYGO
 Q
 ;
EN ;
 K DUOUT,DTOUT,DFOUT
 ;I $D(ZTSK) K ^%ZTSK(ZTSK)
 U IO
 ;
 I APCLTYP="MRA" D MRALOOP^APCLPYR2
 I APCLTYP="MRB" D MRBLOOP^APCLPYR2
 I APCLTYP="MRD" D MRDLOOP^APCLPYR2
 I APCLTYP="MCD" D MCDLOOP^APCLPYR3
 I APCLTYP="PVT" D PVTLOOP^APCLPYR4
 I APCLTYP="RRA" D RRALOOP^APCLPYR5
 I APCLTYP="RRB" D RRBLOOP^APCLPYR5
 I APCLTYP="RRD" D RRDLOOP^APCLPYR5
 Q
