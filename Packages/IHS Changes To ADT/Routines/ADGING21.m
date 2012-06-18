ADGING21 ; IHS/ADC/PDW/ENM - INPATIENT > 21 DAYS ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- entry point
 N DIR S DIR(0)="NO",DIR("A")="Enter number of Days"
 S DIR("?")="What is the minimum length of stay for this report?"
 D ^DIR I $D(DIRUT) D Q Q
 S DGND=Y
 I DGND[U D Q Q
 I DGND="" D Q Q
 G:'DGND A
 D ZIS G:POP!($D(IO("Q"))) Q
 D DT,LP,Q
 Q
QUE ; -- queued entry point
 D DT,LP,Q
 Q
ZIS ; -- device selection
 S %ZIS="PQ"
 D ^%ZIS Q:POP
 I $D(IO("Q")) D TM
 Q
DT ; -- date (today - 21 days)
 N X1,X2,X
 S X1=DT,X2=-DGND D C^%DTC S DGZDT=X
 Q
LP ; -- loop inpatient by ward
 N WRD,DFN,ADM,TOT
 U IO S DGSTOP="",DGPG=0
 S (WRD,DFN,ADM)="",TOT=0 D HDH
 F  S WRD=$O(^DPT("CN",WRD)) Q:WRD=""!(DGSTOP=U)  D
 . F  S DFN=$O(^DPT("CN",WRD,DFN)) Q:'+DFN!(DGSTOP=U)  D
 .. S ADM=^DPT("CN",WRD,DFN)
 .. I +^DGPM(ADM,0)<DGZDT S TOT=TOT+1 D WRT
 Q:DGSTOP=U
 W !!,"Total: ",TOT,!!
 Q
WRT ; -- print patient info
 N X,X1,X2,Y
 I $Y>(IOSL-4) D NEWPG Q:DGSTOP=U
 W !,$E($P(^DPT(DFN,0),U),1,25)                        ;name
 W ?27,$J($P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2),9)     ;HRCN
 S X1=DT,X2=$P(^DPT(DFN,0),U,3) D ^%DTC S X=X\365.25
 W ?37,$J(X,3)                                         ;age
 W ?42,$E(WRD,1,5)                                     ;ward
 S Y=+^DGPM(ADM,0) X ^DD("DD")
 W ?48,$P(Y,",",1)                                     ;admission date
 S X1=DT,X2=+^DGPM(ADM,0) D ^%DTC W ?57,X             ;los
 W ?63,$E($P(^AUPNPAT(DFN,11),U,18),1,12)              ;community
 W ?76,$E($P(^DIC(45.7,^DPT(DFN,.103),0),U),1,3)       ;service
 Q
HDH ; -- heading
 N X,Y
 I DGPG>0!(IOST["C-") W @IOF
 S DGPG=DGPG+1
 W !,"PATIENTS WITH ",DGND," INPATIENT DAYS OR MORE"
 D NOW^%DTC S Y=X X ^DD("DD")
 W ?65,Y
 W !?5,"NAME",?31,"HRCN",?37,"AGE",?42,"WARD",?48,"ADM DT"
 W ?57,"LOS",?63,"COMMUNITY",?76,"SRV"
 S X="",$P(X,"-",IOM)=""
 W !,X
 Q
 ;
NEWPG ; -- end of page control
 I IOST["C-" K DIR S DIR(0)="E" D ^DIR S DGSTOP=X Q:X=U
 D HDH Q
 ;
TM ; -- tasked output
 S ZTRTN="QUE^ADGING21",ZTIO=ION,ZTDESC="INPATIENTS > 21 DAYS"
 S ZTSAVE("DGND")="" D ^%ZTLOAD
 Q
Q ; -- cleanup
 I $G(DGSTOP)="",IOST["C-" D PRTOPT^ADGVAR
 D ^%ZISC D HOME^%ZIS
 K DGND,DGZDT,DGSTOP,DGPG,DIRUT Q
