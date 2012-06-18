ADGCRBL1 ; IHS/ADC/PDW/ENM - CODED A SHEETS (CALC) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> initialize variables
 K ^TMP("DGZCRBL",$J)
 ;
 ;***> find visits by date and then by patient name
 ;
 S DGZDDT=DGZBDT-.0001
VST S DGZDDT=$O(^AUPNVINP("B",DGZDDT))
 G NEXT:DGZDDT="",NEXT:DGZDDT>(DGZEDT+.2359) S DGZIDFN=0
VST1 S DGZIDFN=$O(^AUPNVINP("B",DGZDDT,DGZIDFN)) G VST:DGZIDFN=""
 ;
 G VST1:'$D(^AUPNVINP(DGZIDFN,0)) S DGZVDFN=$P(^(0),U,3)
 G VST1:$P(^AUPNVINP(DGZIDFN,0),U,15)'="" ;check coded flag
 G VST1:'$D(^AUPNVSIT(DGZVDFN,0)) S DGSTR=^(0)
 G VST1:$P(DGSTR,U,11)'=""  ;screen out deleted visits
 G VST1:$P(DGSTR,U,6)'=DUZ(2)  ;screen out other facilities
 ;
 S DFN=$P(DGSTR,U,5),DGZNAME=$P(^DPT(DFN,0),U)
 S DGZVDT=$P(DGSTR,U)
 ;***> set ^utility with data
 S ^TMP("DGZCRBL",$J,$P(DGZDDT,"."),DGZNAME,DFN,DGZIDFN)=DGZVDFN_U_DGZVDT G VST1
 ;
NEXT G ^ADGCRBL2  ;go to print rtn
