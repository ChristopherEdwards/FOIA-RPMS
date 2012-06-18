%ZOSVKR ;SF/KAK - Collect RUM Statistics for OpenM/Cache;8/20/99  08:43  ;3/27/00  11:24 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003 
 ;;8.0;KERNEL;**90,94,107,122,143**;Jul 21, 1998
 ;
RO(OPT) ; Record option resource usage in ^XTMP("KMPR","JOB"
 ;
 N KMPRTYP S KMPRTYP=0  ; option
 G EN
 ;
RP(PRTCL)       ; Record protocol resource usage in ^XTMP("KMPR","JOB"
 ;
 ; Variable PRTCL = option_name^protocol_name
 N OPT,KMPRTYP
 S OPT=$P(PRTCL,"^"),PRTCL=$P(PRTCL,"^",2) Q:PRTCL=""
 ; protocol
 S KMPRTYP=1
 G EN
 ;
RU(KMPROPT,KMPRTYP,KMPRSTAT)    ;-- record resource usage in ^XTMP("KMPR","JOB"
 ;---------------------------------------------------------------------
 ; KMPROPT... Option name (may be option, protocol, rpc, etc.).
 ; KMPRTYP... Type of option:
 ;              0 - Option.
 ;              1 - Protocol.
 ;              2 - RPC (Remote Procedure Call).
 ;              3 - HL7.
 ; KMPRSTAT.. Status (for future use). 1 - start
 ;                                     2 - stop
 ;---------------------------------------------------------------------
 ;
 Q:$G(KMPROPT)=""
 S KMPRTYP=+$G(KMPRTYP)
 S KMPRSTAT=$G(KMPRSTAT)
 ;
 N OPT,PRTCL
 ;
 ; OPT = option name.
 ; PRTCL = protocol name (optional).
 S OPT=$P(KMPROPT,"^"),PRTCL=$P(KMPROPT,"^",2)
 ;
EN ;
 ; C........ comma (,)
 ; CURRENT.. current stats
 ; DATE..... date in fileman format
 ; DIFF..... difference (CURRENT minus PREV)
 ; DOW...... day of week
 ; HDATE.... date/time in $h format
 ; NODE..... current node
 ; PRIMETM.. prime time or non-prime time
 ; PREV..... previous stats
 ;
 N C,CURRENT,CURRHR,DATE,DIFF,DOW,HDATE,I,NODE,PREV,PREVHR
 N PRIMETM,TIME,Y
 ; quit if not in "PROD" uci.
 S Y="" X $G(^%ZOSF("UCI")) Q:Y'[$G(^%ZOSF("PROD"))
 D GETENV^%ZOSV S NODE=$P(Y,"^",3)
 S C=",",U="^"
 I KMPRTYP I OPT="" S:$P($G(^XTMP("KMPR","JOB",NODE,$J)),U,10)["$LOGIN$" OPT="$LOGIN$"
 I OPT="" Q:'+$G(^XUTL("XQ",$J,"T"))  S OPT=$P($G(^XUTL("XQ",$J,^XUTL("XQ",$J,"T"))),U,2) Q:OPT=""
 ;
 ; CURRENT = current stats for this $job.
 ; cpu^dio^bio^pg_fault^cmd^glo^$H_date^$H_sec^ascii_time
 S CURRENT=$$STATS Q:CURRENT=""
 ; concatenate ^OPTion^option_type
 S CURRENT=CURRENT_U_$S(KMPRTYP=2:"`"_OPT,KMPRTYP=3:"&"_OPT,1:OPT)_"***"_$G(PRTCL)_U_$G(XQT)
 ; if option and login or taskman
 I 'KMPRTYP I OPT="$LOGIN$"!(OPT="$STRT ZTMS$") S ^XTMP("KMPR","JOB",NODE,$J)=CURRENT Q
 ; if logout or stopping task or programmer mode
 I OPT="$LOGOUT$"!(OPT="$STOP ZTMS$")!(OPT="XUPROGMODE") K ^XTMP("KMPR","JOB",NODE,$J)
 ;
 ; PREV = previous stats for this $job.
 S PREV=$G(^XTMP("KMPR","JOB",NODE,$J)) S ^($J)=CURRENT
 Q:PREV=""
 ;
 ; check for negative numbers for m commands and glo references
 F I=5,6 D 
 .S:$P(CURRENT,U,I)<0 $P(CURRENT,U,I)=$P(CURRENT,U,I)+(2**32)
 .S:$P(PREV,U,I)<0 $P(PREV,U,I)=$P(PREV,U,I)+(2**32)
 ;
 S $P(CURRENT,U,7)=$P(CURRENT,U,7)-$P(PREV,U,7)*86400+$P(CURRENT,U,8)
 S HDATE=$P(PREV,U,7),$P(PREV,U,7)=$P(PREV,U,8)
 ; quit if not $h
 Q:'HDATE
 ;
 ; DIFF = CURRENT - PREV (current stats minus previous stats)
 ; cpu^dio^bio^pg_fault^cmd^glo^elapsed_sec^option_type
 F I=1:1:7 S $P(DIFF,U,I)=$P(CURRENT,U,I)-$P(PREV,U,I)
 ; option name        time
 S OPT=$P(PREV,U,10),TIME=$P($P(PREV,U,8),".")
 ; date in fm format.
 S DATE=$$HTFM^XLFDT(HDATE),DATE=$P(DATE,".")
 ; day of week.
 S DOW=$$DOW^XLFDT(DATE,1)
 ; PRIMETM =  0: non-prime time
 ;            1: prime time
 S PRIMETM=0
 ; prime time if not saturday or sunday or holiday
 ;            if after 8am and before 5pm.
 I DOW>0&(DOW<6)&('$G(^HOLIDAY(DATE,0))) I TIME>28799&(TIME<61201) S PRIMETM=1
 ; daily stats by $j.
 F I=1:1:7 S $P(^XTMP("KMPR","DLY",NODE,HDATE,OPT,$J,PRIMETM),U,I)=$P($G(^XTMP("KMPR","DLY",NODE,HDATE,OPT,$J,PRIMETM)),U,I)+$P(DIFF,U,I)
 ; 8th piece is count.
 S $P(^XTMP("KMPR","DLY",NODE,HDATE,OPT,$J,PRIMETM),U,8)=$P(^XTMP("KMPR","DLY",NODE,HDATE,OPT,$J,PRIMETM),U,8)+1
 ;
 ; keep track of hours with activity - this will be used to determine
 ; actual hours of activity when moving data to file 8971.1
 S DATE=$$HTFM^XLFDT(HDATE_","_TIME)
 ;S TIME=+$E($P(DATE,".",2),1,2),DATE=$P(DATE,".")
 ; hour for 'previous' dat.
 S PREVHR=+$E($P(DATE,".",2),1,2),DATE=$P(DATE,".")
 ; current hour.
 S CURRHR=+$E($P($$HTFM^XLFDT($H),".",2),1,2)
 ; record all hours this option ran.
 F TIME=PREVHR:1:CURRHR D 
 .; because of zero hour add 1 to time - will offset each hour by 1
 .S:DATE $P(^XTMP("KMPR","HOURS",DATE,NODE),U,(TIME+1))=1
 ;
 Q
 ;
STATS() ;-- extrinsic - return current stats for this $job
 ;
 N V
 S V=$V(-1,$J)
 ; current stats for this $job.
 ; cpu^dio^bio^pg_fault^cmd^glo^$H_date^$H_sec^time in thousands
 Q "^^^^"_$P($P(V,"^",7),",")_"^"_$P($P(V,"^",7),",",2)_"^"_+$H_"^"_$P($H,",",2)_"^"_$ZTIMESTAMP
