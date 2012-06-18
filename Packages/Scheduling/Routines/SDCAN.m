SDCAN ;ALB/LDB - CREATE INDIVIDUALLY CANCELLED APPT. NODES ; [ 09/13/2001  2:19 PM ]
 ;;5.3;Scheduling;;Aug 13, 1993
 ;IHS/ANMC/LJF 11/30/2000 changed $N to $O
 ;
 ;K Q8 F Q7=0:0 S Q7=$N(^SC($P(^DPT(DA(1),"S",DA,0),"^"),"S",DA,1,Q7)) Q:Q7'>0  I $P(^(Q7,0),"^")=DA(1),$P(^(0),"^",9)="C" S Q8="" Q  ;IHS/ANMC/LJF 11/30/2000
 K Q8 F Q7=0:0 S Q7=$O(^SC($P(^DPT(DA(1),"S",DA,0),"^"),"S",DA,1,Q7)) Q:Q7'>0  I $P(^(Q7,0),"^")=DA(1),$P(^(0),"^",9)="C" S Q8="" Q  ;IHS/ANMC/LJF 11/30/2000 $N->$O
 I '$D(Q8) S ^DPT("ASDCN",$P(^DPT(DA(1),"S",DA,0),"^"),DA,DA(1))=$S($P(^DPT(DA(1),"S",DA,0),"^",2)["P":1,1:"")
 K Q7,Q8 Q
