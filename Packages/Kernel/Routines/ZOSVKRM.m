%ZOSVKR ;SF/KAK - Collect RUM Statistics for MSM ;3/10/00  07:43 [ 04/02/2003   8:29 AM ]
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
 S OPT=$P(PRTCL,"^"),PRTCL=$P(PRTCL,"^",2) Q:PRTCL=""
 N KMPRTYP S KMPRTYP=1  ; protocol
 Q
 ;
RU(KMPROPT,KMPRTYP,KMPRSTAT) ;-- record resource usage in ^XTMP("KMPR","JOB"
 Q
 ;
EN ;
 Q
