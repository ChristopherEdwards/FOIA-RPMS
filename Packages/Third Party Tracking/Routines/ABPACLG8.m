ABPACLG8 ;CHECK LOG MODIFICATIONS REPORT; [ 03/29/91  2:02 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 W !!,"NOT AN ENTRY POINT - ACCESS DENIED",!! Q
 ;--------------------------------------------------------------------
RETURNS ;PROCEDURE TO PROCESS RETURN NODES
 S R=0 F I=0:0 D  Q:R=""
 .S R=$O(^TMP("ABPACLG1","R",R)) Q:R=""
 .S R1=0 F M=0:0 D  Q:R1=""
 ..S R1=$O(^TMP("ABPACLG1","R",R,R1)) Q:R1=""
 ..S RR=0 F J=0:0 D  Q:RR=""
 ...S RR=$O(^TMP("ABPACLG1","R",R,R1,RR)) Q:RR=""
 ...S R3=0 F K=0:0 D  Q:R3=""
 ....S R3=$O(^TMP("ABPACLG1","R",R,R1,RR,R3)) Q:R3=""
 ....S R4=0 F L=0:0 D  Q:R4=""
 .....S R4=$O(^TMP("ABPACLG1","R",R,R1,RR,R3,R4)) Q:R4=""
 .....S Y=^(R4),Y=+$E(Y,4,5)_"/"_+$E(Y,6,7)_"/"_+$E(Y,2,3)
 .....S ABPACHK("XMIT")=Y,ABPAINS=$P(^AUTNINS(RR,0),"^")
 .....S ACCTPT=$P(^DIC(4,R3,0),"^")
 .....S TCNT=TCNT+1 W !!,$J(TCNT,2),".",?4,"It is requested that "
 .....W "check number ",R," in the amount of $",$J(R1,8,2),!?4
 .....W "from ",ABPAINS," originally deposited for",!?4
 .....W ACCTPT," be returned per attached instructions from the "
 .....W "insurer.",!!?4,"This was originally submitted on the "
 .....W "transmittal dated ",ABPACHK("XMIT"),"."
 .....I $Y>46 D ^%AUCLS,HD^ABPACLG4
 Q
 ;--------------------------------------------------------------------
IMPROPER ;PROCEDURE TO PROCESS IMPROPER NODES
 S R=0 F I=0:0 D  Q:R=""
 .S R=$O(^TMP("ABPACLG1","I",R)) Q:R=""
 .S R1=0 F M=0:0 D  Q:R1=""
 ..S R1=$O(^TMP("ABPACLG1","I",R,R1)) Q:R1=""
 ..S RR=0 F J=0:0 D  Q:RR=""
 ...S RR=$O(^TMP("ABPACLG1","I",R,R1,RR)) Q:RR=""
 ...S R3=0 F K=0:0 D  Q:R3=""
 ....S R3=$O(^TMP("ABPACLG1","I",R,R1,RR,R3)) Q:R3=""
 ....S R4=0 F L=0:0 D  Q:R4=""
 .....S R4=$O(^TMP("ABPACLG1","I",R,R1,RR,R3,R4)) Q:R4=""
 .....S Y=^(R4),Y=+$E(Y,4,5)_"/"_+$E(Y,6,7)_"/"_+$E(Y,2,3)
 .....S ABPACHK("XMIT")=Y,ABPAINS=$P(^AUTNINS(RR,0),"^")
 .....S ACCTPT=$P(^DIC(4,R3,0),"^")
 .....S TCNT=TCNT+1 W !!,$J(TCNT,2),".",?4,"It is requested that "
 .....W "check number ",R," in the amount of $",$J(R1,8,2),!?4
 .....W "from ",ABPAINS," originally deposited for",!?4
 .....W ACCTPT," be deducted from private insurance collections"
 .....W !?4,"as it has been determined the check was not issued "
 .....W "as reimbursement",!?4,"for patient care.",!!?4
 .....W "This was originally submitted on the transmittal dated "
 .....W ABPACHK("XMIT"),"." I $Y>46 D ^%AUCLS,HD^ABPACLG4
 Q
