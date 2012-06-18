ADGPOST ; IHS/ADC/PDW/ENM - ADT POSTINITS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;searhc/maw removed call to adgcp which is the patient movement
 ;and provider conversion, this should be run at the end.
 ;
 ;D DS,^ADGCP,XREF Q
 D DS,XREF Q
 ;
DS ; day surgery service category fix
 ; -- changes all day surgeries to category "S"
 ; -- change is hard set so APCIS xref not triggered
 W !!!,"Converting day surgery visits to service category ""S""",!
 NEW DSDT,REVDT,DSIEN,DFN,VISIT,CODE
 S CODE=$O(^DIC(40.7,"C",44,0)) Q:CODE=""
 S DFN=0
 F  S DFN=$O(^ADGDS(DFN)) Q:'DFN  D
 . S DSIEN=0
 . F  S DSIEN=$O(^ADGDS(DFN,"DS",DSIEN)) Q:'DSIEN  D
 .. S X=$P($G(^ADGDS(DFN,"DS",DSIEN,2)),U) Q:X=""
 .. Q:'$D(^ADGDS(DFN,"DS",DSIEN,0))  S DATE=+^(0) Q:DATE<1
 .. S REVDT=9999999-$P(DATE,"."),REVDT=REVDT_"."_$P(DATE,".",2)
 .. ;
 .. S VISIT=0
 .. F  S VISIT=$O(^AUPNVSIT("AA",DFN,REVDT,VISIT)) Q:VISIT=""  D
 ... S X=$G(^AUPNVSIT(VISIT,0)) Q:X=""  Q:$P(X,U,8)'=CODE
 ... Q:$P(X,U,7)'="A"
 ... S $P(^AUPNVSIT(VISIT,0),U,7)="S" ;change serv cat to day surg
 Q
 ;
XREF ; -- reindex incomplete chart and ds incomplete chart files
 W !!,"Re-Indexing Incomplete Chart File..."
 S DIK="^ADGIC(" D IXALL^DIK
 W !!,"Re-Indexing DS Incomplete Chart File...",!
 S DIK="^ADGDSI(" D IXALL^DIK
 Q
