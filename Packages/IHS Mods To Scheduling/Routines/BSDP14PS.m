BSDP14PS ;ihs/cmi/maw - PIMS Patch 1014 post init
 ;;5.3;IHS Scheduling;**1014**;Feb 15, 2012
 Q
 ;
POST ;-- post init
 N BDA
 S BDA=0 F  S BDA=$O(^DPT(BDA)) Q:'BDA  D
 . S DA(1)=BDA
 . S DIK="^DPT(DA(1),""S"",",DIK(1)=.01 D ENALL^DIK
 K DIK,DA
 Q
 ;
