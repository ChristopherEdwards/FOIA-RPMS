BGP8XTEO ; IHS/CMI/LAB - TAXONOMY CHECK FOR FY04 CRS REPORT ;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
 D HOME^%ZIS
 W:$D(IOF) @IOF
 W !!,"Checking for Taxonomies to support the 2008 Executive Order Report. ",!,"Please enter the device for printing.",!
ZIS ;
 S XBRC="",XBRP="TAXCHK^BGP8XTEO",XBNS="",XBRX="XIT^BGP8XTEO"
 D ^XBDBQUE
 D XIT
 Q
TAXCHK ;EP
 ;D HOME^%ZIS
 K BGPQUIT
GUICHK ;EP
 W !,"Checking for Taxonomies to support the Executive Order Report...",!
 NEW A,BGPX,I,Y,Z,J,BGPY,BGPT
 K A
 ;S T="TAXS" F J=1:1 S Z=$T(@T+J),BGPX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BGPX=""  D
 S BGPT="" F  S BGPT=$O(^BGPTAXE("B",BGPT)) Q:BGPT=""  D
 .S BGPY=$O(^BGPTAXE("B",BGPT,0))
 .Q:'$D(^BGPTAXE(BGPY,12,"B",8))  ;8 IS SET OF CODES FOR EO REPORT
 .;I $P(^BGPTAXE(BGPY,0),U,2)'="L" S BGPX=$O(^ATXAX("B",BGPT,0))
 .;I $P(^BGPTAXE(BGPY,0),U,2)="L" S BGPX=$O(^ATXLAB("B",BGPT,0))
 .S BGPTYPE=$P(^BGPTAXE(BGPY,0),U,2),Y=$G(^BGPTAXE(BGPY,11,1,0))
 .I BGPTYPE'="L" D
 ..I '$D(^ATXAX("B",BGPT)) S A(BGPT)=Y_"^is Missing" Q
 ..S I=$O(^ATXAX("B",BGPT,0))
 ..I '$D(^ATXAX(I,21,"B")) S A(BGPT)=Y_"^has no entries "
 .I BGPTYPE="L" D
 ..I '$D(^ATXLAB("B",BGPT)) S A(BGPT)=Y_"^is Missing " Q
 ..S I=$O(^ATXLAB("B",BGPT,0))
 ..I '$D(^ATXLAB(I,21,"B")) S A(BGPT)=Y_"^has no entries "
 I '$D(A) W !,"All taxonomies are present.",! K A,BGPX,Y,I,Z D DONE Q
 W !!,"In order for the EO CRS Report to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
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
