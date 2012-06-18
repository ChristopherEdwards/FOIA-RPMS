ADGPEP ; IHS/ADC/PDW/ENM - PUBLIC ENTRY POINTS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;This routine contains a series of public entry points for
 ;obtaining inpatient data on any patient
 ;
CURWARD(DFN) ;PEP; returns external format for patient's current ward
 NEW X
 S X=$$VAL^XBDIQ1(2,DFN,.1) I X]"" Q X
 S Y=9999999.9999999-$$NOW^XLFDT
 S X=$O(^DGPM("ATID3",DFN,Y)) I X="" Q ""
 Q "DSCH"
 ;
SRGWARD(DFN,SURG) ;PEP; PRIVATE ENTRY POINT returns ward at time of surgery
 ; to be called by Surgery package ONLY!!
 NEW ADG,RDT,ADMIT,ADMTX,TRNFR,TRNFX
 D ENP^XBDIQ1(130,SURG,".09;.22","ADG(","I")
 I ADG(.09)="",ADG(.22)="" Q ""
 S RDT=9999999.9999999-$S(ADG(.22)]"":ADG(.22,"I"),1:ADG(.09,"I"))
 S ADMIT=$O(^DGPM("ATID1",DFN,RDT)) I ADMIT="" Q ""
 S ADMTX=$O(^DGPM("ATID1",DFN,ADMIT,0)) I ADMTX="" Q ""
 S TRNFR=$O(^DGPM("ATID2",DFN,RDT))
 S TRNFX=$S(TRNFR="":"",1:$O(^DGPM("ATID2",DFN,TRNFR,0)))
 I TRNFX]"",$$SAMEADMT Q $$VAL^XBDIQ1(405,TRNFX,.06)
 Q $$VAL^XBDIQ1(405,ADMTX,.06)
 ;
SAMEADMT() ; -- is transfer for same admit
 Q $S($P(^DGPM(TRNFX,0),U,14)=ADMTX:1,1:0)
 ;
CURRMBD(DFN) ;PEP; returns external format for patient's current room-bed
 Q $$VAL^XBDIQ1(2,DFN,.101)
 ;
CURSRV(DFN) ;PEP; returns external format for patient's current service
 Q $$VAL^XBDIQ1(2,DFN,.103)
 ;
CURSRVI(DFN) ;PEP; returns internal format for patient's current service
 Q $$VALI^XBDIQ1(2,DFN,.103)
 ;
CURPRV(DFN) ;PEP; returns external format for patient's current att provider
 Q $$VAL^XBDIQ1(2,DFN,.104)
 ;
CURPRVI(DFN) ;PEP; returns internal format for patient's current att provider
 Q $$VALI^XBDIQ1(2,DFN,.104)
 ;
