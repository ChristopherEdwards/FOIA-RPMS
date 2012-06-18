BGP0XTCH ; IHS/CMI/LAB - TAXONOMY CHECK FOR FY04 CRS REPORT 16 Jan 2009 4:02 PM ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
 ;
 D HOME^%ZIS
 W:$D(IOF) @IOF
 W !!,"Checking for Taxonomies to support the 2010 CRS Report. ",!,"Please enter the device for printing.",!
ZIS ;
 K IOP,%ZIS
 W !! S %ZIS="PQM" D ^%ZIS
 I POP D XIT Q
ZIS1 ;
 I $D(IO("Q")) G TSKMN
DRIVER ;
 U IO
 D TAXCHK^BGP0XTCH
 D ^%ZISC
 D XIT
 Q
 ;
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="TAXCHK^BGP0XTCH",ZTDTH="",ZTDESC="CRS 09 TAX REPORT" D ^%ZTLOAD D XIT Q
 Q
TAXCHK ;EP
 ;D HOME^%ZIS
 K BGPQUIT
GUICHK ;EP
 W !,"Checking for Taxonomies to support the Selected Measures Report",!
 NEW A,BGPX,I,Y,Z,J,BGPY,BGPT
 K A
 ;S T="TAXS" F J=1:1 S Z=$T(@T+J),BGPX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BGPX=""  D
 S BGPT="" F  S BGPT=$O(^BGPTAXT("B",BGPT)) Q:BGPT=""  D
 .S BGPY=$O(^BGPTAXT("B",BGPT,0))
 .Q:'$D(^BGPTAXT(BGPY,12,"B",2))
 .;I $P(^BGPTAXT(BGPY,0),U,2)'="L" S BGPX=$O(^ATXAX("B",BGPT,0))
 .;I $P(^BGPTAXT(BGPY,0),U,2)="L" S BGPX=$O(^ATXLAB("B",BGPT,0))
 .S BGPTYPE=$P(^BGPTAXT(BGPY,0),U,2),Y=$G(^BGPTAXT(BGPY,11,1,0))
 .I BGPTYPE'="L" D
 ..I '$D(^ATXAX("B",BGPT)) S A(BGPT)=Y_"^is Missing" Q
 ..S I=$O(^ATXAX("B",BGPT,0))
 ..I '$D(^ATXAX(I,21,"B")) S A(BGPT)=Y_"^has no entries "
 .I BGPTYPE="L" D
 ..I '$D(^ATXLAB("B",BGPT)) S A(BGPT)=Y_"^is Missing " Q
 ..S I=$O(^ATXLAB("B",BGPT,0))
 ..I '$D(^ATXLAB(I,21,"B")) S A(BGPT)=Y_"^has no entries "
 I '$D(A) W !,"All taxonomies are present.",! K A,BGPX,BGPT,BGPY,Y,I,Z D DONE Q
 W !!,"In order for the CRS Report to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S BGPX="" F  S BGPX=$O(A(BGPX)) Q:BGPX=""!($D(BGPQUIT))  D
 .;I $Y>(IOSL-2) D PAGE Q:$D(BGPQUIT)
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
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT="" Q
 Q
