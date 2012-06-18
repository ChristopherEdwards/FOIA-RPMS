ADGADSP ; IHS/ADC/PDW/ENM - A & D SHEET PRINT (DETAILED) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;Detailed Version of ADMISSIONS & DISCHARGES SHEET
 ;
HEAD ;***> prints heading
 S (DGZRM,X)=110 X ^%ZOSF("RM")  ;change right margin to 110
 W !?26,"*****Confidential Patient Data Covered by Privacy Act*****"
 S DGX=$P($G(^DIC(4,DUZ(2),0)),U)  ;facility name
 W !?DGZRM-$L(DGX)/2,DGX,?DGZRM-5,$P(^VA(200,DUZ,0),U,2) ;user initials
 S DGX="ADMISSIONS & DISCHARGES" W !?DGZRM-$L(DGX)/2,DGX
 W ?DGZRM-8,$E(DT,4,7)_$E(DT,2,3)
 S Y=DGDATE X ^DD("DD") W !?DGZRM-$L(Y)/2,Y,?DGZRM-9 D ^%T
 ;
COUNTS ;***> find inpatient counts
 ;S (DGW,DGINPCT)=0
 S (DGW,DGINPCT,DGNEWCT)=0
 F  Q:DGW'?1N.N  D    ;loop thru adt census-ward file;gather totals
 .S DGW=$O(^ADGWD(DGW)) Q:DGW'?1N.N  ;
 .S:$D(^ADGWD(DGW,1,DGDATE)) DGINPCT=DGINPCT+$P(^(DGDATE,0),U,2)
 .S:$D(^ADGWD(DGW,1,DGDATE)) DGNEWCT=DGNEWCT+$P(^(DGDATE,0),U,12)
 ;get newborn count, if any
 ;S DGZ=$O(^DIC(45.7,"B","NEWBORN",0))
 ;S DGNEWCT=$S(DGZ="":0,'$D(^ADGTX(DGZ,1,DGDATE,1)):0,1:$P(^ADGTX(DGZ,1,DGDATE,1),U))
 ;S DGINPCT=DGINPCT-DGNEWCT
 W !!!?10,"INPATIENTS: ",DGINPCT,?94,"NEWBORNS: ",DGNEWCT
 ;
 W !?10,"NAME",?37,"HRCN",?47,"PROVIDER",?71,"AGE"
 W ?80,"WD  SVRC",?90,"COMMUNITY"
 ;
 G ^ADGADSP1
