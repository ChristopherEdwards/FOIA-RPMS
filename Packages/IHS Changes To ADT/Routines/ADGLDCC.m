ADGLDCC ; IHS/ADC/PDW/ENM - DISCHARGES LISTINGS (CALC) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 K ^TMP("DGZLDC",$J)
A ; -- driver
 D LP3 G ^ADGLDCP
 ;
LP3 ; -- loop discharges
 N DGDT,ED,DFN,IFN
 S DGDT=DGBDT-.0001,ED=DGEDT+.2400
 F  S DGDT=$O(^DGPM("AMV3",DGDT)) Q:'DGDT!(DGDT>ED)  D 
 . S DFN=0 F  S DFN=$O(^DGPM("AMV3",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV3",DGDT,DFN,IFN)) Q:'IFN  D 1
 Q
 ;
1 ;
 N NAME,N,CA,ID,WD,WARD,DX,TS
 S NAME=$P($G(^DPT(DFN,0)),U),N=$G(^DGPM(IFN,0)),CA=$P(N,U,14)
 S ID=9999999.9999999-DGDT,WD=$P($G(^DGPM(+$$MP,0)),U,6)
 I DGTYP=2,DGSRT'="A" Q:WD'=+DGSRT
 S WARD=$P($G(^DIC(42,+WD,0)),U),DX=$P($G(^DGPM(+CA,0)),U,10),TS=$$TS
 I DGTYP=3,DGSRT'="A" Q:TS'=+DGSRT
 S TS=$S(TS="":"NO SERVICE",1:$P($G(^DIC(45.7,+TS,0)),U))
UTL ; -- sort by
 ; -- date, alpha
 I DGTYP=1 D  Q 
 . S ^TMP("DGZLDC",$J,$P(DGDT,"."),DGDT,DFN)=WARD_U_TS_U_DX
 ; -- ward, date, alpha
 I DGTYP=2 D  Q
 . S ^TMP("DGZLDC",$J,WARD,DGDT,NAME,DFN)=TS_U_DX
 ; -- service, date, alpha
 S ^TMP("DGZLDC",$J,TS,DGDT,NAME,DFN)=WARD_U_DX
 Q
 ;
MP() ; -- movement, previous
 Q $O(^DGPM("APMV",DFN,CA,$O(^DGPM("APMV",DFN,CA,ID)),0))
 ;
TS() ; -- movement, previous, ts
 Q $O(^DGPM("ATS",DFN,CA,+$O(^DGPM("ATS",DFN,CA,ID)),0))
