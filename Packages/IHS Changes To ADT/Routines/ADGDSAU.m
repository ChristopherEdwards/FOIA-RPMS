ADGDSAU ; IHS/ADC/PDW/ENM - DAY SURGERY AUDIT REPORT ; [ 06/19/2000  10:43 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;**5**;MAR 25, 1999
 ;
 I '$D(DGOPT) D VAR^ADGVAR  ;ADT site parameter variables
 W @IOF,!!!?28,"DAY SURGERY AUDIT REPORT",!!
BDATE S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
EDATE S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT
 G END:Y=-1 S DGEDT=Y
 W !!,"Report uses 132 columns; use wide printer or condensed print!"
 S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G CALC
QUE K IO("Q") S ZTRTN="CALC^ADGDSAU",ZTDESC="DAY SURG AUDIT"
 S ZTSAVE("DGBDT")="",ZTSAVE("DGEDT")="",ZTSAVE("DGOPT(")=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
END K Y,DGBDT,DGEDT D HOME^%ZIS Q
 ;
 ;
CALC ;***> set up sorted Utility file for date range
 ;***> loop thru file by surgery date
 S DGDT=DGBDT-.0001,DGEDT=DGEDT+.2400 K ^TMP("DGDSAU",$J)
 S DGX=DGDT ;IHS/DSD/ENM 06/19/2000
C1 S DGDT=$O(^ADGDS("AA",DGDT)) G NEXT:DGDT="",NEXT:DGDT>DGEDT S DFN=0
C2 S DFN=$O(^ADGDS("AA",DGDT,DFN)) G C1:DFN="" S DGDFN1=0
C3 S DGDFN1=$O(^ADGDS("AA",DGDT,DFN,DGDFN1)) G C2:DGDFN1=""
 ;
 G C3:'$D(^ADGDS(DFN,0)),C3:'$D(^ADGDS(DFN,"DS",DGDFN1,0)) S DGSTR=^(0)
 S (AGE,DGPRC,DGSRV,DGOBS,DGADM,DGADWK,DGCAN,DGUNES,DGNM,DGNS,DGCMT)=""
 S DGNM=$P(^DPT(DFN,0),U)      ;patient name
 S DGCHT=$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^(0),U,2),1:"??") ;chrt
 S AGE=$$VAL^XBDIQ1(9000001,DFN,1102.99)
 S DGPRC=$P(DGSTR,U,2),DGSRV=$P(DGSTR,U,5)   ;procedure/service
 S DGLOS=$$VAL^XBDIQ1(9009012.01,"DFN,DGDFN1",8) ;length of stay
 S DGOBS=$$VAL^XBDIQ1(9009012.01,"DFN,DGDFN1",10) ;los in observ
 S:DGSRV'="" DGSRV=$S($D(^DIC(45.7,DGSRV,0)):$P(^(0),U),1:DGSRV)  ;srv
 S DGSTR2=$G(^ADGDS(DFN,"DS",DGDFN1,2)),DGADM=$P(DGSTR2,U,2)  ;admitted?
 S DGCAN=$P(DGSTR2,U,3),DGNS=$P(DGSTR2,U,4)  ;cancel?/no-show?
 S DGUNES=$P(DGSTR2,U,5),DGCMT=$P(DGSTR2,U,6)  ;unescorted?/comments
 G C4:DGADM'="Y" S X=DGDT-.0001,DGADM="??"  ;no admission found
 ;
 ;***> find if patient admitted w/in time limit for day surgery
 S DGREL=$S($D(DGSTR2):$P(DGSTR2,U),1:"")
 S DGX1=$S(DGREL'="":DGREL,1:DGDT)
 F  S DGX=$O(^DGPM("AMV1",DGX)) Q:DGX=""  Q:DGX>(DGX1+1)  I $D(^DGPM("AMV1",DGX,DFN)) S DGY=$O(^DGPM("AMV1",DGX,DFN,0)),DGADM=$P(^DGPM(DGY,0),U) Q
 G C5
C4 S Y=9999999-DGDT,X1=$P(DGDT,"."),X2=$P(DGOPT("QA1"),U,2) D C^%DTC
 S DGX=9999999-X,DGX=$O(^DGPM("ATID1",DGX))
 I DGX'="",DGX'>Y S DGADWK=9999999-DGX
 ;
 ;***> set utility file to sort by date, service, name
C5 S ^TMP("DGDSAU",$J,$P(DGDT,"."),DGSRV,DGNM,DFN,DGDFN1)=DGCHT_U_AGE_U_DGPRC_U_DGLOS_U_DGOBS_U_DGADM_U_DGADWK_U_DGCAN_U_DGUNES_U_DGNS_U_DGCMT G C3
 ;
NEXT G ^ADGDSAU1
