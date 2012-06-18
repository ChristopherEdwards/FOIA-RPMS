ACDPCCLT ;IHS/ADC/EDE/KML - TEST CDMIS PCC LINK; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ; Local array set as CDMIS entries added or edited:
 ;     ACDPCCL(patient ien,visit ien)=""
 ;     ACDPCCL(patient ien,visit ien,"CS",cs ien)=""
 ;     ACDPCCL(patient ien,visit ien,"IIF",iif ien)=""
 ;     ACDPCCL(patient ien,visit ien,"TDC",tdc ien)=""
 ;
BAD W !,"YOU MUST USE ONE OF THE FOLLOWING ENTRY POINTS:"
 W !!,"    IN  RE  FU  TD  CS",!
 Q
 ;
IN ;
 D INIT
 S ACDPCCL(473,12)=""
 S ACDPCCL(473,12,"IIF",4)=""
 D ^ACDPCCL
 D ^XBVL
 Q
 ;
RE ;
 D INIT
 S ACDPCCL(473,14)=""
 S ACDPCCL(473,14,"IIF",5)=""
 D ^ACDPCCL
 D ^XBVL
 Q
 ;
TD ;
 D INIT
 S ACDPCCL(473,11)=""
 S ACDPCCL(473,11,"TDC",2)=""
 D ^ACDPCCL
 D ^XBVL
 Q
 ;
FU ;
 D INIT
 S ACDPCCL(473,15)=""
 S ACDPCCL(473,15,"IIF",6)=""
 D ^ACDPCCL
 D ^XBVL
 Q
 ;
CS ;
 D INIT
 S ACDPCCLY=76479
 ;**********
 F  S ACDPCCLY=$O(^AUPNVSIT(ACDPCCLY)) Q:'ACDPCCLY  D
 . S APCDVDLT=ACDPCCLY D ^APCDVDLT
 . S DIK="^AUPNVSIT(",DA=ACDPCCLY D ^DIK
 . Q
 K ^ACDVIS(7,21)
 ;**********
 S ACDPCCL(508,7)=""
 S X=0
 F  S X=$O(^ACDCS("C",7,X)) Q:'X  S ACDPCCL(508,7,"CS",X)=""
 D ^ACDPCCL
 D ^XBVL
 Q
 ;
INIT ;
 D ^ACD
 S ACDMODE="A"
 K ACDPCCL,ACDEV
 Q
 ;
DSP ;
 W !!,"Select device for DSP",!
 D GETDEV^ACDPCCL4
 U IO
 W @IOF
 S X=$C(90,87)_" ACDPCCL" X X
 U 0
 W !!
 S X=$C(90,87)_" ACDPCCL" X X
 D ^%ZISC
 K ACDDEV
 Q
