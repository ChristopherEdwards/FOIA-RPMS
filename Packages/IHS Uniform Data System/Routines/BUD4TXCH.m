BUD4TXCH ; IHS/CMI/LAB - TAXONOMY CHECK FOR FY04 GPRA REPORT ;
 ;;9.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 02, 2015;Build 42
 ;
 ;
 D HOME^%ZIS
 W:$D(IOF) @IOF
 W !!,"Checking for Taxonomies to support the 2004 UDS Report. ",!,"Please enter the device for printing.",!
ZIS ;
 S XBRC="",XBRP="TAXCHK^BUD4TXCH",XBNS="",XBRX="XIT^BUD4TXCH"
 D ^XBDBQUE
 D XIT
 Q
TAXCHK ;EP
 D HOME^%ZIS
 K BUDQUIT
 W !,"Checking for Taxonomies to support the 2004 UDS Report...",!
 NEW A,BUDX,I,Y,Z,J
 K A
 S T="TAXS" F J=1:1 S Z=$T(@T+J),BUDX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BUDX=""  D
 .I '$D(^ATXAX("B",BUDX)) S A(BUDX)=Y_"^is Missing" Q
 .S I=$O(^ATXAX("B",BUDX,0))
 .I '$D(^ATXAX(I,21,"B")) S A(BUDX)=Y_"^has no entries "
 S T="LAB" F J=1:1 S Z=$T(@T+J),BUDX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BUDX=""  D
 .I '$D(^ATXLAB("B",BUDX)) S A(BUDX)=Y_"^is Missing " Q
 .S I=$O(^ATXLAB("B",BUDX,0))
 .I '$D(^ATXLAB(I,21,"B")) S A(BUDX)=Y_"^has no entries "
 I '$D(A) W !,"All taxonomies are present.",! K A,BUDX,Y,I,Z D DONE Q
 W !!,"In order for the UDS Report to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S BUDX="" F  S BUDX=$O(A(BUDX)) Q:BUDX=""!($D(BUDQUIT))  D
 .;I $Y>(IOSL-2) D PAGE Q:$D(BUDQUIT)
 .W !,$P(A(BUDX),U)," [",BUDX,"] ",$P(A(BUDX),U,2)
 .Q
DONE ;
 K BUDQUIT
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of taxonomy check.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
XIT ;EP
 K BUD,BUDX,BUDQUIT,BUDLINE,BUDJ,BUDX,BUDTEXT,BUD
 K X,Y,J
 Q
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT="" Q
 Q
TAXS ;
 ;;BUD L26 CPTS
 ;;BUD IMM CPTS
 ;;BUD CPT HIV TESTS
 ;;BGP HIV TEST LOINC CODES
 ;;BUD CPT PAP 04;;Pap CPTs Taxonomy
 ;;BGP PAP LOINC CODES
 ;;
LAB ;
 ;;BGP PAP SMEAR TAX
 ;;BGP HIV TEST TAX
 ;;
