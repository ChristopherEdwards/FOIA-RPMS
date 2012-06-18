INHOS(UIF,INDEV) ;FRW,JSH ;08:59 AM  17 Oct 1997; Program to handle output to a Transaction Type ; 07 Oct 91
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;INPUT:
 ;  UIF    - entry in interface file
 ;  INDEV  - Device name
 ;LOCAL:
 ;  INTT   - transaction type entry
 ;     If INTT is not present it indicates that the
 ;     module(s) is being called by ^INHOM or ^INHOT
 ;
 ;NOTE:  Many modules in this program are called by other programs
 ;
 S X="ERR^INHOS",@^%ZOSF("TRAP")
 K (INBPN,INHSRVR,INPNAME,XUAUDIT,UIF,INDEV,XUTIMP,XUTIMT,XUTIMH) S INDEV=$G(INDEV)
 X $G(^INTHOS(1,2))
 D SETENV^INHUT7
 S X=$P($G(^INRHSITE(1,0)),U,6) X:X ^%ZOSF("PRIORITY")
 I $L(INDEV) K %ZIS S %ZIS="0",IOP=INDEV D ^%ZIS I POP D ERROR("Device: "_$P(^%ZIS(1,INDEV,0),U)_" not available.") Q
EN1 I '$D(^INTHU(+$G(UIF),0)) D ERROR("UIF file entry missing: "_+$G(UIF)) Q
 N DEST S DEST=+$P(^INTHU(UIF,0),U,2)
 I '$D(^INRHD(DEST,0)) D ERROR("Missing DESTINATION number or entry: "_+$G(DEST)) Q
 U:$L(INDEV) IO
 S INTT=+$P(^INRHD(DEST,0),U,2) I 'INTT D ERROR("Missing transaction type or entry for destination '"_$P(^INRHD(DEST,0),U)_"'") Q
 ;If transaction type is inactive, log error and update status
 I '$P($G(^INRHT(INTT,0)),U,5) D ELOG,ULOG^INHU(UIF,"E","Transaction type '"_$P($G(^INRHT(INTT,0)),U)_"' is not active") Q
 S SCR=$P(^INRHT(INTT,0),U,3) I 'SCR D ERROR("Missing script for transaction type: '"_$P(^INRHT(INTT,0),U)_"'") Q
 N INOA,INODA,INA
 ;Start transaction audit
 D:$D(XUAUDIT) TTSTRT^XUSAUD(UIF,"",$P($G(^INTHPC(INBPN,0)),U),$G(INHSRVR),"SCRIPT")
 K INHERR,INEDIT S:$P(^INTHU(UIF,0),U,15) INEDIT=$P(^(0),U,15) S C=",",Z="N INDEV,INTT S ER=$$^IS"_$E(SCR#100000+100000,2,6)_"("_UIF_",.INOA,.INODA)" X Z K INEDIT
 ;Stop transaction audit
 D:$D(XUAUDIT) TTSTP^XUSAUD(0)
 ;Variable INOA, if set within the inbound script, will be passed as
 ;the INA array to the ACK call.
 ;Variable INODA, if set within the inbound script, will be passed as
 ;the INDA array to the ACK call.
 D DONE D:$L(INDEV) ^%ZISC
 Q
DONE ;Entry point from INHOT to handle results of attempt
 ;Stuff LAST DATE/TIME
 K ^UTILITY("INV",$J),^UTILITY("INH",$J),DA,DIE,DIC,DR
 Q:'$D(^INTHU(UIF,0))
 S DIE="^INTHU(",DA=UIF,DR=".09////"_$$NOW^UTDT D ^DIE
 G NONFATAL:ER=1,FATAL:ER=2
 ;
COMP ;Successful processing
 N STATUS
 S STATUS="C" I '$D(INTT),$P(^INTHU(UIF,0),U,4) S STATUS="S"
 D ELOG,ULOG^INHU(UIF,STATUS,.INHERR)
 ; if inbound msg, process appl. ack
 D:$D(INTT) APPLACK(INTT,1,UIF,.INHERR,.INOA,.INODA)
 Q
 ;
NONFATAL ;Non-fatal error
 S ATT=$P(^INTHU(UIF,0),U,12)+1,$P(^(0),U,12)=ATT
 D REQ(UIF,ATT,$G(INTT)),ULOG^INHU(UIF,"P",.INHERR),ELOG
 K INHERR I MR'>ATT S INHERR="Max # of Retries exceeded." D FATAL Q
 I RR="" S INHERR="No Retry Rate found." D FATAL Q
 Q
 ;
FATAL ;Fatal error
 D ULOG^INHU(UIF,"E",.INHERR),ELOG
 ; if inbound msg, process appl. ack
 D:$D(INTT) APPLACK(INTT,0,UIF,.INHERR,.INOA,.INODA)
 Q
 ;
ELOG ;See if any error to log
 D:$D(INHERR)>9 END^INHE(UIF,.INHERR,$G(DEST)):$D(INTT),ENT^INHE(UIF,$G(DEST),.INHERR):'$D(INTT)
 Q
 ;
ELOGACK ; Log 'Appl. Ack creation' errors
 D:$D(INHERR)>9 END^INHE($G(INACKUIF),.INHERR,$G(DEST)):$D(INTT),ENT^INHE($G(INACKUIF),$G(DEST),.INHERR):'$D(INTT)
 Q
 ;
REQ(UIF,ATT,TRT) ;Requeue a transaction
 ;UIF = entry # in UIF
 ;ATT = current number of attempts
 ;TRT (optional) = processing transaction type
 S X=$$GRET^INHU(UIF,$G(TRT)),RR=$P(X,U),MR=+$P(X,U,2)
 Q:RR=""!(MR'>$G(ATT))
 ;Requeue the entry
 S D=$H,T=$P(D,",",2),D=+D
 S %=$E(RR,$L(RR))
 I %="M" S T=T+(RR*60) I T>86400 S RR=T\86400,T=T#86400,%="D"
 I %="H" S T=T+(RR*3600) I T>86400 S RR=T\86400,T=T#86400,%="D"
 I %="D" S D=D+RR
 S D=D_","_T D SET^INHD(D,+$P(^INTHU(UIF,0),U,2),UIF)
 Q
 ;
APPLACK(INTT,INSTAT,INUIF,INHERR,INOA,INODA,INQUE,INACKUIF) ; Send application
 ; acknowledgement to remote system in response to receipt of inbound
 ; message.
 ;
 ; Input:
 ;   INTT     - (req) TRANSACTION TYPE IEN for inbound msg
 ;   INSTAT   - (opt) flag - 1 = positive ack
 ;                           0 = negative ack
 ;   INUIF    - (req) UNIVERSAL INTERFACE IEN for inbound msg
 ;   INHERR   - (pbr) array containing error msg used to log an error
 ;                    in the ack.  Returns with script error msg if
 ;                    ack script encounters error.
 ;   INOA     - (pbr) array sending application-specific information
 ;                    from lookup/store routine to script
 ;   INODA    - (pbr) array sending application-specific information
 ;                    from lookup/store routine to script
 ;   INQUE    - (opt) flag - 0/""/non-existent = que ack to O/P Ctlr
 ;                           1 = do NOT que ack to O/P Ctlr
 ;   INACKUIF - (pbr) UNIVERSAL INTERFACE IEN for ack msg
 ;
 ; Output:
 ;   INACKUIF - (pbr) UNIVERSAL INTERFACE IEN for ack msg
 ;   INHERR   - (pbr) array containing error msg if ack script
 ;                    encountered errors during execution
 ;
 S INSTAT=+$G(INSTAT),INQUE=+$G(INQUE)
 ;
 ; save originating destination for routing appl. ack
 S INOA("INDEST")=$P($G(^INTHU(INUIF,2)),U,2)
 ;
 ; save INODA and selected INOA subscripts in ack UIF (per Selective
 ; Routing design) for use by downstream processes
 ;
 K ^UTILITY("INODA",$J) M ^UTILITY("INODA",$J)=INODA
 D ACK(INTT,INSTAT,INUIF,.INHERR,.INOA,.INODA,INQUE,.INACKUIF)
 D ELOGACK  ; log Ack creation errors
 I $G(INACKUIF) D
 . M ^INTHU(INACKUIF,6)=^UTILITY("INODA",$J)
 . I $D(INOA("DMISID")) M ^INTHU(INACKUIF,7,"DMISID")=INOA("DMISID")
 . I $D(INOA("MSGTYPE")) M ^INTHU(INACKUIF,7,"MSGTYPE")=INOA("MSGTYPE")
 K ^UTILITY("INODA",$J)
 Q
 ;
ACK(INTT,INSTAT,INUIF,INHERR,INOA,INODA,INQUE,INACKUIF) ;Send application
 ; acknowledgement.  Error msg included in ack can only be 80 chars;
 ; use first node of INHERR array.
 ;
 ; Called by: Interactive (PWS/CIW) and non-interactive interfaces.
 ;
 S:$D(INHERR) INHERR=$TR($S($D(INHERR)<10:INHERR,1:@$Q(INHERR)),"^",",")
 D ACK^INHUSEN3(INTT,INSTAT,INUIF,.INHERR,.INOA,.INODA,INQUE,.INACKUIF)
 K INDA,INA
 Q
 ;
ERROR(MESS,ROU) ;Error occurred
 ;INPUT:
 ;   MESS  - free text message
 ;   ROU   - calling routine
 I $G(ROU)="T"
 I $G(ROU)="S"
 ;Stop transaction audit
 D:$D(XUAUDIT) TTSTP^XUSAUD(1)
 D END^INHE($G(UIF),MESS,$G(DEST)) Q
 ;
ERR ;System error
 X ^INTHOS(1,3) K DIE,DA,DR,DQ,DE,DB,DIC
 D END^INHE($G(UIF),$$ERRMSG^INHU1,$G(DEST)) K ZTERROR
ERR1 S ER=2 D DONE
 Q
