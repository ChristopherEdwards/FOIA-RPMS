BOPTSD ;IHS/ILC/ALG/CIA/PLS -  Send All Active Inpatients to Interface;09-Feb-2006 15:35;DU
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
 ;;
ALL ;  send all active patients
 S LOOP="^DPT(""CN""",CHK=LOOP,LOOP=LOOP_")"
LOOP S LOOP=$Q(@LOOP) I $E(LOOP,1,$L(CHK))'=CHK G DONE
 S DFN=$P($P(LOOP,",",3),")",1)
 W !,LOOP,"  -  ",DFN
 D RUN
 G LOOP
DONE W !,"DONE"
 Q
 ;
RUN ;xmit to interface
 S (PSPG,BOPDFN)=DFN D
 .D INIT^BOPCAP I $D(BOPQ) W " *" Q
 .D ADT^BOPCAP
 .W !,"  ORDERS"
LOOP2 .S PSGP=DFN F BOPO=0:0 S BOPO=$O(^PS(55,DFN,5,BOPO)) Q:BOPO<1  D
 ..S BOPN0=$G(^PS(55,DFN,5,BOPO,0)) Q:'BOPN0
 ..S PSGORD=BOPO ;Order Number
 ..Q:$P(BOPN0,U,9)'="A"  ;Status
 ..Q:'$P($G(^PS(55,DFN,5,BOPO,4)),U,9)  ;Verified
 ..D NEW^BOPCAP
 Q
 ;
ONE ; EP - transmit one patient to interface
 N LOOP,DFN,CHK,PSPG,BOPDFN,Y,ANS,DIC S (ANS,Y)=0
 S DIC="^DPT(",DIC(0)="QEAM" D ^DIC Q:Y'>0  S DFN=+Y
 S DIR("A")="Is this the correct patient",DIR(0)="Y",DIR("B")="YES" D ^DIR K DIR Q:$D(DIRUT)
 I Y'=1 G ONE
 I '$D(^PS(55,DFN)) W !,"Not a pharmacy patient.",$C(7) G ONE
 D RUN G ONE
