XBDBQUE ; IHS/ADC/GTH - DOUBLE QUEUING SHELL HANDLER ; 17 Jul 2002  7:47 PM [ 04/28/2003  12:06 PM ]
 ;;3.0;IHS/VA UTILITIES;**5,8,9**;FEB 07, 1997
 ; XB*3*5 - IHS/ADC/GTH 10-31-97
 ; XB*3*8 - IHS/ASDST/GTH 12-07-00
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Parse of drive in SETIOPN.
 ; Thanks to Paul Wesley, DSD, for the original routine.
 ; ---------------------------------------------------------
 ; |refer to XBDBQDOC for instructions, examples, and tests|
 ; ---------------------------------------------------------
 ;
START ;
 NEW XB ;     use a fresh array in case of nesting double queues
 ;     insure IO array is set fully
 I ($D(IO)'>10) S IOP="HOME" D ^%ZIS
 I $D(ZTQUEUED) S XBFQ=1 S:'$D(XBDTH) XBDTH="NOW" ;     insure auto-requeue if called from a queued
 I '$D(XBRC),'$D(XBRP) Q  ;                             insure one of RC or RP exist
 S XB("IOP1")=ION_";"_IOST_";"_IOM_";"_IOSL ;           store current IO params
 I $G(IOPAR)]"" S XB("IOPAR")=IOPAR ;                   store IOPAR
 I $L($G(XBRC))=0 S XBRC="NORC^XBDBQUE" ;               no compute identified
 S XB("RC")=XBRC,XB("RP")=$G(XBRP),XB("RX")=$G(XBRX)
 ;                                                      load XBNS="xx;yy;.." into XB("NS",xx*) ...
 F XBI=1:1 S XBNSX=$P($G(XBNS),";",XBI) Q:XBNSX=""  S:(XBNSX'["*") XBNSX=XBNSX_"*" S XB("NS",XBNSX)=""
 S XB("NS","XB*")=""
 ;                                                     load XBNS("xxx") array into XB("NS","xxx")
 S XBNSX=""
 F  S XBNSX=$O(XBNS(XBNSX)) Q:XBNSX=""  S XB("NS",XBNSX)=""
 ; if this is a double queue with XB("IOP") setup .. pull the parameters out a ^%ZIS call to set up the parameters without an open
 S XB("IOP")=$G(XBIOP)
 I $D(XBIOP) S IOP=XBIOP
 ; XB*3*5 - IHS/ADC/GTH 10-31-97 start block
 I $G(XB("IOPAR"))]"" S %ZIS("IOPAR")=XB("IOPAR") D
 . I XB("IOPAR")'?1"(""".E1""":""".E1""")" Q  ;                skip HFS if not an HFS
 . S XBHFSNM=$P(XB("IOPAR"),":"),XBHFSNM=$TR(XBHFSNM,"()""")
 . S XBHFSMD=$P(XB("IOPAR"),":",2),XBHFSMD=$TR(XBHFSMD,"()""")
 . S %ZIS("HFSNAME")=XBHFSNM,%ZIS("HFSMODE")=XBHFSMD
 . ;this code drops through
 ; XB*3*5 - IHS/ADC/GTH 10-31-97 end block
ZIS ;
 KILL IO("Q")
 I $G(XBRC)]"",$G(XBRP)="" G ZISQ
 S %ZIS="PQM"
 D ^%ZIS ;                 get parameters without an open
 I POP W !,"REPORTING-ABORTED",*7 G END1
 S XB("IO")=IO,XB("IOP")=ION_";"_IOST_";"_IOM_";"_IOSL,XB("IOPAR")=$G(IOPAR),XB("CPU")=$G(IOCPU),XB("ION")=ION
ZISQ ;
 I '$D(IO("Q")),'$G(XBFQ) D
 . I $D(ZTQUEUED) S XBFQ=1 Q
 . I IO=IO(0),$G(XBRP)]"" Q
 . Q:$$VALI^XBDIQ1(3.5,IOS,5.5)=2  ;Q'ing not allowed to DEVICE selected;IHS/SET/GTH XB*3*9 10/29/2002
 . KILL DIR
 . S DIR(0)="Y",DIR("B")="Y",DIR("A")="Won't you queue this "
 . D ^DIR
 . KILL DIR
 . I X["^" S XBQUIT=1
 . S:Y=1 IO("Q")=1
 . Q
 ;
 KILL XB("ZTSK")
 I $D(ZTQUEUED),$G(ZTSK) S XB("ZTSK")=ZTSK
 KILL ZTSK
 ;  quit if user says so
 I $G(XBQUIT) KILL DIR S DIR(0)="E",DIR("A")="Report Aborted .. <CR> to continue" D ^DIR KILL DIR G END1
 ;
QUE1 ;
 I ($D(IO("Q"))!($G(XBFQ))) D  K IO("Q") W:(($G(ZTSK))&('$D(XB("ZTSK")))) !,"Tasked with ",ZTSK W:'$G(ZTSK) !,*7,"Que not successful ... REPORTING ABORTED" D ^%ZISC S IOP=XB("IOP1") D ^%ZIS G END1 ;--->
 . I '$D(ZTQUEUED),IO=IO(0),$G(XBRP)]"" W !,"Queing to slave printer not allowed ... Report Aborting" Q  ;---^
 . S ZTDESC="Double Que COMPUTing  "_XBRC_"  "_$G(XBRP),ZTIO="",ZTRTN="DEQUE1^XBDBQUE"
 . S:$D(XBDTH) ZTDTH=XBDTH
 . S:$G(XB("CPU"))]"" ZTCPU=XB("CPU")
 . S XBNSX=""
 . F  S XBNSX=$O(XB("NS",XBNSX)) Q:XBNSX=""  S ZTSAVE(XBNSX)=""
 . KILL XBRC,XBRP,XBRX,XBNS,XBFQ,XBDTH,XBIOP,XBPAR,XBDTH,XBNSX,XBI
 . S ZTIO="" ;                               insure no device loaded
 . D ^%ZTLOAD
 . Q  ; these do .s branch to END1
 ; (((if queued the above code branched to END)))
 ;
DEQUE1 ;EP - > 1st deque From TaskMan.
 ;
 KILL XBRC,XBRP,XBRX,XBNS,XBFQ,XBDTH,XBIOP,XBPAR,XBDTH
 KILL XB("ZTSK")
 I $D(ZTQUEUED),$G(ZTSK) S XB("ZTSK")=ZTSK
 ;
COMPUTE ;>do computing | routine
 ;
 D @(XB("RC")) ;  >>>PERFORM THE COMPUTE ROUTINE<<< ;stuffed if not provided with NORC^XBDBQUE
 ;
QUE2 ;
 ;
 I $D(ZTQUEUED) D  G ENDC ;===>    automatically requeue if queued
 . Q:XB("RP")=""
 . S ZTDESC="Double Que PRINT "_XB("RC")_" "_XB("RP"),ZTIO=XB("IO"),ZTDTH=$H,ZTRTN="DEQUE2^XBDBQUE" ;IHS/SET/GTH 07/16/2002
 . S XBNSX=""
 . F  S XBNSX=$O(XB("NS",XBNSX)) Q:XBNSX=""  S ZTSAVE(XBNSX)=""
 . D SETIOPN K ZTIO
 . D ^%ZTLOAD
 . I '$D(ZTSK) S XBERR="SECOND QUE FAILED" D @^%ZOSF("ERRTN") Q
 . S XBDBQUE=1
 . Q  ;                     ======>         this branches to ENDC
 ;
 ; device opened from the first que ask
DEQUE2 ;EP - 2nd Deque | printing
 KILL XB("ZTSK")
 I $D(ZTQUEUED),$G(ZTSK) S XB("ZTSK")=ZTSK
 ;open printer device for printing with all selected parameters
 G:(XB("RP")="") END ;---> exit if no print
 ;
 I $D(ZTQUEUED),$$VERSION^%ZOSV(1)["Cache",ION="HFS" D ^%ZISC S IOP=ION,%ZIS("HFSNAME")=XB("IO"),%ZIS("HFSMODE")="W" D ^%ZIS ;IHS/SET/GTH XB*3*9 10/29/2002
 U IO
 D @(XB("RP")) ; >>>PERFORM PRINTING ROUTINE
 ;
 ;-------
END ;>End | cleanup
 ;
 I $G(XB("RX"))'="" D @(XB("RX")) ;   >>>PERFORM CLEANUP ROUTINE<<<
 ;
END0 ;EP - from compute cycle when XB("RP") EXISTS
 I $D(XB("ZTSK")) S XBTZTSK=$G(ZTSK),ZTSK=XB("ZTSK") D KILL^%ZTLOAD K ZTSK S:$G(XBTZTSK) ZTSK=XBTZTSK KILL XBTZTSK
END1 ;EP clean out xb as passed in
 D ^%ZISC
 S IOP=XB("IOP1") ; restore original IO parameters
 D ^%ZIS
 K IOPAR,IOUPAR,IOP
 KILL XB,XBRC,XBRP,XBRX,XBNS,XBFQ,XBDTH,XBIOP,XBPAR,XBDTH,XBERR,XBI,XBNSX,XBQUIT,XBDBQUE
 ;
 Q
ENDC ;EP - end computing cycle
 I $G(XB("RP"))="" G END
 G END0
 ;
 ;----------------
 ;----------------
SUB ;>Subroutines
 ;----------
NORC ;used if no XBRC identified
 Q
 ;
SETIOPN ;EP Set IOP parameters with (N)o open
 Q:'$D(XB("IOP"))
 S IOP=XB("IOP")
 ;Begin New Code;XB*3*9 10/29/2002
 I $$VERSION^%ZOSV(1)["Cache",$G(XB("ION"))="HFS" D  Q
 . S %ZIS("HFSNAME")=XB("IO"),%ZIS("IOPAR")="WNS",%ZIS("HFSMODE")="W",IOP=$P(XB("IOP"),";"),XB("IOP")=IOP,%ZIS="N"
 . D ^%ZIS
 .Q
 ;End New Code;XB*3*9 10/29/2002
 ; XB*3*5 - IHS/ADC/GTH 10-31-97 start block
 I $G(XB("IOPAR"))]"" S %ZIS("IOPAR")=XB("IOPAR") D
 . I XB("IOPAR")'?1"(""".E1""":""".E1""")" Q  ;                skip HFS if not an HFS
 . ; XB*3*8 - IHS/ASDST/GTH 00-12-05 start block
 . ; Index into XB("IOPAR") correctly if ":" in Pathname.
 . NEW A,I
 . S (I,A)=1
 . F  S C=$E(XB("IOPAR"),A) Q:A=$L(XB("IOPAR"))  S A=A+1,I=I+(C=":")
 . ; XB*3*8 - IHS/ASDST/GTH 00-12-05 end block
 . ; S XBHFSNM=$P(XB("IOPAR"),":"),XBHFSNM=$TR(XBHFSNM,"()""") ; XB*3*8
 . S XBHFSNM=$P(XB("IOPAR"),":",I-1),XBHFSNM=$TR(XBHFSNM,"()""") ; XB*3*8
 . ;S XBHFSNM=$P(XB("IOPAR"),":",I-1),XBHFSNM=$TR(XBHFSNM,"()""") ; XB*3*8 ;IHS/SET/GTH XB*3*9 10/29/2002
 . S XBHFSNM=$P(XB("IOPAR"),":",I-2,I-1),XBHFSNM=$TR(XBHFSNM,"()""") ; XB*3*8 ;IHS/SET/GTH XB*3*9 10/29/2002
 . ; S XBHFSMD=$P(XB("IOPAR"),":",2),XBHFSMD=$TR(XBHFSMD,"()""") ; XB*3*8
 . S XBHFSMD=$P(XB("IOPAR"),":",I),XBHFSMD=$TR(XBHFSMD,"()""") ; XB*3*8
 . S %ZIS("HFSNAME")=XBHFSNM,%ZIS("HFSMODE")=XBHFSMD
 . Q
 ; XB*3*5 - IHS/ADC/GTH 10-31-97 end block
 S %ZIS="N"
 D ^%ZIS
 Q
