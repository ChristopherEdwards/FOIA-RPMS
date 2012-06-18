ADGADSP2 ; IHS/ADC/PDW/ENM - A & D SHEET-DAY SURGERY (DETAILED) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> detailed version of A & D SHEET (Day Surgery section)
 ;
 S DGDSD=DGDATE-.0001,DGDAYCT=0 ;loop thru by date/time
A1 S DGDSD=$O(^ADGDS("AA",DGDSD)) G A4:DGDSD="",A4:DGDSD'<(DGDATE_".9999")
 S DFN=0  ;witin date/time loop thru by patient to find surgery entry
A2 S DFN=$O(^ADGDS("AA",DGDSD,DFN)) G A1:DFN="" S DGDSN=0
A3 S DGDSN=$O(^ADGDS("AA",DGDSD,DFN,DGDSN)) G A2:DGDSN=""
 ;
 G A3:'$D(^ADGDS(DFN,"DS",DGDSN,0)) S DGSTR=^(0)
 S DGVLG=$$VAL^XBDIQ1(9000001,DFN,1118) ;community
 S AGE=$$VAL^XBDIQ1(9000001,DFN,1102.98)
 S DGPR=$$VAL^XBDIQ1(200,+$P(DGSTR,U,6),.01)  ;provider
 S DGSER=$$VAL^XBDIQ1(45.7,+$P(DGSTR,U,5),.01)
 S DGDS(DFN)=DGPR_U_AGE_U_DGSER_U_DGVLG
 S DGDAYCT=DGDAYCT+1  ;increment count
 G A3  ;print data and return for more
 ;
A4 ;
 S X="SRZPEP" X ^%ZOSF("TEST") I $T D ADS^SRZPEP("D")
 G END:DGDAYCT=0  ;skip if none for date
 W !!,"DAY SURGERIES:",!
 S DFN=0 F  S DFN=$O(DGDS(DFN)) Q:'DFN  D WRITE
 W !!,"TOTAL DAY SURGERIES: ",DGDAYCT
 ;
END G END1^ADGADSP1
 ;
WRITE ;***> subrtn to print each line
 S DGNM=$P(^DPT(DFN,0),U)  ;patient name
 W !?10,$E(DGNM,1,24)
 S DGCHT=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2),DGCHT="00000"_DGCHT
 S DGCHTX=$E(DGCHT,$L(DGCHT)-5,$L(DGCHT))
 W ?37,$E(DGCHTX,1,2)_"-"_$E(DGCHTX,3,4)_"-"_$E(DGCHTX,5,6)
 W ?47,$E($P(DGDS(DFN),U),1,21),?71,$P(DGDS(DFN),U,2) ;provider & age
 W ?80,$E($P(DGDS(DFN),U,3),1,3),?90,$P(DGDS(DFN),U,4) ;srv&community
 D:$Y>(IOSL-5) NEWPG^ADGADSP1
W9 Q
