ABPACLG6 ;CHECK LOG UTILITY FUNCTIONS - PART 5; [ 06/27/91  6:04 AM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 Q  ;;NOT AN ENTRY POINT
START ;ENTRY POINT - CONTINUATION OF ACCOUNT TRANSFER FUNCTION
 ;---------------------------------------------------------------------
 ;PROCEDURE TO CREATE A NEW CHECK ENTRY
 I +$P(Y,"^",3)>0 D  G SUTIL
 .S DR="1///"_ABPACHK("XMIT")_";2///"_DUZ_";3///"_ABPACHK("AMT")
 .S DR=DR_";4///"_DUZ_";5///NOW;6///N;7///0;8///"_ABPA("AMT") D ^DIE
 .Q
 ;---------------------------------------------------------------------
 ;PROCEDURE TO UPDATE AN EXISTING CHECK
 I +$P(Y,"^",3)'>0 D
 .S RBAL=$P(Y(0),"^",9)+ABPA("AMT")
 .S DR="4///"_DUZ_";5///NOW;8///"_RBAL D ^DIE
 .Q
 ;---------------------------------------------------------------------
SUTIL S ^TMP("ABPACLG1","T",ABPA("AMT"),ABPACHK("NUM"),INSPTR,ACTPTR,ABPA("TO"),DT)=ABPACHK("XMIT")
 I ABPADFN(1)=1 D
 .S ABPA("$P")=+$P(^ABPAPBAT($P(ABPACHK("XMIT"),"."),0),"^",12)
 .S ABPA("$P")=ABPA("$P")+ABPA("AMT")
 .S $P(^ABPAPBAT($P(ABPACHK("XMIT"),"."),0),"^",12)=ABPA("$P")
 I ABPADFN(1)'=1 I DA(2)=1 D
 .S ABPA("$P")=+$P(^ABPAPBAT($P(ABPACHK("XMIT"),"."),0),"^",13)
 .S ABPA("$P")=ABPA("$P")+ABPA("AMT")
 .S $P(^ABPAPBAT($P(ABPACHK("XMIT"),"."),0),"^",13)=ABPA("$P")
 D CLEAR^ABPACLG1 K ABPACHK D HEAD^ABPACLG1
 G GETCHK^ABPACLG1
