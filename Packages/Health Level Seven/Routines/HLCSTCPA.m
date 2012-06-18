HLCSTCPA ;OIFO-O/RJH - (TCP/IP) VMS ;07/10/2003  10:12
 ;;1.6;HEALTH LEVEL SEVEN;**84**;Oct 13, 1995
 ;
 ; 1. port number is input from VMS HLSxxxxDSM.COM or HLSxxxxCACHE.COM
 ;    file, where xxxx is port number.
 ; 2. find the ien of #870(logical link file) for the HL7 multi-listener
 ; 3. call the appropriate entry:
 ;    for Cache: CACHEVMS^HLCSTCP(ien of #870)
 ;    for DSM:   EN^HLCSTCP
 Q
PORT ;
 ;HLIEN870: ien in #870 (logical link file)
 ;HLPORT: port number of multi-listener
 ;HLPRTS: port number in entry to be tested
 ;input of DSM: % = device^port number of multi-listener
 ;input of Cache: port number of TCPIP
 ;
 I ^%ZOSF("OS")["OpenM" D
 . S HLPORT=$ZF("GETSYM","PORT")
 I ^%ZOSF("OS")["DSM" D
 . S HLPORT=$P(%,"^",2)
 I 'HLPORT D ^%ZTER Q
 S HLIEN870=0
 F  S HLIEN870=$O(^HLCS(870,"E","M",HLIEN870)) Q:'HLIEN870  D  Q:(HLPRTS=HLPORT)
 . S HLPRTS=$P(^HLCS(870,HLIEN870,400),"^",2)
 I 'HLIEN870 D ^%ZTER Q
 ;
 K HLPORT,HLPRTS
 ;
 ;for Cache/VMS
 I ^%ZOSF("OS")["OpenM" D  Q
 .D CACHEVMS^HLCSTCP(HLIEN870)
 ;
 ;for DSM
 I ^%ZOSF("OS")["DSM" D  Q
 . S $P(%,"^",2)=HLIEN870   ;set % = device^ien of #870
 . K HLIEN870
 . D EN^HLCSTCP
 ;
 D ^%ZTER
 Q
