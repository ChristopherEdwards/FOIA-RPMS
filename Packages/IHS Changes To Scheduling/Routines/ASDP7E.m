ASDP7E ; IHS/ANMC/LJF - PATCH 7 CALLS; [ 12/01/2000  9:46 AM ]
 ;;5.0;IHS SCHEDULING;**7,8**;MAR 25, 1999
 ;IHS/ITSC/KMS, 25-Apr-2003 - Patch 8 - added ";" in comment line 1, above, before 5.0 for SAC Compliancy
 ;
ENV ;EP; environment check called by patch 7 kids build
 I $T(VCN^AUPNVSIT)="" D  Q
 . S XPDQUIT=2        ;abort install; save global
 . W !!,"AUPN patch #4 not installed; required for MAS patch 7.",!
 W !!,"ENVIRONMENT CHECK OKAY.",!
 Q
