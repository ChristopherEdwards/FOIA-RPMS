XBENHANC ; IHS/ADC/GTH - DISPLAY/PRINT ENHANCEMENTS FIELD IN PACKAGE FILE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Print enhancements to a package, from the entry in the
 ; PACKAGE file.  Entry point EN^XBENHANC(ns) is used, with
 ; the caller providing the namespace of the package.
 ;
EN(XB) ;PEP - XB = Namespace of package to print enhancements.
 Q:'($G(XB)]"")
 D HOME^%ZIS,DT^DICRW
DEV ;
 S %ZIS="OPQ"
 D ^%ZIS
 I POP S IOP=$I D ^%ZIS G K
 G:'$D(IO("Q")) START
 KILL IO("Q")
 I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 S ZTRTN="START^XBENHANC",ZTDESC=$P($P($T(XBENHANC),"-",2),";",2),ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL,ZTSAVE("XB")=""
 D ^%ZTLOAD
 G:'$D(ZTSK) DEV
K ;
 KILL ZTSK
 D ^%ZISC
 Q
 ;
START ;EP - TaskMan.
 NEW A,B,DIRUT,DIWL,DIWR,DIWF,XBHDR,XBPG
 S A=$O(^DIC(9.4,"C",XB,0))
 Q:'A
 Q:'$D(^DIC(9.4,A,"VERSION"))
 S B=$O(^DIC(9.4,A,22,"B",^DIC(9.4,A,"VERSION"),0))
 Q:'B
 S XBHDR="Enhancements to "_$P(^DIC(9.4,A,0),U)_", Version "_^DIC(9.4,A,"VERSION")
 KILL ^UTILITY($J,"W")
 S DIWL=5,DIWR=IOM-6,DIWF="W"
 U IO
 D TOF
 S %=0
 F  S %=$O(^DIC(9.4,A,22,B,1,%)) Q:'%   D DIWP(^(%,0)),TOF:$Y>(IOSL-6) Q:$D(DIRUT)
 D:'$D(DIRUT) ^DIWW
 KILL ^UTILITY($J,"W")
 D ^%ZISC
 Q
 ;
DIWP(X) ;
 NEW %,A,B
 D ^DIWP
 Q
 ;
TOF ;
 NEW %,A,B
 S XBPG=$G(XBPG)+1
 W !!
 I '$D(ZTQUEUED),'$D(IO("S")),IO=IO(0),$$DIR^XBDIR("E")
 Q:$D(DIRUT)
 W @IOF,!!,?DIWL-1,XBHDR,?(DIWR-$L("Page "_XBPG)-1),"Page ",XBPG,!?DIWL-1,$$REPEAT^XLFSTR("-",DIWR-DIWL),!!
 Q
 ;
