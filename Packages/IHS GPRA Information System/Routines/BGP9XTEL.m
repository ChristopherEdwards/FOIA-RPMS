BGP9XTEL ; IHS/CMI/LAB - TAXONOMY CHECK FOR FY04 CRS REPORT ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
 ;
 D HOME^%ZIS
 W:$D(IOF) @IOF
 W !!,"Checking for Taxonomies to support the 2009 Elder Care Report. ",!,"Please enter the device for printing.",!
ZIS ;
 S XBRC="",XBRP="TAXCHK^BGP9XTEL",XBNS="",XBRX="XIT^BGP9XTEL"
 D ^XBDBQUE
 D XIT
 Q
TAXCHK ;EP
 ;D HOME^%ZIS
 K BGPQUIT
GUICHK ;EP
 W !,"Checking for Taxonomies to support the Elder Care CRS Report...",!
 NEW A,BGPX,I,Y,Z,J,BGPY,BGPT
 K A
 ;S T="TAXS" F J=1:1 S Z=$T(@T+J),BGPX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BGPX=""  D
 S BGPT="" F  S BGPT=$O(^BGPTAXN("B",BGPT)) Q:BGPT=""  D
 .S BGPY=$O(^BGPTAXN("B",BGPT,0))
 .Q:'$D(^BGPTAXN(BGPY,12,"B",4))
 .;I $P(^BGPTAXN(BGPY,0),U,2)'="L" S BGPX=$O(^ATXAX("B",BGPT,0))
 .;I $P(^BGPTAXN(BGPY,0),U,2)="L" S BGPX=$O(^ATXLAB("B",BGPT,0))
 .S BGPTYPE=$P(^BGPTAXN(BGPY,0),U,2),Y=$G(^BGPTAXN(BGPY,11,1,0))
 .I BGPTYPE'="L" D
 ..I '$D(^ATXAX("B",BGPT)) S A(BGPT)=Y_"^is Missing" Q
 ..S I=$O(^ATXAX("B",BGPT,0))
 ..I '$D(^ATXAX(I,21,"B")) S A(BGPT)=Y_"^has no entries "
 .I BGPTYPE="L" D
 ..I '$D(^ATXLAB("B",BGPT)) S A(BGPT)=Y_"^is Missing " Q
 ..S I=$O(^ATXLAB("B",BGPT,0))
 ..I '$D(^ATXLAB(I,21,"B")) S A(BGPT)=Y_"^has no entries "
 I '$D(A) W !,"All taxonomies are present.",! K A,BGPX,Y,I,Z D DONE Q
 W !!,"In order for the Elder Care CRS Report to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S BGPX="" F  S BGPX=$O(A(BGPX)) Q:BGPX=""!($D(BGPQUIT))  D
 .I $Y>(IOSL-2) D PAGE Q:$D(BGPQUIT)
 .W !,$P(A(BGPX),U)," [",BGPX,"] ",$P(A(BGPX),U,2)
 .Q
DONE ;
 K BGPQUIT
 Q:$D(ZTQUEUED)
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
 ;;BGP DEPRESSIVE DISORDERS;;Depressive Disorders ICD9 Diagnosis Taxonomy
 ;;BGP PRIMARY CARE CLINICS
 ;;SURVEILLANCE DIABETES;;Diabetes Diagnoses Codes
 ;;BGP HGBA1C LOINC CODES
 ;;BGP LIPID PROFILE LOINC CODES
 ;;BGP LDL LOINC CODES
 ;;BGP TRIGLYCERIDE LOINC CODES
 ;;BGP HDL LOINC CODES
 ;;BGP URINE PROTEIN LOINC CODES
 ;;BGP MICROALBUM LOINC CODES
 ;;BGP CPT FLU;;Flu CPTs Taxonomy
 ;;BGP UNI MASTECTOMY PROCEDURES
 ;;BGP CPT MAMMOGRAM
 ;;BGP COLORECTAL CANCER DXS
 ;;BGP FOBT LOINC CODES
 ;;BGP RECTAL PROCEDURE CODES
 ;;BGP SIG CPTS
 ;;BGP BE CPTS
 ;;BGP COLO CPTS
 ;;BGP DV DXS
 ;;BGP GPRA SMOKING DXS
 ;;BGP ASTHMA DXS
 ;;BGP TOTAL CHOLESTEROL LOINC
 ;;BGP FRACTURE DXS
 ;;BGP FRACTURE CPTS
 ;;BGP FRACTURE PROCEDURES
 ;;BGP HEDIS OSTEOPOROSIS DRUGS
 ;;
LAB ;
 ;;DM AUDIT CREATININE TAX;;CREATININE test lab taxonomy
 ;;DM AUDIT HGB A1C TAX;;HGB A1C Lab Taxonomy
 ;;DM AUDIT LIPID PROFILE TAX;;Lipid Profile Lab Taxonomy
 ;;DM AUDIT LDL CHOLESTEROL TAX;;LDL Cholesterol Lab Taxonomy
 ;;DM AUDIT TRIGLYCERIDE TAX;;Triglyceride Lab Taxonomy
 ;;DM AUDIT HDL TAX;;HDL Lab Taxonomy
 ;;DM AUDIT URINE PROTEIN TAX;;Urine Protein Lab Taxonomy
 ;;DM AUDIT MICROALBUMINURIA TAX;;Microalbuminuia Lab Taxonomy
 ;;BGP GPRA ESTIMATED GFR TAX;;Estimated GFR Taxonomy
 ;;BGP GPRA FOB TESTS;;Fecal Occult Blood Tests taxonomy
 ;;DM AUDIT CHOLESTEROL TAX;;Cholesterol Taxonomy
 ;;
