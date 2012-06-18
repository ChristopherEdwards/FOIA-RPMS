ABPVPRT ;CONTROL PRINT FOR 80 COLUMNS [ 06/02/91  12:54 PM ]
 ;;2.0;FACILITY PVT-INS TRACKING;*0*;IHS-OKC/KJR;AUGUST 7, 1991
COMP ;ENTRY POINT. Compressed print for printer.
 K A("PRINT") I $D(^%ZIS(2,IOST(0),12.1)) D
 .S A("PRINT",16)=^(12.1) ; Code for compressed print.
 I $D(^%ZIS(2,IOST(0),5)),$P(^(5),"^",1)'="" D
 .S A("PRINT",10)=$P(^(5),"^",1) ; Code for standard print.
 I $D(A("PRINT",10)) S IOP=IO_";132" D
 .D ^%ZIS U IO W @A("PRINT",16) ; Set for compressed print.
 Q
