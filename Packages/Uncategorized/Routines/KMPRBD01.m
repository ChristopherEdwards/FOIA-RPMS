KMPRBD01 ;SFISC/RAK - RUM Daily/Weekly Compression ;1/20/00  07:35
 ;;1.0;CAPACITY MANAGEMENT - RUM;**1**;Dec 09, 1998
 ;
EN ;-- entry point for Background Driver.
 ;
 S:'$G(DT) DT=$$DT^XLFDT
 ; Protect ^XTMP("KMPR") from the XQ82 background cleanup job
 S ^XTMP("KMPR",0)=DT+10000
 ;
 S:'$G(DT) DT=$$DT^XLFDT
 ;
 ; store daily stats in file #8971.1 (RESOURCE USAGE MONITOR).
 S ^XTMP("KMPR","BACKGROUND","START")=$$FMTE^XLFDT($$NOW^XLFDT)
 S ^XTMP("KMPR","BACKGROUND","STOP")=""
 D DAILY^KMPRBD02(+$H)
 S ^XTMP("KMPR","BACKGROUND","STOP")=$$FMTE^XLFDT($$NOW^XLFDT)
 ;
 ; clean up old "job" nodes.
 D CLEAN
 ;
 ; if sunday do weekly compression
 I '$$DOW^XLFDT(DT,1) D 
 .; store weekly start/stop stats.
 .S ^XTMP("KMPR","BACKGROUND","WEEKLY","START")=$$FMTE^XLFDT($$NOW^XLFDT)
 .S ^XTMP("KMPR","BACKGROUND","WEEKLY","STOP")=""
 .D WEEKLY^KMPRBD02(DT)
 .S ^XTMP("KMPR","BACKGROUND","WEEKLY","STOP")=$$FMTE^XLFDT($$NOW^XLFDT)
 ;
 ; check for errors.
 D ERRORS
 ;
 Q
 ;
CLEAN ;-- clean up old "JOB" nodes
 ;
 N JOB,NODE S NODE=""
 F  S NODE=$O(^XTMP("KMPR","JOB",NODE)) Q:NODE=""  D
 .S JOB=0 F  S JOB=$O(^XTMP("KMPR","JOB",NODE,JOB)) Q:'+JOB  D
 ..I '$D(^XUTL("XQ",JOB)) K ^XTMP("KMPR","JOB",NODE,JOB)
 ;
 ; Store the number of active user jobs into ^XTMP("KMPR","ACTIVE")
 ; D CLUSTER^%ZKMPRC1
 ;
 Q
 ;
ERRORS ; check and process errors.
 ;
 Q:'$D(^XTMP("KMPR","ERR"))
 ;
 N H,I,LN,N,O,SITE,TEXT,XMSUB,X,XMTEXT,XMY,XMZ,Y,Z
 ;
 S SITE=$$SITE^VASITE
 S XMSUB="RUM Error at site "_$P(SITE,U,3)_" on "_$$FMTE^XLFDT($$DT^XLFDT)
 S TEXT(1)="  The following error(s) have been logged at "_$P(SITE,U,2)_" ("_$P(SITE,U,3)_") "
 S TEXT(2)="  while moving data from ^XTMP(""KMPR"",""DLY"") to file 8971.1."
 S H="",LN=3
 ; H = date in $H format (+$H).
 ; N = node name.
 ; O = option.
 F  S H=$O(^XTMP("KMPR","ERR",H)) Q:H=""  S N="" D 
 .F  S N=$O(^XTMP("KMPR","ERR",H,N)) Q:N=""  S O="" D 
 ..F  S O=$O(^XTMP("KMPR","ERR",H,N,O)) Q:O=""  D 
 ...S TEXT(LN)="",LN=LN+1
 ...S TEXT(LN)="Date..: "_H_"    Node: "_N,LN=LN+1
 ...S TEXT(LN)="Option: "_O,LN=LN+1
 ...; prime time.
 ...S TEXT(LN)="Prime Time     = "_$G(^XTMP("KMPR","ERR",H,N,O,0)),LN=LN+1
 ...; non-prime time.
 ...S TEXT(LN)="Non-Prime Time = "_$G(^XTMP("KMPR","ERR",H,N,O,1)),LN=LN+1
 ...; message.
 ...F I=0:0 S I=$O(^XTMP("KMPR","ERR",H,N,O,"MSG",I)) Q:'I  D 
 ....S TEXT(LN)=^XTMP("KMPR","ERR",H,N,O,"MSG",I),LN=LN+1
 S XMTEXT="TEXT("
 S XMY("G.KMP2-RUM@DOMAIN.NAME")=""
 D ^XMD
 ;
 K ^XTMP("KMPR","ERR")
 ;
 Q
