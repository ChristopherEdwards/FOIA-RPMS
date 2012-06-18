ADGCEN0 ; IHS/ADC/PDW/ENM - CENSUS AID-LIST BY WARD ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> initialize variables
 S DGPAGE=0,DGSITE=$P(^DIC(4,DUZ(2),0),U),DGDUZ=$P(^VA(200,DUZ,0),U,2)
 S DGTL=$P(^DIC(42,DGWD,0),U)_" WARD"
 D HEAD
 ;
 ;***> loop thru adt census-ward file by date
 S DGDT=DGBDT-.0001
DT1 S DGDT=$O(^ADGWD(DGWD,1,DGDT)) G END:DGDT="",END:DGDT>DGEDT
 ;
 I '$D(^ADGWD(DGWD,1,DGDT,0)) D  G END
 .W !!,"NO CENSUS DATA FOR THIS WARD FOR "
 .W $E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3),!! Q
 ;
 S DGSTR=^ADGWD(DGWD,1,DGDT,0)
 W !,$E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3)  ;date
 ;W ?17,$P(DGSTR,U,3),?27,$P(DGSTR,U,5)  ;admits & transfers in
 ;W ?37,$P(DGSTR,U,6),?48,$P(DGSTR,U,4)  ;transfers out & discharges
 ;W ?58,$P(DGSTR,U,7),?69,$P(DGSTR,U,2)  ;deaths and # remaining
 W ?17,$P(DGSTR,U,3)+$P(DGSTR,U,13),?27,$P(DGSTR,U,5)+$P(DGSTR,U,15)
 W ?37,$P(DGSTR,U,6)+$P(DGSTR,U,16),?48,$P(DGSTR,U,4)+$P(DGSTR,U,14)
 W ?58,$P(DGSTR,U,7)+$P(DGSTR,U,17),?69,$P(DGSTR,U,2)+$P(DGSTR,U,12)
 I $Y>(IOSL-6) D NEWPG G END1:DGSTOP=U
 G DT1
 ;
END I IOST["C-" K DIR S DIR(0)="E" D ^DIR
END1 W @IOF K DGBDT,DGEDT,DGDT,DGWD,DGPAGE,DGSITE,DGLIN,DGX
 K DGDUZ,DGTL,DGSTR,DGSTOP,DGTYP,X,Y,DIR D ^%ZISC Q
 ;
NEWPG ;***> subrtn for end of page control
 I IOST'?1"C-".E D HEAD S DGSTOP="" Q
 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 I DGSTOP'=U D HEAD
 Q
 ;
HEAD ;***> subrtn to print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 S DGPAGE=DGPAGE+1 W !,DGDUZ,?80-$L(DGSITE)/2,DGSITE
 W ! D TIME^ADGUTIL W ?28,"ADT WARD CENSUS DATA FOR"
 S Y=DT X ^DD("DD") W !,Y
 W ?80-$L(DGTL)/2,DGTL,?70,"Page: ",DGPAGE
 S DGLIN="",$P(DGLIN,"=",80)="" W !,DGLIN
 W !,"Date",?15,"Admits",?25,"Trans In",?35,"Trans Out"
 W ?46,"Disch",?55,"Deaths",?65,"Remaining"
 S DGLIN="",$P(DGLIN,"-",80)="" W !,DGLIN,!
 Q
