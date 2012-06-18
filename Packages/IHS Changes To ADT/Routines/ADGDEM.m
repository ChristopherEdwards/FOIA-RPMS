ADGDEM ; IHS/ADC/PDW/ENM - DAY SURGERY PATIENT INQUIRY ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> IHS additions to DGDEM (Patient Inquiry)
 ;***> last day surgery
 G B1:'$D(^ADGDS(DFN))  ;skip if no day surgery for patient
 S (DGZDT,DGZZ)=0  ;find last day surgery
A1 S DGZDT=$O(^ADGDS(DFN,"DS","AA",DGZDT)) G A2:DGZDT=""
 S DGZZ=DGZDT G A1
 ;
A2 G B1:DGZZ=0  ;skip if none found
 S DGA=$O(^ADGDS(DFN,"DS","AA",DGZZ,0)) G B1:DGA=""
 G B1:'$D(^ADGDS(DFN,"DS",DGA,0))#2 S DGSTR=^(0),DGX=$P(DGSTR,U)
 ;print data on last day surgery
 W !!,"DAY SURGERY Date/Time: "
 W $E(DGX,4,5)_"/"_$E(DGX,6,7)_"/"_$E(DGX,2,3)
 W:DGX["." " at ",$E($P(DGX,".",2)_"000",1,4)
 S DGX=$P(DGSTR,U,3) W:DGX'="" ?47,"Ward: ",$P(^DIC(42,DGX,0),U)
 W:$P($G(^ADGDS(DFN,"DS",DGA,2)),U,3)="Y" ?47,"(SURGERY CANCELLED)"
 W:$P($G(^ADGDS(DFN,"DS",DGA,2)),U,4)="Y" ?47,"(NO-SHOW)"
 W:$P(DGSTR,U,4)'="" ?58,"Room-Bed: ",$P(DGSTR,U,4)
 S DGSRV=$P(DGSTR,U,5),DGPRV=$P(DGSTR,U,6)
 S:DGSRV'="" DGSRV=$P($G(^DIC(45.7,DGSRV,0)),U)
 S:DGPRV'="" DGPRV=$P($G(^VA(200,DGPRV,0)),U)
 W !?35,"Srvc: ",$E(DGSRV,1,3),?47,"Prov: ",$E(DGPRV,1,15)
 G B1:'$D(^ADGDS(DFN,"DS",DGA,2)),B1:$P(^(2),U)="" S DGX=$P(^(2),U)
 W:DGX'="" !?13,"Released: ",$E(DGX,4,5)_"/"_$E(DGX,6,7)_"/"_$E(DGX,2,3)
 W:DGX["." " at ",$E($P(DGX,".",2)_"000",1,4)
 W ?47,"LOS: ",$$VAL^XBDIQ1(9009012.01,"DFN,DGA",8)," hrs"
 ;
 ;***> any scheduled visits on file?
B1 G END:'$D(^ADGAUTH(DFN,0)),END:'$D(^ADGAUTH(DFN,1,0)) S DG1=0
B10 S DG1=$O(^ADGAUTH(DFN,1,DG1)) G END:DG1=""
 S DGSTR=^ADGAUTH(DFN,1,DG1,0),DGX=$P(DGSTR,U)
 S DGX1=$P(DGSTR,U,5) G B3:DGX1="D"  ;go to B3 if scheduled for day sur
 G B5:DGX1="Q"  ;go to B5 if scheduled for outpatient visit w/quarters
 G B10:DGX1'="I"  ;otherwise if not a scheduled admit, go to end
 ;
 W !!?10,"Scheduled Admit for "
 W $E(DGX,4,5)_"/"_$E(DGX,6,7)_"/"_$E(DGX,2,3)
 W:$P(DGSTR,U,7)'="" ?43,"Ward: ",$E($P(^DIC(42,$P(DGSTR,U,7),0),U),1,3)
 W:$P(DGSTR,U,3)'="" ?55,"Service: ",$P(^DIC(45.7,$P(DGSTR,U,3),0),U,3)
 G B10
 ;
B3 W !!?10,"Scheduled for Day Surgery on "
 W $E(DGX,4,5)_"/"_$E(DGX,6,7)_"/"_$E(DGX,2,3)
 W:$P(DGSTR,U,3)'="" "  Service: ",$P(^DIC(45.7,$P(DGSTR,U,3),0),U,3)
 G B10
 ;
B5 W !!?10,"Scheduled for Quarters on "
 W $E(DGX,4,5)_"/"_$E(DGX,6,7)_"/"_$E(DGX,2,3)
 W ?50,"Provider: "
 W:$P(DGSTR,U,2)'="" $E($P(^VA(200,$P(DGSTR,U,2),0),U),1,20)
 G B10
 ;
END K DGZZ,DGZDT,DGSTR,DIC,DA,DR,DGPRV,DGSRV,LKPRINT Q
