%ZOSVKR ;SF/KAK/RAK - Collect RUM Statistics for VAX-DSM;8/20/99  08:44 ;3/10/00  07:42 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003 
 ;;8.0;KERNEL;**90,94,107,122,143**;Jul 21, 1998
 ;
RO(OPT) ; Record option resource usage in ^XTMP("KMPR","JOB"
 ;
 N KMPRTYP S KMPRTYP=0  ; option
 G EN
 ;
RP(PRTCL) ; Record protocol resource usage in ^XTMP("KMPR","JOB"
 ;
 ; Variable PRTCL = option_name^protocol_name
 N OPT
 S OPT=$P(PRTCL,"^"),PRTCL=$P(PRTCL,"^",2) Q:PRTCL=""
 N KMPRTYP S KMPRTYP=1  ; protocol
 G EN
 ;
RU(KMPROPT,KMPRTYP,KMPRSTAT) ;-- set resource usage into ^XTMP("KMPR","JOB"
 ;-----------------------------------------------------------------------
 ; KMPROPT... Option name (may be option, protocol, rpc, etc.).
 ; KMPRTYP... Type of option:
 ;              0 - Option.
 ;              1 - Protocol.
 ;              2 - RPC (Remote Procedure Call).
 ;              3 - HL7.
 ; KMPRSTAT.. Status (for future use). 1 - start
 ;                                     2 - stop
 ;-----------------------------------------------------------------------
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
 N ARRAY,C,CURRENT,CURRHR,DATE,DIFF,DOW,HDATE,I,NODE,PREV,PREVHR
 N PRIMETM,TIME,Y
 ; quit if not in "PROD" uci.
 S Y="" X $G(^%ZOSF("UCI")) Q:Y'[$G(^%ZOSF("PROD"))
 S C=",",NODE=$P($ZC(%GETSYI),C,4),U="^"
 I KMPRTYP I OPT="" S:$P($G(^XTMP("KMPR","JOB",NODE,$J)),U,10)["$LOGIN$" OPT="$LOGIN$"
 I OPT="" Q:'+$G(^XUTL("XQ",$J,"T"))  S OPT=$P($G(^XUTL("XQ",$J,^XUTL("XQ",$J,"T"))),U,2) Q:OPT=""
 ;
 ; CURRENT = current stats for this $job.
 ; cpu^dio^bio^pg_fault^cmd^glo^$H_date^$H_sec^ascii_time
 S CURRENT=$$STATS Q:CURRENT=""
 ; concatenate ^OPTion^option_type
 S CURRENT=CURRENT_U_$S(KMPRTYP=2:"`"_OPT,KMPRTYP=3:"&"_OPT,1:OPT)_"***"_$G(PRTCL)_U_$G(XQT)
 ; if option and login or taskman.
 I 'KMPRTYP I OPT="$LOGIN$"!(OPT="$STRT ZTMS$") S ^XTMP("KMPR","JOB",NODE,$J)=CURRENT Q
 ;
 ; PREV = previous stats for this $job.
 S PREV=$G(^XTMP("KMPR","JOB",NODE,$J)) S ^($J)=CURRENT
 I OPT="$LOGOUT$"!(OPT="$STOP ZTMS$")!(OPT="XUPROGMODE") K ^XTMP("KMPR","JOB",NODE,$J)
 Q:PREV=""
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
 ; global location for data storage.
 S ARRAY=$NA(^XTMP("KMPR","DLY",NODE,HDATE,OPT,$J,PRIMETM))
 ; daily stats by $j.
 F I=1:1:7 S $P(@ARRAY,U,I)=$P($G(@ARRAY),U,I)+$P(DIFF,U,I)
 ; 8th piece is count.
 S $P(@ARRAY,U,8)=$P(@ARRAY,U,8)+1
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
 .; because of zero hour add 1 to time.  this will offset each hour by 1.
 .S:DATE $P(^XTMP("KMPR","HOURS",DATE,NODE),U,(TIME+1))=1
 ;
 Q
 ;
STATS() ;-- extrinsic - return current stats for this $job
 N C,H,KMPRCMD,KMPRGLO,ZH
 S C="," ;,ZH=$ZH,H=$P(ZH,C,3)
 D JT
 Q:KMPRCMD="" ""
 S ZH=$ZH,H=$P(ZH,C,3),H=$E(H,13,23),H=$P($H,C)_C_($P(H,":")*3600+($P(H,":",2)*60)+$P(H,":",3))
 ;
 ; current stats for this $job.
 ; cpu^dio^bio^pg_fault^cmd^glo^$H_date^$H_sec^ascii_time
 Q $P(ZH,C)_U_$P(ZH,C,7)_U_$P(ZH,C,8)_U_$P(ZH,C,4)_U_KMPRCMD_U_KMPRGLO_U_$P(H,C)_U_$P(H,C,2)_U_$P(ZH,C,3)
 ;
JT ; Calculate the Job Table (%KMPRJT) for this job
 ; %KMPRJT should be made a system wide variable
 ;
 N %GLSBASE,%JOB,%JOBSIZ,%JOBTAB,%MAXPROC,%PID,%SMSTART,%TYPE,KMPROUT,X
 ;
 ; Return the current number of commands and global references
 ; KMPRCMD and KMPRGLO equal to null if NOT successful
 S (KMPRCMD,KMPRGLO)="",KMPROUT=0,U="^"
 ;
 ; Check for correct Job Table (%KMPRJT) for this job
 I $D(%KMPRJT) I $V(%KMPRJT+20)=$J S %TYPE="DSM" D USER G EXIT
 S %SMSTART=$V($ZK(GLS$SMSTART)) G:'%SMSTART EXIT
 S %GLSBASE=$V($V(0)+44)
 S %JOBTAB=%SMSTART+$V(%SMSTART+$V(%GLSBASE+124)),%JOBSIZ=$V(%GLSBASE+128)
 S %MAXPROC=$V($V(%GLSBASE+84)+%SMSTART)
 ;
 ; Go through Job Table looking for this process
 F %JOB=1:1:%MAXPROC Q:KMPROUT  S %KMPRJT=%JOB*%JOBSIZ+%JOBTAB D
 .I $V(%KMPRJT+20) S %PID=$V(%KMPRJT+20),%TYPE="DSM" I %PID=$J D USER S KMPROUT=1
 ;
EXIT ;
 S X=^%ZOSF("ERRTN"),@^%ZOSF("TRAP")
 Q
 ;
USER ;
 ; Watch for NONEXPR process
 S X="UERR^%ZOSVKR",@^%ZOSF("TRAP")
 ;
 ; Process improperly exited DSM
 I %TYPE="DSM",$V(%KMPRJT+$ZK(JOB_B_FLAGS),-1,1)\$ZK(JOB_M_EXITED)#2 G IMPROP
 ;
 ; Get commands and global references from job table
 S KMPRCMD=$V(%KMPRJT),KMPRGLO=$V(%KMPRJT+12)
 Q
UERR ;
 ; Ignore NONEXPR (improperly exited DSM process) and SUSPENDED process
 I $ZE["NONEXPR"!($ZE["SUSPENDED") Q
 ZQ
IMPROP ;
 ; Ignore improperly exited DSM process
 Q
