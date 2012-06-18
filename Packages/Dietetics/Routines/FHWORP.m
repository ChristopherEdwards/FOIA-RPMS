FHWORP ; HISC/NCA - Order Entry 3 Data Conversion ;7/1/97  16:45
 ;;5.0;Dietetics;**6**;Oct 11, 1995
 I +$$VERSION^XPDUTL("OR")'=3 Q
 Q:'$D(^OR(100,0))  D NOW^%DTC S FHNOW=%
Q1 ; Process Converting Active Dietetics Orders
 F FHW1=0:0 S FHW1=$O(^FHPT("AW",FHW1)) Q:FHW1<1  F DFN=0:0 S DFN=$O(^FHPT("AW",FHW1,DFN)) Q:DFN<1  S ADM=$G(^(DFN)) D CVT
EXIT G KIL
CVT ; Start Converting the OE/RR Data
 Q:'$D(^FHPT(DFN,"A",ADM,0))
 S FHX1=$G(^FHPT(DFN,"A",ADM,0))
 S FHORD=$P(FHX1,"^",2) D:FHORD DO
 S TF=$P(FHX1,"^",4) D:TF TF
 S IS=$P(FHX1,"^",10) D:IS IS
 F FHAO=0:0 S FHAO=$O(^FHPT("AOO",DFN,ADM,FHAO)) Q:FHAO<1  S Y=$G(^FHPT(DFN,"A",ADM,"OO",FHAO,0)) D AO
 K N F EL=FHNOW:0 S EL=$O(^FHPT(DFN,"A",ADM,"EL",EL)) Q:EL<1  S Y=$G(^(EL,0)),FHORN=$P(Y,"^",7) I FHORN S:'$D(N(FHORN)) N(FHORN)=""
 F FHORN=0:0 S FHORN=$O(N(FHORN)) Q:FHORN<1  D EL
 Q
AO ; Convert Additional Orders
 S FHORN=$P(Y,"^",8) Q:'FHORN
 S VAL=$G(^OR(100,FHORN,4)),VAL1="" Q:VAL=""!($E(VAL,1)="A")  D VAL(VAL,.VAL1)
 S DATA="A;"_VAL1
 D FH^ORCONV3(FHORN,DATA)
 Q
DO ; Convert Current Diet Order or NPO
 S FHORN=$P($G(^FHPT(DFN,"A",ADM,"DI",FHORD,0)),"^",14) Q:'FHORN
 S TYP=$P($G(^FHPT(DFN,"A",ADM,"DI",FHORD,0)),"^",7) I 'TYP!(TYP="N") D DO1
 S SDT=$P($G(^FHPT(DFN,"A",ADM,"DI",FHORD,0)),"^",9)
 F FHKK=SDT:0 S FHKK=$O(^FHPT(DFN,"A",ADM,"AC",FHKK)) Q:FHKK<1  S Y=$G(^(FHKK,0)),FHORD=$P(Y,"^",2) D DO1
 Q
DO1 S FHORN=$P($G(^FHPT(DFN,"A",ADM,"DI",FHORD,0)),"^",14) Q:'FHORN
 S VAL=$G(^OR(100,FHORN,4)),VAL1="" Q:VAL=""!($E(VAL,1)="D")!($E(VAL,1)="N")  D VAL(VAL,.VAL1)
 S DATA=$S(TYP="N":"N;",1:"D;")_VAL1
 D FH^ORCONV3(FHORN,DATA)
 Q
EL ; Convert Early/Late Tray
 S VAL=$G(^OR(100,FHORN,4)),VAL1="" Q:VAL=""!($E(VAL,1)="E")  D VAL(VAL,.VAL1)
 S DATA="E;"_VAL1
 D FH^ORCONV3(FHORN,DATA)
 Q
TF ; Convert Current Tubefeeding
 S FHORN=$P($G(^FHPT(DFN,"A",ADM,"TF",TF,0)),"^",14) Q:'FHORN
 S VAL=$G(^OR(100,FHORN,4)),VAL1="" Q:VAL=""!($E(VAL,1)="T")  D VAL(VAL,.VAL1)
 S DATA="T;"_VAL1
 D FH^ORCONV3(FHORN,DATA)
 Q
IS ; Convert Isolation/Precaution
 S FHORN=$P(FHX1,"^",13) Q:'FHORN
 S VAL=$G(^OR(100,FHORN,4)),VAL1="" Q:VAL=""!($E(VAL,1)="I")  D VAL(VAL,.VAL1)
 S DATA="I;"_VAL1
 D FH^ORCONV3(FHORN,DATA)
 Q
KIL K %,%DT,ADM,DFN,DATA,EL,FHAO,FHNOW,FHORD,FHORN,FHVAL,FHW1,FHX1,IS,FHKK,N,SDT,TF,TYP,VAL,VAL1,X4,XX,Y
 Q
VAL(VAL,FHVAL) ; Translate all up arrows to semicolons
 S FHVAL=$TR(VAL,"^",";")
 Q
