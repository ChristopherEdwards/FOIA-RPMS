BGPDT ; IHS/CMI/LAB - 2001 DIABETES AUDIT ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 W:$D(IOF) @IOF
 W !!,"Checking for Taxonomies to support the GPRA Report. ",!,"Please enter the device for printing.",!
ZIS ;
 S XBRC="",XBRP="TAXCHK^BGPDT",XBNS="",XBRX="XIT^BGPDT"
 D ^XBDBQUE
 D XIT
 Q
TAXCHK ;EP
 ;W:$D(IOF) @IOF
 K BGPQUIT
 W !,"Checking for Taxonomies to support the GPRA Report...",!
 NEW A,BGPX,I,Y,Z,J
 K A
 S T="TAXS" F J=1:1 S Z=$T(@T+J),BGPX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BGPX=""  D
 .I '$D(^ATXAX("B",BGPX)) S A(BGPX)=Y_"^is Missing" Q
 .S I=$O(^ATXAX("B",BGPX,0))
 .I '$D(^ATXAX(I,21,"B")) S A(BGPX)=Y_"^has no entries "
 S T="LAB" F J=1:1 S Z=$T(@T+J),BGPX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BGPX=""  D
 .I '$D(^ATXLAB("B",BGPX)) S A(BGPX)=Y_"^is Missing " Q
 .S I=$O(^ATXLAB("B",BGPX,0))
 .I '$D(^ATXLAB(I,21,"B")) S A(BGPX)=Y_"^has no entries "
 I '$D(A) W !,"All taxonomies are present.",! K A,BGPX,Y,I,Z D DONE Q
 W !!,"In order for the GPRA Report to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S BGPX="" F  S BGPX=$O(A(BGPX)) Q:BGPX=""!($D(BGPQUIT))  D
 .I $Y>(IOSL-2) D PAGE Q:$D(BGPQUIT)
 .W !,$P(A(BGPX),U)," [",BGPX,"] ",$P(A(BGPX),U,2)
 .Q
DONE ;
 K BGPQUIT
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of taxonomy check.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
XIT ;EP
 K BGP,BGPX,BGPQUIT,BGPLINE,BGPJ,BGPX,BGPTEXT,BGP
 K X,Y,J
 Q
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT="" Q
 Q
TAXS ;
 ;;SURVEILLANCE DIABETES;;Diabetes Diagnoses Codes
 ;;BGP PRIMARY PROVIDER DISC;;Taxonomy of Primary Care Provider Disciplines
 ;;BGP CPT PAP;;Pap CPTs Taxonomy
 ;;BGP CPT MAMMOGRAM;;Mammogram CPTs Taxonomy
 ;;BGP CPT FLU;;Flu CPTs Taxonomy
 ;;BGP PRIMARY CARE CLINICS;;Primary Care clinics Taxonomy
 ;;BGP DENTAL SEALANT OP SITES;;Dental sealant Operative Sites Taxonomy
 ;;BGP DEPRESSIVE DISORDERS;;Depressive Disorders ICD9 Diagnosis Taxonomy
 ;;BGP GPRA EX EDUC TOPICS;;Exercise Education Topics Taxonomy
 ;;
LAB ;
 ;;BGP GPRA FOB TESTS;;FOBT Lab Tests Taxonomy
 ;;DM AUDIT URINE PROTEIN TAX;;Urine Protein Lab Taxonomy
 ;;DM AUDIT MICROALBUMINURIA TAX;;Microalbuminuia Lab Taxonomy
 ;;DM AUDIT HGB A1C TAX;;HGB A1C Lab Taxonomy
 ;;DM AUDIT GLUCOSE TESTS TAX;;Glucose Tests Taxonomy
 ;;DM AUDIT LIPID PROFILE TAX;;Lipid Profile Lab Taxonomy
 ;;DM AUDIT CHOLESTEROL TAX;;Cholesterol Lab Taxonomy
 ;;DM AUDIT LDL CHOLESTEROL TAX;;LDL Cholesterol Lab Taxonomy
 ;;DM AUDIT HDL TAX;;HDL Lab Taxonomy
 ;;DM AUDIT TRIGLYCERIDE TAX;;Triglyceride Lab Taxonomy
 ;;
