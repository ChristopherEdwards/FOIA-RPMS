ADGICAL ; IHS/ADC/PDW/ENM - INCOMPLETE CHARTS ALPHA LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF,!!!?20,"INCOMPLETE CHARTS ALPHA LIST",!!
 ;***> get date range
BDATE S %DT="AEQ",%DT("A")="Select FIRST Discharge Date in Range: ",X=""
 D ^%DT G END:Y=-1 S DGBDT=Y
EDATE S %DT="AEQ",%DT("A")="Select LAST Discharge Date in Range: ",X=""
 D ^%DT G END:Y=-1 S DGEDT=Y
 ;
SORT ; -- ask user for sort choice
 K DIR S DIR(0)="SO^1:Sort by PATIENT NAME;2:Sort by TERMINAL DIGIT"
 S DIR("A")="Select Choice for Sorting Report" D ^DIR
 G BDATE:$D(DIRUT) S DGSRT=Y
 ;
 ;***> get print device
 W !!,*7,"*** WARNING:  Report uses wide paper or condensed print!",!
 S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G CALC
QUE K IO("Q") S ZTRTN="CALC^ADGICAL",ZTDESC="INCOM ALPHA"
 F I="DGBDT","DGEDT","DGSRT" S ZTSAVE(I)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
END K Y,DGBDT,DGEDT D HOME^%ZIS Q
 ;
CALC ;***> Beginning of calculate
 K ^TMP("DGZICAL",$J)
 S DGCNT=0,DGEDT=DGEDT+.2400
 ;
 ;***> loop thru incomplete file by date
 S DGZDT=DGBDT-.0001
C1 S DGZDT=$O(^ADGIC("AB",DGZDT)) G NEXT:DGZDT="",NEXT:DGZDT>DGEDT
 S DFN=0  ;within date loop thru by patient
C2 S DFN=$O(^ADGIC("AB",DGZDT,DFN)) G C1:DFN=""
 S DGDFN1=0   ;within patient loop thru by admission
C3 S DGDFN1=$O(^ADGIC("AB",DGZDT,DFN,DGDFN1)) G C2:DGDFN1=""
 ;
 G C3:'$D(^ADGIC(DFN,"D",DGDFN1,0)) S DGSTR=^(0),DGNM=$P(^DPT(DFN,0),U)
 S DGCHT=$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^(0),U,2),1:"??")
 ;***> set utility file by patient name
 I DGSRT=1 S ^TMP("DGZICAL",$J,DGNM,DFN,DGDFN1)=DGCHT_U_DGSTR,DGCNT=DGCNT+1
 E  S ^TMP("DGZICAL",$J,$$TERMD,DFN,DGDFN1)=DGCHT_U_DGSTR,DGCNT=DGCNT+1
 G C3
 ;
NEXT G ^ADGICAL1
 ;
 ;
TERMD() ; -- returns terminal digit chart number
 NEW X
 S X=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2) I X="" Q "??"
 S X="00000"_X,X=$E(X,$L(X)-5,$L(X))
 Q $E(X,5,6)_$E(X,3,4)_$E(X,1,2)
