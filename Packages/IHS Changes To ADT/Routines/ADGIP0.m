ADGIP0 ; IHS/ADC/PDW/ENM - INPATIENT LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- driver
 D DEV I POP D Q Q
 I $D(IO("Q")) D QUE,Q Q
 D LPWD,^ADGIP1,Q Q
 ;
DEV ;--device selection
 W !!,"Paper margin must be at least 110" S %ZIS="PQ" D ^%ZIS Q
 ;
QUE ;--queued output
 K IO("Q")  S ZTRTN="LPWD^ADGIP0",ZTDESC="INPATIENT LIST"
 D ^%ZTLOAD,^%ZISC K ZTSK  Q
 ;
Q ; -- cleanup
 K DIR,DA,DR,DGDT,Y,X,ZTSK
 D HOME^%ZIS  Q
 ;
LPWD ;--loop ward
 N WARD,DFN
 K ^TMP("DGZINP",$J)
 S WARD="",DGCNT=0 F  S WARD=$O(^DPT("CN",WARD)) Q:WARD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WARD,DFN)) Q:'DFN  D 1
 Q
 ;
1 ;
 N IFN,NAME,TS,COM,UTL
 S IFN=^DPT("CN",WARD,DFN),DGDT=$P($P(^DGPM(IFN,0),U),".",1)
 S NAME=$P($G(^DPT(DFN,0)),U),TS=$G(^(.103))
 S COM=$P($G(^AUPNPAT(DFN,11)),U,18)
 ;--utility node
 S UTL=DGDT_U_$$AGE_U_WARD_U_TS_U_COM_U_$$HRCN^ADGF_U_$$MCR_U_$$MCD
 S ^TMP("DGZINP",$J,NAME,DFN)=UTL,DGCNT=DGCNT+1
 Q
 ;
MCR() ; -- medicare number & suffix
 N X S X=$G(^AUPNMCR(DFN,0)) Q $P(X,U,3)_$G(^AUTTMCS(+$P(X,U,4),0))
 ;
MCD() ; -- medicaid #
 Q $P($G(^AUPNMCD(+$O(^AUPNMCD("B",DFN,0)),0)),U,3)
 ;
AGE() ; -- age
 K ^UTILITY("DIQ1",$J) S DA=DFN,DR=1102.98,DIC=9000001 D EN^DIQ1
 S X=$G(^UTILITY("DIQ1",$J,9000001,DFN,1102.98)) K ^UTILITY("DIQ1",$J)
 Q $S($L(X)=5:" "_X,1:X)
