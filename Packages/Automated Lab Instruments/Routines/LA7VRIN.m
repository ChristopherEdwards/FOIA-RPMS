LA7VRIN ;VA/DALOI/JMC - Process Incoming Lab HL7 Messages ; 01/14/99
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46**;NOV 01, 1997
 ; This routine processes incoming messages for various Lab HL7 configurations.
 Q
 ;
EN ; Only one process should run at a time
 N LA76249,LA7I,LA7INTYP,LA7LOOP
 ;
 L +^LAHM(62.48,"Z",LA76248):10
 E  Q
 ;
 ; Determine interface type
 S LA7INTYP=+$P(^LAHM(62.48,LA76248,0),"^",9)
 ;
 ; main loop, LA7LOOP reset in GETIN, if no messages for 5 minutes (60x5) then quit
 F LA7LOOP=1:1:60 D GETIN H 5
 ;
 ; If point of care interface then task job(s) to process results in LAH.
 I LA7INTYP=20,$D(LA7INTYP("LWL")) D
 . S LA7I=0
 . F  S LA7I=$O(LA7INTYP("LWL",LA7I)) Q:'LA7I  D QLAH(LA7I)
 ;
 ; Release lock
 L -^LAHM(62.48,"Z",LA76248)
 ; Clean up taskman
 I $D(ZTQUEUED) S ZTREQ="@"
 K LA76248
 K CENUM,DPF,ECHOALL,ER,IDE,IDT,LALCT,LANM,LAZZ,LINK,LRTEC,NOW,RMK,T,TC,TP,TSK,WDT
 Q
 ;
 ;
GETIN ; Check the incoming queue for messages and then call LA7VIN1 to
 ; process the message.
 ;
 ; Check incoming queue
 Q:'$O(^LAHM(62.49,"Q",LA76248,"IQ",0))
 ;
 ; Reset timeout counter
 S LA7LOOP=1
 ;
 ; Get lock on message, quit if still building, process message then release lock.
 F  S LA76249=$O(^LAHM(62.49,"Q",LA76248,"IQ",0)) Q:'LA76249  D
 . L +^LAHM(62.49,LA76249):1
 . I '$T H 5 Q
 . D NXTMSG^LA7VRIN1
 . L -^LAHM(62.49,LA76249)
 K ^TMP("LA7TREE",$J)
 Q
 ;
 ;
QUE ; Call here to queue this processing routine to run in the background.
 ; Required variables are:  LA76248 = pointer to configuration in 62.48
 ;
 N ZTDESC,ZTDTH,ZTIO,ZTSAVE,ZTRTN,ZTSK
 ;
 ; See if already running
 L +^LAHM(62.48,"Z",LA76248):1
 E  Q
 ;
 S ZTRTN="EN^LA7VRIN",ZTDTH=$H,ZTIO=""
 S ZTDESC="Processing Routine for "_$P(^LAHM(62.48,LA76248,0),"^")
 S ZTSAVE("LA76248")=LA76248
 D ^%ZTLOAD
 ;
 L -^LAHM(62.48,"Z",LA76248)
 ;
 Q
 ;
 ;
QLAH(LWL) ; Call here to queue result processing routine to run in the background.
 ; Call with LWL = pointer to loadlist in file #68.2
 ;
 N ZTDESC,ZTDTH,ZTIO,ZTSAVE,ZTRTN,ZTSK
 ;
 ; See if already running
 L +^LAH("Z",LWL):1
 E  Q
 ;
 S ZTRTN="EN^LA7VIN",ZTDTH=$H,ZTIO=""
 S ZTDESC="Result Processing for "_$P(^LRO(68.2,LWL,0),"^")
 S ZTSAVE("LWL")=LWL
 ;D ^%ZTLOAD
 ;
 L -^LAH("Z",LWL)
 ;
 Q
