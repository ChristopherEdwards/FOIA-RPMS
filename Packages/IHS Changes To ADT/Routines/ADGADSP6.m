ADGADSP6 ; IHS/ADC/PDW/ENM - A & D SHEET-DAY SURGERY (SUMMARY) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> Summary Format of ADMISSIONS & DISCHARGES SHEET
 ;***> day surgery patients
 ;
 S DGDSD=DGDATE-.0001,DGDAYCT=0  ;loop thru by date
A1 S DGDSD=$O(^ADGDS("AA",DGDSD)) G A4:DGDSD=""
 G A4:DGDSD'<(DGDATE_".9999")
 S DFN=0  ;within date loop by patient
A2 S DFN=$O(^ADGDS("AA",DGDSD,DFN)) G A1:DFN="" S DGDSN=0
A3 S DGDSN=$O(^ADGDS("AA",DGDSD,DFN,DGDSN)) G A2:DGDSN=""
 ;
 G A3:'$D(^ADGDS(DFN,"DS",DGDSN,0)) S DGZ=^(0)
 I $D(^ADGDS(DFN,"DS",DGDSN,2)) G A3:$P(^(2),U,3,4)["Y" ;noshow/cancel
 S X=$P(DGZ,U,5) S:X]"" X=$$VAL^XBDIQ1(45.7,X,.01) S DGDS(DFN)=X
 S DGDAYCT=DGDAYCT+1
 G A3
 ;
A4 ;
 S X="SRZPEP" X ^%ZOSF("TEST") I $T D ADS^SRZPEP("S")
 G END:DGDAYCT=0  ;skip if none for date
 W !!?6,"DAY SURGERY",!,DGLIN,! S DFN=0
 ;
 F  S DFN=$O(DGDS(DFN)) Q:DFN=""  D WRITE
 ;
END Q
 ;
WRITE ;***> subrtn to print each line
 S DGNM=$P(^DPT(DFN,0),U)  ;patient name
 S DGCHT=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)  ;chart #
 S DGCHT="00000"_DGCHT,DGCHT=$E(DGCHT,$L(DGCHT)-5,$L(DGCHT))
 S DGCHT=$E(DGCHT,1,2)_"-"_$E(DGCHT,3,4)_"-"_$E(DGCHT,5,6)
 W !,$E($P(DGDS(DFN),U),1,3),?5,DGCHT,"  ",$E(DGNM,1,20)
 S X=$P(DGDS(DFN),U,2) I X]"" W ?40,X
 I $Y>(IOSL-5) D NEWPG^ADGADSP3
 Q
