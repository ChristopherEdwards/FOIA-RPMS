BGP9CTXC ; IHS/CMI/LAB - TAXONOMY CHECK FOR FY04 CRS REPORT 18 Feb 2008 5:31 PM ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
 ;
 D HOME^%ZIS
 W:$D(IOF) @IOF
 W !!,"Checking for Taxonomies to support the 2009 CMS Report. ",!,"Please enter the device for printing.",!
ZIS ;
 S XBRC="",XBRP="TAXCHK^BGP9CTXC",XBNS="",XBRX="XIT^BGP9CTXC"
 D ^XBDBQUE
 D XIT
 Q
TAXCHK ;EP
 ;D HOME^%ZIS
 K BGPQUIT
GUICHK ;EP
 W !,"Checking for Taxonomies to support the CMS Report...",!
 NEW A,BGPX,I,Y,Z,J,BGPY,BGPT,BGPI,BGPM
 K A
 ;version 8.0
 I $D(BGPPLSTL) D THISRPT Q
 S BGPT="" F  S BGPT=$O(^BGPTAXN("B",BGPT)) Q:BGPT=""  D
 .S BGPY=$O(^BGPTAXN("B",BGPT,0))
 .Q:'$D(^BGPTAXN(BGPY,12,"B",5))
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
 W !!,"In order for the CMS Report to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S BGPX="" F  S BGPX=$O(A(BGPX)) Q:BGPX=""!($D(BGPQUIT))  D
 .I $Y>(IOSL-2) D PAGE Q:$D(BGPQUIT)
 .W !,$P(A(BGPX),U)," [",BGPX,"] ",$P(A(BGPX),U,2)
 .Q
DONE ;
 K BGPQUIT
 Q:$D(ZTQUEUED)
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of taxonomy check.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
THISRPT ;
 S BGPI=0 F  S BGPI=$O(BGPPLSTL(BGPI)) Q:BGPI'=+BGPI  D
 .S BGPM=0 F  S BGPM=$O(BGPPLSTL(BGPI,BGPM)) Q:BGPM'=+BGPM  D
 ..S BGPY=0 F  S BGPY=$O(^BGPCMSMN(BGPI,11,"B",BGPY)) Q:BGPY'=+BGPY  D
 ...S BGPTYPE=$P(^BGPTAXN(BGPY,0),U,2),Y=$G(^BGPTAXN(BGPY,11,1,0)),BGPT=$P(^BGPTAXN(BGPY,0),U)
 ...I BGPTYPE'="L" D
 ....I '$D(^ATXAX("B",BGPT)) S A(BGPT)=Y_"^is Missing" Q
 ....S I=$O(^ATXAX("B",BGPT,0))
 ....I '$D(^ATXAX(I,21,"B")) S A(BGPT)=Y_"^has no entries "
 ...I BGPTYPE="L" D
 ....I '$D(^ATXLAB("B",BGPT)) S A(BGPT)=Y_"^is Missing " Q
 ....S I=$O(^ATXLAB("B",BGPT,0))
 ....I '$D(^ATXLAB(I,21,"B")) S A(BGPT)=Y_"^has no entries "
 I '$D(A) W !,"All taxonomies are present.",! K A,BGPX,Y,I,Z D DONE Q
 W !!,"In order for the CMS Report to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S BGPX="" F  S BGPX=$O(A(BGPX)) Q:BGPX=""!($D(BGPQUIT))  D
 .I $Y>(IOSL-2) D PAGE Q:$D(BGPQUIT)
 .W !,$P(A(BGPX),U)," [",BGPX,"] ",$P(A(BGPX),U,2)
 .Q
XIT ;EP
 K BGP,BGPX,BGPQUIT,BGPLINE,BGPJ,BGPX,BGPTEXT,BGP
 K X,Y,J
 Q
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT="" Q
 Q
TAXS ;
 ;;BGP CMS AMI DXS
 ;;DM AUDIT ASPIRIN DRUGS
 ;;BGP CMS WARFARIN MEDS
 ;;BGP ANTI-PLATELET DRUGS
 ;;BGP CMS ANTI-PLATELET CLASS
 ;;BGP CMS LVSD DXS
 ;;BGP CMS EJECTION FRACTION PROC
 ;;BGP CMS EJECTION FRACTION CPTS
 ;;BGP CMS ACEI MEDS CLASS
 ;;BGP CMS ACEI MEDS
 ;;BGP ASA ALLERGY 995.0-995.3
 ;;BGP CMS AORTIC STENOSIS DXS
 ;;BGP CMS ARB MEDS CLASS
 ;;BGP CMS ARB MEDS
 ;;BGP CMS BETA BLOCKER MEDS
 ;;BGP CMS BETA BLOCKER CLASS
 ;;BGP CMS BETA BLOCKER NDC
 ;;BGP CMS BRADYCARDIA DXS
 ;;BGP CMS 2/3 HEART BLOCK DXS
 ;;BGP CMS HEART FAILURE DXS
 ;;BGP CMS CIRCULATORY SHOCK DXS
 ;;BGP CMS PNEUMONIA DXS
 ;;BGP CMS SEPTI/RESP FAIL DXS
 ;;BGP CMS ABG CPTS
 ;;BGP CMS ANTIBIOTIC MEDS
 ;;BGP CMS ANTIBIOTICS MEDS CLASS
 ;;
LAB ;
 ;;BGP CMS ABG TESTS
 ;;
