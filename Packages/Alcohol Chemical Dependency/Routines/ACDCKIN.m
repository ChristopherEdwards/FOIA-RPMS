ACDCKIN ;IHS/ADC/EDE/KML - CHECK FOR DUP INIT CONTACT BY COMPONENT;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;*************************************************************
 ;DA is defined at ^ACDVIS(DA,0) DO NOT change DA value!!
 ;ACDDFNP is client pointer
 ;ACDCOMC is component pointer
 ;*****************************************************************
EN ;EP
 ;//[ACD1 (ADD)]
 K ACDCKIN
 F ACDDA=0:0 S ACDDA=$O(^ACDVIS("D",ACDDFNP,ACDDA)) Q:'ACDDA  I ACDDA'=DA S ACDN0=^ACDVIS(ACDDA,0) I $P(ACDN0,U,2)=ACDCOMC,$P(ACDN0,U,4)="IN" G WARN
 Q
WARN ;Issue warning message
 S ACDCKIN=1,ACDONCE=1
 W !!,*7,*7,"** Warning, this client has at least one previous 'initial ??' contact",!?3,"for component code: ",$P(^ACDCOMP(ACDCOMC,0),U)
 K ACDDFNP,ACDCOMC,ACDN0
