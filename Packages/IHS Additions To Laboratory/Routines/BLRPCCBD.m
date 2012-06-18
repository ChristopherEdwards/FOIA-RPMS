BLRPCCBD ;IHS/OIT/MKK - IHS TaskMan "Busy Device" Report ;JUL 06, 2010 3:14 PM
 ;;5.2;IHS LABORATORY;**1025,1027**;NOV 01, 1997
 ;;
EP ; EP
 NEW CNT,CNTTSK,TSK,ONE,ZERO,HEADER,STR,SDATE,STIME
 ;
 S (CNT,CNTTSK,TSK)=0
 S HEADER(1)="TASKMAN Listing"
 S HEADER(2)="'BUSY DEVICE' Tasks"
 S HEADER(3)=" "
 S $E(HEADER(4),1)="Task #"
 S $E(HEADER(4),13)="Date"
 S $E(HEADER(4),21)="Time"
 S $E(HEADER(4),31)="Routine"
 S $E(HEADER(4),41)="Description"
 ;
 F  S TSK=$O(^%ZTSK(TSK))  Q:TSK=""!(TSK'?.N)  D
 . S CNTTSK=CNTTSK+1
 . ;
 . ; Only HLLP processes
 . I $G(^%ZTSK(TSK,.03))'["HL7 Message Processor for Lab" Q
 . ;
 . S ONE=$$UP^XLFSTR($G(^%ZTSK(TSK,.1)))
 . I ONE'["RESCHEDULED FOR BUSY DEVICE"  Q
 . ;
 . S ZERO=$G(^%ZTSK(TSK,0))
 . S SDATE=$$UP^XLFSTR($$HTE^XLFDT($P(ZERO,"^",5),"2PMZ"))
 . S STIME=$P(SDATE," ",2,3)
 . S SDATE=$P(SDATE," ",1)
 . ;
 . I CNT<1 D BLRGSHSH^BLRGMENU
 . W TSK
 . W ?10,SDATE,$J(STIME,9)
 . W ?30,$P(ZERO,"^",2)
 . W ?40,$E($G(^%ZTSK(TSK,.03)),1,40)
 . W !
 . S CNT=CNT+1
 ;
 W:CNT>0 !!,"Number of tasks that were rescheduled = ",CNT,!
 ; W:CNT<1 !!,"Number of tasks that were examined = ",CNTTSK,!
 ; ----- BEGIN IHS/OIT/MKK LR*5.2*1027 -- More explicit message
 I CNT<1 D
 . W !!,"Number of tasks that were examined = ",CNTTSK,!
 . W ?10,"No Tasks were rescheduled.",!!
 ; ----- END IHS/OIT/MKK LR*5.2*1027
 ;
 D PRESSKEY^BLRGMENU(10)
 ;
 Q
