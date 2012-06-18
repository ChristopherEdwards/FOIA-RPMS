ABPAPRT ;CONTROL PRINT FOR 80 COLUMNS;[ 06/08/91  11:09 AM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 ;PROCEDURE TO GET PRINTER CONTROL CODES
 K A("PRINT") U IO Q:$D(IOST(0))'=1
 I $D(^%ZIS(2,IOST(0),12.1)) D
 .S A("PRINT",16)=^(12.1) ; Code for compressed print.
 I $D(^%ZIS(2,IOST(0),5)),$P(^(5),"^",1)'="" D
 .S A("PRINT",10)=$P(^(5),"^",1) ; Code for standard print.
 I $D(A("PRINT",10)) D
 .S IOP=IO_";132" W @A("PRINT",16) ; Set for compressed print.
