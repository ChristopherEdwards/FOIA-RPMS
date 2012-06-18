PSORN52A ;IHS/DSD/JCM/SAB/FLS-Break up of PSORN52 ;08/09/93
 ;;7.0;OUTPATIENT PHARMACY;**157**;DEC 1997
 Q  ; Call from tag
 ;
IBHLD ;
 I $P(PSOIBHLD,"^",2)="" S $P(PSOIBHLD,"^",2)=$S($P(PSOLDIBQ,"^",2)=1:1,$P(PSOLDIBQ,"^",2)=0:0,1:"")
 I $P(PSOIBHLD,"^",3)="" S $P(PSOIBHLD,"^",3)=$S($P(PSOLDIBQ,"^",3)=1:1,$P(PSOLDIBQ,"^",3)=0:0,1:"")
 I $P(PSOIBHLD,"^",4)="" S $P(PSOIBHLD,"^",4)=$S($P(PSOLDIBQ,"^",4)=1:1,$P(PSOLDIBQ,"^",4)=0:0,1:"")
 I $P(PSOIBHLD,"^",5)="" S $P(PSOIBHLD,"^",5)=$S($P(PSOLDIBQ,"^",5)=1:1,$P(PSOLDIBQ,"^",5)=0:0,1:"")
 I $P(PSOIBHLD,"^",6)="" S $P(PSOIBHLD,"^",6)=$S($P(PSOLDIBQ,"^",6)=1:1,$P(PSOLDIBQ,"^",6)=0:0,1:"")
 I $P(PSOIBHLD,"^",7)="" S $P(PSOIBHLD,"^",7)=$S($P(PSOLDIBQ,"^",7)=1:1,$P(PSOLDIBQ,"^",7)=0:0,1:"")
 Q
