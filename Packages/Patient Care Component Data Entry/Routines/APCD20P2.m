APCD20P2 ;IHS/CMI/LAB - [ 01/08/04  10:42 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**2**;MAR 09, 1999
 ;
 ;
 D EL,REF,BM,GHS
 D ^XBFMK
 Q
EL ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","EL"))
 S X="EL",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD EL];.06///Elder Care;.07///0;.08///1;.09///9000010.35"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding EL mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
REF ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","REF"))
 S X="REF",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD REF];.06///Refusal for Service;.07///0;.08///0;.09///9000022"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding REF mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
BM ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","BM"))
 S X="BM",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".02///S;.03///9000001;.04///[APCD BM];.06///Birth Measurement;.07///0;.08///0;.09///9000024"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding BM mnemonic failed." H 4
 K DIC,DD,D0,DO
GHS ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","GHS"))
 S X="GHS",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".02///S;.03///9000001;.04///[APCD GHS];.06///Generate Health Summary;.07///0;.08///0"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding GHS mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
