INHVSEQ(INUIF,INERROR) ; FRW ; 26 Mar 95 20:30; Place message in INLHDEST queue
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;INPUT:
 ;  INUIF - ien in Universal Interface file
 ;  INBPN must be set
 ;OUTPUT:
 ;  INERROR - array containing any error messages
 ;  function value - success or failure
 ;        [  -1 - success ;  1 - failure ]
 ;
 ;This is a generic transmitter for TIP/IP destinations. 
 ;It provides two functionalities.
 ;1) it tests for sequence number protocol requirement and
 ;makes call to routine to insert seq. no in outgoing message.
 ;2) It moves messages from ^INLHSCH into ^INLHDEST
 ;
 N ER
 ;Make call for sequence number protocol
 S ER=$$SEQOUT^INHUSEQ(INUIF,.INERR)
 Q:ER ER
 ;Then move into dest queue
 S ER=$$DSTQUE^INHUSEN3(INUIF,.INERR) Q:ER ER
 Q -1
 ;
