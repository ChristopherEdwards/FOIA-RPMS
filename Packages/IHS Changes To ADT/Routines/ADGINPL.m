ADGINPL ; IHS/ADC/PDW/ENM - PROVIDER-INPATIENT INQUIRY ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 N DGPRDA,DGPVN,DFN,X,Y
A ; -- driver
 D ^XBCLS W !!?20,"INPATIENT PROVIDER INQUIRY",!!
 D SP Q:Y'>0
 D LP G A
 ;
SP ; -- select provider
 S DIC=200,DIC(0)="AEQMZ",DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y))"
 S DIC("A")="Select PROVIDER:  " D ^DIC K DIC
 S DGPRDA=+Y,DGPVN=$P(Y,U,2) Q
 ;
LP ; -- loop APR (provider) x-ref of va patient file
 I '$D(^DPT("APR",DGPRDA)) D  Q
 . W !!,"  No inpatients currently assigned to this provider",!
 D HD S DFN=0 F  S DFN=$O(^DPT("APR",DGPRDA,DFN)) Q:'DFN  D
 . Q:'$D(^DPT(DFN,.104))  D LN
 W ! D PRTOPT^ADGVAR Q
 ;
LN ; -- patient information
 W !,$P(^DPT(DFN,0),U),?32,$$HRCN^ADGF,?45,$G(^DPT(DFN,.1))
 W ?53,$G(^DPT(DFN,.101))
 I $D(^DPT(DFN,.103)) W ?63,$P(^DIC(45.7,+^(.103),0),U)
 Q
 ;
HD ; -- heading
 W @IOF W !!,"CURRENT INPATIENTS FOR ",DGPVN,":",!
 W !,"PATIENT NAME",?32,"CHART #",?45,"WARD",?53,"RM-BD",?63,"SERVICE"
 W !,"------------",?32,"-------",?45,"----",?53,"-----",?63,"-------"
 Q
