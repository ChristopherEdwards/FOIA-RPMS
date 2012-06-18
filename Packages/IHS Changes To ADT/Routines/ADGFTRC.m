ADGFTRC ; IHS/ADC/PDW/ENM - TRANS BETWEEN FAC(CALC) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- driver
 D INI,LP1,LP3 G ^ADGFTRP
 ;
INI ; -- initialize variables
 K ^TMP("DGZFTRA",$J),^TMP("DGZFTRD",$J)
 ; -- DGI1 & DGI2 = transfer in types
 S DGI1=$O(^DG(405.1,"AIHS1","A2",0))
 S DGI2=$O(^DG(405.1,"AIHS1","A3",0))
 ; -- DGO1 = transfer out type
 S DGO1=$O(^DG(405.1,"AIHS1","D2",0))
 Q
 ;
LP1 ; -- loop admissions
 N DFN,IFN,N
 S DGDT=DGBDT-.0001,DGEND=DGEDT+.2400
 F  S DGDT=$O(^DGPM("AMV1",DGDT)) Q:'DGDT!(DGDT>DGEND)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV1",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV1",DGDT,DFN,IFN)) Q:'IFN  D 1
 Q
 ;
1 S N=^DGPM(IFN,0),DGT=$P(N,U,4)
 I DGT'=DGI1&(DGT'=DGI2) Q                 ;admit type not transfer
 S DGX=$P(N,U,5) Q:DGX=""                  ;return if no facility
 S DGX1=U_$P(DGX,";",2)_$P(DGX,";")_",0)"  ;set ref from var pntr
 I $D(@DGX1) S DGFAC=$P(@DGX1,U)           ;facility name
 I '$D(@DGX1)  Q                           ;no facility name entry
 S DGSV=$O(^DGPM("APHY",IFN,0)) Q:'DGSV
 Q:'$D(^DGPM(DGSV,0))  S DGSV=$P(^(0),U,9)
 S DGSRV=$S(DGSV="":"NO SERVICE",1:$P(^DIC(45.7,DGSV,0),U))  ;service
 ;***> increment counts
 G PAT:DGTYP=1     ;type 1 is listing only
 I '$D(DGCT(DGFAC,DGSRV)) S DGCT(DGFAC,DGSRV)=1 Q:DGTYP=2  G PAT
 S $P(DGCT(DGFAC,DGSRV),U)=$P(DGCT(DGFAC,DGSRV),U)+1 Q:DGTYP=2
PAT ;***> store patient data for types 1 and 3
 S ^TMP("DGZFTRA",$J,DGDT,DGSRV,DGFAC,DFN)=""
 Q
 ;
LP3 ; -- loop discharges
 N DFN,IFN,N
 S DGDT=DGBDT-.0001,DGEND=DGEDT+.2400
 F  S DGDT=$O(^DGPM("AMV3",DGDT)) Q:'DGDT!(DGDT>DGEND)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV3",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV3",DGDT,DFN,IFN)) Q:'IFN  D 3
 Q
 ;
3 S N=^DGPM(IFN,0),DGT=$P(N,U,4)
 I DGT'=DGO1 Q                             ;discharge type not transfer
 S DGX=$P(N,U,5) Q:DGX=""                  ;return if no facility
 S DGX1=U_$P(DGX,";",2)_$P(DGX,";")_",0)"  ;set ref from var pntr
 I $D(@DGX1) S DGFAC=$P(@DGX1,U)           ;facility name
 I '$D(@DGX1) Q                            ;no facility name entry
 S DGSRV=$P($G(^DIC(45.7,+$$DTS,0)),U)
 ;***> increment counts
 G PAT1:DGTYP=1   ;type 1 is listing only
 I '$D(DGCT(DGFAC,DGSRV)) S DGCT(DGFAC,DGSRV)="^1" Q:DGTYP=2  G PAT1
 S $P(DGCT(DGFAC,DGSRV),U,2)=$P(DGCT(DGFAC,DGSRV),U,2)+1 Q:DGTYP=2
PAT1 ;***> store patient data for types 1 & 3
 S ^TMP("DGZFTRD",$J,DGDT,DGSRV,DGFAC,DFN)=""
 Q
 ;
DTS() ; -- discharge treating specialty
 Q $O(^($O(^DGPM("ATS",DFN,+$P(^DGPM(IFN,0),U,14),9999999.9999999-N)),0))
