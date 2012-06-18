ACHSC6Q ; IHS/ITSC/PMF - QUE CHS EXPENDITURE REPORT ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;
BDT ; Enter beginning date.
 S ACHSBDT=$$DATE^ACHS("B","CHS EXPENDITURE")
 G K:$D(DUOUT)!$D(DTOUT)!(ACHSBDT<1)
 S %DT="F"
 F X=ACHSBDT:1 S Y=X D ^%DT I +Y<1 S X=X-1 Q
 S ACHSEMON=$$FMTE^XLFDT(X)
EDT ; Enter ending date.
 S ACHSEDT=$$DIR^XBDIR("D","Enter The ENDING Date for The CHS EXPENDITURE Report",ACHSEMON)
 G K:$D(DTOUT),BDT:$D(DUOUT)
REPORT ; Select pt/comm/age.
 W !!,"Print Report by: ",!?3,"1. By Patient",!?3,"2. By Community of Residence",!?3,"3. By Age Grouping",!?3,"4. Totals Only",!?3,"5. By Tribe",!!?5,"Enter 1 to 5  1// "
 D READ^ACHSFU
 G K:$D(DTOUT),EDT:$D(DUOUT),REPORT:Y?1"?".E
 I Y="" S ACHSRPT=1 G TYPE
 I (Y<1)!(Y>5) W !,*7 G REPORT
 S ACHSRPT=Y
TYPE ; Select in/dent./out/all.
 W !!,"Want Expenditure Report by ",$S(ACHSRPT=1:"Patient",ACHSRPT=2:"Community of Residence",1:"Age Grouping")," for: ",!!?5,"1.  Inpatient Services",!?5,"2.  Dental Services",!?5,"3.  Outpatient Serices",!?5,"4.  All Services",!
 W !,"Enter 1 thru 4   ALL// "
 D READ^ACHSFU
 G K:$D(DTOUT),REPORT:$D(DUOUT),TYPE:Y?1"?".E
 I Y="" S ACHSRPT1=4 G DEV
 I (Y<1)!(Y>4) W !,*7 G TYPE
 S ACHSRPT1=Y
DEV ; Select device.
 S %=$$PB^ACHS
 I %=U!$D(DTOUT)!$D(DUOUT) D K Q
 I %="B" D VIEWR^XBLM($S(ACHSRPT=3:"^ACHSC6D",1:"^ACHSC6C")),EN^XBVK("VALM"),K Q
 S %ZIS="OPQ"
 D ^%ZIS
 I POP D HOME^%ZIS G K
 G:'$D(IO("Q")) ^ACHSC6D:ACHSRPT=3,^ACHSC6C
 K IO("Q")
 I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 S ZTRTN=$S(ACHSRPT=3:"^ACHSC6D",1:"^ACHSC6C"),ZTIO="",ZTDESC="CHS EXPENDITURE REPORT #"_ACHSRPT_", "_$$FMTE^XLFDT(ACHSBDT)_" to "_$$FMTE^XLFDT(ACHSEDT),ACHSQIO=ION_";"_IOST_";"_IOM_";"_IOSL
 F %="ACHSQIO","ACHSBDT","ACHSEDT","ACHSRPT","ACHSRPT1" S ZTSAVE(%)=""
 D ^%ZTLOAD
 G:'$D(ZTSK) DEV
K ; Kill vars, close device, quit.
 D EN^XBVK("ACHS"),^ACHSVAR
 K ZTIO,ZTSK
 D ^%ZISC
 Q
 ;
