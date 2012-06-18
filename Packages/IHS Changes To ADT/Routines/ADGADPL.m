ADGADPL ; IHS/ADC/PDW/ENM - AVERAGE DAILY PATIENT LOAD BY WARD ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***>  setup for print
 W @IOF,!!!?18,"AVERAGE DAILY PATIENT LOAD BY WARD OR SERVICE",!!
 ;
SELECT ; -- have user select report by ward or by service
 W !! K DIR S DIR(0)="SO^1:By WARD;2:By SERVICE"
 S DIR("A")="Select report format (by number)" D ^DIR
 G END:Y<1,END:Y>2 S DGFORM=Y
 ;
BDATE ; -- ask users for beginning date
 W ! S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT
 G SELECT:Y=-1 S DGBDT=Y
EDATE ; -- ask user for ending date
 S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT
 G BDATE:Y=-1 S DGEDT=Y
 ;
DEV ; -- ask user for printing device
 S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G CALC
QUE K IO("Q") S ZTRTN="CALC^ADGADPL",ZTDESC="AVERAGE DAILY PATIENT LOAD"
 F I="DGBDT","DGEDT","DGFORM" S ZTSAVE(I)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
END K Y,DGBDT,DGEDT,DGFORM D HOME^%ZIS Q
 ;
 ;
CALC ;EP; -- calculate of ADPL
 I DGFORM=1 D  D PRINT Q
 . S DGW=0 ;step thru ADT Census-Ward file for date range
 . F  S DGW=$O(^ADGWD(DGW)) Q:DGW'=+DGW  D
 .. S DGWN=$P(^DIC(42,DGW,0),U)
 .. I $G(^DIC(42,DGW,"I"))="I" S DGWN=DGWN_"  **INACTIVE**"
 .. S DGD=DGBDT-.001
 .. F  S DGD=$O(^ADGWD(DGW,1,DGD)) Q:DGD>DGEDT  Q:DGD=""  D
 ... S X=$P($G(^ADGWD(DGW,1,DGD,0)),U,2)+$P($G(^(0)),U,12)
 ... S DGA(DGWN)=$G(DGA(DGWN))+X
 ;
 S DGW=0 ;step thru ADT Census-Treating Specialty file by date
 F  S DGW=$O(^ADGTX(DGW)) Q:DGW'=+DGW  D
 . S DGWN=$P(^DIC(45.7,DGW,0),U)
 . I $P(^DIC(45.7,DGW,9999999),U,3)="" S DGWN=DGWN_"  **INACTIVE**"
 . S DGD=DGBDT-.001
 . F  S DGD=$O(^ADGTX(DGW,1,DGD)) Q:DGD>DGEDT  Q:DGD=""  D
 .. S X=$P($G(^ADGTX(DGW,1,DGD,0)),U,2),Y=$P($G(^ADGTX(DGW,1,DGD,1)),U)
 .. S DGA(DGWN)=$G(DGA(DGWN))+X+Y
 ;
PRINT ;***> Print report
 ;
 ;initialize variables
 S DGPAGE=0,DGDUZ=$P(^VA(200,DUZ,0),U,2)     ;page#/user initials
 S DGFAC=$P(^DIC(4,DUZ(2),0),U),DGSTOP=""   ;facility
 S (DGLIN,DGLIN1)="",$P(DGLIN,"=",80)="",$P(DGLIN1,"-",80)="" ;line
 S DGDTLIN="from "_$E(DGBDT,4,5)_"/"_$E(DGBDT,6,7)_"/"_$E(DGBDT,2,3)_" to "_$E(DGEDT,4,5)_"/"_$E(DGEDT,6,7)_"/"_$E(DGEDT,2,3)  ;date range
 ;
 S X1=DGEDT,X2=DGBDT D ^%DTC S DGL=X+1
 D HEAD S (DGW,DGT,DGAT)=0
 F  S DGW=$O(DGA(DGW)) Q:DGW=""  Q:DGSTOP=U  D
 . I $Y>(IOSL-5) D NEWPG Q:DGSTOP=U
 . I DGW["INACTIVE",DGA(DGW)=0 Q  ;don't prnt inact wards w/no activity
 . W !!?5,DGW   ;print ward or service name
 . S DGAV=DGA(DGW)/DGL,DGAV=DGAV_".00"  ;calculate adpl
 . S DGT=DGT+DGA(DGW),DGAT=DGAT+DGAV
 . W ?45,$J(DGA(DGW),3),?60,$J(DGAV,5,2),!
 G END2:DGSTOP=U
 W !,DGLIN1,!?10,"TOTAL:",?45,$J(DGT,3),?60,$J(DGAT,5,2),!
 ;
 ;***>  eoj
END1 I IOST["C-" D PRTOPT^ADGVAR
END2 D KILL^ADGUTIL W @IOF D ^%ZISC Q
 ;
 ;
NEWPG ;***>  end of page control
 I IOST'?1"C-".E D HEAD S DGSTOP="" Q
 I DGPAGE>0 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 I DGSTOP'=U D HEAD
 Q
 ;
HEAD ;***> print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 W DGDUZ,?80-$L(DGFAC)\2,DGFAC
 S DGPAGE=DGPAGE+1 W ?70,"Page ",DGPAGE
 W ! D TIME
 S X="AVERAGE DAILY PATIENT LOAD by "_$S(DGFORM=1:"WARD",1:"SERVICE")
 W ?80-$L(X)/2,X
 W !,$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3),?25,DGDTLIN,!!
 W ?5,$S(DGFORM=1:"WARD",1:"SERVICE"),?40,"INPATIENT DAYS",?60,"ADPL"
 W !!,DGLIN Q
 ;
TIME ; -- SUBRTN to print time
 N X S X=$E($$HTFM^XLFDT($H),1,12)
 W $P($$FMTE^XLFDT(X,"2P")," ",2,3)
 Q
