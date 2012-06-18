ADGDODC ; IHS/ADC/PDW/ENM - INPATIENT DEATHS LISTING(CALC) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 K ^TMP("DGZDOD",$J)
A ; -- driver
 D LP3,Q G ^ADGDODP
 ;
LP3 ;--loop discharges for specified date range
 S DGDT=DGBDT-.0001,DGED=DGEDT+.2400
 F  S DGDT=$O(^DGPM("AMV3",DGDT)) Q:'DGDT!(DGDT>DGED)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV3",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV3",DGDT,DFN,IFN)) Q:'IFN  D 3
 Q
 ;
3 ;
 N N,NAME,ID,CA,TS
 Q:'$D(^DPT(DFN,.35))  S N=$G(^DGPM(+IFN,0)) Q:$$DEATH
 S NAME=$P($G(^DPT(+DFN,0)),U),ID=9999999.9999999-DGDT,CA=$P(N,U,14)
 S TS=$$TS
 I DGTYP=1 S ^TMP("DGZDOD",$J,DGDT,NAME,DFN)=$$IHS_U_TS Q
 I DGTYP=2 S ^TMP("DGZDOD",$J,TS,DGDT,NAME,DFN)=$$IHS Q
 S ^TMP("DGZDOD",$J,NAME,DFN,DGDT)=$$IHS_U_TS
 Q
 ;
Q ; -- cleanup
 K IFN,DFN,DGED Q
 ;
DEATH() ; -- type of discharge death
 Q $S($$IHS<4&($$IHS<7):1,1:0)
 ;
IHS() ; -- ihs code type of discharge
 Q $G(^DG(405.1,+$P(N,U,4),"IHS"))
 ;
TS() ; -- discharge treating specialty
 Q $P($G(^DIC(45.7,+$O(^DGPM("ATS",DFN,CA,+$O(^DGPM("ATS",DFN,CA,ID)),0)),0)),U)
