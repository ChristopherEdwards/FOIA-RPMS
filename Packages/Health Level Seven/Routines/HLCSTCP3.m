HLCSTCP3 ;SFIRMFO/RSD - BI-DIRECTIONAL TCP ;09/13/2006
 ;;1.6;HEALTH LEVEL SEVEN;**76,77,133**;OCT 13, 1995;Build 13
 ;Per VHA Directive 2004-038, this routine should not be modified.
 ;
OPENA I $G(HLMSG),$D(^HLMA(HLMSG,"P")) S HLPORTA=+$P(^("P"),U,6)
 D MON^HLCSTCP("Open")
 S POP=1
 I $G(HLDIRECT("OPEN TIMEOUT")) D
 .S HLI=1
 .D CALL^%ZISTCP(HLTCPADD,HLTCPORT,HLDIRECT("OPEN TIMEOUT"))
 E  D
 .F HLI=1:1:HLDRETR D CALL^%ZISTCP(HLTCPADD,HLTCPORT) Q:'POP
 ;set # of opens back in msg
 I $G(HLMSG),$D(^HLMA(HLMSG,"P")) S $P(^("P"),U,6)=HLPORTA+HLI
 ;device open
 I 'POP S HLPORT=IO D  Q $S($G(HLERROR)]"":0,1:1)
 . N $ETRAP,$ESTACK S $ETRAP="D ERROR^HLCSTCP2" ;HL*1.6*77
 . ;if address came from DNS, set back into LL
 . I $D(HLIP) S $P(^HLCS(870,HLDP,400),U)=HLTCPADD
 . ; write and read to check if still open
 . Q:HLOS'["OpenM"  X "U IO:(::""-M"")" ; must be Cache/NT + use packet mode
 . Q:$P(^HLCS(870,HLDP,400),U,7)'="Y"  ; must want to SAY HELO
 . U IO W "HELO "_$$KSP^XUPARAM("WHERE"),! R X:1
 ;openfail-try DNS lookup
 I '$D(HLDOM) S HLDOM=+$P(^HLCS(870,HLDP,0),U,7),HLDOM=$P($G(^DIC(4.2,HLDOM,0)),U) D:HLDOM]"" DNS
 ;HLIP=ip add. from DNS call, get first one and try open again
 I $D(HLIP) S HLTCPADD=$P(HLIP,","),HLIP=$P(HLIP,",",2,99) G:HLTCPADD OPENA
 ;open error
 I $G(HLDIRECT("OPEN TIMEOUT")) D
 .D MON^HLCSTCP("Openfail")
 .I $D(HLPORT) D CLOSE^%ZISTCP K HLPORT
 E  D
 .D CC^HLCSTCP2("Openfail") H 3
 Q 0
 ;
 ;following code was removed, site's complained of to many alerts
 ;couldn't open, send 1 alert
 ;I '$G(HLPORTA) D
 ;. ;send alert
 ;. N XQA,XQAMSG,XQAOPT,XQAROU,XQAID,Z
 ;. ;get mailgroup from file 869.3
 ;. S Z=$P($$PARAM^HLCS2,U,8),HLPORTA="" Q:Z=""
 ;. S XQA("G."_Z)="",XQAMSG=$$HTE^XLFDT($H,2)_" Logical Link "_$P(^HLCS(870,HLDP,0),U)_" exceeded Open Retries."
 ;. D SETUP^XQALERT
 ;open error
 ;D CC("Openfail") H 3
 ;Q 0
 ;
 ;
DNS ;VA domains must have "med" inserted.
 ;All domains must use port 5000 and are prepended with "HL7"
 ;non-VA DNS lookups will succeed if site uses port 5000 and 
 ;configure their local DNS with "HL7.yourdomain.com" and entries
 ;are created in the logical link file and domain file.
 D MON^HLCSTCP("DNS Lkup")
 I HLDOM["VA.GOV"&(HLDOM'[".MED.") S HLDOM=$P(HLDOM,".VA.GOV")_".MED.VA.GOV"
 I HLTCPORT=5000 S HLDOM="HL7."_HLDOM
 I HLTCPORT=5500 S HLDOM="MPI."_HLDOM
 S HLIP=$$ADDRESS^XLFNSLK(HLDOM)
 K:HLIP="" HLIP
 Q
 ;
