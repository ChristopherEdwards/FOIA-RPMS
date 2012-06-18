ABPACLG9 ;CHECK LOG MODIFICATIONS REPORT; [ 03/29/91  12:00 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 W !!,"NOT AN ENTRY POINT - ACCESS DENIED",!! Q
 ;--------------------------------------------------------------------
TXFERS ;PROCEDURE TO PROCESS TRANSFER NODES
 S R=0 F I=0:0 D  Q:R=""
 .S R=$O(^TMP("ABPACLG1","T",R)) Q:R=""
 .S RR=0 F J=0:0 D  Q:RR=""
 ..S RR=$O(^TMP("ABPACLG1","T",R,RR)) Q:RR=""
 ..S R3=0 F K=0:0 D  Q:R3=""
 ...S R3=$O(^TMP("ABPACLG1","T",R,RR,R3)) Q:R3=""
 ...S R4=0 F L=0:0 D  Q:R4=""
 ....S R4=$O(^TMP("ABPACLG1","T",R,RR,R3,R4)) Q:R4=""
 ....S R5=0 F M=0:0 D  Q:R5=""
 .....S R5=$O(^TMP("ABPACLG1","T",R,RR,R3,R4,R5)) Q:R5=""
 .....S R6=0 F N=0:0 D  Q:R6=""
 ......S R6=$O(^TMP("ABPACLG1","T",R,RR,R3,R4,R5,R6)) Q:R6=""
 ......S Y=^(R6),Y=+$E(Y,4,5)_"/"_+$E(Y,6,7)_"/"_+$E(Y,2,3)
 ......S ABPACHK("XMIT")=Y,ABPAINS=$P(^AUTNINS(R3,0),"^")
 ......S FROM=$P(^DIC(4,R4,0),"^"),TO=$P(^DIC(4,R5,0),"^")
 ......S TCNT=TCNT+1 W !!,$J(TCNT,2),".",?4,"It is requested "
 ......W "that $",$J(R,8,2)," of check number ",RR," from ",!?4
 ......W ABPAINS," be transferred from accounting point",!?4
 ......W FROM," to ",TO,".",!?4
 ......W !?4,"This was originally submitted on the transmittal "
 ......W "dated ",ABPACHK("XMIT"),"."
 ......I $Y>46 D ^%AUCLS,HD^ABPACLG4
 Q
