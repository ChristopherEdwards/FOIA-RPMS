HLCSTCP4 ;SFIRMFO/RSD - BI-DIRECTIONAL TCP ;11/17/2003  09:40
 ;;1.6;HEALTH LEVEL SEVEN;**109**;Oct 13,1995
 ;
 ; RDERR & ERROR moved from HLCSTCP2 on 12/2/2003 - LJA
 ;
RDERR ; Error during read process, decrement counter
 D LLCNT^HLCSTCP(HLDP,4,1)
ERROR ; Error trap
 ; OPEN ERROR-retry.
 ; WRITE ERROR (SERVER DISCONNECT)-close channel, retry
 ;
 ;**109**
 ;I $G(HLMSG) L -^HLMA(HLMSG)
 ;
 S $ETRAP="D UNWIND^%ZTER"
 I $$EC^%ZOSV["OPENERR"!($$EC^%ZOSV["NOTOPEN")!($$EC^%ZOSV["DEVNOTOPN") D CC^HLCSTCP2("Op-err") S:$G(HLPRIO)="I" HLERROR="15^Open Related Error" D UNWIND^%ZTER Q
 I $$EC^%ZOSV["WRITE" D  Q  ;HL*1.6*77 modifications start here
 .  D CC^HLCSTCP2("Wr-err")
 .  S:$G(HLPRIO)="I" HLERROR="108^Write Error"
 .  D UNWIND^%ZTER ;HL*1.6*77 modifications end here
 I $$EC^%ZOSV["READ" D CC^HLCSTCP2("Rd-err") S:$G(HLPRIO)="I" HLERROR="108^Read Error" D UNWIND^%ZTER Q
 S HLCSOUT=1 D ^%ZTER,CC^HLCSTCP2("Error"),SDFLD^HLCSTCP
 S:$G(HLPRIO)="I" HLERROR="9^Error"
 D UNWIND^%ZTER
 Q
 ;
