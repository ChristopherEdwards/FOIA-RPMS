ABPVCK1 ;3P BILL TRANSMISSION EDIT REPORT;[ 06/03/91  1:49 PM ]
 ;;2.0;FACILITY PVT-INS TRACKING;*0*;IHS-OKC/KJR;AUGUST 7, 1991
 W !!,"NOT AN ENTRY POINT!",!! Q
 ;--------------------------------------------------------------------
A3 ;PROCEDURE TO BUILD SORTED UTILITY GLOBAL INDEX
 K ^UTILITY("ABPVCK") S RR=+BRECNO F ABPVI=0:0 D  Q:+RR=0
 .S RR=$O(^ABPVFAC(RR)) Q:+RR=0
 .S ZX=^ABPVFAC(RR,0),PDFN=$P(ZX,"^",2),PNAME=$P(^DPT(PDFN,0),"^")
 .S ^UTILITY("ABPVCK",PNAME,$P(ZX,"^",3),RR)=""
 .K ZX,PDFN,PNAME
 Q
 ;--------------------------------------------------------------------
A4 ;PROCEDURE TO PRINT SORTED EXPORT TRANSMITTAL LOG
 K ^UTILITY("ABPVTXE") D ^ABPVPRT,HEADER^ABPVCK0
 S R=0 F ABPVI=0:0 D  Q:R=""
 .S R=$O(^UTILITY("ABPVCK",R)) Q:R=""
 .S RR=0 F ABPVI=0:0 D  Q:+RR=0
 ..S RR=$O(^UTILITY("ABPVCK",R,RR)) Q:+RR=0
 ..S RRR=0 F ABPVI=0:0 D  Q:+RRR=0
 ...S RRR=$O(^UTILITY("ABPVCK",R,RR,RRR)) Q:+RRR=0
 ...S ZX=^ABPVFAC(RRR,0)
 ...S X=$P(ZX,"^",11)
 ...W ?1,$E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)
 ...W ?11,$J($P(ZX,"^",1),7)
 ...S PDFN=$P(ZX,"^",2) W ?20,$E($P(^DPT(PDFN,0),"^",1),1,30)
 ...W ?52,$J($P(ZX,"^",5),6)
 ...S X=$P(ZX,"^",3)
 ...W ?61,$E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)
 ...S ZINSCO=$P(ZX,"^",8) D INSCHK^ABPVCK0
 ...W ?71,$P(^AUTNINS($P(ZX,"^",8),0),"^",1)
 ...W ?103,$J($P(ZX,"^",9),8,2)
 ...W ?113,$P(ZX,"^",6)
 ...W ?117,$J($P(ZX,"^",7),2),!
 ...S ZCLCT=ZCLCT+1,ZCLAMT=ZCLAMT+$P(ZX,"^",9)
 ...I $Y>50 D HEADER^ABPVCK0
 W ?5 F I=1:1:110 W "-"
 W !,?5,"TOTAL CLAIMS = ",ZCLCT,?45,"TOTAL CLAIM AMT = ",?64
 W $J(ZCLAMT,8,2),!! H 3
 Q
