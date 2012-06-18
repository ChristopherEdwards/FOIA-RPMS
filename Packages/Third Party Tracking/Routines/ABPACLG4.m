ABPACLG4 ;CHECK LOG MODIFICATIONS REPORT; [ 03/29/91  12:20 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 W !!,"NOT AN ENTRY POINT - ACCESS DENIED",!! Q
 ;--------------------------------------------------------------------
HD ;PROCEDURE TO PERFORM MEMORANDUM HEADING
 S ABPAPG=ABPAPG+1 D CHECK^ABPAOPT I +ABPAOPT(5)>0 D
 .F I=1:1:+ABPAOPT(5) W !
 W ?55,"PAGE ",ABPAPG F I=1:1:5 W !
 W ?12,+$E(ABPADT,4,5)_"/"_+$E(ABPADT,6,7)_"/"_+$E(ABPADT,2,3),!!
 W ?12,ABPAOPT(3),!!!
 W ?12,"Private Insurance Collections"," - "
 W "Control Log Corrections",!!?12,"Finance",!?12
 W $P(^DIC(4,DUZ(2),0),"^"),!!!!
 W ?12,"The following corrections to the private insurance collections"
 W !?12,"control log have been noted by this office:",!!!
 Q
 ;--------------------------------------------------------------------
EDITS ;PROCEDURE TO PROCESS EDIT NODES
 S R=0 F I=0:0 D  Q:R=""
 .S R=$O(^TMP("ABPACLG1","E",R)) Q:R=""
 .S R1=0 F M=0:0 D  Q:R1=""
 ..S R1=$O(^TMP("ABPACLG1","E",R,R1)) Q:R1=""
 ..S RR=0 F J=0:0 D  Q:RR=""
 ...S RR=$O(^TMP("ABPACLG1","E",R,R1,RR)) Q:RR=""
 ...S R3=0 F K=0:0 D  Q:R3=""
 ....S R3=$O(^TMP("ABPACLG1","E",R,R1,RR,R3)) Q:R3=""
 ....S R4=0 F L=0:0 D  Q:R4=""
 .....S R4=$O(^TMP("ABPACLG1","E",R,R1,RR,R3,R4)) Q:R4=""
 .....S Y=^(R4),Y=+$E(Y,4,5)_"/"_+$E(Y,6,7)_"/"_+$E(Y,2,3)
 .....S ABPACHK("XMIT")=Y,ABPAINS=$P(^AUTNINS(RR,0),"^")
 .....S TCNT=TCNT+1 W !!,$J(TCNT,2),".",?4,"Check number ",R
 .....W " in the amount of $",$J(R1,8,2)," from",!?4,ABPAINS
 .....W " has been corrected to read ",R3,!?4,"as of"
 .....W " ",+$E(R4,4,5)_"/"_+$E(R4,6,7)_"/"_+$E(R4,2,3),".",!?4
 .....W "This was originally submitted on the transmittal dated "
 .....W ABPACHK("XMIT"),"." I $Y>46 D ^%AUCLS,HD
 Q
 ;--------------------------------------------------------------------
END ;PROCEDURE TO PERFORM MEMORANDUM CLOSING
 I $Y>46 D ^%AUCLS S ABPAPG=ABPAPG+1 W ?55,"PAGE ",ABPAPG,!!!!!!!!
 W !!!!!!?45,ABPAOPT(4),!?45,ABPAOPT(10)
 W !?45,$P(^DIC(4,DUZ(2),0),"^")
 D ^%AUCLS
 Q
 ;--------------------------------------------------------------------
MAIN ;ENTRY POINT - THE MAIN ROUTINE DRIVER
 Q:$D(^TMP("ABPACLG1"))'=10
 S ABPAPG=0,TCNT=0 D ^%AUCLS,HD
 LOCK ^TMP("ABPACLG1")
 D EDITS,IMPROPER^ABPACLG8,RETURNS^ABPACLG8,TXFERS^ABPACLG9,END
 LOCK ^TMP("ABPACLG1")
 K ABPACHK("XMIT"),ABPAINS,ABPAPG,ACCTPT,FROM,I,J,K,L,M,R,R1,R3,R4,R5
 K R6,RR,TCNT,TO
 Q
