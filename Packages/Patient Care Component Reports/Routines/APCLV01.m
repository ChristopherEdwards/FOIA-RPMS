APCLV01 ; IHS/CMI/LAB - provider functions ;
 ;;2.0;IHS PCC SUITE;**4**;MAY 14, 2009
 ;
MEAS ;EP
 NEW Z,C,%,S
 S (C,Y)=0 F  S Y=$O(^AUPNVMSR("AD",V,Y)) Q:Y'=+Y   I '$P($G(^AUPNVMSR(Y,2)),U,1) S C=C+1 S APCLV(C)="" D
 .I F=99 D  Q
 ..F I=1:1 S S=$T(@I) Q:S=""  S %="" D @I S $P(APCLV(C),U,I)=%
 .I F[";" D  Q
 ..F J=1:1 S I=$P(F,";",J) Q:I=""  I I'=99 S %="" D @I S $P(APCLV(C),U,J)=%
 .S %="",I=F D @I S $P(APCLV(C),U)=%
 .Q
 Q
1 ;
 S %=$$VD^APCLV($P(^AUPNVMSR(Y,0),U,3),"I")
 Q
2 ;
 S %=$$VD^APCLV($P(^AUPNVMSR(Y,0),U,3),"S")
 Q
3 ;
 S %=$P(^AUPNVMSR(Y,0),U,2)
 Q
4 ;
 S %=$$PATIENT^APCLV($P(^AUPNVMSR(Y,0),U,3),"E")
 Q
5 ;
 S %=$P(^AUPNVMSR(Y,0),U)
 Q
 S %=$$PATIENT^APCLV($P(^AUPNVMSR(Y,0),U,3),"E")
 Q
6 ;
 S %=$P(^AUTTMSR($P(^AUPNVMSR(Y,0),U),0),U,2)
 Q
7 ;
 S %=$P(^AUTTMSR($P(^AUPNVMSR(Y,0),U),0),U)
 Q
8 ;
 S %=$P(^AUPNVMSR(Y,0),U,4)
 Q
9 ;
 S %=$P(^AUTTMSR($P(^AUPNVMSR(Y,0),U),0),U,11)
 Q
 ;
