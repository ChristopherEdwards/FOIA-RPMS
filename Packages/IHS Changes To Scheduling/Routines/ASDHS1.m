ASDHS1 ; IHS/ADC/PDW/ENM - HS BY CLINIC CONT. ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;IHS/HQW/KML 2/19/97  replace ^UTILITY with ^TMP per SAC 2.3.2.5
 ;
GOT ;EP; called by ASDHS to put into correct sort order
 NEW DFN,TDO
 S DFN=$P(^SC(ASDX,"S",ASDT,1,ASDY,0),U)
 S TDO=$$HRN^ASDUT(DFN),TDO=$P(TDO,"-",3)_$P(TDO,"-",2)
 D CLO:ORDER=2,PCO:ORDER=3
 Q
 ;
PCO ; by prin clinic order
 NEW ASDZ,ASDP
 S ASDZ=$P($G(^SC(ASDX,"SL")),U,5),ASDZ=$S(+ASDZ:ASDZ,1:ASDX)
 S ASDP=$S($D(^SC(ASDZ,0)):$P(^(0),U),1:ASDZ)
 S ^TMP("SDHS",$J,"A",ASDP," "_TDO,DFN)=ASDX
 Q
 ;
CLO ; by clinics selected
 NEW ASDN
 S ASDN=$P($G(^SC(ASDX,0)),U)
 S ^TMP("SDHS",$J,"A",ASDN," "_TDO,DFN)=ASDX
 Q
 ;
GO ;EP; called to loop thru sorted list
 NEW ASDI,ASDJ,ASDK,ASDX
 S ASDI=0 F  S ASDI=$O(^TMP("SDHS",$J,"A",ASDI)) Q:ASDI=""  D
 . S ASDJ=0 F  S ASDJ=$O(^TMP("SDHS",$J,"A",ASDI,ASDJ)) Q:ASDJ=""  D
 .. S ASDK=0
 .. F  S ASDK=$O(^TMP("SDHS",$J,"A",ASDI,ASDJ,ASDK)) Q:'ASDK  D
 ... S ASDX=^TMP("SDHS",$J,"A",ASDI,ASDJ,ASDK)
 ... D HS,MP,AIU
 W:IOF]"" !,@IOF G END^SDROUT1
 ;
HS ; -- health summary
 Q:$G(SDZHS)
 Q:$P($G(^SC(+ASDX,9999999)),U)'="Y"
 S X=$$HSTYP^ASDUT(+ASDX,ASDK) Q:X=""
 D HS^ASDFORM(ASDK,X) Q
 ;
MP ; -- med profile
 Q:$G(SDZMP)
 Q:$P($G(^SC(ASDX,9999999)),U,3)'="Y"
 D MP^ASDFORM(ASDK)
 Q
 ;
AIU ; -- address update
 Q:$G(SDZAI)
 Q:$P($G(^SC(ASDX,9999999)),U,4)'="Y"
 D AIU^ASDFORM(ASDK)
 Q
